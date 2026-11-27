import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/bandeja_avisos/data/bandeja_avisos_repository_api.dart';
import 'package:app/features/bandeja_avisos/domain/aviso_en_bandeja.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Avisos (spec 034). La maqueta lo usa solo con sesión y API.
final bandejaAvisosRepositoryProvider = Provider<BandejaAvisosRepository>(
  (ref) => BandejaAvisosRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
