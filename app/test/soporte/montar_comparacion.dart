import 'package:app/core/tema/tema.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/presentation/cotizaciones_screen.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'solicitud_falsa.dart';

/// Monta la pantalla de comparación de cotizaciones con los dobles de prueba.
Future<void> montarComparacion(
  WidgetTester tester,
  SolicitudesFalsas solicitudes, {
  required String id,
  bool visitaDisponible = false,
}) async {
  final contenedor = ProviderContainer(
    overrides: [
      ...dobles(solicitudes: solicitudes, borrador: BorradorFalso()),
      visitaDisponibleProvider.overrideWithValue(visitaDisponible),
    ],
  );
  addTearDown(contenedor.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: contenedor,
      child: MaterialApp(
        theme: temaClaro,
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: CotizacionesScreen(solicitudId: id),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
