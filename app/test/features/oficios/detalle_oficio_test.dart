// Spec 035: detalle de un oficio y pedido de uno nuevo contra la API falsa
// (repositorio, controlador y las opciones de «Pedir cotización»).
import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/detalle_oficio_real.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

final _detalle = {
  'clave': 'plo',
  'nombre': 'Plomería',
  'modalidad': 'domicilio',
  'frasesSugeridas': ['Fuga en el baño'],
};

ProviderContainer _contenedor(ApiFalsa api, {bool activas = true}) {
  final c = contenedorConApi(
    api,
    extra: [solicitudesRealesActivasProvider.overrideWithValue(activas)],
  );
  addTearDown(c.dispose);
  return c;
}

Future<void> _montar(WidgetTester tester, ProviderContainer c) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FrasesDelOficio(
            clave: 'plo',
            ejemplo: const ['De ejemplo'],
            opciones: (frases) =>
                Column(children: [for (final f in frases) Text(f)]),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('CA_035_05 pedir un oficio manda el texto con sesión', () async {
    final api = ApiFalsa(
      (_) => jsonOk({'id': 'p-1', 'texto': 'Herrería'}, estado: 201),
    );
    await _contenedor(api)
        .read(detalleOficioRepositoryProvider)
        .pedirOficio('Herrería');
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'POST /api/v1/oficios-pedidos');
    expect(p.json, {'texto': 'Herrería'});
    expect(p.autorizacion, 'Bearer ${tokensA.accessToken}');
  });

  test('CA_035_03 un oficio que no existe es NoEncontradoFailure', () async {
    final c = _contenedor(ApiFalsa((_) => http.Response('', 404)));
    await expectLater(
      c.read(detalleOficioRepositoryProvider).detalle('x'),
      throwsA(isA<NoEncontradoFailure>()),
    );
  });

  test(
    'CA_035_04 sin conexión devuelve la última copia con su fecha',
    () async {
      var falla = false;
      final c = _contenedor(
        ApiFalsa((_) => falla ? http.Response('', 503) : jsonOk(_detalle)),
      );
      final p = detalleOficioControllerProvider('plo');
      c.listen(p, (_, _) {});
      expect((await c.read(p.future)).copiaDel, isNull);
      falla = true;
      c.invalidate(p);
      final copia = await c.read(p.future);
      expect(copia.copiaDel, isNotNull);
      expect(copia.detalle.frasesSugeridas, ['Fuga en el baño']);
    },
  );

  testWidgets('CA_035_01 muestra las frases del servidor', (tester) async {
    final api = ApiFalsa((_) => jsonOk(_detalle));
    await _montar(tester, _contenedor(api));
    expect(find.text('Fuga en el baño'), findsOneWidget);
    expect(find.text('De ejemplo'), findsNothing);
    expect(api.llamadas, ['GET oficios/plo']);
  });

  testWidgets('CA_035_07 con error ofrece reintentar', (tester) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla ? http.Response('', 500) : jsonOk(_detalle),
    );
    await _montar(tester, _contenedor(api));
    falla = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Fuga en el baño'), findsOneWidget);
  });

  testWidgets('sin API se quedan las opciones de ejemplo', (tester) async {
    final api = ApiFalsa();
    await _montar(tester, _contenedor(api, activas: false));
    expect(find.text('De ejemplo'), findsOneWidget);
    expect(api.peticiones, isEmpty);
  });
}
