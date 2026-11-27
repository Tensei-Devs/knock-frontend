// Spec 039 (CA-03, CA-09 y CA-17): el técnico propone el precio de su visita
// contra la API falsa.
import 'dart:async';

import 'package:app/features/maqueta/precio_tecnico_real.dart';
import 'package:app/features/visita/data/precio_tecnico_repository_api.dart';
import 'package:app/features/visita/visita_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_cuerpo_real.dart';

const _visita = 'v1';

const _finalEnviada = {
  'visitaId': _visita,
  'precio': 650,
  'estado': 'enviada',
  'venceEn': '2026-11-29T12:00:00Z',
};

const _ajuste = {
  'id': 'a1',
  'cotizacionId': 'c1',
  'visitaId': _visita,
  'montoNuevo': 600,
  'estado': 'pendiente',
  'venceEn': '2026-11-28T12:00:00Z',
};

http.Response _trabajo() => jsonOk({
  'proximasVisitas': [
    {'visitaId': _visita, 'solicitudId': 's1'},
  ],
  'cotizacionesEnviadas': [
    {'cotizacionId': 'c0', 'solicitudId': 's1', 'estado': 'rechazada'},
    {
      'cotizacionId': 'c1',
      'solicitudId': 's1',
      'estado': 'aceptada',
      'tope': 500,
    },
  ],
});

Future<void> _montar(WidgetTester tester, ApiFalsa api, String boton) async {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await montarCuerpoReal(
    tester,
    precioTecnicoRepositoryProvider.overrideWithValue(
      PrecioTecnicoRepositoryApi(transporte: api.transporte, url: urlApiPrueba),
    ),
    const PrecioTecnicoReal(visitaId: _visita),
  );
  await tester.tap(find.text(boton));
  await tester.pumpAndSettle();
}

Future<void> _llenar(WidgetTester tester, String monto, String texto) async {
  await tester.enterText(find.byType(TextField).at(0), monto);
  await tester.enterText(find.byType(TextField).at(1), texto);
  await tester.pump();
}

Future<void> _tocar(WidgetTester tester, String boton) async {
  await tester.ensureVisible(find.text(boton));
  await tester.tap(find.text(boton));
  await tester.pump();
}

Finder _aviso(String texto) => find.textContaining(texto, findRichText: true);

Iterable<PeticionApi> _escrituras(ApiFalsa api) =>
    api.peticiones.where((p) => p.metodo == 'POST');

void main() {
  testWidgets('CA_039_01 envía la cotización final una sola vez', (
    tester,
  ) async {
    final respuesta = Completer<http.Response>();
    final api = ApiFalsa((_) => respuesta.future);
    await _montar(tester, api, 'Enviar cotización final');
    await _llenar(tester, '650', 'Cambio de la bomba');
    await _tocar(tester, 'Enviar al cliente');
    expect(find.text('Enviar al cliente'), findsNothing);
    respuesta.complete(jsonOk(_finalEnviada, estado: 201));
    await tester.pumpAndSettle();
    final p = _escrituras(api).single;
    expect(p.ruta, 'visitas/$_visita/cotizacion-final');
    expect(p.json, {'precio': 650, 'descripcion': 'Cambio de la bomba'});
    expect(find.byType(TextField), findsNothing);
  });

  for (final (estado, texto) in [
    (403, 'No tienes permiso'),
    (404, 'ya no está disponible'),
    (409, 'Ahora no se puede enviar'),
    (422, 'Revisa los datos'),
    (429, 'demasiados intentos'),
    (500, 'No pudimos conectar'),
  ]) {
    testWidgets('CA_039_03 un $estado conserva lo escrito', (tester) async {
      final api = ApiFalsa((_) => http.Response('', estado));
      await _montar(tester, api, 'Enviar cotización final');
      await _llenar(tester, '650', 'Cambio de la bomba');
      await _tocar(tester, 'Enviar al cliente');
      await tester.pumpAndSettle();
      expect(_aviso(texto), findsOneWidget);
      expect(find.text('Cambio de la bomba'), findsOneWidget);
      expect(_escrituras(api), hasLength(1));
    });
  }

  testWidgets('CA_039_03 sin red no se reintenta', (tester) async {
    final api = ApiFalsa((_) => throw http.ClientException('sin red'));
    await _montar(tester, api, 'Enviar cotización final');
    await _llenar(tester, '650', 'Cambio de la bomba');
    await _tocar(tester, 'Enviar al cliente');
    await tester.pumpAndSettle();
    expect(_aviso('No pudimos conectar'), findsOneWidget);
    expect(_escrituras(api), hasLength(1));
  });

  testWidgets('CA_039_07 propone al menos 100 pesos sobre el tope', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.metodo == 'GET' ? _trabajo() : jsonOk(_ajuste, estado: 201),
    );
    await _montar(tester, api, 'Proponer otro precio');
    await _llenar(tester, '599', 'Falta una refacción');
    await _tocar(tester, 'Proponer al cliente');
    expect(_escrituras(api), isEmpty);
    await _llenar(tester, '600', 'Falta una refacción');
    await _tocar(tester, 'Proponer al cliente');
    await tester.pumpAndSettle();
    final p = _escrituras(api).single;
    expect(p.ruta, 'cotizaciones/c1/ajuste-precio');
    expect(p.json, {'montoNuevo': 600, 'motivo': 'Falta una refacción'});
  });

  for (final (estado, texto) in [
    (403, 'No tienes permiso'),
    (409, 'Ahora no se puede proponer'),
    (422, 'Revisa los datos'),
    (503, 'No pudimos conectar'),
  ]) {
    testWidgets('CA_039_09 un $estado conserva lo escrito', (tester) async {
      final api = ApiFalsa(
        (p) => p.metodo == 'GET' ? _trabajo() : http.Response('', estado),
      );
      await _montar(tester, api, 'Proponer otro precio');
      await _llenar(tester, '700', 'Falta una refacción');
      await _tocar(tester, 'Proponer al cliente');
      await tester.pumpAndSettle();
      expect(_aviso(texto), findsOneWidget);
      expect(find.text('Falta una refacción'), findsOneWidget);
    });
  }

  for (final (estado, codigo, texto) in [
    (422, 'content_rejected', 'El motivo no se pudo publicar.'),
    (503, 'moderation_unavailable', 'No pudimos revisar el motivo'),
  ]) {
    testWidgets('CA_039_09 $codigo se explica sobre el motivo', (tester) async {
      final api = ApiFalsa(
        (p) => p.metodo == 'GET'
            ? _trabajo()
            : jsonOk({'code': codigo}, estado: estado),
      );
      await _montar(tester, api, 'Proponer otro precio');
      await _llenar(tester, '700', 'Falta una refacción');
      await _tocar(tester, 'Proponer al cliente');
      await tester.pumpAndSettle();
      expect(_aviso(texto), findsOneWidget);
      expect(find.text('Falta una refacción'), findsOneWidget);
      expect(_escrituras(api), hasLength(1));
    });
  }

  testWidgets('CA_039_17 sin cotización aceptada lo dice', (tester) async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'proximasVisitas': <Object>[],
        'cotizacionesEnviadas': <Object>[],
      }),
    );
    await _montar(tester, api, 'Proponer otro precio');
    expect(_aviso('No encontramos la cotización'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('CA_039_17 un error permite reintentar la carga', (tester) async {
    var cargas = 0;
    final api = ApiFalsa(
      (_) => ++cargas == 1 ? http.Response('', 503) : _trabajo(),
    );
    await _montar(tester, api, 'Proponer otro precio');
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
