// Spec 045, enmienda 1 (E-01) y spec 035: los oficios de la maqueta salen del
// backend (`GET /oficios`), no de una lista fija. Sin inventar oficios si falla.
import 'package:app/core/router/app_router.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/preparar_maqueta.dart';

class _OficiosFalso implements OficiosRepository {
  _OficiosFalso(this.respuestas);

  /// Cada llamada toma la siguiente respuesta; una excepción hace fallar.
  final List<Object> respuestas;
  int llamadas = 0;

  @override
  Future<List<Oficio>> listar() async {
    final r = respuestas[llamadas < respuestas.length ? llamadas : 0];
    llamadas++;
    if (r is Exception) throw r;
    return r as List<Oficio>;
  }
}

const _mec = Oficio(
  clave: 'mec',
  nombre: 'Mecánica',
  modalidad: Modalidad.taller,
);
const _ele = Oficio(
  clave: 'ele',
  nombre: 'Electricidad',
  modalidad: Modalidad.domicilio,
);
const _otro = Oficio(
  clave: 'jar',
  nombre: 'Jardinería',
  modalidad: Modalidad.domicilio,
);

Future<void> _abrirInicio(WidgetTester tester, OficiosRepository repo) async {
  final container = await montarApp(
    tester,
    esTecnico: false,
    maqueta: true,
    extra: [oficiosRepositoryProvider.overrideWithValue(repo)],
  );
  container.read(appRouterProvider).go('/inicio');
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_045_10 solo salen los oficios que devuelve el backend', (
    tester,
  ) async {
    await _abrirInicio(
      tester,
      _OficiosFalso([
        [_mec, _ele],
      ]),
    );
    expect(find.text('Mi auto'), findsOneWidget);
    expect(find.text('Agua y tuberías'), findsNothing);
  });

  testWidgets('CA_045_10 un oficio que la maqueta no sabe dibujar se omite', (
    tester,
  ) async {
    await _abrirInicio(
      tester,
      _OficiosFalso([
        [_mec, _otro],
      ]),
    );
    expect(find.text('Mi auto'), findsOneWidget);
    expect(find.text('Jardinería'), findsNothing);
  });

  testWidgets('CA_045_12 si falla no se inventan oficios y Reintentar los '
      'pide de nuevo', (tester) async {
    final repo = _OficiosFalso([
      Exception('sin red'),
      [_mec, _ele],
    ]);
    await _abrirInicio(tester, repo);
    expect(find.text('Mi auto'), findsNothing);
    final aviso = find.text(
      'No pudimos cargar los oficios. Toca para reintentar',
    );
    expect(aviso, findsOneWidget);
    await tester.tap(aviso);
    await asentarMaqueta(tester);
    expect(aviso, findsNothing);
    expect(find.text('Mi auto'), findsOneWidget);
    expect(repo.llamadas, 2);
  });
}
