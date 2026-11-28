// Spec 041 y 045: las pantallas de opiniones de la maqueta con datos reales:
// estados, idiomas, errores que conservan lo escrito y accesibilidad. Solo
// datos ficticios.
import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/maqueta/opiniones_reales.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/features/opiniones/data/opiniones_repository_api.dart';
import 'package:app/features/opiniones/opiniones.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/opiniones_falsas.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/solicitud_falsa.dart';

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api,
  Widget pantalla, {
  String idioma = 'es',
}) async {
  final router = GoRouter(
    initialLocation: '/prueba',
    routes: [
      GoRoute(path: '/prueba', builder: (_, _) => pantalla),
      GoRoute(
        path: '/actividad',
        builder: (_, _) => const Scaffold(body: Text('En actividad')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        opinionesRepositoryProvider.overrideWithValue(
          OpinionesRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: MaterialApp.router(
        locale: Locale(idioma),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await asentarMaqueta(tester);
}

Widget _lista() => const Scaffold(
  body: SingleChildScrollView(child: OpinionesReales(tecnicoId: 't1')),
);

const _calificar = CalificarReal(visitaId: 'v1', trabajo: 'Plomería');

Future<void> _tocar(WidgetTester tester, Finder donde) async {
  await tester.ensureVisible(donde);
  await asentarMaqueta(tester);
  await tester.tap(donde);
  await asentarMaqueta(tester);
}

Solicitud _solicitud(EstadoSolicitud estado) => Solicitud(
  id: 'b' * 24,
  estado: estado,
  oficioNombre: 'Plomería',
  oficioClave: 'plo',
  descripcion: '',
  totalFotos: 0,
  dia: DateTime(2026, 11, 12),
  franja: Franja.tarde,
  creadoEn: DateTime(2026, 11, 10),
  totalCotizaciones: 1,
  visitaId: 'c' * 24,
);

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_041_13 vacío, y error con Reintentar', (tester) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla ? http.Response('', 503) : jsonOk(paginaJson([])),
    );
    await _montar(tester, api, _lista());
    expect(find.textContaining('No pudimos conectar'), findsOneWidget);

    falla = false;
    await _tocar(tester, find.text('Reintentar'));

    expect(find.textContaining('Aún sin opiniones'), findsOneWidget);
  });

  testWidgets('CA_041_03 técnico no disponible', (tester) async {
    await _montar(tester, ApiFalsa((_) => http.Response('', 404)), _lista());

    expect(find.text('Ese técnico ya no está disponible.'), findsOneWidget);
  });

  testWidgets('CA_041_04 muestra las opiniones y pide la siguiente página', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.url.queryParameters['cursor'] == null
          ? jsonOk(paginaJson([opinionJson('o1')], cursor: 'c1'))
          : jsonOk(paginaJson([opinionJson('o2', comentario: 'Puntual')])),
    );
    await _montar(tester, api, _lista());
    expect(find.text('Muy bien'), findsOneWidget);
    expect(find.text('5 estrellas: 1'), findsOneWidget);
    expect(find.text('Respuesta del técnico: Gracias'), findsOneWidget);

    await _tocar(tester, find.text('Ver más'));

    expect(find.text('Muy bien'), findsOneWidget);
    expect(find.text('Puntual'), findsOneWidget);
    expect(find.text('Ver más'), findsNothing);
  });

  testWidgets('CA_041_12 el perfil muestra el resumen del servidor', (
    tester,
  ) async {
    await _montar(
      tester,
      ApiFalsa((_) => jsonOk(paginaJson([opinionJson('o1')]))),
      PerfilTecnicoReal(
        tecnicoId: 't1',
        idDeMaqueta: 'api:t1',
        nombre: 'Persona Uno',
        verificado: true,
        alPedir: () {},
      ),
    );

    expect(find.text('Persona Uno'), findsOneWidget);
    expect(find.text('Pedir cotización'), findsOneWidget);
  });

  testWidgets('CA_041_16 en inglés', (tester) async {
    await _montar(
      tester,
      ApiFalsa((_) => jsonOk(paginaJson([]))),
      _lista(),
      idioma: 'en',
    );

    expect(find.textContaining('No reviews yet'), findsOneWidget);
  });

  testWidgets('CA_041_14 publicar está apagado sin estrellas y publica', (
    tester,
  ) async {
    final api = ApiFalsa((_) => jsonOk(creadaJson, estado: 201));
    await _montar(tester, api, _calificar);

    await tester.tap(find.text('Publicar opinión'));
    await asentarMaqueta(tester);
    expect(api.peticiones, isEmpty);

    await _tocar(tester, find.bySemanticsLabel('4 de 5 estrellas'));
    await _tocar(tester, find.bySemanticsLabel('Trato: 3 de 5 estrellas'));
    await _tocar(tester, find.text('Guardar en mis técnicos de confianza'));
    await _tocar(tester, find.text('Publicar opinión'));

    expect(find.text('En actividad'), findsOneWidget);
    final cuerpo = api.peticiones.single.json;
    expect(cuerpo['calificacion'], 4);
    expect((cuerpo['partes'] as Map)['trato'], 3);
    expect(cuerpo['guardarTecnicoConfianza'], isTrue);
  });

  for (final (estado, codigo, mensaje) in [
    (409, 'review_not_allowed', 'ya no se puede calificar'),
    (403, null, 'permiso'),
    (422, null, 'datos'),
    (404, null, 'Esa visita ya no está disponible'),
    (503, null, 'No pudimos conectar'),
  ]) {
    testWidgets('CA_041_08 con $estado conserva lo escrito', (tester) async {
      final api = ApiFalsa((_) => jsonOk({'code': ?codigo}, estado: estado));
      await _montar(tester, api, _calificar);
      await _tocar(tester, find.bySemanticsLabel('5 de 5 estrellas'));
      await tester.enterText(find.byType(TextField), 'Mi comentario');

      await _tocar(tester, find.text('Publicar opinión'));

      expect(find.textContaining(mensaje), findsOneWidget);
      expect(find.text('Mi comentario'), findsOneWidget);
      expect(find.text('Publicar opinión'), findsOneWidget);
    });
  }

  testWidgets('CA_041_17 estrellas accesibles con texto al 200 %', (
    tester,
  ) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    await _montar(tester, ApiFalsa(), _calificar);

    expect(tester.takeException(), isNull);
    final estrella = find.bySemanticsLabel('1 de 5 estrellas');
    expect(tester.getSize(estrella).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(estrella).height, greaterThanOrEqualTo(48));
  });

  test('solo una visita terminada y sin opinión se puede calificar', () {
    bool porCalificar(EstadoSolicitud e) =>
        jobDeSolicitud(_solicitud(e), catalogo: const {})!.porCalificar;
    expect(porCalificar(EstadoSolicitud.terminada), isTrue);
    expect(porCalificar(EstadoSolicitud.calificada), isFalse);
    expect(porCalificar(EstadoSolicitud.citaConfirmada), isFalse);
  });

  testWidgets('desde Actividad se abre «Calificar» de la visita real', (
    tester,
  ) async {
    fijarPantalla(tester, tamano: tamanoMovil);
    maq.resetAll();
    final container = await montarApp(
      tester,
      esTecnico: false,
      maqueta: true,
      extra: [
        solicitudesRealesRepositoryProvider.overrideWithValue(
          SolicitudesFalsas()
            ..listadas.add(_solicitud(EstadoSolicitud.terminada)),
        ),
        solicitudesRealesActivasProvider.overrideWithValue(true),
        oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
        intervaloRefrescoSolicitudProvider.overrideWithValue(null),
      ],
    );
    container.read(appRouterProvider).go('/actividad');
    await asentarMaqueta(tester);

    await _tocar(tester, find.text('Calificar el servicio'));

    expect(find.byType(CalificarReal), findsOneWidget);
    maq.pv.me.registered = false;
    maq.pv.dispose();
  });
}
