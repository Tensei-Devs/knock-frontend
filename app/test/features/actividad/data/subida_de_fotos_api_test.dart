// KNOCK-288 (spec 015, T-04; backend 062): subida privada de una foto de
// solicitud. API y almacenamiento falsos; solo datos ficticios.
import 'dart:io';
import 'dart:typed_data';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/data/foto_preparada.dart';
import 'package:app/features/actividad/data/solicitud_repository_api.dart';
import 'package:app/features/actividad/data/subida_de_fotos_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image/image.dart' as img;

import '../../../soporte/api_falsa.dart';

const _id = '0123456789abcdef0123456789abcdef';
const _destino = 'https://almacen.knock.test/cuarentena/foto?firma=ficticia';

Map<String, Object?> _enlace({
  String id = _id,
  String urlSubida = _destino,
  String metodo = 'PUT',
}) => {
  'id': id,
  'urlSubida': urlSubida,
  'metodo': metodo,
  'encabezados': {'x-ms-blob-type': 'BlockBlob', 'content-type': 'image/jpeg'},
  'venceEn': '2026-11-25T18:00:00Z',
  'confirmarAntesDe': '2026-11-25T18:30:00Z',
};

http.Response _problema(int estado, String codigo) =>
    jsonOk({'status': estado, 'code': codigo}, estado: estado);

ApiFalsa _api({http.Response? alPedir, http.Response? alConfirmar}) => ApiFalsa(
  (p) => p.ruta == 'imagenes/subidas'
      ? alPedir ?? jsonOk(_enlace(), estado: 201)
      : alConfirmar ?? jsonOk({'id': _id, 'ancho': 4, 'alto': 4, 'bytes': 3}),
);

final _preparada = FotoLista(
  bytes: Uint8List.fromList([1, 2, 3]),
  tipoContenido: 'image/jpeg',
  ancho: 4,
  alto: 4,
);

SubidaDeFotosApi _subida(
  ApiFalsa api,
  ApiFalsa almacen, {
  Future<ResultadoFoto> Function(Uint8List)? preparar,
  Future<Uint8List> Function(String)? leer,
}) => SubidaDeFotosApi(
  transporte: api.cliente,
  url: urlApiPrueba,
  almacenamiento: almacen.cliente,
  leer: leer ?? (_) async => Uint8List.fromList([9, 9]),
  preparar: preparar ?? (_) async => _preparada,
);

