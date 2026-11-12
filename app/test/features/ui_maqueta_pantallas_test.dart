// Spec 014 (KNOCK-242), CA-06: Inicio, Explorar, Actividad, Oficios y Mi cuenta
// usan los componentes base de la maqueta (P01, P06, P11, P20) y conservan
// sus cuatro estados, rutas y acciones. Datos ficticios y sin red.
import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/core/widgets/fila_knock.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/oficios/data/oficios_repository_de_prueba.dart';
import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/oficios_repository.dart';
import 'package:app/features/oficios/oficios_providers.dart';
import 'package:app/features/oficios/presentation/oficios_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../soporte/accesibilidad.dart';
import '../soporte/montar_app.dart';
import '../soporte/pantalla_maqueta.dart';

class _RepositorioDe implements OficiosRepository {
  const _RepositorioDe(this._respuesta);

  final Future<List<Oficio>> Function() _respuesta;

  @override
  Future<List<Oficio>> listar() => _respuesta();
}

/// Pantalla de Oficios sola, con los temas de Knock.
Future<void> _montarOficios(
  WidgetTester tester,
  OficiosRepository repositorio,
  ThemeMode modo, {
  bool asentar = true,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [oficiosRepositoryProvider.overrideWithValue(repositorio)],
      child: MaterialApp(
        theme: temaClaro,
        darkTheme: temaOscuro,
        themeMode: modo,
        home: const OficiosScreen(),
      ),
    ),
  );
  if (asentar) await tester.pumpAndSettle();
}

Map<String, String> get _es => leerArb('es');

