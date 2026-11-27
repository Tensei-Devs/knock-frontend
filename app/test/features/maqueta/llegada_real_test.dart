// Spec 016 (CA-10 a CA-14 y CA-20): «Confirmar llegada» contra la API falsa.
import 'package:app/features/maqueta/llegada_real.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/trabajo/data/llegada_repository_api.dart';
import 'package:app/features/trabajo/llegada_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/llegada_json.dart';
import '../../soporte/montar_cuerpo_real.dart';

Future<void> _montar(WidgetTester tester, ApiFalsa api) {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  return montarCuerpoReal(
    tester,
    llegadaRepositoryProvider.overrideWithValue(
      LlegadaRepositoryApi(transporte: api.transporte, url: urlApiPrueba),
    ),
    const LlegadaReal(visitaId: visitaDeLlegadaId),
  );
}

ApiFalsa _apiQueResponde(http.Response Function() alConfirmar) => ApiFalsa(
  (p) => p.metodo == 'POST' ? alConfirmar() : jsonOk(visitaTecnicoJson()),
);

Future<void> _confirmar(WidgetTester tester, String codigo) async {
  await tester.enterText(find.byType(TextField), codigo);
  await tester.tap(find.text('Ya llegué'));
  await tester.pumpAndSettle();
}

BtnK _boton(WidgetTester tester) =>
    tester.widget<BtnK>(find.widgetWithText(BtnK, 'Ya llegué'));

void main() {
  testWidgets('CA_016_10 confirma y muestra la visita en curso', (
    tester,
  ) async {
    final api = _apiQueResponde(
      () => jsonOk(visitaTecnicoJson(estado: 'en_curso', puedeLlegar: false)),
    );
    await _montar(tester, api);
    expect(find.text('Centro'), findsOneWidget);
    await _confirmar(tester, '4821');
    expect(
      find.textContaining('Llegada confirmada', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Terminar servicio'), findsOneWidget);
    expect(find.textContaining('4821'), findsNothing);
  });

  testWidgets('CA_016_11 código incorrecto con intentos restantes', (
    tester,
  ) async {
    final api = _apiQueResponde(
      () => problemaJson(422, 'wrong_code', {'intentosRestantes': 2}),
    );
    await _montar(tester, api);
    await _confirmar(tester, '1111');
    expect(
      find.textContaining('Te quedan 2 intentos', findRichText: true),
      findsOneWidget,
    );
    expect(_boton(tester).onTap, isNotNull);
  });

  for (final (estado, codigo, texto) in [
    (409, 'visit_locked', 'Esta visita quedó bloqueada'),
    (409, 'code_used', 'Este código ya se usó.'),
    (409, 'code_expired', 'El código de esta visita ya venció.'),
    (409, 'visit_cancelled', 'Esta visita se canceló.'),
    (409, 'visit_not_active', 'Esta visita ya no está vigente.'),
    (409, 'visit_without_code', 'Esta cita es en el taller'),
    (409, 'outside_window', 'desde las 00:00.'),
    (403, 'not_a_technician', 'Solo el técnico de la visita'),
  ]) {
    testWidgets('CA_016_13 $codigo se explica sin códigos', (tester) async {
      await _montar(
        tester,
        _apiQueResponde(() => problemaJson(estado, codigo)),
      );
      await _confirmar(tester, '4821');
      expect(find.textContaining(texto, findRichText: true), findsOneWidget);
      expect(find.textContaining('$estado'), findsNothing);
      expect(_boton(tester).onTap, isNull);
    });
  }

  testWidgets('CA_016_15 un 429 dice cuánto esperar', (tester) async {
    final api = _apiQueResponde(
      () => http.Response('', 429, headers: {'retry-after': '60'}),
    );
    await _montar(tester, api);
    await _confirmar(tester, '4821');
    expect(
      find.textContaining('Hiciste muchos intentos.', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('CA_016_17 sin red avisa del reintento manual', (tester) async {
    final api = _apiQueResponde(() => throw http.ClientException('sin red'));
    await _montar(tester, api);
    await _confirmar(tester, '4821');
    expect(
      find.textContaining('este reintento cuenta', findRichText: true),
      findsOneWidget,
    );
    expect(api.peticiones.where((p) => p.metodo == 'POST'), hasLength(1));
  });

  testWidgets('CA_016_20 sin puedeLlegar no llama a la llegada', (
    tester,
  ) async {
    final api = ApiFalsa((_) => jsonOk(visitaTecnicoJson(puedeLlegar: false)));
    await _montar(tester, api);
    expect(_boton(tester).onTap, isNull);
    expect(
      find.textContaining('el día de la cita', findRichText: true),
      findsOneWidget,
    );
    expect(api.peticiones.where((p) => p.metodo == 'POST'), isEmpty);
  });

  testWidgets('CA_016_13 una visita ajena ofrece reintentar', (tester) async {
    await _montar(tester, ApiFalsa((_) => http.Response('', 404)));
    expect(
      find.textContaining('ya no está disponible', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
