// Spec 034 y 045: «Avisos» y «Qué avisos recibir» con datos reales. Solo datos
// ficticios.
import 'package:app/features/bandeja_avisos/bandeja_avisos.dart';
import 'package:app/features/bandeja_avisos/data/bandeja_avisos_repository_api.dart';
import 'package:app/features/maqueta/avisos_reales.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/preparar_maqueta.dart';

Map<String, Object?> _aviso(String id, {bool leido = false}) => {
  'id': id,
  'tipo': 'cotizaciones',
  'comoRol': 'cliente',
  'titulo': 'Aviso $id',
  'texto': 'Texto de ejemplo',
  'destino': {'campoSinContrato': 'x'},
  'leido': leido,
  'creadoEn': '2026-11-20T18:00:00Z',
};

Map<String, Object?> _preferencias({bool promociones = false}) => {
  'tipos': [
    {'tipo': 'seguridad', 'activo': true, 'apagable': false},
    {'tipo': 'promociones', 'activo': promociones, 'apagable': true},
    {'tipo': 'un_tipo_nuevo', 'activo': true, 'apagable': false},
  ],
};

Future<void> _montar(WidgetTester tester, ApiFalsa api, Widget hijo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        bandejaAvisosRepositoryProvider.overrideWithValue(
          BandejaAvisosRepositoryApi(
            transporte: api.cliente,
            url: urlApiPrueba,
          ),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: hijo)),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_034_13 error con Reintentar y después vacío', (tester) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla
          ? http.Response('', 503)
          : jsonOk({'items': <Object?>[], 'siguienteCursor': null}),
    );
    await _montar(tester, api, const AvisosReales());
    expect(find.textContaining('No pudimos cargar'), findsOneWidget);

    falla = false;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);

    expect(find.textContaining('Sin avisos por ahora'), findsOneWidget);
  });

  testWidgets('CA_034_03 pagina sin repetir y marca leídos uno y todos', (
    tester,
  ) async {
    final api = ApiFalsa((p) {
      if (p.metodo == 'POST') return http.Response('', 204);
      return p.url.queryParameters['cursor'] == null
          ? jsonOk({
              'items': [_aviso('1')],
              'siguienteCursor': 'c1',
            })
          : jsonOk({
              'items': [_aviso('1'), _aviso('2'), _aviso('3')],
              'siguienteCursor': null,
            });
    });
    await _montar(tester, api, const AvisosReales());
    await tester.tap(find.text('Ver más'));
    await asentarMaqueta(tester);
    expect(find.text('Aviso 1'), findsOneWidget);
    expect(find.text('Nuevo'), findsNWidgets(3));

    await tester.tap(find.text('Aviso 1'));
    await asentarMaqueta(tester);
    expect(api.llamadas.last, 'POST avisos/1/leido');
    expect(find.text('Nuevo'), findsNWidgets(2));

    await tester.tap(find.text('Marcar leídos'));
    await asentarMaqueta(tester);
    expect(api.llamadas.last, 'POST avisos/leidos');
    expect(find.text('Nuevo'), findsNothing);
  });

  testWidgets('CA_034_08 un aviso que ya no existe sale de la lista', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.metodo == 'POST'
          ? jsonOk({'code': 'notice_not_found'}, estado: 404)
          : jsonOk({
              'items': [_aviso('1')],
              'siguienteCursor': null,
            }),
    );
    await _montar(tester, api, const AvisosReales());

    await tester.tap(find.text('Aviso 1'));
    await asentarMaqueta(tester);

    expect(find.text('Aviso 1'), findsNothing);
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('CA_034_17 muestra los interruptores del servidor; el fijo no '
      'envía nada y el otro cambia al confirmarse', (tester) async {
    final api = ApiFalsa(
      (p) => jsonOk(_preferencias(promociones: p.metodo == 'PUT')),
    );
    await _montar(tester, api, const PreferenciasDeAvisosReales());
    expect(find.text('Seguridad'), findsOneWidget);
    expect(find.text('Otros avisos'), findsOneWidget);
    expect(find.text('Siempre activo'), findsNWidgets(2));
    final interruptores = find.byWidgetPredicate(
      (w) => w.runtimeType.toString() == 'Sw',
    );

    await tester.tap(interruptores.first, warnIfMissed: false);
    await asentarMaqueta(tester);
    expect(api.peticiones.where((p) => p.metodo == 'PUT'), isEmpty);

    await tester.tap(interruptores.at(1));
    await asentarMaqueta(tester);

    final put = api.peticiones.singleWhere((p) => p.metodo == 'PUT');
    expect(put.ruta, 'me/preferencias-avisos');
    expect(put.json, {
      'tipos': [
        {'tipo': 'promociones', 'activo': true},
      ],
    });
  });
}
