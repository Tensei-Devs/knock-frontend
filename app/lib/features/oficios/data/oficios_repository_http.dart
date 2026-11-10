import 'package:app/core/red/obtener_json.dart';
import 'package:app/features/oficios/data/oficio_mapper.dart';
import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/oficios_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/oficios` (público, sin token).
class OficiosRepositoryHttp implements OficiosRepository {
  const OficiosRepositoryHttp({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<List<Oficio>> listar() async => OficioMapper.listaDesdeContrato(
    await obtenerJson(transporte, url, 'oficios'),
  );
}
