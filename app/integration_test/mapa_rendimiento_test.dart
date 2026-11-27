import 'package:app/main_spike_mapa.dart' as spike;
import 'package:flutter/foundation.dart' show kProfileMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';

/// Medición de fluidez del spike TT-MOB-04 (TC-01). Solo tiene sentido en
/// modo *profile* en un Android **físico** con la clave de Maps en
/// `android/local.properties`:
///
/// ```bash
/// cd app
/// flutter drive --profile --driver=test_driver/perf_driver.dart \
///   --target=integration_test/mapa_rendimiento_test.dart
/// ```
///
/// Con `flutter test` (modo *debug*) se marca como omitida: la traza necesita
/// `flutter drive --profile`.
///
/// El resumen queda en `build/mapa_rendimiento.timeline_summary.json`.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TC-TT-MOB-04-01 el mapa con 50 pines se mueve fluido', (
    tester,
  ) async {
    spike.main();
    // El mapa nativo carga fuera de Flutter: se espera a que se pinte.
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));

    final mapa = find.byType(GoogleMap);
    expect(mapa, findsOneWidget);

    await binding.traceAction(() async {
      // Arrastres en cuatro direcciones (~4 s).
      for (final desplazamiento in const [
        Offset(-300, 0),
        Offset(0, -300),
        Offset(300, 0),
        Offset(0, 300),
      ]) {
        await tester.timedDrag(
          mapa,
          desplazamiento,
          const Duration(milliseconds: 800),
        );
        await tester.pump(const Duration(milliseconds: 200));
      }

      // Alejar (los pines se agrupan) y acercar (se separan), ~6 s.
      await _pellizcar(tester, mapa, separar: false);
      await tester.pump(const Duration(seconds: 1));
      await _pellizcar(tester, mapa, separar: true);
      await tester.pump(const Duration(seconds: 1));
      await _pellizcar(tester, mapa, separar: false);
      await tester.pump(const Duration(seconds: 1));
    }, reportKey: 'mapa_rendimiento');
  }, skip: !kProfileMode);
}

/// Gesto de dos dedos: [separar] acerca el zoom; si no, lo aleja.
Future<void> _pellizcar(
  WidgetTester tester,
  Finder mapa, {
  required bool separar,
}) async {
  const pasos = 30;
  const paso = Offset(6, 0);
  final centro = tester.getCenter(mapa);
  final inicio = separar ? const Offset(40, 0) : const Offset(220, 0);
  final dedo1 = await tester.startGesture(centro - inicio, pointer: 1);
  final dedo2 = await tester.startGesture(centro + inicio, pointer: 2);
  for (var i = 0; i < pasos; i++) {
    await dedo1.moveBy(separar ? -paso : paso);
    await dedo2.moveBy(separar ? paso : -paso);
    await tester.pump(const Duration(milliseconds: 16));
  }
  await dedo1.up();
  await dedo2.up();
}
