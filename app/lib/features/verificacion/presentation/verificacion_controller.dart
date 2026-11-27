import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/verificacion/domain/verificacion.dart';
import 'package:app/features/verificacion/verificacion_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mi verificación. Sin sesión no pide nada. Se vuelve a pedir cada vez que se
/// abre la pantalla.
class VerificacionController extends AsyncNotifier<Verificacion> {
  @override
  Future<Verificacion> build() async {
    final conSesion = ref.watch(sesionProvider.select((t) => t != null));
    if (!conSesion) {
      return const Verificacion(estado: EstadoDeVerificacion.sinVerificar);
    }
    return ref.watch(verificacionRepositoryProvider).miEstado();
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final verificacionControllerProvider =
    AsyncNotifierProvider.autoDispose<VerificacionController, Verificacion>(
      VerificacionController.new,
      retry: (_, _) => null,
    );
