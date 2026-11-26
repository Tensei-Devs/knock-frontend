import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/tecnico/domain/reputacion.dart';
import 'package:http/http.dart' as http;

class ReputacionRepositoryApi implements ReputacionRepository {
  const ReputacionRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<Reputacion> obtener() async {
    final respuesta = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'tecnicos/me/reputacion',
    );
    final json = objetoDelContrato(respuesta.json);
    if (!json.containsKey('promedio')) throw const DatosInvalidosFailure();
    final promedio = json['promedio'];
    final numero = promedio is num
        ? promedio.toDouble()
        : promedio is String
        ? double.tryParse(promedio)
        : null;
    if (promedio != null && (numero == null || !numero.isFinite)) {
      throw const DatosInvalidosFailure();
    }
    final distribucion = objetoDelContrato(json['distribucion']);
    return Reputacion(
      promedio: numero,
      total: _entero(json['total']),
      distribucion: {
        for (final entrada in distribucion.entries)
          _estrella(entrada.key): _entero(entrada.value),
      },
      nivel: textoObligatorio(json['nivel']),
    );
  }

  static int _entero(Object? valor) {
    final numero = valor is int ? valor : int.tryParse('$valor');
    if (numero == null || numero < 0) throw const DatosInvalidosFailure();
    return numero;
  }

  static int _estrella(Object? valor) {
    final numero = _entero(valor);
    if (numero < 1 || numero > 5) throw const DatosInvalidosFailure();
    return numero;
  }
}
