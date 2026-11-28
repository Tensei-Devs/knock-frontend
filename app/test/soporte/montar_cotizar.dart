// Monta una pantalla de cotizar (specs 046 y 038) con la sesión, el reloj del
// 26 de noviembre de 2026 y el repositorio real sobre una API falsa. Solo datos
// ficticios.
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/trabajo/data/cotizar_repository_api.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'api_falsa.dart';
import 'montar_app.dart';
import 'preparar_maqueta.dart';

Future<void> montarCotizar(
  WidgetTester tester,
  ApiFalsa api,
  Widget hijo, {
  Locale idioma = const Locale('es'),
  double escala = 1,
}) async {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = escala;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        tokensInicialesProvider.overrideWithValue(tokensA),
        relojCotizarProvider.overrideWithValue(() => DateTime(2026, 11, 26)),
        cotizarRepositoryProvider.overrideWithValue(
          CotizarRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: MaterialApp(
        locale: idioma,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: hijo)),
      ),
    ),
  );
  await asentarMaqueta(tester);
}
