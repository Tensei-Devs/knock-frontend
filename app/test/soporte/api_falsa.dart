// Spec 026: API falsa en memoria (MockClient) y contenedor con la sesión real.
// Solo datos ficticios; ningún token real.
import 'dart:async';
import 'dart:convert';

import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/espera_por_limite.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const urlApiPrueba = 'https://api.knock.test';

/// Petición que llegó a la API falsa.
class PeticionApi {
  PeticionApi(this.metodo, this.url, this.cabeceras, this.cuerpo);

  final String metodo;
  final Uri url;
  final Map<String, String> cabeceras;
  final String cuerpo;

  /// Ruta sin el prefijo `/api/v1/`.
  String get ruta => url.path.replaceFirst('/api/v1/', '');

  /// Método y ruta completa, por ejemplo `POST /api/v1/auth/refresh`.
  String get llamadaCompleta => '$metodo ${url.path}';

  String? get autorizacion => cabeceras['authorization'];

  Map<String, Object?> get json => jsonDecode(cuerpo) as Map<String, Object?>;

  @override
  String toString() => '$metodo $ruta';
}

typedef ResponderApi = FutureOr<http.Response> Function(PeticionApi peticion);

/// API falsa: guarda cada petición y responde con [responder].
class ApiFalsa {
  ApiFalsa([ResponderApi? responder])
    : responder = responder ?? ((_) => http.Response('', 200));

  ResponderApi responder;
  final peticiones = <PeticionApi>[];

  late final MockClient cliente = MockClient((peticion) async {
    final registrada = PeticionApi(peticion.method, peticion.url, {
      for (final e in peticion.headers.entries) e.key.toLowerCase(): e.value,
    }, peticion.body);
    peticiones.add(registrada);
    return responder(registrada);
  });

  /// Transporte público de la app: la API falsa detrás de la espera por 429.
  http.Client get transporte => ClienteConEspera(cliente);

  List<String> get llamadas => [for (final p in peticiones) '$p'];
}

http.Response jsonOk(
  Object cuerpo, {
  int estado = 200,
  Map<String, String>? h,
}) => http.Response.bytes(
  utf8.encode(jsonEncode(cuerpo)),
  estado,
  headers: {'content-type': 'application/json', ...?h},
);

Map<String, Object?> perfilJson({
  String? nombre = 'Ana López',
  String? fotoUrl,
  String? colonia,
  String? codigoPostal,
}) => {
  'id': 'u-1',
  'nombre': nombre,
  'fotoUrl': fotoUrl,
  'colonia': colonia,
  'codigoPostal': codigoPostal,
  'esTecnico': false,
  'estado': 'activo',
  'perfilCompleto': nombre != null,
  'creadoEn': '2026-11-01T10:00:00Z',
};

Map<String, Object?> tokensJson(String acceso, String refresco) => {
  'accessToken': acceso,
  'expiresIn': 900,
  'refreshToken': refresco,
};

/// Tokens ficticios (cortos y claramente no secretos).
const tokensA = TokensSesion(accessToken: 'acc-A', refreshToken: 'ref-A');

/// Contenedor con la API falsa en lugar de la red y la sesión real sobre un
/// almacén seguro en memoria ([almacen]).
ProviderContainer contenedorConApi(
  ApiFalsa api, {
  TokensSesion? tokens = tokensA,
  AlmacenSeguroEnMemoria? almacen,
  List<Override> extra = const [],
}) {
  final almacenSeguro = almacen ?? AlmacenSeguroEnMemoria();
  final c = ProviderContainer(
    overrides: [
      urlApiProvider.overrideWithValue(urlApiPrueba),
      transporteHttpProvider.overrideWithValue(api.transporte),
      almacenSeguroProvider.overrideWithValue(almacenSeguro),
      tokensInicialesProvider.overrideWithValue(tokens),
      sesionInicialProvider.overrideWithValue(tokens != null),
      ...extra,
    ],
  );
  return c;
}
