// Spec 028 (KNOCK-260): el aviso de privacidad de «Entra con tu celular» abre
// la página de la landing en el navegador y no marca la casilla.
//
// CA_028_10 (humo manual): con la app instalada desde la tienda, tocar el aviso
// abre la página de privacidad publicada. Lo hace el Tech Lead en el teléfono y
// deja la captura en el PR (no se puede automatizar sin un navegador real).
import 'package:app/core/config/aviso_de_privacidad.dart';
import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/router/rutas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/accesibilidad.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';

/// Abridor que anota las direcciones que se le piden.
class _AbridorFalso implements AbridorDeEnlaces {
  _AbridorFalso({this.resultado = true});

  final bool resultado;
  final abiertos = <Uri>[];

  @override
  Future<bool> abrir(Uri direccion) async {
    abiertos.add(direccion);
    return resultado;
  }
}

const _celular = '5512345678';

Future<ProviderContainer> _montar(WidgetTester tester, _AbridorFalso abridor) =>
    montarApp(
      tester,
      esTecnico: false,
      sesionIniciada: false,
      extra: [abridorDeEnlacesProvider.overrideWithValue(abridor)],
    );

/// El fragmento del aviso dentro del texto de la casilla.
FinderBase<TextRangeContext> _aviso(String texto) =>
    find.textRange.ofSubstring(texto);

bool _marcada(WidgetTester tester) =>
    tester.widget<Checkbox>(find.byType(Checkbox)).value ?? false;

String _celularEscrito(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

void main() {
  testWidgets('CA_028_01 tocar el aviso pide abrir su dirección en el '
      'navegador externo', (tester) async {
    final abridor = _AbridorFalso();
    await _montar(tester, abridor);

    await tester.tapOnText(_aviso('aviso de privacidad'));
    await tester.pumpAndSettle();

    expect(abridor.abiertos, [urlDelAvisoDePrivacidad]);
    expect(abridor.abiertos.single.scheme, 'https');
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('CA_028_02 tocar el aviso no cambia la casilla y tocar el resto '
      'de la fila sí', (tester) async {
    final abridor = _AbridorFalso();
    await _montar(tester, abridor);
    expect(_marcada(tester), isFalse);

    await tester.tapOnText(_aviso('aviso de privacidad'));
    await tester.pumpAndSettle();
    expect(_marcada(tester), isFalse);
    expect(abridor.abiertos, hasLength(1));

    await tester.tapOnText(_aviso('Acepto el'));
    await tester.pumpAndSettle();
    expect(_marcada(tester), isTrue);
    expect(abridor.abiertos, hasLength(1), reason: 'la fila no abre el aviso');

    // Con la casilla marcada tocar el aviso tampoco la desmarca.
    await tester.tapOnText(_aviso('aviso de privacidad'));
    await tester.pumpAndSettle();
    expect(_marcada(tester), isTrue);
    expect(abridor.abiertos, hasLength(2));
  });

  testWidgets('CA_028_04 si no se puede abrir muestra un mensaje y conserva el '
      'celular y la casilla', (tester) async {
    final abridor = _AbridorFalso(resultado: false);
    final container = await _montar(tester, abridor);

    await tester.enterText(find.byType(TextField), _celular);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(_marcada(tester), isTrue);

    await tester.tapOnText(_aviso('aviso de privacidad'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'No pudimos abrir el aviso de privacidad. '
        'Inténtalo de nuevo más tarde.',
      ),
      findsOneWidget,
    );
    expect(ubicacion(container), Rutas.entrar);
    expect(_celularEscrito(tester), _celular);
    expect(_marcada(tester), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CA_028_06 el aviso se anuncia como enlace y la fila de la '
      'casilla mide al menos 48 dp', (tester) async {
    final semantica = tester.ensureSemantics();
    await _montar(tester, _AbridorFalso());

    final nodo = find.semantics
        .byLabel('aviso de privacidad')
        .evaluate()
        .single;
    final datos = nodo.getSemanticsData();
    expect(datos.flagsCollection.isLink, isTrue);
    expect(datos.hasAction(SemanticsAction.tap), isTrue);

    expect(
      tester.getSize(find.byType(CheckboxListTile)).height,
      greaterThanOrEqualTo(48),
    );
    await expectAccesible(tester);
    semantica.dispose();
  });

  testWidgets('CA_028_07 con el texto al 200 % el aviso no se corta ni '
      'desborda', (tester) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final abridor = _AbridorFalso();
    await _montar(tester, abridor);

    expect(_aviso('aviso de privacidad'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tapOnText(_aviso('aviso de privacidad'));
    await tester.pumpAndSettle();
    expect(abridor.abiertos, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('CA_028_08 el mensaje de error aparece en inglés si ese es el '
      'idioma activo', (tester) async {
    final abridor = _AbridorFalso(resultado: false);
    final container = await _montar(tester, abridor);
    container
        .read(preferenciasProvider.notifier)
        .cambiarIdioma(const Locale('en'));
    await tester.pumpAndSettle();

    await tester.tapOnText(_aviso('privacy notice'));
    await tester.pumpAndSettle();

    expect(
      find.text("We couldn't open the privacy notice. Please try again later."),
      findsOneWidget,
    );
    expect(find.textContaining('No pudimos abrir'), findsNothing);
  });
}
