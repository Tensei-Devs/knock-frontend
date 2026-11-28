import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/core/notificaciones/registro_dispositivos_provider.dart';
import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/identificador_dispositivo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Situación del registro de este teléfono para recibir notificaciones.
sealed class EstadoRegistro {
  const EstadoRegistro();
}

/// No hay identificador registrado.
final class SinRegistrar extends EstadoRegistro {
  const SinRegistrar();
}

/// La persona no ha aceptado las notificaciones: no se registra nada.
final class SinPermisoDeNotificaciones extends EstadoRegistro {
  const SinPermisoDeNotificaciones();
}

/// El servicio de notificaciones no entregó identificador (no disponible).
final class SinIdentificador extends EstadoRegistro {
  const SinIdentificador();
}

/// El servidor no aceptó el registro; se reintenta al volver a iniciar sesión.
final class RegistroFallido extends EstadoRegistro {
  const RegistroFallido();
}

/// El servidor tiene apagado el registro (503): las notificaciones no están
/// disponibles por ahora. No se reintenta en bucle.
final class NotificacionesNoDisponibles extends EstadoRegistro {
  const NotificacionesNoDisponibles();
}

/// El identificador está registrado. No se imprime: es una credencial.
final class Registrado extends EstadoRegistro {
  const Registrado(this.identificador, {this.id});

  final String identificador;

  /// Id del dispositivo en el servidor (para `DELETE /dispositivos/{id}`).
  final String? id;

  @override
  String toString() => 'Registrado';
}

/// Registra y desregistra el identificador de notificaciones (spec 012, R-01).
///
/// Habla con `POST/DELETE /dispositivos` (simulado solo sin `KNOCK_API_URL`
/// fuera de `release`). El inicio de sesión llama a [alIniciarSesion] y el
/// cierre, a [alCerrarSesion].
class RegistroDispositivoController extends Notifier<EstadoRegistro> {
  @override
  EstadoRegistro build() => const SinRegistrar();

  /// Registra el identificador si la persona aceptó las notificaciones.
  /// No pide el permiso: eso lo hace la pantalla con su explicación previa.
  Future<void> alIniciarSesion() async {
    final permiso = await ref
        .read(gestorPermisosProvider)
        .estado(PermisoApp.notificaciones);
    if (!ref.mounted) return;
    if (!permiso.concedida) {
      state = const SinPermisoDeNotificaciones();
      return;
    }
    final identificador = await ref
        .read(servicioNotificacionesProvider)
        .obtenerIdentificador();
    if (!ref.mounted) return;
    if (identificador == null) {
      state = const SinIdentificador();
      return;
    }
    try {
      final id = await ref
          .read(registroDispositivosRepositoryProvider)
          .registrar(identificador);
      await _guardarId(id);
      if (!ref.mounted) return;
      state = Registrado(identificador, id: id);
    } on NotificacionesNoDisponiblesException {
      if (!ref.mounted) return;
      state = const NotificacionesNoDisponibles();
    } on Object {
      if (!ref.mounted) return;
      state = const RegistroFallido();
    }
  }

  /// Desregistra el identificador y lo invalida en el teléfono.
  ///
  /// Devuelve `false` si el servidor no confirmó el desregistro. Aun así el
  /// identificador se invalida en el teléfono, así que el servidor no puede
  /// enviar nada a esta cuenta por ese identificador (spec 012 §6), y el id
  /// guardado se borra: el servidor elimina el dispositivo al terminar la
  /// sesión (enmienda 2026-11-27, CA-B01).
  Future<bool> alCerrarSesion() async {
    final servicio = ref.read(servicioNotificacionesProvider);
    final actual = state;
    final almacen = ref.read(almacenSeguroProvider);
    var confirmado = true;
    try {
      final id = (actual is Registrado ? actual.id : null) ?? await _leerId();
      if (id != null) {
        await ref.read(registroDispositivosRepositoryProvider).desregistrar(id);
      }
    } on Object {
      confirmado = false;
    }
    await borrarIdDispositivoEnServidor(almacen);
    try {
      await servicio.borrarIdentificador();
    } on Object {
      confirmado = false;
    }
    if (ref.mounted) state = const SinRegistrar();
    return confirmado;
  }

  Future<void> _guardarId(String id) async {
    try {
      await ref
          .read(almacenSeguroProvider)
          .escribir(claveIdDispositivoEnServidor, id);
    } on Object {
      // Sin registro: si no se guarda, el servidor lo borra al cerrar sesión.
    }
  }

  Future<String?> _leerId() async {
    try {
      return await ref
          .read(almacenSeguroProvider)
          .leer(claveIdDispositivoEnServidor);
    } on Object {
      return null;
    }
  }
}

final registroDispositivoControllerProvider =
    NotifierProvider<RegistroDispositivoController, EstadoRegistro>(
      RegistroDispositivoController.new,
    );
