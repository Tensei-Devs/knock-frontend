import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/features/actividad/data/borrador_repository.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

BorradorSolicitud _borrador() => BorradorSolicitud(
  oficioClave: 'plo',
  descripcion: 'Hay una fuga de agua',
  rutasDeFotos: const ['f1.jpg'],
  dia: DateTime(2026, 11, 13),
  franja: Franja.noche,
  actualizadoEn: DateTime.utc(2026, 11, 11, 10),
);

void main() {
  test('CA_015_14 sin señal a media captura se recupera lo escrito', () async {
    final almacen = AlmacenPreferenciasEnMemoria();
    await BorradorRepository(almacen).guardar(_borrador());

    // Otra instancia, como al reabrir el formulario.
    final recuperado = BorradorRepository(almacen).leer();
    expect(recuperado, isNotNull);
    expect(recuperado!.descripcion, 'Hay una fuga de agua');
    expect(recuperado.rutasDeFotos, ['f1.jpg']);
    expect(recuperado.franja, Franja.noche);
  });

  test('CA_015_14 sin borrador guardado no hay nada que recuperar', () {
    expect(BorradorRepository(AlmacenPreferenciasEnMemoria()).leer(), isNull);
  });

  test('CA_015_19 al enviar o descartar el borrador queda vacío', () async {
    SharedPreferences.setMockInitialValues({});
    final preferencias = await SharedPreferences.getInstance();
    final repo = BorradorRepository(AlmacenPreferenciasShared(preferencias));

    await repo.guardar(_borrador());
    expect(preferencias.getKeys(), contains('knock.borrador.solicitud'));

    await repo.descartar();
    expect(repo.leer(), isNull);
    expect(
      preferencias.getKeys().where((k) => k.startsWith('knock.borrador')),
      isEmpty,
    );
  });

  test('CA_015_19 en preferencias no queda dirección del domicilio', () async {
    SharedPreferences.setMockInitialValues({});
    final preferencias = await SharedPreferences.getInstance();
    await BorradorRepository(AlmacenPreferenciasShared(preferencias))
        .guardar(_borrador());

    for (final clave in preferencias.getKeys()) {
      expect(clave.toLowerCase(), isNot(contains('direccion')));
      expect(
        '${preferencias.get(clave)}'.toLowerCase(),
        isNot(contains('direccion')),
      );
    }
  });

  test('CA_015_14 un valor dañado en el almacén no rompe la lectura', () async {
    SharedPreferences.setMockInitialValues({'knock.borrador.solicitud': '{{{'});
    final preferencias = await SharedPreferences.getInstance();
    expect(
      BorradorRepository(AlmacenPreferenciasShared(preferencias)).leer(),
      isNull,
    );
  });
}
