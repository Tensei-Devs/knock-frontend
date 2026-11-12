/// Regla de las fotos que la app pinta (spec 015, CA-21).
///
/// Solo se cargan direcciones `https` de un dominio permitido de Knock. Lo
/// demás se descarta sin pedirlo: una respuesta alterada no puede hacer que la
/// app cargue (y delate) una dirección de otro sitio.
library;

/// Si [direccion] es `https`, sin usuario ni puerto raro, y su dominio es uno
/// de [dominios] (o un subdominio suyo).
bool esFotoPermitida(String direccion, Set<String> dominios) {
  final uri = Uri.tryParse(direccion);
  if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return false;
  if (uri.userInfo.isNotEmpty) return false;
  if (uri.hasPort && uri.port != 443) return false;
  final host = uri.host.toLowerCase();
  return dominios.any((d) {
    final dominio = d.toLowerCase();
    return host == dominio || host.endsWith('.$dominio');
  });
}

/// Solo las direcciones permitidas de [direcciones], en el mismo orden.
List<String> fotosPermitidas(
  Iterable<String> direcciones,
  Set<String> dominios,
) => [
  for (final d in direcciones)
    if (esFotoPermitida(d, dominios)) d,
];
