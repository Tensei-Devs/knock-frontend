import 'package:app/core/red/obtener_json.dart';
import 'package:app/features/inicio/data/colonia_mapper.dart';
import 'package:app/features/inicio/domain/colonia.dart';
import 'package:app/features/inicio/domain/colonias_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/colonias/en-punto?lat&lon`.
///
/// El contrato exige sesión (responde 401 sin token) y la app aún no manda el
/// token (sesión real pendiente, KNOCK-228/spec 002): sin sesión llega
/// `NoAutorizadoFailure` y la pantalla lo muestra con su mensaje.
class ColoniasRepositoryHttp implements ColoniasRepository {
  const ColoniasRepositoryHttp({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<ResultadoColonia> enPunto({
    required double latitud,
    required double longitud,
  }) async => ColoniaMapper.desdeContrato(
    await obtenerJson(
      transporte,
      url,
      'colonias/en-punto',
      consulta: {'lat': '$latitud', 'lon': '$longitud'},
    ),
  );
}
