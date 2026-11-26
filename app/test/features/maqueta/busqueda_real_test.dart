// Specs 021 y 036 (TEC-03): «Buscar» con sesión y servidor. Solo datos
// ficticios.
import 'package:app/features/busqueda/busqueda.dart';
import 'package:app/features/busqueda/data/busqueda_repository_api.dart';
import 'package:app/features/inicio/data/zonas_repository_http.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/maqueta/busqueda_real.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

const _zona = {
  'enCobertura': true,
  'ciudadPiloto': true,
  'colonias': [
    {
      'id': 'col-1',
      'nombre': 'Col. Centro',
      'cp': '42800',
      'municipio': 'Tula de Allende',
    },
  ],
};

Map<String, Object?> _experto(String id, {bool atiende = true}) => {
  'id': id,
  'nombre': 'Experto $id',
  'oficios': [
    {'clave': 'plo', 'nombre': 'Plomería'},
  ],
  'calificacion': 4.8,
  'totalResenas': 12,
  'verificado': true,
  'nivelVerificacion': 'identidad',
  'coloniaBase': 'Col. Centro',
  'distanciaKm': 2,
  'atiendeTuColonia': atiende,
  'fotoUrl': null,
};

Map<String, Object?> _pagina({
  String estado = 'detectado',
  List<Object?>? items,
  String? siguiente,
  List<Object?> sugeridos = const [],
}) => {
  'interpretacion': {
    'estado': estado,
    'oficioDetectado': estado == 'detectado'
        ? {'clave': 'plo', 'nombre': 'Plomería'}
        : null,
    'oficiosSugeridos': sugeridos,
  },
  'items': items ?? [_experto('1', atiende: false)],
  'nextCursor': siguiente,
};

ApiFalsa _servidor(http.Response Function(PeticionApi) busqueda) =>
    ApiFalsa((p) {
      if (p.ruta.startsWith('zonas/cp/')) return jsonOk(_zona);
      if (p.ruta == 'tecnicos/autocompletar') {
        return jsonOk({'sugerencias': <Object?>[]});
      }
      return busqueda(p);
    });

