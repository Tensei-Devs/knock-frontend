// Spec 014 (KNOCK-242), CA-04: los componentes base no se desbordan con el
// texto al 200 % en 320 × 640, miden al menos 48 dp y aplican los tokens.
import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/core/widgets/fila_knock.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/accesibilidad.dart';
import '../../soporte/pantalla_maqueta.dart';

const _titulo = 'Mis técnicos de confianza con un nombre bastante largo';
const _detalle = 'Recordatorios y el historial completo de tus servicios';

Future<void> _montar(WidgetTester tester, Widget hijo, ThemeMode modo) =>
    montarSuelto(
      tester,
      SingleChildScrollView(child: hijo),
      claro: temaClaro,
      oscuro: temaOscuro,
      modo: modo,
    );

void main() {
  const modos = {'claro': ThemeMode.light, 'oscuro': ThemeMode.dark};

  for (final MapEntry(key: nombre, value: modo) in modos.entries) {
    group('CA_014_04 componentes base en $nombre', () {
      testWidgets(
        'CA_014_04 FilaKnock y GrupoDeFilas: sin desborde a 200 % y filas de '
        '62 dp o más',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();
          await _montar(
            tester,
            GrupoDeFilas(
              filas: [
                FilaKnock(
                  icono: Icons.home_outlined,
                  titulo: _titulo,
                  detalle: _detalle,
                  alTocar: () {},
                ),
                FilaKnock(
                  icono: Icons.settings_outlined,
                  titulo: 'Configuración',
                  alTocar: () {},
                ),
                const FilaKnock(
                  icono: Icons.info_outline,
                  titulo: 'Solo informa',
                ),
              ],
            ),
            modo,
          );

          expect(tester.takeException(), isNull);
          for (final fila in tester.widgetList(find.byType(ListTile))) {
            expect(
              tester.getSize(find.byWidget(fila)).height,
              greaterThanOrEqualTo(Alturas.fila),
            );
          }
          // Divisor entre filas: n - 1.
          expect(find.byType(Divider), findsNWidgets(2));
          // Flecha solo en las filas con acción.
          expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));
          await expectAccesible(tester);
          semantica.dispose();
        },
      );

      testWidgets(
        'CA_014_04 FilaKnock: cuadro de ícono de 40 con radio 12 y sin '
        'etiqueta el ícono no entra en la semántica',
        (tester) async {
          fijarPantalla(tester);
          await _montar(
            tester,
            FilaKnock(
              icono: Icons.home_outlined,
              titulo: 'Fila',
              alTocar: () {},
            ),
            modo,
          );
          final cuadro = tester.widget<Container>(
            find
                .ancestor(
                  of: find.byIcon(Icons.home_outlined),
                  matching: find.byType(Container),
                )
                .first,
          );
          final decoracion = cuadro.decoration! as BoxDecoration;
          expect(
            decoracion.borderRadius,
            BorderRadius.circular(Radios.iconoFila),
          );
          expect(
            tester.getSize(find.byWidget(cuadro)),
            const Size.square(Alturas.iconoFila),
          );
          final c = tester.element(find.byType(FilaKnock)).colores;
          expect(decoracion.color, c.navySoft);
          expect(
            find.ancestor(
              of: find.byIcon(Icons.home_outlined),
              matching: find.byWidgetPredicate(
                (w) => w is ExcludeSemantics && w.excluding,
              ),
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets('CA_014_04 FilaKnock: con etiqueta el ícono se anuncia', (
        tester,
      ) async {
        fijarPantalla(tester);
        final semantica = tester.ensureSemantics();
        await _montar(
          tester,
          const FilaKnock(
            icono: Icons.build_outlined,
            etiquetaIcono: 'En taller',
            titulo: 'Mecánica',
          ),
          modo,
        );
        // La etiqueta del ícono se fusiona con el texto de la fila.
        expect(find.bySemanticsLabel(RegExp('En taller')), findsOneWidget);
        semantica.dispose();
      });

      testWidgets(
        'CA_014_04 TarjetaKnock: radio 22, sombra de dos capas y tinta de lo '
        'que lleva dentro visible',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          await _montar(
            tester,
            TarjetaKnock(
              child: Column(
                children: [
                  const Text(_titulo),
                  CheckboxListTile(
                    value: false,
                    onChanged: (_) {},
                    title: const Text(_detalle),
                  ),
                ],
              ),
            ),
            modo,
          );
          // Sin la aserción «ListTile … ink splashes may be invisible».
          expect(tester.takeException(), isNull);
          final sombra = tester.widget<DecoratedBox>(
            find
                .descendant(
                  of: find.byType(TarjetaKnock),
                  matching: find.byType(DecoratedBox),
                )
                .first,
          );
          final deco = sombra.decoration as BoxDecoration;
          expect(deco.boxShadow, Sombras.tarjeta);
          expect(deco.borderRadius, BorderRadius.circular(Radios.grande));
          expect(deco.color, isNull);
        },
      );

      testWidgets(
        'CA_014_04 EstadoKnock: sin desborde a 200 %, círculo de 96 y botón '
        'de 48 dp o más',
        (tester) async {
          fijarPantalla(tester, escalaDeTexto: 2);
          final semantica = tester.ensureSemantics();
          var reintentos = 0;
          await montarSuelto(
            tester,
            EstadoKnock(
              icono: Icons.cloud_off_outlined,
              titulo: 'No pudimos cargar los oficios, intenta otra vez',
              detalle: _detalle * 2,
              accion: FilledButton(
                onPressed: () => reintentos++,
                child: const Text('Reintentar'),
              ),
            ),
            claro: temaClaro,
            oscuro: temaOscuro,
            modo: modo,
          );

          expect(tester.takeException(), isNull);
          final boton = tester.getSize(find.byType(FilledButton));
          expect(boton.height, greaterThanOrEqualTo(Alturas.areaTactil));
          expect(boton.height, greaterThanOrEqualTo(Alturas.boton));
          final circulo = tester.getSize(
            find
                .ancestor(
                  of: find.byIcon(Icons.cloud_off_outlined),
                  matching: find.byType(Container),
                )
                .first,
          );
          expect(circulo, const Size.square(Alturas.estadoVacio));
          await expectAccesible(tester);
          // A 200 % el contenido no cabe y se desplaza hasta el botón.
          await tester.ensureVisible(find.text('Reintentar'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Reintentar'));
          expect(reintentos, 1);
          semantica.dispose();
        },
      );
    });
  }
}
