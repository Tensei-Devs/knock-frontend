import 'package:flutter/material.dart';

/// Tokens de color de la maqueta (`maqueta-knock/css/knock.css`), modo claro.
///
/// TT-MOB-02, spec §8 decisión 1. Los nombres siguen las variables CSS.
abstract final class ColoresClaro {
  /// `--ink`: texto principal.
  static const ink = Color(0xFF231A15);

  /// `--ink2`: texto secundario.
  static const ink2 = Color(0xFF4A3C33);

  /// `--mut`: texto atenuado.
  static const mut = Color(0xFF6B5D52);

  /// `--amber`: naranja de acciones. **Nunca** como texto sobre crema o
  /// blanco (2.98 y 3.24:1), ni con texto blanco encima (3.24:1).
  static const amber = Color(0xFFE9682D);

  /// `--amber-ink`: naranja para texto sobre crema o blanco.
  static const amberInk = Color(0xFF8F3510);

  /// `--navy`: azul petróleo de apoyo.
  static const navy = Color(0xFF1C3A4C);

  /// `--surface`: blanco de tarjetas y superficies elevadas.
  static const surface = Color(0xFFFFFFFF);

  /// `--surface2`: crema, fondo de la app.
  static const crema = Color(0xFFFBF5E9);
}

/// Tokens de color de la maqueta, modo oscuro (`[data-theme="dark"]`).
///
/// La maqueta no redefine `--amber` en oscuro: se usa el mismo naranja.
abstract final class ColoresOscuro {
  /// `--bg`: fondo de la app.
  static const bg = Color(0xFF14110F);

  /// `--stage`: fondo más profundo.
  static const stage = Color(0xFF0E0C0A);

  /// `--surface`: superficies (barra, tarjetas).
  static const surface = Color(0xFF1E1B18);

  /// `--surface2`: superficies elevadas.
  static const surface2 = Color(0xFF26211D);

  /// `--line`: líneas y divisores.
  static const line = Color(0xFF3A332D);

  /// `--line2`: líneas suaves.
  static const line2 = Color(0xFF302A25);

  /// `--ink`: texto principal.
  static const ink = Color(0xFFF6EEE3);

  /// `--ink2`: texto secundario.
  static const ink2 = Color(0xFFDCD0C2);

  /// `--mut`: texto atenuado. **Nunca** sobre `navybg` (3.44:1).
  static const mut = Color(0xFFB5A798);

  /// `--navy`: azul de apoyo. **Nunca** como texto sobre `navybg` (4.25:1).
  static const navy = Color(0xFF8FC4D6);

  /// `--navybg`: fondo azul. Encima solo `ink` o `ink2`.
  static const navybg = Color(0xFF2A5568);

  /// `--navy-soft`: fondo azul suave. Encima solo `ink` o `ink2`.
  static const navySoft = Color(0xFF1D3440);

  /// `--amber` (sin cambio en oscuro). **Nunca** sobre `navybg` (2.50:1) ni
  /// sobre `navy-soft` (4.01:1).
  static const amber = Color(0xFFE9682D);
}

/// Colores de error. La maqueta no los define: se toman los de la paleta
/// base de Material 3 (M3 baseline), que cumplen 4.5:1 con su par.
abstract final class ColoresError {
  static const claro = Color(0xFFBA1A1A);
  static const sobreClaro = Color(0xFFFFFFFF);
  static const contenedorClaro = Color(0xFFFFDAD6);
  static const sobreContenedorClaro = Color(0xFF410002);
  static const oscuro = Color(0xFFFFB4AB);
  static const sobreOscuro = Color(0xFF690005);
  static const contenedorOscuro = Color(0xFF93000A);
  static const sobreContenedorOscuro = Color(0xFFFFDAD6);
}

