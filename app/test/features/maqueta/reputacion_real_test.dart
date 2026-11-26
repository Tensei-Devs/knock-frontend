import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/reputacion_real.dart';
import 'package:app/features/tecnico/domain/reputacion.dart';
import 'package:app/features/tecnico/presentation/reputacion_controller.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repositorio implements ReputacionRepository {
  bool falla = true;
  Completer<Reputacion>? pendiente;
  @override
  Future<Reputacion> obtener() async {
    if (pendiente case final p?) return p.future;
    if (falla) throw const ServicioNoDisponibleFailure();
    return Reputacion(
      promedio: 4.5,
      total: 2,
      distribucion: {5: 1, 4: 1},
      nivel: 'confiable',
    );
  }
}

Future<void> _montar(WidgetTester tester, _Repositorio repo) =>
    tester.pumpWidget(
      ProviderScope(
        overrides: [reputacionRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SingleChildScrollView(child: ReputacionReal())),
        ),
      ),
    );

void main() {
  testWidgets('CA_036_57 permite reintentar y muestra datos reales', (
    tester,
  ) async {
    final repo = _Repositorio();
    await _montar(tester, repo);
    await tester.pumpAndSettle();
    expect(find.text('No pudimos cargar las opiniones.'), findsOneWidget);
    repo.falla = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Nivel: Confiable'), findsOneWidget);
    expect(find.text('★ 4.5 de 5'), findsOneWidget);
    expect(find.text('5 estrellas: 1'), findsOneWidget);
  });

  testWidgets('muestra carga y estado vacío sin inventar promedio', (
    tester,
  ) async {
    final repo = _Repositorio()..pendiente = Completer<Reputacion>();
    await _montar(tester, repo);
    expect(find.text('Cargando las opiniones…'), findsOneWidget);
    repo.pendiente!.complete(
      Reputacion(promedio: null, total: 0, distribucion: {}, nivel: 'nuevo'),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Aún sin opiniones'), findsOneWidget);
    expect(find.text('0 opiniones'), findsOneWidget);
    expect(find.textContaining('de 5'), findsNothing);
  });

  testWidgets('muestra copia fechada tras perder la conexión', (tester) async {
    final repo = _Repositorio()..falla = false;
    await _montar(tester, repo);
    await tester.pumpAndSettle();
    repo.falla = true;
    final context = tester.element(find.byType(ReputacionReal));
    final container = ProviderScope.containerOf(context);
    container.read(reputacionControllerProvider.notifier).reintentar();
    await tester.pumpAndSettle();
    expect(find.textContaining('Sin conexión.'), findsOneWidget);
    expect(find.text('★ 4.5 de 5'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
