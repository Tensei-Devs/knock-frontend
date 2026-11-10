import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Respuesta guardada con el ETag que mandó el servidor.
class EntradaCache {
  const EntradaCache({
    required this.etag,
    required this.cuerpo,
    required this.encabezados,
    required this.guardadaEn,
  });

  final String etag;
  final Uint8List cuerpo;
  final Map<String, String> encabezados;
  final DateTime guardadaEn;
}

/// Caché de respuestas GET (spec 002, R-06). Vive solo en memoria: no se
/// escribe en disco, y se vacía completa al cerrar (y al iniciar) sesión
/// para que nadie vea datos de otra persona.
class CacheRespuestas {
  CacheRespuestas({
    this.vigencia = const Duration(minutes: 5),
    DateTime Function()? ahora,
  }) : _ahora = ahora ?? DateTime.now;

  /// Cuánto tiempo se conserva una entrada ("poco tiempo").
  final Duration vigencia;
  final DateTime Function() _ahora;
  final Map<String, EntradaCache> _entradas = {};

  bool get estaVacia => _entradas.isEmpty;

  /// La entrada vigente, o `null` (si venció, se descarta).
  EntradaCache? obtener(String clave) {
    final entrada = _entradas[clave];
    if (entrada == null) return null;
    if (_ahora().difference(entrada.guardadaEn) > vigencia) {
      _entradas.remove(clave);
      return null;
    }
    return entrada;
  }

  void guardar(
    String clave, {
    required String etag,
    required Uint8List cuerpo,
    required Map<String, String> encabezados,
  }) {
    _entradas[clave] = EntradaCache(
      etag: etag,
      cuerpo: cuerpo,
      encabezados: encabezados,
      guardadaEn: _ahora(),
    );
  }

  /// Borra todo (cierre de sesión, R-06 y CA-04).
  void borrarTodo() => _entradas.clear();
}

final cacheRespuestasProvider = Provider<CacheRespuestas>(
  (ref) => CacheRespuestas(),
);

/// Transporte que revalida con ETag las lecturas (GET) antes de volver a
/// descargarlas: manda `If-None-Match` y, si el servidor responde 304, entrega
/// lo guardado. Solo guarda respuestas 200 con ETag y sin `no-store`.
///
/// Las URL que [sinCache] acepta pasan de largo: ni se guardan ni se usan como
/// llave (por ejemplo, `colonias/en-punto` lleva coordenadas exactas en la
/// consulta, spec 026 §8).
class ClienteConCache extends http.BaseClient {
  ClienteConCache(this._interno, this._cache, {this.sinCache});

  final http.Client _interno;
  final CacheRespuestas _cache;
  final bool Function(Uri url)? sinCache;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method != 'GET' ||
        request is! http.Request ||
        (sinCache?.call(request.url) ?? false)) {
      return _interno.send(request);
    }
    final clave = request.url.toString();
    final guardada = _cache.obtener(clave);
    final peticion = http.Request(request.method, request.url)
      ..headers.addAll(request.headers);
    if (guardada != null) peticion.headers['If-None-Match'] = guardada.etag;

    final respuesta = await _interno.send(peticion);
    if (respuesta.statusCode == 304 && guardada != null) {
      await respuesta.stream.drain<void>();
      return http.StreamedResponse(
        Stream.value(guardada.cuerpo),
        200,
        contentLength: guardada.cuerpo.length,
        request: request,
        headers: guardada.encabezados,
      );
    }
    final etag = respuesta.headers['etag'];
    final sinGuardar = (respuesta.headers['cache-control'] ?? '')
        .toLowerCase()
        .contains('no-store');
    if (respuesta.statusCode != 200 || etag == null || sinGuardar) {
      return respuesta;
    }
    final completa = await http.Response.fromStream(respuesta);
    _cache.guardar(
      clave,
      etag: etag,
      cuerpo: completa.bodyBytes,
      encabezados: completa.headers,
    );
    return http.StreamedResponse(
      Stream.value(completa.bodyBytes),
      completa.statusCode,
      contentLength: completa.bodyBytes.length,
      request: request,
      headers: completa.headers,
    );
  }

  @override
  void close() => _interno.close();
}
