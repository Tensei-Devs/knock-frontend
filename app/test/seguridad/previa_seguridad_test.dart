// Spec 027: seguridad negativa de la previa sin sesión.
import 'dart:convert';
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

/// El script de la spec 027 sobre [contenido]; `null` si no hay Python.
Future<ProcessResult?> _correrScript(List<int> contenido) async {
  final dir = Directory.systemTemp.createTempSync('previa_release_');
  addTearDown(() => dir.deleteSync(recursive: true));
  final binario = File('${dir.path}/libapp.so')..writeAsBytesSync(contenido);
  try {
    return await Process.run(
      'python',
      ['../scripts/verificar_release_sin_demo.py', binario.path],
      environment: {'PYTHONUTF8': '1'},
    );
  } on ProcessException {
    return null;
  }
}

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

  test(
    'CA_027_27 el script falla si el binario trae un nombre de ejemplo',
    () async {
      final resultado = await _correrScript([
        0,
        1,
        ...utf8.encode('xx ${expertosDeEjemplo.first.nombre} yy'),
        2,
      ]);
      if (resultado == null) {
        markTestSkipped('sin Python en el equipo');
        return;
      }
      expect(resultado.exitCode, 1, reason: '${resultado.stdout}');
      expect('${resultado.stdout}', contains('Elena Muestra'));
    },
  );

  test(
    'CA_027_27 el script falla si el binario trae el rótulo en UTF-16',
    () async {
      final resultado = await _correrScript(
        'Datos de ejemplo'.codeUnits.expand((c) => [c, 0]).toList(),
      );
      if (resultado == null) {
        markTestSkipped('sin Python en el equipo');
        return;
      }
      expect(resultado.exitCode, 1, reason: '${resultado.stdout}');
    },
  );

  test('CA_027_27 el script pasa con un binario limpio', () async {
    final resultado = await _correrScript('Knock Entrar Registrarme'.codeUnits);
    if (resultado == null) {
      markTestSkipped('sin Python en el equipo');
      return;
    }
    expect(resultado.exitCode, 0, reason: '${resultado.stdout}');
  });

  test(
    'CA_027_27 el script no da un falso verde si no hay nada que revisar',
    () async {
      final vacio = Directory.systemTemp.createTempSync('previa_vacio_');
      addTearDown(() => vacio.deleteSync(recursive: true));
      try {
        final r = await Process.run('python', [
          '../scripts/verificar_release_sin_demo.py',
          vacio.path,
        ]);
        expect(r.exitCode, 2);
      } on ProcessException {
        markTestSkipped('sin Python en el equipo');
      }
    },
  );
}
