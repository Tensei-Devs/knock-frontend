// Spec 040 (CA-16, CA-18, CA-19, CA-27): «Trabajo» con la agenda real, «El
// cliente no estaba» y «Terminar servicio», contra una API falsa.
import 'dart:convert';

import 'package:app/core/config/subida_de_fotos.dart';
import 'package:app/features/actividad/actividad.dart';
import 'package:app/features/maqueta/terminar_servicio_real.dart';
import 'package:app/features/maqueta/trabajo_real.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/visita/data/acciones_visita_repository_api.dart';
import 'package:app/features/visita/data/agenda_repository_api.dart';
import 'package:app/features/visita/visita_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _url = 'https://api.knock.test';

class _Api {
  final peticiones = <http.Request>[];
  int estadoDeAccion = 200;

  late final cliente = MockClient((r) async {
    peticiones.add(r);
    final ruta = r.url.path;
    if (ruta.endsWith('/agenda')) {
      return _json({
        'items': [_visita('v1', 'confirmada'), _visita('v2', 'en_curso')],
        'nextCursor': null,
      }, 200);
    }
    if (estadoDeAccion != 200) return _json({}, estadoDeAccion);
    if (ruta.endsWith('/cliente-ausente')) {
      return _json({
        'visitaId': 'v1',
        'estado': 'no_presentado',
        'quienFalto': 'cliente',
      }, 200);
    }
    return _json({
      'visitaId': 'v2',
      'estado': 'terminada',
      'terminadaEn': '2026-11-27T12:00:00Z',
    }, 200);
  });

  static http.Response _json(Object cuerpo, int estado) =>
      http.Response(jsonEncode(cuerpo), estado);

  static Map<String, Object?> _visita(String id, String estado) => {
    'id': id,
    'estado': estado,
    'modalidad': 'domicilio',
    'fechaHora': '2026-11-27T18:00:00Z',
    'dia': '2026-11-27',
    'hora': id == 'v1' ? '12:00' : '13:00',
    'precio': 100,
  };

  List<Override> get overrides => [
    solicitudesRealesActivasProvider.overrideWithValue(true),
    agendaRepositoryProvider.overrideWithValue(
      AgendaRepositoryApi(transporte: cliente, url: _url),
    ),
    accionesVisitaRepositoryProvider.overrideWithValue(
      AccionesVisitaRepositoryApi(transporte: cliente, url: _url),
    ),
  ];
}

Future<void> _montar(
  WidgetTester tester,
  Widget pantalla, {
  required List<Override> overrides,
}) async {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: '/prueba',
    routes: [
      GoRoute(path: '/prueba', builder: (_, _) => pantalla),
      GoRoute(path: '/trabajo', builder: (_, _) => const Text('en trabajo')),
      GoRoute(
        path: '/m/tecnico/cerrar/:vid',
        builder: (_, s) => Text('cerrar ${s.pathParameters['vid']}'),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Widget _terminar() => Scaffold(
  body: SingleChildScrollView(
    child: TerminarServicioReal(
      visitaId: 'v2',
      elegir: ({varias = true, max = 5}) async => ['foto.jpg'],
    ),
  ),
);

void main() {
  testWidgets('CA_040_27 Trabajo muestra la agenda real y sus acciones', (
    tester,
  ) async {
    await _montar(
      tester,
      const TrabajoSegunSesion(),
      overrides: _Api().overrides,
    );
    expect(find.text('Próximas visitas'), findsOneWidget);
    expect(find.text('2026-11-27 · 12:00'), findsOneWidget);
    expect(find.text('El cliente no estaba'), findsOneWidget);
    await tester.tap(find.text('Terminar servicio'));
    await tester.pumpAndSettle();
    expect(find.text('cerrar v2'), findsOneWidget);
  });

  testWidgets('CA_040_16 fuera de la ventana lo explica y no cierra la hoja', (
    tester,
  ) async {
    final api = _Api()..estadoDeAccion = 409;
    await _montar(tester, const TrabajoSegunSesion(), overrides: api.overrides);
    await tester.tap(find.text('El cliente no estaba'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registrar que no estaba'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Ahora no se puede registrar: solo dentro de la ventana de la cita.',
      ),
      findsOneWidget,
    );

    api.estadoDeAccion = 200;
    await tester.tap(find.text('Registrar que no estaba'));
    await tester.pumpAndSettle();
    expect(find.text('Registrar que no estaba'), findsNothing);
    expect(
      api.peticiones.where((r) => r.url.path.endsWith('/agenda')),
      hasLength(2),
    );
  });

  testWidgets('con la subida apagada no deja terminar', (tester) async {
    final api = _Api();
    await _montar(tester, _terminar(), overrides: api.overrides);
    expect(
      find.textContaining('La subida de fotos todavía no está disponible'),
      findsOneWidget,
    );
    await tester.tap(find.text('Terminar servicio'));
    await tester.pumpAndSettle();
    expect(api.peticiones, isEmpty);
  });

  testWidgets('CA_040_19 conserva lo escrito si falla y no repite la subida', (
    tester,
  ) async {
    final api = _Api()..estadoDeAccion = 409;
    final subidas = <String>[];
    await _montar(
      tester,
      _terminar(),
      overrides: [
        ...api.overrides,
        subidaDeFotosActivaProvider.overrideWithValue(true),
        subidaDeFotoDeTrabajoProvider.overrideWithValue((ruta) async {
          subidas.add(ruta);
          return 'a' * 32;
        }),
      ],
    );
    await tester.tap(find.byType(AddPhoto));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Cambié la llave');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terminar servicio'));
    await tester.pumpAndSettle();
    expect(
      find.text('Esta visita no está en curso: no se puede terminar.'),
      findsOneWidget,
    );
    expect(find.text('Cambié la llave'), findsOneWidget);

    api.estadoDeAccion = 200;
    await tester.tap(find.text('Terminar servicio'));
    await tester.pumpAndSettle();
    expect(find.text('en trabajo'), findsOneWidget);
    expect(subidas, ['foto.jpg']);
    expect(jsonDecode(api.peticiones.last.body), {
      'descripcion': 'Cambié la llave',
      'recomendacion': null,
      'fotos': ['a' * 32],
    });
  });
}
