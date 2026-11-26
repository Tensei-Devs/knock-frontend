import 'package:app/core/config/modo_maqueta.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/main.dart' as knock;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../test/soporte/api_falsa.dart';
import 'entrada_ficticia.dart';

/// Arranque común de los E2E de humo (KNOCK-293): app real en el teléfono, con
/// la API siempre falsa. Aunque se compile con `--dart-define=KNOCK_API_URL`,
/// ninguna petición de la app sale a la red por su transporte.
///
/// - Sin [api]: la app corre sin URL de API (datos de ejemplo).
/// - Con [api]: la URL es ficticia y todo lo contesta [api].
/// - [conSesion]: deja tokens ficticios en el almacenamiento seguro real del
///   teléfono antes de arrancar, como si ya se hubiera entrado.
///
/// - [maqueta] en falso: la app normal (`MODO_MAQUETA=false`).
///
/// Borra la sesión y las preferencias guardadas de la app en el dispositivo.
Future<void> arrancarE2e(
  WidgetTester tester, {
  ApiFalsa? api,
  bool conSesion = false,
  bool maqueta = true,
}) async {
  final preferencias = await SharedPreferences.getInstance();
  await preferencias.clear();
  await sinSesionGuardada();
  if (conSesion) {
    await AlmacenSesion(AlmacenSeguroFlutterSecureStorage())
        .guardar(acceso: tokensA.accessToken, refresco: tokensA.refreshToken);
  }
  maq.resetAll();
  addTearDown(() async {
    await preferencias.clear();
    await sinSesionGuardada();
    maq.resetAll();
  });
  final falsa = api ?? ApiFalsa((_) => http.Response('', 503));
  await knock.arrancar(
    overrides: [
      ...entradaFicticia,
      modoMaquetaProvider.overrideWithValue(maqueta),
      urlApiProvider.overrideWithValue(api == null ? '' : urlApiPrueba),
      transporteHttpProvider.overrideWithValue(falsa.transporte),
      transporteDeSubidasProvider.overrideWithValue(falsa.cliente),
      // Sin sondeo periódico: cada recorrido pide lo que necesita.
      intervaloRefrescoSolicitudProvider.overrideWithValue(null),
    ],
  );
  await asentar(tester);
}

/// Espera a que no queden cuadros pendientes. Con un límite: en el teléfono
/// una animación que no termina no debe colgar la suite diez minutos.
Future<void> asentar(WidgetTester tester) async {
  await tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 20),
  );
}

/// Desplaza hasta [f] si hace falta, toca el primero y espera.
Future<void> tocar(WidgetTester tester, Finder f) async {
  expect(f, findsWidgets);
  await tester.ensureVisible(f.first);
  await asentar(tester);
  await tester.tap(f.first);
  await asentar(tester);
}

Finder enLaBarra(String etiqueta) => find.descendant(
  of: find.byType(NavigationBar),
  matching: find.text(etiqueta),
);