/// `ColorScheme` claro con la paleta de la maqueta.
///
/// Roles elegidos para no usar ningún par de texto por debajo de 4.5:1
/// (spec §8 decisión 1): `onPrimary` es tinta, no blanco.
const esquemaClaro = ColorScheme(
  brightness: Brightness.light,
  primary: ColoresClaro.amber,
  onPrimary: ColoresClaro.ink,
  primaryContainer: ColoresClaro.crema,
  onPrimaryContainer: ColoresClaro.amberInk,
  primaryFixed: ColoresClaro.amber,
  primaryFixedDim: ColoresClaro.amber,
  onPrimaryFixed: ColoresClaro.ink,
  onPrimaryFixedVariant: ColoresClaro.ink,
  secondary: ColoresClaro.navy,
  onSecondary: ColoresClaro.surface,
  secondaryContainer: ColoresClaro.crema,
  onSecondaryContainer: ColoresClaro.navy,
  secondaryFixed: ColoresClaro.navy,
  secondaryFixedDim: ColoresClaro.navy,
  onSecondaryFixed: ColoresClaro.surface,
  onSecondaryFixedVariant: ColoresClaro.surface,
  tertiary: ColoresClaro.amberInk,
  onTertiary: ColoresClaro.surface,
  tertiaryContainer: ColoresClaro.crema,
  onTertiaryContainer: ColoresClaro.navy,
  tertiaryFixed: ColoresClaro.amberInk,
  tertiaryFixedDim: ColoresClaro.amberInk,
  onTertiaryFixed: ColoresClaro.surface,
  onTertiaryFixedVariant: ColoresClaro.surface,
  error: ColoresError.claro,
  onError: ColoresError.sobreClaro,
  errorContainer: ColoresError.contenedorClaro,
  onErrorContainer: ColoresError.sobreContenedorClaro,
  surface: ColoresClaro.crema,
  onSurface: ColoresClaro.ink,
  surfaceDim: ColoresClaro.crema,
  surfaceBright: ColoresClaro.surface,
  surfaceContainerLowest: ColoresClaro.surface,
  surfaceContainerLow: ColoresClaro.surface,
  surfaceContainer: ColoresClaro.surface,
  surfaceContainerHigh: ColoresClaro.surface,
  surfaceContainerHighest: ColoresClaro.surface,
  onSurfaceVariant: ColoresClaro.mut,
  outline: ColoresClaro.mut,
  outlineVariant: ColoresClaro.mut,
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: ColoresClaro.ink,
  onInverseSurface: ColoresClaro.crema,
  inversePrimary: ColoresClaro.amber,
  surfaceTint: ColoresClaro.amber,
);

/// `ColorScheme` oscuro con la paleta de la maqueta.
///
/// `onPrimary` y `onSecondary` son `bg`; sobre `navybg` y `navy-soft` solo
/// va `ink` (spec §8 decisión 1).
const esquemaOscuro = ColorScheme(
  brightness: Brightness.dark,
  primary: ColoresOscuro.amber,
  onPrimary: ColoresOscuro.bg,
  primaryContainer: ColoresOscuro.surface2,
  onPrimaryContainer: ColoresOscuro.amber,
  primaryFixed: ColoresOscuro.amber,
  primaryFixedDim: ColoresOscuro.amber,
  onPrimaryFixed: ColoresOscuro.bg,
  onPrimaryFixedVariant: ColoresOscuro.bg,
  secondary: ColoresOscuro.navy,
  onSecondary: ColoresOscuro.bg,
  secondaryContainer: ColoresOscuro.navybg,
  onSecondaryContainer: ColoresOscuro.ink,
  secondaryFixed: ColoresOscuro.navy,
  secondaryFixedDim: ColoresOscuro.navy,
  onSecondaryFixed: ColoresOscuro.bg,
  onSecondaryFixedVariant: ColoresOscuro.bg,
  tertiary: ColoresOscuro.amber,
  onTertiary: ColoresOscuro.bg,
  tertiaryContainer: ColoresOscuro.navySoft,
  onTertiaryContainer: ColoresOscuro.ink,
  tertiaryFixed: ColoresOscuro.amber,
  tertiaryFixedDim: ColoresOscuro.amber,
  onTertiaryFixed: ColoresOscuro.bg,
  onTertiaryFixedVariant: ColoresOscuro.bg,
  error: ColoresError.oscuro,
  onError: ColoresError.sobreOscuro,
  errorContainer: ColoresError.contenedorOscuro,
  onErrorContainer: ColoresError.sobreContenedorOscuro,
  surface: ColoresOscuro.bg,
  onSurface: ColoresOscuro.ink,
  surfaceDim: ColoresOscuro.stage,
  surfaceBright: ColoresOscuro.surface2,
  surfaceContainerLowest: ColoresOscuro.stage,
  surfaceContainerLow: ColoresOscuro.surface,
  surfaceContainer: ColoresOscuro.surface,
  surfaceContainerHigh: ColoresOscuro.surface2,
  surfaceContainerHighest: ColoresOscuro.surface2,
  onSurfaceVariant: ColoresOscuro.mut,
  outline: ColoresOscuro.mut,
  outlineVariant: ColoresOscuro.line,
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: ColoresOscuro.ink,
  onInverseSurface: ColoresOscuro.bg,
  inversePrimary: ColoresClaro.amberInk,
  surfaceTint: ColoresOscuro.amber,
);

