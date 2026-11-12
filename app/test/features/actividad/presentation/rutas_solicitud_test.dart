import 'package:app/core/router/rutas.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/montar_app.dart';

void main() {
  testWidgets('CA_015_01 desde Actividad se abre el formulario de tres pasos', (
    tester,
  ) async {
    await montarApp(tester, esTecnico: false);
    await tester.tap(enLaBarra('Actividad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pedir cotización'));
    await tester.pumpAndSettle();

    expect(find.text('Paso 1 de 3: oficio'), findsOneWidget);
  });

  test('CA_015_01 la ruta de detalle codifica el id', () {
    expect(Rutas.solicitudDetalle('a b'), '/actividad/solicitud/a%20b');
  });
}
