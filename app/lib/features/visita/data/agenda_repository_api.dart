import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/visita/domain/agenda.dart';
import 'package:http/http.dart' as http;

class AgendaRepositoryApi implements AgendaRepository {
  const AgendaRepositoryApi({required this.transporte, required this.url});
  final http.Client transporte;
  final String url;

  @override
  Future<PaginaAgenda> listar({String? cursor}) async {
    final respuesta = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'agenda',
      consulta: cursor == null ? null : {'Cursor': cursor},
    );
    final m = objetoDelContrato(respuesta.json);
    return PaginaAgenda([
      for (final item in listaDelContrato(m['items']))
        _visita(objetoDelContrato(item)),
    ], textoOpcional(m['nextCursor']));
  }

  static VisitaAgenda _visita(Map<Object?, Object?> m) {
    final precio = m['precio'];
    final numero = precio is int ? precio : int.tryParse('$precio');
    if (!m.containsKey('precio') || (precio != null && numero == null)) {
      throw const DatosInvalidosFailure();
    }
    return VisitaAgenda(
      id: textoObligatorio(m['id']),
      estado: textoObligatorio(m['estado']),
      modalidad: textoObligatorio(m['modalidad']),
      fechaHora: fechaHoraObligatoria(m['fechaHora']),
      dia: textoObligatorio(m['dia']),
      hora: textoObligatorio(m['hora']),
      precio: numero,
    );
  }
}