void main() {
  test('CA_015_18 pide el enlace, sube los bytes preparados sin la sesión y '
      'confirma', () async {
    final api = _api();
    final almacen = ApiFalsa((_) => http.Response('', 201));

    final id = await _subida(api, almacen).subir('/privado/foto.jpg');

    expect(id, _id);
    expect(api.llamadas, [
      'POST imagenes/subidas',
      'POST imagenes/subidas/$_id/confirmar',
    ]);
    expect(api.peticiones.first.json, {
      'proposito': 'solicitud',
      'tipoContenido': 'image/jpeg',
      'tamanoBytes': 3,
    });
    final put = almacen.peticiones.single;
    expect(put.metodo, 'PUT');
    expect(put.url.toString(), _destino);
    expect(put.autorizacion, isNull);
    expect(put.cabeceras['x-ms-blob-type'], 'BlockBlob');
    expect(put.cuerpo.codeUnits, [1, 2, 3]);
  });

  test('CA_015_18 con la preparación real, una foto sale sin los metadatos '
      'con los que llegó', () async {
    final original = img.Image(width: 8, height: 8);
    original.exif.imageIfd['Make'] = 'CamaraFicticia';
    final bytes = img.encodeJpg(original);
    expect(String.fromCharCodes(bytes), contains('CamaraFicticia'));
    // El cuerpo es binario: se guardan los bytes, no su lectura como texto.
    List<int>? enviado;
    await SubidaDeFotosApi(
      transporte: _api().cliente,
      url: urlApiPrueba,
      almacenamiento: MockClient((peticion) async {
        enviado = peticion.bodyBytes;
        return http.Response('', 201);
      }),
      leer: (_) async => bytes,
      preparar: (b) async => prepararFoto(b),
    ).subir('/privado/foto.jpg');

    expect(enviado, isNotEmpty);
    expect(String.fromCharCodes(enviado!), isNot(contains('CamaraFicticia')));
  });

  test('un archivo que no es una foto, o que ya no existe, no llega a la '
      'red', () async {
    final api = _api();
    final almacen = ApiFalsa();
    for (final subida in [
      _subida(api, almacen, preparar: (b) async => prepararFoto(b)),
      _subida(
        api,
        almacen,
        leer: (_) async => throw const FileSystemException('no existe'),
      ),
    ]) {
      await expectLater(
        subida.subir('/privado/foto.jpg'),
        throwsA(isA<FotoNoValidaFailure>()),
      );
    }
    expect(api.peticiones, isEmpty);
    expect(almacen.peticiones, isEmpty);
  });

  test('un enlace que no es https o no es PUT se rechaza sin enviar '
      'bytes', () async {
    for (final enlace in [
      _enlace(urlSubida: 'http://almacen.knock.test/foto'),
      _enlace(urlSubida: 'file:///foto'),
      _enlace(metodo: 'POST'),
      _enlace(id: 'otro'),
    ]) {
      final almacen = ApiFalsa();
      await expectLater(
        _subida(
          _api(alPedir: jsonOk(enlace, estado: 201)),
          almacen,
        ).subir('/privado/foto.jpg'),
        throwsA(isA<DatosInvalidosFailure>()),
      );
      expect(almacen.peticiones, isEmpty);
    }
  });

  test('si el almacenamiento falla no se confirma', () async {
    final api = _api();
    await expectLater(
      _subida(
        api,
        ApiFalsa((_) => http.Response('', 403)),
      ).subir('/privado/foto.jpg'),
      throwsA(isA<ServicioNoDisponibleFailure>()),
    );
    expect(api.llamadas, ['POST imagenes/subidas']);
  });

  test('los errores de pedir y de confirmar llegan como Failure', () async {
    final casos = <(ApiFalsa, Type)>[
      (_api(alPedir: _problema(422, 'x')), FotoNoValidaFailure),
      (
        _api(alPedir: _problema(503, 'storage_unavailable')),
        ServicioNoDisponibleFailure,
      ),
      (
        _api(alPedir: _problema(429, 'limit_exceeded')),
        DemasiadosIntentosFailure,
      ),
      (
        _api(alConfirmar: _problema(422, 'image_rejected')),
        FotoNoValidaFailure,
      ),
      (
        _api(alConfirmar: _problema(503, 'moderation_unavailable')),
        ModeracionNoDisponibleFailure,
      ),
      (_api(alConfirmar: _problema(409, 'upload_expired')), ConflictoFailure),
    ];
    for (final (api, tipo) in casos) {
      final subida = SubidaDeFotosApi(
        transporte: api.transporte,
        url: urlApiPrueba,
        almacenamiento: ApiFalsa((_) => http.Response('', 201)).cliente,
        leer: (_) async => Uint8List(1),
        preparar: (_) async => _preparada,
      );
      await expectLater(
        subida.subir('/privado/foto.jpg'),
        throwsA(predicate((e) => e.runtimeType == tipo, '$tipo')),
      );
    }
  });

  test(
    'el repositorio sube con la pieza de fotos y, sin ella, falla',
    () async {
      final api = _api();
      final repositorio = SolicitudRepositoryApi(
        transporte: api.cliente,
        url: urlApiPrueba,
        fotos: _subida(api, ApiFalsa((_) => http.Response('', 201))),
      );

      expect(await repositorio.subirFoto('/privado/foto.jpg'), _id);
      await expectLater(
        SolicitudRepositoryApi(
          transporte: api.cliente,
          url: urlApiPrueba,
        ).subirFoto('/privado/foto.jpg'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    },
  );
}
