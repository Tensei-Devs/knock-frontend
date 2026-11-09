import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cache_respuestas.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/espera_por_limite.dart';
import 'package:app/core/sesion/cliente_autenticado.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:knock_api/api.dart';

/// URL base cruda de la API. Las pruebas la reemplazan con `overrideWithValue`.
final urlApiProvider = Provider<String>((ref) => urlApiDefinida);

/// Cliente HTTP de red con espera por 429 (`Retry-After`, spec 009). Las pruebas
/// lo reemplazan por un cliente que apunta a un servidor simulado.
final transporteHttpProvider = Provider<http.Client>((ref) {
  final cliente = ClienteConEspera(http.Client());
  ref.onDispose(cliente.close);
  return cliente;
});

/// Transporte del cliente generado (spec 002): caché con ETag (R-06) sobre
/// sesión con token y renovación (R-02), sobre [transporteHttpProvider].
final transporteApiProvider = Provider<http.Client>((ref) {
  return ClienteConCache(
    ClienteAutenticado(
      ref.watch(transporteHttpProvider),
      leer: () => ref.read(sesionProvider),
      renovar: ref.read(sesionProvider.notifier).renovar,
    ),
    ref.watch(cacheRespuestasProvider),
  );
});

/// Cliente generado de la API (spec 006). Es la única puerta de la app hacia
/// HTTP: nadie arma peticiones a mano. Lanza [ApiNoConfiguradaFailure] al
/// leerse si la URL base falta o no es válida.
final clienteApiProvider = Provider<ApiClient>((ref) {
  final url = normalizarUrlApi(ref.watch(urlApiProvider));
  if (url == null) throw const ApiNoConfiguradaFailure();
  return ApiClient(basePath: url)..client = ref.watch(transporteApiProvider);
});

/// Operaciones de autenticación del contrato (`/api/v{version}/auth/...`).
final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(ref.watch(clienteApiProvider)),
);
