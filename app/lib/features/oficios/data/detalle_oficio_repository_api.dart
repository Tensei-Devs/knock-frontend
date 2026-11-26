import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/oficios/domain/detalle_oficio.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/oficios/{clave}` y `POST /api/v1/oficios-pedidos`.
class DetalleOficioRepositoryApi implements DetalleOficioRepository {
  const DetalleOficioRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  @override
  Future<DetalleOficio> detalle(String clave) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'oficios/${Uri.encodeComponent(clave)}',
    );
    final m = objetoDelContrato(r.json);
    return DetalleOficio(
      clave: textoObligatorio(m['clave']),
      frasesSugeridas: [
        for (final f in listaDelContrato(m['frasesSugeridas']))
          textoObligatorio(f),
      ],
    );
  }

  @override
  Future<void> pedirOficio(String texto) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'oficios-pedidos',
      cuerpo: {'texto': texto},
    );
    textoObligatorio(objetoDelContrato(r.json)['id']);
  }
}
