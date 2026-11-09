// Spec 010 (KNOCK-224): oficios reales con caché, ETag y modo sin conexión.
import 'dart:io';

import 'package:app/core/cache/almacen_cache.dart';
import 'package:app/core/cache/revalidador_etag.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/features/oficios/data/oficios_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _uno =
    '[{"clave":"ele","nombre":"Electricidad","modalidad":"domicilio"}]';
const _dos =
    '[{"clave":"ele","nombre":"Electricidad","modalidad":"domicilio"},'
    '{"clave":"mec","nombre":"Mecánica","modalidad":"taller"}]';

void main() {
  late DateTime ahora;
  late AlmacenCacheEnMemoria almacen;
  late http.Response Function(http.Request) servidor;

  OficiosRepositoryApi crear() => OficiosRepositoryApi(
    revalidador: RevalidadorEtag(
      cliente: MockClient((p) async => servidor(p)),
      almacen: almacen,
      ahora: () => ahora,
    ),
    url: Uri.parse('https://api.ejemplo.test/api/v1/oficios'),
  );

  setUp(() {
    ahora = DateTime.utc(2026, 11, 5, 12);
    almacen = AlmacenCacheEnMemoria();
    servidor = (_) => http.Response(_uno, 200, headers: {'etag': '"v1"'});
  });

  test('R_010_SC primera vez: pide a la red y emite una sola vez', () async {
    final emitidos = await crear().observar().toList();
    expect(emitidos, hasLength(1));
    expect(emitidos.single.oficios.single.clave, 'ele');
    expect(emitidos.single.sinConexion, isFalse);
  });

  test('R_010_03 emite primero lo guardado y luego lo nuevo', () async {
    await crear().observar().toList();
    ahora = ahora.add(const Duration(minutes: 11));
    servidor = (_) => http.Response(_dos, 200, headers: {'etag': '"v2"'});

    final emitidos = await crear().observar().toList();

    expect(emitidos.map((r) => r.oficios.length), [1, 2]);
    expect(emitidos.every((r) => !r.sinConexion), isTrue);
  });

  test(
    'R_010_SC sin red con caché: lo guardado y aviso sin conexión',
    () async {
      await crear().observar().toList();
      ahora = ahora.add(const Duration(hours: 2));
      servidor = (_) => throw const SocketException('sin red');

      final emitidos = await crear().observar().toList();

      expect(emitidos.last.oficios, hasLength(1));
      expect(emitidos.last.sinConexion, isTrue);
    },
  );

  test(
    'R_010_SC sin red y sin caché: falla con ServicioNoDisponible',
    () async {
      servidor = (_) => throw const SocketException('sin red');
      await expectLater(
        crear().observar().toList(),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    },
  );

  test(
    'CA_010_01 listar usa la caché vigente sin preguntar de nuevo',
    () async {
      await crear().listar();
      servidor = (_) => throw StateError('no debía haber petición');
      expect(await crear().listar(), hasLength(1));
    },
  );

  test('una respuesta que no cumple el contrato no entra a la caché', () async {
    servidor = (_) => http.Response('[{"clave":""}]', 200);
    await expectLater(crear().listar(), throwsA(isA<DatosInvalidosFailure>()));
    expect(await almacen.leer(OficiosRepositoryApi.clave), isNull);
  });
}
