// Spec 026 (KNOCK-248), P-6: composición real o simulada según `KNOCK_API_URL`
// y el modo de compilación. Una compilación de tienda sin URL válida no abre.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/data/perfil_repository_api.dart';
import 'package:app/features/cuenta/data/perfil_repository_simulado.dart';
import 'package:app/features/inicio/data/colonias_repository_http.dart';
import 'package:app/features/inicio/data/colonias_repository_simulado.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;
import 'package:flutter_test/flutter_test.dart';

ProviderContainer _contenedor({required String url, required bool release}) {
  final c = ProviderContainer(
    overrides: [
      urlApiProvider.overrideWithValue(url),
      modoReleaseProvider.overrideWithValue(release),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

/// La causa real de un provider que falló al crearse.
Object _causa(Object error) {
  var causa = error;
  while (causa is ProviderException) {
    causa = causa.exception;
  }
  return causa;
}

void main() {
  group('release sin URL válida', () {
    test('CA_026_22 arrancar falla con ApiNoConfiguradaFailure antes de abrir la app', () async {
      for (final url in ['', 'http://api.knock.mx', 'https://', 'no es url']) {
        await expectLater(
          arrancar(urlApi: url, esRelease: true),
          throwsA(isA<ApiNoConfiguradaFailure>()),
          reason: url,
        );
      }
    });

    test('CA_026_22 la validación acepta una URL https y el modo de desarrollo sin URL', () {
      expect(
        () => validarConfiguracionApi(
          url: 'https://api.knock.test',
          esRelease: true,
        ),
        returnsNormally,
      );
      expect(
        () => validarConfiguracionApi(url: '', esRelease: false),
        returnsNormally,
      );
    });

    test('CA_026_22 en release ningún repositorio cae al simulado', () {
      final c = _contenedor(url: '', release: true);
      for (final leer in <Object Function()>[
        () => c.read(perfilRepositoryProvider),
        () => c.read(coloniasRepositoryProvider),
      ]) {
        Object? fallo;
        try {
          leer();
        } on Object catch (e) {
          fallo = _causa(e);
        }
        expect(fallo, isA<ApiNoConfiguradaFailure>());
      }
    });
  });

  group('desarrollo', () {
    test('CA_026_23 sin KNOCK_API_URL usa los repositorios simulados', () {
      final c = _contenedor(url: '', release: false);
      expect(c.read(perfilRepositoryProvider), isA<PerfilRepositorySimulado>());
      expect(
        c.read(coloniasRepositoryProvider),
        isA<ColoniasRepositorySimulado>(),
      );
    });

    test('CA_026_23 con una URL válida usa los reales', () {
      final c = _contenedor(url: 'https://api.knock.test', release: false);
      expect(c.read(perfilRepositoryProvider), isA<PerfilRepositoryApi>());
      expect(c.read(coloniasRepositoryProvider), isA<ColoniasRepositoryHttp>());
    });

    test('CA_026_23 con una URL válida en release también usa los reales', () {
      final c = _contenedor(url: 'https://api.knock.test', release: true);
      expect(c.read(perfilRepositoryProvider), isA<PerfilRepositoryApi>());
      expect(c.read(coloniasRepositoryProvider), isA<ColoniasRepositoryHttp>());
    });
  });
}
