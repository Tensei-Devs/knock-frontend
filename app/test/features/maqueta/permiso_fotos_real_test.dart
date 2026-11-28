// Spec 040 (CA-23, CA-25, CA-P01 y CA-P02): el permiso de fotos del cliente
// contra la API falsa.
import 'dart:async';

import 'package:app/features/maqueta/permiso_fotos_real.dart';
import 'package:app/features/visita/data/permiso_fotos_repository_api.dart';
import 'package:app/features/visita/visita_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_cuerpo_real.dart';

const _visita = 'v1';

http.Response _vista({
  String estado = 'terminada',
  String rol = 'cliente',
  bool? permiso,
}) => jsonOk({
  'id': _visita,
  'rol': rol,
  'estado': estado,
  'permisoFotos': permiso,
});

Future<void> _montar(WidgetTester tester, ApiFalsa api) => montarCuerpoReal(
  tester,
  permisoFotosRepositoryProvider.overrideWithValue(
    PermisoFotosRepositoryApi(transporte: api.transporte, url: urlApiPrueba),
  ),
  const PermisoFotosReal(visitaId: _visita),
);

SwitchListTile _interruptor(WidgetTester tester) =>
    tester.widget<SwitchListTile>(find.byType(SwitchListTile));

Iterable<PeticionApi> _escrituras(ApiFalsa api) =>
    api.peticiones.where((p) => p.metodo == 'PUT');

void main() {
  testWidgets('CA_040_23 guarda y muestra el valor del servidor', (
    tester,
  ) async {
    final respuesta = Completer<http.Response>();
    final api = ApiFalsa((p) {
      if (p.metodo == 'PUT') return respuesta.future;
      return _vista();
    });
    await _montar(tester, api);
    expect(_interruptor(tester).value, isFalse);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(_interruptor(tester).onChanged, isNull);
    await tester.tap(find.byType(Switch));
    respuesta.complete(jsonOk({'visitaId': _visita, 'permiso': true}));
    await tester.pumpAndSettle();
    expect(_interruptor(tester).value, isTrue);
    expect(find.text('Guardamos tu respuesta.'), findsOneWidget);
    final p = _escrituras(api).single;
    expect(p.ruta, 'visitas/$_visita/permiso-fotos');
    expect(p.json, {'permiso': true});
  });

  for (final (estado, texto) in [
    (400, 'Revisa los datos'),
    (403, 'No tienes permiso'),
    (404, 'ya no está disponible'),
    (409, 'choca'),
    (422, 'Revisa los datos'),
    (429, 'demasiados intentos'),
    (500, 'No pudimos conectar'),
  ]) {
    testWidgets('CA_040_25 un $estado regresa al valor anterior', (
      tester,
    ) async {
      final api = ApiFalsa(
        (p) => p.metodo == 'PUT' ? http.Response('', estado) : _vista(),
      );
      await _montar(tester, api);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(_interruptor(tester).value, isFalse);
      expect(find.textContaining(texto, findRichText: true), findsOneWidget);
      expect(_escrituras(api), hasLength(1));
    });
  }

  testWidgets('CA_040_25 sin red conserva el valor', (tester) async {
    final api = ApiFalsa((p) {
      if (p.metodo == 'PUT') throw http.ClientException('sin red');
      return _vista(permiso: true);
    });
    await _montar(tester, api);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(_interruptor(tester).value, isTrue);
    expect(_escrituras(api), hasLength(1));
  });

  for (final (estado, rol) in [
    ('en_curso', 'cliente'),
    ('terminada', 'tecnico'),
  ]) {
    testWidgets('CA_040_23 no aparece en $estado como $rol', (tester) async {
      final api = ApiFalsa((_) => _vista(estado: estado, rol: rol));
      await _montar(tester, api);
      expect(find.byType(SwitchListTile), findsNothing);
    });
  }
}
