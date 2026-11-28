import 'package:app/features/maqueta/conversaciones_reales.dart';
import 'package:app/features/mensajes/domain/conversacion.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/mensajes_falsos.dart';
import '../../../soporte/pantalla_maqueta.dart';

class _Vacio extends ConversacionesDePrueba {
  @override
  Future<ResumenConversaciones> consultar({String? cursor}) async =>
      const ResumenConversaciones(conversaciones: [], totalNoLeidos: 0);
}

Future<void> _montar(WidgetTester tester, ConversacionesDePrueba repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conversacionesRepositoryProvider.overrideWithValue(repo),
        canalMensajesProvider.overrideWithValue(CanalDePrueba()),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(child: ConversacionesReales()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('CA_020_11 sin conversaciones explica cuándo se abre el chat', (
    tester,
  ) async {
    await _montar(tester, _Vacio());
    expect(
      find.text(
        'Aún no tienes conversaciones. El chat se abre al recibir '
        'cotizaciones.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('CA_020_17 cada conversación se lee junta y cabe al 200 %', (
    tester,
  ) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final semantica = tester.ensureSemantics();
    await _montar(tester, ConversacionesDePrueba());
    expect(
      find.bySemanticsLabel(RegExp(r'Ana\s+Plomería\s+1 mensaje sin leer')),
      findsOneWidget,
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });
}
