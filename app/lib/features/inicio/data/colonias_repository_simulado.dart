import 'package:app/features/inicio/data/colonia_mapper.dart';
import 'package:app/features/inicio/domain/colonia.dart';
import 'package:app/features/inicio/domain/colonias_repository.dart';

/// SIMULADO: respuesta ficticia con la forma del contrato, para la demo sin
/// `KNOCK_API_URL`. Pasa por [ColoniaMapper] igual que la respuesta real.
class ColoniasRepositorySimulado implements ColoniasRepository {
  const ColoniasRepositorySimulado();

  @override
  Future<ResultadoColonia> enPunto({
    required double latitud,
    required double longitud,
  }) async => ColoniaMapper.desdeContrato(const {
    'enCobertura': true,
    'colonia': {
      'id': '00000000-0000-4000-8000-000000000001',
      'nombre': 'Colonia de ejemplo',
      'cp': '00000',
      'municipio': 'Municipio de ejemplo',
    },
  });
}
