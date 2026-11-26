// Spec 029 y 045: «Privacidad y datos» con datos reales: estados, interruptor
// de la descarga, errores e idiomas. Solo datos ficticios.
import 'package:app/core/config/exportacion_de_datos.dart';
import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/features/cuenta/cuenta.dart';
import 'package:app/features/cuenta/data/privacidad_repository_api.dart';
import 'package:app/features/maqueta/privacidad_real.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

class _AbridorFalso implements AbridorDeEnlaces {
  final abiertas = <Uri>[];

  @override
  Future<bool> abrir(Uri direccion) async {
    abiertas.add(direccion);
    return true;
  }
}

Map<String, Object?> _consentimiento(
  String tipo, {
  bool vigente = false,
  bool obligatorio = false,
}) => {
  'tipo': tipo,
  'vigente': vigente,
  'obligatorio': obligatorio,
  'version': vigente ? 'v1' : null,
  'fecha': vigente ? '2026-11-20T18:00:00Z' : null,
};

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api,
  Widget hijo, {
  bool exportacion = true,
  AbridorDeEnlaces? abridor,
  String idioma = 'es',
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        exportacionDeDatosActivaProvider.overrideWithValue(exportacion),
        if (abridor != null)
          abridorDeEnlacesProvider.overrideWithValue(abridor),
        privacidadRepositoryProvider.overrideWithValue(
          PrivacidadRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: MaterialApp(
        locale: Locale(idioma),
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

  testWidgets('con el interruptor apagado no llama a la API', (tester) async {
    final api = ApiFalsa();
    await _montar(tester, api, const ExportacionReal(), exportacion: false);

    expect(find.textContaining('todavía no está disponible'), findsOneWidget);
    expect(find.text('Pedir mi archivo'), findsNothing);
    expect(api.peticiones, isEmpty);
  });

  testWidgets('CA_029_27 error con Reintentar, sin pedir y en preparación', (
    tester,
  ) async {
    var falla = true;
    final api = ApiFalsa((p) {
      if (p.metodo == 'POST') return http.Response('', 202);
      return falla ? http.Response('', 503) : http.Response('', 404);
    });
    await _montar(tester, api, const ExportacionReal());
    expect(find.text('Reintentar'), findsOneWidget);

    falla = false;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);
    expect(find.textContaining('Aún no has pedido'), findsOneWidget);

    await tester.tap(find.text('Pedir mi archivo'));
    await asentarMaqueta(tester);

    expect(find.textContaining('Estamos preparando'), findsOneWidget);
    expect(find.text('Actualizar'), findsOneWidget);
  });

  testWidgets('con el archivo listo abre el enlace recién pedido', (
    tester,
  ) async {
    final abridor = _AbridorFalso();
    final api = ApiFalsa(
      (_) => jsonOk({
        'estado': 'lista',
        'enlace': 'https://archivos.knock.test/x.zip',
        'venceEn': '2026-11-27T18:00:00Z',
      }),
    );
    await _montar(tester, api, const ExportacionReal(), abridor: abridor);

    await tester.tap(find.text('Descargar'));
    await asentarMaqueta(tester);

    expect(abridor.abiertas.single.path, '/x.zip');
  });

  testWidgets('vencida permite pedirlo otra vez', (tester) async {
    final api = ApiFalsa(
      (_) => jsonOk({'estado': 'vencida', 'enlace': null, 'venceEn': null}),
    );
    await _montar(tester, api, const ExportacionReal());

    expect(find.textContaining('venció'), findsOneWidget);
    expect(find.text('Pedir mi archivo'), findsOneWidget);
  });

  testWidgets('CA_029_15 el opcional cambia y el obligatorio no', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.metodo == 'PUT'
          ? jsonOk(_consentimiento('promociones', vigente: true))
          : jsonOk([
              _consentimiento('terminos', vigente: true, obligatorio: true),
              _consentimiento('promociones'),
              _consentimiento('algo_nuevo', obligatorio: true),
            ]),
    );
    await _montar(tester, api, const ConsentimientosReales());
    expect(find.text('Otro consentimiento'), findsOneWidget);

    await tester.tap(find.text('Términos y condiciones'));
    await asentarMaqueta(tester);
    expect(api.peticiones, hasLength(1));

    await tester.tap(find.text('Promociones y novedades'));
    await asentarMaqueta(tester);

    expect(api.peticiones.last.json, {'tipo': 'promociones', 'vigente': true});
    expect(find.textContaining('Versión v1'), findsNWidgets(2));
  });

  testWidgets('CA_029_27 vacío y error de consentimientos', (tester) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla ? http.Response('', 503) : jsonOk(<Object?>[]),
    );
    await _montar(tester, api, const ConsentimientosReales());
    expect(find.text('Reintentar'), findsOneWidget);

    falla = false;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);

    expect(find.textContaining('No hay consentimientos'), findsOneWidget);
  });

  testWidgets('CA_029_32 y CA_029_33 en inglés y con texto al 200 %', (
    tester,
  ) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final semantica = tester.ensureSemantics();
    final api = ApiFalsa(
      (p) => p.url.path.endsWith('ultima')
          ? http.Response('', 404)
          : jsonOk([_consentimiento('encuestas')]),
    );
    await _montar(
      tester,
      api,
      const Column(children: [ExportacionReal(), ConsentimientosReales()]),
      idioma: 'en',
    );

    expect(find.text('Download my data'), findsOneWidget);
    expect(find.text('Surveys to improve Knock'), findsOneWidget);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });
}
