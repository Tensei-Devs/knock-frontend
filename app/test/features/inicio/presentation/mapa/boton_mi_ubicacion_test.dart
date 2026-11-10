import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/mapa/boton_mi_ubicacion.dart';
import 'package:app/features/inicio/presentation/mapa/mi_ubicacion_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes_ubicacion.dart';

Future<void> _montar(
  WidgetTester tester, {
  required UbicacionFalsa ubicacion,
  required CamaraMapa? camara,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [ubicacionRepositoryProvider.overrideWithValue(ubicacion)],
      child: MaterialApp(
        home: Scaffold(
          body: const Center(child: Text('mapa')),
          floatingActionButton: BotonMiUbicacion(camara: camara),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder get _boton => find.byTooltip(BotonMiUbicacion.etiqueta);

const _sinPermiso = 'Sin permiso de ubicación; puedes seguir usando el mapa.';

void main() {
  testWidgets('TC-TT-MOB-04-04 el permiso se pide solo al tocar Mi ubicación', (
    tester,
  ) async {
    final ubicacion = UbicacionFalsa(
      const Concedida(latitud: 20.07, longitud: -99.35),
    );
    final camara = CamaraFalsa();
    await _montar(tester, ubicacion: ubicacion, camara: camara);

    expect(_boton, findsOneWidget);
    expect(ubicacion.llamadas, 0, reason: 'no se pide al abrir');
    expect(camara.movimientos, isEmpty);

    await tester.tap(_boton);
    await tester.pumpAndSettle();

    expect(ubicacion.llamadas, 1);
    expect(camara.movimientos, [(20.07, -99.35)]);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets(
    'TC-TT-MOB-04-04 sin mapa listo el botón está deshabilitado y no pide nada',
    (tester) async {
      final ubicacion = UbicacionFalsa(
        const Concedida(latitud: 20.07, longitud: -99.35),
      );
      await _montar(tester, ubicacion: ubicacion, camara: null);

      await tester.tap(_boton);
      await tester.pumpAndSettle();

      expect(ubicacion.llamadas, 0);
    },
  );

  testWidgets('TC-TT-MOB-04-05 muestra el aviso cuando se niega el permiso', (
    tester,
  ) async {
    final ubicacion = UbicacionFalsa(const Denegada());
    final camara = CamaraFalsa();
    await _montar(tester, ubicacion: ubicacion, camara: camara);

    await tester.tap(_boton);
    await tester.pumpAndSettle();

    expect(find.text(_sinPermiso), findsOneWidget);
    expect(find.text(BotonMiUbicacion.abrirAjustes), findsNothing);
    expect(camara.movimientos, isEmpty);
    expect(find.text('mapa'), findsOneWidget, reason: 'el mapa sigue');
    expect(tester.takeException(), isNull);

    // Otro toque con el mismo resultado vuelve a avisar.
    ScaffoldMessenger.of(tester.element(find.text('mapa')))
        .removeCurrentSnackBar();
    await tester.pumpAndSettle();
    await tester.tap(_boton);
    await tester.pumpAndSettle();
    expect(ubicacion.llamadas, 2);
    expect(find.text(_sinPermiso), findsOneWidget);
  });

  testWidgets('TC-TT-MOB-04-05 negado para siempre ofrece abrir ajustes', (
    tester,
  ) async {
    final ubicacion = UbicacionFalsa(const DenegadaParaSiempre());
    final camara = CamaraFalsa();
    await _montar(tester, ubicacion: ubicacion, camara: camara);

    await tester.tap(_boton);
    await tester.pumpAndSettle();

    expect(find.text(_sinPermiso), findsOneWidget);
    await tester.tap(find.text(BotonMiUbicacion.abrirAjustes));
    await tester.pumpAndSettle();

    expect(ubicacion.ajustesAbiertos, 1);
    expect(camara.movimientos, isEmpty);
  });

  testWidgets(
    'TC-TT-MOB-04-05 con el servicio apagado pide activar la ubicación',
    (tester) async {
      final ubicacion = UbicacionFalsa(const ServicioDesactivado());
      final camara = CamaraFalsa();
      await _montar(tester, ubicacion: ubicacion, camara: camara);

      await tester.tap(_boton);
      await tester.pumpAndSettle();

      expect(find.text('Activa la ubicación del teléfono.'), findsOneWidget);
      expect(find.text(BotonMiUbicacion.abrirAjustes), findsNothing);
      expect(camara.movimientos, isEmpty);
    },
  );

  testWidgets(
    'TC-TT-MOB-04-05 el botón cumple tamaño táctil y etiqueta (A11Y)',
    (tester) async {
      final semantica = tester.ensureSemantics();
      await _montar(
        tester,
        ubicacion: UbicacionFalsa(const Denegada()),
        camara: CamaraFalsa(),
      );

      expect(find.bySemanticsLabel(BotonMiUbicacion.etiqueta), findsWidgets);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      semantica.dispose();
    },
  );
}
