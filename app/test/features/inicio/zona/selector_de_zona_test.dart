import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/zona/selector_de_zona.dart';
import 'package:app/features/inicio/zona_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../presentation/mapa/fakes_ubicacion.dart';

Future<
  ({
    ProviderContainer c,
    UbicacionFalsa ubicacion,
    List<(double, double)> puntos,
  })
>
_montar(WidgetTester tester, ResultadoUbicacion resultado) async {
  final ubicacion = UbicacionFalsa(resultado);
  final puntos = <(double, double)>[];
  final c = ProviderContainer(
    overrides: [ubicacionRepositoryProvider.overrideWithValue(ubicacion)],
  );
  addTearDown(c.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SelectorDeZona(alUbicar: (lat, lon) => puntos.add((lat, lon))),
        ),
      ),
    ),
  );
  return (c: c, ubicacion: ubicacion, puntos: puntos);
}

void main() {
  final es = AppLocalizationsEsHelper.textos;

  group('CA-012-04 ubicación negada: la app pide el código postal', () {
    for (final (nombre, resultado) in <(String, ResultadoUbicacion)>[
      ('negada', const Denegada()),
      ('negada para siempre', const DenegadaParaSiempre()),
      ('servicio apagado', const ServicioDesactivado()),
    ]) {
      testWidgets('CA_012_04 $nombre muestra el campo del código postal', (
        tester,
      ) async {
        final t = await _montar(tester, resultado);
        expect(find.byType(TextField), findsNothing);

        await tester.tap(find.text(es.zonaUsarUbicacion));
        await tester.pumpAndSettle();
        await tester.tap(find.text(es.permisoContinuar));
        await tester.pumpAndSettle();

        expect(t.ubicacion.llamadas, 1);
        expect(t.c.read(zonaControllerProvider), isA<ZonaPideCodigoPostal>());
        expect(find.text(es.zonaPideCodigoPostal), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });
    }

    testWidgets('CA_012_04 un código postal válido fija la zona', (
      tester,
    ) async {
      final t = await _montar(tester, const Denegada());
      await tester.tap(find.text(es.zonaUsarUbicacion));
      await tester.pumpAndSettle();
      await tester.tap(find.text(es.permisoContinuar));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '42506');
      await tester.tap(find.text(es.zonaContinuar));
      await tester.pumpAndSettle();

      final zona = t.c.read(zonaControllerProvider);
      expect(zona, isA<ZonaPorCodigoPostal>());
      expect((zona as ZonaPorCodigoPostal).codigo, '42506');
    });

    testWidgets('CA_012_04 un código postal inválido no avanza', (
      tester,
    ) async {
      final t = await _montar(tester, const Denegada());
      await tester.tap(find.text(es.zonaUsarUbicacion));
      await tester.pumpAndSettle();
      await tester.tap(find.text(es.permisoContinuar));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '4250');
      await tester.tap(find.text(es.zonaContinuar));
      await tester.pumpAndSettle();

      expect(find.text(es.zonaCodigoPostalInvalido), findsOneWidget);
      expect(t.c.read(zonaControllerProvider), isA<ZonaPideCodigoPostal>());
    });

    test('CA_012_04 solo valen 5 dígitos', () {
      expect(esCodigoPostalValido('42506'), isTrue);
      for (final malo in ['', '4250', '425061', '4250a', '42 06', '١٢٣٤٥']) {
        expect(esCodigoPostalValido(malo), isFalse, reason: malo);
      }
    });
  });

  group('R-06 y R-07 explicación previa y alternativa', () {
    testWidgets(
      'R_012_06 se explica antes de pedir y concedido usa la ubicación',
      (tester) async {
        final t = await _montar(
          tester,
          const Concedida(latitud: 20.27, longitud: -98.99),
        );
        await tester.tap(find.text(es.zonaUsarUbicacion));
        await tester.pumpAndSettle();

        expect(find.text(es.permisoUbicacionTitulo), findsOneWidget);
        expect(find.text(es.permisoUbicacionCuerpo), findsOneWidget);
        expect(t.ubicacion.llamadas, 0, reason: 'aún no se pide al sistema');

        await tester.tap(find.text(es.permisoContinuar));
        await tester.pumpAndSettle();

        expect(t.ubicacion.llamadas, 1);
        expect(t.puntos, [(20.27, -98.99)]);
        expect(t.c.read(zonaControllerProvider), isA<ZonaPorUbicacion>());
        expect(find.byType(TextField), findsNothing);
      },
    );

    testWidgets(
      'R_012_07 «Ahora no» no pide el permiso y ofrece el código postal',
      (tester) async {
        final t = await _montar(tester, const Denegada());
        await tester.tap(find.text(es.zonaUsarUbicacion));
        await tester.pumpAndSettle();
        await tester.tap(find.text(es.permisoAhoraNo));
        await tester.pumpAndSettle();

        expect(t.ubicacion.llamadas, 0);
        expect(find.byType(TextField), findsOneWidget);
      },
    );

    testWidgets(
      'ACC la explicación y el campo tienen texto accesible y blancos táctiles',
      (tester) async {
        final semantica = tester.ensureSemantics();
        await _montar(tester, const Denegada());
        await tester.tap(find.text(es.zonaUsarUbicacion));
        await tester.pumpAndSettle();

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        expect(find.bySemanticsLabel(es.permisoUbicacionTitulo), findsWidgets);

        await tester.tap(find.text(es.permisoAhoraNo));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        semantica.dispose();
      },
    );
  });
}

/// Textos en español sin montar la app.
class AppLocalizationsEsHelper {
  static AppLocalizations get textos =>
      lookupAppLocalizations(const Locale('es'));
}
