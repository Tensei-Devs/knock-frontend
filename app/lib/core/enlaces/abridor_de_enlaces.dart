import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre una dirección web fuera de la app (spec 028, R-04).
///
/// Es una interfaz pequeña para que las pantallas no importen `url_launcher`
/// y las pruebas la sustituyan por un abridor falso.
abstract interface class AbridorDeEnlaces {
  /// Pide al sistema abrir [direccion]. Devuelve `false`, sin lanzar, si no se
  /// pudo abrir (sin navegador o con el sistema rechazando la apertura).
  Future<bool> abrir(Uri direccion);
}

/// Abridor real: el navegador externo del teléfono.
class AbridorDeEnlacesDelSistema implements AbridorDeEnlaces {
  const AbridorDeEnlacesDelSistema();

  @override
  Future<bool> abrir(Uri direccion) async {
    try {
      return await launchUrl(direccion, mode: LaunchMode.externalApplication);
    } on Exception {
      return false;
    }
  }
}

/// Abridor de enlaces de la app; las pruebas lo sustituyen.
final abridorDeEnlacesProvider = Provider<AbridorDeEnlaces>(
  (ref) => const AbridorDeEnlacesDelSistema(),
);
