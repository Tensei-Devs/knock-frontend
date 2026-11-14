import 'dart:io';

import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/datos_de_visita.dart';
import 'package:app/features/actividad/data/aviso_local_repository.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AlmacenSeguroEnMemoria almacen;
  late ContactosConfianzaSeguros repositorio;

  setUp(() {
    almacen = AlmacenSeguroEnMemoria();
    repositorio = ContactosConfianzaSeguros(almacen);
  });

  test('CA_022_04 el contacto queda solo en el almacén seguro', () async {
    SharedPreferences.setMockInitialValues({});
    await repositorio.guardar(
      const ContactoConfianza(id: '1', nombre: 'Ana', celular: '5500000001'),
    );

    expect(await repositorio.listar(), hasLength(1));
    expect(almacen.contenido.keys, [claveContactosConfianza]);
    expect((await SharedPreferences.getInstance()).getKeys(), isEmpty);
  });

  test('CA_022_06 el contacto 11 no se guarda', () async {
    for (var i = 0; i < 10; i++) {
      await repositorio.guardar(
        ContactoConfianza(
          id: '$i',
          nombre: 'Persona $i',
          celular: '550000001$i',
        ),
      );
    }

    expect(
      () => repositorio.guardar(
        const ContactoConfianza(
          id: '99',
          nombre: 'Once',
          celular: '5599999999',
        ),
      ),
      throwsA(
        isA<ContactoNoGuardado>().having(
          (e) => e.error,
          'error',
          ErrorContacto.lleno,
        ),
      ),
    );
    expect(await repositorio.listar(), hasLength(10));
  });

  test('CA_022_08 editar reemplaza y borrar quita del almacén', () async {
    await repositorio.guardar(
      const ContactoConfianza(id: '1', nombre: 'Ana', celular: '5500000001'),
    );
    await repositorio.guardar(
      const ContactoConfianza(
        id: '1',
        nombre: 'Ana María',
        celular: '5500000002',
      ),
    );

    final lista = await repositorio.listar();
    expect(lista.single.nombre, 'Ana María');
    expect(almacen.contenido.values.join(), isNot(contains('5500000001')));

    await repositorio.borrar('1');
    expect(await repositorio.listar(), isEmpty);
    expect(almacen.contenido, isEmpty);
  });

  test(
    'CA_022_13 y CA_022_20 cerrar sesión borra contactos y respaldo del aviso',
    () async {
      await repositorio.guardar(
        const ContactoConfianza(id: '1', nombre: 'Ana', celular: '5500000001'),
      );
      await RespaldoAvisoSeguro(almacen).guardar(
        'v1',
        DatosAvisoLocal(
          tecnicoNombre: 'Técnico',
          tecnicoVerificado: true,
          dia: DateTime(2026, 11, 14),
          hora: '10:30',
        ),
      );

      await borrarDatosDeVisita(almacen);

      expect(almacen.contenido, isEmpty);
    },
  );

  group('CA_022_11 y CA_022_20 manifiesto', () {
    final manifiesto = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();

    test('CA_022_11 sin READ_CONTACTS, SEND_SMS ni CALL_PHONE', () {
      for (final permiso in ['READ_CONTACTS', 'SEND_SMS', 'CALL_PHONE']) {
        expect(manifiesto, isNot(contains('android.permission.$permiso')));
      }
    });

    test('CA_022_11 consultas solo para sms y https', () {
      expect(manifiesto, contains('android:scheme="sms"'));
      expect(manifiesto, contains('android:scheme="https"'));
    });

    test('CA_022_20 sin copia de seguridad y con reglas de extracción', () {
      expect(manifiesto, contains('android:allowBackup="false"'));
      expect(
        manifiesto,
        contains('android:dataExtractionRules="@xml/data_extraction_rules"'),
      );
      final reglas = File(
        'android/app/src/main/res/xml/data_extraction_rules.xml',
      ).readAsStringSync();
      expect(reglas, contains('<cloud-backup>'));
      expect(reglas, contains('<device-transfer>'));
      expect(reglas, contains('<exclude domain="root" />'));
    });
  });
}
