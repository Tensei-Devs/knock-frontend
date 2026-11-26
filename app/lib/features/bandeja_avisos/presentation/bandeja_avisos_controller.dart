import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/bandeja_avisos/bandeja_avisos_providers.dart';
import 'package:app/features/bandeja_avisos/domain/aviso_en_bandeja.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La bandeja de la cuenta (spec 034): páginas por cursor y marcar leídos. No
/// guarda nada en el teléfono.
class BandejaAvisosController extends AsyncNotifier<PaginaAvisos> {
  bool _pidiendoMas = false;

  @override
  Future<PaginaAvisos> build() {
    // Al abrir o cerrar una sesión se vuelve a pedir: nada pasa a otra cuenta.
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(bandejaAvisosRepositoryProvider).listar();
  }

  void reintentar() => ref.invalidateSelf();

  /// La página siguiente, sin repetir avisos (CA-03). Devuelve el error si
  /// falla; lo que ya se mostraba sigue igual.
  Future<Failure?> cargarMas() async {
    final actual = state.value;
    final cursor = actual?.siguiente;
    if (actual == null || cursor == null || _pidiendoMas) return null;
    _pidiendoMas = true;
    try {
      final pagina = await ref
          .read(bandejaAvisosRepositoryProvider)
          .listar(cursor: cursor);
      final vistos = {for (final a in actual.items) a.id};
      state = AsyncData(
        PaginaAvisos([
          ...actual.items,
          for (final a in pagina.items)
            if (!vistos.contains(a.id)) a,
        ], pagina.siguiente),
      );
      return null;
    } on Failure catch (falla) {
      return falla;
    } finally {
      _pidiendoMas = false;
    }
  }

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
    return null;
  }

  Future<Failure?> marcarTodos() async {
    try {
      await ref.read(bandejaAvisosRepositoryProvider).marcarTodos();
    } on Failure catch (falla) {
      return falla;
    }
    _cambiar((items) => [for (final a in items) a.comoLeido()]);
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
