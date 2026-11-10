import 'package:flutter/painting.dart';

/// Colores del mapa dibujado de la previa (spec 027, decisión D-12): el mundo
/// de la maqueta (`worldSvg` de `js/mapa.js`) y sus pines. Viven en los
/// tokens del tema porque ningún widget escribe colores sueltos (spec 002).
abstract final class ColoresMapa {
  /// Pin de mecánica (`MECOLOR.mec` de la maqueta).
  static const pinMecanica = Color(0xFF1C3A4C);

  /// Pin de plomería (`MECOLOR.plo`).
  static const pinPlomeria = Color(0xFF1D5B85);

  /// Pin de electricidad: el tono más oscuro del par de la maqueta para que
  /// el texto claro se lea.
  static const pinElectricidad = Color(0xFF8A5A00);

  /// Texto e ícono sobre los pines y avatares de oficio.
  static const sobrePin = Color(0xFFFFFFFF);

  /// Sombra de un pin.
  static const sombraPin = Color(0x40000000);

  /// «Tú estás aquí» (`.medot`): punto, borde y halo.
  static const punto = Color(0xFF2F7DE1);
  static const puntoBorde = Color(0xFFFFFFFF);
  static const puntoHalo = Color(0x332F7DE1);
}

/// Colores del mundo dibujado (los de `worldSvg` de la maqueta, y una
/// variante oscura). Es un dibujo de ejemplo: no usa SDK de mapas.
final class PaletaMapa {
  const PaletaMapa({
    required this.fondo,
    required this.bloques,
    required this.calleBorde,
    required this.calle,
    required this.parque,
    required this.parqueBorde,
    required this.parqueSendero,
    required this.rio,
    required this.rioBorde,
    required this.avenida,
    required this.avenidaBorde,
    required this.textoAvenida,
    required this.textoColonia,
    required this.textoParque,
    required this.textoRio,
  });

  final Color fondo;
  final List<Color> bloques;
  final Color calleBorde;
  final Color calle;
  final Color parque;
  final Color parqueBorde;
  final Color parqueSendero;
  final Color rio;
  final Color rioBorde;
  final Color avenida;
  final Color avenidaBorde;
  final Color textoAvenida;
  final Color textoColonia;
  final Color textoParque;
  final Color textoRio;

  static const claro = PaletaMapa(
    fondo: Color(0xFFF2EFE9),
    bloques: [
      Color(0xFFE3EBD2),
      Color(0xFFE9E3D8),
      Color(0xFFE4DDD0),
      Color(0xFFEBD9CE),
    ],
    calleBorde: Color(0xFFD9D3C7),
    calle: Color(0xFFFFFFFF),
    parque: Color(0xFFCDEBB0),
    parqueBorde: Color(0xFFB3D99A),
    parqueSendero: Color(0xFFE8F4DA),
    rio: Color(0xFFC9E3EA),
    rioBorde: Color(0xFFAAD3DF),
    avenida: Color(0xFFFFE3A8),
    avenidaBorde: Color(0xFFE2B462),
    textoAvenida: Color(0xFF7A6B45),
    textoColonia: Color(0xFF8E8776),
    textoParque: Color(0xFF5F8C48),
    textoRio: Color(0xFF4C8FA3),
  );

  static const oscuro = PaletaMapa(
    fondo: Color(0xFF1E1B18),
    bloques: [
      Color(0xFF26301F),
      Color(0xFF2B2622),
      Color(0xFF28231F),
      Color(0xFF302520),
    ],
    calleBorde: Color(0xFF14110F),
    calle: Color(0xFF3A332D),
    parque: Color(0xFF2C3B2A),
    parqueBorde: Color(0xFF3B4F38),
    parqueSendero: Color(0xFF3A4C37),
    rio: Color(0xFF1F3B46),
    rioBorde: Color(0xFF2A5568),
    avenida: Color(0xFF6B5630),
    avenidaBorde: Color(0xFF4A3B1F),
    textoAvenida: Color(0xFFE9D7A8),
    textoColonia: Color(0xFFB5A798),
    textoParque: Color(0xFFA8D090),
    textoRio: Color(0xFF8FC4D6),
  );
}
