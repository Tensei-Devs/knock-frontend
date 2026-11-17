import 'dart:io';

import 'package:app/core/preferencias/almacen_borrador_solicitud.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/features/actividad/data/borrador_repository.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory raiz;
  late Directory fotos;
  late AlmacenPreferenciasShared almacen;
  late BorradorRepository repositorio;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    almacen = AlmacenPreferenciasShared(await SharedPreferences.getInstance());
    raiz = Directory.systemTemp.createTempSync('knock_borrador_');
    fotos = Directory('${raiz.path}/fotos_solicitud')..createSync();
    repositorio = BorradorRepository(
      almacen: almacen,
      directorioFotos: () async => fotos,
    );
  });

  tearDown(() => raiz.deleteSync(recursive: true));

  File fotoPrivada(String nombre) =>
      File('${fotos.path}/$nombre')..writeAsBytesSync([0xFF, 0xD8, 0xFF]);

  BorradorSolicitud borradorCon(List<String> rutas) => BorradorSolicitud(
    oficioClave: 'plo',
    descripcion: 'Gotea la llave del baño',
    rutasDeFotos: rutas,
    dia: DateTime(2026, 11, 12),
    franja: Franja.manana,
    actualizadoEn: DateTime.utc(2026, 11, 10, 18),
  );

  group('CA_015_14 recupera lo escrito y las fotos', () {
    test('CA_015_14 lo guardado se lee igual al volver', () async {
      final foto = fotoPrivada('a1.jpg');
      await repositorio.guardar(borradorCon([foto.path]));

      final leido = await repositorio.leer();

      expect(leido, isNotNull);
      expect(leido!.descripcion, 'Gotea la llave del baño');
      expect(leido.oficioClave, 'plo');
      expect(leido.rutasDeFotos, [foto.path]);
      expect(leido.franja, Franja.manana);
    });

    test(
      'CA_015_14 quita fotos que ya no existen o fuera del directorio',
      () async {
        final viva = fotoPrivada('viva.jpg');
        final borrada = fotoPrivada('borrada.jpg')..deleteSync();
        final ajena = File('${raiz.path}/ajena.jpg')..writeAsBytesSync([1]);
        await repositorio.guardar(
          borradorCon([viva.path, borrada.path, ajena.path]),
        );

        final leido = await repositorio.leer();

        expect(leido!.rutasDeFotos, [viva.path]);
      },
    );

    test('CA_015_14 un borrador dañado se descarta y se borra', () async {
      await almacen.guardarBorrador({'v': 99});

      expect(await repositorio.leer(), isNull);
      expect(almacen.leerBorrador(), isNull);
    });

    test('CA_015_14 sin borrador devuelve null', () async {
      expect(await repositorio.leer(), isNull);
    });
  });

  group('CA_015_19 al enviar, descartar o cerrar sesión queda vacío', () {
    test('CA_015_19 borrarTodo vacía el borrador y el directorio', () async {
      final foto = fotoPrivada('a1.jpg');
      fotoPrivada('b2.jpg');
      await repositorio.guardar(borradorCon([foto.path]));

      await repositorio.borrarTodo();

      expect(almacen.leerBorrador(), isNull);
      expect(fotos.listSync(), isEmpty);
      expect(await repositorio.leer(), isNull);
    });

    test('CA_015_19 borrarTodo no falla si el directorio no existe', () async {
      fotos.deleteSync(recursive: true);

      await repositorio.borrarTodo();

      expect(almacen.leerBorrador(), isNull);
    });

    test('CA_015_19 lo guardado en preferencias no tiene dirección', () async {
      SharedPreferences.setMockInitialValues({});
      final preferencias = await SharedPreferences.getInstance();
      final repo = BorradorRepository(
        almacen: AlmacenPreferenciasShared(preferencias),
        directorioFotos: () async => fotos,
      );

      await repo.guardar(borradorCon(const []));

      final guardado = '${preferencias.get(claveBorradorSolicitud)}';
      expect(guardado, isNot(contains('direccion')));
      for (final clave in preferencias.getKeys()) {
        expect(clave, startsWith('knock.'));
      }
    });
  });
}
