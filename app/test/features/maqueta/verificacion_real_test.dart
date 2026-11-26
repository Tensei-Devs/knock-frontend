// Spec 018: estado de mi verificación contra la API falsa (repositorio,
// controlador y pantalla). Solo datos ficticios.
import 'package:app/features/maqueta/verificacion_real.dart';
import 'package:app/features/verificacion/verificacion.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

Map<String, Object?> _estado(
  String estado, {
  String? motivo,
  List<String> consejos = const [],
  String? nivel,
}) => {
  'estado': estado,
  'motivo': motivo,
  'consejos': consejos,
  'nivelOtorgado': nivel,
  'fotos': <Object>[],
  'enviadoEn': estado == 'en_revision' ? '2026-11-20T18:00:00Z' : null,
  'puedeReintentar': true,
};

Future<void> _montar(WidgetTester tester, ApiFalsa api) async {
  final c = contenedorConApi(api);
  addTearDown(c.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(child: EstadoDeVerificacionReal()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('CA_018_08 pide el estado con sesión y sin sesión no', () async {
    final api = ApiFalsa((_) => jsonOk(_estado('en_revision')));
    for (final tokens in [tokensA, null]) {
      final c = contenedorConApi(api, tokens: tokens);
      addTearDown(c.dispose);
      c.listen(verificacionControllerProvider, (_, _) {});
      await c.read(verificacionControllerProvider.future);
    }
    expect(api.llamadas, ['GET me/verificacion']);
    expect(api.peticiones.single.autorizacion, 'Bearer ${tokensA.accessToken}');
  });

  for (final (nombre, cuerpo, textos) in [
    (
      'CA_018_08 en revisión con su fecha',
      _estado('en_revision'),
      ['Revisamos en menos de 24 h', 'Enviada el'],
    ),
    (
      'CA_018_09 rechazada con motivo y consejos',
      _estado(
        'no_verificada',
        motivo: 'La foto se ve borrosa',
        consejos: ['Busca buena luz'],
      ),
      ['La foto se ve borrosa', 'Busca buena luz'],
    ),
    (
      'CA_018_10 verificada básica',
      _estado('verificada', nivel: 'basica'),
      ['Verificado: básica'],
    ),
    (
      'CA_018_11 fotos borradas es Sin verificar',
      _estado('sin_verificar', motivo: 'fotos_borradas'),
      ['Sin verificar', 'Tus fotos se borraron'],
    ),
  ]) {
    testWidgets(nombre, (tester) async {
      await _montar(tester, ApiFalsa((_) => jsonOk(cuerpo)));
      for (final t in textos) {
        expect(find.textContaining(t), findsOneWidget);
      }
    });
  }

  testWidgets('CA_018_15 con error ofrece reintentar', (tester) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla ? http.Response('', 500) : jsonOk(_estado('sin_verificar')),
    );
    await _montar(tester, api);
    expect(api.peticiones, hasLength(1), reason: 'no reintenta solo');
    falla = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Sin verificar'), findsOneWidget);
  });
}
