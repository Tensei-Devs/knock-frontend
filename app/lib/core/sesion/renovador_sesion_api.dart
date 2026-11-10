import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Renovación real: `POST /api/v1/auth/refresh` (spec 016 del backend).
///
/// Usa el transporte **público** (sin `ClienteAutenticado`) para no entrar en
/// un bucle de renovación. La API rota el token: el anterior ya no sirve.
/// Solo 400 y 401 significan «rechazada» (devuelve `null`); red, 429, 5xx o una
/// respuesta ilegible lanzan un `Failure` y la sesión se conserva (D-03).
class RenovadorSesionApi implements RenovadorSesion {
  const RenovadorSesionApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<TokensSesion?> renovar(String refreshToken) async {
    final respuesta = await enviarJson(
      transporte,
      url,
      'POST',
      'auth/refresh',
      cuerpo: {'refreshToken': refreshToken},
      aceptar: const {400, 401},
    );
    if (respuesta.estado == 400 || respuesta.estado == 401) return null;
    final json = respuesta.json;
    if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    final acceso = json['accessToken'];
    final refresco = json['refreshToken'];
    if (acceso is! String ||
        acceso.isEmpty ||
        refresco is! String ||
        refresco.isEmpty) {
      throw const DatosInvalidosFailure();
    }
    return TokensSesion(accessToken: acceso, refreshToken: refresco);
  }
}

/// Quién renueva la sesión: la API real por el transporte público. Las pruebas
/// lo reemplazan con un doble.
final renovadorSesionProvider = Provider<RenovadorSesion>(
  (ref) => RenovadorSesionApi(
    transporte: ref.watch(transporteHttpProvider),
    url: ref.watch(urlApiProvider),
  ),
);
