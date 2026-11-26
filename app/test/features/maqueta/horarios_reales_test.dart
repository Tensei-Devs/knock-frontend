// Spec 036 y 045: los horarios de «Tu perfil público» con datos reales. Solo
// datos ficticios.
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/maqueta/horarios_reales.dart';
import 'package:app/features/tecnico/data/horarios_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/horarios_json.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api, {
  bool real = true,
}) async {
  fijarPantalla(tester, tamano: tamanoMovil);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        solicitudesRealesActivasProvider.overrideWithValue(real),
        horariosRepositoryProvider.overrideWithValue(
          HorariosRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: HorariosSegunSesion(ejemplo: Text('de ejemplo')),
          ),
        ),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('sin sesión o sin API se ve el ejemplo y no se llama nada', (
    tester,
  ) async {
    final api = ApiFalsa();
    await _montar(tester, api, real: false);

    expect(find.text('de ejemplo'), findsOneWidget);
    expect(api.peticiones, isEmpty);
  });

  testWidgets('CA_036_54 error con Reintentar y después los siete días', (
    tester,
  ) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla ? http.Response('', 503) : jsonOk(semanaJson()),
    );
    await _montar(tester, api);
    expect(find.text('No pudimos cargar tus horarios.'), findsOneWidget);

    falla = false;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);

    expect(find.text('Lunes'), findsOneWidget);
    expect(find.text('10:00 a 18:00'), findsOneWidget);
    expect(find.textContaining('aún no se puede abrir'), findsOneWidget);
  });

  testWidgets('CA_036_54 sin perfil de técnico y semana vacía', (tester) async {
    var estado = 404;
    final api = ApiFalsa(
      (_) => estado == 404
          ? http.Response('', 404)
          : jsonOk({'horarios': <Object?>[]}),
    );
    await _montar(tester, api);
    expect(find.text('No encontramos tu perfil de técnico.'), findsOneWidget);

    estado = 200;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);
    expect(find.text('Aún no hay horarios.'), findsOneWidget);
  });

  testWidgets('CA_036_38 CA_036_59 abrir un día lo guarda con las horas de la '
      'maqueta y el control mide 48 dp', (tester) async {
    final semantica = tester.ensureSemantics();
    final api = ApiFalsa(
      (p) => p.metodo == 'GET' ? jsonOk(semanaJson()) : jsonOk(p.json),
    );
    await _montar(tester, api);

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await tester.tap(find.byKey(const ValueKey('horario-martes')));
    await asentarMaqueta(tester);

    expect(api.llamadas.last, 'PUT tecnicos/me/horarios');
    expect(find.text('08:00 a 19:00'), findsOneWidget);
    semantica.dispose();
  });

  testWidgets('un fallo al guardar deja el día como estaba', (tester) async {
    final api = ApiFalsa(
      (p) => p.metodo == 'GET' ? jsonOk(semanaJson()) : http.Response('', 503),
    );
    await _montar(tester, api);

    await tester.tap(find.byKey(const ValueKey('horario-lunes')));
    await asentarMaqueta(tester);

    expect(api.llamadas.last, 'PUT tecnicos/me/horarios');
    expect(find.text('10:00 a 18:00'), findsOneWidget);
  });
}
