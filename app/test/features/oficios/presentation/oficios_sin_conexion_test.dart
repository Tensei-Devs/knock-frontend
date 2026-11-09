// Spec 010 (KNOCK-224): la pantalla muestra lo guardado, avisa sin conexión y
// permite reintentar.
import 'dart:async';

import 'package:app/features/oficios/domain/modalidad.dart';
import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/oficios_repository.dart';
import 'package:app/features/oficios/domain/resultado_oficios.dart';
import 'package:app/features/oficios/oficios_providers.dart';
import 'package:app/features/oficios/presentation/oficios_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _ele = Oficio(
  clave: 'ele',
  nombre: 'Electricidad',
  modalidad: Modalidad.domicilio,
);
const _mec = Oficio(
  clave: 'mec',
  nombre: 'Mecánica',
  modalidad: Modalidad.taller,
);
const _aviso = 'Sin conexión. Se muestra lo último guardado.';

class _ConCacheFalso implements OficiosRepositoryConCache {
  _ConCacheFalso(this._flujos);

  final List<Stream<ResultadoOficios> Function()> _flujos;
  int consultas = 0;

  @override
  Stream<ResultadoOficios> observar() => _flujos[consultas++]();

  @override
  Future<List<Oficio>> listar() async => (await observar().last).oficios;
}

Future<void> _montar(WidgetTester tester, OficiosRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [oficiosRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: OficiosScreen()),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('R_010_03 muestra primero lo guardado y se actualiza al llegar '
      'lo nuevo', (tester) async {
    final nuevo = Completer<void>();
    Stream<ResultadoOficios> flujo() async* {
      yield const ResultadoOficios([_ele]);
      await nuevo.future;
      yield const ResultadoOficios([_ele, _mec]);
    }

    await _montar(tester, _ConCacheFalso([flujo]));
    expect(find.text('Electricidad'), findsOneWidget);
    expect(find.text('Mecánica'), findsNothing);
    expect(find.text(_aviso), findsNothing);

    nuevo.complete();
    await tester.pump();
    await tester.pump();
    expect(find.text('Mecánica'), findsOneWidget);
  });

  testWidgets('R_010_SC sin conexión: lista guardada, aviso y Reintentar '
      'que recupera', (tester) async {
    final repo = _ConCacheFalso([
      () => Stream.value(const ResultadoOficios([_ele], sinConexion: true)),
      () => Stream.value(const ResultadoOficios([_ele, _mec])),
    ]);
    await _montar(tester, repo);

    expect(find.text('Electricidad'), findsOneWidget);
    expect(find.text(_aviso), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    await tester.pump();

    expect(repo.consultas, 2);
    expect(find.text('Mecánica'), findsOneWidget);
    expect(find.text(_aviso), findsNothing);
  });

  testWidgets('R_010_SC sin conexión y sin guardado: error con Reintentar', (
    tester,
  ) async {
    await _montar(
      tester,
      _ConCacheFalso([() => Stream.error(StateError('sin red'))]),
    );
    expect(find.text('No pudimos cargar los oficios'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
