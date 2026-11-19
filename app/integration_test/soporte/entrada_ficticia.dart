import 'package:app/core/sesion/servicio_entrada.dart';
import 'package:app/core/sesion/sesion_provider.dart'
    show servicioEntradaProvider;
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Entrada sin Firebase ni API para los E2E de humo (KNOCK-228): el
/// recorrido de las pestañas no depende de un SMS real ni del backend.
/// El recorrido real se prueba a mano con un número de prueba de Firebase
/// (ver app/README.md).
class _ServicioEntradaFicticio implements ServicioEntrada {
  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) async => SolicitudCodigo(celular: celular, idVerificacion: 'ficticia');

  @override
  Future<ResultadoEntrada> verificarCodigo(
    SolicitudCodigo solicitud,
    String codigo,
  ) async => const ResultadoEntrada(esNuevo: false, perfilCompleto: true);
}

/// Borra la sesión guardada en el dispositivo para que la app arranque sin sesión.
///
/// `arrancar` ya fija `sesionInicialProvider` según los tokens guardados y Riverpod
/// no admite sobrescribir dos veces el mismo proveedor; por eso los E2E limpian el
/// almacén seguro en lugar de sobrescribirlo.
Future<void> sinSesionGuardada() => const FlutterSecureStorage().deleteAll();

/// Overrides para `arrancar` en los E2E: entrada ficticia, sin Firebase ni API.
final List<Override> entradaFicticia = [
  servicioEntradaProvider.overrideWithValue(_ServicioEntradaFicticio()),
];
