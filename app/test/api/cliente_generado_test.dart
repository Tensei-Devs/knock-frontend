// Spec 006 (KNOCK-220): el cliente generado corresponde al contrato vendorizado.
//
// Corre en cada `flutter test` (y por eso en el CI actual): si alguien edita
// app/packages/knock_api a mano o cambia contracts/openapi.v1.json sin
// regenerar, el manifiesto deja de coincidir y la prueba falla (R-04).
// La regeneración completa la hace `python app/tool/generar_cliente_api.py --check`.
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knock_api/api.dart';

final _contrato = File('../contracts/openapi.v1.json');
final _paquete = Directory('packages/knock_api');
const _nombreManifiesto = '.knock-manifest.json';

List<int> _bytesLf(File archivo) {
  final bytes = archivo.readAsBytesSync();
  final salida = <int>[];
  for (var i = 0; i < bytes.length; i++) {
    if (bytes[i] == 13 && i + 1 < bytes.length && bytes[i + 1] == 10) continue;
    salida.add(bytes[i]);
  }
  return salida;
}

String _sha(File archivo) => sha256.convert(_bytesLf(archivo)).toString();

Map<String, Object?> _json(File archivo) =>
    jsonDecode(utf8.decode(_bytesLf(archivo))) as Map<String, Object?>;

/// Diferencias entre una carpeta del cliente y su manifiesto.
List<String> diferenciasConManifiesto(Directory carpeta, File contrato) {
  final manifiesto = _json(File('${carpeta.path}/$_nombreManifiesto'));
  final esperados = (manifiesto['archivos']! as Map<String, Object?>)
      .cast<String, String>();
  final diferencias = <String>[];
  if (manifiesto['contratoSha256'] != _sha(contrato)) {
    diferencias.add('contrato distinto al usado para generar');
  }
  final reales = <String, String>{};
  for (final entidad in carpeta.listSync(recursive: true)) {
    if (entidad is! File) continue;
    final relativa = entidad.path
        .substring(carpeta.path.length + 1)
        .replaceAll(r'\', '/');
    if (relativa == _nombreManifiesto ||
        relativa == 'pubspec.lock' ||
        relativa.startsWith('.dart_tool/')) {
      continue;
    }
    reales[relativa] = _sha(entidad);
  }
  for (final nombre in esperados.keys) {
    if (!reales.containsKey(nombre)) {
      diferencias.add('falta: $nombre');
    } else if (reales[nombre] != esperados[nombre]) {
      diferencias.add('distinto: $nombre');
    }
  }
  for (final nombre in reales.keys) {
    if (!esperados.containsKey(nombre)) diferencias.add('sobra: $nombre');
  }
  return diferencias;
}

String _archivoDelModelo(String esquema) {
  final serpiente = esquema
      .replaceAllMapped(RegExp('(?<!^)([A-Z])'), (m) => '_${m[1]}')
      .toLowerCase();
  return '${_paquete.path}/lib/model/$serpiente.dart';
}

void main() {
  group('CA-006-01 los tipos del cliente salen del contrato', () {
    test('CA-006-01 cada esquema del contrato tiene su modelo con sus campos '
        'y los requeridos no son anulables', () {
      final esquemas =
          ((_json(_contrato)['components']! as Map)['schemas']! as Map)
              .cast<String, Map<String, Object?>>();
      expect(esquemas, isNotEmpty);
      for (final MapEntry(key: nombre, value: esquema) in esquemas.entries) {
        final archivo = File(_archivoDelModelo(nombre));
        expect(archivo.existsSync(), isTrue, reason: 'falta el modelo $nombre');
        final codigo = archivo.readAsStringSync();
        expect(codigo, contains('class $nombre {'));
        final propiedades = (esquema['properties']! as Map).keys.cast<String>();
        final requeridos = ((esquema['required'] as List?) ?? const [])
            .cast<String>();
        for (final propiedad in propiedades) {
          expect(
            codigo,
            contains("json[r'$propiedad']"),
            reason: '$nombre.$propiedad no está en el modelo generado',
          );
          if (requeridos.contains(propiedad)) {
            expect(codigo, contains('required this.$propiedad,'));
          }
        }
      }
    });

    test('CA-006-01 la ruta del canje del contrato es la del cliente', () {
      final rutas = (_json(_contrato)['paths']! as Map).keys;
      final api = File('${_paquete.path}/lib/api/auth_api.dart')
          .readAsStringSync();
      expect(rutas, contains('/api/v{version}/auth/firebase'));
      expect(api, contains("r'/api/v{version}/auth/firebase'"));
    });

    test('CA-006-01 SessionResponse lee y escribe los cuatro campos', () {
      final sesion = SessionResponse.fromJson({
        'accessToken': 'acceso-ficticio',
        'refreshToken': 'renovacion-ficticia',
        'esNuevo': true,
        'perfilCompleto': false,
      })!;
      expect(sesion.accessToken, 'acceso-ficticio');
      expect(sesion.refreshToken, 'renovacion-ficticia');
      expect(sesion.esNuevo, isTrue);
      expect(sesion.perfilCompleto, isFalse);
      expect(sesion.toJson().keys, {
        'accessToken',
        'refreshToken',
        'esNuevo',
        'perfilCompleto',
      });
    });
  });

  group('CA-006-02 un cliente editado a mano se detecta', () {
    test('CA-006-02 el cliente del repositorio coincide con su manifiesto '
        'y con el contrato vendorizado', () {
      expect(diferenciasConManifiesto(_paquete, _contrato), isEmpty);
    });

    test('CA-006-02 una edición a mano, un archivo agregado o un contrato '
        'cambiado hacen fallar la comprobación', () {
      final tmp = Directory.systemTemp.createTempSync('knock-api-');
      addTearDown(() => tmp.deleteSync(recursive: true));
      final copia = Directory('${tmp.path}/knock_api')..createSync();
      for (final entidad in _paquete.listSync(recursive: true)) {
        if (entidad is! File) continue;
        final relativa = entidad.path.substring(_paquete.path.length + 1);
        if (relativa.startsWith('.dart_tool')) continue;
        final destino = File('${copia.path}/$relativa')
          ..createSync(recursive: true);
        entidad.copySync(destino.path);
      }
      final contrato = _contrato.copySync('${tmp.path}/openapi.v1.json');
      expect(diferenciasConManifiesto(copia, contrato), isEmpty);

      final modelo = File('${copia.path}/lib/model/session_response.dart');
      modelo.writeAsStringSync('${modelo.readAsStringSync()}\n// a mano\n');
      File('${copia.path}/lib/extra.dart').writeAsStringSync('// extra\n');
      contrato.writeAsStringSync('${contrato.readAsStringSync()} ');

      expect(
        diferenciasConManifiesto(copia, contrato),
        unorderedEquals([
          'contrato distinto al usado para generar',
          'distinto: lib/model/session_response.dart',
          'sobra: lib/extra.dart',
        ]),
      );
    });
  });
}
