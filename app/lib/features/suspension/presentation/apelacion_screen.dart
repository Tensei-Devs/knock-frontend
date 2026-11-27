import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/entrada/entrada.dart';
import 'package:app/features/suspension/domain/apelacion_suspension.dart';
import 'package:app/features/suspension/presentation/apelacion_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Apelar la suspensión» (`/entrar/apelacion`, spec 033, enmienda del
/// 2026-11-26): se verifica el número por SMS, sin abrir sesión, y se consulta
/// o se presenta la apelación. Nada se guarda en el teléfono.
class ApelacionScreen extends ConsumerStatefulWidget {
  const ApelacionScreen({super.key});

  @override
  ConsumerState<ApelacionScreen> createState() => _ApelacionScreenState();
}

class _ApelacionScreenState extends ConsumerState<ApelacionScreen> {
  final _celular = TextEditingController();
  final _codigo = TextEditingController();
  final _texto = TextEditingController();
  bool _invalido = false;

  @override
  void dispose() {
    for (final c in [_celular, _codigo, _texto]) {
      c.dispose();
    }
    super.dispose();
  }

  void _siValido(bool valido, Future<void> Function() accion) {
    setState(() => _invalido = !valido);
    if (!valido) return;
    FocusScope.of(context).unfocus();
    unawaited(accion());
  }

  Widget _boton(String texto, bool cargando, VoidCallback alTocar) =>
      BotonPrincipalDeEntrada(
        texto: texto,
        etiquetaCargando: AppLocalizations.of(context).entradaCargando,
        cargando: cargando,
        onPressed: alTocar,
      );

  List<Widget> _numero(
    TextEditingController c,
    int digitos,
    String etiqueta,
    String error,
  ) => [
    TextField(
      key: ValueKey(etiqueta),
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(digitos),
      ],
      decoration: decoracionDeEntrada(
        etiqueta: etiqueta,
        error: _invalido ? error : null,
      ),
    ),
    const SizedBox(height: 16),
  ];

  Widget _aviso(String texto) => Semantics(
    liveRegion: true,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(texto),
    ),
  );

  String _fecha(DateTime fecha) =>
      MaterialLocalizations.of(context).formatShortDate(fecha.toLocal());

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final ui = ref.watch(apelacionControllerProvider);
    final control = ref.read(apelacionControllerProvider.notifier);
    final falla = ui.falla;
    final apelacion = ui.apelacion;

    final contenido = switch (ui.paso) {
      PasoDeApelacion.celular => [
        ..._numero(
          _celular,
          digitosDeCelular,
          textos.entradaCelularEtiqueta,
          textos.entradaCelularError,
        ),
        _boton(
          textos.suspensionEnviarCodigo,
          ui.cargando,
          () => _siValido(
            esCelularValido(_celular.text),
            () => control.enviarCodigo(_celular.text),
          ),
        ),
      ],
      PasoDeApelacion.codigo => [
        ..._numero(
          _codigo,
          digitosDeCodigo,
          textos.entradaCodigoEtiqueta,
          textos.entradaCodigoError,
        ),
        _boton(
          textos.suspensionVerificar,
          ui.cargando,
          () => _siValido(
            esCodigoValido(_codigo.text),
            () => control.verificar(_codigo.text),
          ),
        ),
      ],
      PasoDeApelacion.consulta => [
        _boton(
          textos.bloqueosReintentar,
          ui.cargando,
          control.reintentarConsulta,
        ),
      ],
      PasoDeApelacion.formulario => [
        _aviso(textos.suspensionSinConsulta),
        TextField(
          controller: _texto,
          maxLines: 5,
          maxLength: apelacionMaxima,
          decoration: decoracionDeEntrada(
            etiqueta: textos.suspensionTexto,
            ayuda: textos.suspensionTextoAyuda,
            error: _invalido || falla is DatosRechazadosFailure
                ? textos.suspensionTextoAyuda
                : null,
          ),
        ),
        const SizedBox(height: 16),
        _boton(
          textos.suspensionPresentar,
          ui.cargando,
          () => _siValido(
            textoDeApelacionValido(_texto.text),
            () => control.presentar(_texto.text),
          ),
        ),
      ],
      PasoDeApelacion.estado => [
        if (apelacion != null) ...[
          _aviso(textos.suspensionEstado(apelacion.estado)),
          Text(textos.suspensionPresentadaEl(_fecha(apelacion.presentadaEn))),
          if (apelacion.resueltaEn case final resuelta?)
            Text(textos.suspensionResueltaEl(_fecha(resuelta))),
        ],
      ],
      PasoDeApelacion.noDisponible => [_aviso(textos.suspensionNoDisponible)],
      PasoDeApelacion.noPermitida => [_aviso(textos.suspensionNoPermitida)],
    };

    return MarcoDeEntrada(
      titulo: textos.suspensionTitulo,
      detalle: textos.suspensionDetalle,
      formulario: [
        ...contenido,
        if (falla != null)
          MensajeDeErrorDeEntrada(switch (falla) {
            NoAutorizadoFailure() => textos.suspensionVerificarOtraVez,
            DemasiadosIntentosFailure() ||
            DatosRechazadosFailure() => mensajeDeError(textos, falla),
            _ => mensajeDeErrorDeEntrada(textos, falla),
          }),
      ],
      pie: [
        TextButton(
          onPressed: () => context.go(Rutas.entrar),
          child: Text(textos.suspensionVolver),
        ),
      ],
    );
  }
}
