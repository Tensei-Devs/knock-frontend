// EXPERIMENTO (spec 045): monta cada ruta de la maqueta y anota qué se ve.
import 'package:app/core/config/modo_maqueta.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/mapa_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';

Future<void> _cargarNunito() async {
  final f = FontLoader('Nunito');
  for (final w in [
    'Regular',
    'Medium',
    'SemiBold',
    'Bold',
    'ExtraBold',
    'Black',
  ]) {
    f.addFont(rootBundle.load('assets/fonts/nunito/Nunito-$w.ttf'));
  }
  await f.load();
}

void main() {
  testWidgets('recorre las rutas de la maqueta', (tester) async {
    await _cargarNunito();
    usarMapaReal = false;
    addTearDown(() => usarMapaReal = true);
    fijarPantalla(tester, tamano: const Size(412, 892));
    final container = await montarApp(
      tester,
      esTecnico: true,
      extra: [modoMaquetaProvider.overrideWithValue(true)],
    );
    maq.loadDemo();
    maq.pv.seedDemo();
    addTearDown(maq.resetAll);
    final router = container.read(appRouterProvider);
    final j = maq.jobs.first.id;
    final rutas = <String>[
      '/inicio',
      '/explorar',
      '/actividad',
      '/trabajo',
      '/cuenta',
      '/cuenta/configuracion',
      '/m/buscar',
      '/m/experto/rm',
      '/m/experto/rm/opiniones',
      '/m/asistente',
      '/m/solicitar',
      '/m/enviada/$j',
      '/m/comparar/$j',
      '/m/visita/j3',
      '/m/cita/j2',
      '/m/calificar/j4',
      '/m/reportar/j4',
      '/m/compartir/j3',
      '/m/mensajes',
      '/m/chat/rm',
      '/m/mi-casa',
      '/m/confianza',
      '/m/avisos',
      '/m/avisos-config',
      '/m/aviso-privacidad',
      '/m/terminos',
      '/m/privacidad',
      '/m/eliminar/1',
      '/m/eliminar/2',
      '/m/eliminado',
      '/m/ayuda?t=1',
      '/m/sin-conexion',
      '/m/tecnico/registro',
      '/m/tecnico/verificacion',
      '/m/tecnico/pendiente',
      '/m/tecnico/verificado',
      '/m/tecnico/rechazada',
      '/m/tecnico/mensajes',
      '/m/tecnico/chat/ml/r1',
      '/m/tecnico/cotizar/r1',
      '/m/tecnico/iniciar/vr1',
      '/m/tecnico/cerrar/vr1',
      '/m/tecnico/perfil',
      '/m/tecnico/reputacion',
    ];
    for (final r in rutas) {
      router.go(r);
      try {
        await tester.pumpAndSettle(
          const Duration(milliseconds: 100),
          EnginePhase.sendSemanticsUpdate,
          const Duration(seconds: 3),
        );
      } on Object {
        await tester.pump(const Duration(milliseconds: 500));
      }
      final ex = tester.takeException();
      final textos = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data ?? '')
          .where((t) => t.length > 3)
          .take(4)
          .join(' | ');
      // ignore: avoid_print
      print(
        'RUTA $r -> ${ex == null ? 'ok' : 'ERROR ${ex.toString().split('\n').first}'} :: $textos',
      );
    }
  });
}
