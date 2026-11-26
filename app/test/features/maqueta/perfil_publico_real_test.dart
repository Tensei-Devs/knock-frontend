// Specs 036 (TEC-05 a TEC-07) y 037 (SRV-01): el perfil público de un técnico
// real. Solo datos ficticios.
import 'package:app/features/inicio/data/zonas_repository_http.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/maqueta/perfil_publico_real.dart';
import 'package:app/features/tecnico/data/perfil_publico_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

const _perfil = {
  'id': 't-1',
  'nombre': 'Experto Uno',
  'nombreNegocio': 'Taller Uno',
  'fotoUrl': null,
  'verificacion': 'verificado',
  'calificacion': 4.7,
  'anios': 5,
  'descripcionCorta': 'Arreglos de agua',
  'oficios': ['plo'],
  'detalle': {
    'descripcion': 'Arreglos de agua y boiler',
    'atencion': 'domicilio',
    'radioKm': 8,
    'coloniaId': 'col-1',
    'disponibleHoy': true,
  },
};

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

Map<String, Object?> _foto(String id) => {
  'id': id,
  'url': 'https://almacen.knock.test/$id',
  'creadoEn': '2026-11-20T18:00:00Z',
};

http.Response _bien(PeticionApi p) => switch (p.ruta) {
  'tecnicos/t-1' => jsonOk(_perfil),
  'tecnicos/t-1/servicios' => jsonOk({
    'items': [
      {
        'id': 's-1',
        'nombre': 'Cambio de llave',
        'detalle': null,
        'precioReferencia': 350,
        'oficio': 'plo',
      },
    ],
  }),
  'tecnicos/t-1/llega-a-mi-colonia' => jsonOk({'atiende': true}),
  'tecnicos/t-1/fotos-trabajos' => jsonOk({
    'fotos': p.url.queryParameters['cursor'] == null
        ? [_foto('f1')]
        : [_foto('f1'), _foto('f2')],
    'nextCursor': p.url.queryParameters['cursor'] == null ? 'c1' : null,
  }),
  _ => jsonOk(_zona),
};

Future<ProviderContainer> _montar(
  WidgetTester tester,
  ApiFalsa api, {
  bool conSesionIniciada = true,
}) async {
  maq.user
    ..col = 'Col. Centro'
    ..cp = '42800';
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        perfilPublicoRepositoryProvider.overrideWithValue(
          PerfilPublicoRepositoryApi(
            transporte: api.cliente,
            url: urlApiPrueba,
          ),
        ),
        zonasRepositoryProvider.overrideWithValue(
          ZonasRepositoryHttp(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PerfilPublicoReal(
              tecnicoId: 't-1',
              conSesion: conSesionIniciada,
            ),
          ),
        ),
      ),
    ),
  );
  await asentarMaqueta(tester);
  return ProviderScope.containerOf(
    tester.element(find.byType(PerfilPublicoReal)),
  );
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_036_17_21_25 perfil, colonia, servicios y fotos del '
      'servidor', (tester) async {
    final api = ApiFalsa(_bien);
    await _montar(tester, api);

    expect(find.text('Taller Uno'), findsOneWidget);
    expect(find.text('Arreglos de agua y boiler'), findsOneWidget);
    expect(find.text('Disponible hoy'), findsOneWidget);
    expect(find.text('Sí atiende Col. Centro'), findsOneWidget);
    expect(find.text('Cambio de llave'), findsOneWidget);
    expect(find.textContaining('350'), findsOneWidget);
    expect(
      api.peticiones
          .singleWhere((p) => p.ruta.endsWith('llega-a-mi-colonia'))
          .url
          .queryParameters,
      {'colonia': 'col-1'},
    );
  });

  testWidgets('CA_036_28 pide más fotos con el cursor y no las repite', (
    tester,
  ) async {
    final api = ApiFalsa(_bien);
    await _montar(tester, api);
    await tester.ensureVisible(find.text('Ver más fotos'));
    await tester.tap(find.text('Ver más fotos'));
    await asentarMaqueta(tester);

    expect(find.byType(Image), findsNWidgets(2));
    expect(find.text('Ver más fotos'), findsNothing);
  });

  testWidgets('CA_036_19_23_27 un 404 dice que ya no está disponible', (
    tester,
  ) async {
    await _montar(
      tester,
      ApiFalsa(
        (p) =>
            p.ruta.startsWith('zonas') ? jsonOk(_zona) : http.Response('', 404),
      ),
    );

    expect(find.text('Ese técnico ya no está disponible.'), findsNWidgets(4));
  });

  testWidgets('CA_036_20_52 sin conexión: Reintentar sin copia y, con copia, '
      'la copia con su fecha', (tester) async {
    var sinRed = true;
    final api = ApiFalsa((p) {
      if (sinRed) throw http.ClientException('sin red');
      return _bien(p);
    });
    final c = await _montar(tester, api, conSesionIniciada: false);
    expect(find.textContaining('No pudimos conectar'), findsOneWidget);

    sinRed = false;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);
    expect(find.text('Taller Uno'), findsOneWidget);

    sinRed = true;
    c.invalidate(perfilPublicoProvider('t-1'));
    await asentarMaqueta(tester);

    expect(find.textContaining('puede estar desactualizada'), findsOneWidget);
    expect(find.text('Taller Uno'), findsOneWidget);
  });

  testWidgets('CA_036_17 sin sesión solo pide el resumen', (tester) async {
    final api = ApiFalsa(_bien);
    await _montar(tester, api, conSesionIniciada: false);

    expect(api.llamadas, ['GET tecnicos/t-1']);
  });

  testWidgets('CA_036_59 con texto al 200 % no se desborda y es/en tienen las '
      'mismas claves', (tester) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    await _montar(tester, ApiFalsa(_bien));

    expect(tester.takeException(), isNull);
    expect(
      leerArb('es').keys.where((k) => k.startsWith('tecnico')).toSet(),
      leerArb('en').keys.where((k) => k.startsWith('tecnico')).toSet(),
    );
  });
}
