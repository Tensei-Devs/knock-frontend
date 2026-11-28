// Spec 019 (CA-D01) y 036 (CA-33 y CA-35): «Disponible hoy» contra la API
// falsa.
import 'dart:async';

import 'package:app/features/maqueta/disponible_hoy_real.dart';
import 'package:app/features/tecnico/data/disponible_hoy_repository_api.dart';
import 'package:app/features/tecnico/data/horarios_repository_api.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

Future<void> _montar(WidgetTester tester, ApiFalsa api) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        disponibleHoyRepositoryProvider.overrideWithValue(
          DisponibleHoyRepositoryApi(
            transporte: api.transporte,
            url: urlApiPrueba,
          ),
        ),
        horariosRepositoryProvider.overrideWithValue(
          HorariosRepositoryApi(transporte: api.transporte, url: urlApiPrueba),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: DisponibleHoyReal())),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

http.Response _resumen() => jsonOk({'disponibleHoy': false});

SwitchListTile _interruptor(WidgetTester tester) =>
    tester.widget<SwitchListTile>(find.byType(SwitchListTile));

Iterable<PeticionApi> _escrituras(ApiFalsa api) =>
    api.peticiones.where((p) => p.metodo == 'PUT');

void main() {
  testWidgets('CA_019_D01 muestra el valor que responde el servidor', (
    tester,
  ) async {
    final respuesta = Completer<http.Response>();
    final api = ApiFalsa((p) {
      if (p.metodo == 'PUT') return respuesta.future;
      return _resumen();
    });
    await _montar(tester, api);
    expect(_interruptor(tester).value, isFalse);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(_interruptor(tester).onChanged, isNull);
    await tester.tap(find.byType(Switch));
    respuesta.complete(
      jsonOk({
        'disponibleHoy': true,
        'disponibleHasta': '2026-11-28T05:59:59Z',
      }),
    );
    await tester.pumpAndSettle();
    expect(_interruptor(tester).value, isTrue);
    final p = _escrituras(api).single;
    expect(p.ruta, 'tecnicos/me/disponibilidad');
    expect(p.json, {'disponibleHoy': true});
  });

  for (final (estado, texto) in [
    (403, 'No tienes permiso'),
    (422, 'Revisa los datos'),
    (429, 'demasiados intentos'),
    (500, 'No pudimos conectar'),
  ]) {
    testWidgets('CA_036_35 un $estado conserva el valor', (tester) async {
      final api = ApiFalsa(
        (p) => p.metodo == 'PUT' ? http.Response('', estado) : _resumen(),
      );
      await _montar(tester, api);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(_interruptor(tester).value, isFalse);
      expect(find.textContaining(texto, findRichText: true), findsOneWidget);
      expect(_escrituras(api), hasLength(1));
    });
  }

  testWidgets('CA_019_D01 sin red conserva el valor', (tester) async {
    final api = ApiFalsa((p) {
      if (p.metodo == 'PUT') throw http.ClientException('sin red');
      return _resumen();
    });
    await _montar(tester, api);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(_interruptor(tester).value, isFalse);
    expect(_escrituras(api), hasLength(1));
  });

  testWidgets('CA_019_D01 si el resumen falla deja reintentar', (tester) async {
    var cargas = 0;
    final api = ApiFalsa(
      (_) => ++cargas == 1 ? http.Response('', 503) : _resumen(),
    );
    await _montar(tester, api);
    expect(find.byType(SwitchListTile), findsNothing);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.byType(SwitchListTile), findsOneWidget);
  });
}
