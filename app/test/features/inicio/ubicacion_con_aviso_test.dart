// Spec 012, R-06, R-07 y CA-04: la ubicación se pide con un aviso previo y, si
// la persona dice «Ahora no», no se llega a la petición del sistema.
import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/domain/ubicar_con_aviso.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/colonia_controller.dart';
import 'package:app/features/inicio/presentation/mapa/mi_ubicacion_controller.dart';
import 'package:app/features/inicio/presentation/mapa/boton_mi_ubicacion.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'presentation/mapa/fakes_ubicacion.dart';

const _punto = Concedida(latitud: 20.06, longitud: -99.34);

void main() {
  group('ubicarConAviso', () {
    test(
      'CA_04 sin permiso y con «Ahora no» no pide nada al sistema',
      () async {
        final repo = UbicacionFalsa(_punto, permiso: false);
        var avisos = 0;
        final r = await ubicarConAviso(repo, () async {
          avisos++;
          return false;
        });
        expect(avisos, 1);
        expect(r, isA<Denegada>());
        expect(repo.llamadas, 0);
      },
    );

    test('R_012_06 sin permiso explica primero y luego pide', () async {
      final repo = UbicacionFalsa(_punto, permiso: false);
      var avisos = 0;
      final r = await ubicarConAviso(repo, () async {
        avisos++;
        expect(repo.llamadas, 0, reason: 'el aviso va antes de la petición');
        return true;
      });
      expect(avisos, 1);
      expect(r, isA<Concedida>());
      expect(repo.llamadas, 1);
    });

    test('R_012_06 con el permiso ya concedido no repite el aviso', () async {
      final repo = UbicacionFalsa(_punto);
      final r = await ubicarConAviso(repo, () async => fail('sin aviso'));
      expect(r, isA<Concedida>());
      expect(repo.llamadas, 1);
    });

    test('R_012_06 ubicarSiHayPermiso nunca pide el permiso', () async {
      final sin = UbicacionFalsa(_punto, permiso: false);
      expect(await ubicarSiHayPermiso(sin), isA<Denegada>());
      expect(sin.llamadas, 0);
      final con = UbicacionFalsa(_punto);
      expect(await ubicarSiHayPermiso(con), isA<Concedida>());
    });
  });

  group('controladores', () {
    ProviderContainer contenedor(UbicacionFalsa ubicacion) {
      final c = ProviderContainer(
        overrides: [ubicacionRepositoryProvider.overrideWithValue(ubicacion)],
      );
      addTearDown(c.dispose);
      return c;
    }

    test(
      'CA_04 «Mi ubicación» con «Ahora no» avisa y sigue sin ubicación',
      () async {
        final ubicacion = UbicacionFalsa(_punto, permiso: false);
        final camara = CamaraFalsa();
        final c = contenedor(ubicacion);
        await c
            .read(miUbicacionControllerProvider.notifier)
            .centrar(camara, explicar: () async => false);
        expect(ubicacion.llamadas, 0);
        expect(camara.movimientos, isEmpty);
        expect(
          c.read(miUbicacionControllerProvider),
          AvisoUbicacion.sinPermiso,
        );
      },
    );

    test('CA_04 la colonia con «Ahora no» queda sin ubicación', () async {
      final ubicacion = UbicacionFalsa(_punto, permiso: false);
      final c = contenedor(ubicacion);
      await c
          .read(coloniaControllerProvider.notifier)
          .consultar(explicar: () async => false);
      expect(ubicacion.llamadas, 0);
      expect(c.read(coloniaControllerProvider), isA<ColoniaSinUbicacion>());
    });
  });

  group('botón «Mi ubicación»', () {
    Future<void> montar(WidgetTester t, UbicacionFalsa u) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: [ubicacionRepositoryProvider.overrideWithValue(u)],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es'),
            home: Scaffold(
              floatingActionButton: BotonMiUbicacion(camara: CamaraFalsa()),
            ),
          ),
        ),
      );
      await t.tap(find.byTooltip(BotonMiUbicacion.etiqueta));
      await t.pumpAndSettle();
    }

    testWidgets('CA_04 explica el motivo y «Ahora no» no pide el permiso', (
      t,
    ) async {
      final u = UbicacionFalsa(_punto, permiso: false);
      await montar(t, u);
      expect(find.text('¿Usar tu ubicación?'), findsOneWidget);
      expect(find.textContaining('código postal'), findsOneWidget);
      await t.tap(find.text('Ahora no'));
      await t.pumpAndSettle();
      expect(u.llamadas, 0);
      expect(
        find.byType(SnackBar),
        findsOneWidget,
        reason: 'sigue sin bloqueo',
      );
      expect(find.byTooltip(BotonMiUbicacion.etiqueta), findsOneWidget);
    });

    testWidgets('R_012_06 «Continuar» pide la ubicación', (t) async {
      final u = UbicacionFalsa(_punto, permiso: false);
      await montar(t, u);
      await t.tap(find.text('Continuar'));
      await t.pumpAndSettle();
      expect(u.llamadas, 1);
    });
  });
}
