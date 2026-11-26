// Cliente HTTP falso para las pruebas de repositorios: responde siempre lo
// mismo y guarda cada petición.
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Responde [estado] con [cuerpo] en JSON (vacío si es `null`).
({http.Client cliente, List<http.Request> peticiones}) clienteQueResponde(
  int estado, [
  Object? cuerpo,
]) {
  final peticiones = <http.Request>[];
  final cliente = MockClient((peticion) async {
    peticiones.add(peticion);
    return http.Response(
      cuerpo == null ? '' : jsonEncode(cuerpo),
      estado,
      headers: {'content-type': 'application/json'},
    );
  });
  return (cliente: cliente, peticiones: peticiones);
}
