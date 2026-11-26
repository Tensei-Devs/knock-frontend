import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/opiniones/domain/opinion.dart';
import 'package:app/features/opiniones/opiniones_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lo que se muestra de un técnico y, si es la última copia porque no hubo
/// conexión, desde cuándo (CA-05).
final class VistaOpiniones {
  const VistaOpiniones(this.pagina, {this.copiaDel});

  final PaginaOpiniones pagina;

  /// Fecha de la copia mostrada; `null` si los datos acaban de llegar.
  final DateTime? copiaDel;
}

/// Reloj de las copias; las pruebas lo fijan.
final relojOpinionesProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Última primera página buena por técnico. Vive solo en memoria y se vacía al
/// abrir o cerrar sesión (spec 041, §5).
final copiasOpinionesProvider =
    Provider<Map<String, (PaginaOpiniones, DateTime)>>((ref) {
      ref.watch(sesionProvider.select((tokens) => tokens != null));
      return {};
    });

/// Las opiniones de un técnico, con «Ver más» por cursor.
class OpinionesController extends AsyncNotifier<VistaOpiniones>
    with PaginasPorCursor<VistaOpiniones> {
  OpinionesController(this.tecnicoId);

  final String tecnicoId;

  @override
  Future<VistaOpiniones> build() async {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    final copias = ref.watch(copiasOpinionesProvider);
    try {
      final pagina = await ref
          .watch(opinionesRepositoryProvider)
          .listar(tecnicoId);
      copias[tecnicoId] = (pagina, ref.read(relojOpinionesProvider)());
      return VistaOpiniones(pagina);
    } on ServicioNoDisponibleFailure {
      final copia = copias[tecnicoId];
      if (copia == null) rethrow;
      return VistaOpiniones(copia.$1, copiaDel: copia.$2);
    }
  }

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(VistaOpiniones pagina) => pagina.pagina.siguiente;

  @override
  Future<VistaOpiniones> pedirPagina(String cursor) async => VistaOpiniones(
    await ref
        .read(opinionesRepositoryProvider)
        .listar(tecnicoId, cursor: cursor),
  );

  /// Sin repetir elementos (CA-04). La fecha de una copia se conserva.
  @override
  VistaOpiniones unirPaginas(VistaOpiniones actual, VistaOpiniones siguiente) =>
      VistaOpiniones(
        PaginaOpiniones(
          unirSinRepetir(
            actual.pagina.items,
            siguiente.pagina.items,
            (o) => o.id,
          ),
          siguiente.pagina.resumen,
          siguiente.pagina.siguiente,
        ),
        copiaDel: actual.copiaDel,
      );
}

/// Sin reintento automático: la persona decide con Reintentar.
final opinionesControllerProvider = AsyncNotifierProvider.autoDispose
    .family<OpinionesController, VistaOpiniones, String>(
      OpinionesController.new,
      retry: (_, _) => null,
    );
