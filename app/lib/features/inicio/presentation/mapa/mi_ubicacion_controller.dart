import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';

/// Puerto de la cámara del mapa: lo implementa el widget del mapa y las
/// pruebas usan uno falso.
abstract interface class CamaraMapa {
  /// Mueve la cámara para centrarla en el punto.
  Future<void> moverA({required double latitud, required double longitud});
}

/// Aviso que se muestra cuando «Mi ubicación» no puede centrar el mapa.
enum AvisoUbicacion {
  sinPermiso(
    'Sin permiso de ubicación; puedes seguir usando el mapa.',
    ofreceAjustes: false,
  ),
  sinPermisoParaSiempre(
    'Sin permiso de ubicación; puedes seguir usando el mapa.',
    ofreceAjustes: true,
  ),
  servicioDesactivado(
    'Activa la ubicación del teléfono.',
    ofreceAjustes: false,
  );

  const AvisoUbicacion(this.texto, {required this.ofreceAjustes});

  /// Texto literal en español hasta que TT-MOB-02 lo pase a ARB.
  final String texto;

  /// Si el aviso lleva la acción «Abrir ajustes».
  final bool ofreceAjustes;
}

/// Controlador del botón «Mi ubicación».
///
/// El estado es solo el último aviso (o `null`). La posición **no** se guarda:
/// se usa para mover la cámara y se descarta (constitución §6).
class MiUbicacionController extends Notifier<AvisoUbicacion?> {
  @override
  AvisoUbicacion? build() => null;

  /// Pide la ubicación una vez y, si se concede, centra [camara] en ella.
  Future<void> centrar(CamaraMapa camara) async {
    state = null;
    final resultado = await ref
        .read(ubicacionRepositoryProvider)
        .obtenerUnaVez();
    if (!ref.mounted) return;
    switch (resultado) {
      case Concedida(:final latitud, :final longitud):
        await camara.moverA(latitud: latitud, longitud: longitud);
      case Denegada():
        state = AvisoUbicacion.sinPermiso;
      case DenegadaParaSiempre():
        state = AvisoUbicacion.sinPermisoParaSiempre;
      case ServicioDesactivado():
        state = AvisoUbicacion.servicioDesactivado;
    }
  }

  /// Abre los ajustes de la app (permiso negado para siempre).
  Future<void> abrirAjustes() =>
      ref.read(ubicacionRepositoryProvider).abrirAjustes();
}

final miUbicacionControllerProvider =
    NotifierProvider<MiUbicacionController, AvisoUbicacion?>(
      MiUbicacionController.new,
    );
