import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/accesibilidad.dart';
import '../../../soporte/montar_comparacion.dart';
import '../../../soporte/pantalla_maqueta.dart';
import '../../../soporte/solicitud_falsa.dart';

const _id = 'bbbbbbbbbbbbbbbbbbbbbbbb';
const _aviso =
    'Al elegir, verás el teléfono del técnico y él verá la dirección de tu '
    'servicio. Las demás cotizaciones se cerrarán.';

Future<void> _montar(
  WidgetTester tester,
  SolicitudesFalsas solicitudes, {
  bool visitaDisponible = false,
}) async {
  solicitudes.comparacion = ResultadoComparacion(
    cotizaciones: [cotizacionDePrueba('c1', nombre: 'Técnico Uno')],
    totalCotizaciones: 1,
    tiposMixtos: false,
    puedeElegir: true,
  );
  await montarComparacion(
    tester,
    solicitudes,
    id: _id,
    visitaDisponible: visitaDisponible,
  );
}

Future<void> _abrirHoja(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Elegir'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Elegir'));
  await tester.pumpAndSettle();
}

Future<void> _confirmar(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Confirmar elección'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Confirmar elección'));
  await tester.pumpAndSettle();
}

void main() {
  late SolicitudesFalsas solicitudes;

  setUp(() => solicitudes = SolicitudesFalsas());

  group('CA_015_11 la cita y el contacto solo después de confirmar', () {
    testWidgets('CA_015_11 antes de confirmar no hay teléfono ni dirección', (
      tester,
    ) async {
      await _montar(tester, solicitudes);
      await _abrirHoja(tester);

      expect(find.text('¿Eliges a Técnico Uno?'), findsOneWidget);
      expect(find.text(_aviso), findsOneWidget);
      expect(find.textContaining('5500000001'), findsNothing);
      expect(find.textContaining('Calle de Prueba'), findsNothing);
      expect(solicitudes.elecciones, isEmpty);
    });

    testWidgets(
      'CA_015_11 al confirmar muestra la cita, el teléfono y el lugar',
      (tester) async {
        await _montar(tester, solicitudes);
        await _abrirHoja(tester);
        await _confirmar(tester);

        expect(solicitudes.elecciones, [(_id, 'c1')]);
        expect(find.text('Cita confirmada'), findsOneWidget);
        expect(find.text('Teléfono: 5500000001'), findsOneWidget);
        expect(find.text('Lugar: Calle de Prueba 123'), findsOneWidget);
        expect(find.text(r'Hasta $1,100'), findsWidgets);
        expect(find.text('Va a tu domicilio'), findsOneWidget);
        // Sin la pantalla de la visita (KNOCK-83) no hay botón sin destino.
        expect(find.text('Ver mi visita'), findsNothing);

        await tester.tap(find.text('Listo'));
        await tester.pumpAndSettle();
        expect(find.text('Cita confirmada'), findsNothing);
      },
    );

    testWidgets(
      'CA_015_11 sin contacto público explica que escribirá por chat',
      (tester) async {
        solicitudes.citaAlElegir = citaDePrueba(telefono: null);
        await _montar(tester, solicitudes);
        await _abrirHoja(tester);
        await _confirmar(tester);

        expect(
          find.text(
            'Este técnico no publicó un teléfono. Podrás escribirle por el chat '
            'cuando esté disponible',
          ),
          findsOneWidget,
        );
        expect(find.textContaining('Teléfono:'), findsNothing);
      },
    );

    testWidgets('CA_015_11 con la visita disponible aparece «Ver mi visita»', (
      tester,
    ) async {
      await _montar(tester, solicitudes, visitaDisponible: true);
      await _abrirHoja(tester);
      await _confirmar(tester);

      expect(find.text('Ver mi visita'), findsOneWidget);
    });
  });

  group('CA_015_12 un 409 al confirmar', () {
    testWidgets(
      'CA_015_12 quote_unavailable muestra su texto y no ofrece reintentar',
      (tester) async {
        solicitudes.fallasAlElegir.add(
          const EleccionRechazadaFailure(
            MotivoEleccionRechazada.cotizacionNoDisponible,
          ),
        );
        await _montar(tester, solicitudes);
        await _abrirHoja(tester);
        await _confirmar(tester);

        expect(
          find.text('Esta cotización ya no está disponible. Elige otra.'),
          findsOneWidget,
        );
        expect(find.text('Confirmar elección'), findsNothing);
        expect(find.text('Cita confirmada'), findsNothing);
        expect(solicitudes.elecciones, hasLength(1));
      },
    );

    testWidgets('CA_015_20 un 503 dice que no se confirmó y deja reintentar', (
      tester,
    ) async {
      solicitudes.fallasAlElegir.add(const ServicioNoDisponibleFailure());
      await _montar(tester, solicitudes);
      await _abrirHoja(tester);
      await _confirmar(tester);

      expect(
        find.text('No pudimos confirmar tu elección. Intenta de nuevo.'),
        findsOneWidget,
      );
      await _confirmar(tester);
      expect(solicitudes.elecciones, hasLength(2));
      expect(find.text('Cita confirmada'), findsOneWidget);
    });
  });

  testWidgets('CA_015_16 la hoja es accesible con texto al 200 %', (
    tester,
  ) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final semantica = tester.ensureSemantics();
    await _montar(tester, solicitudes);
    await _abrirHoja(tester);

    await expectAccesible(tester);
    await _confirmar(tester);
    await expectAccesible(tester);
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });
}
