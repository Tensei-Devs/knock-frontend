import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/direcciones/direcciones_providers.dart';
import 'package:app/features/direcciones/domain/direccion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Las direcciones de la cuenta (spec 030). No guarda nada en el teléfono.
/// Después de cada escritura se vuelve a pedir la lista: el servidor decide el
/// orden y cuál queda como principal.
class DireccionesController extends AsyncNotifier<List<Direccion>> {
  @override
  Future<List<Direccion>> build() {
    // Al abrir o cerrar una sesión se vuelve a pedir: nada pasa a otra cuenta.
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(direccionesRepositoryProvider).listar();
  }

  void reintentar() => ref.invalidateSelf();

  Future<Failure?> crear(DireccionNueva nueva) =>
      _escribir(() => ref.read(direccionesRepositoryProvider).crear(nueva));

  Future<Failure?> editar(String id, CambiosDireccion cambios) => _escribir(
    () => ref.read(direccionesRepositoryProvider).editar(id, cambios),
  );

  Future<Failure?> eliminar(String id) =>
      _escribir(() => ref.read(direccionesRepositoryProvider).eliminar(id));

  Future<Failure?> _escribir(Future<Object?> Function() escritura) async {
    try {
      await escritura();
    } on NoEncontradoFailure catch (falla) {
      // Ya no existe: la lista se pone al día y se explica el error.
      ref.invalidateSelf();
      return falla;
    } on Failure catch (falla) {
      return falla;
    }
    ref.invalidateSelf();
    return null;
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final direccionesControllerProvider =
    AsyncNotifierProvider<DireccionesController, List<Direccion>>(
      DireccionesController.new,
      retry: (_, _) => null,
    );

/// El `id` que la persona eligió al pedir una cotización; `null` si no ha
/// elegido ninguno. Se olvida al cambiar la sesión.
class DireccionElegida extends Notifier<String?> {
  @override
  String? build() {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return null;
  }

  void elegir(String id) => state = id;
}

final direccionElegidaProvider = NotifierProvider<DireccionElegida, String?>(
  DireccionElegida.new,
);

/// La dirección que vale al pedir: la elegida; si no, la principal; si no, la
/// primera. `null` mientras no hay lista.
final direccionParaPedirProvider = Provider<Direccion?>((ref) {
  final lista = ref.watch(direccionesControllerProvider).value ?? const [];
  if (lista.isEmpty) return null;
  final elegida = ref.watch(direccionElegidaProvider);
  return lista.where((d) => d.id == elegida).firstOrNull ??
      lista.where((d) => d.principal).firstOrNull ??
      lista.first;
});
