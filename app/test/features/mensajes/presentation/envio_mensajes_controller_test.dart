import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/mensajes/domain/envio_de_mensajes.dart';
import 'package:app/features/mensajes/domain/mensaje.dart';
import 'package:app/features/mensajes/presentation/envio_mensajes_controller.dart';
import 'package:flutter_test/flutter_test.dart';

/// Envío de prueba: cada llamada espera a que la prueba la resuelva.
class EnvioDePrueba implements EnvioDeMensajes {
  final llamadas = <(String, String)>[];
  final pendientes = <Completer<Mensaje>>[];

  @override
  Future<Mensaje> enviar(String conversacionId, String texto) {
    llamadas.add((conversacionId, texto));
    final c = Completer<Mensaje>();
    pendientes.add(c);
    return c.future;
  }
}

Mensaje guardado(String texto, {bool contactoOculto = false}) => Mensaje(
  id: 'm-1',
  autorRol: 'cliente',
  texto: texto,
  contactoOculto: contactoOculto,
  enviadoEn: DateTime.utc(2026, 11, 27, 12),
);

void main() {
  late EnvioDePrueba envio;
  late EnvioMensajesController controller;

  setUp(() {
    envio = EnvioDePrueba();
    controller = EnvioMensajesController(envio, 'c1');
  });

  tearDown(() => controller.dispose());

  test('CA_020_E02 envío optimista: pendiente y luego el del '
      'servidor', () async {
    final enviando = controller.enviar('  Hola  ');
    expect(controller.estado.enviando, isTrue);
    final propio = controller.estado.mensajes.single;
    expect(propio.estado, EstadoDeEnvio.pendiente);
    expect(propio.textoVisible, 'Hola');
    expect(envio.llamadas, [('c1', 'Hola')]);

    envio.pendientes.single.complete(
      guardado('Llámame al ***', contactoOculto: true),
    );
    expect(await enviando, isNull);
    final enviado = controller.estado.mensajes.single;
    expect(enviado.estado, EstadoDeEnvio.enviado);
    expect(enviado.textoVisible, 'Llámame al ***');
    expect(enviado.contactoOculto, isTrue);
    expect(controller.estado.enviando, isFalse);
  });

  test('CA_020_E02 texto inválido no se envía', () async {
    expect(await controller.enviar(''), MotivoTextoInvalido.vacio);
    expect(await controller.enviar('a' * 1001), MotivoTextoInvalido.muyLargo);
    expect(
      await controller.enviar('a\tb'),
      MotivoTextoInvalido.caracterNoPermitido,
    );
    expect(envio.llamadas, isEmpty);
    expect(controller.estado.mensajes, isEmpty);
  });

  test('CA_020_E02 un envío a la vez', () async {
    unawaited(controller.enviar('uno'));
    await controller.enviar('dos');
    expect(envio.llamadas, hasLength(1));
  });

  test('CA_020_E02 la falla conserva el texto y no reintenta sola; '
      'reintentar es manual', () async {
    final primero = controller.enviar('Hola');
    envio.pendientes.single.completeError(
      const DemasiadosIntentosFailure(espera: Duration(seconds: 9)),
    );
    await primero;
    final fallido = controller.estado.mensajes.single;
    expect(fallido.estado, EstadoDeEnvio.fallido);
    expect(fallido.texto, 'Hola');
    expect(controller.estado.ultimaFalla, isA<DemasiadosIntentosFailure>());
    await pumpEventQueue();
    expect(envio.llamadas, hasLength(1));

    final reintento = controller.reintentar(fallido.idLocal);
    expect(controller.estado.mensajes.single.estado, EstadoDeEnvio.pendiente);
    envio.pendientes.last.complete(guardado('Hola'));
    await reintento;
    expect(envio.llamadas, [('c1', 'Hola'), ('c1', 'Hola')]);
    expect(controller.estado.mensajes.single.estado, EstadoDeEnvio.enviado);
    expect(controller.estado.ultimaFalla, isNull);
  });

  test(
    'CA_020_E02 409 conversation_closed cierra y bloquea el envío',
    () async {
      final primero = controller.enviar('Hola');
      envio.pendientes.single.completeError(const ConflictoFailure());
      await primero;
      expect(controller.estado.cerrada, isTrue);
      await controller.enviar('Otro');
      await controller.reintentar(controller.estado.mensajes.single.idLocal);
      expect(envio.llamadas, hasLength(1));
    },
  );

  test('CA_020_E02 conversación cerrada desde el inicio no envía', () async {
    final cerrada = EnvioMensajesController(envio, 'c1', cerrada: true);
    addTearDown(cerrada.dispose);
    await cerrada.enviar('Hola');
    expect(envio.llamadas, isEmpty);
  });

  test('CA_020_E02 descartar quita solo un fallido', () async {
    final primero = controller.enviar('Hola');
    envio.pendientes.single.completeError(
      const ModeracionNoDisponibleFailure(),
    );
    await primero;
    controller.descartar(controller.estado.mensajes.single.idLocal);
    expect(controller.estado.mensajes, isEmpty);
  });

  test('CA_020_E02 un error que no es Failure queda como sin '
      'conexión', () async {
    final primero = controller.enviar('Hola');
    envio.pendientes.single.completeError(Exception('red'));
    await primero;
    expect(controller.estado.ultimaFalla, isA<ServicioNoDisponibleFailure>());
  });
}
