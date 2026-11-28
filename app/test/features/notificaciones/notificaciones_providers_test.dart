// Spec 012 (KNOCK-60): interruptor NOTIFICACIONES_PUSH y flujo completo con
// FCM falso y API falsa: permiso, registro al iniciar sesión y baja al
// cerrarla. Identificadores ficticios; sin Firebase ni red.
import 'package:app/core/notificaciones/registro_dispositivo_controller.dart';
import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/core/notificaciones/registro_dispositivos_provider.dart';
import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/notificaciones/data/registro_dispositivos_api.dart';
import 'package:app/features/notificaciones/data/servicio_notificaciones_fcm.dart';
import 'package:app/features/notificaciones/notificaciones_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/api_falsa.dart';
import '../../soporte/fuente_fcm_falsa.dart';

ProviderContainer _contenedor({
  required bool pushActivo,
  required bool firebaseListo,
  FuenteFcmFalsa? fuente,
  ApiFalsa? api,
}) {
  final c = contenedorConApi(
    api ?? ApiFalsa(),
    extra: [
      ...overridesDeNotificaciones(
        pushActivo: pushActivo,
        firebaseListo: firebaseListo,
      ),
      fuenteFcmProvider.overrideWithValue(fuente ?? FuenteFcmFalsa()),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('interruptor NOTIFICACIONES_PUSH', () {
    test('apagado: sin FCM ni permiso, aunque Firebase esté listo', () {
      final c = _contenedor(pushActivo: false, firebaseListo: true);
      expect(
        c.read(servicioNotificacionesProvider),
        isA<ServicioNotificacionesNoDisponible>(),
      );
      expect(c.read(gestorPermisosProvider), isA<GestorPermisosNoDisponible>());
    });

    test('encendido sin Firebase iniciado: sigue sin notificaciones', () {
      final c = _contenedor(pushActivo: true, firebaseListo: false);
      expect(
        c.read(servicioNotificacionesProvider),
        isA<ServicioNotificacionesNoDisponible>(),
      );
      expect(c.read(gestorPermisosProvider), isA<GestorPermisosNoDisponible>());
    });

    test('encendido con Firebase: usa FCM', () {
      final c = _contenedor(pushActivo: true, firebaseListo: true);
      expect(
        c.read(servicioNotificacionesProvider),
        isA<ServicioNotificacionesFcm>(),
      );
      expect(c.read(gestorPermisosProvider), isA<GestorPermisosFcm>());
    });

    test('el registro usa el contrato real con KNOCK_API_URL', () {
      final c = _contenedor(pushActivo: false, firebaseListo: false);
      expect(
        c.read(registroDispositivosRepositoryProvider),
        isA<RegistroDispositivosApi>(),
      );
    });

    test('sin KNOCK_API_URL el registro es el simulado', () {
      final c = ProviderContainer(
        overrides: [
          urlApiProvider.overrideWithValue(''),
          ...overridesDeNotificaciones(pushActivo: false, firebaseListo: false),
        ],
      );
      addTearDown(c.dispose);
      expect(
        c.read(registroDispositivosRepositoryProvider),
        isA<RegistroDispositivosSimulado>(),
      );
    });
  });

  group('flujo con FCM y la API', () {
    test('CA_012_01 y CA_012_02 permiso, registro con el identificador de '
        'FCM y baja al cerrar sesión', () async {
      final fuente = FuenteFcmFalsa();
      final api = ApiFalsa(
        (p) => p.metodo == 'POST'
            ? jsonOk({'id': 'disp-1'}, estado: 201)
            : jsonOk(<String, Object?>{}, estado: 204),
      );
      final c = _contenedor(
        pushActivo: true,
        firebaseListo: true,
        fuente: fuente,
        api: api,
      );
      final control = c.read(registroDispositivoControllerProvider.notifier);

      // Sin permiso no se registra nada.
      await control.alIniciarSesion();
      expect(api.peticiones, isEmpty);
      expect(
        c.read(registroDispositivoControllerProvider),
        isA<SinPermisoDeNotificaciones>(),
      );

      // La persona acepta (lo pide la pantalla tras la explicación).
      await c.read(gestorPermisosProvider).pedir(PermisoApp.notificaciones);
      await control.alIniciarSesion();
      final post = api.peticiones.single;
      expect(post.llamadaCompleta, 'POST /api/v1/dispositivos');
      expect(post.json['identificador'], 'fcm-prueba-1');
      expect(post.autorizacion, 'Bearer acc-A');
      expect(c.read(registroDispositivoControllerProvider), isA<Registrado>());

      expect(await control.alCerrarSesion(), isTrue);
      expect(
        api.peticiones.last.llamadaCompleta,
        'DELETE /api/v1/dispositivos/disp-1',
      );
      expect(fuente.borrados, 1);
    });
  });
}
