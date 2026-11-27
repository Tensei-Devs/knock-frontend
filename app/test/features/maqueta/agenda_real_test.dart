import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/agenda_real.dart';
import 'package:app/features/visita/domain/agenda.dart';
import 'package:app/features/visita/visita_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Agenda implements AgendaRepository {
  bool falla = false;
  bool vacia = false;
  bool paginar = false;
  String? cursorPedido;

  @override
  Future<PaginaAgenda> listar({String? cursor}) async {
    cursorPedido = cursor;
    if (falla) throw const ServicioNoDisponibleFailure();
    if (vacia) return PaginaAgenda([], null);
    return PaginaAgenda([
      VisitaAgenda(
        id: cursor == null ? 'v1' : 'v2',
        estado: 'confirmada',
        modalidad: 'domicilio',
        fechaHora: DateTime.utc(2026, 11, 27, 12),
        dia: '2026-11-27',
        hora: cursor == null ? '12:00' : '13:00',
        precio: 100,
      ),
    ], paginar && cursor == null ? 'c2' : null);
  }
}

Future<void> _montar(WidgetTester tester, _Agenda repo) => tester.pumpWidget(
  ProviderScope(
    overrides: [agendaRepositoryProvider.overrideWithValue(repo)],
    child: const MaterialApp(
      locale: Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: AgendaReal())),
    ),
  ),
);

void main() {
  testWidgets('CA_040_27 muestra visitas del servidor sin inventar ubicación', (
    tester,
  ) async {
    await _montar(tester, _Agenda());
    await tester.pumpAndSettle();
    expect(find.text('2026-11-27 · 12:00'), findsOneWidget);
    expect(
      find.text('La ubicación de las visitas no está disponible en el mapa.'),
      findsOneWidget,
    );
  });

  testWidgets('permite reintentar un error y muestra agenda vacía', (
    tester,
  ) async {
    final repo = _Agenda()..falla = true;
    await _montar(tester, repo);
    await tester.pumpAndSettle();
    expect(find.text('No pudimos cargar tu agenda.'), findsOneWidget);
    repo
      ..falla = false
      ..vacia = true;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('No tienes visitas próximas.'), findsOneWidget);
  });

  testWidgets('pide y muestra la siguiente página', (tester) async {
    final repo = _Agenda()..paginar = true;
    await _montar(tester, repo);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver más visitas'));
    await tester.pumpAndSettle();
    expect(repo.cursorPedido, 'c2');
    expect(find.text('2026-11-27 · 12:00'), findsOneWidget);
    expect(find.text('2026-11-27 · 13:00'), findsOneWidget);
    expect(find.text('Ver más visitas'), findsNothing);
  });
}
