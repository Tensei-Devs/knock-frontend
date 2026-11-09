import 'dart:async';
import 'dart:io';

import 'package:app/core/cache/almacen_cache.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// De dónde salió la respuesta de [RevalidadorEtag.obtener].
enum OrigenCache {
  /// El servidor mandó datos nuevos (200).
  red,

  /// Lo guardado seguía vigente: no se preguntó al servidor.
  cache,

  /// Se preguntó con `If-None-Match` y el servidor respondió 304.
  cacheRevalidada,

  /// No se pudo preguntar (sin señal o servicio caído): se usa lo guardado,
  /// aunque ya venció.
  cacheSinConexion,
}

final class RespuestaCache {
  const RespuestaCache({required this.cuerpo, required this.origen});

  final String cuerpo;
  final OrigenCache origen;

  /// Si lo mostrado puede estar desactualizado por falta de conexión.
  bool get sinConexion => origen == OrigenCache.cacheSinConexion;
}

/// Pide un recurso `GET` guardándolo en [AlmacenCache] y revalidándolo con
/// `ETag` / `If-None-Match` (spec 010, R-01 y R-02).
class RevalidadorEtag {
  RevalidadorEtag({
    required this._cliente,
    required this._almacen,
    DateTime Function()? ahora,
    this.espera = const Duration(seconds: 15),
  }) : _ahora = ahora ?? DateTime.now;

  final http.Client _cliente;
  final AlmacenCache _almacen;
  final DateTime Function() _ahora;
  final Duration espera;

  /// Lo guardado para [clave], venza o no.
  Future<EntradaCache?> leerGuardado(String clave) => _almacen.leer(clave);

  /// Devuelve el cuerpo de [url]. Si lo guardado tiene menos de [vigencia],
  /// no hay petición; si venció, se pregunta con `If-None-Match` y un 304 lo
  /// renueva sin descargar. [validar] se ejecuta antes de guardar un 200 y
  /// puede lanzar para no ensuciar la caché con un cuerpo inválido.
  ///
  /// Sin conexión o con 5xx devuelve lo guardado
  /// ([OrigenCache.cacheSinConexion]) o, si no hay nada, lanza
  /// [ServicioNoDisponibleFailure].
  Future<RespuestaCache> obtener(
    Uri url, {
    required String clave,
    required Duration vigencia,
    void Function(String cuerpo)? validar,
  }) async {
    final guardado = await _almacen.leer(clave);
    final ahora = _ahora();
    if (guardado != null && ahora.difference(guardado.guardadoEn) < vigencia) {
      return RespuestaCache(cuerpo: guardado.cuerpo, origen: OrigenCache.cache);
    }

    final http.Response respuesta;
    try {
      respuesta = await _cliente
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              if (guardado?.etag != null) 'If-None-Match': guardado!.etag!,
            },
          )
          .timeout(espera);
    } on IOException {
      return _sinConexion(guardado);
    } on http.ClientException {
      return _sinConexion(guardado);
    } on TimeoutException {
      return _sinConexion(guardado);
    }

    final estado = respuesta.statusCode;
    if (estado == 304 && guardado != null) {
      await _almacen.guardar(clave, guardado.conFecha(ahora));
      return RespuestaCache(
        cuerpo: guardado.cuerpo,
        origen: OrigenCache.cacheRevalidada,
      );
    }
    if (estado == 200) {
      validar?.call(respuesta.body);
      await _almacen.guardar(
        clave,
        EntradaCache(
          cuerpo: respuesta.body,
          etag: respuesta.headers['etag'],
          guardadoEn: ahora,
        ),
      );
      return RespuestaCache(cuerpo: respuesta.body, origen: OrigenCache.red);
    }
    return switch (estado) {
      401 => throw const NoAutorizadoFailure(),
      403 => throw const AccesoDenegadoFailure(),
      429 => throw const DemasiadosIntentosFailure(),
      _ => _sinConexion(guardado),
    };
  }

  RespuestaCache _sinConexion(EntradaCache? guardado) {
    if (guardado == null) throw const ServicioNoDisponibleFailure();
    return RespuestaCache(
      cuerpo: guardado.cuerpo,
      origen: OrigenCache.cacheSinConexion,
    );
  }
}

/// Revalidador de la app, sobre el transporte HTTP y la caché del proveedor.
final revalidadorEtagProvider = Provider<RevalidadorEtag>(
  (ref) => RevalidadorEtag(
    cliente: ref.watch(transporteHttpProvider),
    almacen: ref.watch(almacenCacheProvider),
  ),
);
