import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/trabajo/cotizar_providers.dart';
import 'package:app/features/trabajo/domain/cotizar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Una lista del técnico por páginas. Sin sesión no pide nada.
abstract class ListaDelTecnicoController<P> extends AsyncNotifier<P>
    with PaginasPorCursor<P> {
  P get vacia;

  Future<P> pedir(CotizarRepository repo, String? cursor);

  @override
  Future<P> build() async {
    if (!ref.watch(sesionProvider.select((t) => t != null))) return vacia;
    return pedir(ref.watch(cotizarRepositoryProvider), null);
  }

  void reintentar() => ref.invalidateSelf();

  @override
  Future<P> pedirPagina(String cursor) =>
      pedir(ref.read(cotizarRepositoryProvider), cursor);
}

/// «Solicitudes nuevas» del técnico.
class SolicitudesRecibidasController
    extends ListaDelTecnicoController<PaginaDeSolicitudes> {
  final _retiradas = <String>{};

  @override
  Future<PaginaDeSolicitudes> build() {
    _retiradas.clear();
    return super.build();
  }

  @override
  PaginaDeSolicitudes get vacia => const PaginaDeSolicitudes([], null);

  @override
  Future<PaginaDeSolicitudes> pedir(CotizarRepository repo, String? cursor) =>
      repo.recibidas(cursor: cursor);

  @override
  String? cursorDe(PaginaDeSolicitudes pagina) => pagina.siguiente;

  void retirar(String solicitudId) {
    _retiradas.add(solicitudId);
    final actual = state.value;
    if (actual != null) {
      state = AsyncData(
        PaginaDeSolicitudes(_visibles(actual.items), actual.siguiente),
      );
    }
  }

  List<SolicitudRecibida> _visibles(List<SolicitudRecibida> solicitudes) => [
    for (final solicitud in solicitudes)
      if (!_retiradas.contains(solicitud.solicitudId)) solicitud,
  ];

  @override
  PaginaDeSolicitudes unirPaginas(
    PaginaDeSolicitudes actual,
    PaginaDeSolicitudes siguiente,
  ) => PaginaDeSolicitudes(
    _visibles(
      unirSinRepetir(actual.items, siguiente.items, (s) => s.solicitudId),
    ),
    siguiente.siguiente,
  );
}

final solicitudesRecibidasProvider =
    AsyncNotifierProvider.autoDispose<
      SolicitudesRecibidasController,
      PaginaDeSolicitudes
    >(SolicitudesRecibidasController.new, retry: (_, _) => null);

/// «Cotizaciones enviadas» (spec 038).
class CotizacionesEnviadasController
    extends ListaDelTecnicoController<PaginaDeCotizaciones> {
  @override
  PaginaDeCotizaciones get vacia => const PaginaDeCotizaciones([], null);

  @override
  Future<PaginaDeCotizaciones> pedir(CotizarRepository repo, String? cursor) =>
      repo.enviadas(cursor: cursor);

  @override
  String? cursorDe(PaginaDeCotizaciones pagina) => pagina.siguiente;

  @override
  PaginaDeCotizaciones unirPaginas(
    PaginaDeCotizaciones actual,
    PaginaDeCotizaciones siguiente,
  ) => PaginaDeCotizaciones(
    unirSinRepetir(actual.items, siguiente.items, (c) => c.id),
    siguiente.siguiente,
  );
}

final cotizacionesEnviadasProvider =
    AsyncNotifierProvider.autoDispose<
      CotizacionesEnviadasController,
      PaginaDeCotizaciones
    >(CotizacionesEnviadasController.new, retry: (_, _) => null);

/// El detalle que se va a cotizar; solo vive mientras la pantalla está abierta.
final solicitudParaCotizarProvider = FutureProvider.autoDispose
    .family<SolicitudParaCotizar, String>((ref, id) {
      ref.watch(sesionProvider.select((t) => t != null));
      return ref.watch(cotizarRepositoryProvider).solicitud(id);
    }, retry: (_, _) => null);
