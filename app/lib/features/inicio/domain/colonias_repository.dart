import 'package:app/features/inicio/domain/colonia.dart';

/// Fuente de la colonia de un punto. Las coordenadas se usan para la consulta
/// y se descartan: no se guardan ni se registran (constitución §6).
abstract interface class ColoniasRepository {
  Future<ResultadoColonia> enPunto({
    required double latitud,
    required double longitud,
  });
}
