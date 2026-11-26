import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'soporte/arranque_e2e.dart';
import 'soporte/entrar.dart';

/// Humo de los flujos con datos de ejemplo (KNOCK-293, spec 045): sin URL de
/// API, sin SMS y sin red.
///
/// `cd app; flutter test integration_test/flujos_ejemplo_test.dart -d <id>`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'TC-KNOCK-293-MAQ-02 cliente con historial: comparar cotizaciones y '
    'confirmar la visita',
    (tester) async {
      await arrancarE2e(tester);
      await entrarEnLaMaqueta(tester);

      await tocar(tester, enLaBarra('Mi cuenta'));
      await tocar(tester, find.text('Cliente con historial de ejemplo'));
      // El aviso emergente se quita solo.
      await tester.pump(const Duration(seconds: 5));
      await tocar(tester, enLaBarra('Actividad'));
      expect(find.text('El boiler no enciende'), findsOneWidget);

      await tocar(tester, find.text('Ver y elegir'));
      await tocar(tester, find.textContaining(RegExp(r'^Elegir a ')));
      expect(find.textContaining(RegExp(r'^¿Elegir a .*\?$')), findsOneWidget);
      await tocar(tester, find.textContaining('Sí, elegir a '));
      expect(find.text('Tu código para cuando llegue'), findsOneWidget);
    },
  );
}
