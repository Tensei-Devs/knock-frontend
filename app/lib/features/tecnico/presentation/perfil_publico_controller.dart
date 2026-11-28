import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/tecnico/domain/perfil_publico.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Un dato y, si es la última copia porque no hubo conexión, desde cuándo
/// (spec 036, CA-20, CA-24 y CA-29; spec 037, CA-04).
final class ConFecha<T> {
  const ConFecha(this.datos, {this.copiaDel});

  final T datos;
  final DateTime? copiaDel;
}

/// Reloj de las copias; las pruebas lo fijan.
final relojPerfilProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Última respuesta buena de cada consulta. Solo en memoria; se vacía al abrir
/// o cerrar sesión.
final copiasPerfilProvider = Provider<Map<String, (Object, DateTime)>>((ref) {
  ref.watch(sesionProvider.select((tokens) => tokens != null));
  return {};
});

Future<ConFecha<T>> _conCopia<T extends Object>(
  Ref ref,
  String clave,
  Future<T> Function(PerfilPublicoRepository) pedir,
) async {
  final copias = ref.watch(copiasPerfilProvider);
  try {
    final datos = await pedir(ref.watch(perfilPublicoRepositoryProvider));
    copias[clave] = (datos, ref.read(relojPerfilProvider)());
    return ConFecha(datos);
  } on ServicioNoDisponibleFailure {
    final copia = copias[clave];
    if (copia == null) rethrow;
    return ConFecha(copia.$1 as T, copiaDel: copia.$2);
  }
}

/// TEC-05. Sin reintento automático, como los demás.
final perfilPublicoProvider = FutureProvider.autoDispose
    .family<ConFecha<PerfilPublico>, String>(
      (ref, id) => _conCopia(ref, 'perfil/$id', (r) => r.perfil(id)),
      retry: (_, _) => null,
    );

/// SRV-01.
final serviciosPublicosProvider = FutureProvider.autoDispose
    .family<ConFecha<List<ServicioPublico>>, String>(
      (ref, id) => _conCopia(ref, 'servicios/$id', (r) => r.servicios(id)),
      retry: (_, _) => null,
    );

/// TEC-06, con el técnico y el `coloniaId` de la persona.
final llegaAMiColoniaProvider = FutureProvider.autoDispose
    .family<ConFecha<bool>, (String, String)>(
      (ref, de) => _conCopia(
        ref,
        'llega/${de.$1}/${de.$2}',
        (r) => r.llegaAColonia(de.$1, de.$2),
      ),
      retry: (_, _) => null,
    );

/// TEC-07, por cursor.
class FotosDeTrabajosController extends AsyncNotifier<ConFecha<PaginaFotos>>
    with PaginasPorCursor<ConFecha<PaginaFotos>> {
  FotosDeTrabajosController(this.id);

  final String id;

  @override
  Future<ConFecha<PaginaFotos>> build() =>
      _conCopia(ref, 'fotos/$id', (r) => r.fotos(id));

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(ConFecha<PaginaFotos> pagina) =>
      pagina.copiaDel == null ? pagina.datos.siguiente : null;

  @override
  Future<ConFecha<PaginaFotos>> pedirPagina(String cursor) async => ConFecha(
    await ref.read(perfilPublicoRepositoryProvider).fotos(id, cursor: cursor),
  );

  /// Sin repetir fotos (CA-28).
  @override
  ConFecha<PaginaFotos> unirPaginas(
    ConFecha<PaginaFotos> actual,
    ConFecha<PaginaFotos> siguiente,
  ) => ConFecha(
    PaginaFotos(
      unirSinRepetir(actual.datos.fotos, siguiente.datos.fotos, (f) => f.id),
      siguiente.datos.siguiente,
    ),
  );
}

final fotosDeTrabajosProvider = AsyncNotifierProvider.autoDispose
    .family<FotosDeTrabajosController, ConFecha<PaginaFotos>, String>(
      FotosDeTrabajosController.new,
      retry: (_, _) => null,
    );
