import 'package:app/core/errores/failure.dart';
import 'package:app/features/mi/domain/casa_y_auto.dart';
import 'package:app/features/mi/mi_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lista de «Mi casa y mi auto» (CAS-01) con alta, edición y baja (CAS-02 a
/// CAS-04). Cada escritura devuelve `null` si salió bien o el [Failure] para
/// que la pantalla muestre su mensaje y conserve lo escrito (CA-05, CA-08 y
/// CA-11).
class CasaYAutoController extends AsyncNotifier<List<ElementoCasa>> {
  @override
  Future<List<ElementoCasa>> build() =>
      ref.watch(casaYAutoRepositoryProvider).listar();

  /// Vuelve a pedir la lista (botón Reintentar, CA-16).
  void reintentar() => ref.invalidateSelf();

  Future<Failure?> agregar({
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  }) => _escribir(() async {
    final nuevo = await ref
        .read(casaYAutoRepositoryProvider)
        .agregar(tipo: tipo, nombre: nombre, anio: anio);
    return [nuevo, ...?state.value];
  });

  Future<Failure?> editar(
    String id, {
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  }) => _escribir(() async {
    final editado = await ref
        .read(casaYAutoRepositoryProvider)
        .editar(id, tipo: tipo, nombre: nombre, anio: anio);
    return [
      for (final e in state.value ?? const <ElementoCasa>[])
        e.id == id ? editado : e,
    ];
  });

  Future<Failure?> quitar(String id) => _escribir(() async {
    await ref.read(casaYAutoRepositoryProvider).quitar(id);
    return [
      for (final e in state.value ?? const <ElementoCasa>[])
        if (e.id != id) e,
    ];
  });

  Future<Failure?> _escribir(
    Future<List<ElementoCasa>> Function() escritura,
  ) async {
    try {
      state = AsyncData(await escritura());
      return null;
    } on Failure catch (e) {
      // Un elemento que ya no existe (404) se quita de la lista mostrada.
      if (e is NoEncontradoFailure) ref.invalidateSelf();
      return e;
    }
  }
}

/// Se descarta al salir de la pantalla. Sin reintento automático: la persona
/// decide con Reintentar.
final casaYAutoControllerProvider =
    AsyncNotifierProvider.autoDispose<CasaYAutoController, List<ElementoCasa>>(
      CasaYAutoController.new,
      retry: (_, _) => null,
    );

/// Historial de un elemento (CAS-05), página por página con el cursor y sin
/// repetir trabajos (CA-15).
class HistorialElemento {
  HistorialElemento(this._repositorio, this.id);

  final CasaYAutoRepository _repositorio;
  final String id;
  final List<TrabajoDelElemento> trabajos = [];
  String? _cursor;
  var _primera = true;

  /// Hay más páginas por pedir.
  bool get hayMas => _primera || _cursor != null;

  /// Pide la siguiente página y la agrega; lanza el [Failure] si falla.
  Future<void> cargarMas() async {
    if (!hayMas) return;
    final pagina = await _repositorio.historial(id, cursor: _cursor);
    trabajos.addAll(pagina.trabajos);
    _cursor = pagina.siguiente;
    _primera = false;
  }
}
