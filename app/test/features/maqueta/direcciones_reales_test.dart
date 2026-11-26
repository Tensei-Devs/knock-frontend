// Spec 030: «Mis datos» y el paso 3 de «Pedir cotización» con las direcciones
// del servidor. Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/direcciones/data/direcciones_repository_api.dart';
import 'package:app/features/direcciones/direcciones.dart';
import 'package:app/features/maqueta/direcciones_reales.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/montar_cuerpo_real.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

Map<String, Object?> _direccion(
  String id, {
  String colonia = 'Col. Centro',
  String? referencias = 'Portón verde',
  bool principal = false,
}) => {
  'id': id,
  'calleNumero': 'Calle Falsa $id',
  'colonia': colonia,
  'referencias': referencias,
  'principal': principal,
  'creadoEn': '2026-11-20T18:00:00Z',
};

Future<void> _montar(WidgetTester tester, ApiFalsa api, Widget hijo) {
  maq.user.col = 'Col. Centro';
  return montarCuerpoReal(
    tester,
    direccionesRepositoryProvider.overrideWithValue(
      DireccionesRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
    ),
    hijo,
  );
}

Future<void> _tocar(WidgetTester tester, Finder que) async {
  await tester.ensureVisible(que.last);
  await asentarMaqueta(tester);
  await tester.tap(que.last);
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta();

  for (final (nombre, hijo) in const [
    ('Mis datos', DireccionesReales()),
    ('paso 3', DireccionAlPedirReal()),
  ]) {
    testWidgets('CA_030_12_13 $nombre: carga, sin conexión con Reintentar y '
        'vacío', (tester) async {
      var sinRed = true;
      final api = ApiFalsa((_) {
        if (sinRed) throw http.ClientException('sin red');
        return jsonOk(<Object?>[]);
      });
      await _montar(tester, api, hijo);
      expect(find.textContaining('No pudimos cargar'), findsOneWidget);
      expect(find.textContaining('No pudimos conectar'), findsOneWidget);

      sinRed = false;
      await _tocar(tester, find.text('Reintentar'));

      expect(find.textContaining('Aún no tienes direcciones'), findsOneWidget);
      expect(find.text('Agregar dirección'), findsOneWidget);
    });
  }

  testWidgets('CA_030_01 la lista muestra colonia y referencias, nunca la '
      'calle', (tester) async {
    final api = ApiFalsa(
      (_) => jsonOk([
        _direccion('1', principal: true),
        _direccion('2', colonia: 'Col. Otra', referencias: null),
      ]),
    );
    await _montar(tester, api, const DireccionesReales());

    expect(find.text('Col. Centro'), findsOneWidget);
    expect(find.text('Portón verde'), findsOneWidget);
    expect(find.text('Sin referencias'), findsOneWidget);
    expect(find.text('Principal'), findsOneWidget);
    expect(find.textContaining('Calle Falsa'), findsNothing);
  });

  testWidgets('CA_030_03_05 alta: un 422 conserva lo escrito y al aceptar se '
      'vuelve a pedir la lista', (tester) async {
    var rechazar = true;
    var lista = <Object?>[];
    final api = ApiFalsa((p) {
      if (p.metodo == 'GET') return jsonOk(lista);
      if (rechazar) return http.Response('', 422);
      lista = [_direccion('9')];
      return jsonOk(_direccion('9'), estado: 201);
    });
    await _montar(tester, api, const DireccionesReales());

    await _tocar(tester, find.text('Agregar dirección'));
    await tester.enterText(find.byType(TextField).first, 'Calle Falsa 9');
    await asentarMaqueta(tester);
    await _tocar(tester, find.text('Guardar dirección'));

    expect(find.textContaining('Revisa los datos'), findsOneWidget);
    expect(find.text('Calle Falsa 9'), findsOneWidget);

    rechazar = false;
    await _tocar(tester, find.text('Guardar dirección'));

    final alta = api.peticiones.lastWhere((p) => p.metodo == 'POST');
    expect(alta.ruta, 'me/direcciones');
    expect(alta.json, {
      'calleNumero': 'Calle Falsa 9',
      'colonia': 'Col. Centro',
      'principal': false,
    });
    expect(find.text('Guardar dirección'), findsNothing);
    expect(find.text('Portón verde'), findsOneWidget);
  });

  for (final estado in [403, 404]) {
    testWidgets('CA_030_08 editar: un $estado se explica y conserva lo '
        'escrito', (tester) async {
      final api = ApiFalsa(
        (p) => p.metodo == 'GET'
            ? jsonOk([_direccion('1')])
            : http.Response('', estado),
      );
      await _montar(tester, api, const DireccionesReales());

      await _tocar(tester, find.text('Editar'));
      await tester.enterText(find.byType(TextField).first, 'Calle Nueva 2');
      await asentarMaqueta(tester);
      await _tocar(tester, find.text('Guardar dirección'));

      expect(
        api.peticiones.where((p) => p.metodo == 'PUT').single.ruta,
        'me/direcciones/1',
      );
      expect(find.textContaining('ya no está disponible'), findsOneWidget);
      expect(find.text('Calle Nueva 2'), findsOneWidget);
    });

    testWidgets('CA_030_11 eliminar: un $estado se explica en la hoja', (
      tester,
    ) async {
      final api = ApiFalsa(
        (p) => p.metodo == 'GET'
            ? jsonOk([_direccion('1')])
            : http.Response('', estado),
      );
      await _montar(tester, api, const DireccionesReales());

      await _tocar(tester, find.text('Eliminar'));
      await _tocar(tester, find.text('Eliminar'));

      expect(find.textContaining('ya no está disponible'), findsOneWidget);
    });
  }

  testWidgets('CA_030_09 eliminar con 204 quita la dirección', (tester) async {
    var lista = <Object?>[_direccion('1')];
    final api = ApiFalsa((p) {
      if (p.metodo == 'GET') return jsonOk(lista);
      lista = [];
      return http.Response('', 204);
    });
    await _montar(tester, api, const DireccionesReales());

    await _tocar(tester, find.text('Eliminar'));
    await _tocar(tester, find.text('Eliminar'));

    expect(api.llamadas, contains('DELETE me/direcciones/1'));
    expect(find.textContaining('Aún no tienes direcciones'), findsOneWidget);
  });

  testWidgets('CA_030_13 el paso 3 elige la principal y deja cambiarla', (
    tester,
  ) async {
    final api = ApiFalsa(
      (_) => jsonOk([
        _direccion('1', colonia: 'Col. Otra'),
        _direccion('2', principal: true),
      ]),
    );
    await _montar(tester, api, const DireccionAlPedirReal());
    final contenedor = ProviderScope.containerOf(
      tester.element(find.byType(DireccionAlPedirReal)),
    );
    expect(contenedor.read(direccionParaPedirProvider)?.id, '2');

    await _tocar(tester, find.text('Col. Otra'));

    expect(contenedor.read(direccionParaPedirProvider)?.id, '1');
  });

  testWidgets('CA_030_14 en inglés los textos salen del ARB', (tester) async {
    final en = lookupAppLocalizations(const Locale('en'));
    expect(en.direccionesAgregar, leerArb('en')['direccionesAgregar']);
    expect(
      leerArb('es').keys.where((k) => k.startsWith('direcciones')).toSet(),
      leerArb('en').keys.where((k) => k.startsWith('direcciones')).toSet(),
    );
  });

  testWidgets('CA_030_15 con texto al 200 % no se desborda y los botones '
      'miden 48 dp', (tester) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final api = ApiFalsa((_) => jsonOk([_direccion('1', principal: true)]));
    await _montar(tester, api, const DireccionesReales());

    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  });

  test('CA_030_16 los textos de depuración no llevan datos personales', () {
    final d = Direccion(
      id: '1',
      calleNumero: 'Calle Falsa 1',
      colonia: 'Col. Centro',
      principal: true,
      creadoEn: DateTime(2026),
    );
    expect('$d', isNot(contains('Calle')));
    expect('${const NoEncontradoFailure()}', isNot(contains('Calle')));
  });
}
