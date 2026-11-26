// Spec 033 (KNOCK-266): pantallas de bloqueos con la API. Solo datos ficticios.
import 'package:app/features/maqueta/bloqueos_reales.dart';
import 'package:app/features/maqueta/reportes_reales.dart';
import 'package:app/features/reportes/data/reportes_repository_api.dart';
import 'package:app/features/reportes/reportes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/accesibilidad.dart';
import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/reportes_json.dart';

ReportesRepositoryApi _repo(ApiFalsa api) =>
    ReportesRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

/// Monta una pantalla de bloqueos con sesión, repositorio falso e idioma.
Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api,
  Widget hijo, {
  Locale locale = const Locale('es'),
  double escalaDeTexto = 1.0,
}) async {
  tester.view.physicalSize = const Size(412, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        reportesRepositoryProvider.overrideWithValue(_repo(api)),
        bloqueosRepositoryProvider.overrideWithValue(_repo(api)),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(escalaDeTexto)),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.all(16), child: hijo),
          ),
        ),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

Future<void> _tocar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto));
  await asentarMaqueta(tester);
  await tester.tap(find.text(texto));
  await asentarMaqueta(tester);
}

/// Servidor de ejemplo: la visita dice a quién se bloquea, la lista responde
/// según [bloqueados] y desbloquear sale bien.
ApiFalsa _servidor(
  http.Response Function(PeticionApi) busqueda, {
  List<String> bloqueados = const [],
  String? cursor,
}) => ApiFalsa((p) {
  if (p.ruta == 'visitas/v-1') return jsonOk(visitaParaReportarJson('u-2'));
  if (p.metodo == 'DELETE') return http.Response('', 204);
  if (p.ruta == 'me/bloqueos') {
    return jsonOk(paginaDeBloqueadosJson(bloqueados, cursor));
  }
  return busqueda(p);
});

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_033_19 bloquear: error, datos, 409 y 404 con Reintentar', (
    tester,
  ) async {
    var fase = 0;
    final api = ApiFalsa((p) {
      if (p.ruta == 'visitas/v-1') {
        return fase == 0
            ? http.Response('', 503)
            : jsonOk(visitaParaReportarJson('u-2'));
      }
      if (p.metodo == 'POST' && p.ruta == 'usuarios/u-2/bloqueo') {
        return switch (fase) {
          1 => jsonOk({'code': 'already_blocked'}, estado: 409),
          2 => jsonOk({'code': 'user_not_found'}, estado: 404),
          _ => http.Response('', 201),
        };
      }
      return jsonOk(paginaDeBloqueadosJson([], null));
    });
    await _montar(
      tester,
      api,
      const BloquearReal(visitaId: 'v-1', trabajo: 'Trabajo de ejemplo'),
    );

    // Sin respuesta de la visita: Reintentar (CA-19, error).
    expect(find.text('Reintentar'), findsOneWidget);

    fase = 1;
    await _tocar(tester, 'Reintentar');
    expect(find.textContaining('Técnico de ejemplo'), findsOneWidget);

    // 409 `already_blocked`: el texto del catálogo y el botón sigue ahí.
    await _tocar(tester, 'Bloquear a esta persona');
    await _tocar(tester, 'Sí, bloquear');
    expect(find.text('Ya habías bloqueado a esta persona.'), findsOneWidget);
    expect(find.text('Bloquear a esta persona'), findsOneWidget);

    // 404: no se revela de quién se trata, solo que no está disponible.
    fase = 2;
    await _tocar(tester, 'Bloquear a esta persona');
    await _tocar(tester, 'Sí, bloquear');
    expect(find.text('Esa persona ya no está disponible.'), findsOneWidget);

    fase = 3;
    await _tocar(tester, 'Bloquear a esta persona');
    await _tocar(tester, 'Sí, bloquear');
    expect(find.text('Bloqueaste a esta persona.'), findsOneWidget);
    expect(find.text('Deshacer'), findsOneWidget);
  });

  testWidgets('CA_033_20 desbloquear: aviso propio del 404 y deshecho', (
    tester,
  ) async {
    var desbloqueada = false;
    final api = ApiFalsa((p) {
      if (p.metodo == 'DELETE') {
        return desbloqueada
            ? http.Response('', 204)
            : jsonOk({'code': 'block_not_found'}, estado: 404);
      }
      return jsonOk(paginaDeBloqueadosJson(desbloqueada ? [] : ['u-2'], null));
    });
    await _montar(tester, api, const PersonasBloqueadasReales());
    expect(find.text('Persona u-2'), findsOneWidget);

    await _tocar(tester, 'Desbloquear');
    expect(find.text('Esa persona ya no estaba bloqueada.'), findsOneWidget);

    desbloqueada = true;
    await _tocar(tester, 'Desbloquear');
    expect(find.text('No has bloqueado a nadie.'), findsOneWidget);
    expect(find.text('Persona u-2'), findsNothing);
  });

  testWidgets('CA_033_21 la lista: error con Reintentar y luego datos', (
    tester,
  ) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla
          ? http.Response('', 422)
          : jsonOk(paginaDeBloqueadosJson(['u-2'], null)),
    );
    await _montar(tester, api, const PersonasBloqueadasReales());

    expect(find.text('No pudimos cargar tus bloqueos.'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    falla = false;
    await _tocar(tester, 'Reintentar');
    expect(find.text('Persona u-2'), findsOneWidget);
    expect(find.text('Desbloquear'), findsOneWidget);
  });

  testWidgets('CA_033_21 sin conexión y lista vacía', (tester) async {
    final sinConexion = ApiFalsa((_) => throw http.ClientException('sin red'));
    await _montar(tester, sinConexion, const PersonasBloqueadasReales());
    expect(find.textContaining('Revisa tu conexión'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    final vacia = ApiFalsa((_) => jsonOk(paginaDeBloqueadosJson([], null)));
    await _montar(tester, vacia, const PersonasBloqueadasReales());
    expect(find.text('No has bloqueado a nadie.'), findsOneWidget);
  });

  testWidgets('CA_033_09 «Ver más» pide la página siguiente sin repetir', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.url.queryParameters['cursor'] == 'c1'
          ? jsonOk(paginaDeBloqueadosJson(['u-2', 'u-3'], null))
          : jsonOk(paginaDeBloqueadosJson(['u-2'], 'c1')),
    );
    await _montar(tester, api, const PersonasBloqueadasReales());

    await _tocar(tester, 'Ver más');

    expect(find.text('Persona u-2'), findsOneWidget);
    expect(find.text('Persona u-3'), findsOneWidget);
    final pedidos = api.peticiones.where((p) => p.ruta == 'me/bloqueos');
    expect(pedidos, hasLength(2));
    expect(pedidos.last.url.queryParameters['cursor'], 'c1');
  });

  testWidgets('CA_033_24 centro de ayuda: reportes y bloqueos juntos', (
    tester,
  ) async {
    var falla = true;
    final api = ApiFalsa((p) {
      if (p.ruta == 'reportes/me') {
        return falla
            ? http.Response('', 422)
            : jsonOk(paginaDeReportesJson([], null));
      }
      return jsonOk(paginaDeBloqueadosJson([], null));
    });
    await _montar(
      tester,
      api,
      const Column(
        spacing: 24,
        children: [MisReportesReales(), PersonasBloqueadasReales()],
      ),
    );

    expect(find.text('No pudimos cargar tus reportes.'), findsOneWidget);
    expect(find.text('No has bloqueado a nadie.'), findsOneWidget);

    falla = false;
    await _tocar(tester, 'Reintentar');
    expect(find.text('No has hecho reportes.'), findsOneWidget);
  });

  testWidgets('CA_033_25 en inglés y las claves coinciden en el ARB', (
    tester,
  ) async {
    final api = ApiFalsa((p) {
      if (p.metodo == 'POST' && p.ruta == 'usuarios/u-2/bloqueo') {
        return jsonOk({'code': 'already_blocked'}, estado: 409);
      }
      return jsonOk(
        p.ruta == 'visitas/v-1'
            ? visitaParaReportarJson('u-2')
            : paginaDeBloqueadosJson([], null),
      );
    });
    await _montar(
      tester,
      api,
      const BloquearReal(visitaId: 'v-1', trabajo: 'Trabajo de ejemplo'),
      locale: const Locale('en'),
    );

    await _tocar(tester, 'Block this person');
    await _tocar(tester, 'Yes, block');
    expect(find.text('You had already blocked this person.'), findsOneWidget);

    expect(
      leerArb('es').keys.where((k) => k.startsWith('bloqueos')).toSet(),
      leerArb('en').keys.where((k) => k.startsWith('bloqueos')).toSet(),
    );
  });

  testWidgets('CA_033_26 accesibilidad y texto al 200 % sin desbordes', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    final api = _servidor(
      (_) => jsonOk(paginaDeBloqueadosJson([], null)),
      bloqueados: ['u-2'],
    );
    await _montar(
      tester,
      api,
      const PersonasBloqueadasReales(),
      escalaDeTexto: 2.0,
    );
    await _tocar(tester, 'Desbloquear');

    await expectAccesible(tester);
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });
}
