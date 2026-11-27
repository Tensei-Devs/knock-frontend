// Spec 029 y 045: eliminar la cuenta con la API: pendientes, confirmación,
// verificación por SMS, errores y cancelación. Solo datos ficticios.
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/features/cuenta/cuenta.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/eliminar_real.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

class _Verificador implements VerificadorCelular {
  final celulares = <String>[];
  int cierres = 0;

  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) async {
    celulares.add(celular);
    return SolicitudCodigo(celular: celular, idVerificacion: 'v-1');
  }

  @override
  Future<String> tokenDeId(SolicitudCodigo solicitud, String codigo) async =>
      'prueba-$codigo';

  @override
  Future<void> cerrarSesion() async => cierres++;
}

/// Monta [pantalla] con la API falsa y las rutas a las que puede ir.
Future<ProviderContainer> _montar(
  WidgetTester tester,
  ApiFalsa api,
  Widget pantalla, {
  VerificadorCelular? verificador,
  String idioma = 'es',
}) async {
  final c = contenedorConApi(
    api,
    extra: [
      if (verificador != null)
        verificadorCelularProvider.overrideWithValue(verificador),
    ],
  );
  addTearDown(c.dispose);
  final router = GoRouter(
    initialLocation: '/prueba',
    routes: [
      GoRoute(
        path: '/prueba',
        builder: (_, _) => Scaffold(body: pantalla),
      ),
      GoRoute(path: RM.eliminado, builder: (_, _) => const Text('destino-fin')),
      GoRoute(path: '/cuenta', builder: (_, _) => const Text('destino-cuenta')),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp.router(
        locale: Locale(idioma),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await asentarMaqueta(tester);
  return c;
}

Future<void> _tocar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto));
  await tester.tap(find.text(texto));
  await asentarMaqueta(tester);
}

Future<void> _escribir(WidgetTester tester, int campo, String texto) async {
  await tester.ensureVisible(find.byType(TextField).at(campo));
  await tester.enterText(find.byType(TextField).at(campo), texto);
  await asentarMaqueta(tester);
}

