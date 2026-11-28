import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/explorar/domain/explorar.dart';
import 'package:app/features/explorar/explorar_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lo que muestra Explorar: los bloques y, si son la última copia porque no
/// hubo conexión, desde cuándo (CA-45).
final class VistaExplorar {
  const VistaExplorar(this.datos, {this.copiaDel});

  final Explorar datos;

  /// Fecha de la copia mostrada; `null` si los datos acaban de llegar.
  final DateTime? copiaDel;

  bool get esCopia => copiaDel != null;
}

/// Reloj de las copias; las pruebas lo fijan.
final relojExplorarProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Última respuesta buena por filtro. Vive solo en memoria y se vacía al abrir
/// o cerrar sesión, para que nadie vea lo de otra cuenta (spec 036, §5).
final copiasExplorarProvider =
    Provider<Map<FiltroExplorar, (Explorar, DateTime)>>((ref) {
      ref.watch(sesionProvider.select((tokens) => tokens != null));
      return {};
    });

/// Explorar con un filtro. Si no hay conexión y ya se vio ese filtro, entrega
/// la última copia con su fecha; si no, el error (con Reintentar en pantalla).
final explorarProvider = FutureProvider.autoDispose
    .family<VistaExplorar, FiltroExplorar>((ref, filtro) async {
      final copias = ref.watch(copiasExplorarProvider);
      try {
        final datos = await ref
            .watch(explorarRepositoryProvider)
            .cargar(filtro);
        copias[filtro] = (datos, ref.read(relojExplorarProvider)());
        return VistaExplorar(datos);
      } on ServicioNoDisponibleFailure {
        final copia = copias[filtro];
        if (copia == null) rethrow;
        return VistaExplorar(copia.$1, copiaDel: copia.$2);
      }
    }, retry: (_, _) => null);
