import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'soporte/arranque_e2e.dart';
import 'soporte/entrar.dart';

/// Recorrido corto de la maqueta (spec 045) en teléfono físico, con la
/// bandera por defecto (sin `--dart-define=MODO_MAQUETA=false`):
/// `cd app && flutter test integration_test/maqueta_recorrido_test.dart -d <id>`.
///
/// Borra la sesión y las preferencias guardadas de la app en el dispositivo.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'TC-KNOCK-293-MAQ-01 recorre previa, entrada, pestañas y cuenta',
    (tester) async {
      await arrancarE2e(tester);

      // Previa sin sesión: título de la barra y botón «Entrar», sin barra inferior.
      expect(find.text('Inicio'), findsWidgets);
      expect(find.byType(NavigationBar), findsNothing);

      // Entrada con celular y código (cualquier código de 6 números).
      await entrarEnLaMaqueta(tester);

      // Con sesión: barra inferior de cliente (4 pestañas, sin Trabajo).
      expect(find.byType(NavigationDestination), findsNWidgets(4));
      expect(enLaBarra('Trabajo'), findsNothing);

      for (final etiqueta in ['Explorar', 'Actividad', 'Inicio']) {
        await tocar(tester, enLaBarra(etiqueta));
        expect(find.text(etiqueta), findsWidgets, reason: etiqueta);
      }

      // Mi cuenta → Configuración → Aviso de privacidad.
      await tocar(tester, enLaBarra('Mi cuenta'));
      expect(find.text('Mi cuenta'), findsWidgets);
      expect(find.text('Centro de ayuda'), findsOneWidget);
      await tocar(tester, find.text('Configuración'));
      expect(find.text('Privacidad y seguridad'), findsOneWidget);
      await tocar(tester, find.text('Aviso de privacidad'));
      expect(find.text('En pocas palabras'), findsOneWidget);
      expect(find.text('Nunca vendemos tus datos.'), findsOneWidget);
      expect(find.text('Leer el aviso completo'), findsOneWidget);
    },
  );
}
