import 'dart:io';
import 'dart:typed_data';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/actividad/data/foto_preparada.dart';
import 'package:http/http.dart' as http;

/// REAL: la subida privada de una foto de solicitud (backend 032 y 062), en
/// tres pasos:
///
/// 1. `POST /api/v1/imagenes/subidas` pide un enlace temporal (con sesión).
/// 2. `PUT` de los bytes a ese enlace, **fuera de la API**: va por
///    [almacenamiento], sin el token de la sesión.
/// 3. `POST /api/v1/imagenes/subidas/{id}/confirmar` procesa y modera la foto.
///
/// Antes de salir del teléfono, cada foto pasa por [preparar]: se reduce y se
/// le quitan los metadatos (incluida la ubicación). El enlace temporal no se
/// registra ni se guarda. Nada se reintenta aquí (spec 026, R-13).
class SubidaDeFotosApi {
  const SubidaDeFotosApi({
    required this.transporte,
    required this.url,
    required this.almacenamiento,
    this.leer = _leerArchivo,
    this.preparar = prepararFotoEnSegundoPlano,
  });

  /// Transporte con sesión hacia la API.
  final http.Client transporte;
  final String url;

  /// Transporte sin sesión hacia el almacenamiento del enlace temporal.
  final http.Client almacenamiento;

  final Future<Uint8List> Function(String ruta) leer;
  final Future<ResultadoFoto> Function(Uint8List bytes) preparar;

  /// Sube la foto de [rutaLocal] y devuelve su `archivoId`.
  Future<String> subir(String rutaLocal) async {
    final foto = await _preparada(rutaLocal);
    final enlace = await _pedirEnlace(foto);
    await _enviarBytes(enlace, foto.bytes);
    await _confirmar(enlace.id);
    return enlace.id;
  }

  Future<FotoLista> _preparada(String ruta) async {
    final Uint8List original;
    try {
      original = await leer(ruta);
    } on IOException {
      throw const FotoNoValidaFailure();
    }
    final resultado = await preparar(original);
    if (resultado is FotoLista && resultado.bytes.length <= maximoBytesFoto) {
      return resultado;
    }
    throw const FotoNoValidaFailure();
  }

  Future<_Enlace> _pedirEnlace(FotoLista foto) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'imagenes/subidas',
      cuerpo: {
        'proposito': 'solicitud',
        'tipoContenido': foto.tipoContenido,
        'tamanoBytes': foto.bytes.length,
      },
      aceptar: const {422, 503},
    );
    if (r.estado == 422) throw const FotoNoValidaFailure();
    if (r.estado == 503) throw _noDisponible(r);
    return _Enlace.desde(r.json);
  }

  Future<void> _enviarBytes(_Enlace enlace, Uint8List bytes) async {
    final peticion = http.Request('PUT', enlace.destino)
      ..headers.addAll(enlace.encabezados)
      ..followRedirects = false
      ..bodyBytes = bytes;
    final int estado;
    try {
      final respuesta = await almacenamiento.send(peticion);
      await respuesta.stream.drain<void>();
      estado = respuesta.statusCode;
    } on Exception {
      throw const ServicioNoDisponibleFailure();
    }
    if (estado < 200 || estado > 299) {
      throw const ServicioNoDisponibleFailure();
    }
  }

  Future<void> _confirmar(String id) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'imagenes/subidas/$id/confirmar',
      aceptar: const {422, 503},
    );
    if (r.estado == 422) throw const FotoNoValidaFailure();
    if (r.estado == 503) throw _noDisponible(r);
  }

  static Failure _noDisponible(RespuestaJson r) {
    final json = r.json;
    return json is Map<Object?, Object?> &&
            json['code'] == 'moderation_unavailable'
        ? const ModeracionNoDisponibleFailure()
        : const ServicioNoDisponibleFailure();
  }

  static Future<Uint8List> _leerArchivo(String ruta) =>
      File(ruta).readAsBytes();
}

/// El enlace temporal que entrega la API, ya validado: solo `PUT` y `https`.
class _Enlace {
  const _Enlace(this.id, this.destino, this.encabezados);

  factory _Enlace.desde(Object? json) {
    if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    final id = json['id'];
    final direccion = json['urlSubida'];
    final encabezados = json['encabezados'];
    final destino = direccion is String ? Uri.tryParse(direccion) : null;
    if (id is! String ||
        !_idDeArchivo.hasMatch(id) ||
        destino == null ||
        !destino.isScheme('https') ||
        destino.host.isEmpty ||
        json['metodo'] != 'PUT' ||
        encabezados is! Map<Object?, Object?>) {
      throw const DatosInvalidosFailure();
    }
    return _Enlace(id, destino, {
      for (final MapEntry(:key, :value) in encabezados.entries)
        if (key is String && value is String) key: value,
    });
  }

  /// 32 hexadecimales: el `archivoId` del backend (spec 020, R-04).
  static final _idDeArchivo = RegExp(r'^[0-9a-f]{32}$');

  final String id;
  final Uri destino;
  final Map<String, String> encabezados;
}
