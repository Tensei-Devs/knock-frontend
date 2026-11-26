import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/eliminacion.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lo pendiente antes de eliminar (spec 029).
class PendientesController extends AsyncNotifier<PendientesDeCuenta> {
  @override
  Future<PendientesDeCuenta> build() {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(eliminacionRepositoryProvider).pendientes();
  }

  void reintentar() => ref.invalidateSelf();
}

/// La eliminación pedida en esta sesión: la fecha en que se borra la cuenta, o
/// `null`. Después de cerrar la app, lo que queda es el estado del perfil.
class EliminacionController extends Notifier<DateTime?> {
  /// Motivo elegido en el primer paso; opcional y solo en memoria.
  String? motivo;

  @override
  DateTime? build() {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    motivo = null;
    return null;
  }

  /// Lanza un `Failure` si el servidor no la acepta.
  Future<ResultadoDeEliminacion> programar({String? firebaseIdToken}) async {
    final resultado = await ref
        .read(eliminacionRepositoryProvider)
        .programar(firebaseIdToken: firebaseIdToken, motivo: motivo);
    if (resultado is EliminacionProgramada) {
      state = resultado.eliminarEn;
      ref.invalidate(perfilControllerProvider);
    }
    return resultado;
  }

  /// Con 409 (no hay nada programado) se vuelve a leer el estado del servidor.
  Future<Failure?> cancelar() async {
    try {
      await ref.read(eliminacionRepositoryProvider).cancelar();
    } on ConflictoFailure catch (falla) {
      _olvidar();
      return falla;
    } on Failure catch (falla) {
      return falla;
    }
    _olvidar();
    return null;
  }

  void _olvidar() {
    state = null;
    ref.invalidate(perfilControllerProvider);
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final pendientesControllerProvider =
    AsyncNotifierProvider.autoDispose<PendientesController, PendientesDeCuenta>(
      PendientesController.new,
      retry: (_, _) => null,
    );

final eliminacionControllerProvider =
    NotifierProvider<EliminacionController, DateTime?>(
      EliminacionController.new,
    );

/// Si la cuenta tiene una eliminación en sus 7 días de gracia: la recién
/// pedida o la que dice el estado del perfil.
final eliminacionEnCursoProvider = Provider<bool>(
  (ref) =>
      ref.watch(eliminacionControllerProvider) != null ||
      perfilCargado(ref.watch(perfilControllerProvider))?.estado ==
          Perfil.estadoEliminacionProgramada,
);
