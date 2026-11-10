import 'package:app/core/errores/failure.dart';

/// Configuración de la conexión con la API (spec 006, KNOCK-220).
///
/// La URL base llega al compilar: `--dart-define=KNOCK_API_URL=https://...`.
/// No se escribe fija en el código: cambia por ambiente y la decide quien
/// compila. Sin ella, cada llamada falla con `ApiNoConfiguradaFailure`.
const String urlApiDefinida = String.fromEnvironment('KNOCK_API_URL');

/// Falla si es una compilación de tienda sin URL válida (spec 026, R-10).
void validarConfiguracionApi({required String url, required bool esRelease}) {
  if (esRelease && normalizarUrlApi(url) == null) {
    throw const ApiNoConfiguradaFailure();
  }
}

/// Versión de la API que consume esta app (segmento `v{version}` de la ruta).
const String versionApi = '1';

/// Devuelve la URL base sin la diagonal final, o `null` si no es válida.
///
/// Solo se acepta `https`, salvo `http` hacia la propia máquina o el emulador
/// de Android (`localhost`, `127.0.0.1`, `10.0.2.2`) para el backend local.
String? normalizarUrlApi(String url) {
  final texto = url.trim();
  final uri = Uri.tryParse(texto);
  if (texto.isEmpty || uri == null || uri.host.isEmpty) return null;
  if (uri.hasQuery || uri.hasFragment || uri.userInfo.isNotEmpty) return null;
  const locales = {'localhost', '127.0.0.1', '10.0.2.2'};
  final permitido =
      uri.scheme == 'https' ||
      (uri.scheme == 'http' && locales.contains(uri.host));
  if (!permitido) return null;
  return texto.endsWith('/') ? texto.substring(0, texto.length - 1) : texto;
}
