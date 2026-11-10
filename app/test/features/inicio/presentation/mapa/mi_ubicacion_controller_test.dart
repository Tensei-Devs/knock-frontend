import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/mapa/mi_ubicacion_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes_ubicacion.dart';

ProviderContainer _contenedor(UbicacionFalsa ubicacion) {
  final contenedor = ProviderContainer(
    overrides: [ubicacionRepositoryProvider.overrideWithValue(ubicacion)],
  );
  addTearDown(contenedor.dispose);
  return contenedor;
}

void main() {
  test(
    'TC-TT-MOB-04-04 con permiso concedido centra la cámara en la posición',
    () async {
      final ubicacion = UbicacionFalsa(
        const Concedida(latitud: 20.061, longitud: -99.342),
      );
      final camara = CamaraFalsa();
      final contenedor = _contenedor(ubicacion);

      await contenedor
          .read(miUbicacionControllerProvider.notifier)
          .centrar(camara);

      expect(ubicacion.llamadas, 1, reason: 'una sola lectura');
      expect(camara.movimientos, [(20.061, -99.342)]);
      expect(contenedor.read(miUbicacionControllerProvider), isNull);
    },
  );

  test(
    'TC-TT-MOB-04-04 al concederse después de un aviso, el aviso se limpia',
    () async {
      final ubicacion = UbicacionFalsa(const Denegada());
      final camara = CamaraFalsa();
      final contenedor = _contenedor(ubicacion);
      final controlador = contenedor.read(
        miUbicacionControllerProvider.notifier,
      );

      await controlador.centrar(camara);
      expect(
        contenedor.read(miUbicacionControllerProvider),
        AvisoUbicacion.sinPermiso,
      );

      ubicacion.resultado = const Concedida(latitud: 20.05, longitud: -99.34);
      await controlador.centrar(camara);

      expect(contenedor.read(miUbicacionControllerProvider), isNull);
      expect(camara.movimientos, [(20.05, -99.34)]);
    },
  );

  test(
    'TC-TT-MOB-04-05 con permiso denegado no mueve la cámara y avisa',
    () async {
      const casos = <(ResultadoUbicacion, AvisoUbicacion, bool)>[
        (Denegada(), AvisoUbicacion.sinPermiso, false),
        (DenegadaParaSiempre(), AvisoUbicacion.sinPermisoParaSiempre, true),
        (ServicioDesactivado(), AvisoUbicacion.servicioDesactivado, false),
      ];

      for (final (resultado, aviso, ofreceAjustes) in casos) {
        final ubicacion = UbicacionFalsa(resultado);
        final camara = CamaraFalsa();
        final contenedor = _contenedor(ubicacion);

        await contenedor
            .read(miUbicacionControllerProvider.notifier)
            .centrar(camara);

        expect(camara.movimientos, isEmpty, reason: '$resultado');
        expect(
          contenedor.read(miUbicacionControllerProvider),
          aviso,
          reason: '$resultado',
        );
        expect(aviso.ofreceAjustes, ofreceAjustes, reason: '$resultado');
      }
    },
  );

  test('TC-TT-MOB-04-05 los avisos tienen el texto acordado', () {
    expect(
      AvisoUbicacion.sinPermiso.texto,
      'Sin permiso de ubicación; puedes seguir usando el mapa.',
    );
    expect(
      AvisoUbicacion.sinPermisoParaSiempre.texto,
      'Sin permiso de ubicación; puedes seguir usando el mapa.',
    );
    expect(
      AvisoUbicacion.servicioDesactivado.texto,
      'Activa la ubicación del teléfono.',
    );
  });

  test(
    'TC-TT-MOB-04-05 abrir ajustes delega en el repositorio de ubicación',
    () async {
      final ubicacion = UbicacionFalsa(const DenegadaParaSiempre());
      final contenedor = _contenedor(ubicacion);

      await contenedor
          .read(miUbicacionControllerProvider.notifier)
          .abrirAjustes();

      expect(ubicacion.ajustesAbiertos, 1);
      expect(ubicacion.llamadas, 0, reason: 'no pide la ubicación');
    },
  );
}
