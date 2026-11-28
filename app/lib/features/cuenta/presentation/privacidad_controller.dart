import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/privacidad.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Los consentimientos que dice el servidor (spec 029).
class ConsentimientosController extends AsyncNotifier<List<Consentimiento>> {
  @override
  Future<List<Consentimiento>> build() {
    // Al abrir o cerrar una sesión se vuelve a pedir: nada pasa a otra cuenta.
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(privacidadRepositoryProvider).consentimientos();
  }

  void reintentar() => ref.invalidateSelf();

  /// El interruptor solo cambia cuando el servidor lo confirma.
  Future<Failure?> cambiar(String tipo, {required bool vigente}) async {
    final Consentimiento nuevo;
    try {
      nuevo = await ref
          .read(privacidadRepositoryProvider)
          .cambiarConsentimiento(tipo, vigente: vigente);
    } on Failure catch (falla) {
      return falla;
    }
    if (!ref.mounted) return null;
    final actuales = state.value;
    if (actuales != null) {
      state = AsyncData([
        for (final c in actuales) c.tipo == nuevo.tipo ? nuevo : c,
      ]);
    }
    return null;
  }
}

/// La última descarga de datos; `null` si nunca se pidió.
class ExportacionController extends AsyncNotifier<Exportacion?> {
  @override
  Future<Exportacion?> build() {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(privacidadRepositoryProvider).ultimaExportacion();
  }

  /// También sirve de «Actualizar» mientras se prepara el archivo.
  void reintentar() => ref.invalidateSelf();

  /// Si ya hay una en curso (409) se vuelve a leer el estado y se devuelve el
  /// error para explicarlo.
  Future<Failure?> pedir() async {
    try {
      await ref.read(privacidadRepositoryProvider).pedirExportacion();
    } on ConflictoFailure catch (falla) {
      if (ref.mounted) ref.invalidateSelf();
      return falla;
    } on Failure catch (falla) {
      return falla;
    }
    if (ref.mounted) {
      state = const AsyncData(Exportacion(EstadoExportacion.enPreparacion));
    }
    return null;
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final consentimientosControllerProvider =
    AsyncNotifierProvider.autoDispose<
      ConsentimientosController,
      List<Consentimiento>
    >(ConsentimientosController.new, retry: (_, _) => null);

/// Se descarta al salir: al volver se pide un enlace nuevo, nunca se guarda.
final exportacionControllerProvider =
    AsyncNotifierProvider.autoDispose<ExportacionController, Exportacion?>(
      ExportacionController.new,
      retry: (_, _) => null,
    );
