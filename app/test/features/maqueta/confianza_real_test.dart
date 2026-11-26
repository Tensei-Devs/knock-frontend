// Spec 032 y 045: «Mis técnicos de confianza» y el botón «Guardar» con datos
// reales: estados, páginas sin repetir, guardar, quitar y errores. Solo datos
// ficticios.
import 'package:app/features/maqueta/confianza_real.dart';
import 'package:app/features/tecnicos_confianza/data/tecnicos_confianza_repository_api.dart';
import 'package:app/features/tecnicos_confianza/tecnicos_confianza.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/preparar_maqueta.dart';

const _a = 'a0a0a0a0a0a0a0a0a0a0a0a0';
const _b = 'b0b0b0b0b0b0b0b0b0b0b0b0';

Map<String, Object?> _tecnico(String id, String nombre) => {
  'tecnicoId': id,
  'nombre': nombre,
  'fotoUrl': null,
  'nivelVerificacion': 'sin_verificar',
  'guardadoEn': '2026-11-20T18:00:00Z',
};

Future<void> _montar(WidgetTester tester, ApiFalsa api, Widget hijo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        tecnicosConfianzaRepositoryProvider.overrideWithValue(
          TecnicosConfianzaRepositoryApi(
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

  test('solo un técnico real tiene id del servidor', () {
    expect(idDeTecnicoReal('api:$_a'), _a);
    expect(idDeTecnicoReal('tr'), isNull);
    expect(idDeTecnicoReal('api:visita:$_a'), isNull);
    expect(idDeTecnicoReal('api:'), isNull);
  });

  testWidgets('CA_032_10 vacío, y error con Reintentar', (tester) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla
          ? http.Response('', 503)
          : jsonOk({'items': <Object?>[], 'nextCursor': null}),
    );
    await _montar(tester, api, const ConfianzaReal());
    expect(find.textContaining('No pudimos cargar'), findsOneWidget);

    falla = false;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);

    expect(find.textContaining('Aún no guardas a nadie'), findsOneWidget);
  });

  testWidgets('CA_032_03 pide la página siguiente con el cursor y no repite', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.url.queryParameters['cursor'] == null
          ? jsonOk({
              'items': [_tecnico(_a, 'Persona Uno')],
              'nextCursor': 'c1',
            })
          : jsonOk({
              'items': [
                _tecnico(_a, 'Persona Uno'),
                _tecnico(_b, 'Persona Dos'),
              ],
              'nextCursor': null,
            }),
    );
    await _montar(tester, api, const ConfianzaReal());

    await tester.tap(find.text('Ver más'));
    await asentarMaqueta(tester);

    expect(find.text('Persona Uno'), findsOneWidget);
    expect(find.text('Persona Dos'), findsOneWidget);
    expect(find.text('Ver más'), findsNothing);
    expect(api.peticiones.last.url.queryParameters['cursor'], 'c1');
  });

  testWidgets('CA_032_07 quitar llama a DELETE y saca al técnico', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.metodo == 'DELETE'
          ? http.Response('', 204)
          : jsonOk({
              'items': [_tecnico(_a, 'Persona Uno')],
              'nextCursor': null,
            }),
    );
    await _montar(tester, api, const ConfianzaReal());

    await tester.tap(find.text('Quitar'));
    await asentarMaqueta(tester);

    expect(api.llamadas.last, 'DELETE me/tecnicos-confianza/$_a');
    expect(find.text('Persona Uno'), findsNothing);
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('CA_032_04 y CA_032_06 «Guardar» hace PUT; si el técnico ya no '
      'existe no lo marca', (tester) async {
    var existe = true;
    final api = ApiFalsa((p) {
      if (p.metodo == 'PUT') {
        return existe
            ? jsonOk(_tecnico(_a, 'Persona Uno'), estado: 201)
            : jsonOk({'code': 'technician_not_found'}, estado: 404);
      }
      if (p.metodo == 'DELETE') return http.Response('', 204);
      return jsonOk({'items': <Object?>[], 'nextCursor': null});
    });
    await _montar(
      tester,
      api,
      const GuardarTecnicoReal(tecnicoId: _a, destino: '/m'),
    );

    await tester.tap(find.text('Guardar'));
    await asentarMaqueta(tester);
    expect(api.llamadas.last, 'PUT me/tecnicos-confianza/$_a');
    expect(find.text('Guardado'), findsOneWidget);

    await tester.tap(find.text('Guardado'));
    await asentarMaqueta(tester);
    existe = false;
    await tester.tap(find.text('Guardar'));
    await asentarMaqueta(tester);

    expect(find.text('Guardado'), findsNothing);
    await tester.pump(const Duration(seconds: 10));
  });
}
