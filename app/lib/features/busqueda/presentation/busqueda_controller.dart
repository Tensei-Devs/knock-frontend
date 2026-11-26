import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/busqueda/busqueda_providers.dart';
import 'package:app/features/busqueda/domain/busqueda.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pausa desde la última tecla antes de pedir (spec 021, R-02).
const pausaAlEscribir = Duration(milliseconds: 400);

/// La consulta abierta. Vive solo en memoria (R-05).
final class ConsultaBusqueda {
  const ConsultaBusqueda({
    this.texto,
    this.oficio,
    this.soloVerificados = false,
  });

  /// Texto ya normalizado; `null` mientras no haya uno válido.
  final String? texto;
  final String? oficio;
  final bool soloVerificados;
}

/// Lo que la persona pide: el texto (con pausa mientras escribe) y los
/// filtros. Se olvida al salir de la pantalla y al cambiar la sesión.
class ConsultaBusquedaNotifier extends Notifier<ConsultaBusqueda> {
  Timer? _pausa;

  @override
  ConsultaBusqueda build() {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    ref.onDispose(() => _pausa?.cancel());
    return const ConsultaBusqueda();
  }

  /// Mientras escribe: espera la pausa; cambiar el texto quita el filtro de
  /// oficio.
  void escribir(String texto) {
    _pausa?.cancel();
    _pausa = Timer(pausaAlEscribir, () => buscarYa(texto));
  }

  /// Con la tecla de buscar o una sugerencia: sin esperar.
  void buscarYa(String texto) {
    _pausa?.cancel();
    final limpio = normalizarConsulta(texto);
    if (limpio == state.texto) return;
    state = ConsultaBusqueda(
      texto: limpio,
      soloVerificados: state.soloVerificados,
    );
  }

  /// Los filtros viajan al servidor (R-03).
  void filtrarOficio(String? oficio) => state = ConsultaBusqueda(
    texto: state.texto,
    oficio: oficio,
    soloVerificados: state.soloVerificados,
  );

  void soloVerificados({required bool activo}) => state = ConsultaBusqueda(
    texto: state.texto,
    oficio: state.oficio,
    soloVerificados: activo,
  );
}

final consultaBusquedaProvider =
    NotifierProvider.autoDispose<ConsultaBusquedaNotifier, ConsultaBusqueda>(
      ConsultaBusquedaNotifier.new,
    );

/// Los resultados de la consulta abierta en la colonia [coloniaId]; `null`
/// mientras no haya texto. Una consulta nueva descarta la respuesta de la
/// anterior (CA-07).
class BusquedaController extends AsyncNotifier<PaginaBusqueda?>
    with PaginasPorCursor<PaginaBusqueda?> {
  BusquedaController(this.coloniaId);

  final String coloniaId;

  @override
  Future<PaginaBusqueda?> build() async {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    final consulta = ref.watch(consultaBusquedaProvider);
    if (consulta.texto == null) return null;
    return _pedir(consulta);
  }

  Future<PaginaBusqueda> _pedir(ConsultaBusqueda c, {String? cursor}) => ref
      .read(busquedaRepositoryProvider)
      .buscar(
        consulta: c.texto!,
        coloniaId: coloniaId,
        oficio: c.oficio,
        soloVerificados: c.soloVerificados,
        cursor: cursor,
      );

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(PaginaBusqueda? pagina) => pagina?.siguiente;

  @override
  Future<PaginaBusqueda?> pedirPagina(String cursor) async {
    try {
      return await _pedir(ref.read(consultaBusquedaProvider), cursor: cursor);
    } on BusquedaNoDisponible {
      throw const ServicioNoDisponibleFailure();
    }
  }

  @override
  PaginaBusqueda? unirPaginas(
    PaginaBusqueda? actual,
    PaginaBusqueda? siguiente,
  ) => PaginaBusqueda(
    interpretacion: actual!.interpretacion,
    items: unirSinRepetir(actual.items, siguiente!.items, (e) => e.id),
    siguiente: siguiente.siguiente,
  );

  /// Como [cargarMas]; si el cursor ya no vale, empieza otra vez desde la
  /// primera página (CA-17).
  Future<Failure?> verMas() async {
    final falla = await cargarMas();
    if (falla is! DatosRechazadosFailure) return falla;
    ref.invalidateSelf();
    return null;
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final busquedaControllerProvider = AsyncNotifierProvider.autoDispose
    .family<BusquedaController, PaginaBusqueda?, String>(
      BusquedaController.new,
      retry: (_, _) => null,
    );

/// Sugerencias para el texto de la consulta abierta. Si fallan, no estorban: la
/// búsqueda sigue funcionando.
final sugerenciasBusquedaProvider =
    FutureProvider.autoDispose<List<SugerenciaBusqueda>>((ref) async {
      final texto = ref.watch(consultaBusquedaProvider.select((c) => c.texto));
      if (texto == null) return const [];
      return ref.watch(busquedaRepositoryProvider).sugerencias(texto);
    }, retry: (_, _) => null);

/// Catálogo de oficios para los chips de filtro y «No entendimos» (spec 021,
/// §4, CA-03, CA-08).
final oficiosBusquedaProvider = FutureProvider.autoDispose<List<Oficio>>(
  (ref) => ref.watch(oficiosRepositoryProvider).listar(),
  retry: (_, _) => null,
);
