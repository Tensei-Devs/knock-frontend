// Spec 047, CA-16: los mensajes no tocan disco, registros ni caché.
// Solo datos ficticios.
import 'dart:io';

import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../soporte/api_falsa.dart';

List<File> _fuentesDelChat() => [
  ...Directory('lib/features/mensajes')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart')),
  File('lib/features/maqueta/conversacion_real.dart'),
  File('lib/features/maqueta/boton_conversacion.dart'),
];

bool _revalida(PeticionApi p) =>
    p.cabeceras.keys.any((k) => k.toLowerCase() == 'if-none-match');

void main() {
  test('CA_047_16 el chat no escribe en disco ni en registros', () {
    final prohibido = RegExp(
      r'shared_preferences|flutter_secure_storage|path_provider|dart:io|'
      r'dart:developer|debugPrint|print\(|configureLogging|Logger\(',
    );
    for (final archivo in _fuentesDelChat()) {
      expect(
        prohibido.hasMatch(archivo.readAsStringSync()),
        isFalse,
        reason: archivo.path,
      );
    }
  });

  test('CA_047_16 las conversaciones y sus mensajes no entran en la '
      'caché', () async {
    final api = ApiFalsa(
      (_) => jsonOk({'items': <Object?>[]}, h: {'etag': '"v1"'}),
    );
    final contenedor = ProviderContainer(
      overrides: [
        urlApiProvider.overrideWithValue(urlApiPrueba),
        transporteHttpProvider.overrideWithValue(api.transporte),
        tokensInicialesProvider.overrideWithValue(
          const TokensSesion(accessToken: 'ficticio', refreshToken: 'ficticio'),
        ),
      ],
    );
    addTearDown(contenedor.dispose);
    final transporte = contenedor.read(transporteApiProvider);
    for (final ruta in [
      'conversaciones',
      'conversaciones/c1',
      'conversaciones/c1/mensajes',
    ]) {
      final url = Uri.parse('$urlApiPrueba/api/v1/$ruta');
      for (var vez = 0; vez < 2; vez++) {
        final respuesta = await http.Response.fromStream(
          await transporte.send(http.Request('GET', url)),
        );
        expect(respuesta.statusCode, 200);
      }
    }
    expect(api.peticiones, hasLength(6));
    expect(api.peticiones.map(_revalida), everyElement(isFalse));

    // Control: una lectura que sí se guarda revalida la segunda vez.
    final oficios = Uri.parse('$urlApiPrueba/api/v1/oficios');
    for (var vez = 0; vez < 2; vez++) {
      await http.Response.fromStream(
        await transporte.send(http.Request('GET', oficios)),
      );
    }
    expect(_revalida(api.peticiones.last), isTrue);
  });
}
