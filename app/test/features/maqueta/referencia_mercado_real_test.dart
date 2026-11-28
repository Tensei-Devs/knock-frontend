// Spec 038, D-03 y enmienda 2026-11-27 (CA-F01, CA-F02, CA-06): la tarjeta
// de referencia de mercado dentro del formulario de cotizar. Solo datos
// ficticios.
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/maqueta/cotizar_real.dart';
import 'package:app/features/trabajo/data/cotizar_repository_api.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/cotizar_json.dart';
import '../../soporte/fecha_esperada.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/preparar_maqueta.dart';

const _ruta = 'cotizaciones/referencia-mercado';

/// El detalle, las listas y el envío responden bien; la referencia, según
/// [referencia].
ApiFalsa _api(http.Response Function() referencia) => ApiFalsa((p) {
  if (p.metodo == 'POST') return jsonOk(cotizacionJson(), estado: 201);
  if (p.ruta == _ruta) return referencia();
  if (p.ruta.startsWith('tecnicos/me/')) {
    return jsonOk({'items': <Object?>[], 'nextCursor': null});
  }
  return jsonOk(detalleJson());
});

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api, {
  Locale idioma = const Locale('es'),
}) async {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        tokensInicialesProvider.overrideWithValue(tokensA),
        relojCotizarProvider.overrideWithValue(() => DateTime(2026, 11, 26)),
        cotizarRepositoryProvider.overrideWithValue(
          CotizarRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: MaterialApp(
        locale: idioma,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(child: CotizarReal(solicitudId: 's1')),
        ),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

const _rango = r'Otros técnicos cobran de $300 a $600. Lo más común: $450.';

List<PeticionApi> _referencias(ApiFalsa api) =>
    api.peticiones.where((p) => p.ruta == _ruta).toList();

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_038_04 pide la referencia con la clave del oficio y el tipo '
      'elegido', (tester) async {
    final api = _api(() => jsonOk(referenciaJson()));
    await _montar(tester, api);

    expect(_referencias(api).single.url.queryParameters, {
      'oficio': 'plomeria',
      'tipoTrabajo': 'fijo',
    });

    await tester.tap(find.text('Rango'));
    await asentarMaqueta(tester);

    expect(_referencias(api).last.url.queryParameters['tipoTrabajo'], 'rango');
  });

  testWidgets('CA_038_F01 con mercado muestra el rango y «Usar este rango» '
      'llena el formulario sin enviar nada', (tester) async {
    final api = _api(() => jsonOk(referenciaJson()));
    await _montar(tester, api);

    expect(find.text('Referencia de mercado'), findsOneWidget);
    expect(find.text(_rango), findsOneWidget);
    expect(find.text('Referencia general del oficio.'), findsNothing);

    await tester.tap(find.text('Usar este rango'));
    await asentarMaqueta(tester);

    expect(find.text('300'), findsOneWidget);
    expect(find.text('600'), findsOneWidget);
    final rango = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Rango'),
    );
    expect(rango.selected, isTrue);
    expect(api.peticiones.where((p) => p.metodo == 'POST'), isEmpty);
  });

  testWidgets('CA_038_F01 con categoria antepone la referencia general', (
    tester,
  ) async {
    await _montar(
      tester,
      _api(() => jsonOk(referenciaJson(origen: 'categoria'))),
    );

    expect(find.text('Referencia general del oficio.'), findsOneWidget);
    expect(find.text(_rango), findsOneWidget);
    expect(find.text('Usar este rango'), findsOneWidget);
  });

  testWidgets('CA_038_F01 sin datos lo dice y no ofrece el rango', (
    tester,
  ) async {
    await _montar(tester, _api(() => jsonOk({'origen': 'sin_datos'})));

    expect(
      find.text('Todavía no hay suficientes datos para darte una referencia.'),
      findsOneWidget,
    );
    expect(find.text('Usar este rango'), findsNothing);
  });

  testWidgets('CA_038_F01 un rango sin amplitud no se ofrece', (tester) async {
    await _montar(
      tester,
      _api(() => jsonOk(referenciaJson(p25: 400, mediana: 400, p75: 400))),
    );

    expect(find.textContaining(r'de $400 a $400'), findsOneWidget);
    expect(find.text('Usar este rango'), findsNothing);
  });

  testWidgets('CA_038_F01 en inglés', (tester) async {
    await _montar(
      tester,
      _api(() => jsonOk(referenciaJson())),
      idioma: const Locale('en'),
    );

    expect(
      find.text(r'Other technicians charge $300 to $600. Most common: $450.'),
      findsOneWidget,
    );
    expect(find.text('Use this range'), findsOneWidget);
  });

  testWidgets('CA_038_F02 CA_038_06 con un 403 en la referencia se puede '
      'cotizar igual', (tester) async {
    final api = _api(() => http.Response('', 403));
    await _montar(tester, api);

    expect(find.text('Referencia de mercado'), findsOneWidget);
    expect(find.text('Usar este rango'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '350');
    await tester.tap(
      find.text(fechaEsperada(tester, CotizarReal, DateTime(2026, 11, 27))),
    );
    await tester.enterText(find.byType(TextField).last, '09:30');
    await tester.pump();
    await tester.tap(find.text('Enviar cotización'));
    await asentarMaqueta(tester);

    expect(api.peticiones.where((p) => p.metodo == 'POST').length, 1);
  });
}
