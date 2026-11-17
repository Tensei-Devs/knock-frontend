// Spec 026 (R-09, R-11) y spec 045 (enmienda 1): «Dónde está abierta tu
// cuenta» muestra las sesiones reales, permite cerrar las demás y nunca cierra
// la de este teléfono desde aquí.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/sesion_dispositivo.dart';
import 'package:app/features/cuenta/domain/sesiones_repository.dart';
import 'package:app/features/maqueta/sesiones_reales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/preparar_maqueta.dart';

class _SesionesFalso implements SesionesRepository {
  _SesionesFalso(this.respuestas);

  /// Cada `listar` toma la siguiente respuesta; una excepción hace fallar.
  final List<Object> respuestas;
  int listados = 0;
  final cerradas = <String>[];
  Failure? falloAlCerrar;

  @override
  Future<List<SesionDispositivo>> listar() async {
    final r = respuestas[listados < respuestas.length ? listados : 0];
    listados++;
    if (r is Exception) throw r;
    return r as List<SesionDispositivo>;
  }

  @override
  Future<void> cerrar(String id) async {
    if (falloAlCerrar != null) throw falloAlCerrar!;
    cerradas.add(id);
  }
}

final _ahora = DateTime.now();

final _aqui = SesionDispositivo(
  id: 'a',
  dispositivo: 'Samsung Galaxy A54',
  ultimaActividad: _ahora,
  actual: true,
);
final _otra = SesionDispositivo(
  id: 'b',
  dispositivo: 'Navegador en computadora',
  ultimaActividad: _ahora.subtract(const Duration(days: 3, hours: 1)),
  actual: false,
);

Future<void> _montar(WidgetTester tester, _SesionesFalso repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sesionesRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: SesionesAbiertas())),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_045_10 muestra las sesiones del servidor y marca la actual', (
    tester,
  ) async {
    await _montar(
      tester,
      _SesionesFalso([
        [_aqui, _otra],
      ]),
    );
    expect(find.text('Samsung Galaxy A54'), findsOneWidget);
    expect(find.text('Aquí'), findsOneWidget);
    expect(find.text('Navegador en computadora'), findsOneWidget);
    expect(find.text('hace 3 días'), findsOneWidget);
    // Solo la otra sesión se puede cerrar.
    expect(find.text('Cerrar'), findsOneWidget);
  });

  testWidgets('CA_045_10 cerrar otra sesión la quita de la lista', (
    tester,
  ) async {
    final repo = _SesionesFalso([
      [_aqui, _otra],
    ]);
    await _montar(tester, repo);
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    expect(repo.cerradas, ['b']);
    expect(find.text('Navegador en computadora'), findsNothing);
    expect(find.text('Samsung Galaxy A54'), findsOneWidget);
  });

  testWidgets('CA_045_12 si cerrar falla, la sesión sigue en la lista', (
    tester,
  ) async {
    final repo = _SesionesFalso([
      [_aqui, _otra],
    ])..falloAlCerrar = const ServicioNoDisponibleFailure();
    await _montar(tester, repo);
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    expect(find.text('Navegador en computadora'), findsOneWidget);
  });

  testWidgets('CA_045_12 si falla la carga, no se inventan sesiones y '
      'Reintentar las pide de nuevo', (tester) async {
    final repo = _SesionesFalso([
      const ServicioNoDisponibleFailure(),
      [_aqui],
    ]);
    await _montar(tester, repo);
    expect(find.text('No pudimos cargar tus sesiones.'), findsOneWidget);
    expect(find.text('Samsung Galaxy A54'), findsNothing);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('No pudimos cargar tus sesiones.'), findsNothing);
    expect(find.text('Samsung Galaxy A54'), findsOneWidget);
    expect(repo.listados, 2);
  });

  test('CA_045_10 el tiempo relativo habla en español', () {
    final t = DateTime(2026, 11, 17, 12);
    expect(haceTiempo(t, ahora: t), 'hace un momento');
    expect(
      haceTiempo(t, ahora: t.add(const Duration(minutes: 30))),
      'hace 30 minutos',
    );
    expect(
      haceTiempo(t, ahora: t.add(const Duration(hours: 5))),
      'hace 5 horas',
    );
    expect(
      haceTiempo(t, ahora: t.add(const Duration(days: 1, hours: 2))),
      'hace 1 día',
    );
    expect(haceTiempo(t, ahora: t.add(const Duration(days: 4))), 'hace 4 días');
  });
}
