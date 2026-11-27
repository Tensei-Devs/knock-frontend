// Spec 016: un envío a la vez, sin reintentos y con el bloqueo del servidor.
import 'dart:async';

import 'package:app/features/trabajo/trabajo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../soporte/api_falsa.dart';
import '../../../soporte/llegada_json.dart';

final _estado = llegadaControllerProvider(visitaDeLlegadaId);

ProviderContainer _contenedor(ApiFalsa api) {
  final c = contenedorConApi(api);
  addTearDown(c.dispose);
  // Mantiene vivo el controlador `autoDispose` durante la prueba.
  c.listen(_estado, (_, _) {});
  return c;
}

Future<void> _enviar(ProviderContainer c, String codigo) =>
    c.read(_estado.notifier).confirmar(codigo);

void main() {
  test('CA_016_10 el código correcto deja la visita en curso', () async {
    final api = ApiFalsa(
      (_) => jsonOk(visitaTecnicoJson(estado: 'en_curso', puedeLlegar: false)),
    );
    final c = _contenedor(api);
    await _enviar(c, '4821');
    expect(c.read(_estado).confirmada?.enCurso, isTrue);
    await _enviar(c, '4821');
    expect(api.peticiones, hasLength(1));
  });

  test('CA_016_11 el doble toque manda una sola petición', () async {
    final respuesta = Completer<http.Response>();
    final api = ApiFalsa((_) => respuesta.future);
    final c = _contenedor(api);
    final primero = _enviar(c, '1111');
    final segundo = _enviar(c, '1111');
    expect(c.read(_estado).enviando, isTrue);
    respuesta.complete(
      problemaJson(422, 'wrong_code', {'intentosRestantes': 2}),
    );
    await Future.wait([primero, segundo]);
    expect(api.peticiones, hasLength(1));
    expect(c.read(_estado).intentosRestantes, 2);
    expect(c.read(_estado).cerrada, isFalse);
  });

  test('CA_016_12 la visita bloqueada no admite otro envío', () async {
    final api = ApiFalsa((_) => problemaJson(409, 'visit_locked'));
    final c = _contenedor(api);
    await _enviar(c, '1111');
    expect(c.read(_estado).cerrada, isTrue);
    await _enviar(c, '2222');
    expect(api.peticiones, hasLength(1));
  });

  test('CA_016_13 menos de 4 dígitos no sale del teléfono', () async {
    final api = ApiFalsa();
    final c = _contenedor(api);
    await _enviar(c, '12a');
    expect(c.read(_estado).motivo, MotivoLlegada.formato);
    expect(api.peticiones, isEmpty);
  });

  test('CA_016_17 sin respuesta avisa que reintentar cuenta', () async {
    final api = ApiFalsa((_) => throw http.ClientException('sin red'));
    final c = _contenedor(api);
    await _enviar(c, '4821');
    expect(c.read(_estado).respuestaPerdida, isTrue);
    expect(c.read(_estado).cerrada, isFalse);
    expect(api.peticiones, hasLength(1));
  });
}
