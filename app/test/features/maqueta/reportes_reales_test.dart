// Spec 033 y 045: «Reportar un problema» y «Mis reportes» con la API.
import 'dart:async';

import 'package:app/features/maqueta/reportes_reales.dart';
import 'package:app/features/reportes/data/reportes_repository_api.dart';
import 'package:app/features/reportes/reportes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/montar_cuerpo_real.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/reportes_json.dart';

ReportesRepositoryApi _repo(ApiFalsa api) =>
    ReportesRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

Future<void> _montarFormulario(WidgetTester tester, ApiFalsa api) async {
  tester.view.physicalSize = const Size(412, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        reportesRepositoryProvider.overrideWithValue(_repo(api)),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ReportarReal(visitaId: 'v-1', trabajo: 'Trabajo de ejemplo'),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

Future<void> _tocar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto));
  await asentarMaqueta(tester);
  await tester.tap(find.text(texto));
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_033_12 un rechazo conserva lo escrito y luego se envía', (
    tester,
  ) async {
    var rechazar = true;
    final api = ApiFalsa((p) {
      if (p.metodo == 'GET') return jsonOk(visitaParaReportarJson('u-2'));
      return rechazar
          ? jsonOk({'code': 'report_content_rejected'}, estado: 422)
          : jsonOk({
              'reporteId': 'r-1',
              'estado': 'abierto',
              'creadoEn': '2026-11-20T18:00:00Z',
              'avisoEmergencia': 'Llama al 911 ahora.',
            }, estado: 201);
    });
    await _montarFormulario(tester, api);
    expect(find.textContaining('Técnico de ejemplo'), findsOneWidget);

    await _tocar(tester, 'Peligro');
    await tester.enterText(find.byType(TextField), 'Texto de ejemplo');
    await asentarMaqueta(tester);
    await _tocar(tester, 'Enviar reporte');
    expect(find.text('Texto de ejemplo'), findsOneWidget);
    expect(find.text('Enviar reporte'), findsOneWidget);

    rechazar = false;
    await _tocar(tester, 'Enviar reporte');

    expect(find.text('Recibimos tu reporte'), findsOneWidget);
    expect(find.text('Llama al 911 ahora.'), findsOneWidget);
  });

  testWidgets('CA_033_22 error con Reintentar y visita sin cuenta', (
    tester,
  ) async {
    var falla = true;
    final api = ApiFalsa(
      (_) =>
          falla ? http.Response('', 503) : jsonOk(visitaParaReportarJson(null)),
    );
    await _montarFormulario(tester, api);
    expect(find.text('Reintentar'), findsOneWidget);

    falla = false;
    await _tocar(tester, 'Reintentar');

    expect(
      find.textContaining('No es posible reportar desde esta visita'),
      findsOneWidget,
    );
    expect(find.textContaining('911'), findsOneWidget);
  });

  testWidgets('CA_033_24 mis reportes: error, reintento y vacío', (
    tester,
  ) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla
          ? http.Response('', 500)
          : jsonOk(paginaDeReportesJson([], null)),
    );
    await montarCuerpoReal(
      tester,
      reportesRepositoryProvider.overrideWithValue(_repo(api)),
      const MisReportesReales(),
    );

    falla = false;
    await _tocar(tester, 'Reintentar');

    expect(find.text('No has hecho reportes.'), findsOneWidget);
  });

  testWidgets('CA_033_23 mis reportes: carga y luego vacío', (tester) async {
    final respuesta = Completer<http.Response>();
    final api = ApiFalsa((_) => respuesta.future);
    await montarCuerpoReal(
      tester,
      reportesRepositoryProvider.overrideWithValue(_repo(api)),
      const MisReportesReales(),
    );
    expect(find.text('Cargando tus reportes…'), findsOneWidget);

    respuesta.complete(jsonOk(paginaDeReportesJson([], null)));
    await asentarMaqueta(tester);
    expect(find.text('No has hecho reportes.'), findsOneWidget);
  });

  testWidgets('CA_033_16 apela una decisión', (tester) async {
    final api = ApiFalsa(
      (p) => p.metodo == 'POST'
          ? http.Response('', 200)
          : jsonOk(paginaDeReportesJson(['r-1'], null, puedeApelar: true)),
    );
    await montarCuerpoReal(
      tester,
      reportesRepositoryProvider.overrideWithValue(_repo(api)),
      const MisReportesReales(),
    );

    await _tocar(tester, 'Apelar la decisión');
    await tester.enterText(find.byType(TextField), 'Motivo de ejemplo');
    await asentarMaqueta(tester);
    await _tocar(tester, 'Enviar apelación');

    expect(api.llamadas, contains('POST reportes/r-1/apelacion'));
    await tester.pump(const Duration(seconds: 10));
  });
}
