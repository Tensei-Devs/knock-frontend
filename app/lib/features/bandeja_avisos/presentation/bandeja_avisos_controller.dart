import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/bandeja_avisos/bandeja_avisos_providers.dart';
import 'package:app/features/bandeja_avisos/domain/aviso_en_bandeja.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La bandeja de la cuenta (spec 034): páginas por cursor y marcar leídos. No
/// guarda nada en el teléfono.
class BandejaAvisosController extends AsyncNotifier<PaginaAvisos>
    with PaginasPorCursor<PaginaAvisos> {
  @override
  Future<PaginaAvisos> build() {
    // Al abrir o cerrar una sesión se vuelve a pedir: nada pasa a otra cuenta.
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(bandejaAvisosRepositoryProvider).listar();
  }

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(PaginaAvisos pagina) => pagina.siguiente;

  @override
  Future<PaginaAvisos> pedirPagina(String cursor) =>
      ref.read(bandejaAvisosRepositoryProvider).listar(cursor: cursor);

  /// Sin repetir elementos (CA-03).
  @override
  PaginaAvisos unirPaginas(PaginaAvisos actual, PaginaAvisos siguiente) =>
      PaginaAvisos(
        unirSinRepetir(actual.items, siguiente.items, (e) => e.id),
        siguiente.siguiente,
      );

  /// Marca uno como leído. Si ya no existe (404), sale de la lista y se
  /// devuelve el error para explicarlo (CA-08).
  Future<Failure?> marcarLeido(String id) async {
    try {
      await ref.read(bandejaAvisosRepositoryProvider).marcarLeido(id);
    } on NoEncontradoFailure catch (falla) {
      _cambiar(
        (items) => [
          for (final a in items)
            if (a.id != id) a,
        ],
      );
      return falla;
    } on Failure catch (falla) {
      return falla;
    }
    _cambiar(
      (items) => [for (final a in items) a.id == id ? a.comoLeido() : a],
    );
    ref.invalidate(avisosSinLeerControllerProvider);
    return null;
  }

  Future<Failure?> marcarTodos() async {
    try {
      await ref.read(bandejaAvisosRepositoryProvider).marcarTodos();
    } on Failure catch (falla) {
      return falla;
    }
    _cambiar((items) => [for (final a in items) a.comoLeido()]);
    ref.invalidate(avisosSinLeerControllerProvider);
    return null;
  }

  void _cambiar(
    List<AvisoEnBandeja> Function(List<AvisoEnBandeja>) transformar,
  ) {
    final actual = state.value;
    if (actual == null) return;
    state = AsyncData(
      PaginaAvisos(transformar(actual.items), actual.siguiente),
    );
  }
}

/// El contador de la campana. Sin sesión no pide nada.
class AvisosSinLeerController extends AsyncNotifier<AvisosSinLeer> {
  @override
  Future<AvisosSinLeer> build() async {
    final conSesion = ref.watch(sesionProvider.select((t) => t != null));
    if (!conSesion) return const AvisosSinLeer(0);
    return ref.watch(bandejaAvisosRepositoryProvider).sinLeer();
  }
}

final avisosSinLeerControllerProvider =
    AsyncNotifierProvider.autoDispose<AvisosSinLeerController, AvisosSinLeer>(
      AvisosSinLeerController.new,
      retry: (_, _) => null,
    );

/// «Qué avisos recibir»: lo que dice el servidor.
class PreferenciasDeAvisosController
    extends AsyncNotifier<List<PreferenciaDeAviso>> {
  @override
  Future<List<PreferenciaDeAviso>> build() {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(bandejaAvisosRepositoryProvider).preferencias();
  }

  void reintentar() => ref.invalidateSelf();

  /// El interruptor solo cambia cuando el servidor lo confirma.
  Future<Failure?> cambiar(String tipo, {required bool activo}) async {
    try {
      state = AsyncData(
        await ref
            .read(bandejaAvisosRepositoryProvider)
            .cambiar(tipo, activo: activo),
      );
      return null;
    } on Failure catch (falla) {
      return falla;
    }
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final bandejaAvisosControllerProvider =
    AsyncNotifierProvider<BandejaAvisosController, PaginaAvisos>(
      BandejaAvisosController.new,
      retry: (_, _) => null,
    );

final preferenciasDeAvisosControllerProvider =
    AsyncNotifierProvider<
      PreferenciasDeAvisosController,
      List<PreferenciaDeAviso>
    >(PreferenciasDeAvisosController.new, retry: (_, _) => null);
