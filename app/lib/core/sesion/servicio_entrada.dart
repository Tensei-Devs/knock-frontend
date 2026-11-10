import 'package:app/core/sesion/canje_sesion.dart';
import 'package:app/core/sesion/identificador_dispositivo.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/sesion/verificador_celular.dart';

/// Resultado de entrar, sin tokens (esos solo van al almacenamiento seguro).
final class ResultadoEntrada {
  const ResultadoEntrada({required this.esNuevo, required this.perfilCompleto});

  final bool esNuevo;
  final bool perfilCompleto;
}

/// Registro e inicio de sesión con el celular (KNOCK-228; spec 015 del
/// backend): Firebase verifica el SMS, la API canjea el ID token por la
/// sesión propia y los tokens quedan en el almacenamiento seguro y en la sesión.
abstract interface class ServicioEntrada {
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  });

  Future<ResultadoEntrada> verificarCodigo(
    SolicitudCodigo solicitud,
    String codigo,
  );
}

class ServicioEntradaReal implements ServicioEntrada {
  ServicioEntradaReal({
    required this._verificador,
    required this._canje,
    required this._iniciarSesion,
    required this._identificador,
    required this._dispositivo,
  });

  final VerificadorCelular _verificador;
  final CanjeSesion _canje;

  /// Registra los tokens del canje en la sesión (almacenamiento seguro y
  /// memoria) sin reiniciar la app (spec 026, R-05).
  final Future<void> Function(TokensSesion tokens) _iniciarSesion;
  final IdentificadorDispositivo _identificador;
  final String _dispositivo;

  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) => _verificador.enviarCodigo(celular, anterior: anterior);

  @override
  Future<ResultadoEntrada> verificarCodigo(
    SolicitudCodigo solicitud,
    String codigo,
  ) async {
    final tokenFirebase = await _verificador.tokenDeId(solicitud, codigo);
    final sesion = await _canje.canjear(
      tokenFirebase: tokenFirebase,
      idDispositivo: await _identificador.obtener(),
      dispositivo: _dispositivo,
    );
    await _iniciarSesion(
      TokensSesion(accessToken: sesion.acceso, refreshToken: sesion.renovacion),
    );
    // La app ya tiene su sesión; la de Firebase no se necesita. Si cerrarla
    // falla, la entrada sigue siendo válida.
    try {
      await _verificador.cerrarSesion();
    } on Exception {
      // Sin registro: no hay nada útil que guardar y podría llevar datos.
    }
    return ResultadoEntrada(
      esNuevo: sesion.esNuevo,
      perfilCompleto: sesion.perfilCompleto,
    );
  }
}
