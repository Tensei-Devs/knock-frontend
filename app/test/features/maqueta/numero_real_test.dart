// Spec 029: cambio de número y recuperación de acceso contra la API falsa, con
// un verificador de celular de prueba. Solo números ficticios.
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/features/maqueta/numero_real.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

class _Verificador implements VerificadorCelular {
  final enviados = <String>[];

  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) async {
    enviados.add(celular);
    return SolicitudCodigo(celular: celular, idVerificacion: 'v-1');
  }

  @override
  Future<String> tokenDeId(SolicitudCodigo solicitud, String codigo) async =>
      'prueba-ficticia';

  @override
  Future<void> cerrarSesion() async {}
}

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api,
  _Verificador verificador, {
  bool recuperar = false,
}) async {
  tester.view.physicalSize = const Size(400, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final c = contenedorConApi(
    api,
    tokens: recuperar ? null : tokensA,
    extra: [verificadorCelularProvider.overrideWithValue(verificador)],
  );
  addTearDown(c.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: HojaDeNumeroReal(recuperar: recuperar),
          ),
        ),
      ),
    ),
  );
}

Future<void> _tocar(WidgetTester tester, String texto) async {
  await tester.tap(find.text(texto));
  await tester.pumpAndSettle();
}

Future<void> _escribir(WidgetTester tester, int campo, String texto) async {
  await tester.enterText(find.byType(TextField).at(campo), texto);
  await tester.pump();
}

void main() {
  testWidgets('CA_029_01 comprueba, manda el SMS y confirma', (tester) async {
    final api = ApiFalsa((_) => http.Response('', 204));
    final verificador = _Verificador();
    await _montar(tester, api, verificador);
    await _escribir(tester, 0, '7710000001');
    await _tocar(tester, 'Enviarme el código');
    await _escribir(tester, 0, '123456');
    await _tocar(tester, 'Confirmar');
    expect(verificador.enviados, ['7710000001']);
    expect(api.peticiones.map((p) => p.llamadaCompleta), [
      'POST /api/v1/me/cambio-numero',
      'POST /api/v1/me/cambio-numero/confirmar',
    ]);
    expect(api.peticiones.first.json, {'celularNuevo': '+527710000001'});
    expect(api.peticiones.last.json, {'firebaseIdToken': 'prueba-ficticia'});
  });

  testWidgets('CA_029_03 un número en uso no gasta el SMS y conserva lo '
      'escrito', (tester) async {
    final verificador = _Verificador();
    await _montar(tester, ApiFalsa((_) => http.Response('', 409)), verificador);
    await _escribir(tester, 0, '7710000001');
    await _tocar(tester, 'Enviarme el código');
    expect(find.text('Ese número ya pertenece a otra cuenta.'), findsOneWidget);
    expect(find.text('7710000001'), findsOneWidget);
    expect(verificador.enviados, isEmpty);
  });

  testWidgets('CA_029_07 la recuperación sale sin sesión', (tester) async {
    final api = ApiFalsa((_) => http.Response('', 202));
    await _montar(tester, api, _Verificador(), recuperar: true);
    await _escribir(tester, 0, '7710000002');
    await _escribir(tester, 1, '7710000001');
    await _tocar(tester, 'Soy técnico');
    await _tocar(tester, 'Enviarme el código');
    await _escribir(tester, 0, '123456');
    await _tocar(tester, 'Confirmar');
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'POST /api/v1/recuperacion-acceso');
    expect(p.autorizacion, isNull);
    expect(p.json, {
      'firebaseIdToken': 'prueba-ficticia',
      'celularAnterior': '+527710000002',
      'tipo': 'tecnico',
    });
    expect(find.textContaining('Recibimos tu solicitud'), findsOneWidget);
  });
}
