import 'package:app/core/sesion/sesion.dart';
import 'package:http/http.dart' as http;

/// Transporte que agrega el token a cada petición y, si la API responde 401,
/// renueva la sesión y repite la petición una sola vez (spec 002, R-02, CA-01).
/// Si la renovación falla, la sesión se cierra y se entrega el 401 original.
class ClienteAutenticado extends http.BaseClient {
  ClienteAutenticado(
    this._interno, {
    required this.leer,
    required this.renovar,
  });

  final http.Client _interno;

  /// Tokens actuales (`null` si no hay sesión).
  final TokensSesion? Function() leer;

  /// Renueva el token [vencido]; `null` si ya no es válido.
  final Future<TokensSesion?> Function(String vencido) renovar;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final tokens = leer();
    // Solo se pueden repetir las peticiones con cuerpo en memoria.
    if (tokens == null || request is! http.Request) {
      return _interno.send(_conToken(request, tokens));
    }
    final respuesta = await _interno.send(_conToken(request, tokens));
    if (respuesta.statusCode != 401) return respuesta;

    final original = await http.Response.fromStream(respuesta);
    final nuevos = await renovar(tokens.accessToken);
    if (nuevos == null) {
      return http.StreamedResponse(
        Stream.value(original.bodyBytes),
        401,
        contentLength: original.bodyBytes.length,
        request: request,
        headers: original.headers,
      );
    }
    return _interno.send(_conToken(request, nuevos));
  }

  @override
  void close() => _interno.close();
}

http.BaseRequest _conToken(http.BaseRequest original, TokensSesion? tokens) {
  if (original is! http.Request) {
    if (tokens != null) {
      original.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    return original;
  }
  final copia = http.Request(original.method, original.url)
    ..headers.addAll(original.headers)
    ..bodyBytes = original.bodyBytes
    ..followRedirects = original.followRedirects
    ..maxRedirects = original.maxRedirects
    ..persistentConnection = original.persistentConnection;
  if (tokens != null) {
    copia.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
  }
  return copia;
}
