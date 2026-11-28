import 'package:app/core/errores/failure.dart';
import 'package:app/features/mensajes/data/canal_mensajes_signalr.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/api_falsa.dart';
import '../../../soporte/mensajes_falsos.dart';

void main() {
  test('CA_020_13 el evento noLeidos sube el contador sin recargar', () async {
    final canal = CanalDePrueba();
    final c = contenedorConApi(
      ApiFalsa((_) => jsonOk({})),
      extra: [
        canalMensajesProvider.overrideWithValue(canal),
        conversacionesRepositoryProvider.overrideWithValue(
          ConversacionesDePrueba(),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(globoProvider, (_, _) {});
    await pumpEventQueue();
    expect(c.read(globoProvider).conectado, isTrue);
    expect(c.read(globoProvider).total, 3);

    canal.emitir(4);
    expect(c.read(globoProvider).total, 4);
  });

  test('CA_020_13 solo acepta un total válido del evento', () {
    expect(
      totalDeNoLeidos([
        {'conversacionId': 'c1', 'noLeidos': 1, 'total': 5},
      ]),
      5,
    );
    for (final argumentos in <List<Object?>?>[
      null,
      [],
      ['5'],
      [
        {'total': -1},
      ],
      [
        {'total': '5'},
      ],
    ]) {
      expect(totalDeNoLeidos(argumentos), isNull);
    }
  });

  test('el canal no se abre sin URL válida ni sin token', () async {
    void nada(int _) {}
    await expectLater(
      CanalMensajesSignalR(
        url: '',
        token: () => 'x',
      ).abrir(alCambiarContador: nada, alCaerse: () {}),
      throwsA(isA<ApiNoConfiguradaFailure>()),
    );
    final sinToken = CanalMensajesSignalR(url: urlApiPrueba, token: () => null);
    await expectLater(
      sinToken.abrir(alCambiarContador: nada, alCaerse: () {}),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    await sinToken.cerrar();
  });
}
