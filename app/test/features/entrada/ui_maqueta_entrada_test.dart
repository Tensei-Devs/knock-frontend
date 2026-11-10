// Spec 014 (KNOCK-242), CA-05: la entrada (celular, código y completar perfil)
// usa la marca, el título, los campos y el botón principal de la maqueta (P07)
// y conserva sus mensajes de error y su cuenta regresiva. Datos ficticios.
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/data/perfil_repository_simulado.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/accesibilidad.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';

const _celular = '5512345678';

/// Altura del botón relleno de la pantalla (el único `FilledButton`).
Size _boton(WidgetTester tester) => tester.getSize(find.byType(FilledButton));

void _estiloDeEntrada(WidgetTester tester, String titulo) {
  // Título `.h1`: 26/900 en Nunito.
  final estilo = tester.widget<Text>(find.text(titulo)).style!;
  expect(estilo.fontWeight, FontWeight.w900);
  expect(estilo.fontSize, 26);
  // Formulario en una tarjeta con la sombra de la maqueta.
  expect(find.byType(TarjetaKnock), findsOneWidget);
  // Campo con el contorno del tema (`.inp`, radio 12).
  final borde =
      Theme.of(tester.element(find.byType(TextField).first))
              .inputDecorationTheme
              .border!
          as OutlineInputBorder;
  expect(borde.borderRadius, BorderRadius.circular(Radios.pequeno));
  // Botón principal `.btn`: píldora de 56 dp o más y todo el ancho.
  final boton = _boton(tester);
  expect(boton.height, greaterThanOrEqualTo(Alturas.boton));
  final tarjeta = tester.getSize(find.byType(TarjetaKnock));
  expect(boton.width, tarjeta.width - 2 * Espaciado.cuerpo);
}

void main() {
  const modos = {'claro': ThemeMode.light, 'oscuro': ThemeMode.dark};

  for (final MapEntry(key: nombre, value: modo) in modos.entries) {
    group('CA_014_05 entrada en $nombre', () {
      testWidgets(
        'CA_014_05 celular: marca, título, campo y botón de la maqueta; sin '
        'desborde a 200 %; el error del aviso se conserva',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();
          final container = await montarApp(
            tester,
            esTecnico: false,
            sesionIniciada: false,
          );
          await usarTema(tester, container, modo);

          expect(find.text('Entra con tu celular'), findsOneWidget);
          expect(find.byIcon(Icons.door_front_door_rounded), findsOneWidget);
          expect(find.text('+52'), findsOneWidget);
          _estiloDeEntrada(tester, 'Entra con tu celular');
          expect(tester.takeException(), isNull);
          await expectAccesible(tester);

          // Con el número bien pero sin aceptar el aviso, el error sigue ahí.
          await tester.enterText(find.byType(TextField), _celular);
          await tocarTexto(tester, 'Continuar');
          expect(
            find.text(leerArb('es')['entradaAvisoError']!),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
          semantica.dispose();
        },
      );

      testWidgets(
        'CA_014_05 código: título, campo y botón de la maqueta y la cuenta '
        'regresiva se conserva',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();
          final container = await montarApp(
            tester,
            esTecnico: false,
            sesionIniciada: false,
          );
          await usarTema(tester, container, modo);
          await tester.enterText(find.byType(TextField), _celular);
          await tester.ensureVisible(find.byType(Checkbox));
          await tester.tap(find.byType(Checkbox));
          await tester.pumpAndSettle();
          await tocarTexto(tester, 'Continuar');

          expect(find.text('Escribe el código'), findsOneWidget);
          expect(find.text('Reenviar en 60 s'), findsOneWidget);
          _estiloDeEntrada(tester, 'Escribe el código');
          expect(tester.takeException(), isNull);
          await expectAccesible(tester);

          // La cuenta regresiva usa un Timer: se desmonta antes de terminar.
          await tester.pumpWidget(const SizedBox.shrink());
          container.dispose();
          semantica.dispose();
        },
      );

      testWidgets(
        'CA_014_05 completar perfil: título h1, campo y botón de la maqueta; '
        'la validación del nombre se conserva',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();
          final container = await montarApp(
            tester,
            esTecnico: false,
            extra: [
              perfilRepositoryProvider.overrideWithValue(
                PerfilRepositorySimulado(inicial: Perfil.nuevo),
              ),
            ],
          );
          await usarTema(tester, container, modo);

          expect(find.text('¿Cómo te llamas?'), findsOneWidget);
          final titulo = tester.widget<Text>(find.text('¿Cómo te llamas?'));
          expect(titulo.style!.fontWeight, FontWeight.w900);
          expect(titulo.style!.fontSize, 26);
          // A 200 % la lista no construye el botón hasta desplazarse a él.
          await tester.scrollUntilVisible(
            find.byType(FilledButton),
            200,
            scrollable: find.byType(Scrollable).first,
          );
          expect(_boton(tester).height, greaterThanOrEqualTo(Alturas.boton));
          expect(tester.takeException(), isNull);
          await expectAccesible(tester);

          await tester.enterText(find.byType(TextFormField), 'A1');
          await tester.ensureVisible(find.text('Continuar'));
          await tester.tap(find.text('Continuar'));
          await tester.pumpAndSettle();
          expect(find.text('Escribe tu nombre (solo letras)'), findsOneWidget);
          semantica.dispose();
        },
      );
    });
  }
}
