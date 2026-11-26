import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/reportes/data/reportes_repository_api.dart';
import 'package:app/features/reportes/domain/reporte.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ReportesRepositoryApi _api(Ref ref) => ReportesRepositoryApi(
  transporte: ref.watch(transporteApiProvider),
  url: ref.watch(urlApiProvider),
);

/// Reportes (spec 033). La maqueta lo usa solo con sesión y API.
final reportesRepositoryProvider = Provider<ReportesRepository>(_api);

/// Bloqueos (spec 033): el chat de una visita real y «Personas bloqueadas».
final bloqueosRepositoryProvider = Provider<BloqueosRepository>(_api);