Future<void> _montar(WidgetTester tester, ApiFalsa api) async {
  maq.user
    ..col = 'Col. Centro'
    ..cp = '42800';
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        busquedaRepositoryProvider.overrideWithValue(
          BusquedaRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
        zonasRepositoryProvider.overrideWithValue(
          ZonasRepositoryHttp(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BusquedaReal(),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

Future<void> _escribir(WidgetTester tester, String texto) async {
  await tester.enterText(find.byType(TextField), texto);
  await tester.pump(pausaAlEscribir);
  await asentarMaqueta(tester);
}

Iterable<PeticionApi> _busquedas(ApiFalsa api) =>
    api.peticiones.where((p) => p.ruta == 'busqueda');

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_021_05_07 con una letra no pide; varias seguidas piden una '
      'sola vez tras la pausa', (tester) async {
    final api = _servidor((_) => jsonOk(_pagina()));
    await _montar(tester, api);
    await _escribir(tester, 'b');
    expect(find.text('Escribe al menos 2 letras'), findsOneWidget);
    expect(_busquedas(api), isEmpty);

    await tester.enterText(find.byType(TextField), 'bo');
    await tester.pump(const Duration(milliseconds: 100));
    await _escribir(tester, 'boiler');

    expect(_busquedas(api).single.url.queryParameters, {
      'q': 'boiler',
      'coloniaId': 'col-1',
      'limit': '20',
    });
    expect(maq.sQ, isNot(contains('boiler')));
  });

  testWidgets('CA_021_02_10 muestra lo que entendió el servidor y la tarjeta '
      'sin contacto', (tester) async {
    await _montar(tester, _servidor((_) => jsonOk(_pagina())));
    await _escribir(tester, 'boiler');

    expect(find.text('Buscamos: Plomería'), findsOneWidget);
    expect(find.text('Experto 1'), findsOneWidget);
    expect(find.textContaining('4.8 estrellas, 12 reseñas'), findsOneWidget);
    expect(find.textContaining('a unos 2 km'), findsOneWidget);
    expect(find.text('No atiende tu colonia'), findsOneWidget);
  });

  testWidgets('CA_021_08 «Solo verificados» pide de nuevo con el filtro', (
    tester,
  ) async {
    final api = _servidor((_) => jsonOk(_pagina()));
    await _montar(tester, api);
    await _escribir(tester, 'boiler');
    await tester.tap(find.text('Solo verificados'));
    await asentarMaqueta(tester);

    expect(_busquedas(api).last.url.queryParameters['soloVerificados'], 'true');
  });

  testWidgets('CA_021_03 ambiguo: elegir un oficio repite la búsqueda con '
      'él', (tester) async {
    final api = _servidor(
      (_) => jsonOk(
        _pagina(
          estado: 'ambiguo',
          sugeridos: [
            {'clave': 'ele', 'nombre': 'Electricidad del hogar'},
          ],
        ),
      ),
    );
    await _montar(tester, api);
    await _escribir(tester, 'luz');
    await tester.tap(find.text('Electricidad del hogar'));
    await asentarMaqueta(tester);

    expect(_busquedas(api).last.url.queryParameters['oficio'], 'ele');
  });

  testWidgets('CA_021_11 sin resultados con oficio invita a pedir', (
    tester,
  ) async {
    await _montar(tester, _servidor((_) => jsonOk(_pagina(items: []))));
    await _escribir(tester, 'boiler');

    expect(
      find.text('Todavía no hay expertos de Plomería en tu colonia'),
      findsOneWidget,
    );
    expect(find.text('Pedir cotización de todos modos'), findsOneWidget);
  });

  testWidgets('CA_021_12_13 sin conexión y 503 muestran su texto y '
      'Reintentar', (tester) async {
    var fase = 0;
    final api = _servidor((_) {
      if (fase == 0) throw http.ClientException('sin red');
      return fase == 1 ? http.Response('', 503) : jsonOk(_pagina());
    });
    await _montar(tester, api);
    await _escribir(tester, 'boiler');
    expect(find.text('Sin conexión'), findsOneWidget);

    fase = 1;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);
    expect(find.textContaining('no está disponible'), findsOneWidget);

    fase = 2;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);
    expect(find.text('Experto 1'), findsOneWidget);
  });

  testWidgets('CA_021_15_17 colonia desconocida pide elegir la zona', (
    tester,
  ) async {
    await _montar(
      tester,
      _servidor((_) => jsonOk({'code': 'colonia_not_found'}, estado: 422)),
    );
    await _escribir(tester, 'boiler');

    expect(find.text('Elegir mi zona'), findsOneWidget);
  });

  testWidgets('CA_021_17_18 pagina con el cursor sin repetir y un cursor '
      'vencido reinicia', (tester) async {
    var vencido = false;
    final api = _servidor((p) {
      if (p.url.queryParameters['cursor'] == null) {
        return jsonOk(_pagina(items: [_experto('1')], siguiente: 'c1'));
      }
      return vencido
          ? jsonOk({'code': 'invalid_cursor'}, estado: 400)
          : jsonOk(
              _pagina(items: [_experto('1'), _experto('2')], siguiente: 'c2'),
            );
    });
    await _montar(tester, api);
    await _escribir(tester, 'boiler');
    await tester.ensureVisible(find.text('Ver más'));
    await tester.tap(find.text('Ver más'));
    await asentarMaqueta(tester);
    expect(find.text('Experto 1'), findsOneWidget);
    expect(find.text('Experto 2'), findsOneWidget);

    vencido = true;
    await tester.ensureVisible(find.text('Ver más'));
    await tester.tap(find.text('Ver más'));
    await asentarMaqueta(tester);

    expect(find.text('Experto 2'), findsNothing);
    expect(_busquedas(api).last.url.queryParameters['cursor'], isNull);
  });

  testWidgets('CA_036_09 tocar una sugerencia busca su texto con su oficio', (
    tester,
  ) async {
    final api = ApiFalsa((p) {
      if (p.ruta.startsWith('zonas/cp/')) return jsonOk(_zona);
      if (p.ruta == 'tecnicos/autocompletar') {
        return jsonOk({
          'sugerencias': [
            {'tipo': 'servicio', 'texto': 'Calentador', 'clave': 'plo'},
          ],
        });
      }
      return jsonOk(_pagina());
    });
    await _montar(tester, api);
    await _escribir(tester, 'cal');
    await tester.tap(find.text('Calentador'));
    await asentarMaqueta(tester);

    expect(_busquedas(api).last.url.queryParameters['q'], 'Calentador');
    expect(_busquedas(api).last.url.queryParameters['oficio'], 'plo');
  });

  testWidgets('CA_021_16 con texto al 200 % no se desborda y en inglés hay '
      'las mismas claves', (tester) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    await _montar(tester, _servidor((_) => jsonOk(_pagina())));
    await _escribir(tester, 'boiler');

    expect(tester.takeException(), isNull);
    expect(
      leerArb('es').keys.where((k) => k.startsWith('busqueda')).toSet(),
      leerArb('en').keys.where((k) => k.startsWith('busqueda')).toSet(),
    );
  });
}
