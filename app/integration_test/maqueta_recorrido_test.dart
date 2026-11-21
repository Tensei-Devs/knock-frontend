import 'package:app/main.dart' as knock;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'soporte/entrada_ficticia.dart';

/// Recorrido corto de la maqueta (spec 045) en teléfono físico, con la
/// bandera por defecto (sin `--dart-define=MODO_MAQUETA=false`):
/// `cd app && flutter test integration_test/maqueta_recorrido_test.dart -d <id>`.
///
/// Borra la sesión guardada del dispositivo.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder enBarra(String etiqueta) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(etiqueta),
  );

  Future<void> tocar(WidgetTester tester, Finder f) async {
    final objetivo = f.first;
    await tester.ensureVisible(objetivo);
    await tester.tap(objetivo);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'TC-KNOCK-293-MAQ-01 recorre previa, entrada, pestañas y cuenta',
    (tester) async {
      await sinSesionGuardada();
      await knock.arrancar(overrides: entradaFicticia);
      await tester.pumpAndSettle();

      // Previa sin sesión: título de la barra y botón «Entrar», sin barra inferior.
      expect(find.text('Inicio'), findsWidgets);
      expect(find.byType(NavigationBar), findsNothing);
      await tocar(tester, find.text('Entrar'));

      // Entrada con celular y código (cualquier código de 6 números).
      expect(find.text('Entra con tu celular'), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, '5512345678');
      await tester.pumpAndSettle();
      await tocar(tester, find.text('Enviarme el código'));
      expect(find.text('Escribe el código'), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.pumpAndSettle();
      // La previa sigue en la pila: solo el botón del código se puede tocar.
      await tocar(tester, find.text('Entrar').hitTestable());

      // Con sesión: barra inferior de cliente (4 pestañas, sin Trabajo).
      expect(find.byType(NavigationDestination), findsNWidgets(4));
      expect(enBarra('Trabajo'), findsNothing);

      for (final etiqueta in ['Explorar', 'Actividad', 'Inicio']) {
        await tocar(tester, enBarra(etiqueta));
        expect(find.text(etiqueta), findsWidgets, reason: etiqueta);
      }

      // Mi cuenta → Configuración → Aviso de privacidad.
      await tocar(tester, enBarra('Mi cuenta'));
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
