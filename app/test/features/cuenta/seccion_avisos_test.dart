import 'package:app/core/notificaciones/registro_dispositivo_controller.dart';
import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/features/cuenta/presentation/widgets/seccion_avisos.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/fakes_notificaciones.dart';

final _es = lookupAppLocalizations(const Locale('es'));

Future<
  ({
    ProviderContainer c,
    GestorPermisosFalso permisos,
    RegistroDispositivosSimulado servidor,
  })
>
_montar(WidgetTester tester, GestorPermisosFalso permisos) async {
  final servidor = RegistroDispositivosSimulado();
  final c = ProviderContainer(
    overrides: [
      gestorPermisosProvider.overrideWithValue(permisos),
      registroDispositivosRepositoryProvider.overrideWithValue(servidor),
      servicioNotificacionesProvider.overrideWithValue(
        ServicioNotificacionesFalso(),
      ),
    ],
  );
  addTearDown(c.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: SeccionAvisos())),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (c: c, permisos: permisos, servidor: servidor);
}

void main() {
  group('CA-012-01 aceptar las notificaciones registra el identificador', () {
    testWidgets('CA_012_01 explica, pide y registra', (tester) async {
      final t = await _montar(tester, GestorPermisosFalso());

      await tester.tap(find.text(_es.avisosActivar));
      await tester.pumpAndSettle();
      expect(find.text(_es.permisoNotificacionesTitulo), findsOneWidget);
      expect(t.permisos.pedidos, isEmpty);

      await tester.tap(find.text(_es.permisoContinuar));
      await tester.pumpAndSettle();

      expect(t.permisos.pedidos, [PermisoApp.notificaciones]);
      expect(t.servidor.registrados, {'id-prueba-1'});
      expect(find.text(_es.avisosActivadas), findsOneWidget);
    });
  });

  group('R-06 y R-07 permiso de notificaciones', () {
    testWidgets('R_012_06 «Ahora no» no muestra la petición del sistema', (
      tester,
    ) async {
      final t = await _montar(tester, GestorPermisosFalso());
      await tester.tap(find.text(_es.avisosActivar));
      await tester.pumpAndSettle();
      await tester.tap(find.text(_es.permisoAhoraNo));
      await tester.pumpAndSettle();

      expect(t.permisos.pedidos, isEmpty);
      expect(t.servidor.registrados, isEmpty);
    });

    testWidgets(
      'R_012_07 negado: la app avisa y las preferencias siguen sirviendo',
      (tester) async {
        final t = await _montar(
          tester,
          GestorPermisosFalso(alPedir: EstadoPermiso.denegado),
        );
        await tester.tap(find.text(_es.avisosActivar));
        await tester.pumpAndSettle();
        await tester.tap(find.text(_es.permisoContinuar));
        await tester.pumpAndSettle();

        expect(find.text(_es.avisosApagadas), findsOneWidget);
        expect(t.servidor.registrados, isEmpty);
        expect(
          t.c.read(registroDispositivoControllerProvider),
          isA<SinRegistrar>(),
        );

        await tester.tap(find.text(_es.avisosMensajes));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<SwitchListTile>(find.byType(SwitchListTile).at(1))
              .value,
          isFalse,
        );
      },
    );

    testWidgets('R_012_07 negado para siempre ofrece abrir los ajustes', (
      tester,
    ) async {
      final t = await _montar(
        tester,
        GestorPermisosFalso(estadoInicial: EstadoPermiso.denegadoParaSiempre),
      );

      expect(find.text(_es.avisosActivar), findsNothing);
      await tester.tap(find.text(_es.avisosAbrirAjustes));
      await tester.pumpAndSettle();

      expect(t.permisos.ajustesAbiertos, 1);
    });

    testWidgets('ACC la sección cumple blancos táctiles y etiquetas', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      await _montar(tester, GestorPermisosFalso());

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      semantica.dispose();
    });
  });
}
