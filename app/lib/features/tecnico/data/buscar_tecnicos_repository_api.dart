import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/tecnico/domain/buscar_tecnicos.dart';
import 'package:http/http.dart' as http;

class BuscarTecnicosRepositoryApi {
  const BuscarTecnicosRepositoryApi({
    required this.transporte,
    required this.url,
  });
  final http.Client transporte;
  final String url;

  Future<PaginaTecnicos> listar({String? oficio, String? cursor}) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'tecnicos',
      consulta: {'oficio': ?oficio, 'cursor': ?cursor},
    );
    final m = objetoDelContrato(r.json);
    return PaginaTecnicos([
      for (final valor in listaDelContrato(m['tecnicos']))
        _tecnico(objetoDelContrato(valor)),
    ], textoOpcional(m['nextCursor']));
  }

  Future<List<GrupoMapa>> mapa({String? zoom}) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'mapa/tecnicos',
      consulta: {'zoom': ?zoom},
    );
    final m = objetoDelContrato(r.json);
    return [
      for (final valor in listaDelContrato(m['grupos']))
        _grupo(objetoDelContrato(valor)),
    ];
  }

  static TecnicoEncontrado _tecnico(Map<Object?, Object?> m) =>
      TecnicoEncontrado(
        id: textoObligatorio(m['id']),
        nombre: textoObligatorio(m['nombre']),
        verificacion: textoObligatorio(m['verificacion']),
        oficios: [
          for (final valor in listaDelContrato(m['oficios']))
            textoObligatorio(valor),
        ],
      );

  static GrupoMapa _grupo(Map<Object?, Object?> m) {
    final cantidad = m['cantidad'] is int
        ? m['cantidad'] as int
        : int.tryParse('${m['cantidad']}');
    final lat = _numero(m['latitud']);
    final lng = _numero(m['longitud']);
    if (cantidad == null || cantidad < 1 || lat.abs() > 90 || lng.abs() > 180) {
      throw const DatosInvalidosFailure();
    }
    return GrupoMapa(
      latitud: lat,
      longitud: lng,
      cantidad: cantidad,
      tecnicoId: textoOpcional(m['tecnicoId']),
    );
  }

  static double _numero(Object? valor) {
    final n = valor is num ? valor.toDouble() : double.tryParse('$valor');
    if (n == null || !n.isFinite) throw const DatosInvalidosFailure();
    return n;
  }
}
