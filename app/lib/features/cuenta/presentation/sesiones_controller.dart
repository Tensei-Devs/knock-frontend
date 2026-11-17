import 'package:app/core/errores/failure.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/sesion_dispositivo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sesiones abiertas de la cuenta (`GET /me/sesiones`, spec 026 R-09 y spec 029):
/// cargando, datos (posiblemente solo la de este teléfono) o error con
/// Reintentar. No guarda nada en el teléfono.
class SesionesController extends AsyncNotifier<List<SesionDispositivo>> {
  @override
  Future<List<SesionDispositivo>> build() =>
      ref.watch(sesionesRepositoryProvider).listar();

  /// Vuelve a pedir las sesiones (botón Reintentar).
  void reintentar() => ref.invalidateSelf();

  /// Cierra otra sesión (`DELETE /me/sesiones/{id}`). Devuelve `null` si salió
  /// bien (la quita de la lista) o el [Failure]; la sesión actual (409) no se
  /// puede cerrar desde aquí.
  Future<Failure?> cerrar(String id) async {
    try {
      await ref.read(sesionesRepositoryProvider).cerrar(id);
    } on Failure catch (e) {
      return e;
    }
    final actuales = state.value;
    if (actuales != null) {
      state = AsyncData([
        for (final s in actuales)
          if (s.id != id) s,
      ]);
    }
    return null;
  }
}

/// Se descarta al salir de la pantalla para pedir las sesiones frescas al volver.
/// Sin reintento automático: Riverpod reintenta solo los proveedores que fallan
/// y eso escondería el error; la persona decide con Reintentar.
final sesionesControllerProvider =
    AsyncNotifierProvider.autoDispose<
      SesionesController,
      List<SesionDispositivo>
    >(SesionesController.new, retry: (_, _) => null);
