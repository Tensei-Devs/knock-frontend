// Spec 036, CA-45: sin conexión, Explorar muestra la última copia del mismo
// filtro con su fecha; sin copia, el error. La copia se borra con la sesión.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/explorar/explorar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repo implements ExplorarRepository {
  bool sinConexion = false;
  int llamadas = 0;

  @override
  Future<Explorar> cargar(FiltroExplorar filtro) async {
    llamadas++;
    if (sinConexion) throw const ServicioNoDisponibleFailure();
    return Explorar(
      filtro: filtro,
      serviciosPopulares: const [
        ServicioPopular(clave: 'mec', nombre: 'Mecánica', tecnicos: 3),
      ],
      mejorCalificados: const [],
      ideas: const [],
    );
  }
}

void main() {
  late _Repo repo;
  late ProviderContainer c;
  final hora = DateTime(2026, 11, 25, 9, 30);

  setUp(() {
    repo = _Repo();
    c = ProviderContainer(
      overrides: [
        explorarRepositoryProvider.overrideWithValue(repo),
        relojExplorarProvider.overrideWithValue(() => hora),
      ],
    );
    addTearDown(c.dispose);
  });

  Future<VistaExplorar> leer(FiltroExplorar filtro) {
    final sub = c.listen(explorarProvider(filtro), (_, _) {});
    addTearDown(sub.close);
    return c.read(explorarProvider(filtro).future);
  }

  test('CA_036_45 sin conexión entrega la última copia con su fecha', () async {
    final primera = await leer(FiltroExplorar.auto);
    expect(primera.esCopia, isFalse);

    repo.sinConexion = true;
    c.invalidate(explorarProvider(FiltroExplorar.auto));
    final copia = await leer(FiltroExplorar.auto);

    expect(copia.esCopia, isTrue);
    expect(copia.copiaDel, hora);
    expect(copia.datos.serviciosPopulares.single.nombre, 'Mecánica');
    expect(repo.llamadas, 2);
  });

  test(
    'CA_036_45 sin copia de ese filtro, el error llega a la pantalla',
    () async {
      await leer(FiltroExplorar.auto);
      repo.sinConexion = true;
      await expectLater(
        leer(FiltroExplorar.luz),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    },
  );

  test('CA_036_44 abrir o cerrar la sesión borra las copias', () async {
    await leer(FiltroExplorar.auto);
    expect(c.read(copiasExplorarProvider), isNotEmpty);

    await c
        .read(sesionProvider.notifier)
        .iniciar(const TokensSesion(accessToken: 'a', refreshToken: 'r'));

    expect(c.read(copiasExplorarProvider), isEmpty);
  });
}
