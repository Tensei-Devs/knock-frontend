import 'dart:io';

import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/core/preferencias/directorio_fotos_borrador.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('CA_015_19 cerrar sesión borra el borrador y sus fotos', () async {
    final raiz = Directory.systemTemp.createTempSync('knock_cierre_');
    addTearDown(() => raiz.deleteSync(recursive: true));
    final fotos = Directory('${raiz.path}/fotos_solicitud')..createSync();
    File('${fotos.path}/a1.jpg').writeAsBytesSync([0xFF, 0xD8, 0xFF]);
    final almacen = AlmacenPreferenciasEnMemoria();
    await almacen.guardarBorrador({'v': 1, 'descripcion': 'Gotea la llave'});

    final contenedor = ProviderContainer(
      overrides: [
        almacenPreferenciasProvider.overrideWithValue(almacen),
        directorioFotosBorradorProvider.overrideWithValue(() async => fotos),
      ],
    );
    addTearDown(contenedor.dispose);

    await contenedor.read(sesionProvider.notifier).cerrar();

    expect(almacen.leerBorrador(), isNull);
    expect(fotos.listSync(), isEmpty);
  });
}
