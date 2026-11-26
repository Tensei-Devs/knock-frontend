import 'package:app/features/maqueta/agenda_real.dart';
import 'package:app/features/visita/domain/agenda.dart';
import 'package:app/features/visita/visita_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Agenda implements AgendaRepository {
  @override
  Future<PaginaAgenda> listar({String? cursor}) async => PaginaAgenda([
    VisitaAgenda(
      id: 'v1',
      estado: 'confirmada',
      modalidad: 'domicilio',
      fechaHora: DateTime.utc(2026, 11, 27, 12),
      dia: '2026-11-27',
      hora: '12:00',
      precio: 100,
    ),
  ], null);
}

void main() {
  testWidgets('CA_040_27 muestra visitas del servidor sin inventar ubicación', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [agendaRepositoryProvider.overrideWithValue(_Agenda())],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SingleChildScrollView(child: AgendaReal())),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('2026-11-27 · 12:00'), findsOneWidget);
    expect(
      find.text('La ubicación de las visitas no está disponible en el mapa.'),
      findsOneWidget,
    );
  });
}
