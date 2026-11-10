import 'package:app/core/router/rutas.dart';
import 'package:flutter_test/flutter_test.dart';

import '../soporte/montar_app.dart';

void main() {
  testWidgets('CA_001_03 tocar una pestaña navega a su función', (
    tester,
  ) async {
    final container = await montarApp(tester, esTecnico: true);

    const destinos = {
      'Explorar': Rutas.explorar,
      'Actividad': Rutas.actividad,
      'Trabajo': Rutas.trabajo,
      'Mi cuenta': Rutas.cuenta,
      'Inicio': Rutas.inicio,
    };
    for (final MapEntry(key: etiqueta, value: ruta) in destinos.entries) {
      await tester.tap(enLaBarra(etiqueta));
      await tester.pumpAndSettle();
      expect(ubicacion(container), ruta, reason: etiqueta);
      expect(enElTitulo(etiqueta), findsOneWidget, reason: etiqueta);
    }
  });
}
