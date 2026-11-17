/// Dirección del aviso de privacidad que abre la pantalla de entrada
/// (spec 028, R-02): la página `/privacidad/` de la landing.
const String avisoDePrivacidadPorDefecto =
    'https://knock-frontend-production.up.railway.app/privacidad/';

/// Dirección elegida al compilar con `--dart-define=KNOCK_PRIVACY_URL=...`.
/// Vacía si no se definió.
const String _avisoDefinidoAlCompilar = String.fromEnvironment(
  'KNOCK_PRIVACY_URL',
);

/// Dirección que usa la app para el aviso de privacidad (spec 028, R-02).
///
/// Solo se acepta una dirección `https` con servidor y sin credenciales
/// incrustadas; cualquier otra, o ninguna, se ignora y se usa
/// [avisoDePrivacidadPorDefecto]. [definida] solo cambia en las pruebas.
String direccionDelAvisoDePrivacidad([
  String definida = _avisoDefinidoAlCompilar,
]) {
  final candidata = Uri.tryParse(definida.trim());
  final valida =
      candidata != null &&
      candidata.scheme == 'https' &&
      candidata.host.isNotEmpty &&
      candidata.userInfo.isEmpty;
  return valida ? candidata.toString() : avisoDePrivacidadPorDefecto;
}

/// Dirección del aviso para esta compilación.
final Uri urlDelAvisoDePrivacidad = Uri.parse(direccionDelAvisoDePrivacidad());
