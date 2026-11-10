import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/sesion/sesion_provider.dart'
    show sesionIniciadaProvider;
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/inicio/presentation/colonia_controller.dart';
import 'package:app/features/oficios/presentation/oficios_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Perfil de la cuenta: cargando, datos o error.
class PerfilController extends AsyncNotifier<Perfil> {
  @override
  Future<Perfil> build() {
    // Vuelve a pedir el perfil cuando se abre o se cierra una sesión (no en
    // cada renovación del token).
    // Vuelve a pedir el perfil cuando se abre o se cierra una sesión (no en
    // cada renovación del token).
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(perfilRepositoryProvider).obtener();
  }

  /// Guarda el nombre (HU-002). Devuelve el error si falla (`null` si salió
  /// bien); en ese caso el estado no cambia y el perfil que se mostraba sigue
  /// igual (spec 026, CA-04).
  Future<Object?> guardarNombre(String nombre) async {
    try {
      state = AsyncData(
        await ref.read(perfilRepositoryProvider).guardarNombre(nombre),
      );
      return null;
    } on Object catch (error) {
      return error;
    }
  }

  /// Cierra la sesión (HU-004): revoca, borra el perfil y reinicia lo que
  /// dependía de la cuenta (spec 001 §6: sin datos de la sesión anterior). La
  /// bandera de sesión pasa a falso y el router lleva a `/entrar` (spec 026).
  Future<void> cerrarSesion() async {
    await ref.read(perfilRepositoryProvider).cerrarSesion();
    ref.read(sesionIniciadaProvider.notifier).cerrar();
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
  (ref) =>
      perfilCargado(ref.watch(perfilControllerProvider))?.completo == false,
);

/// El perfil solo si ya cargó. Riverpod conserva el valor anterior mientras
/// se vuelve a cargar o tras un error; ese valor puede ser de la cuenta que
/// cerró sesión, así que nunca se muestra (spec 026, CA-26).
Perfil? perfilCargado(AsyncValue<Perfil> estado) =>
    estado.isLoading || estado.hasError ? null : estado.value;
