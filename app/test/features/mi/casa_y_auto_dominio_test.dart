// Spec 031: reglas del formulario (backend 041, R-14) y paginación del
// historial sin repetir trabajos (CA-15).
import 'package:app/features/mi/data/casa_y_auto_repository_simulado.dart';
import 'package:app/features/mi/domain/casa_y_auto.dart';
import 'package:app/features/mi/presentation/casa_y_auto_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _HistorialPaginado extends CasaYAutoRepositorySimulado {
  final cursores = <String?>[];

  @override
  Future<PaginaHistorial> historial(String id, {String? cursor}) async {
    cursores.add(cursor);
    return switch (cursor) {
      null => PaginaHistorial(trabajos: [_t('Plomería')], siguiente: 'c2'),
      'c2' => PaginaHistorial(trabajos: [_t('Electricidad')]),
      _ => const PaginaHistorial(trabajos: []),
    };
  }
}

TrabajoDelElemento _t(String oficio) => TrabajoDelElemento(
  fecha: DateTime.utc(2026, 9, 12),
  oficio: oficio,
  tecnico: 'Técnico Demo',
);

void main() {
  final hoy = DateTime(2026, 11, 24);

  test('CA_031_05 reglas: nombre de 2 a 60 y año solo en autos entre 1950 y el próximo', () {
    CampoElemento? v(TipoElemento t, String n, int? a) =>
        ReglasElemento.validar(tipo: t, nombre: n, anio: a, hoy: hoy);
    expect(v(TipoElemento.auto, 'Nissan Versa', 2018), isNull);
    expect(v(TipoElemento.auto, 'Nissan Versa', 2027), isNull);
    expect(v(TipoElemento.auto, 'Nissan Versa', 2028), CampoElemento.anio);
    expect(v(TipoElemento.auto, 'Nissan Versa', 1949), CampoElemento.anio);
    expect(v(TipoElemento.auto, 'Nissan Versa', null), CampoElemento.anio);
    expect(v(TipoElemento.instalacion, 'Boiler', null), isNull);
    expect(v(TipoElemento.instalacion, 'Boiler', 2010), CampoElemento.anio);
    expect(v(TipoElemento.otro, 'x', null), CampoElemento.nombre);
    expect(v(TipoElemento.otro, 'a' * 61, null), CampoElemento.nombre);
  });

  test(
    'CA_031_15 el historial pide la página siguiente con el cursor y no repite',
    () async {
      final repo = _HistorialPaginado();
      final historial = HistorialElemento(repo, 'e1');

      await historial.cargarMas();
      expect(historial.hayMas, isTrue);
      await historial.cargarMas();
      await historial.cargarMas();

      expect(repo.cursores, [null, 'c2']);
      expect(historial.trabajos.map((t) => t.oficio), [
        'Plomería',
        'Electricidad',
      ]);
      expect(historial.hayMas, isFalse);
    },
  );

  test('CA_031_05 el simulado aplica el límite de 20 elementos', () async {
    final repo = CasaYAutoRepositorySimulado(reloj: () => hoy);
    for (var i = 0; i < ReglasElemento.maximoElementos; i++) {
      await repo.agregar(tipo: TipoElemento.otro, nombre: 'Cosa $i');
    }
    await expectLater(
      repo.agregar(tipo: TipoElemento.otro, nombre: 'Una más'),
      throwsA(anything),
    );
    expect((await repo.listar()).length, ReglasElemento.maximoElementos);
  });
}
