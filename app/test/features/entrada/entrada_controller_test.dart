// KNOCK-228: controlador de la entrada con un servicio falso (sin red).
import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/entrada/presentation/entrada_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/entrada_falsa.dart';

void main() {
  late ServicioEntradaFalso servicio;
  late ProviderContainer contenedor;

  setUp(() {
    servicio = ServicioEntradaFalso();
    contenedor = ProviderContainer(
      overrides: [servicioEntradaProvider.overrideWithValue(servicio)],
    );
  });

  tearDown(() => contenedor.dispose());

  EntradaController controlador() =>
      contenedor.read(entradaControllerProvider.notifier);
  EntradaUiState estado() => contenedor.read(entradaControllerProvider);

  test('un celular inválido no llega al servicio', () async {
    expect(await controlador().enviarCodigo('55123'), isFalse);
    expect(servicio.celularesEnviados, isEmpty);
    expect(estado().error, isA<CelularRechazadoFailure>());
  });

  test('enviar guarda la solicitud y verificar inicia la sesión', () async {
    expect(await controlador().enviarCodigo('5512345678'), isTrue);
    expect(estado().solicitud?.celular, '5512345678');
    expect(contenedor.read(sesionIniciadaProvider), isFalse);

    final resultado = await controlador().verificar('123456');

    expect(resultado?.esNuevo, isTrue);
    expect(servicio.codigosVerificados, ['123456']);
    expect(contenedor.read(sesionIniciadaProvider), isTrue);
    expect(estado().cargando, isFalse);
    expect(estado().error, isNull);
  });

  test('un error del canje queda en el estado y no inicia la sesión', () async {
    servicio.errorAlVerificar = const CuentaSuspendidaFailure();
    await controlador().enviarCodigo('5512345678');

    expect(await controlador().verificar('123456'), isNull);

    expect(estado().error, isA<CuentaSuspendidaFailure>());
    expect(estado().cargando, isFalse);
    expect(estado().solicitud, isNotNull, reason: 'se puede reintentar');
    expect(contenedor.read(sesionIniciadaProvider), isFalse);
  });

  test('un código de menos de 6 dígitos no llega al servicio', () async {
    await controlador().enviarCodigo('5512345678');
    expect(await controlador().verificar('123'), isNull);
    expect(servicio.codigosVerificados, isEmpty);
    expect(estado().error, isA<CodigoIncorrectoFailure>());
  });

  test('verificar sin haber pedido el código avisa que venció', () async {
    expect(await controlador().verificar('123456'), isNull);
    expect(estado().error, isA<CodigoVencidoFailure>());
  });

  test('reenviar usa la solicitud anterior', () async {
    await controlador().enviarCodigo('5512345678');
    expect(await controlador().reenviar(), isTrue);
    expect(servicio.reenvios, 1);
  });

  test('limpiarError quita el mensaje', () async {
    servicio.errorAlEnviar = const DemasiadosIntentosFailure();
    await controlador().enviarCodigo('5512345678');
    expect(estado().error, isA<DemasiadosIntentosFailure>());
    controlador().limpiarError();
    expect(estado().error, isNull);
  });
}
