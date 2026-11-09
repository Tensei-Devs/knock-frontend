import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../soporte/montar_app.dart';

/// Todo texto que pinta la pantalla activa: `Text` (barra, títulos, menú)
/// y los mensajes de `Tooltip` (los lee el lector de pantalla).
List<String> _textosVisibles(WidgetTester tester) => [
  for (final texto in tester.widgetList<Text>(find.byType(Text)))
    texto.data ?? texto.textSpan!.toPlainText(),
  for (final ayuda in tester.widgetList<Tooltip>(find.byType(Tooltip)))
    if (ayuda.message != null) ayuda.message!,
];

/// Comprueba que todo texto visible de la pantalla está en [permitidos] y
/// devuelve los textos vistos.
List<String> _comprobarTextos(
  WidgetTester tester,
  Set<String> permitidos,
  String pantalla,
  String idioma,
) {
  final textos = _textosVisibles(tester);
  for (final texto in textos) {
    expect(
      permitidos,
      contains(texto),
      reason: '«$texto» en $pantalla no está en app_$idioma.arb',
    );
  }
  return textos;
}

const _clavesDePestana = [
  'tabInicio',
  'tabExplorar',
  'tabActividad',
  'tabTrabajo',
  'tabCuenta',
];

void main() {
  group('TC-TT-MOB-02-02 textos solo desde ARB', () {
    test(
      'TC-TT-MOB-02-02 app_es.arb y app_en.arb tienen las mismas claves',
      () {
        final es = leerArb('es');
        final en = leerArb('en');

        expect(es.keys.toSet(), en.keys.toSet());
        expect(es, isNotEmpty);
        for (final MapEntry<String, String>(:key, :value) in [
          ...es.entries,
          ...en.entries,
        ]) {
          expect(value.trim(), isNotEmpty, reason: key);
        }
      },
    );

    for (final idioma in ['es', 'en']) {
      testWidgets(
        'TC-TT-MOB-02-02 todo texto visible sale del ARB del idioma activo ($idioma)',
        (tester) async {
          final arb = leerArb(idioma);
          // Datos de la persona (perfil simulado de la demo), no textos de la app.
          final permitidos = {...arb.values, 'Persona Demo', 'PD'};
          final container = await montarApp(tester, esTecnico: true);
          container
              .read(preferenciasProvider.notifier)
              .cambiarIdioma(Locale(idioma));
          await tester.pumpAndSettle();

          expect(
            tester.widget<Title>(find.byType(Title)).title,
            arb['appTitle'],
          );

          final vistos = <String>{};
          for (final clave in _clavesDePestana) {
            await tester.tap(enLaBarra(arb[clave]!));
            await tester.pumpAndSettle();
            expect(enElTitulo(arb[clave]!), findsOneWidget, reason: clave);

            vistos.addAll(
              _comprobarTextos(tester, permitidos, arb[clave]!, idioma),
            );
          }

          // HU-052: los selectores de tema e idioma están en Configuración.
          // Solo ahí se admite además el tooltip de la flecha Atrás, que viene
          // de MaterialLocalizations y no de los ARB (spec HU-052 §8, Límites
          // conocidos).
          await tester.tap(find.text(arb['configuracionTitulo']!));
          await tester.pumpAndSettle();
          final atras = MaterialLocalizations.of(
            tester.element(find.byType(AppBar)),
          ).backButtonTooltip;
          vistos.addAll(
            _comprobarTextos(
              tester,
              {...permitidos, atras},
              arb['configuracionTitulo']!,
              idioma,
            ),
          );

          // El recorrido vio las 5 pestañas, el menú de prueba y Configuración.
          for (final clave in [
            ..._clavesDePestana,
            'pruebaModoTecnico',
            'configuracionTitulo',
            'configuracionIdioma',
            'configuracionIdiomaEspanol',
            'configuracionIdiomaIngles',
            'configuracionTema',
            'configuracionTemaAutomatico',
            'configuracionTemaAutomaticoDetalle',
            'configuracionTemaClaro',
            'configuracionTemaOscuro',
          ]) {
            expect(vistos, contains(arb[clave]), reason: clave);
          }
        },
      );
    }
  });
}
