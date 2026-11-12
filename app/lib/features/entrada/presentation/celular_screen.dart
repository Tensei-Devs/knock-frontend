import 'package:app/core/config/aviso_de_privacidad.dart';
import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/colores.dart';
import 'package:app/features/entrada/domain/validacion_entrada.dart';
import 'package:app/features/entrada/presentation/entrada_controller.dart';
import 'package:app/features/entrada/presentation/mensaje_de_error.dart';
import 'package:app/features/entrada/presentation/widgets/marco_de_entrada.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Entra con tu celular» (`/entrar`, HU-001; conectada en KNOCK-228).
///
/// Pide 10 dígitos con el prefijo fijo +52 y la aceptación del aviso de
/// privacidad; «Continuar» pide el SMS a Firebase. Estados: formulario
/// (datos), cargando (botón con indicador) y error con su mensaje del ARB
/// (se reintenta con el mismo botón). No hay estado vacío. El celular pasa a
/// la pantalla del código en memoria y no se guarda ni se registra.
class CelularScreen extends ConsumerStatefulWidget {
  const CelularScreen({super.key});

  @override
  ConsumerState<CelularScreen> createState() => _CelularScreenState();
}

class _CelularScreenState extends ConsumerState<CelularScreen> {
  final _celular = TextEditingController();
  bool _aceptado = false;
  bool _errorCelular = false;
  bool _errorAviso = false;

  @override
  void dispose() {
    _celular.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    final celular = _celular.text;
    setState(() {
      _errorCelular = !esCelularValido(celular);
      _errorAviso = !_aceptado;
    });
    if (_errorCelular || _errorAviso) {
      return;
    }
    FocusScope.of(context).unfocus();
    final enviado = await ref
        .read(entradaControllerProvider.notifier)
        .enviarCodigo(celular);
    if (enviado && mounted) {
      context.go(Rutas.codigo, extra: celular);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final entrada = ref.watch(entradaControllerProvider);
    final error = entrada.error;

    return MarcoDeEntrada(
      titulo: textos.entradaCelularTitulo,
      detalle: textos.entradaCelularDetalle,
      formulario: [
        TextField(
          controller: _celular,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.telephoneNumberNational],
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(digitosDeCelular),
          ],
          style: tema.textTheme.titleMedium?.copyWith(letterSpacing: 1.2),
          decoration: decoracionDeEntrada(
            etiqueta: textos.entradaCelularEtiqueta,
            ayuda: textos.entradaCelularAyuda,
            error: _errorCelular ? textos.entradaCelularError : null,
            prefijo: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
              child: Align(
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  textos.entradaPrefijoPais,
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          onChanged: (_) {
            if (_errorCelular) setState(() => _errorCelular = false);
            ref.read(entradaControllerProvider.notifier).limpiarError();
          },
          onSubmitted: (_) => _continuar(),
        ),
        const SizedBox(height: 12),
        _CasillaDelAviso(
          aceptado: _aceptado,
          error: _errorAviso,
          onChanged: (valor) => setState(() {
            _aceptado = valor;
            if (valor) _errorAviso = false;
          }),
        ),
        const SizedBox(height: 16),
        BotonPrincipalDeEntrada(
          texto: textos.entradaContinuar,
          etiquetaCargando: textos.entradaCargando,
          cargando: entrada.cargando,
          onPressed: _continuar,
        ),
        if (error != null)
          MensajeDeErrorDeEntrada(mensajeDeErrorDeEntrada(textos, error)),
      ],
    );
  }
}

/// «Acepto el aviso de privacidad», con el aviso como enlace (spec 028).
///
/// Tocar el texto del aviso lo abre en el navegador y **no** cambia la casilla;
/// tocar el resto de la fila marca o desmarca. Si el teléfono no puede abrir la
/// página sale un mensaje breve y la pantalla no cambia (R-03).
class _CasillaDelAviso extends ConsumerStatefulWidget {
  const _CasillaDelAviso({
    required this.aceptado,
    required this.error,
    required this.onChanged,
  });

  final bool aceptado;
  final bool error;
  final ValueChanged<bool> onChanged;

  @override
  ConsumerState<_CasillaDelAviso> createState() => _CasillaDelAvisoState();
}

class _CasillaDelAvisoState extends ConsumerState<_CasillaDelAviso> {
  late final TapGestureRecognizer _alTocarElAviso = TapGestureRecognizer()
    ..onTap = _abrirElAviso;

  @override
  void dispose() {
    _alTocarElAviso.dispose();
    super.dispose();
  }

  Future<void> _abrirElAviso() async {
    // Se toman antes del `await`: el mensaje sale aunque la pantalla cambie.
    final mensajero = ScaffoldMessenger.of(context);
    final mensaje = AppLocalizations.of(context).entradaAvisoNoSeAbrio;
    final abierto = await ref
        .read(abridorDeEnlacesProvider)
        .abrir(urlDelAvisoDePrivacidad);
    if (!abierto) {
      mensajero.showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    final colorEnlace = esquema.brightness == Brightness.light
        ? ColoresClaro.amberInk
        : esquema.primary;

    final aviso = textos.entradaAvisoPrivacidad;
    final completo = textos.entradaAceptoAviso(aviso);
    final inicio = completo.indexOf(aviso);
    final texto = inicio < 0
        ? TextSpan(text: completo)
        : TextSpan(
            children: [
              TextSpan(text: completo.substring(0, inicio)),
              TextSpan(
                text: aviso,
                recognizer: _alTocarElAviso,
                style: TextStyle(
                  color: colorEnlace,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationColor: colorEnlace,
                ),
              ),
              TextSpan(text: completo.substring(inicio + aviso.length)),
            ],
          );

    return CheckboxListTile(
      value: widget.aceptado,
      onChanged: (valor) => widget.onChanged(valor ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      isError: widget.error,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radios.medio),
      ),
      title: Text.rich(texto, style: tema.textTheme.bodyLarge),
      subtitle: widget.error
          ? Text(
              textos.entradaAvisoError,
              style: tema.textTheme.bodyMedium?.copyWith(color: esquema.error),
            )
          : null,
    );
  }
}
