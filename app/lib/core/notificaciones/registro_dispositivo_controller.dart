import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
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

/// El identificador está registrado. No se imprime: es una credencial.
final class Registrado extends EstadoRegistro {
  const Registrado(this.identificador);

  final String identificador;

  @override
  String toString() => 'Registrado';
}

/// Registra y desregistra el identificador de notificaciones (spec 012, R-01).
///
/// El servidor del registro es [RegistroDispositivosSimulado] mientras el
/// backend no publique el endpoint. Quien maneje la sesión llama a
/// [alIniciarSesion] y a [alCerrarSesion].
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
      await ref
          .read(registroDispositivosRepositoryProvider)
          .registrar(identificador);
      if (!ref.mounted) return;
      state = Registrado(identificador);
    } on Object {
      if (!ref.mounted) return;
      state = const RegistroFallido();
    }
  }

  /// Desregistra el identificador y lo invalida en el teléfono.
  ///
  /// Devuelve `false` si el servidor no confirmó el desregistro. Aun así el
  /// identificador se invalida en el teléfono, así que el servidor no puede
  /// enviar nada a esta cuenta por ese identificador (spec 012 §6).
  Future<bool> alCerrarSesion() async {
    final servicio = ref.read(servicioNotificacionesProvider);
    final actual = state;
    var confirmado = true;
    try {
      final identificador = actual is Registrado
          ? actual.identificador
          : await servicio.obtenerIdentificador();
      if (identificador != null) {
        await ref
            .read(registroDispositivosRepositoryProvider)
            .desregistrar(identificador);
      }
    } on Object {
      confirmado = false;
    }
    try {
      await servicio.borrarIdentificador();
    } on Object {
      confirmado = false;
    }
    if (ref.mounted) state = const SinRegistrar();
    return confirmado;
  }
}

final registroDispositivoControllerProvider =
    NotifierProvider<RegistroDispositivoController, EstadoRegistro>(
      RegistroDispositivoController.new,
    );
