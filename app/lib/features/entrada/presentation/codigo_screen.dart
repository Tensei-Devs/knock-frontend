import 'package:app/core/router/rutas.dart';
import 'package:app/features/entrada/domain/validacion_entrada.dart';
import 'package:app/features/entrada/presentation/cuenta_regresiva_controller.dart';
import 'package:app/features/entrada/presentation/entrada_controller.dart';
import 'package:app/features/entrada/presentation/mensaje_de_error.dart';
import 'package:app/features/entrada/presentation/widgets/marco_de_entrada.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Escribe el código» (`/entrar/codigo`, HU-001; conectada en KNOCK-228).
///
/// Con 6 dígitos «Entrar» verifica el código con Firebase, canjea el ID token
/// en `POST /api/v1/auth/firebase` con el cliente generado y guarda los
/// tokens en almacenamiento seguro; entonces el router lleva a Inicio.
/// Estados: formulario, cargando y error (mensaje del ARB; se reintenta).
/// El código no se guarda ni se registra.
class CodigoScreen extends ConsumerStatefulWidget {
  const CodigoScreen({required this.celular, super.key});

  /// Los 10 dígitos que se escribieron en la pantalla anterior.
  final String celular;

  @override
  ConsumerState<CodigoScreen> createState() => _CodigoScreenState();
}

class _CodigoScreenState extends ConsumerState<CodigoScreen> {
  final _codigo = TextEditingController();
  bool _error = false;

  @override
  void dispose() {
    _codigo.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!esCodigoValido(_codigo.text)) {
      setState(() => _error = true);
      return;
    }
    FocusScope.of(context).unfocus();
    await ref.read(entradaControllerProvider.notifier).verificar(_codigo.text);
  }

  Future<void> _reenviar() async {
    final enviado = await ref
        .read(entradaControllerProvider.notifier)
        .reenviar();
    if (enviado && mounted) {
      ref.read(cuentaRegresivaProvider.notifier).reiniciar();
    }
  }

  void _cambiarNumero() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Rutas.entrar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final segundos = ref.watch(cuentaRegresivaProvider);
    final entrada = ref.watch(entradaControllerProvider);
    final errorDeEntrada = entrada.error;

    return MarcoDeEntrada(
      titulo: textos.entradaCodigoTitulo,
      detalle: textos.entradaCodigoEnviadoA(formatearCelular(widget.celular)),
      formulario: [
        TextField(
          controller: _codigo,
          autofocus: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.center,
          autofillHints: const [AutofillHints.oneTimeCode],
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(digitosDeCodigo),
          ],
          style: tema.textTheme.headlineSmall?.copyWith(letterSpacing: 8),
          decoration: decoracionDeEntrada(
            etiqueta: textos.entradaCodigoEtiqueta,
            error: _error ? textos.entradaCodigoError : null,
          ),
          onChanged: (_) {
            if (_error) setState(() => _error = false);
            ref.read(entradaControllerProvider.notifier).limpiarError();
          },
          onSubmitted: (_) => _entrar(),
        ),
        const SizedBox(height: 20),
        BotonPrincipalDeEntrada(
          texto: textos.entradaEntrar,
          etiquetaCargando: textos.entradaCargando,
          cargando: entrada.cargando,
          onPressed: _entrar,
        ),
        if (errorDeEntrada != null)
          MensajeDeErrorDeEntrada(
            mensajeDeErrorDeEntrada(textos, errorDeEntrada),
          ),
      ],
      pie: [
        if (segundos > 0)
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Center(
              child: Text(
                textos.entradaReenviarEn(segundos),
                textAlign: TextAlign.center,
                style: tema.textTheme.bodyLarge?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          TextButton(
            onPressed: entrada.cargando ? null : _reenviar,
            child: Text(textos.entradaReenviarCodigo),
          ),
        TextButton(
          onPressed: _cambiarNumero,
          child: Text(textos.entradaCambiarNumero),
        ),
      ],
    );
  }
}