void main() {
  const modos = {'claro': ThemeMode.light, 'oscuro': ThemeMode.dark};

  for (final MapEntry(key: nombre, value: modo) in modos.entries) {
    group('CA_014_06 pantallas en $nombre', () {
      testWidgets(
        'CA_014_06 Inicio: saludo h1, tarjeta de zona y fila de oficios; la '
        'barra inferior lleva el estilo de la maqueta',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();
          final container = await montarApp(tester, esTecnico: false);
          await usarTema(tester, container, modo);

          final saludo = tester.widget<Text>(find.text(_es['inicioSaludo']!));
          expect(saludo.style!.fontWeight, FontWeight.w900);
          expect(saludo.style!.fontSize, 26);
          expect(find.byType(TarjetaKnock), findsOneWidget);
          expect(find.byType(Card), findsNothing);
          // A 200 % la lista construye la fila al desplazarse hasta ella.
          await tester.scrollUntilVisible(
            find.text(_es['inicioExplorarOficios']!),
            200,
          );
          expect(
            find.widgetWithText(FilaKnock, _es['inicioExplorarOficios']!),
            findsOneWidget,
          );
          // La acción de la zona sigue ahí y mide lo de un botón de la maqueta.
          final boton = find.widgetWithText(
            FilledButton,
            _es['inicioVerColonia']!,
          );
          await tester.ensureVisible(boton);
          expect(
            tester.getSize(boton).height,
            greaterThanOrEqualTo(Alturas.boton),
          );

          // Barra inferior: píldora activa y línea superior de la maqueta.
          final contexto = tester.element(find.byType(NavigationBar));
          final tema = Theme.of(contexto);
          expect(
            tema.navigationBarTheme.indicatorColor,
            contexto.colores.navySoft,
          );
          expect(
            find.ancestor(
              of: find.byType(NavigationBar),
              matching: find.byWidgetPredicate(
                (w) =>
                    w is DecoratedBox &&
                    w.decoration is BoxDecoration &&
                    (w.decoration as BoxDecoration).border != null,
              ),
            ),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
          await expectAccesible(tester);
          semantica.dispose();
        },
      );

      testWidgets(
        'CA_014_06 Explorar: fila de Oficios con los componentes base y la '
        'ruta de siempre',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();
          final container = await montarApp(tester, esTecnico: false);
          await usarTema(tester, container, modo);
          await tester.tap(enLaBarra('Explorar'));
          await tester.pumpAndSettle();

          expect(ubicacion(container), Rutas.explorar);
          expect(find.byType(GrupoDeFilas), findsOneWidget);
          expect(find.widgetWithText(FilaKnock, 'Oficios'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await expectAccesible(tester);

          await tester.tap(find.widgetWithText(ListTile, 'Oficios'));
          await tester.pumpAndSettle();
          expect(ubicacion(container), Rutas.oficios);
          // Datos de prueba: tres oficios en el mismo grupo de filas.
          expect(find.byType(FilaKnock), findsNWidgets(3));
          semantica.dispose();
        },
      );

      testWidgets(
        'CA_014_06 Actividad: estado vacío de la maqueta y ningún botón sin '
        'destino',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();
          final container = await montarApp(tester, esTecnico: false);
          await usarTema(tester, container, modo);
          await tester.tap(enLaBarra('Actividad'));
          await tester.pumpAndSettle();

          expect(ubicacion(container), Rutas.actividad);
          expect(find.byType(EstadoKnock), findsOneWidget);
          expect(find.text(_es['actividadVaciaTitulo']!), findsOneWidget);
          expect(find.text(_es['actividadVaciaDetalle']!), findsOneWidget);
          expect(find.byType(FilledButton), findsNothing);
          expect(find.byType(OutlinedButton), findsNothing);
          expect(find.byType(TextButton), findsNothing);
          expect(tester.takeException(), isNull);
          await expectAccesible(tester);
          semantica.dispose();
        },
      );

      testWidgets(
        'CA_014_06 Oficios: cargando, datos, vacío y error con Reintentar',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();

          // Cargando.
          final espera = Completer<List<Oficio>>();
          await _montarOficios(
            tester,
            _RepositorioDe(() => espera.future),
            modo,
            asentar: false,
          );
          await tester.pump();
          expect(find.byType(CircularProgressIndicator), findsOneWidget);

          // Datos.
          await _montarOficios(tester, const OficiosRepositoryDePrueba(), modo);
          expect(find.byType(FilaKnock), findsNWidgets(3));
          expect(find.byType(GrupoDeFilas), findsOneWidget);

          // Vacío (no es un error).
          await _montarOficios(
            tester,
            _RepositorioDe(() async => const []),
            modo,
          );
          expect(find.byType(EstadoKnock), findsOneWidget);
          expect(
            find.text('Todavía no hay oficios disponibles'),
            findsOneWidget,
          );
          expect(find.text('Reintentar'), findsNothing);

          // Error con Reintentar, que vuelve a pedir.
          var pedidos = 0;
          await _montarOficios(
            tester,
            _RepositorioDe(() async {
              pedidos++;
              throw const ServicioNoDisponibleFailure();
            }),
            modo,
          );
          expect(find.byType(EstadoKnock), findsOneWidget);
          expect(find.text('No pudimos cargar los oficios'), findsOneWidget);
          final antes = pedidos;
          await tester.ensureVisible(find.text('Reintentar'));
          await tester.tap(find.text('Reintentar'));
          await tester.pumpAndSettle();
          expect(pedidos, greaterThan(antes));
          expect(
            tester.getSize(find.byType(FilledButton)).height,
            greaterThanOrEqualTo(Alturas.boton),
          );
          expect(tester.takeException(), isNull);
          await expectAccesible(tester);
          semantica.dispose();
        },
      );

      testWidgets('CA_014_06 Mi cuenta: tarjeta de perfil sin teléfono, filas '
          'agrupadas y cierre de sesión en una hoja inferior', (tester) async {
        fijarPantalla(tester, escalaDeTexto: 2);
        final semantica = tester.ensureSemantics();
        final container = await montarApp(tester, esTecnico: false);
        await usarTema(tester, container, modo);
        await tester.tap(enLaBarra('Mi cuenta'));
        await tester.pumpAndSettle();

        expect(ubicacion(container), Rutas.cuenta);
        expect(find.text('Persona Demo'), findsOneWidget);
        expect(find.text(_es['cuentaEditarPerfil']!), findsOneWidget);
        expect(find.textContaining('+52'), findsNothing);
        expect(find.byType(TarjetaKnock), findsOneWidget);
        expect(find.widgetWithText(FilaKnock, 'Configuración'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await expectAccesible(tester);

        await tester.scrollUntilVisible(find.text('Cerrar sesión'), 200);
        // Cerrar sesión: hoja inferior (no un AlertDialog) con los mismos
        // textos; Cancelar la cierra y conserva la cuenta.
        await tocarTexto(tester, 'Cerrar sesión');
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.byType(BottomSheet), findsOneWidget);
        expect(find.text(_es['cuentaCerrarSesionTitulo']!), findsOneWidget);
        expect(
          tester
              .getSize(find.widgetWithText(FilledButton, 'Cerrar sesión'))
              .height,
          greaterThanOrEqualTo(Alturas.boton),
        );
        // A 200 % la hoja se desplaza hasta Cancelar.
        await tester.ensureVisible(find.text('Cancelar'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsNothing);
        // Cancelar no cierra la sesión: el perfil sigue completo.
        expect(
          container.read(perfilControllerProvider).value!.completo,
          isTrue,
        );
        semantica.dispose();
      });
    });
  }
}
