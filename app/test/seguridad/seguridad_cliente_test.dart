// Spec 009 (KNOCK-223): controles de seguridad comunes del cliente que se
// comprueban leyendo el código y el manifiesto (sin secretos, solo HTTPS,
// permisos mínimos y registros sin datos personales). Se ejecutan desde `app/`.
import 'dart:io';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/mapa/mi_ubicacion_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../features/inicio/presentation/mapa/fakes_ubicacion.dart';

/// Archivos de código y configuración que se revisan (rutas desde `app/`).
Iterable<File> _archivos(List<String> carpetas, Set<String> extensiones) sync* {
  const ignoradas = ['/build/', '/.gradle/', '/.dart_tool/', '/generado/'];
  for (final carpeta in carpetas) {
    final dir = Directory(carpeta);
    if (!dir.existsSync()) continue;
    for (final e in dir.listSync(recursive: true, followLinks: false)) {
      final ruta = e.path.replaceAll(r'\', '/');
      if (e is! File || ignoradas.any(ruta.contains)) continue;
      if (ruta.endsWith('local.properties')) continue;
      if (extensiones.any(ruta.endsWith)) yield e;
    }
  }
}

String _manifiesto() =>
    File('android/app/src/main/AndroidManifest.xml').readAsStringSync();

void main() {
  group('R-01 sin claves ni secretos en el repositorio', () {
    final patrones = <String, RegExp>{
      'clave de Google (AIza...)': RegExp(r'AIza[0-9A-Za-z_\-]{35}'),
      'llave privada': RegExp(r'-----BEGIN [A-Z ]*PRIVATE KEY-----'),
      'token de GitHub': RegExp(r'gh[pousr]_[0-9A-Za-z]{36,}'),
      'clave de AWS': RegExp(r'AKIA[0-9A-Z]{16}'),
    };

    test(
      'CA_009_01 el código, la configuración y los flujos no contienen claves',
      () {
        final revisados =
            _archivos(
              ['lib', 'test', 'android', 'ios', '../.github'],
              {
                '.dart',
                '.kt',
                '.kts',
                '.xml',
                '.gradle',
                '.yml',
                '.yaml',
                '.plist',
                '.json',
                '.properties',
              },
            ).where(
              (f) => !f.path
                  .replaceAll(r'\', '/')
                  .endsWith('seguridad_cliente_test.dart'),
            );
        var cuantos = 0;
        for (final archivo in revisados) {
          cuantos++;
          final texto = archivo.readAsStringSync();
          patrones.forEach((nombre, patron) {
            expect(
              patron.hasMatch(texto),
              isFalse,
              reason: '$nombre en ${archivo.path}',
            );
          });
        }
        expect(
          cuantos,
          greaterThan(10),
          reason: 'la revisión sí encontró archivos',
        );
      },
    );

    test(
      'CA_009_01 los archivos de claves de servicios no están en el árbol',
      () {
        for (final ruta in [
          'android/app/google-services.json',
          'ios/Runner/GoogleService-Info.plist',
          'android/key.properties',
        ]) {
          expect(File(ruta).existsSync(), isFalse, reason: ruta);
        }
        final ignorado = File('../.gitignore').readAsStringSync();
        for (final regla in [
          'google-services.json',
          'GoogleService-Info.plist',
          'local.properties',
          '*.keystore',
        ]) {
          expect(
            ignorado,
            contains(regla),
            reason: '.gitignore debe cubrir $regla',
          );
        }
      },
    );

    test('CA_009_01 la clave de Maps y la URL de la API llegan por variables, no fijas', () {
      expect(_manifiesto(), contains(r'${mapsApiKey}'));
      for (final archivo in _archivos(['lib'], {'.dart'})) {
        final texto = archivo.readAsStringSync();
        expect(
          texto,
          isNot(contains('azurecontainerapps.io')),
          reason: archivo.path,
        );
      }
      expect(
        urlApiDefinida,
        isEmpty,
        reason: 'sin --dart-define no hay URL por omisión',
      );
    });
  });

  group('R-03 solo HTTPS y certificados válidos', () {
    test(
      'R-03 no se aceptan certificados inválidos ni se escriben URL http fijas',
      () {
        final http = RegExp(r'''['"]http://([^/'":]+)''');
        const locales = {'localhost', '127.0.0.1', '10.0.2.2'};
        for (final archivo in _archivos(['lib'], {'.dart'})) {
          final texto = archivo.readAsStringSync();
          expect(
            texto,
            isNot(contains('badCertificateCallback')),
            reason: archivo.path,
          );
          expect(
            texto,
            isNot(contains('allowLegacyUnsafeRenegotiation')),
            reason: archivo.path,
          );
          for (final m in http.allMatches(texto)) {
            expect(
              locales,
              contains(m.group(1)),
              reason: '${archivo.path}: ${m.group(0)}',
            );
          }
        }
      },
    );

    test('R-03 el manifiesto principal no habilita tráfico sin cifrar', () {
      expect(_manifiesto(), isNot(contains('usesCleartextTraffic="true"')));
      expect(_manifiesto(), isNot(contains('networkSecurityConfig')));
    });

    test('R-03 la URL de la API solo admite https o la máquina local', () {
      expect(normalizarUrlApi('http://api.ejemplo.test'), isNull);
      expect(normalizarUrlApi('https://api.ejemplo.test'), isNotNull);
    });
  });

  group('R-04 permisos mínimos', () {
    test(
      'CA_009_03 el manifiesto solo declara ubicación aproximada e INTERNET',
      () {
        final permisos = RegExp(r'<uses-permission[^>]*android:name="([^"]+)"')
            .allMatches(_manifiesto())
            .map((m) => m.group(1))
            .toSet();
        expect(permisos, {
          'android.permission.ACCESS_COARSE_LOCATION',
          'android.permission.INTERNET',
        });
      },
    );

    test(
      'CA_009_03 con el permiso negado la app avisa y sigue funcionando',
      () async {
        final ubicacion = UbicacionFalsa(const Denegada());
        final camara = CamaraFalsa();
        final contenedor = ProviderContainer(
          overrides: [ubicacionRepositoryProvider.overrideWithValue(ubicacion)],
        );
        addTearDown(contenedor.dispose);
        final controlador = contenedor.read(
          miUbicacionControllerProvider.notifier,
        );

        await controlador.centrar(camara);
        expect(
          contenedor.read(miUbicacionControllerProvider),
          AvisoUbicacion.sinPermiso,
        );
        expect(camara.movimientos, isEmpty);

        // Sigue funcionando: tras conceder el permiso, el mismo botón centra el mapa.
        ubicacion.resultado = const Concedida(
          latitud: 20.061,
          longitud: -99.342,
        );
        await controlador.centrar(camara);
        expect(camara.movimientos, [(20.061, -99.342)]);
      },
    );
  });

  group('R-05 los registros no incluyen datos personales', () {
    test(
      'R-05 el código de la app no escribe en la consola ni en registros',
      () {
        final prohibido = RegExp(
          r'\b(print|debugPrint|debugPrintStack)\s*\(|dart:developer|\blog\s*\(|package:logging',
        );
        for (final archivo in _archivos(['lib'], {'.dart'})) {
          expect(
            prohibido.hasMatch(archivo.readAsStringSync()),
            isFalse,
            reason: archivo.path,
          );
        }
      },
    );

    test('R-05 un Failure solo se imprime con su nombre, sin datos', () {
      const fallos = <Failure>[
        NoAutorizadoFailure(),
        DatosRechazadosFailure(),
        DemasiadosIntentosFailure(espera: Duration(seconds: 30)),
        AvisoNoAceptadoFailure(),
      ];
      for (final f in fallos) {
        expect(f.toString(), f.runtimeType.toString());
      }
    });

    test('R-07 el deviceId no usa identificadores propios del teléfono', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      for (final paquete in [
        'device_info_plus',
        'android_id',
        'platform_device_id',
        'advertising_id',
        'imei',
      ]) {
        expect(pubspec, isNot(contains(paquete)));
      }
    });
  });
}
