// KNOCK-248: el backend rechaza con 422 las coordenadas con más de 10 decimales
// o 16 caracteres, y el GPS devuelve 15 o más. El repositorio las envía con
// seis decimales (privacidad y contrato de `GET /api/v1/colonias/en-punto`).
import 'package:app/features/inicio/data/colonias_repository_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _enPunto =
    '{"enCobertura":true,"colonia":{"id":"1","nombre":"Centro",'
    '"cp":"42500","municipio":"Actopan"}}';

void main() {
  test(
    'Coordenadas_ConMuchosDecimales_SeEnvianConSeis_RedondeoDeContrato',
    () async {
      Uri? recibida;
      final cliente = MockClient((peticion) async {
        recibida = peticion.url;
        return http.Response(
          _enPunto,
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final repositorio = ColoniasRepositoryHttp(
        transporte: cliente,
        url: 'https://api.ejemplo.invalid',
      );

      await repositorio.enPunto(
        latitud: 20.271234567891234,
        longitud: -98.941187654321987,
      );

      final consulta = recibida!.queryParameters;
      final patron = RegExp(r'^-?\d{1,3}(\.\d{1,6})?$');
      expect(consulta['lat'], matches(patron));
      expect(consulta['lon'], matches(patron));
      expect(consulta['lat'], '20.271235');
      expect(consulta['lon'], '-98.941188');
      expect(consulta['lat']!.length, lessThanOrEqualTo(16));
      expect(consulta['lon']!.length, lessThanOrEqualTo(16));
    },
  );
}
