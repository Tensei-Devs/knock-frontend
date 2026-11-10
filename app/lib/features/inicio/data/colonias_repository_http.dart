import 'package:app/core/red/obtener_json.dart';
import 'package:app/features/inicio/data/colonia_mapper.dart';
import 'package:app/features/inicio/domain/colonia.dart';
import 'package:app/features/inicio/domain/colonias_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/colonias/en-punto?lat&lon`.
///
/// El contrato exige sesión: el [transporte] con sesión (spec 026) agrega el
/// Bearer y renueva ante un 401; sin sesión no sale la petición y llega
/// `NoAutorizadoFailure`. Las coordenadas no se registran ni se guardan en la
/// caché.
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
