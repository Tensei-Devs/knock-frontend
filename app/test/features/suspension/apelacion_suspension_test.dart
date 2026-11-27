// Spec 033, enmienda del 2026-11-26 (CA-E01 a CA-E03): apelación de una cuenta
// suspendida contra una API falsa. Datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/features/suspension/suspension_providers.dart';
import 'package:app/features/suspension/data/apelacion_suspension_repository_api.dart';
import 'package:app/features/suspension/domain/apelacion_suspension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/entrada_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/preparar_maqueta.dart';

const _idToken = 'token-sms-ficticio';

class _Verificador implements VerificadorCelular {
  int cierres = 0;

  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) async => SolicitudCodigo(celular: celular, idVerificacion: 'v-1');

  @override
  Future<String> tokenDeId(SolicitudCodigo solicitud, String codigo) async =>
      _idToken;

  @override
  Future<void> cerrarSesion() async => cierres++;
}

Map<String, Object?> _apelacion({String estado = 'pendiente'}) => {
  'estado': estado,
  'presentadaEn': '2026-11-26T12:00:00Z',
};

ApiFalsa _api({int consulta = 404, int envio = 200}) => ApiFalsa((p) {
  final estado = p.metodo == 'GET' ? consulta : envio;
  return estado == 200
      ? jsonOk(_apelacion())
      : jsonOk(<String, Object?>{}, estado: estado);
});

Future<void> _tocar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto));
  await tester.tap(find.text(texto));
  await asentarMaqueta(tester);
}

Future<_Verificador> _hastaVerificar(WidgetTester tester, ApiFalsa api) async {
  final verificador = _Verificador();
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = await montarApp(
    tester,
    esTecnico: false,
    sesionIniciada: false,
    extra: [
      verificadorCelularProvider.overrideWithValue(verificador),
      apelacionSuspensionRepositoryProvider.overrideWithValue(
        ApelacionSuspensionRepositoryApi(
          transporte: api.cliente,
          url: urlApiPrueba,
        ),
      ),
    ],
  );
  container.read(appRouterProvider).go(Rutas.apelacion);
  await asentarMaqueta(tester);
  await tester.enterText(find.byType(TextField), '7712345678');
  await _tocar(tester, 'Enviarme el código');
  await tester.enterText(find.byType(TextField), '123456');
  await _tocar(tester, 'Verificar');
  return verificador;
}

Future<void> _presentar(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField), 'No fui yo, revisen');
  await _tocar(tester, 'Enviar apelación');
}

void main() {
  test('CA_033_E01 las dos rutas llevan el idToken de Firebase', () async {
    final api = _api(consulta: 200);
    final repo = ApelacionSuspensionRepositoryApi(
      transporte: api.cliente,
      url: urlApiPrueba,
    );
    await repo.consultar(_idToken);
    await repo.presentar(_idToken, 'No fui yo, revisen');
    expect(api.peticiones.map((p) => p.llamadaCompleta), [
      'GET /api/v1/suspension/apelacion',
      'POST /api/v1/suspension/apelacion',
    ]);
    expect(
      api.peticiones.map((p) => p.autorizacion),
      everyElement('Bearer $_idToken'),
    );
    expect(api.peticiones.last.json, {'texto': 'No fui yo, revisen'});
  });

  test('cada error del contrato tiene su Failure', () async {
    for (final (estado, falla) in [
      (400, isA<DatosRechazadosFailure>()),
      (401, isA<NoAutorizadoFailure>()),
      (404, isA<NoEncontradoFailure>()),
      (409, isA<ApelacionNoPermitidaFailure>()),
      (413, isA<DatosRechazadosFailure>()),
      (422, isA<DatosRechazadosFailure>()),
    ]) {
      final repo = ApelacionSuspensionRepositoryApi(
        transporte: _api(consulta: estado).cliente,
        url: urlApiPrueba,
      );
      await expectLater(repo.consultar(_idToken), throwsA(falla));
    }
  });

  test('el texto va de 8 a 500 caracteres', () {
    expect(textoDeApelacionValido('  corto  '), isFalse);
    expect(textoDeApelacionValido('a' * 8), isTrue);
    expect(textoDeApelacionValido('a' * 501), isFalse);
  });

  testWidgets('con una apelación presentada muestra su estado', (tester) async {
    final verificador = await _hastaVerificar(tester, _api(consulta: 200));
    expect(find.text('Tu apelación está en revisión.'), findsOneWidget);
    expect(verificador.cierres, 1);
  });

  testWidgets('tras un 404 al consultar deja presentar la apelación', (
    tester,
  ) async {
    final api = _api();
    await _hastaVerificar(tester, api);
    expect(find.textContaining('No hay una apelación'), findsOneWidget);
    await _presentar(tester);
    expect(find.text('Tu apelación está en revisión.'), findsOneWidget);
  });

  for (final (estado, texto) in [
    (404, 'No hay una apelación disponible.'),
    (409, 'No se puede presentar otra apelación.'),
  ]) {
    testWidgets('CA_033_E03 un $estado al enviar quita el formulario', (
      tester,
    ) async {
      await _hastaVerificar(tester, _api(envio: estado));
      await _presentar(tester);
      expect(find.text(texto), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });
  }

  testWidgets('un 422 conserva lo escrito', (tester) async {
    await _hastaVerificar(tester, _api(envio: 422));
    await _presentar(tester);
    expect(find.text('No fui yo, revisen'), findsOneWidget);
  });

  testWidgets('CA_033_E02 un 401 pide verificar el número otra vez', (
    tester,
  ) async {
    await _hastaVerificar(tester, _api(consulta: 401));
    expect(
      find.text('Verifica tu número otra vez con un código por SMS.'),
      findsOneWidget,
    );
    expect(find.text('Enviarme el código'), findsOneWidget);
  });

  testWidgets('sin conexión al consultar deja reintentar', (tester) async {
    var falla = true;
    await _hastaVerificar(
      tester,
      ApiFalsa((_) {
        if (falla) throw http.ClientException('sin red');
        return jsonOk(_apelacion(estado: 'rechazada'));
      }),
    );
    falla = false;
    await _tocar(tester, 'Reintentar');
    expect(find.text('Tu apelación fue rechazada.'), findsOneWidget);
  });

  testWidgets('la cuenta suspendida ofrece apelar al entrar', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await montarApp(
      tester,
      esTecnico: false,
      sesionIniciada: false,
      servicioEntrada: ServicioEntradaFalso()
        ..errorAlVerificar = const CuentaSuspendidaFailure(),
    );
    await tester.enterText(find.byType(TextField), '7712345678');
    await tester.tap(find.byType(Checkbox));
    await _tocar(tester, 'Continuar');
    await tester.enterText(find.byType(TextField), '123456');
    await _tocar(tester, 'Entrar');
    await _tocar(tester, 'Apelar la suspensión');
    expect(find.text('Tu apelación'), findsOneWidget);
  });
}
