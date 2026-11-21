import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/presentation/mapa/mi_ubicacion_controller.dart';

/// Repositorio de ubicación falso: devuelve [resultado] y cuenta llamadas.
class UbicacionFalsa implements UbicacionRepository {
  UbicacionFalsa(this.resultado, {this.permiso = true});

  ResultadoUbicacion resultado;

  /// Si el permiso ya estaba concedido antes de preguntar.
  bool permiso;
  int llamadas = 0;
  int ajustesAbiertos = 0;

  @override
  Future<bool> permisoConcedido() async => permiso;

  @override
  Future<ResultadoUbicacion> obtenerUnaVez() async {
    llamadas++;
    return resultado;
  }

  @override
  Future<void> abrirAjustes() async => ajustesAbiertos++;
}

/// Cámara falsa: registra cada punto al que se le pide moverse.
class CamaraFalsa implements CamaraMapa {
  final movimientos = <(double, double)>[];

  @override
  Future<void> moverA({
    required double latitud,
    required double longitud,
  }) async => movimientos.add((latitud, longitud));
}
