// Spec 012 (KNOCK-60): adaptador de Firebase Cloud Messaging con una fuente
// falsa. Sin Firebase ni red; identificadores ficticios.
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/features/notificaciones/data/servicio_notificaciones_fcm.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    show AuthorizationStatus;
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/fakes_notificaciones.dart';
import '../../../soporte/fuente_fcm_falsa.dart';

void main() {
  group('estadoDePermisoFcm', () {
    test('CA_012_01 autorizado o provisional cuenta como concedido', () {
      expect(
        estadoDePermisoFcm(AuthorizationStatus.authorized),
        EstadoPermiso.concedido,
      );
      expect(
        estadoDePermisoFcm(AuthorizationStatus.provisional),
        EstadoPermiso.concedido,
      );
    });

    test('R-07 negado solo se cambia en Ajustes; sin decidir no se pidió', () {
      expect(
        estadoDePermisoFcm(AuthorizationStatus.denied),
        EstadoPermiso.denegadoParaSiempre,
      );
      expect(
        estadoDePermisoFcm(AuthorizationStatus.deniedPermanently),
        EstadoPermiso.denegadoParaSiempre,
      );
      expect(
        estadoDePermisoFcm(AuthorizationStatus.notDetermined),
        EstadoPermiso.sinPedir,
      );
    });
  });

  group('ServicioNotificacionesFcm', () {
    test('CA_012_01 entrega el identificador de FCM', () async {
      final fuente = FuenteFcmFalsa();
      expect(
        await ServicioNotificacionesFcm(fuente).obtenerIdentificador(),
        'fcm-prueba-1',
      );
    });

    test('sin identificador o vacío devuelve null', () async {
      final fuente = FuenteFcmFalsa(identificador: '');
      final servicio = ServicioNotificacionesFcm(fuente);
      expect(await servicio.obtenerIdentificador(), isNull);
      fuente.identificador = null;
      expect(await servicio.obtenerIdentificador(), isNull);
    });

    test('un fallo de FCM no rompe el inicio de sesión: null', () async {
      final fuente = FuenteFcmFalsa()..falloAlPedirToken = Exception('fcm');
      expect(
        await ServicioNotificacionesFcm(fuente).obtenerIdentificador(),
        isNull,
      );
    });

    test('CA_012_02 borrar invalida el identificador en FCM', () async {
      final fuente = FuenteFcmFalsa();
      await ServicioNotificacionesFcm(fuente).borrarIdentificador();
      expect(fuente.borrados, 1);
      expect(fuente.identificador, isNull);
    });

    test('CA_012_03 pasa los toques y la carga inicial tal cual', () async {
      final fuente = FuenteFcmFalsa()
        ..cargaInicial = {'tipo': 'visitas', 'destino': 'actividad'};
      final servicio = ServicioNotificacionesFcm(fuente);
      expect(await servicio.toqueInicial(), {
        'tipo': 'visitas',
        'destino': 'actividad',
      });
      final primero = servicio.toques.first;
      fuente.tocar({'tipo': 'mensajes'});
      expect(await primero, {'tipo': 'mensajes'});
    });
  });

  group('GestorPermisosFcm', () {
    test('R-06 el permiso de notificaciones lo lee y lo pide FCM', () async {
      final fuente = FuenteFcmFalsa();
      final gestor = GestorPermisosFcm(fuente);
      expect(
        await gestor.estado(PermisoApp.notificaciones),
        EstadoPermiso.sinPedir,
      );
      expect(
        await gestor.pedir(PermisoApp.notificaciones),
        EstadoPermiso.concedido,
      );
      expect(fuente.permisosPedidos, 1);
      expect(
        await gestor.estado(PermisoApp.notificaciones),
        EstadoPermiso.concedido,
      );
    });

    test('la ubicación sigue con el otro gestor', () async {
      final fuente = FuenteFcmFalsa();
      final gestor = GestorPermisosFcm(
        fuente,
        otros: GestorPermisosFalso(estadoInicial: EstadoPermiso.concedido),
      );
      expect(
        await gestor.estado(PermisoApp.ubicacion),
        EstadoPermiso.concedido,
      );
      expect(fuente.permisosPedidos, 0);
    });

    test('R-07 abre los ajustes de la app', () async {
      final fuente = FuenteFcmFalsa();
      await GestorPermisosFcm(fuente).abrirAjustes();
      expect(fuente.ajustesAbiertos, 1);
    });
  });
}
