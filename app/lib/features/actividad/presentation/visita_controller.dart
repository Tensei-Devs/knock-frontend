import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lo que muestra la pantalla de la visita: la visita del servidor o, sin
/// conexión, la copia guardada (spec 016, CA-02).
@immutable
sealed class VistaDeVisita {
  const VistaDeVisita();
}

final class VisitaEnLinea extends VistaDeVisita {
  const VisitaEnLinea(this.visita);

  final Visita visita;
}

final class VisitaSinConexion extends VistaDeVisita {
  const VisitaSinConexion(this.guardada);

  final VisitaGuardada guardada;
}

/// Pide la visita [id], mantiene su copia cifrada y la borra cuando la visita
/// se cierra (R-03, R-07, CA-16). Sin caché de respuestas (R-04).
final visitaProvider = FutureProvider.autoDispose.family<VistaDeVisita, String>(
  (ref, id) async {
    final local = ref.read(visitaLocalRepositoryProvider);
    try {
      final visita = await ref.read(visitaRepositoryProvider).obtenerVisita(id);
      if (visita.estado.cerrada) {
        await local.borrar(id);
      } else {
        // Con `motivoCodigo` la copia se guarda sin código (R-07).
        await local.guardar(
          VisitaGuardada.de(visita, ref.read(relojSolicitudProvider)()),
        );
      }
      return VisitaEnLinea(visita);
    } on NoEncontradoFailure {
      await local.borrar(id);
      rethrow;
    } on ServicioNoDisponibleFailure {
      final guardada = await local.leer(id);
      if (guardada == null) rethrow;
      return VisitaSinConexion(guardada);
    }
  },
);
