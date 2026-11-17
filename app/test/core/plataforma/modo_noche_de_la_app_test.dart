// El mapa nativo se oscurece con el modo de noche de Android y no con el tema
// de Flutter: con el teléfono en oscuro y la app en «Claro», el mapa se veía
// oscuro. La app le dice a Android su propio modo de noche según «Apariencia».
import 'package:app/core/plataforma/modo_noche_de_la_app.dart';
import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Falso implements ModoNocheDeLaApp {
  final modos = <ThemeMode>[];

  @override
  Future<void> fijar(ThemeMode modo) async => modos.add(modo);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('código que se manda a Android', () {
    test('sistema 0, claro 1 y oscuro 2', () {
      expect(ModoNocheDeLaAppAndroid.codigo(ThemeMode.system), 0);
      expect(ModoNocheDeLaAppAndroid.codigo(ThemeMode.light), 1);
      expect(ModoNocheDeLaAppAndroid.codigo(ThemeMode.dark), 2);
    });

    test('usa el canal knock/pantalla con el método modoNoche', () async {
      const canal = MethodChannel('knock/pantalla');
      final llamadas = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(canal, (llamada) async {
            llamadas.add(llamada);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(canal, null),
      );

      await const ModoNocheDeLaAppAndroid().fijar(ThemeMode.light);

      expect(llamadas.single.method, 'modoNoche');
      expect(llamadas.single.arguments, 1);
    });

    test('sin canal (pruebas o iOS) no lanza', () async {
      await const ModoNocheDeLaAppAndroid().fijar(ThemeMode.dark);
    });
  });

  group('sincronización con «Apariencia»', () {
    test('al arrancar y en cada cambio avisa el modo vigente', () {
      final falso = _Falso();
      final container = ProviderContainer(
        overrides: [modoNocheDeLaAppProvider.overrideWithValue(falso)],
      );
      addTearDown(container.dispose);

      container.listen(modoNocheSincronizadoProvider, (_, _) {});
      expect(falso.modos, [ThemeMode.system]);

      container
          .read(preferenciasProvider.notifier)
          .cambiarTema(ThemeMode.light);
      container.read(modoNocheSincronizadoProvider);
      expect(falso.modos, [ThemeMode.system, ThemeMode.light]);

      container.read(preferenciasProvider.notifier).cambiarTema(ThemeMode.dark);
      container.read(modoNocheSincronizadoProvider);
      expect(falso.modos.last, ThemeMode.dark);
    });
  });
}
