import 'package:app/features/maqueta/lista_tecnicos_reales.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/mapa_google.dart';
import 'package:app/features/maqueta/datos.dart' show provs;
import 'package:app/features/tecnico/data/buscar_tecnicos_repository_api.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:go_router/go_router.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/preparar_maqueta.dart';

Future<void> _montar(WidgetTester tester, http.Client cliente) =>
    tester.pumpWidget(
      ProviderScope(
        overrides: [
          buscarTecnicosRepositoryProvider.overrideWithValue(
            BuscarTecnicosRepositoryApi(
              transporte: cliente,
              url: 'https://example.test',
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ListaTecnicosReales(oficio: 'plo'),
            ),
          ),
        ),
      ),
    );

void main() {
  prepararPruebasDeMaqueta();
  testWidgets('lista, filtra verificados y muestra vacío', (tester) async {
    final peticiones = <Uri>[];
    final cliente = MockClient((r) async {
      peticiones.add(r.url);
      if (r.url.queryParameters['soloVerificados'] == 'true') {
        return http.Response('{"tecnicos":[],"nextCursor":null}', 200);
      }
      return http.Response(
        '{"tecnicos":[{"id":"t1","nombre":"Ana","verificacion":"basica",'
        '"oficios":["plo"],"nombreNegocio":null,"fotoUrl":null,'
        '"calificacion":null,"anios":null,"descripcionCorta":null,"detalle":null}],'
        '"nextCursor":null}',
        200,
      );
    });
    await _montar(tester, cliente);
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
    expect(peticiones.last.queryParameters['oficio'], 'plo');
    await tester.tap(find.text('Solo verificados'));
    await tester.pumpAndSettle();
    expect(peticiones.last.queryParameters['soloVerificados'], 'true');
    expect(find.text('Ana'), findsNothing);
    expect(
      find.text('No encontramos expertos con esa búsqueda.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Disponible hoy'));
    await tester.pumpAndSettle();
    expect(peticiones.last.queryParameters['disponibleHoy'], 'true');
    expect(peticiones.last.queryParameters['soloVerificados'], 'true');
  });

  testWidgets('reintenta el error y carga la página siguiente', (tester) async {
    var falla = true;
    final cliente = MockClient((r) async {
      if (falla) return http.Response('', 503);
      final cursor = r.url.queryParameters['cursor'];
      return http.Response(
        '{"tecnicos":[{"id":"${cursor == null ? 't1' : 't2'}",'
        '"nombre":"${cursor == null ? 'Ana' : 'Luis'}","verificacion":"basica",'
        '"oficios":["plo"],"nombreNegocio":null,"fotoUrl":null,'
        '"calificacion":null,"anios":null,"descripcionCorta":null,"detalle":null}],'
        '"nextCursor":${cursor == null ? '"c2"' : 'null'}}',
        200,
      );
    });
    await _montar(tester, cliente);
    await tester.pumpAndSettle();
    expect(
      find.text(
        'La búsqueda no está disponible en este momento. Intenta de nuevo.',
      ),
      findsOneWidget,
    );
    falla = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
    await tester.tap(find.text('Ver más'));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Luis'), findsOneWidget);
  });

  testWidgets('Inicio usa la lista real y no ubica técnicos de ejemplo', (
    tester,
  ) async {
    final cliente = MockClient(
      (_) async => http.Response('{"tecnicos":[],"nextCursor":null}', 200),
    );
    final container = await montarApp(
      tester,
      esTecnico: false,
      maqueta: true,
      extra: [
        solicitudesRealesActivasProvider.overrideWithValue(true),
        buscarTecnicosRepositoryProvider.overrideWithValue(
          BuscarTecnicosRepositoryApi(
            transporte: cliente,
            url: 'https://example.test',
          ),
        ),
      ],
    );
    container.read(appRouterProvider).go('/inicio');
    await asentarMaqueta(tester);
    expect(find.byType(ListaTecnicosReales), findsOneWidget);
    expect(
      tester.widget<MapaGoogleKnock>(find.byType(MapaGoogleKnock)).expertos,
      isEmpty,
    );
    expect(find.text('Cargando expertos en el mapa…'), findsOneWidget);
  });

  testWidgets('una tarjeta abre el perfil con el id real', (tester) async {
    final cliente = MockClient(
      (_) async => http.Response(
        '{"tecnicos":[{"id":"t1","nombre":"Ana","verificacion":"basica",'
        '"oficios":["plo"],"nombreNegocio":null,"fotoUrl":null,'
        '"calificacion":null,"anios":null,"descripcionCorta":null,"detalle":null}],'
        '"nextCursor":null}',
        200,
      ),
    );
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(
            body: SingleChildScrollView(child: ListaTecnicosReales()),
          ),
        ),
        GoRoute(
          path: '/m/experto/:id',
          builder: (_, state) =>
              Scaffold(body: Text('perfil ${state.pathParameters['id']}')),
        ),
      ],
    );
    addTearDown(router.dispose);
    addTearDown(() => provs.remove('api:t1'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          buscarTecnicosRepositoryProvider.overrideWithValue(
            BuscarTecnicosRepositoryApi(
              transporte: cliente,
              url: 'https://example.test',
            ),
          ),
        ],
        child: MaterialApp.router(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ana'));
    await tester.pumpAndSettle();
    expect(find.text('perfil api:t1'), findsOneWidget);
  });
}
