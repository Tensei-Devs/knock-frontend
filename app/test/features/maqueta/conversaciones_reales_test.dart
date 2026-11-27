import 'package:app/features/maqueta/conversaciones_reales.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/pantallas_actividad.dart'
    show MensajesScreen;
import 'package:app/features/maqueta/pantallas_tecnico.dart'
    show TecMensajesScreen;
import 'package:app/features/mensajes/domain/conversacion.dart';
import 'package:app/features/mensajes/domain/conversaciones_repository.dart';
import 'package:app/features/mensajes/mensajes_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repositorio implements ConversacionesRepository {
  String? cursorPedido;
  @override
  Future<int> contador() async => 12;
  @override
  Future<ResumenConversaciones> consultar({String? cursor}) async {
    cursorPedido = cursor;
    return ResumenConversaciones(
      conversaciones: [
        Conversacion(
          id: cursor == null ? 'c1' : 'c2',
          solicitudId: 's',
          rol: 'cliente',
          estado: 'abierta',
          contraparte: const ContraparteConversacion(nombre: 'Ana'),
          servicio: cursor == null ? 'Plomería' : 'Mecánica',
          noLeidos: 1,
        ),
      ],
      totalNoLeidos: 2,
      siguiente: cursor == null ? 'c2' : null,
    );
  }
}

void main() {
  testWidgets('lista datos y pagina sin abrir ni marcar mensajes', (
    tester,
  ) async {
    final repo = _Repositorio();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [conversacionesRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(child: ConversacionesReales()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Plomería'), findsOneWidget);
    expect(find.text('Sin conexión'), findsOneWidget);
    await tester.tap(find.text('Ver más'));
    await tester.pumpAndSettle();
    expect(repo.cursorPedido, 'c2');
    expect(find.text('Mecánica'), findsOneWidget);
  });

  testWidgets('las pantallas de cliente y técnico muestran la lista real', (
    tester,
  ) async {
    for (final pantalla in [
      const MensajesScreen(),
      const TecMensajesScreen(),
    ]) {
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            conversacionesRepositoryProvider.overrideWithValue(_Repositorio()),
            solicitudesRealesActivasProvider.overrideWithValue(true),
          ],
          child: MaterialApp(
            locale: const Locale('es'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: pantalla,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ConversacionesReales), findsOneWidget);
      expect(find.text('Plomería'), findsOneWidget);
    }
  });
}
