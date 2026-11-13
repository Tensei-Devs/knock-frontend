import 'package:app/core/tema/tema.dart';
import 'package:app/features/actividad/presentation/pasos/paso_cuando_donde.dart';
import 'package:app/features/actividad/presentation/pasos/paso_descripcion_fotos.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/features/actividad/presentation/solicitud_detalle_screen.dart';
import 'package:app/features/actividad/presentation/solicitud_nueva_screen.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/accesibilidad.dart';
import '../../../soporte/pantalla_maqueta.dart';
import '../../../soporte/solicitud_falsa.dart';

/// Monta [pantalla] con los dobles de la spec 015 y devuelve el contenedor.
Future<ProviderContainer> _montar(
  WidgetTester tester,
  Widget pantalla, {
  SolicitudesFalsas? solicitudes,
  BorradorFalso? borrador,
}) async {
  final contenedor = ProviderContainer(
    overrides: dobles(
      solicitudes: solicitudes ?? SolicitudesFalsas(),
      borrador: borrador ?? BorradorFalso(),
    ),
  );
  addTearDown(contenedor.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: contenedor,
      child: MaterialApp(
        theme: temaClaro,
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: pantalla,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return contenedor;
}

SolicitudController _control(ProviderContainer c) =>
    c.read(solicitudControllerProvider.notifier);

void main() {
  group('CA_015_03 selector de fotos', () {
    testWidgets(
      'CA_015_03 sin fotos explica que falta una al intentar avanzar',
      (tester) async {
        final c = await _montar(
          tester,
          const SolicitudNuevaScreen(oficioClave: 'plo'),
        );
        _control(c).cambiarDescripcion('Gotea la llave del baño');
        await tester.tap(find.text('Siguiente'));
        await tester.pumpAndSettle();

        expect(
          find.text('Agrega al menos una foto: le dice al técnico qué llevar'),
          findsOneWidget,
        );
        expect(find.byType(PasoDescripcionFotos), findsOneWidget);
      },
    );

    testWidgets(
      'CA_015_03 con 5 fotos se deshabilitan los botones de agregar',
      (tester) async {
        final c = await _montar(
          tester,
          const SolicitudNuevaScreen(oficioClave: 'plo'),
        );
        await _control(c).elegirFotos();
        await tester.pumpAndSettle();

        final tomar = tester.widget<OutlinedButton>(
          find.ancestor(
            of: find.text('Tomar foto'),
            matching: find.byWidgetPredicate((w) => w is OutlinedButton),
          ),
        );
        expect(tomar.onPressed, isNull);
        expect(find.text('Ya tienes 5 fotos, el máximo.'), findsOneWidget);
        expect(find.bySemanticsLabel('Foto 5 de 5'), findsOneWidget);
      },
    );
  });

  group('CA_015_05 y CA_015_17 paso «Cuándo y dónde»', () {
    Future<ProviderContainer> alPaso3(
      WidgetTester tester,
      String oficio,
    ) async {
      final c = await _montar(
        tester,
        SolicitudNuevaScreen(oficioClave: oficio),
      );
      _control(c).cambiarDescripcion('Algo que describir bien');
      await _control(c).tomarFoto();
      _control(c).avanzar();
      await tester.pumpAndSettle();
      expect(find.byType(PasoCuandoDonde), findsOneWidget);
      return c;
    }

    testWidgets('CA_015_05 en taller no pide dirección y avisa', (
      tester,
    ) async {
      await alPaso3(tester, 'mec');

      expect(find.text('Llevarás tu auto al taller'), findsOneWidget);
      expect(find.text('Calle y número'), findsNothing);
    });

    testWidgets('CA_015_17 a domicilio pide calle y número y no envía con 7', (
      tester,
    ) async {
      final solicitudes = SolicitudesFalsas();
      final c = await _montar(
        tester,
        const SolicitudNuevaScreen(oficioClave: 'plo'),
        solicitudes: solicitudes,
      );
      _control(c).cambiarDescripcion('Algo que describir bien');
      await _control(c).tomarFoto();
      _control(c).avanzar();
      await tester.pumpAndSettle();

      expect(find.text('Calle y número'), findsOneWidget);
      await tester.tap(find.text('Hoy'));
      await tester.tap(find.text('Tarde'));
      await tester.enterText(find.byType(TextField), 'a' * 7);
      await tester.tap(find.text('Enviar solicitud'));
      await tester.pumpAndSettle();

      expect(find.text('Escribe al menos 8 caracteres.'), findsOneWidget);
      expect(solicitudes.creaciones, isEmpty);
    });

    testWidgets('CA_015_04 se ofrecen seis días empezando por «Hoy»', (
      tester,
    ) async {
      await alPaso3(tester, 'plo');

      final chips = find.byType(ChoiceChip);
      // Seis días y tres franjas.
      expect(chips, findsNWidgets(9));
      expect(find.text('Hoy'), findsOneWidget);
    });
  });

  group('CA_015_13 solicitud ajena o inexistente', () {
    testWidgets('CA_015_13 el detalle dice que ya no está disponible', (
      tester,
    ) async {
      await _montar(tester, const SolicitudDetalleScreen(id: 'cualquier-otro'));

      expect(
        find.text('Esta solicitud ya no está disponible.'),
        findsOneWidget,
      );
      expect(find.text('Volver a Actividad'), findsOneWidget);
    });

    testWidgets('CA_015_01 el detalle propio muestra el estado Enviada', (
      tester,
    ) async {
      await _montar(
        tester,
        const SolicitudDetalleScreen(id: 'bbbbbbbbbbbbbbbbbbbbbbbb'),
      );

      expect(find.text('Enviada'), findsOneWidget);
      expect(find.text('Plomería'), findsOneWidget);
      expect(find.text('2 fotos'), findsOneWidget);
    });
  });

  group('CA_015_16 accesibilidad del flujo', () {
    for (final (nombre, oficio, paso) in [
      ('paso 1', null, 0),
      ('paso 2', 'plo', 1),
      ('paso 3', 'plo', 2),
    ]) {
      testWidgets('CA_015_16 $nombre con etiquetas, 48 dp y texto al 200 %', (
        tester,
      ) async {
        fijarPantalla(tester, escalaDeTexto: 2);
        final semantica = tester.ensureSemantics();
        final c = await _montar(
          tester,
          SolicitudNuevaScreen(oficioClave: oficio),
        );
        if (paso == 2) {
          _control(c).cambiarDescripcion('Algo que describir bien');
          await _control(c).tomarFoto();
          _control(c).avanzar();
          await tester.pumpAndSettle();
        }

        await expectAccesible(tester);
        expect(tester.takeException(), isNull);
        semantica.dispose();
      });
    }
  });
}
