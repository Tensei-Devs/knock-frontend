import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:http/http.dart' as http;

/// Transporte que agrega el token a las rutas protegidas de la API y, si ésta
/// responde 401, renueva la sesión y repite la petición **una sola vez**
/// (spec 002, R-02; spec 026, R-04, R-06, R-07).
///
/// - El `Authorization: Bearer` solo sale hacia la URL base de la API y solo en
///   rutas protegidas (todas menos las públicas: `auth/firebase`,
///   `auth/refresh`, `oficios`, `recuperacion-acceso`, `tecnicos/autocompletar`
///   y `tecnicos/{id}` de **un solo segmento**, CA-026-11). `explorar` lo lleva
///   solo si hay sesión (spec 036).
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
    if (ruta == null) return _interno.send(request);
    final protegida = _esProtegida(ruta);
    if (!protegida && !_admiteSesion(ruta)) return _interno.send(request);

    final tokens = leer();
    if (tokens == null) {
      // Con sesión opcional, sin sesión sale sin token (spec 036, TEC-14).
      if (!protegida) return _interno.send(request);
      throw const NoAutorizadoFailure();
    }
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

/// Rutas del contrato que NO piden sesión: el resto de la API es protegido y
/// lleva el Bearer (así cada ruta nueva del contrato queda protegida por
/// omisión). La lista sale del backend: `[AllowAnonymous]` en
/// `AuthController.cs:18-19` (`auth/firebase`), `RefreshController.cs:18-19`
/// (`auth/refresh`), `OficiosController.cs:28-29` (`oficios`),
/// `AccessRecoveryController.cs:15-16` (`recuperacion-acceso`) y
/// `TecnicosController.cs:61-62` y `76-77` (`tecnicos/{id}` y
/// `tecnicos/autocompletar`), y de las rutas con política `anonymous` del
/// gateway (`appsettings.json`). `health` no pasa por el gateway y no se usa.
const _rutasPublicas = {
  'auth/firebase',
  'auth/refresh',
  'oficios',
  'recuperacion-acceso',
  'tecnicos/autocompletar',
};

/// `tecnicos/{id}`: el perfil público de un técnico. Coincide con **un solo
/// segmento** y con un identificador de 24 hexadecimales; así `tecnicos/me`,
/// `tecnicos/{id}/llega-a-mi-colonia` y cualquier subruta siguen exigiendo
/// sesión (llevan datos personales o acciones de la persona).
final _perfilPublicoDeTecnico = RegExp(r'^tecnicos/[0-9a-fA-F]{24}$');

bool _esProtegida(String ruta) =>
    !_rutasPublicas.contains(ruta) &&
    !_admiteSesion(ruta) &&
    !_perfilPublicoDeTecnico.hasMatch(ruta);

/// Rutas públicas que con sesión entregan más (spec 036, backend 046 R-49):
/// llevan el token solo si hay sesión.
bool _admiteSesion(String ruta) => ruta == 'explorar';

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
