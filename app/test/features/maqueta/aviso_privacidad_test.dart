// KNOCK-289: el aviso completo de la maqueta no puede llevar marcadores sin
// llenar y debe nombrar al responsable y su domicilio, tal como los publica la
// landing (`landing/privacidad/index.html`, sección «Responsable»).
import 'package:app/core/router/app_router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('KNOCK-289 el aviso completo no trae marcadores y nombra al '
      'responsable', (tester) async {
    fijarPantalla(tester, tamano: tamanoMovil);
    final container = await montarApp(tester, esTecnico: false, maqueta: true);
    container.read(appRouterProvider).go('/m/aviso-privacidad');
    await asentarMaqueta(tester);

    await tester.tap(find.text('Leer el aviso completo'));
    await asentarMaqueta(tester);

    final texto = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? t.textSpan?.toPlainText() ?? '')
        .join('\n');

    final marcador = RegExp(r'\[[A-ZÁÉÍÓÚÑ ]{3,}\]');
    expect(
      marcador.allMatches(texto).map((m) => m.group(0)).toList(),
      isEmpty,
      reason: 'el aviso no puede mostrar marcadores sin llenar',
    );
    expect(texto, contains('José Julián Hernández Hernández'));
    expect(
      texto,
      contains(
        'Alonso de Borja 92, colonia Aviación, C.P. 42506, Actopan, Hidalgo',
      ),
    );
  });
}
