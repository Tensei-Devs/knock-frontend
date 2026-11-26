// Spec 021 (KNOCK-66): pruebas de widget, estados y accesibilidad para
// `InicioScreen` (barra), `BusquedaScreen` y `TarjetaExperto`.
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/actividad/actividad.dart'
    show coloniaGuardadaProvider;
import 'package:app/features/busqueda/busqueda.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/accesibilidad.dart';
import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';

class _OficiosFalsos implements OficiosRepository {
  const _OficiosFalsos(this._lista);

  final List<Oficio> _lista;

  @override
  Future<List<Oficio>> listar() async => _lista;
}

const _oficiosCatalogo = [
  Oficio(clave: 'plo', nombre: 'Plomería', modalidad: Modalidad.domicilio),
  Oficio(clave: 'mec', nombre: 'Mecánica', modalidad: Modalidad.taller),
];

Map<String, Object?> _experto({
  String id = '1',
  bool atiende = true,
  bool verificado = true,
}) => {
  'id': id,
  'nombre': 'Experto $id',
  'oficios': [
    {'clave': 'plo', 'nombre': 'Plomería'},
  ],
  'calificacion': 4.8,
  'totalResenas': 12,
  'verificado': verificado,
  'nivelVerificacion': 'identidad',
  'coloniaBase': 'Centro',
  'distanciaKm': 2,
  'atiendeTuColonia': atiende,
  'fotoUrl': null,
};

Map<String, Object?> _respuesta({
  String estado = 'detectado',
  Object? detectado = const {'clave': 'plo', 'nombre': 'Plomería'},
  Object? sugeridos,
  List<Object?>? items,
  String? siguiente,
}) => {
  'interpretacion': {
    'estado': estado,
    'oficioDetectado': detectado,
    'oficiosSugeridos': sugeridos,
  },
  'items': items ?? [_experto()],
  'nextCursor': siguiente,
};

