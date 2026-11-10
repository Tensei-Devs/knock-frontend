// Spec 027: seguridad negativa de la previa sin sesión.
import 'dart:io';

import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../soporte/api_falsa.dart';
import '../soporte/montar_app.dart';

List<File> _fuentesDeLaPrevia() =>
    Directory('lib/features/previa')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

const _oficiosJson = [
  {'clave': 'ele', 'nombre': 'Electricidad', 'modalidad': 'domicilio'},
  {'clave': 'mec', 'nombre': 'Mecánica', 'modalidad': 'taller'},
];

void main() {
  testWidgets(
    'CA_027_14 sin sesión solo sale GET /oficios y sin Authorization',
    (tester) async {
      tester.view.physicalSize = const Size(400, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final api = ApiFalsa((p) => jsonOk(_oficiosJson));
      await montarApp(
        tester,
        esTecnico: false,
        sesionIniciada: false,
        abrirEnEntrada: false,
        extra: [
          urlApiProvider.overrideWithValue(urlApiPrueba),
          transporteHttpProvider.overrideWithValue(api.transporte),
        ],
      );
      expect(find.text('Busca un experto cerca de ti'), findsOneWidget);
      expect(find.text('Electricidad'), findsWidgets);

      // Tocar el buscador y los chips tampoco manda nada.
      await tester.tap(find.text('Busca un experto cerca de ti'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ahora no'));
      await tester.pumpAndSettle();

      expect(api.peticiones, isNotEmpty);
      for (final p in api.peticiones) {
        expect(p.llamadaCompleta, 'GET /api/v1/oficios', reason: '$p');
        expect(p.cabeceras, isNot(contains('authorization')), reason: '$p');
      }
    },
  );

  test('CA_027_30 la previa no usa ubicación, permisos ni notificaciones', () {
    final prohibido = RegExp(
      r'geolocator|permission|gestor_permisos|ubicacion_repository|'
      r'firebase_messaging|google_maps_flutter',
      caseSensitive: false,
    );
    for (final archivo in _fuentesDeLaPrevia()) {
      expect(
        archivo.readAsStringSync(),
        isNot(contains(prohibido)),
        reason: archivo.path,
      );
    }
  });

  test('CA_027_33 la previa no registra nada ni toca tokens', () {
    final prohibido = RegExp(
      r'\bprint\(|debugPrint\(|\blog\(|developer\.log|sesionProvider|'
      r'almacen_seguro|tokensSesion',
    );
    for (final archivo in _fuentesDeLaPrevia()) {
      expect(
        archivo.readAsStringSync(),
        isNot(contains(prohibido)),
        reason: archivo.path,
      );
    }
  });

  test(
    'CA_027_33 los datos de ejemplo no se muestran como datos de contacto',
    () {
      for (final e in expertosDeEjemplo) {
        expect('${e.nombre}${e.oficio}${e.calificacion}', isNot(contains('@')));
      }
    },
  );
}
