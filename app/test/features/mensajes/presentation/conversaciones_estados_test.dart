import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/conversaciones_reales.dart';
import 'package:app/features/maqueta/globo_real.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/api_falsa.dart';
import '../../../soporte/mensajes_falsos.dart';

void main() {
  late CanalDePrueba canal;
  late ConversacionesDePrueba repo;

  setUp(() {
    canal = CanalDePrueba();
    repo = ConversacionesDePrueba();
  });

  ProviderContainer contenedor() {
    final c = contenedorConApi(
      ApiFalsa((_) => jsonOk({})),
      extra: [
        canalMensajesProvider.overrideWithValue(canal),
        conversacionesRepositoryProvider.overrideWithValue(repo),
        solicitudesRealesActivasProvider.overrideWithValue(true),
      ],
    );
    c.listen(globoProvider, (_, _) {});
    return c;
  }

  testWidgets('CA_020_14 canal caído: contador congelado y sin bucle', (
    tester,
  ) async {
    final c = contenedor();
    addTearDown(c.dispose);
    await tester.pump();
    canal.error = Exception('sin red');
    repo.total = 9;
    canal.caer();
    expect(c.read(globoProvider).sinConexion, isTrue);
    expect(c.read(globoProvider).total, 3);

    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(seconds: 30));
    }
    // La primera apertura y tres reintentos acotados.
    expect(canal.aperturas, 4);

    canal.error = null;
    unawaited(c.read(globoProvider.notifier).reintentar());
    await tester.pump();
    expect(c.read(globoProvider).conectado, isTrue);
    expect(c.read(globoProvider).total, 9);
    c.dispose();
  });

  testWidgets('un 429 espera lo que pide Retry-After', (tester) async {
    repo.error = const DemasiadosIntentosFailure(espera: Duration(seconds: 90));
    final c = contenedor();
    addTearDown(c.dispose);
    await tester.pump();
    repo.error = null;
    await tester.pump(const Duration(seconds: 89));
    expect(canal.aperturas, 0);
    await tester.pump(const Duration(seconds: 2));
    expect(canal.aperturas, 1);
    c.dispose();
  });

  test('CA_020_16 al cerrar sesión se borra el contador y se cierra', () async {
    final c = contenedor();
    addTearDown(c.dispose);
    await pumpEventQueue();
    expect(c.read(globoProvider).total, 3);

    await c.read(sesionProvider.notifier).cerrar();
    await pumpEventQueue();
    expect(c.read(globoProvider).total, isNull);
    expect(c.read(globoProvider).conectado, isFalse);
    expect(canal.cierres, greaterThan(0));
  });

  testWidgets(
    'CA_020_14 la lista y Actividad avisan Sin conexión y reintentan',
    (tester) async {
      canal.error = Exception('sin red');
      final c = contenedor();
      addTearDown(c.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: const MaterialApp(
            locale: Locale('es'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [AvisoCanalCaido(), ConversacionesReales()],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Sin conexión'), findsNWidgets(2));
      expect(find.text('Plomería'), findsOneWidget);

      canal.error = null;
      await tester.tap(find.text('Reintentar').first);
      await tester.pumpAndSettle();
      expect(find.text('Sin conexión'), findsNothing);

      // Con el canal arriba, un cambio del contador vuelve a pedir la lista.
      final consultas = repo.consultas;
      canal.emitir(7);
      await tester.pumpAndSettle();
      expect(repo.consultas, consultas + 1);
      c.dispose();
    },
  );
}
