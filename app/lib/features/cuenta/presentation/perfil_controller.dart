import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/inicio/presentation/colonia_controller.dart';
import 'package:app/features/oficios/presentation/oficios_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Perfil de la cuenta: cargando, datos o error.
class PerfilController extends AsyncNotifier<Perfil> {
  @override
  Future<Perfil> build() => ref.watch(perfilRepositoryProvider).obtener();

  /// Guarda el nombre (HU-002). Si falla, el error queda en el estado.
  Future<void> guardarNombre(String nombre) async {
    state = await AsyncValue.guard(
      () => ref.read(perfilRepositoryProvider).guardarNombre(nombre),
    );
  }

  /// Cierra la sesión (HU-004): revoca, borra el perfil y reinicia lo que
  /// dependía de la cuenta (spec 001 §6: sin datos de la sesión anterior).
  Future<void> cerrarSesion() async {
    await ref.read(perfilRepositoryProvider).cerrarSesion();
    ref.read(esTecnicoProvider.notifier).cambiar(esTecnico: false);
    ref.invalidate(coloniaControllerProvider);
    ref.invalidate(oficiosControllerProvider);
    ref.invalidateSelf();
  }

  /// Vuelve a pedir el perfil (Reintentar).
  void reintentar() => ref.invalidateSelf();
}

/// Sin reintento automático: la persona decide con Reintentar.
final perfilControllerProvider =
    AsyncNotifierProvider<PerfilController, Perfil>(
      PerfilController.new,
      retry: (_, _) => null,
    );

/// Cuenta nueva: el perfil ya cargó y aún no tiene nombre. Mientras carga o si
/// falla es falso, para no atrapar a la persona en «completar perfil».
final perfilPendienteProvider = Provider<bool>(
  (ref) => ref.watch(perfilControllerProvider).value?.completo == false,
);
