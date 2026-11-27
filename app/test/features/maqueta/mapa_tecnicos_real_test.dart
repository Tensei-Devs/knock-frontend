// Spec 036 (CA-13, CA-15, CA-51) y filtros de TEC-02: el mapa real de Inicio
// pide la zona visible, pinta grupos y abre el perfil de un técnico solo.
import 'dart:convert';

import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/lista_tecnicos_reales.dart';
import 'package:app/features/maqueta/mapa_google.dart';
import 'package:app/features/tecnico/data/buscar_tecnicos_repository_api.dart';
import 'package:app/features/tecnico/data/perfil_publico_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/preparar_maqueta.dart';

const _url = 'https://api.knock.test';

final _limites = LatLngBounds(
  southwest: const LatLng(20.01234567, -99.4),
  northeast: const LatLng(20.1, -99.3),
);

http.Response _json(Object cuerpo, [int estado = 200]) =>
    http.Response(jsonEncode(cuerpo), estado);

void main() {
  prepararPruebasDeMaqueta();

  test('CA_036_13 redondea la zona y limita el zoom', () {
    final consulta = consultaDeVista(_limites, 21.4, 'plo');
    expect(consulta, (
      norte: '20.1000',
      sur: '20.0123',
      este: '-99.3000',
      oeste: '-99.4000',
      zoom: '20',
      oficio: 'plo',
    ));
  });

  testWidgets('CA_036_51 pide la zona, reintenta y pinta los grupos', (
    tester,
  ) async {
    final zonas = <Uri>[];
    var falla = true;
    final cliente = MockClient((r) async {
      if (r.url.path.endsWith('/mapa/tecnicos')) {
        zonas.add(r.url);
        if (falla) return _json({}, 422);
        return _json({
          'grupos': [
            {
              'latitud': 20.05,
              'longitud': -99.34,
              'cantidad': 4,
              'tecnicoId': null,
            },
          ],
        });
      }
      return _json({'tecnicos': <Object>[], 'nextCursor': null});
    });
    final container = await montarApp(
      tester,
      esTecnico: false,
      maqueta: true,
      extra: [
        solicitudesRealesActivasProvider.overrideWithValue(true),
        buscarTecnicosRepositoryProvider.overrideWithValue(
          BuscarTecnicosRepositoryApi(transporte: cliente, url: _url),
        ),
        perfilPublicoRepositoryProvider.overrideWithValue(
          PerfilPublicoRepositoryApi(transporte: cliente, url: _url),
        ),
      ],
    );
    container.read(appRouterProvider).go('/inicio');
    await asentarMaqueta(tester);

    MapaGoogleKnock mapa() =>
        tester.widget<MapaGoogleKnock>(find.byType(MapaGoogleKnock));
    mapa().alMoverCamara!(_limites, 13.5);
    await asentarMaqueta(tester);
    expect(zonas.single.queryParameters['norte'], '20.1000');
    expect(zonas.single.queryParameters['zoom'], '14');
    expect(
      find.text('No pudimos cargar los expertos del mapa.'),
      findsOneWidget,
    );

    falla = false;
    await tester.ensureVisible(find.text('Reintentar').first);
    await tester.tap(find.text('Reintentar').first);
    await asentarMaqueta(tester);
    expect(mapa().grupos.single.cantidad, 4);
    expect(find.text('No pudimos cargar los expertos del mapa.'), findsNothing);
  });

  testWidgets('filtra por orden y radio solo con ubicación', (tester) async {
    final peticiones = <Uri>[];
    final cliente = MockClient((r) async {
      peticiones.add(r.url);
      return _json({'tecnicos': <Object>[], 'nextCursor': null});
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          buscarTecnicosRepositoryProvider.overrideWithValue(
            BuscarTecnicosRepositoryApi(transporte: cliente, url: _url),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ListaTecnicosReales(ubicacion: (lat: 20.05, lng: -99.34)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(peticiones.last.queryParameters.containsKey('lat'), isFalse);

    await tester.tap(find.text('Hasta 5 km'));
    await tester.pumpAndSettle();
    expect(peticiones.last.queryParameters['radioKm'], '5');
    expect(peticiones.last.queryParameters['lat'], '20.05');

    await tester.tap(find.text('Más cercanos'));
    await tester.pumpAndSettle();
    expect(peticiones.last.queryParameters['orden'], 'distancia');
  });
}
