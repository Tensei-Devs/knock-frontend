// Spec 046 (CA-02, CA-04 a CA-09), 019 (entrada) y 038 (CA-10, CA-14).
import 'dart:async';

import 'package:app/features/maqueta/bandeja_trabajo_real.dart';
import 'package:app/features/maqueta/cotizar_real.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/cotizar_json.dart';
import '../../soporte/fecha_esperada.dart';
import '../../soporte/montar_cotizar.dart';
import '../../soporte/preparar_maqueta.dart';

/// API falsa: el detalle y la lista responden bien; el envío, según [envio].
ApiFalsa _api({
  FutureOr<http.Response> Function()? envio,
  int estadoDetalle = 200,
  List<Object?> propias = const [],
}) => ApiFalsa((p) {
  if (p.metodo == 'POST') {
    return envio?.call() ?? jsonOk(cotizacionJson(), estado: 201);
  }
  if (p.ruta == 'tecnicos/me/cotizaciones') {
    return jsonOk({'items': propias, 'nextCursor': null});
  }
  if (p.ruta == 'cotizaciones/referencia-mercado') {
    return jsonOk({'origen': 'sin_datos'});
  }
  if (p.ruta == 'tecnicos/me/solicitudes') {
    return jsonOk({
      'items': [recibidaJson()],
      'nextCursor': null,
    });
  }
  return jsonOk(detalleJson(), estado: estadoDetalle);
});

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api,
  Widget hijo, {
  Locale idioma = const Locale('es'),
  double escala = 1,
}) => montarCotizar(tester, api, hijo, idioma: idioma, escala: escala);

const _pantalla = CotizarReal(solicitudId: 's1');

Future<void> _llenar(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, '350');
  await tester.tap(
    find.text(fechaEsperada(tester, CotizarReal, DateTime(2026, 11, 27))),
  );
  await tester.enterText(find.byType(TextField).last, '09:30');
  await tester.pump();
}

Future<void> _enviar(WidgetTester tester) async {
  await tester.tap(find.text('Enviar cotización'));
  await asentarMaqueta(tester);
}