http.Response _programada() =>
    jsonOk({'eliminarEn': '2026-12-03T18:00:00Z'}, estado: 202);

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_029_28 pendientes: error, vacío y con datos', (tester) async {
    var respuesta = 503;
    final api = ApiFalsa(
      (_) => respuesta == 503
          ? http.Response('', 503)
          : jsonOk({
              'citas': {'total': respuesta, 'ids': <String>[]},
              'cotizaciones': {'total': 0, 'ids': <String>[]},
            }),
    );
    final c = await _montar(tester, api, const PendientesReales());
    expect(find.text('Reintentar'), findsOneWidget);

    respuesta = 0;
    await _tocar(tester, 'Reintentar');
    expect(find.textContaining('No tienes citas'), findsOneWidget);

    respuesta = 2;
    c.invalidate(pendientesControllerProvider);
    await asentarMaqueta(tester);
    expect(find.text('Citas abiertas: 2'), findsOneWidget);
  });

  testWidgets('CA_029_29 solo con ELIMINAR; el 409 conserva lo escrito', (
    tester,
  ) async {
    var estado = 409;
    final api = ApiFalsa(
      (p) => p.ruta == 'me'
          ? jsonOk(perfilJson())
          : estado == 409
          ? http.Response('', 409)
          : _programada(),
    );
    await _montar(tester, api, const EliminarCuentaReal());

    await _escribir(tester, 0, 'eliminar');
    await _tocar(tester, 'Eliminar mi cuenta');
    expect(api.peticiones, isEmpty);

    await _escribir(tester, 0, 'ELIMINAR');
    await _tocar(tester, 'Eliminar mi cuenta');
    expect(find.textContaining('visita en curso'), findsOneWidget);
    expect(find.text('ELIMINAR'), findsOneWidget);

    estado = 202;
    await _tocar(tester, 'Eliminar mi cuenta');
    expect(find.text('destino-fin'), findsOneWidget);
  });

  testWidgets('sesión de más de 24 horas: pide el SMS y reenvía la prueba', (
    tester,
  ) async {
    maq.user.phone = '771 000 0000';
    final verificador = _Verificador();
    var sinServicio = true;
    final api = ApiFalsa((p) {
      if (p.ruta == 'me') return jsonOk(perfilJson());
      if (p.json['firebaseIdToken'] == null) {
        return jsonOk({
          'errors': {
            'firebaseIdToken': ['Is required.'],
          },
        }, estado: 422);
      }
      return sinServicio ? http.Response('', 503) : _programada();
    });
    await _montar(
      tester,
      api,
      const EliminarCuentaReal(),
      verificador: verificador,
    );

    await _escribir(tester, 0, 'ELIMINAR');
    await _tocar(tester, 'Eliminar mi cuenta');
    await _tocar(tester, 'Enviarme el código');
    expect(verificador.celulares, ['7710000000']);

    await _escribir(tester, 2, '123456');
    await _tocar(tester, 'Eliminar mi cuenta');
    expect(find.textContaining('No pudimos conectar'), findsOneWidget);
    expect(verificador.cierres, 1);

    sinServicio = false;
    await _tocar(tester, 'Eliminar mi cuenta');
    expect(api.peticiones.last.ruta, isNot('me/eliminacion/cancelar'));
    expect(find.text('destino-fin'), findsOneWidget);
    expect(verificador.cierres, 1);
  });

  testWidgets('una prueba rechazada pide otro código', (tester) async {
    maq.user.phone = '7710000000';
    final api = ApiFalsa(
      (_) => jsonOk({
        'errors': {
          'firebaseIdToken': ['The token is not valid.'],
        },
      }, estado: 422),
    );
    await _montar(
      tester,
      api,
      const EliminarCuentaReal(),
      verificador: _Verificador(),
    );
    await _escribir(tester, 0, 'ELIMINAR');
    await _tocar(tester, 'Eliminar mi cuenta');
    await _tocar(tester, 'Enviarme el código');
    await _escribir(tester, 2, '123456');
    await _tocar(tester, 'Eliminar mi cuenta');

    expect(find.textContaining('No pudimos confirmar'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('CA_029_30 sin eliminación programada lo dice', (tester) async {
    final api = ApiFalsa((_) => jsonOk(perfilJson()));
    await _montar(tester, api, EliminadaReal(alSalir: () async {}));

    expect(find.text('No tienes una eliminación programada'), findsOneWidget);
    expect(find.text('Cancelar la eliminación'), findsNothing);
    await _tocar(tester, 'Ir a Mi cuenta');
    expect(find.text('destino-cuenta'), findsOneWidget);
  });

  testWidgets('CA_029_30 error con Reintentar y cancelar la eliminación', (
    tester,
  ) async {
    var falla = true;
    var salio = false;
    final api = ApiFalsa((p) {
      if (p.metodo == 'POST') return http.Response('', 200);
      return falla
          ? http.Response('', 503)
          : jsonOk({...perfilJson(), 'estado': 'eliminacion_programada'});
    });
    await _montar(
      tester,
      api,
      EliminadaReal(alSalir: () async => salio = true),
    );
    expect(find.text('Reintentar'), findsOneWidget);

    falla = false;
    await _tocar(tester, 'Reintentar');
    expect(find.textContaining('programada para eliminarse'), findsOneWidget);
    await _tocar(tester, 'Salir');
    expect(salio, isTrue);

    await _tocar(tester, 'Cancelar la eliminación');
    expect(api.llamadas, contains('POST me/eliminacion/cancelar'));
    expect(find.text('destino-cuenta'), findsOneWidget);
  });

  testWidgets('CA_029_31 el aviso de Mi cuenta cancela y explica el 409', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.metodo == 'POST' ? http.Response('', 409) : jsonOk(perfilJson()),
    );
    await _montar(tester, api, const AvisoDeEliminacionReal());
    final avisos = <String>[];
    final escucha = maq.avisos.stream.listen((a) => avisos.add(a.msg));
    addTearDown(escucha.cancel);

    await _tocar(tester, 'Cancelar la eliminación');

    expect(avisos, ['No hay una eliminación programada que cancelar.']);
  });

  testWidgets('CA_029_32 y CA_029_33 en inglés y con texto al 200 %', (
    tester,
  ) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final semantica = tester.ensureSemantics();
    await _montar(tester, ApiFalsa(), const EliminarCuentaReal(), idioma: 'en');

    expect(find.text('Type ELIMINAR to confirm'), findsOneWidget);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });
}
