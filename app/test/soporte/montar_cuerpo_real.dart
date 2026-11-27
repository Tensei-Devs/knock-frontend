import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'montar_app.dart';
import 'preparar_maqueta.dart';

/// Monta solo el cuerpo real de una pantalla, con sesión y [repositorio].
Future<void> montarCuerpoReal(
  WidgetTester tester,
  Override repositorio,
  Widget hijo,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [conSesion(), repositorio],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: hijo)),
      ),
    ),
  );
  await asentarMaqueta(tester);
}
