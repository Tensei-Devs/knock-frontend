import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/visita/data/acciones_visita_repository_api.dart';
import 'package:app/features/visita/data/agenda_repository_api.dart';
import 'package:app/features/visita/data/permiso_fotos_repository_api.dart';
import 'package:app/features/visita/data/precio_de_visita_repository_api.dart';
import 'package:app/features/visita/data/precio_tecnico_repository_api.dart';
import 'package:app/features/visita/domain/acciones_visita.dart';
import 'package:app/features/visita/domain/agenda.dart';
import 'package:app/features/visita/domain/permiso_fotos.dart';
import 'package:app/features/visita/domain/precio_de_visita.dart';
import 'package:app/features/visita/domain/precio_tecnico.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Acciones de la visita (spec 040). La maqueta lo usa solo con sesión y API.
final accionesVisitaRepositoryProvider = Provider<AccionesVisitaRepository>(
  (ref) => AccionesVisitaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// Lo que el técnico propone sobre el precio (spec 039).
final precioTecnicoRepositoryProvider = Provider<PrecioTecnicoRepository>(
  (ref) => PrecioTecnicoRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// La cotización aceptada de una visita. Sin reintento automático.
final cotizacionAceptadaProvider = FutureProvider.autoDispose
    .family<CotizacionAceptada?, String>(
      _pedirCotizacionAceptada,
      retry: (_, _) => null,
    );

Future<CotizacionAceptada?> _pedirCotizacionAceptada(Ref ref, String visitaId) {
  return ref
      .watch(precioTecnicoRepositoryProvider)
      .cotizacionAceptada(visitaId);
}

/// Cotización final y ajustes de precio (spec 039).
final precioDeVisitaRepositoryProvider = Provider<PrecioDeVisitaRepository>(
  (ref) => PrecioDeVisitaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// Permiso de fotos del cliente (spec 040).
final permisoFotosRepositoryProvider = Provider<PermisoFotosRepository>(
  (ref) => PermisoFotosRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// Sin reintento automático.
final permisoDeFotosProvider = FutureProvider.autoDispose
    .family<PermisoDeFotos, String>(_pedirPermiso, retry: (_, _) => null);

Future<PermisoDeFotos> _pedirPermiso(Ref ref, String visitaId) {
  return ref.watch(permisoFotosRepositoryProvider).consultar(visitaId);
}

final agendaRepositoryProvider = Provider<AgendaRepository>(
  (ref) => AgendaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
