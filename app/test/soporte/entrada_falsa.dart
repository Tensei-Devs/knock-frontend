import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/servicio_entrada.dart';
import 'package:app/core/sesion/verificador_celular.dart';

/// [ServicioEntrada] sin Firebase ni red, para widget tests (KNOCK-228).
///
/// Responde al momento; [errorAlEnviar] y [errorAlVerificar] simulan fallos.
class ServicioEntradaFalso implements ServicioEntrada {
  Failure? errorAlEnviar;
  Failure? errorAlVerificar;
  final celularesEnviados = <String>[];
  final codigosVerificados = <String>[];
  int reenvios = 0;

  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) async {
    if (anterior != null) reenvios++;
    final error = errorAlEnviar;
    if (error != null) throw error;
    celularesEnviados.add(celular);
    return SolicitudCodigo(celular: celular, idVerificacion: 'verificacion-1');
  }

  @override
  Future<ResultadoEntrada> verificarCodigo(
    SolicitudCodigo solicitud,
    String codigo,
  ) async {
    final error = errorAlVerificar;
    if (error != null) throw error;
    codigosVerificados.add(codigo);
    return const ResultadoEntrada(esNuevo: true, perfilCompleto: false);
  }
}
