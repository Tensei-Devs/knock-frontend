import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/tecnico/domain/buscar_tecnicos.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Los grupos de la zona visible. Una consulta por zona: la respuesta de una
/// zona anterior nunca pisa a la actual.
class MapaTecnicosController extends AsyncNotifier<List<GrupoMapa>> {
  MapaTecnicosController(this.consulta);
  final ConsultaMapa consulta;

  @override
  Future<List<GrupoMapa>> build() {
    ref.watch(sesionProvider.select((t) => t != null));
    return ref
        .watch(buscarTecnicosRepositoryProvider)
        .mapa(
          norte: consulta.norte,
          sur: consulta.sur,
          este: consulta.este,
          oeste: consulta.oeste,
          zoom: consulta.zoom,
          oficio: consulta.oficio,
        );
  }

  void reintentar() => ref.invalidateSelf();
}

final mapaTecnicosControllerProvider = AsyncNotifierProvider.autoDispose
    .family<MapaTecnicosController, List<GrupoMapa>, ConsultaMapa>(
      MapaTecnicosController.new,
      retry: (_, _) => null,
    );
