import 'dart:io';

import 'package:app/core/tema/tema.dart';
import 'package:app/features/actividad/data/solicitud_repository_de_prueba.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/presentation/widgets/tarjeta_cotizacion.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/accesibilidad.dart';
import '../../../soporte/montar_comparacion.dart';
import '../../../soporte/pantalla_maqueta.dart';
import '../../../soporte/solicitud_falsa.dart';

const _id = 'bbbbbbbbbbbbbbbbbbbbbbbb';

Future<void> _montar(
  WidgetTester tester,
  SolicitudesFalsas solicitudes, {
  String id = _id,
  bool visitaDisponible = false,
}) async {
  await montarComparacion(
    tester,
    solicitudes,
    id: id,
    visitaDisponible: visitaDisponible,
  );
}

void main() {
  late SolicitudesFalsas solicitudes;

  setUp(() => solicitudes = SolicitudesFalsas());

  group('CA_015_07 tarjetas de la comparación', () {
    testWidgets('CA_015_07 muestra precio, tope, qué cubre, etiquetas y nota', (
      tester,
    ) async {
      solicitudes.comparacion = ResultadoComparacion(
        cotizaciones: [
          cotizacionDePrueba(
            'c1',
            nombre: 'Técnico Uno',
            etiquetas: const {
              EtiquetaCotizacion.verificado,
              EtiquetaCotizacion.mejorPrecio,
            },
          ),
        ],
        totalCotizaciones: 1,
        tiposMixtos: false,
        puedeElegir: true,
      );

      await _montar(tester, solicitudes);

      expect(find.text('Técnico Uno'), findsOneWidget);
      expect(find.text(r'$1,000'), findsOneWidget);
      expect(find.text(r'Hasta $1,100'), findsOneWidget);
      expect(
        find.text('Si el precio sube, el técnico te pedirá tu aprobación'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Arreglo completo, mano de obra incluida, refacciones aparte',
        ),
        findsOneWidget,
      );
      expect(find.text('Verificado'), findsOneWidget);
      expect(find.text('Mejor precio'), findsOneWidget);
      expect(find.text('Nota de prueba'), findsOneWidget);
      expect(find.text('4.5 de 5'), findsOneWidget);
      expect(find.text('Verificación basico'), findsOneWidget);
      expect(find.textContaining('Te mostramos'), findsNothing);
    });

    testWidgets('CA_015_07 con 7 cotizaciones avisa «Te mostramos 5 de 7»', (
      tester,
    ) async {
      solicitudes.comparacion = ResultadoComparacion(
        cotizaciones: [for (var i = 0; i < 5; i++) cotizacionDePrueba('c$i')],
        totalCotizaciones: 7,
        tiposMixtos: false,
        puedeElegir: true,
      );

      await _montar(tester, solicitudes);

      expect(find.text('Te mostramos 5 de 7'), findsOneWidget);
    });

    testWidgets('CA_015_07 con tipos mixtos avisa que cubren cosas distintas', (
      tester,
    ) async {
      solicitudes.comparacion = ResultadoComparacion(
        cotizaciones: [
          cotizacionDePrueba('c1'),
          cotizacionDePrueba('c2', tipo: TipoPrecio.rango, tope: 1250),
          cotizacionDePrueba('c3', tipo: TipoPrecio.visita, tope: 150),
        ],
        totalCotizaciones: 3,
        tiposMixtos: true,
        puedeElegir: true,
      );

      await _montar(tester, solicitudes);

      expect(
        find.text(
          'Las cotizaciones cubren cosas distintas: revisa qué incluye cada una',
        ),
        findsOneWidget,
      );
      expect(find.text(r'De $600 a $1,000'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text(r'Visita: $1,000'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text(r'Visita: $1,000'), findsOneWidget);
    });
  });

  group('CA_015_08 el orden lo decide el servidor', () {
    testWidgets('CA_015_08 cada chip pide su `orden` y respeta lo recibido', (
      tester,
    ) async {
      // El servidor manda primero la más cara: la app no la reordena.
      solicitudes.comparacion = ResultadoComparacion(
        cotizaciones: [
          cotizacionDePrueba('c1', nombre: 'Cara', tope: 2000),
          cotizacionDePrueba('c2', nombre: 'Barata', tope: 500),
        ],
        totalCotizaciones: 2,
        tiposMixtos: false,
        puedeElegir: true,
      );
      await _montar(tester, solicitudes);

      for (final (chip, orden) in [
        ('Menor precio', OrdenCotizaciones.precio),
        ('Mejor calificadas', OrdenCotizaciones.calificacion),
        ('Más pronto', OrdenCotizaciones.pronto),
        ('Recomendadas', OrdenCotizaciones.recomendadas),
      ]) {
        await tester.ensureVisible(find.text(chip));
        await tester.pumpAndSettle();
        await tester.tap(find.text(chip));
        await tester.pumpAndSettle();
        expect(solicitudes.ordenesPedidos.last, orden);
      }

      expect(solicitudes.ordenesPedidos.first, OrdenCotizaciones.recomendadas);
      expect(
        tester.getTopLeft(find.text('Cara')).dy,
        lessThan(tester.getTopLeft(find.text('Barata')).dy),
      );
    });
  });

  group('CA_015_09 cuando no se puede elegir', () {
    for (final (motivo, texto) in [
      (
        MotivoSinEleccion.vencida,
        'Esta solicitud venció. Puedes pedir una nueva.',
      ),
      (MotivoSinEleccion.cancelada, 'Esta solicitud se canceló.'),
    ]) {
      testWidgets('CA_015_09 muestra el motivo ${motivo.valor}', (
        tester,
      ) async {
        solicitudes.comparacion = ResultadoComparacion(
          cotizaciones: [cotizacionDePrueba('c1')],
          totalCotizaciones: 1,
          tiposMixtos: false,
          puedeElegir: false,
          motivo: motivo,
        );

        await _montar(tester, solicitudes);

        expect(find.text(texto), findsOneWidget);
        expect(find.text('Elegir'), findsNothing);
      });
    }

    testWidgets('CA_015_09 sin cotizaciones explica que aún no llegan', (
      tester,
    ) async {
      await _montar(tester, solicitudes);

      expect(
        find.text(
          'Todavía no hay cotizaciones. Te avisaremos cuando llegue la primera.',
        ),
        findsOneWidget,
      );
    });

    ResultadoComparacion yaElegida() => ResultadoComparacion(
      cotizaciones: [cotizacionDePrueba('c1')],
      totalCotizaciones: 1,
      tiposMixtos: false,
      puedeElegir: false,
      motivo: MotivoSinEleccion.yaElegida,
      visitaId: 'v' * 24,
    );

    testWidgets('CA_015_09 ya elegida con visita disponible: «Ver mi visita»', (
      tester,
    ) async {
      solicitudes.comparacion = yaElegida();

      await _montar(tester, solicitudes, visitaDisponible: true);

      expect(
        find.text('Ya elegiste una cotización para esta solicitud.'),
        findsOneWidget,
      );
      expect(find.text('Ver mi visita'), findsOneWidget);
    });

    testWidgets(
      'CA_015_09 sin la pantalla de visita no hay botón sin destino',
      (tester) async {
        solicitudes.comparacion = yaElegida();

        await _montar(tester, solicitudes);

        expect(
          find.text('Ya elegiste una cotización para esta solicitud.'),
          findsOneWidget,
        );
        expect(find.text('Ver mi visita'), findsNothing);
      },
    );

    testWidgets(
      'CA_015_13 una solicitud ajena muestra «ya no está disponible»',
      (tester) async {
        await _montar(tester, solicitudes, id: 'otra');

        expect(
          find.text('Esta solicitud ya no está disponible.'),
          findsOneWidget,
        );
      },
    );
  });

  group('CA_015_10 sin contacto antes de elegir', () {
    testWidgets('CA_015_10 la tarjeta no muestra teléfono ni dirección', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: temaClaro,
          locale: const Locale('es'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TarjetaCotizacion(
                cotizacion: cotizacionDePrueba('c1'),
                dominiosDeFotos: const {},
              ),
            ),
          ),
        ),
      );

      final textos = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data ?? '')
          .join(' | ');
      expect(textos, isNot(matches(RegExp(r'\d{10}'))));
      expect(textos.toLowerCase(), isNot(contains('calle')));
      expect(textos.toLowerCase(), isNot(contains('whatsapp')));
      expect(find.byIcon(Icons.phone), findsNothing);
    });

    test('CA_015_10 el modelo de la cotización no tiene contacto', () {
      // Lee los campos de `TecnicoResumen` y `Cotizacion` en el código: si
      // alguien les agrega teléfono, WhatsApp o dirección, esta prueba falla
      // (el contacto solo existe en `TecnicoElegido`, después de elegir).
      final fuente = File('lib/features/actividad/domain/cotizacion.dart')
          .readAsStringSync();
      for (final clase in ['TecnicoResumen', 'Cotizacion']) {
        final cuerpo = RegExp(
          'final class $clase '
          r'\{(.*?)\n\}',
          dotAll: true,
        ).firstMatch(fuente)?.group(1);
        expect(cuerpo, isNotNull, reason: 'no encontré $clase');
        final campos = RegExp(r'final [\w<>?, ]+ (\w+);')
            .allMatches(cuerpo!)
            .map((m) => m.group(1)!.toLowerCase())
            .toList();
        expect(campos, isNotEmpty, reason: '$clase sin campos');
        for (final prohibido in [
          'telefono',
          'whatsapp',
          'direccion',
          'celular',
        ]) {
          expect(
            campos.where((c) => c.contains(prohibido)),
            isEmpty,
            reason: '$clase tiene un campo de contacto',
          );
        }
      }
    });
  });

  group('CA_015_16 accesibilidad de la comparación', () {
    testWidgets('CA_015_16 etiquetas, 48 dp y texto al 200 %', (tester) async {
      fijarPantalla(tester, escalaDeTexto: 2);
      final semantica = tester.ensureSemantics();
      solicitudes.comparacion = ResultadoComparacion(
        cotizaciones: [
          cotizacionDePrueba(
            'c1',
            etiquetas: const {EtiquetaCotizacion.puedeIrMasPronto},
          ),
        ],
        totalCotizaciones: 6,
        tiposMixtos: true,
        puedeElegir: true,
      );

      await _montar(tester, solicitudes);

      await expectAccesible(tester);
      expect(tester.takeException(), isNull);
      semantica.dispose();
    });
  });

  group('doble del servidor (backend 021 R-04 a R-06)', () {
    final semillas = etiquetarComoElServidor([
      cotizacionDePrueba('fijo', tope: 990, calificacion: 4.8),
      cotizacionDePrueba(
        'rango',
        tipo: TipoPrecio.rango,
        tope: 1250,
        verificado: false,
      ),
      cotizacionDePrueba('visita', tipo: TipoPrecio.visita, tope: 150),
    ]);

    test('CA_015_08 «Menor precio» deja las visitas al final', () {
      final ids = ordenarComoElServidor(
        semillas,
        OrdenCotizaciones.precio,
      ).map((c) => c.id);
      expect(ids, ['fijo', 'rango', 'visita']);
    });

    test('CA_015_07 «mejor_precio» nunca va a una visita', () {
      final mejor = semillas.where(
        (c) => c.etiquetas.contains(EtiquetaCotizacion.mejorPrecio),
      );
      expect(mejor.map((c) => c.id), ['fijo']);
    });
  });
}
