import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/trabajo/data/cotizar_repository_api.dart';
import 'package:app/features/trabajo/domain/cotizar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cotizar (specs 046 y 038). La maqueta lo usa solo con sesión y API.
final cotizarRepositoryProvider = Provider<CotizarRepository>(
  (ref) => CotizarRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// La hora actual, para saber qué días ya pasaron; las pruebas la fijan.
final relojCotizarProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