Future<void> _montarBusqueda(
  WidgetTester tester,
  ApiFalsa api, {
  String? coloniaId = 'col-1',
  double escalaDeTexto = 1.0,
}) async {
  tester.view.physicalSize = const Size(412, 892);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        urlApiProvider.overrideWithValue(urlApiPrueba),
        transporteHttpProvider.overrideWithValue(api.transporte),
        almacenSeguroProvider.overrideWithValue(AlmacenSeguroEnMemoria()),
        tokensInicialesProvider.overrideWithValue(tokensA),
        sesionInicialProvider.overrideWithValue(true),
        coloniaGuardadaProvider.overrideWithValue(coloniaId),
        oficiosRepositoryProvider.overrideWithValue(
          const _OficiosFalsos(_oficiosCatalogo),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(escalaDeTexto)),
          child: child!,
        ),
        home: const BusquedaScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _buscar(WidgetTester tester, String texto) async {
  await tester.enterText(find.byType(TextField), texto);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'InicioScreen muestra barra de búsqueda y navega a /inicio/buscar',
    (tester) async {
      final api = ApiFalsa((_) => jsonOk(perfilJson()));
      final container = await montarApp(
        tester,
        esTecnico: false,
        extra: <Override>[
          urlApiProvider.overrideWithValue(urlApiPrueba),
          transporteHttpProvider.overrideWithValue(api.transporte),
          almacenSeguroProvider.overrideWithValue(AlmacenSeguroEnMemoria()),
          tokensInicialesProvider.overrideWithValue(tokensA),
          sesionInicialProvider.overrideWithValue(true),
          oficiosRepositoryProvider.overrideWithValue(
            const _OficiosFalsos(_oficiosCatalogo),
          ),
        ],
      );

      expect(find.text('Ej.: boiler, frenos, un contacto'), findsOneWidget);
      await tester.tap(find.text('Ej.: boiler, frenos, un contacto'));
      await tester.pumpAndSettle();

      expect(ubicacion(container), Rutas.buscar);
      expect(find.byType(BusquedaScreen), findsOneWidget);
    },
  );

  testWidgets('CA_021_05_06 mínimo 2 letras y contador hasta 80 caracteres', (
    tester,
  ) async {
    final api = ApiFalsa((_) => jsonOk(_respuesta()));
    await _montarBusqueda(tester, api);

    await _buscar(tester, 'a');
    expect(find.text('Escribe al menos 2 letras'), findsOneWidget);
    expect(api.peticiones, isEmpty);

    await tester.enterText(find.byType(TextField), 'a' * 85);
    await tester.pump();
    expect(find.text('80/80'), findsOneWidget);
  });

  testWidgets('CA_021_01_02_10 muestra interpretación y tarjeta sin contacto', (
    tester,
  ) async {
    final api = ApiFalsa(
      (_) => jsonOk(
        _respuesta(
          detectado: {'clave': 'mec', 'nombre': 'Mecánica'},
          items: [_experto(atiende: false)],
        ),
      ),
    );
    await _montarBusqueda(tester, api);
    await _buscar(tester, 'frenso');

    expect(find.text('Buscamos: Mecánica'), findsOneWidget);
    expect(find.text('Experto 1'), findsOneWidget);
    expect(find.textContaining('4.8 estrellas, 12 reseñas'), findsOneWidget);
    expect(find.textContaining('a unos 2 km'), findsOneWidget);
    expect(find.text('Verificado: identidad'), findsOneWidget);
    expect(find.text('No atiende tu colonia'), findsOneWidget);
  });

  testWidgets('CA_021_03 ambiguo y no_entendido permiten elegir oficio', (
    tester,
  ) async {
    var estado = 'ambiguo';
    final api = ApiFalsa((_) {
      if (estado == 'ambiguo') {
        return jsonOk(
          _respuesta(
            estado: 'ambiguo',
            detectado: null,
            sugeridos: [
              {'clave': 'plo', 'nombre': 'Plomería'},
              {'clave': 'mec', 'nombre': 'Mecánica'},
            ],
          ),
        );
      }
      return jsonOk(
        _respuesta(estado: 'no_entendido', detectado: null, items: []),
      );
    });
    await _montarBusqueda(tester, api);
    await _buscar(tester, 'luz');

    expect(find.text('¿Cuál de estos buscas?'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(ActionChip),
        matching: find.text('Plomería'),
      ),
    );
    await tester.pumpAndSettle();
    expect(api.peticiones.last.url.queryParameters['oficio'], 'plo');

    estado = 'no_entendido';
    await _buscar(tester, 'xyzzy');
    expect(find.text('No entendimos qué necesitas'), findsOneWidget);
    expect(find.text('Elige una categoría'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ActionChip),
        matching: find.text('Mecánica'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('CA_021_08 chips de Solo verificados y Oficio envían filtros', (
    tester,
  ) async {
    final api = ApiFalsa((_) => jsonOk(_respuesta()));
    await _montarBusqueda(tester, api);
    await _buscar(tester, 'boiler');

    await tester.tap(find.text('Solo verificados'));
    await tester.pumpAndSettle();
    expect(api.peticiones.last.url.queryParameters['soloVerificados'], 'true');

    final chipMecanica = find.descendant(
      of: find.byType(FilterChip),
      matching: find.text('Mecánica'),
    );
    await tester.ensureVisible(chipMecanica);
    await tester.pumpAndSettle();
    await tester.tap(chipMecanica);
    await tester.pumpAndSettle();
    expect(api.peticiones.last.url.queryParameters['oficio'], 'mec');
  });

  testWidgets('CA_021_11 sin resultados con oficio invita a pedir cotización', (
    tester,
  ) async {
    final api = ApiFalsa((_) => jsonOk(_respuesta(items: [])));
    await _montarBusqueda(tester, api);
    await _buscar(tester, 'boiler');

    expect(
      find.text('Todavía no hay expertos de Plomería en tu colonia'),
      findsOneWidget,
    );
    expect(find.text('Pedir cotización de todos modos'), findsOneWidget);
  });

  testWidgets('CA_021_12_13 sin conexión y 503 muestran error y Reintentar', (
    tester,
  ) async {
    var fase = 0;
    final api = ApiFalsa((_) {
      if (fase == 0) throw http.ClientException('sin red');
      if (fase == 1) return http.Response('', 503);
      return jsonOk(_respuesta());
    });
    await _montarBusqueda(tester, api);
    await _buscar(tester, 'boiler');

    expect(find.text('Sin conexión'), findsOneWidget);
    fase = 1;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'La búsqueda no está disponible en este momento. Intenta de nuevo.',
      ),
      findsOneWidget,
    );

    fase = 2;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Experto 1'), findsOneWidget);
  });

  testWidgets('CA_021_15 sin zona guardada muestra aviso de zona', (
    tester,
  ) async {
    final api = ApiFalsa((_) => jsonOk(_respuesta()));
    await _montarBusqueda(tester, api, coloniaId: null);
    await _buscar(tester, 'boiler');

    expect(
      find.text('Elige tu zona para buscar expertos cerca'),
      findsOneWidget,
    );
    expect(api.peticiones, isEmpty);
  });

  testWidgets('CA_021_09 tocar un resultado abre Pedir cotización con oficio', (
    tester,
  ) async {
    final api = ApiFalsa((p) {
      if (p.ruta == 'me') return jsonOk(perfilJson());
      if (p.ruta == 'busqueda') return jsonOk(_respuesta());
      return jsonOk({'items': <Object?>[]});
    });
    final container = await montarApp(
      tester,
      esTecnico: false,
      extra: <Override>[
        urlApiProvider.overrideWithValue(urlApiPrueba),
        transporteHttpProvider.overrideWithValue(api.transporte),
        almacenSeguroProvider.overrideWithValue(AlmacenSeguroEnMemoria()),
        tokensInicialesProvider.overrideWithValue(tokensA),
        sesionInicialProvider.overrideWithValue(true),
        coloniaGuardadaProvider.overrideWithValue('col-1'),
        oficiosRepositoryProvider.overrideWithValue(
          const _OficiosFalsos(_oficiosCatalogo),
        ),
      ],
    );

    container.read(appRouterProvider).go(Rutas.buscar);
    await tester.pumpAndSettle();
    await _buscar(tester, 'boiler');

    await tester.tap(find.text('Experto 1'));
    await tester.pumpAndSettle();

    final uri = container
        .read(appRouterProvider)
        .routerDelegate
        .currentConfiguration
        .uri;
    expect(uri.path, Rutas.solicitudNueva);
    expect(uri.queryParameters[Rutas.parametroOficio], 'plo');
  });

  testWidgets('CA_021_18 tope de 100 resultados muestra mensaje', (
    tester,
  ) async {
    final items = [for (var i = 0; i < 100; i++) _experto(id: '$i')];
    final api = ApiFalsa((_) => jsonOk(_respuesta(items: items)));
    await _montarBusqueda(tester, api);
    await _buscar(tester, 'boiler');

    final topeFinder = find.text(
      'Mostramos los primeros 100. Agrega más palabras para afinar.',
    );
    await tester.scrollUntilVisible(
      topeFinder,
      500,
      maxScrolls: 100,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    expect(topeFinder, findsOneWidget);
  });

  testWidgets('CA_021_16 accesibilidad y texto al 200 % sin desborde', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();

    final api = ApiFalsa((_) => jsonOk(_respuesta()));
    await _montarBusqueda(tester, api, escalaDeTexto: 2.0);
    await _buscar(tester, 'boiler');

    await expectAccesible(tester);
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });
}
