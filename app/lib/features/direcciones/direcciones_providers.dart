import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/direcciones/data/direcciones_repository_api.dart';
import 'package:app/features/direcciones/domain/direcciones_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Direcciones de la persona (spec 030): solo capa de datos; la pantalla
/// «Mis datos» y el paso 3 de «Pedir cotización» las usan después. Sin
/// `KNOCK_API_URL` válida falla con `ApiNoConfiguradaFailure` en la primera
/// llamada.
final direccionesRepositoryProvider = Provider<DireccionesRepository>(
  (ref) => DireccionesRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
