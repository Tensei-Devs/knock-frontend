import 'dart:io';

import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';

/// Datos ficticios (spec §2).
const _celular = '5512345678';
const _codigo = '123456';

/// Cuenta los clientes HTTP que se intentan crear: debe quedar en 0.
class _ContadorDeRed extends HttpOverrides {
  int clientes = 0;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    clientes++;
    return super.createHttpClient(context);
  }
}

Finder _campo() => find.byType(TextField);

Future<ProviderContainer> _montarSinSesion(WidgetTester tester) =>
    montarApp(tester, esTecnico: false, sesionIniciada: false);

/// Escribe el celular, acepta el aviso y toca «Continuar».
Future<void> _pasarAlCodigo(WidgetTester tester) async {
  await tester.enterText(_campo(), _celular);
  await tester.tap(find.byType(Checkbox));
  await tester.pumpAndSettle();
  await tocarTexto(tester, 'Continuar');
}

/// Desmonta la app y desecha el contenedor para que la cuenta regresiva
/// cancele su `Timer` antes de que termine la prueba (desechar dos veces no
/// hace nada).
Future<void> _desmontar(
  WidgetTester tester,
  ProviderContainer container,
) async {
  await tester.pumpWidget(const SizedBox.shrink());
  container.dispose();
}

void main() {
  testWidgets(
    'TC-HU-001-01 con 10 dígitos y el aviso aceptado pasa al código sin red',
    (tester) async {
      final red = _ContadorDeRed();
      final anterior = HttpOverrides.current;
      HttpOverrides.global = red;
      addTearDown(() => HttpOverrides.global = anterior);

      final container = await _montarSinSesion(tester);
      expect(find.text('Entra con tu celular'), findsOneWidget);
      expect(find.text('+52'), findsOneWidget);
      expect(find.text('Te enviaremos un código por SMS'), findsOneWidget);
      expect(
        tester.widget<TextField>(_campo()).keyboardType,
        TextInputType.number,
      );

      await _pasarAlCodigo(tester);

      expect(ubicacion(container), Rutas.codigo);
      expect(find.text('Escribe el código'), findsOneWidget);
      expect(find.text('Lo enviamos al +52 55 1234 5678'), findsOneWidget);
      expect(find.text('Reenviar en 60 s'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(container.read(sesionIniciadaProvider), isFalse);
      expect(red.clientes, 0);

      await _desmontar(tester, container);
    },
  );

  group('TC-HU-001-02 celular inválido', () {
    for (final MapEntry(key: caso, value: escrito) in {
      'vacío': '',
      'menos de 10 dígitos': '551234567',
      'con letras': '55abc',
    }.entries) {
      testWidgets('TC-HU-001-02 $caso muestra el error y no avanza', (
        tester,
      ) async {
        final container = await _montarSinSesion(tester);
        await tester.enterText(_campo(), escrito);
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        await tocarTexto(tester, 'Continuar');

        expect(
          find.text('Escribe los 10 dígitos de tu celular'),
          findsOneWidget,
        );
        expect(ubicacion(container), Rutas.entrar);
        expect(find.text('Escribe el código'), findsNothing);
      });
    }

    testWidgets('TC-HU-001-02 el campo no admite más de 10 dígitos ni letras', (
      tester,
    ) async {
      await _montarSinSesion(tester);
      await tester.enterText(_campo(), '55a1234567890');
      await tester.pump();

      expect(tester.widget<TextField>(_campo()).controller!.text, _celular);
    });
  });

  testWidgets(
    'TC-HU-001-03 sin aceptar el aviso Continuar no avanza y lo indica',
    (tester) async {
      final container = await _montarSinSesion(tester);
      // El aviso se ve como texto, sin abrir nada.
      expect(find.text('Acepto el aviso de privacidad'), findsOneWidget);

      await tester.enterText(_campo(), _celular);
      await tocarTexto(tester, 'Continuar');

      expect(ubicacion(container), Rutas.entrar);
      expect(
        find.text('Acepta el aviso de privacidad para continuar'),
        findsOneWidget,
      );
      expect(find.text('Escribe los 10 dígitos de tu celular'), findsNothing);
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).isError, isTrue);

      // Al aceptarlo desaparece el aviso y ya avanza.
      await tester.tap(find.text('Acepto el aviso de privacidad'));
      await tester.pumpAndSettle();
      expect(
        find.text('Acepta el aviso de privacidad para continuar'),
        findsNothing,
      );
      await tocarTexto(tester, 'Continuar');
      expect(ubicacion(container), Rutas.codigo);

      await _desmontar(tester, container);
    },
  );

  group('TC-HU-001-04 pantalla del código', () {
    testWidgets('TC-HU-001-04 con menos de 6 dígitos Entrar no avanza', (
      tester,
    ) async {
      final container = await _montarSinSesion(tester);
      await _pasarAlCodigo(tester);

      await tester.enterText(_campo(), '12345');
      await tocarTexto(tester, 'Entrar');

      expect(find.text('Escribe los 6 dígitos del código'), findsOneWidget);
      expect(container.read(sesionIniciadaProvider), isFalse);
      expect(ubicacion(container), Rutas.codigo);

      await _desmontar(tester, container);
    });

    testWidgets(
      'TC-HU-001-04 con 6 dígitos Entrar marca la sesión y lleva a Inicio',
      (tester) async {
        final container = await _montarSinSesion(tester);
        await _pasarAlCodigo(tester);

        await tester.enterText(_campo(), _codigo);
        await tocarTexto(tester, 'Entrar');

        expect(container.read(sesionIniciadaProvider), isTrue);
        expect(ubicacion(container), Rutas.inicio);
        expect(enElTitulo('Inicio'), findsOneWidget);
        expect(find.byType(NavigationBar), findsOneWidget);
      },
    );

    testWidgets(
      'TC-HU-001-04 la cuenta baja de 60 a 0 y Reenviar código la reinicia',
      (tester) async {
        final container = await _montarSinSesion(tester);
        await _pasarAlCodigo(tester);
        expect(find.text('Reenviar en 60 s'), findsOneWidget);
        expect(find.text('Reenviar código'), findsNothing);

        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Reenviar en 59 s'), findsOneWidget);

        await tester.pump(const Duration(seconds: 58));
        expect(find.text('Reenviar en 1 s'), findsOneWidget);

        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Reenviar código'), findsOneWidget);
        expect(find.textContaining('Reenviar en'), findsNothing);

        // Sigue en 0: no baja de cero.
        await tester.pump(const Duration(seconds: 5));
        expect(find.text('Reenviar código'), findsOneWidget);

        await tocarTexto(tester, 'Reenviar código');
        expect(find.text('Reenviar en 60 s'), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Reenviar en 59 s'), findsOneWidget);

        await _desmontar(tester, container);
      },
    );

    testWidgets('TC-HU-001-04 Cambiar número regresa a escribir el celular', (
      tester,
    ) async {
      final container = await _montarSinSesion(tester);
      await _pasarAlCodigo(tester);

      await tocarTexto(tester, 'Cambiar número');

      expect(ubicacion(container), Rutas.entrar);
      expect(find.text('Entra con tu celular'), findsOneWidget);
      // El número escrito se conserva para corregirlo.
      expect(tester.widget<TextField>(_campo()).controller!.text, _celular);
      await _desmontar(tester, container);
    });
  });

  group('TC-HU-001-06 idiomas, temas y accesibilidad', () {
    for (final idioma in ['es', 'en']) {
      for (final modo in [ThemeMode.light, ThemeMode.dark]) {
        testWidgets('TC-HU-001-06 textos del ARB, etiquetas, 48 dp y 200 % '
            '($idioma, ${modo.name})', (tester) async {
          final semantica = tester.ensureSemantics();
          tester.view.physicalSize = const Size(320, 640);
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.textScaleFactorTestValue = 2;
          addTearDown(() {
            tester.view.reset();
            tester.platformDispatcher.clearTextScaleFactorTestValue();
          });

          final arb = leerArb(idioma);
          final container = await _montarSinSesion(tester);
          container.read(preferenciasProvider.notifier)
            ..cambiarIdioma(Locale(idioma))
            ..cambiarTema(modo);
          await tester.pumpAndSettle();

          final esperado = modo == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light;
          expect(
            Theme.of(tester.element(find.byType(Scaffold))).brightness,
            esperado,
          );

          // Pantalla del celular, con los dos mensajes de error a la vista.
          await tocarTexto(tester, arb['entradaContinuar']!);
          final avisoCompleto = arb['entradaAceptoAviso']!.replaceAll(
            '{aviso}',
            arb['entradaAvisoPrivacidad']!,
          );
          _comprobarTextos(tester, {...arb.values, avisoCompleto});
          for (final clave in [
            'entradaCelularTitulo',
            'entradaCelularEtiqueta',
            'entradaPrefijoPais',
            'entradaCelularError',
            'entradaAvisoError',
            'entradaContinuar',
          ]) {
            expect(find.text(arb[clave]!), findsWidgets, reason: clave);
          }
          expect(find.text(avisoCompleto), findsOneWidget);
          await _comprobarAccesibilidad(tester);

          // Pantalla del código, con su error a la vista.
          container.read(appRouterProvider).go(Rutas.codigo, extra: _celular);
          await tester.pumpAndSettle();
          await tocarTexto(tester, arb['entradaEntrar']!);
          final enviadoA = arb['entradaCodigoEnviadoA']!.replaceAll(
            '{celular}',
            '55 1234 5678',
          );
          // La cuenta regresiva corre mientras se asienta la pantalla.
          final reenviar = {
            for (var segundos = 1; segundos <= 60; segundos++)
              arb['entradaReenviarEn']!.replaceAll('{segundos}', '$segundos'),
          };
          _comprobarTextos(tester, {...arb.values, enviadoA, ...reenviar});
          expect(find.text(enviadoA), findsOneWidget);
          expect(
            find.byWidgetPredicate(
              (w) => w is Text && reenviar.contains(w.data),
            ),
            findsOneWidget,
          );
          expect(find.text(arb['entradaCodigoError']!), findsOneWidget);
          expect(find.text(arb['entradaCambiarNumero']!), findsOneWidget);
          await _comprobarAccesibilidad(tester);

          expect(tester.takeException(), isNull);
          await _desmontar(tester, container);
          semantica.dispose();
        });
      }
    }
  });
}

/// Todo `Text` visible sale de los ARB (o de un texto del ARB con sus
/// valores de ejemplo).
void _comprobarTextos(WidgetTester tester, Set<String> permitidos) {
  for (final texto in tester.widgetList<Text>(find.byType(Text))) {
    final plano = texto.data ?? texto.textSpan!.toPlainText();
    expect(permitidos, contains(plano), reason: '«$plano» no está en el ARB');
  }
}

Future<void> _comprobarAccesibilidad(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}
