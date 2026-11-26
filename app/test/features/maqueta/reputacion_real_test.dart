import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/reputacion_real.dart';
import 'package:app/features/tecnico/domain/reputacion.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repositorio implements ReputacionRepository {
  bool falla = true;
  @override
  Future<Reputacion> obtener() async {
    if (falla) throw const ServicioNoDisponibleFailure();
    return Reputacion(
      promedio: 4.5,
      total: 2,
      distribucion: {5: 1, 4: 1},
      nivel: 'confiable',
    );
  }
}

void main() {
  testWidgets('CA_036_57 permite reintentar y muestra datos reales', (
    tester,
  ) async {
    final repo = _Repositorio();
    await tester.pumpWidget(
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
    await tester.pumpAndSettle();
    expect(find.text('No pudimos cargar las opiniones.'), findsOneWidget);
    repo.falla = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Nivel: Confiable'), findsOneWidget);
    expect(find.text('★ 4.5 de 5'), findsOneWidget);
    expect(find.text('5 estrellas: 1'), findsOneWidget);
  });
}