int _envios(ApiFalsa api) =>
    api.peticiones.where((p) => p.metodo == 'POST').length;

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_019_04 cerrar la confirmación no descarta', (tester) async {
    final api = _api();
    await _montar(tester, api, const SolicitudesNuevasReal());

    await tester.tap(find.text('Descartar'));
    await asentarMaqueta(tester);
    await tester.tap(find.text('Conservar solicitud'));
    await asentarMaqueta(tester);

    expect(_envios(api), 0);
    expect(find.text('Descartar'), findsOneWidget);
  });

  for (final estado in [204, 404, 409, 503]) {
    testWidgets('CA_019_03 el descarte responde $estado', (tester) async {
      var descartada = false;
      final api = ApiFalsa((p) {
        if (p.metodo == 'POST') {
          expect(p.ruta, 'solicitudes/s1/descartar');
          expect(p.cuerpo, isEmpty);
          descartada = estado == 204;
          return switch (estado) {
            204 => http.Response('', 204),
            409 => jsonOk({'code': 'request_not_dismissable'}, estado: estado),
            _ => jsonOk({}, estado: estado),
          };
        }
        return jsonOk({
          'items': [if (!descartada) recibidaJson()],
          'nextCursor': null,
        });
      });
      await _montar(tester, api, const SolicitudesNuevasReal());

      await tester.tap(find.text('Descartar'));
      await asentarMaqueta(tester);
      await tester.tap(find.text('Sí, descartar'));
      await asentarMaqueta(tester);

      expect(_envios(api), 1);
      expect(
        find.text('Descartar'),
        estado == 503 ? findsOneWidget : findsNothing,
      );
      if (estado == 204) {
        ProviderScope.containerOf(
          tester.element(find.byType(SolicitudesNuevasReal)),
        ).read(solicitudesRecibidasProvider.notifier).reintentar();
        await asentarMaqueta(tester);
        expect(find.text('Descartar'), findsNothing);
      }
      if (estado == 409) {
        expect(
          find.text('Esta solicitud ya no se puede descartar.'),
          findsOneWidget,
        );
      }
    });
  }

  testWidgets('CA_046_02 un 404 no distingue la causa', (tester) async {
    await _montar(tester, _api(estadoDetalle: 404), _pantalla);
    expect(find.text('Esta solicitud ya no está disponible.'), findsOneWidget);
    expect(find.text('Enviar cotización'), findsNothing);
  });

  testWidgets('CA_046_03 muestra los errores y no envía', (tester) async {
    final api = _api();
    await _montar(tester, api, _pantalla);
    await _enviar(tester);
    expect(find.text('Elige un día.'), findsOneWidget);
    await tester.tap(find.text('Rango'));
    await tester.pump();
    expect(find.text('Máximo en pesos'), findsOneWidget);
    expect(_envios(api), 0);
  });

  testWidgets('CA_046_04 muestra el tope del servidor y vuelve a leer', (
    tester,
  ) async {
    final api = _api();
    await _montar(tester, api, _pantalla);
    await _llenar(tester);
    await _enviar(tester);
    expect(find.text('Cotización enviada'), findsOneWidget);
    expect(find.text(r'Tope: $400'), findsOneWidget);
    expect(
      find.text('El cliente tendrá que aprobar el precio final.'),
      findsOneWidget,
    );
    expect(
      api.llamadas.where((l) => l == 'GET tecnicos/me/cotizaciones'),
      hasLength(2),
    );
  });

  for (final (codigo, texto) in [
    ('request_not_quotable', 'Esta solicitud ya no admite cotizaciones.'),
    ('quote_duplicate', 'Ya enviaste una cotización para esta solicitud.'),
    ('quote_quota_full', 'Esta solicitud ya tiene el máximo de cotizaciones.'),
  ]) {
    testWidgets('CA_046_05 $codigo ya no ofrece enviar', (tester) async {
      final api = _api(envio: () => jsonOk({'code': codigo}, estado: 409));
      await _montar(tester, api, _pantalla);
      await _llenar(tester);
      await _enviar(tester);
      expect(find.text(texto), findsOneWidget);
      expect(find.text('Enviar cotización'), findsNothing);
    });
  }

  for (final (estado, codigo) in [(404, null), (409, 'quote_quota_full')]) {
    testWidgets('un $estado al enviar vuelve a leer las dos listas', (
      tester,
    ) async {
      final api = _api(envio: () => jsonOk({'code': ?codigo}, estado: estado));
      await _montar(
        tester,
        api,
        const Column(children: [_pantalla, SolicitudesNuevasReal()]),
      );
      await _llenar(tester);
      await _enviar(tester);
      for (final ruta in ['cotizaciones', 'solicitudes']) {
        expect(
          api.llamadas.where((l) => l == 'GET tecnicos/me/$ruta'),
          hasLength(2),
          reason: ruta,
        );
      }
    });
  }

  testWidgets('el precio de la visita muestra y valida el rango', (
    tester,
  ) async {
    final api = _api();
    await _montar(tester, api, _pantalla);
    await tester.tap(find.text('Por visita'));
    await tester.pump();
    expect(find.textContaining('De 100 a 250 pesos.'), findsOneWidget);
    await _llenar(tester);
    await _enviar(tester);
    expect(
      find.textContaining('Escribe un número entero de 100 a 250.'),
      findsOneWidget,
    );
    expect(_envios(api), 0);
  });

  testWidgets('los días salen del día de la solicitud', (tester) async {
    await _montar(tester, _api(), _pantalla);
    // 3 tipos de precio y 8 días desde el 27, no desde la creación (26).
    expect(find.byType(ChoiceChip), findsNWidgets(3 + 8));
  });

  for (final (estado, codigo) in [
    (400, null),
    (413, null),
    (422, 'content_rejected'),
    (429, null),
    (503, 'moderation_unavailable'),
  ]) {
    testWidgets('CA_046_06 un $estado conserva lo escrito', (tester) async {
      final api = _api(envio: () => jsonOk({'code': ?codigo}, estado: estado));
      await _montar(tester, api, _pantalla);
      await _llenar(tester);
      await _enviar(tester);
      expect(find.text('350'), findsOneWidget);
      expect(find.text('09:30'), findsOneWidget);
      expect(find.text('Enviar cotización'), findsOneWidget);
      expect(_envios(api), 1);
    });
  }

  testWidgets('CA_046_07 sin perfil de técnico no hay formulario', (
    tester,
  ) async {
    final api = ApiFalsa(
      (_) => jsonOk({'code': 'not_a_technician'}, estado: 403),
    );
    await _montar(tester, api, _pantalla);
    expect(
      find.text('Necesitas un perfil de técnico para ver esto.'),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('CA_046_08 un segundo toque no manda otra petición', (
    tester,
  ) async {
    final respuesta = Completer<http.Response>();
    final api = _api(envio: () => respuesta.future);
    await _montar(tester, api, _pantalla);
    await _llenar(tester);
    await tester.tap(find.text('Enviar cotización'));
    await tester.pump();
    await tester.tap(find.byType(CotizarReal), warnIfMissed: false);
    await tester.pump();
    expect(_envios(api), 1);
    respuesta.completeError(http.ClientException('sin red'));
    await asentarMaqueta(tester);
    expect(_envios(api), 1);
  });

  testWidgets('una ya cotizada muestra la cotización propia', (tester) async {
    await _montar(tester, _api(propias: [cotizacionJson()]), _pantalla);
    expect(find.text(r'Precio fijo · $350'), findsOneWidget);
    expect(find.text('Enviar cotización'), findsNothing);
  });

  testWidgets('CA_046_09 inglés, texto al 200 % y objetivos de 48 dp', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await _montar(
      tester,
      _api(),
      _pantalla,
      idioma: const Locale('en'),
      escala: 2,
    );
    expect(find.text('Send quote'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantica.dispose();
  });

  testWidgets('019 las solicitudes nuevas ofrecen cotizar', (tester) async {
    await _montar(tester, _api(), const SolicitudesNuevasReal());
    expect(find.text('Plomería · Centro'), findsOneWidget);
    expect(find.text('Ver y cotizar'), findsOneWidget);
  });

  testWidgets('CA_038_14 vacío, 403 y sin conexión con reintentar', (
    tester,
  ) async {
    await _montar(tester, _api(), const CotizacionesEnviadasReal());
    expect(find.text('Todavía no has enviado cotizaciones.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await _montar(
      tester,
      ApiFalsa((_) => jsonOk(<String, Object?>{}, estado: 403)),
      const CotizacionesEnviadasReal(),
    );
    expect(find.text('No tienes permiso para hacer esto.'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await _montar(
      tester,
      ApiFalsa((_) => throw http.ClientException('sin red')),
      const CotizacionesEnviadasReal(),
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
