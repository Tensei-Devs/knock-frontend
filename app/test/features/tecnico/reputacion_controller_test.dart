import 'package:app/core/errores/failure.dart';
import 'package:app/features/tecnico/domain/reputacion.dart';
import 'package:app/features/tecnico/presentation/reputacion_controller.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repositorio implements ReputacionRepository {
  bool sinConexion = false;
  @override
  Future<Reputacion> obtener() async {
    if (sinConexion) throw const ServicioNoDisponibleFailure();
    return Reputacion(
      promedio: 5,
      total: 1,
      distribucion: {5: 1},
      nivel: 'nuevo',
    );
  }
}

void main() {
  test('CA_036_42 conserva la copia si falla la conexión', () async {
    final repo = _Repositorio();
    final container = ProviderContainer(
      overrides: [reputacionRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    final sub = container.listen(reputacionControllerProvider, (_, _) {});
    addTearDown(sub.close);
    final primero = await container.read(reputacionControllerProvider.future);
    expect(primero.reputacion.total, 1);
    repo.sinConexion = true;
    container.read(reputacionControllerProvider.notifier).reintentar();
    final copia = await container.read(reputacionControllerProvider.future);
    expect(copia.reputacion.total, 1);
    expect(copia.copiaDel, isNotNull);
  });
}
