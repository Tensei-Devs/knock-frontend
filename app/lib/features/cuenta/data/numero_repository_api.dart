import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/cuenta/domain/numero.dart';
import 'package:http/http.dart' as http;

/// REAL: `POST /api/v1/me/cambio-numero`, `/confirmar` y
/// `POST /api/v1/recuperacion-acceso` (pública).
class NumeroRepositoryApi implements NumeroRepository {
  const NumeroRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  Future<void> _publicar(String ruta, Map<String, Object?> cuerpo) =>
      enviarJson(transporte, url, 'POST', ruta, cuerpo: cuerpo);

  @override
  Future<void> comprobar(String celularNuevo) =>
      _publicar('me/cambio-numero', {'celularNuevo': celularNuevo});

  @override
  Future<void> confirmar(String firebaseIdToken) => _publicar(
    'me/cambio-numero/confirmar',
    {'firebaseIdToken': firebaseIdToken},
  );

  @override
  Future<void> recuperar({
    required String firebaseIdToken,
    required String celularAnterior,
    required TipoDeCuenta tipo,
  }) => _publicar('recuperacion-acceso', {
    'firebaseIdToken': firebaseIdToken,
    'celularAnterior': celularAnterior,
    'tipo': tipo.name,
  });
}
