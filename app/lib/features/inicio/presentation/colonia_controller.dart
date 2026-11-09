import 'package:app/core/errores/failure.dart';
import 'package:app/features/inicio/domain/colonia.dart';
import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Por qué no hay colonia que mostrar todavía o cómo se resolvió.
sealed class EstadoColonia {
  const EstadoColonia();
}

/// Aún no se ha pedido (la persona toca «Ver mi colonia»).
final class ColoniaSinPedir extends EstadoColonia {
  const ColoniaSinPedir();
}

/// Se pidió la ubicación y la colonia al servidor.
final class ColoniaConsultando extends EstadoColonia {
  const ColoniaConsultando();
}

final class ColoniaEncontrada extends EstadoColonia {
  const ColoniaEncontrada(this.colonia);
  final Colonia colonia;
}

final class ColoniaFueraDeCobertura extends EstadoColonia {
  const ColoniaFueraDeCobertura();
}

/// Sin permiso o con el servicio de ubicación apagado.
final class ColoniaSinUbicacion extends EstadoColonia {
  const ColoniaSinUbicacion();
}

final class ColoniaConError extends EstadoColonia {
  const ColoniaConError(this.falla);
  final Failure falla;
}

/// Lee la ubicación una vez, busca su colonia y descarta las coordenadas.
class ColoniaController extends Notifier<EstadoColonia> {
  @override
  EstadoColonia build() => const ColoniaSinPedir();

  Future<void> consultar() async {
    state = const ColoniaConsultando();
    final ubicacion = await ref
        .read(ubicacionRepositoryProvider)
        .obtenerUnaVez();
    if (ubicacion is! Concedida) {
      state = const ColoniaSinUbicacion();
      return;
    }
    try {
      final resultado = await ref
          .read(coloniasRepositoryProvider)
          .enPunto(latitud: ubicacion.latitud, longitud: ubicacion.longitud);
      final colonia = resultado.colonia;
      state = resultado.enCobertura && colonia != null
          ? ColoniaEncontrada(colonia)
          : const ColoniaFueraDeCobertura();
    } on Failure catch (falla) {
      state = ColoniaConError(falla);
    }
  }
}

final coloniaControllerProvider =
    NotifierProvider<ColoniaController, EstadoColonia>(ColoniaController.new);
