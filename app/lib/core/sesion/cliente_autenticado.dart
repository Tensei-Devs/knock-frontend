import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:http/http.dart' as http;

/// Transporte que agrega el token a las rutas protegidas de la API y, si ésta
/// responde 401, renueva la sesión y repite la petición **una sola vez**
/// (spec 002, R-02; spec 026, R-04, R-06, R-07).
///
/// - El `Authorization: Bearer` solo sale hacia la URL base de la API y solo en
///   rutas protegidas (`me`, `auth/logout`, `colonias/…`); `auth/firebase`,
///   `auth/refresh` y `oficios` van sin él (CA-026-11).
/// - Una llamada protegida sin sesión no sale a la red: falla con
///   [NoAutorizadoFailure] (CA-026-05).
/// - Si la petición repetida vuelve a dar 401, la sesión se cierra.
/// - `auth/logout` nunca se renueva ni se repite (CA-026-08).
class ClienteAutenticado extends http.BaseClient {
  ClienteAutenticado(
    this._interno, {
    required this.leer,
    required this.renovar,
    required this.cerrar,
    required String urlBase,
  }) : _base = Uri.tryParse(normalizarUrlApi(urlBase) ?? '');

  final http.Client _interno;
  final Uri? _base;

  /// Tokens actuales (`null` si no hay sesión).
  final TokensSesion? Function() leer;

  /// Renueva el token [vencido]: `null` si la API lo rechazó; lanza un
  /// `Failure` si el fallo es transitorio (la sesión se conserva).
  final Future<TokensSesion?> Function(String vencido) renovar;

  /// Cierra la sesión local (la renovada también fue rechazada).
  final Future<void> Function() cerrar;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final ruta = _rutaDeLaApi(request.url);
    if (ruta == null || !_esProtegida(ruta)) return _interno.send(request);

    final tokens = leer();
    if (tokens == null) throw const NoAutorizadoFailure();
    final respuesta = await _interno.send(_conToken(request, tokens));
    // Solo se pueden repetir las peticiones con cuerpo en memoria.
    if (respuesta.statusCode != 401 ||
        request is! http.Request ||
        !_esRenovable(ruta)) {
      return respuesta;
    }

    final original = await http.Response.fromStream(respuesta);
    final nuevos = await renovar(tokens.accessToken);
    if (nuevos == null) return _comoRespuesta(original, request);
    final repetida = await _interno.send(_conToken(request, nuevos));
    if (repetida.statusCode == 401) await cerrar();
    return repetida;
  }

  /// Ruta relativa a `/api/v1/` si [url] apunta a la API configurada.
  String? _rutaDeLaApi(Uri url) {
    final base = _base;
    if (base == null) return null;
    final mismoDestino =
        url.scheme == base.scheme &&
        url.host == base.host &&
        url.port == base.port;
    final prefijo = '${base.path}/api/v$versionApi/';
    if (!mismoDestino || !url.path.startsWith(prefijo)) return null;
    return url.path.substring(prefijo.length);
  }

  @override
  void close() => _interno.close();
}

bool _esProtegida(String ruta) =>
    ruta == 'me' ||
    ruta.startsWith('me/') ||
    ruta == 'auth/logout' ||
    ruta.startsWith('colonias/');

bool _esRenovable(String ruta) => ruta != 'auth/logout';

http.StreamedResponse _comoRespuesta(
  http.Response original,
  http.BaseRequest r,
) => http.StreamedResponse(
  Stream.value(original.bodyBytes),
  original.statusCode,
  contentLength: original.bodyBytes.length,
  request: r,
  headers: original.headers,
);

http.BaseRequest _conToken(http.BaseRequest original, TokensSesion tokens) {
  final autorizacion = 'Bearer ${tokens.accessToken}';
  if (original is! http.Request) {
    original.headers['Authorization'] = autorizacion;
    return original;
  }
  return http.Request(original.method, original.url)
    ..headers.addAll(original.headers)
    ..headers['Authorization'] = autorizacion
    ..bodyBytes = original.bodyBytes
    ..followRedirects = original.followRedirects
    ..maxRedirects = original.maxRedirects
    ..persistentConnection = original.persistentConnection;
}
