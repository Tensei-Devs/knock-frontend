import 'package:app/core/errores/failure.dart';
import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:http/http.dart' as http;

/// Máximo de caracteres del identificador que acepta el contrato.
const maximoIdentificadorDispositivo = 4096;

/// Registro real contra `POST /api/v1/dispositivos` y
/// `DELETE /api/v1/dispositivos/{id}` (contrato de mensajería, spec 037).
///
/// El endpoint aún no está en el cliente generado: usa [enviarJson] (mismo
/// transporte con sesión y mismo mapeo de errores). Una escritura nunca se
/// reintenta aquí. El identificador es una credencial: no se registra ni
/// viaja en errores.
class RegistroDispositivosApi implements RegistroDispositivosRepository {
  RegistroDispositivosApi({
    required this.transporte,
    required this.url,
    required this.plataforma,
  });

  final http.Client transporte;
  final String url;

  /// `android` o `ios` (valores del contrato).
  final String plataforma;

  @override
  Future<String> registrar(String identificador) async {
    if (!_identificadorValido(identificador)) {
      throw const DatosRechazadosFailure();
    }
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'dispositivos',
      cuerpo: {'identificador': identificador, 'plataforma': plataforma},
      aceptar: const {503},
    );
    if (r.estado == 503) throw const NotificacionesNoDisponiblesException();
    final json = r.json;
    final id = json is Map<String, Object?> ? json['id'] : null;
    if ((r.estado != 200 && r.estado != 201) || id is! String || id.isEmpty) {
      throw const DatosInvalidosFailure();
    }
    return id;
  }

  @override
  Future<void> desregistrar(String id) async {
    if (id.isEmpty || id.contains(RegExp(r'[/?#\\]'))) {
      throw const DatosRechazadosFailure();
    }
    final r = await enviarJson(
      transporte,
      url,
      'DELETE',
      'dispositivos/${Uri.encodeComponent(id)}',
      aceptar: const {503},
    );
    if (r.estado == 503) throw const NotificacionesNoDisponiblesException();
  }
}

bool _identificadorValido(String identificador) =>
    identificador.isNotEmpty &&
    identificador.length <= maximoIdentificadorDispositivo &&
    !identificador.contains(RegExp(r'[\x00-\x1F\x7F]'));
