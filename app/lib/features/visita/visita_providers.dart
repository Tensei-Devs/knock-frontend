import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/visita/data/acciones_visita_repository_api.dart';
import 'package:app/features/visita/data/agenda_repository_api.dart';
import 'package:app/features/visita/data/precio_de_visita_repository_api.dart';
import 'package:app/features/visita/domain/acciones_visita.dart';
import 'package:app/features/visita/domain/agenda.dart';
import 'package:app/features/visita/domain/precio_de_visita.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Acciones de la visita (spec 040). La maqueta lo usa solo con sesión y API.
final accionesVisitaRepositoryProvider = Provider<AccionesVisitaRepository>(
  (ref) => AccionesVisitaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// Cotización final y ajustes de precio (spec 039).
final precioDeVisitaRepositoryProvider = Provider<PrecioDeVisitaRepository>(
  (ref) => PrecioDeVisitaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

final agendaRepositoryProvider = Provider<AgendaRepository>(
  (ref) => AgendaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
