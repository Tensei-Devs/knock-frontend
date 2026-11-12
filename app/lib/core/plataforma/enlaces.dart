import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enlaces que la app abre en apps del sistema (spec 016, R-05 y CA-21). Solo
/// se arman con estas funciones: nunca se abre una dirección que llegue tal
/// cual del servidor (sin esquemas arbitrarios).
abstract final class Enlaces {
  /// Mapas: `https://www.google.com/maps/search/?api=1&query=<dirección>`.
  static Uri mapa(String direccion) => Uri.parse(
    'https://www.google.com/maps/search/?api=1&query='
    '${Uri.encodeComponent(direccion)}',
  );

  /// Marcador del teléfono con el número (solo dígitos).
  static Uri? llamada(String telefono) {
    final digitos = _soloDigitos(telefono);
    return digitos.length < 10 ? null : Uri(scheme: 'tel', path: digitos);
  }

  /// WhatsApp con el número de México (`52` + 10 dígitos).
  static Uri? whatsapp(String numero) {
    final digitos = _soloDigitos(numero);
    if (digitos.length < 10) return null;
    final completo = digitos.length == 10 ? '52$digitos' : digitos;
    return Uri.parse('https://wa.me/$completo');
  }

  static String _soloDigitos(String texto) =>
      texto.replaceAll(RegExp(r'[^0-9]'), '');
}

/// Abre un enlace en una app del sistema. Devuelve `false` si no hay app que
/// lo abra (la pantalla avisa sin bloquearse, R-05).
abstract interface class AbridorDeEnlaces {
  Future<bool> abrir(Uri enlace);
}

class AbridorDeEnlacesDelSistema implements AbridorDeEnlaces {
  const AbridorDeEnlacesDelSistema();

  @override
  Future<bool> abrir(Uri enlace) async {
    try {
      return await launchUrl(enlace, mode: LaunchMode.externalApplication);
    } on PlatformException {
      return false;
    }
  }
}

final abridorDeEnlacesProvider = Provider<AbridorDeEnlaces>(
  (ref) => const AbridorDeEnlacesDelSistema(),
);
