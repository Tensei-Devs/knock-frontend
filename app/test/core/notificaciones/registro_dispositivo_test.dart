import 'package:app/core/notificaciones/registro_dispositivo_controller.dart';
import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/fakes_notificaciones.dart';

({
  ProviderContainer contenedor,
  RegistroDispositivosSimulado servidor,
  ServicioNotificacionesFalso servicio,
})
_preparar({EstadoPermiso permiso = EstadoPermiso.concedido}) {
  final servidor = RegistroDispositivosSimulado();
  final servicio = ServicioNotificacionesFalso();
  final contenedor = ProviderContainer(
    overrides: [
      registroDispositivosRepositoryProvider.overrideWithValue(servidor),
      servicioNotificacionesProvider.overrideWithValue(servicio),
      gestorPermisosProvider.overrideWithValue(
        GestorPermisosFalso(estadoInicial: permiso),
      ),
    ],
  );
  addTearDown(contenedor.dispose);
  return (contenedor: contenedor, servidor: servidor, servicio: servicio);
}

EstadoRegistro _estado(ProviderContainer c) =>
    c.read(registroDispositivoControllerProvider);

void main() {
  group('CA-012-01 el identificador se registra al aceptar', () {
    test('CA_012_01 con el permiso concedido queda registrado', () async {
      final t = _preparar();
      await t.contenedor
          .read(registroDispositivoControllerProvider.notifier)
          .alIniciarSesion();

      expect(_estado(t.contenedor), isA<Registrado>());
      expect(t.servidor.registrados, {'id-prueba-1'});
    });

    test('CA_012_01 sin aceptar las notificaciones no se registra', () async {
      final t = _preparar(permiso: EstadoPermiso.denegado);
      await t.contenedor
          .read(registroDispositivoControllerProvider.notifier)
          .alIniciarSesion();

      expect(_estado(t.contenedor), isA<SinPermisoDeNotificaciones>());
      expect(t.servidor.registrados, isEmpty);
    });

    test('CA_012_01 sin identificador del servicio no registra nada', () async {
      final t = _preparar();
      t.servicio.identificador = null;
      await t.contenedor
          .read(registroDispositivoControllerProvider.notifier)
          .alIniciarSesion();

      expect(_estado(t.contenedor), isA<SinIdentificador>());
      expect(t.servidor.registrados, isEmpty);
    });

    test('CA_012_01 si el servidor falla queda RegistroFallido', () async {
      final t = _preparar();
      t.servidor.fallo = Exception('x');
      await t.contenedor
          .read(registroDispositivoControllerProvider.notifier)
          .alIniciarSesion();

      expect(_estado(t.contenedor), isA<RegistroFallido>());
    });

    test('CA_012_01 el estado no imprime el identificador', () async {
      final t = _preparar();
      await t.contenedor
          .read(registroDispositivoControllerProvider.notifier)
          .alIniciarSesion();

      expect('${_estado(t.contenedor)}', isNot(contains('id-prueba-1')));
    });
  });

  group('CA-012-02 el identificador se desregistra al cerrar sesión', () {
    test('CA_012_02 se desregistra y se invalida en el teléfono', () async {
      final t = _preparar();
      final control = t.contenedor.read(
        registroDispositivoControllerProvider.notifier,
      );
      await control.alIniciarSesion();

      final confirmado = await control.alCerrarSesion();

      expect(confirmado, isTrue);
      expect(t.servidor.registrados, isEmpty);
      expect(t.servicio.borrados, 1);
      expect(_estado(t.contenedor), isA<SinRegistrar>());
    });

    test('CA_012_02 seguridad negativa: si el servidor falla, el identificador '
        'se invalida igual en el teléfono', () async {
      final t = _preparar();
      final control = t.contenedor.read(
        registroDispositivoControllerProvider.notifier,
      );
      await control.alIniciarSesion();
      t.servidor.fallo = Exception('sin red');

      final confirmado = await control.alCerrarSesion();

      expect(confirmado, isFalse);
      expect(t.servicio.borrados, 1);
      expect(t.servicio.identificador, isNull);
      expect(_estado(t.contenedor), isA<SinRegistrar>());
    });

    test('CA_012_02 cerrar sesión sin haber registrado no falla', () async {
      final t = _preparar(permiso: EstadoPermiso.denegado);
      final confirmado = await t.contenedor
          .read(registroDispositivoControllerProvider.notifier)
          .alCerrarSesion();

      expect(confirmado, isTrue);
      expect(t.servicio.borrados, 1);
    });
  });
}
