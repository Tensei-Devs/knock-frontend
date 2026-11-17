// Spec 045, CA-06 y CA-07 (modo maqueta encendido): tema oscuro, inglés y
// «reducir movimiento». Cada ruta comprueba su contenido (sin la franja de ejemplo, retirada en la enmienda 2).
import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/carga_k.dart';
import 'package:app/features/maqueta/en_dict.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

/// Una ruta por función (inicio, explorar, actividad, trabajo, cuenta, buscar,
/// solicitud, mensajes, ayuda y legales, registro y verificación de técnico) y
/// un texto suyo que el diccionario de la maqueta traduce al inglés.
const _subconjunto = <(String, String)>[
  ('/inicio', 'Inicio'),
  ('/explorar', 'Pedir cotización'),
  ('/actividad', 'A domicilio'),
  ('/trabajo', 'Estás disponible hoy'),
  ('/cuenta', 'Mi casa y mi auto'),
  ('/cuenta/configuracion', 'Idioma'),
  ('/m/buscar', 'Plomería'),
  ('/m/solicitar', '¿Qué necesitas arreglar?'),
  ('/m/mensajes', 'Mensajes'),
  ('/m/aviso-privacidad', 'Aviso de privacidad'),
  ('/m/tecnico/registro', 'Continuar'),
  ('/m/tecnico/pendiente', 'Revisando tus documentos…'),
];

void main() {
  prepararPruebasDeMaqueta(
    alTerminar: () {
      idiomaIngles = false;
      ignorarEntornoDePruebas = false;
    },
  );

  group('CA_045_06 tema oscuro', () {
    for (final (ruta, texto) in _subconjunto) {
      testWidgets('CA_045_06 $ruta en oscuro: contenido', (tester) async {
        fijarPantalla(tester, tamano: tamanoMovil);
        final container = await montarApp(
          tester,
          esTecnico: true,
          maqueta: true,
        );
        await usarTema(tester, container, ThemeMode.dark);
        container.read(appRouterProvider).go(ruta);
        await asentarMaqueta(tester);
        final tema = Theme.of(tester.element(find.byType(Scaffold).first));
        expect(tema.brightness, Brightness.dark, reason: ruta);
        expect(find.textContaining(texto), findsWidgets, reason: ruta);
        // La franja «Datos de ejemplo» se retiró (spec 045, enmienda 2).
        expect(
          find.text(leerArb('es')['previaDatosDeEjemplo']!),
          findsNothing,
          reason: ruta,
        );
      });
    }
  });

  group('CA_045_06 inglés', () {
    for (final (ruta, texto) in _subconjunto) {
      testWidgets('CA_045_06 $ruta en inglés: contenido', (tester) async {
        final ingles = diccionarioEn[texto];
        expect(
          ingles,
          isNotNull,
          reason: '«$texto» debe estar en el diccionario de la maqueta',
        );
        fijarPantalla(tester, tamano: tamanoMovil);
        final container = await montarApp(
          tester,
          esTecnico: true,
          maqueta: true,
        );
        container
            .read(preferenciasProvider.notifier)
            .cambiarIdioma(const Locale('en'));
        await tester.pumpAndSettle();
        container.read(appRouterProvider).go(ruta);
        await asentarMaqueta(tester);
        expect(find.textContaining(ingles!), findsWidgets, reason: ruta);
        // La franja «Datos de ejemplo» se retiró (spec 045, enmienda 2).
        expect(
          find.text(leerArb('en')['previaDatosDeEjemplo']!),
          findsNothing,
          reason: ruta,
        );
      });
    }
  });

  group('CA_045_07 reducir movimiento', () {
    Future<void> montarCarga(
      WidgetTester tester, {
      required bool reducir,
    }) async {
      ignorarEntornoDePruebas = true;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reducir),
            child: const Scaffold(
              body: CargaK(tipo: TipoCarga.puntos, size: 44),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('CA_045_07 sin el ajuste, la espera sí se anima', (
      tester,
    ) async {
      await montarCarga(tester, reducir: false);
      final lottie = tester.widget<Lottie>(find.byType(Lottie));
      expect(lottie.animate, isTrue);
      expect(lottie.controller, isNull);
    });

    testWidgets(
      'CA_045_07 con el ajuste, la espera queda en un fotograma fijo',
      (tester) async {
        await montarCarga(tester, reducir: true);
        final lottie = tester.widget<Lottie>(find.byType(Lottie));
        expect(lottie.animate, isFalse);
        final fijo = lottie.controller! as AlwaysStoppedAnimation<double>;
        expect(fijo.value, TipoCarga.puntos.poster);
        // El tiempo pasa y el fotograma no cambia.
        await tester.pump(const Duration(seconds: 2));
        final despues = tester.widget<Lottie>(find.byType(Lottie));
        expect(
          (despues.controller! as AlwaysStoppedAnimation<double>).value,
          TipoCarga.puntos.poster,
        );
      },
    );

    testWidgets('CA_045_07 los mensajes rotativos no se desvanecen', (
      tester,
    ) async {
      ignorarEntornoDePruebas = true;
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: MensajesRotativos([
                'Uno',
                'Dos',
              ], cada: Duration(seconds: 1)),
            ),
          ),
        ),
      );
      expect(find.text('Uno'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      // Cambia el texto de golpe: sin transición no queda el anterior a medias.
      expect(find.text('Dos'), findsOneWidget);
      expect(find.text('Uno'), findsNothing);
    });

    testWidgets('CA_045_07 la app en modo maqueta con el ajuste del sistema '
        'muestra las esperas quietas', (tester) async {
      ignorarEntornoDePruebas = true;
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      fijarPantalla(tester, tamano: tamanoMovil);
      final container = await montarApp(
        tester,
        esTecnico: false,
        maqueta: true,
      );
      container.read(appRouterProvider).go('/m/enviada/j1');
      await asentarMaqueta(tester);
      final lotties = find.byType(Lottie);
      expect(lotties, findsWidgets, reason: 'la pantalla tiene una espera');
      for (final l in tester.widgetList<Lottie>(lotties)) {
        expect(l.animate, isFalse);
      }
    });
  });
}
