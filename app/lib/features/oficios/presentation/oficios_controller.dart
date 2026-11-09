import 'dart:async';

import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/resultado_oficios.dart';
import 'package:app/features/oficios/oficios_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Si los oficios mostrados vienen de lo guardado por falta de conexión
/// (spec 010). Solo lo escribe [OficiosController], nunca al construirse.
class OficiosSinConexion extends Notifier<bool> {
  @override
  bool build() => false;

  void fijar(bool valor) => state = valor;
}

final oficiosSinConexionProvider = NotifierProvider<OficiosSinConexion, bool>(
  OficiosSinConexion.new,
);

/// Estado de la pantalla de oficios: cargando, datos (lista, posiblemente
/// vacía) o error. Si el repositorio guarda caché, muestra primero lo guardado
/// y se actualiza cuando llegan los datos nuevos (spec 010, R-03).
class OficiosController extends AsyncNotifier<List<Oficio>> {
  @override
  Future<List<Oficio>> build() {
    final repositorio = ref.watch(oficiosRepositoryProvider);
    if (repositorio is! OficiosRepositoryConCache) return repositorio.listar();

    final primero = Completer<List<Oficio>>();
    final suscripcion = repositorio.observar().listen(
      (resultado) {
        ref
            .read(oficiosSinConexionProvider.notifier)
            .fijar(resultado.sinConexion);
        if (primero.isCompleted) {
          state = AsyncData(resultado.oficios);
        } else {
          primero.complete(resultado.oficios);
        }
      },
      onError: (Object error, StackTrace pila) {
        // Con datos ya mostrados se conservan; sin ellos, es el error.
        if (!primero.isCompleted) primero.completeError(error, pila);
      },
    );
    ref.onDispose(suscripcion.cancel);
    return primero.future;
  }

  /// Vuelve a pedir los oficios (botón Reintentar): el estado pasa por
  /// «cargando» y termina en datos o en error.
  void reintentar() => ref.invalidateSelf();
}

/// Sin reintento automático: Riverpod reintenta solo los proveedores que
/// fallan y eso escondería el error; aquí la persona decide con Reintentar.
final oficiosControllerProvider =
    AsyncNotifierProvider<OficiosController, List<Oficio>>(
      OficiosController.new,
      retry: (_, _) => null,
    );
