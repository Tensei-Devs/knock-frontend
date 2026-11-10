import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/cuenta/data/perfil_repository_api.dart';
import 'package:app/features/cuenta/data/perfil_repository_simulado.dart';
import 'package:app/features/cuenta/data/sesiones_repository_api.dart';
import 'package:app/features/cuenta/domain/perfil_repository.dart';
import 'package:app/features/cuenta/domain/sesiones_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio del perfil (raíz de composición). Con `KNOCK_API_URL` válida usa
/// `GET/PUT /me` y `POST /auth/logout`; sin ella, el SIMULADO solo fuera de
/// `release` (en `release` falla con `ApiNoConfiguradaFailure`, spec 026 R-10).
///
/// Se vuelve a crear cuando se abre o se cierra una sesión, para que el último
/// perfil leído de una cuenta no pase a la siguiente.
final perfilRepositoryProvider = Provider<PerfilRepository>((ref) {
  if (!usaApiReal(ref)) return PerfilRepositorySimulado();
  ref.watch(sesionProvider.select((tokens) => tokens != null));
  return PerfilRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
    cerrarLocal: () => ref.read(sesionProvider.notifier).cerrar(),
  );
});

/// Sesiones por dispositivo (spec 026, R-09): solo capa de datos, sin pantalla.
final sesionesRepositoryProvider = Provider<SesionesRepository>(
  (ref) => SesionesRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
