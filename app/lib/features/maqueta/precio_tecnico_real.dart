import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/envio_de_visita.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/visita/visita.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «Enviar cotización final» y «Proponer otro precio» de una visita en curso
/// (spec 039, CA-03, CA-09 y CA-17). El servidor decide si se permiten.
class PrecioTecnicoReal extends StatelessWidget {
  const PrecioTecnicoReal({super.key, required this.visitaId});

  final String visitaId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return stack([
      BtnK(
        textos.precioFinalBoton,
        () => _abrir(context, _HojaCotizacionFinal(visitaId: visitaId)),
        kind: Bk.sec,
        sm: true,
      ),
      BtnK(
        textos.precioAjusteBoton,
        () => _abrir(context, _HojaAjuste(visitaId: visitaId)),
        kind: Bk.sec,
        sm: true,
      ),
    ], gap: 12);
  }

  void _abrir(BuildContext context, Widget contenido) =>
      unawaited(hoja<void>(context, (_, _) => contenido));
}

/// Un envío a la vez; un error deja intacto lo escrito.
class _HojaCotizacionFinal extends ConsumerStatefulWidget {
  const _HojaCotizacionFinal({required this.visitaId});

  final String visitaId;

  @override
  ConsumerState<_HojaCotizacionFinal> createState() => _FinalState();
}

class _FinalState extends ConsumerState<_HojaCotizacionFinal>
    with EnvioDeVisita {
  final _monto = TextEditingController();
  final _descripcion = TextEditingController();

  @override
  void dispose() {
    _monto.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _enviar(int precio) async {
    final textos = AppLocalizations.of(context);
    final bien = await enviarUnaVez(
      textos.precioFinalNoPermitida,
      () => ref
          .read(precioTecnicoRepositoryProvider)
          .enviarFinal(
            widget.visitaId,
            precio: precio,
            descripcion: _descripcion.text.trim(),
          ),
    );
    if (!bien || !mounted) return;
    Navigator.pop(context);
    maq.toast(textos.precioFinalEnviada);
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final precio = ReglasDePrecioTecnico.pesos(_monto.text);
    final largo = _descripcion.text.trim().length;
    VoidCallback? enviar;
    if (!enviando &&
        precio != null &&
        largo >= ReglasDePrecioTecnico.descripcionMinima) {
      enviar = () => _enviar(precio);
    }
    return stack([
      sheetH(context, textos.precioFinalBoton),
      sMut(textos.precioFinalExplicacion),
      FieldK(
        label: textos.precioFinalMonto,
        help: textos.precioMontoAyuda,
        c: _monto,
        keyboard: TextInputType.number,
        onChanged: (_) => setState(() {}),
      ),
      FieldK(
        label: textos.precioFinalDescripcion,
        help: textos.precioDescripcionAyuda,
        c: _descripcion,
        lines: 3,
        maxLen: ReglasDePrecioTecnico.descripcionMaxima,
        onChanged: (_) => setState(() {}),
      ),
      if (errorDeEnvio case final error?) NoteK('red', 'help', error),
      BtnK(enviando ? textos.visitaEnviando : textos.precioFinalEnviar, enviar),
    ]);
  }
}

/// El ajuste necesita la cotización aceptada: carga, error, vacío y datos.
class _HojaAjuste extends ConsumerStatefulWidget {
  const _HojaAjuste({required this.visitaId});

  final String visitaId;

  @override
  ConsumerState<_HojaAjuste> createState() => _AjusteState();
}

class _AjusteState extends ConsumerState<_HojaAjuste> with EnvioDeVisita {
  final _monto = TextEditingController();
  final _motivo = TextEditingController();

  @override
  void dispose() {
    _monto.dispose();
    _motivo.dispose();
    super.dispose();
  }

  Future<void> _enviar(String cotizacionId, int monto) async {
    final textos = AppLocalizations.of(context);
    final bien = await enviarUnaVez(
      textos.precioAjusteNoPermitido,
      () => ref
          .read(precioTecnicoRepositoryProvider)
          .proponerAjuste(
            cotizacionId,
            montoNuevo: monto,
            motivo: _motivo.text.trim(),
          ),
      propio: (falla) => switch (falla) {
        ContenidoRechazadoFailure() => textos.precioAjusteMotivoRechazado,
        ModeracionNoDisponibleFailure() => textos.precioAjusteSinRevision,
        _ => null,
      },
    );
    if (!bien || !mounted) return;
    Navigator.pop(context);
    maq.toast(textos.precioAjusteEnviado);
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final proveedor = cotizacionAceptadaProvider(widget.visitaId);
    return stack([
      sheetH(context, textos.precioAjusteBoton),
      ref
          .watch(proveedor)
          .when(
            skipLoadingOnRefresh: false,
            loading: () => sMut(textos.precioAjusteCargando),
            error: (error, _) => ErrorDeCargaDeVisita(
              error: error,
              alReintentar: () => ref.invalidate(proveedor),
            ),
            data: (cotizacion) => cotizacion == null
                ? NoteK('amber', 'help', textos.precioAjusteSinCotizacion)
                : _formulario(textos, cotizacion),
          ),
    ]);
  }

  Widget _formulario(AppLocalizations textos, CotizacionAceptada cotizacion) {
    final monto = ReglasDePrecioTecnico.pesos(_monto.text);
    final largo = _motivo.text.trim().length;
    VoidCallback? enviar;
    if (!enviando &&
        monto != null &&
        monto >= cotizacion.ajusteMinimo &&
        largo >= ReglasDePrecioTecnico.motivoMinimo) {
      enviar = () => _enviar(cotizacion.id, monto);
    }
    return stack([
      FieldK(
        label: textos.precioAjusteMonto,
        help: textos.precioAjusteMinimo(cotizacion.ajusteMinimo),
        c: _monto,
        keyboard: TextInputType.number,
        onChanged: (_) => setState(() {}),
      ),
      FieldK(
        label: textos.precioAjusteMotivo,
        help: textos.precioAjusteMotivoAyuda,
        c: _motivo,
        lines: 3,
        maxLen: ReglasDePrecioTecnico.motivoMaximo,
        onChanged: (_) => setState(() {}),
      ),
      if (errorDeEnvio case final error?) NoteK('red', 'help', error),
      BtnK(
        enviando ? textos.visitaEnviando : textos.precioAjusteEnviar,
        enviar,
      ),
    ]);
  }
}
