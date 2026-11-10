import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cómo se eligió la zona de búsqueda (spec 012, R-07).
sealed class EstadoZona {
  const EstadoZona();
}

final class ZonaSinElegir extends EstadoZona {
  const ZonaSinElegir();
}

/// Sin permiso o sin servicio de ubicación: se pide el código postal.
final class ZonaPideCodigoPostal extends EstadoZona {
  const ZonaPideCodigoPostal();
}

/// Se usó la ubicación del teléfono. Las coordenadas no se guardan aquí.
final class ZonaPorUbicacion extends EstadoZona {
  const ZonaPorUbicacion();
}

final class ZonaPorCodigoPostal extends EstadoZona {
  const ZonaPorCodigoPostal(this.codigo);

  final String codigo;
}

/// Código postal mexicano: 5 números.
bool esCodigoPostalValido(String texto) => RegExp(r'^\d{5}$').hasMatch(texto);

/// Elige la zona con la ubicación y, si no se puede, con el código postal.
///
/// La app funciona sin el permiso: un permiso negado nunca es un error, solo
/// cambia la forma de elegir la zona. Las coordenadas se entregan a
/// [alUbicar] y se descartan (constitución §6).
class ZonaController extends Notifier<EstadoZona> {
  @override
  EstadoZona build() => const ZonaSinElegir();

  /// Pide la ubicación una vez (la explicación previa la muestra la pantalla).
  Future<void> usarUbicacion({
    required void Function(double latitud, double longitud) alUbicar,
  }) async {
    final resultado = await ref
        .read(ubicacionRepositoryProvider)
        .obtenerUnaVez();
    if (!ref.mounted) return;
    switch (resultado) {
      case Concedida(:final latitud, :final longitud):
        alUbicar(latitud, longitud);
        state = const ZonaPorUbicacion();
      case Denegada() || DenegadaParaSiempre() || ServicioDesactivado():
        state = const ZonaPideCodigoPostal();
    }
  }

  /// Fija la zona por código postal. Devuelve `false` si no es válido.
  bool usarCodigoPostal(String texto) {
    final codigo = texto.trim();
    if (!esCodigoPostalValido(codigo)) return false;
    state = ZonaPorCodigoPostal(codigo);
    return true;
  }
}

final zonaControllerProvider = NotifierProvider<ZonaController, EstadoZona>(
  ZonaController.new,
);
