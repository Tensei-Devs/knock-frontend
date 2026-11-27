import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/lista_paginada_real.dart';
import 'package:app/features/maqueta/rutas_tecnico.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// El precio de una cotización propia, según su tipo.
String precioDeCotizacion(AppLocalizations t, CotizacionPropia c) {
  final tipo = t.cotizarTipo(c.tipoPrecio);
  final min = c.precioMin;
  final max = c.precioMax;
  if (min != null && max != null) return '$tipo · ${t.cotizarRango(min, max)}';
  return '$tipo · ${t.cotizarMonto(c.precio ?? c.tope)}';
}

/// Una cotización propia (spec 038 y 046, §13).
class TarjetaDeCotizacionPropia extends StatelessWidget {
  const TarjetaDeCotizacionPropia(this.cotizacion, {super.key});

  final CotizacionPropia cotizacion;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return CardK(
      child: stack([
        bT(precioDeCotizacion(t, cotizacion)),
        sMut('${fechaLegible(context, cotizacion.dia)} · ${cotizacion.hora}'),
        sMut(t.cotizarTope(cotizacion.tope)),
        sMut(t.cotizarEstado(cotizacion.estado)),
      ], gap: 4),
    );
  }
}

String _errorDeTrabajo(AppLocalizations t, Object error) => switch (error) {
  ServicioNoDisponibleFailure() => t.errorSinConexion,
  SinPerfilTecnicoFailure() => t.cotizarSinPerfil,
  AccesoDenegadoFailure() => t.errorAccesoDenegado,
  DemasiadosIntentosFailure() => t.errorDemasiadosIntentos,
  _ => t.errorInesperado,
};

/// «Solicitudes nuevas» (spec 019), la entrada a cotizar (spec 046, §13).
class SolicitudesNuevasReal extends ListaPaginadaReal<PaginaDeSolicitudes> {
  const SolicitudesNuevasReal({super.key});

  @override
  TextosDeLista textosDeLista(AppLocalizations t) => (
    titulo: t.cotizarNuevas,
    cargando: t.cotizarCargando,
    error: t.errorInesperado,
    vacio: t.cotizarNuevasVacio,
  );

  @override
  String textoDeError(AppLocalizations t, Object error) =>
      _errorDeTrabajo(t, error);

  @override
  AsyncValue<PaginaDeSolicitudes> observar(WidgetRef ref) =>
      ref.watch(solicitudesRecibidasProvider);

  @override
  List<Widget> filas(PaginaDeSolicitudes pagina) => [
    for (final s in pagina.items) _TarjetaDeSolicitud(s),
  ];

  @override
  bool hayMas(PaginaDeSolicitudes pagina) => pagina.siguiente != null;

  @override
  void reintentar(WidgetRef ref) =>
      ref.read(solicitudesRecibidasProvider.notifier).reintentar();

  @override
  Future<Failure?> cargarMas(WidgetRef ref) =>
      ref.read(solicitudesRecibidasProvider.notifier).cargarMas();
}

class _TarjetaDeSolicitud extends StatelessWidget {
  const _TarjetaDeSolicitud(this.solicitud);

  final SolicitudRecibida solicitud;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return CardK(
      child: stack([
        bT('${solicitud.oficio} · ${solicitud.colonia}'),
        T(solicitud.descripcion),
        sMut(
          t.cotizarCuando(
            fechaLegible(context, solicitud.dia),
            t.cotizarFranja(solicitud.franja),
          ),
        ),
        BtnK(
          solicitud.yaCotizo ? t.cotizarVerPropia : t.cotizarVer,
          () => context.push(RT.cotizar(solicitud.solicitudId)),
          kind: Bk.sec,
        ),
      ], gap: 6),
    );
  }
}

/// «Cotizaciones enviadas» (spec 038, CA-08 a CA-11 y CA-14).
class CotizacionesEnviadasReal extends ListaPaginadaReal<PaginaDeCotizaciones> {
  const CotizacionesEnviadasReal({super.key});

  @override
  TextosDeLista textosDeLista(AppLocalizations t) => (
    titulo: t.cotizarEnviadas,
    cargando: t.cotizarCargando,
    error: t.errorInesperado,
    vacio: t.cotizarEnviadasVacio,
  );

  @override
  String textoDeError(AppLocalizations t, Object error) =>
      _errorDeTrabajo(t, error);

  @override
  AsyncValue<PaginaDeCotizaciones> observar(WidgetRef ref) =>
      ref.watch(cotizacionesEnviadasProvider);

  @override
  List<Widget> filas(PaginaDeCotizaciones pagina) => [
    for (final c in pagina.items) TarjetaDeCotizacionPropia(c),
  ];

  @override
  bool hayMas(PaginaDeCotizaciones pagina) => pagina.siguiente != null;

  @override
  void reintentar(WidgetRef ref) =>
      ref.read(cotizacionesEnviadasProvider.notifier).reintentar();

  @override
  Future<Failure?> cargarMas(WidgetRef ref) =>
      ref.read(cotizacionesEnviadasProvider.notifier).cargarMas();
}
