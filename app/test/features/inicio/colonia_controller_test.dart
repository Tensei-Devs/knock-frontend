import 'package:app/core/errores/failure.dart';
import 'package:app/features/inicio/domain/colonia.dart';
import 'package:app/features/inicio/domain/colonias_repository.dart';
import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/colonia_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'presentation/mapa/fakes_ubicacion.dart';

class _Colonias implements ColoniasRepository {
  _Colonias(this.respuesta);

  final Future<ResultadoColonia> Function() respuesta;

  @override
  Future<ResultadoColonia> enPunto({
    required double latitud,
    required double longitud,
  }) => respuesta();
}

ProviderContainer _contenedor(
  ResultadoUbicacion ubicacion,
  ColoniasRepository colonias,
) {
  final c = ProviderContainer(
    overrides: [
      ubicacionRepositoryProvider.overrideWithValue(UbicacionFalsa(ubicacion)),
      coloniasRepositoryProvider.overrideWithValue(colonias),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  const concedida = Concedida(latitud: 1, longitud: 2);

  test('Inicio: con ubicación y cobertura muestra la colonia', () async {
    final c = _contenedor(
      concedida,
      _Colonias(
        () async => const ResultadoColonia(
          enCobertura: true,
          colonia: Colonia(id: '1', nombre: 'Centro', cp: '1', municipio: 'M'),
        ),
      ),
    );
    await c.read(coloniaControllerProvider.notifier).consultar();
    expect(c.read(coloniaControllerProvider), isA<ColoniaEncontrada>());
  });

  test('Inicio: fuera de cobertura, sin permiso y con error', () async {
    var c = _contenedor(
      concedida,
      _Colonias(() async => const ResultadoColonia(enCobertura: false)),
    );
    await c.read(coloniaControllerProvider.notifier).consultar();
    expect(c.read(coloniaControllerProvider), isA<ColoniaFueraDeCobertura>());

    c = _contenedor(
      const Denegada(),
      _Colonias(() async => throw StateError('no debe llamarse')),
    );
    await c.read(coloniaControllerProvider.notifier).consultar();
    expect(c.read(coloniaControllerProvider), isA<ColoniaSinUbicacion>());

    c = _contenedor(
      concedida,
      _Colonias(() async => throw const NoAutorizadoFailure()),
    );
    await c.read(coloniaControllerProvider.notifier).consultar();
    final estado = c.read(coloniaControllerProvider);
    expect(estado, isA<ColoniaConError>());
    expect((estado as ColoniaConError).falla, isA<NoAutorizadoFailure>());
  });
}
