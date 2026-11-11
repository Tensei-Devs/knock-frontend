import 'package:flutter/material.dart';

/// Familia tipográfica de la maqueta, empaquetada en `assets/fonts/nunito/`
/// (pesos 400, 500, 600, 700, 800 y 900; spec 014, R-01).
const String familiaTipografica = 'Nunito';

/// Escala de textos de la maqueta (`.h1`, `.h2`, `.h3`, `.t`, `.s`) sobre los
/// roles de Material. Sin color: lo pone el tema.
///
/// | Maqueta | Rol |
/// |---|---|
/// | `.h1` 26/900 | `headlineMedium` |
/// | `.h2` 20/900 | `headlineSmall` y `titleLarge` |
/// | `.h3` 17/900 | `titleMedium` |
/// | `.t` 16 | `bodyLarge` |
/// | `.s` 14 | `bodyMedium` |
const TextTheme escalaDeTextos = TextTheme(
  headlineMedium: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    height: 1.15,
    letterSpacing: -0.2,
  ),
  headlineSmall: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    height: 1.2,
  ),
  titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1.2),
  titleMedium: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w900,
    height: 1.25,
  ),
  bodyLarge: TextStyle(fontSize: 16, height: 1.45),
  bodyMedium: TextStyle(fontSize: 14, height: 1.4),
);

/// Texto de los botones (`.btn`: 17/900).
const TextStyle textoDeBoton = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w900,
);