/// Colores de la maqueta que no caben en un `ColorScheme` (spec 014, R-02):
/// fondos suaves de íconos y avisos, línea de divisores y fondo azul.
///
/// Cada fondo trae su color de texto **ya validado** a 4.5:1 (spec 014, R-04):
/// en oscuro sobre `navybg` y `navy-soft` solo va `ink`.
@immutable
class ColoresKnock extends ThemeExtension<ColoresKnock> {
  const ColoresKnock({
    required this.navySoft,
    required this.sobreNavySoft,
    required this.navyBg,
    required this.sobreNavyBg,
    required this.amberSoft,
    required this.sobreAmberSoft,
    required this.linea,
  });

  /// `--navy-soft`: fondo del cuadro de ícono y de la pestaña activa.
  final Color navySoft;

  /// Texto e ícono sobre [navySoft].
  final Color sobreNavySoft;

  /// `--navybg`: fondo del botón oscuro.
  final Color navyBg;

  /// Texto sobre [navyBg].
  final Color sobreNavyBg;

  /// `--amber-soft`: fondo de avisos naranjas.
  final Color amberSoft;

  /// `--amber-ink` sobre [amberSoft].
  final Color sobreAmberSoft;

  /// `--line2`: divisores y bordes decorativos (no delimitan un control).
  final Color linea;

  static const claro = ColoresKnock(
    navySoft: Color(0xFFE1ECEF),
    sobreNavySoft: ColoresClaro.navy,
    navyBg: ColoresClaro.navy,
    sobreNavyBg: Color(0xFFFFFFFF),
    amberSoft: Color(0xFFFDE8DC),
    sobreAmberSoft: ColoresClaro.amberInk,
    linea: Color(0xFFEDE3D2),
  );

  static const oscuro = ColoresKnock(
    navySoft: ColoresOscuro.navySoft,
    sobreNavySoft: ColoresOscuro.ink,
    navyBg: ColoresOscuro.navybg,
    sobreNavyBg: ColoresOscuro.ink,
    amberSoft: Color(0xFF3B2415),
    sobreAmberSoft: Color(0xFFFFC9A6),
    linea: ColoresOscuro.line2,
  );

  @override
  ColoresKnock copyWith({
    Color? navySoft,
    Color? sobreNavySoft,
    Color? navyBg,
    Color? sobreNavyBg,
    Color? amberSoft,
    Color? sobreAmberSoft,
    Color? linea,
  }) => ColoresKnock(
    navySoft: navySoft ?? this.navySoft,
    sobreNavySoft: sobreNavySoft ?? this.sobreNavySoft,
    navyBg: navyBg ?? this.navyBg,
    sobreNavyBg: sobreNavyBg ?? this.sobreNavyBg,
    amberSoft: amberSoft ?? this.amberSoft,
    sobreAmberSoft: sobreAmberSoft ?? this.sobreAmberSoft,
    linea: linea ?? this.linea,
  );

  @override
  ColoresKnock lerp(ColoresKnock? other, double t) {
    if (other == null) return this;
    return ColoresKnock(
      navySoft: Color.lerp(navySoft, other.navySoft, t)!,
      sobreNavySoft: Color.lerp(sobreNavySoft, other.sobreNavySoft, t)!,
      navyBg: Color.lerp(navyBg, other.navyBg, t)!,
      sobreNavyBg: Color.lerp(sobreNavyBg, other.sobreNavyBg, t)!,
      amberSoft: Color.lerp(amberSoft, other.amberSoft, t)!,
      sobreAmberSoft: Color.lerp(sobreAmberSoft, other.sobreAmberSoft, t)!,
      linea: Color.lerp(linea, other.linea, t)!,
    );
  }
}

/// Atajo: `context.colores` en lugar de `Theme.of(context).extension<...>()`.
///
/// Si el tema no es el de Knock (un `MaterialApp` pelado), toma los valores
/// según el brillo en lugar de fallar.
extension ColoresKnockEnContexto on BuildContext {
  ColoresKnock get colores {
    final tema = Theme.of(this);
    return tema.extension<ColoresKnock>() ??
        (tema.brightness == Brightness.dark
            ? ColoresKnock.oscuro
            : ColoresKnock.claro);
  }
}
