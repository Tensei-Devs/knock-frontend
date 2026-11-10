import 'package:app/core/sesion/servicio_entrada.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

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

/// Overrides para `arrancar` en los E2E: sin sesión guardada y entrada ficticia.
final List<Override> entradaFicticia = [
  sesionInicialProvider.overrideWithValue(false),
  servicioEntradaProvider.overrideWithValue(_ServicioEntradaFicticio()),
];
