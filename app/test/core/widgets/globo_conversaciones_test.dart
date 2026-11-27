import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/widgets/globo_conversaciones.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/mensajes_falsos.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_020_08 contador con tope 9+, etiqueta y texto al 200 %', (
    tester,
  ) async {
    fijarPantalla(tester);
    final semantica = tester.ensureSemantics();
    var toques = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: Center(
              child: GloboConversaciones(
                total: 12,
                alTocar: () => toques++,
                fondo: Colors.indigo,
                insignia: Colors.red,
                borde: Colors.white,
                trazo: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('9+'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Mensajes, 12 mensajes sin leer'),
      findsOneWidget,
    );
    final lado = tester.getSize(find.byType(GloboConversaciones)).shortestSide;
    expect(lado, greaterThanOrEqualTo(48));
    await tester.tap(find.byType(GloboConversaciones));
    expect(toques, 1);
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });

  testWidgets('CA_020_12 está en las cinco pestañas y no fuera de ellas', (
    tester,
  ) async {
    fijarPantalla(tester, tamano: tamanoMovil);
    final contenedor = await montarApp(
      tester,
      esTecnico: true,
      maqueta: true,
      extra: [
        solicitudesRealesActivasProvider.overrideWithValue(true),
        canalMensajesProvider.overrideWithValue(CanalDePrueba()),
        conversacionesRepositoryProvider.overrideWithValue(
          ConversacionesDePrueba(),
        ),
      ],
    );
    final router = contenedor.read(appRouterProvider);
    for (final ruta in [
      Rutas.inicio,
      Rutas.explorar,
      Rutas.actividad,
      Rutas.trabajo,
      Rutas.cuenta,
    ]) {
      router.go(ruta);
      await asentarMaqueta(tester);
      expect(find.byType(GloboConversaciones), findsOneWidget, reason: ruta);
    }
    for (final ruta in [RM.mensajes, Rutas.completarPerfil]) {
      router.go(ruta);
      await asentarMaqueta(tester);
      expect(find.byType(GloboConversaciones), findsNothing, reason: ruta);
    }
  });
}
