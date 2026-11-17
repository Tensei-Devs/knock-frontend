import 'package:app/core/red/enviar_json.dart';
import 'package:app/core/red/obtener_json.dart';
import 'package:app/features/inicio/data/zona_mapper.dart';
import 'package:app/features/inicio/domain/zona.dart';
import 'package:app/features/inicio/domain/zonas_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/zonas/cp/{cp}`. Pide sesión (Bearer, por el transporte
/// con sesión de la spec 026). El resultado puede guardarse en la caché de
/// `catalogo/` (spec 017, R-09).
class ZonasRepositoryHttp implements ZonasRepository {
  const ZonasRepositoryHttp({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<ResultadoZona> porCodigoPostal(String cp) async =>
      ZonaMapper.zonaDesdeContrato(
        await obtenerJson(transporte, url, 'zonas/cp/$cp'),
      );
}

/// REAL: `POST /api/v1/zonas/lista-espera`. Sin `Idempotency-Key`: el servidor
/// es idempotente por persona y código postal (spec 017, R-15). Una escritura
/// nunca se reintenta aquí.
class ListaEsperaRepositoryHttp implements ListaEsperaRepository {
  const ListaEsperaRepositoryHttp({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  @override
  Future<RegistroListaEspera> registrar({
    required String cp,
    String? municipio,
  }) async {
    final respuesta = await enviarJson(
      transporte,
      url,
      'POST',
      'zonas/lista-espera',
      cuerpo: {
        'cp': cp,
        if (municipio != null && municipio.trim().isNotEmpty)
          'municipio': municipio.trim(),
      },
    );
    return ZonaMapper.registroDesdeContrato(respuesta.json);
  }
}
