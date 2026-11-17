// Preparación común de las pruebas del modo maqueta (spec 045).
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/mapa_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fuente_nunito.dart';

/// Teléfono de referencia de las pruebas de la maqueta.
const Size tamanoMovil = Size(412, 892);

/// Espera a que la pantalla se asiente sin quedarse esperando animaciones
/// que no terminan.
Future<void> asentarMaqueta(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 100),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 3),
);

/// Registra lo que toda prueba del modo maqueta necesita: la tipografía de la
/// app, el mapa de relleno y los datos de ejemplo cargados y limpios.
/// [alTerminar] restablece lo que la prueba haya cambiado.
void prepararPruebasDeMaqueta({void Function()? alTerminar}) {
  setUpAll(cargarNunito);
  setUp(() {
    usarMapaReal = false;
    maq.resetAll();
    maq.loadDemo();
    maq.pv.seedDemo();
  });
  tearDown(() {
    usarMapaReal = true;
    alTerminar?.call();
    maq.resetAll();
  });
}
