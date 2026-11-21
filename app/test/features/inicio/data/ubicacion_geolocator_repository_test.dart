import 'dart:async';

import 'package:app/features/inicio/data/ubicacion_geolocator_repository.dart';
import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

/// Plataforma de `geolocator` falsa (sin canal nativo): se inyecta en el
/// repositorio, no reemplaza `GeolocatorPlatform.instance`.
class _GeolocatorFalso extends Fake implements GeolocatorPlatform {
  _GeolocatorFalso({
    this.servicioActivo = true,
    this.permisoActual = LocationPermission.denied,
    this.permisoAlPedir = LocationPermission.whileInUse,
    this.errorAlLeer,
  });

  final bool servicioActivo;
  final LocationPermission permisoActual;
  final LocationPermission permisoAlPedir;
  final Exception? errorAlLeer;

  int pedidos = 0;
  int lecturas = 0;
  int ajustes = 0;
  LocationSettings? ajustesDeLectura;

  @override
  Future<bool> isLocationServiceEnabled() async => servicioActivo;

  @override
  Future<LocationPermission> checkPermission() async => permisoActual;

  @override
  Future<LocationPermission> requestPermission() async {
    pedidos++;
    return permisoAlPedir;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    lecturas++;
    ajustesDeLectura = locationSettings;
    final error = errorAlLeer;
    if (error != null) throw error;
    return Position(
      latitude: 20.04,
      longitude: -99.33,
      timestamp: DateTime.utc(2026, 10, 22),
      accuracy: 100,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  @override
  Future<bool> openAppSettings() async {
    ajustes++;
    return true;
  }
}

void main() {
  test(
    'TC-TT-MOB-04-04 pide el permiso si falta y lee la posición una vez',
    () async {
      final plataforma = _GeolocatorFalso();
      final repositorio = UbicacionGeolocatorRepository(plataforma: plataforma);

      final resultado = await repositorio.obtenerUnaVez();

      expect(resultado, isA<Concedida>());
      final concedida = resultado as Concedida;
      expect((concedida.latitud, concedida.longitud), (20.04, -99.33));
      expect(plataforma.pedidos, 1);
      expect(plataforma.lecturas, 1);
      expect(plataforma.ajustesDeLectura?.accuracy, LocationAccuracy.low);
      expect(
        plataforma.ajustesDeLectura?.timeLimit,
        UbicacionGeolocatorRepository.limite,
      );
      expect('$concedida', isNot(contains('20.04')), reason: 'sin coordenadas');
    },
  );

  test(
    'TC-TT-MOB-04-04 con el permiso ya concedido no vuelve a pedirlo',
    () async {
      final plataforma = _GeolocatorFalso(
        permisoActual: LocationPermission.whileInUse,
      );

      final resultado = await UbicacionGeolocatorRepository(
        plataforma: plataforma,
      ).obtenerUnaVez();

      expect(resultado, isA<Concedida>());
      expect(plataforma.pedidos, 0);
      expect(plataforma.lecturas, 1);
    },
  );

  test('R_012_06 permisoConcedido solo consulta, nunca pide', () async {
    for (final (permiso, esperado) in [
      (LocationPermission.whileInUse, true),
      (LocationPermission.always, true),
      (LocationPermission.denied, false),
      (LocationPermission.deniedForever, false),
    ]) {
      final plataforma = _GeolocatorFalso(permisoActual: permiso);
      final repositorio = UbicacionGeolocatorRepository(plataforma: plataforma);
      expect(
        await repositorio.permisoConcedido(),
        esperado,
        reason: '$permiso',
      );
      expect(plataforma.pedidos, 0);
    }
  });

  group('TC-TT-MOB-04-05 casos sin ubicación', () {
    Future<(ResultadoUbicacion, _GeolocatorFalso)> obtener(
      _GeolocatorFalso plataforma,
    ) async {
      final resultado = await UbicacionGeolocatorRepository(
        plataforma: plataforma,
      ).obtenerUnaVez();
      return (resultado, plataforma);
    }

    test('TC-TT-MOB-04-05 negado al pedir da Denegada sin leer', () async {
      final (resultado, plataforma) = await obtener(
        _GeolocatorFalso(permisoAlPedir: LocationPermission.denied),
      );
      expect(resultado, isA<Denegada>());
      expect(plataforma.lecturas, 0);
    });

    test('TC-TT-MOB-04-05 negado para siempre no vuelve a pedir', () async {
      final (resultado, plataforma) = await obtener(
        _GeolocatorFalso(permisoActual: LocationPermission.deniedForever),
      );
      expect(resultado, isA<DenegadaParaSiempre>());
      expect(plataforma.pedidos, 0);
      expect(plataforma.lecturas, 0);
    });

    test('TC-TT-MOB-04-05 servicio apagado no pide permiso', () async {
      final (resultado, plataforma) = await obtener(
        _GeolocatorFalso(servicioActivo: false),
      );
      expect(resultado, isA<ServicioDesactivado>());
      expect(plataforma.pedidos, 0);
      expect(plataforma.lecturas, 0);
    });

    test('TC-TT-MOB-04-05 permiso indeterminado da Denegada', () async {
      final (resultado, _) = await obtener(
        _GeolocatorFalso(permisoAlPedir: LocationPermission.unableToDetermine),
      );
      expect(resultado, isA<Denegada>());
    });

    test(
      'TC-TT-MOB-04-05 los errores de lectura terminan en un resultado',
      () async {
        final errores = <Exception, Type>{
          const LocationServiceDisabledException(): ServicioDesactivado,
          TimeoutException('sin lectura'): ServicioDesactivado,
          const PermissionRequestInProgressException('en curso'): Denegada,
          const PermissionDeniedException('negado'): Denegada,
          const PermissionDefinitionsNotFoundException('falta'): Denegada,
        };
        for (final MapEntry(key: error, value: tipo) in errores.entries) {
          final (resultado, _) = await obtener(
            _GeolocatorFalso(errorAlLeer: error),
          );
          expect(resultado.runtimeType, tipo, reason: '$error');
        }
      },
    );
  });

  test('TC-TT-MOB-04-05 abrir ajustes abre los de la app', () async {
    final plataforma = _GeolocatorFalso();

    await UbicacionGeolocatorRepository(plataforma: plataforma).abrirAjustes();

    expect(plataforma.ajustes, 1);
  });
}
