import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'package:app/features/inicio/domain/ubicacion_repository.dart';

/// Ubicación con `geolocator`: pide el permiso solo cuando se llama y lee la
/// posición una vez (sin `getPositionStream`, sin guardarla ni registrarla).
class UbicacionGeolocatorRepository implements UbicacionRepository {
  UbicacionGeolocatorRepository({GeolocatorPlatform? plataforma})
    : _plataforma = plataforma ?? GeolocatorPlatform.instance;

  final GeolocatorPlatform _plataforma;

  /// Tiempo máximo de espera de la lectura antes de rendirse.
  static const limite = Duration(seconds: 15);

  @override
  Future<ResultadoUbicacion> obtenerUnaVez() async {
    try {
      if (!await _plataforma.isLocationServiceEnabled()) {
        return const ServicioDesactivado();
      }
      var permiso = await _plataforma.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await _plataforma.requestPermission();
      }
      switch (permiso) {
        case LocationPermission.deniedForever:
          return const DenegadaParaSiempre();
        case LocationPermission.denied:
        case LocationPermission.unableToDetermine:
          return const Denegada();
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          break;
      }
      final posicion = await _plataforma.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: limite,
        ),
      );
      return Concedida(
        latitud: posicion.latitude,
        longitud: posicion.longitude,
      );
    } on LocationServiceDisabledException {
      return const ServicioDesactivado();
    } on TimeoutException {
      // Sin lectura a tiempo: casi siempre el servicio está apagado o sin
      // señal. Se trata igual para que la persona reciba un aviso claro.
      return const ServicioDesactivado();
    } on PermissionDeniedException {
      return const Denegada();
    } on PermissionRequestInProgressException {
      return const Denegada();
    } on PermissionDefinitionsNotFoundException {
      return const Denegada();
    }
  }

  @override
  Future<void> abrirAjustes() async {
    await _plataforma.openAppSettings();
  }
}
