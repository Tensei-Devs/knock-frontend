// Spec 039, lado cliente: cotización final y ajustes de precio contra la API
// falsa (repositorio y controlador) y la tarjeta con sus decisiones.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/precio_de_visita_real.dart';
import 'package:app/features/visita/visita.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

const _id = 'c1c1c1c1c1c1c1c1c1c1c1c1';

Map<String, Object?> _final([String estado = 'enviada']) => {
  'visitaId': _id,
  'precio': 850,
  'descripcion': 'Cambiar la tubería',
  'estado': estado,
  'venceEn': '2026-11-28T18:00:00Z',
  'decididaEn': null,
};

final _ajustes = {
  'items': [
    {
      'id': 'a-1',
      'cotizacionId': 'q-1',
      'montoNuevo': '600',
      'motivo': 'Falta una pieza',
      'estado': 'pendiente',
      'venceEn': '2026-11-27T18:00:00Z',
    },
  ],
};

ApiFalsa _api({
  http.Response Function()? cotizacion,
  Map<String, Object?>? ajustes,
  int decision = 200,
}) => ApiFalsa((p) {
  if (p.metodo == 'POST') {
    return jsonOk({'estado': 'aprobada'}, estado: decision);
  }
  if (p.ruta.endsWith('cotizacion-final')) {
    return cotizacion?.call() ?? jsonOk(_final());
  }
  return jsonOk(ajustes ?? {'items': <Object>[]});
});

ProviderContainer _contenedor(ApiFalsa api, {bool sesion = true}) {
  final c = contenedorConApi(api, tokens: sesion ? tokensA : null);
  addTearDown(c.dispose);
  return c;
}

Future<PrecioDeVisita> _cargar(ProviderContainer c) {
  final p = precioDeVisitaControllerProvider(_id);
  c.listen(p, (_, _) {});
  return c.read(p.future);
}

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api, {
  Locale idioma = const Locale('es'),
}) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: _contenedor(api),
      child: MaterialApp(
        locale: idioma,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(child: PrecioDeVisitaReal(visitaId: _id)),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tocar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto).first);
  await tester.tap(find.text(texto).first);
  await tester.pumpAndSettle();
}

void main() {
  test('CA_039_04 lee la cotización final y los ajustes con sesión', () async {
    final api = _api(ajustes: _ajustes);
    final r = await _cargar(_contenedor(api));
    expect(r.cotizacionFinal!.precio, 850);
    expect(r.cotizacionFinal!.porDecidir, isTrue);
    expect(r.ajustes.single.montoNuevo, 600);
    expect(api.llamadas, [
      'GET visitas/$_id/cotizacion-final',
      'GET visitas/$_id/ajustes-pendientes',
    ]);
    expect(
      api.peticiones.map((p) => p.autorizacion),
      everyElement('Bearer ${tokensA.accessToken}'),
    );
  });

  test('sin cotización final (404) queda en nulo', () async {
    final api = _api(cotizacion: () => http.Response('', 404));
    final r = await _cargar(_contenedor(api));
    expect(r.cotizacionFinal, isNull);
  });

  test('sin sesión no pide nada', () async {
    final api = _api();
    final r = await _cargar(_contenedor(api, sesion: false));
    expect(r.cotizacionFinal, isNull);
    expect(api.peticiones, isEmpty);
  });

  test('CA_039_10 las decisiones mandan aprueba o rechaza', () async {
    final api = _api();
    final repo = _contenedor(api).read(precioDeVisitaRepositoryProvider);
    await repo.decidirCotizacionFinal(_id, aprueba: false);
    await repo.decidirAjuste('a-1', aprueba: true);
    expect(api.peticiones.map((p) => p.llamadaCompleta), [
      'POST /api/v1/visitas/$_id/cotizacion-final/decision',
      'POST /api/v1/ajustes/a-1/decision',
    ]);
    expect(api.peticiones.map((p) => p.json), [
      {'decision': 'rechaza'},
      {'decision': 'aprueba'},
    ]);
  });

  for (final (estado, falla) in [
    (404, isA<NoEncontradoFailure>()),
    (409, isA<ConflictoFailure>()),
    (403, isA<AccesoDenegadoFailure>()),
  ]) {
    test('CA_039_12 una decisión con $estado falla con su tipo', () async {
      final repo = _contenedor(_api(decision: estado))
          .read(precioDeVisitaRepositoryProvider);
      await expectLater(
        repo.decidirAjuste('a-1', aprueba: true),
        throwsA(falla),
      );
    });
  }

  testWidgets('CA_039_16 aprueba la cotización final y la vuelve a pedir', (
    tester,
  ) async {
    var estado = 'enviada';
    final api = _api(cotizacion: () => jsonOk(_final(estado)));
    await _montar(tester, api);
    expect(find.text(r'$850'), findsOneWidget);
    expect(find.text('Cambiar la tubería'), findsOneWidget);
    estado = 'aprobada';
    await _tocar(tester, 'Aprobar');
    expect(find.text('Aprobaste la cotización final.'), findsOneWidget);
    expect(find.text('Aprobar'), findsNothing);
    expect(api.llamadas.where((l) => l.startsWith('POST')), hasLength(1));
  });

  testWidgets('CA_039_18 un 409 en el ajuste lo explica y deja actualizar', (
    tester,
  ) async {
    final api = _api(
      cotizacion: () => http.Response('', 404),
      ajustes: _ajustes,
      decision: 409,
    );
    await _montar(tester, api);
    expect(find.text('Falta una pieza'), findsOneWidget);
    await _tocar(tester, 'Rechazar');
    expect(
      find.text('Este cambio de precio ya se decidió o venció.'),
      findsOneWidget,
    );
    final antes = api.peticiones.length;
    await _tocar(tester, 'Actualizar');
    expect(api.peticiones.length, antes + 2);
  });

  testWidgets('CA_039_16 con un error ofrece actualizar', (tester) async {
    var falla = true;
    final api = _api(
      cotizacion: () => falla ? http.Response('', 500) : jsonOk(_final()),
    );
    await _montar(tester, api);
    expect(find.text('Aprobar'), findsNothing);
    falla = false;
    await _tocar(tester, 'Actualizar');
    expect(find.text('Aprobar'), findsOneWidget);
  });

  testWidgets('CA_039_19 en inglés usa el ARB', (tester) async {
    await _montar(tester, _api(), idioma: const Locale('en'));
    expect(find.text('Final quote'), findsOneWidget);
    expect(find.text('Approve'), findsOneWidget);
  });
}
