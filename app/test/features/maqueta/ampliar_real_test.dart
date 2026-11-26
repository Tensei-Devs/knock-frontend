// Spec 038: «Pedir también a otros» contra la API falsa.
import 'package:app/features/maqueta/ampliar_real.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

Future<void> _pedir(WidgetTester tester, ApiFalsa api) async {
  final c = contenedorConApi(api);
  addTearDown(c.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: AmpliarSolicitudReal(solicitudId: 's-1')),
      ),
    ),
  );
  await tester.tap(find.text('Pedir también a otros'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('CA_038_01 amplía la solicitud con sesión', (tester) async {
    final api = ApiFalsa((_) => jsonOk({'id': 's-1', 'estado': 'enviada'}));
    await _pedir(tester, api);
    expect(
      api.peticiones.single.llamadaCompleta,
      'POST /api/v1/solicitudes/s-1/ampliar',
    );
    expect(api.peticiones.single.autorizacion, 'Bearer ${tokensA.accessToken}');
    expect(find.textContaining('pedimos cotización'), findsOneWidget);
    expect(find.text('Pedir también a otros'), findsNothing);
  });

  for (final (estado, texto) in [
    (409, 'Esta solicitud ya no se puede ampliar.'),
    (404, 'Esta solicitud ya no está disponible.'),
  ]) {
    testWidgets('CA_038_03 un $estado lo explica', (tester) async {
      await _pedir(tester, ApiFalsa((_) => http.Response('', estado)));
      expect(find.text(texto), findsOneWidget);
      expect(find.text('Pedir también a otros'), findsOneWidget);
    });
  }
}
