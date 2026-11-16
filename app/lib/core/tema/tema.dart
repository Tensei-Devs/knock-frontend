import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tipografia.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:flutter/material.dart';

export 'package:app/core/tema/tipografia.dart' show familiaTipografica;

/// Tema claro de Knock (Material 3, paleta de la maqueta).
final ThemeData temaClaro = _construirTema(esquemaClaro);

/// Tema oscuro de Knock (Material 3, paleta de la maqueta).
final ThemeData temaOscuro = _construirTema(esquemaOscuro);

ThemeData _construirTema(ColorScheme esquema) {
  final claro = esquema.brightness == Brightness.light;
  final extra = claro ? ColoresKnock.claro : ColoresKnock.oscuro;
  // En claro el naranja (`primary`) no sirve como color de texto sobre crema
  // ni blanco (2.98 y 3.24:1): los botones sin relleno usan `amber-ink`.
  final textoDeAccion = claro ? ColoresClaro.amberInk : esquema.primary;
  const pildora = StadiumBorder();
  final colorDeTexto = WidgetStateProperty.resolveWith<Color?>(
    (estados) => estados.contains(WidgetState.disabled)
        ? esquema.onSurface.withValues(alpha: 0.38)
        : textoDeAccion,
  );
  ButtonStyle sinRelleno(double alto) => ButtonStyle(
    foregroundColor: colorDeTexto,
    minimumSize: WidgetStatePropertyAll(Size(64, alto)),
    shape: const WidgetStatePropertyAll(pildora),
    textStyle: const WidgetStatePropertyAll(textoDeBoton),
    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 22)),
  );
  final textoDeSeleccion = extra.sobreNavySoft;
  final borde = OutlineInputBorder(
    borderRadius: BorderRadius.circular(Radios.pequeno),
    borderSide: BorderSide(color: esquema.outline, width: 2),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    brightness: esquema.brightness,
    scaffoldBackgroundColor: esquema.surface,
    fontFamily: familiaTipografica,
    textTheme: escalaDeTextos,
    extensions: [extra],
    textButtonTheme: TextButtonThemeData(style: sinRelleno(Alturas.botonGhost)),
    // `.btn.sec`: contorno de 2 dp. El texto sigue el color de las reglas de
    // contraste (amber-ink en claro), no el azul de la maqueta.
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: sinRelleno(Alturas.boton).copyWith(
        side: WidgetStatePropertyAll(
          BorderSide(color: esquema.secondary, width: 2),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: sinRelleno(Alturas.boton),
    ),
    // Botón relleno: naranja con texto tinta (5.27:1). En claro el naranja
    // contra crema da 2.98:1, por debajo del 3:1 que pide WCAG 1.4.11 para el
    // contorno de un componente: se delimita con un borde de tinta sin
    // cambiar el color del botón.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, Alturas.boton),
        shape: pildora,
        textStyle: textoDeBoton,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        side: claro ? const BorderSide(color: ColoresClaro.ink) : null,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (estados) => estados.contains(WidgetState.selected)
            ? textoDeAccion
            : esquema.onSurfaceVariant,
      ),
    ),
    // `.inp`: 56 de alto, radio 12. El contorno usa `outline` (≥ 3:1) y no
    // la línea decorativa de la maqueta (1.2:1), por WCAG 1.4.11.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: esquema.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: borde,
      enabledBorder: borde,
      focusedBorder: borde.copyWith(
        borderSide: BorderSide(color: esquema.secondary, width: 2),
      ),
      errorBorder: borde.copyWith(
        borderSide: BorderSide(color: esquema.error, width: 2),
      ),
      focusedErrorBorder: borde.copyWith(
        borderSide: BorderSide(color: esquema.error, width: 2),
      ),
    ),
    // `.card`: la sombra de dos capas la pone `TarjetaKnock`.
    cardTheme: CardThemeData(
      color: esquema.surfaceContainer,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radios.grande),
      ),
    ),
    // `.top`: 60 de alto, fondo de superficie, título 18/900 y línea inferior.
    appBarTheme: AppBarTheme(
      toolbarHeight: Alturas.barraSuperior,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: esquema.surfaceContainer,
      foregroundColor: esquema.onSurface,
      shape: Border(bottom: BorderSide(color: extra.linea)),
      titleTextStyle: TextStyle(
        fontFamily: familiaTipografica,
        fontSize: 18,
        fontWeight: FontWeight.w900,
        height: 1.2,
        color: esquema.onSurface,
      ),
    ),
    // `.tabs`: etiqueta 12/800 y píldora de la pestaña activa.
    navigationBarTheme: NavigationBarThemeData(
      height: Alturas.pestana + 16,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: esquema.surfaceContainer,
      indicatorColor: extra.navySoft,
      indicatorShape: pildora,
      iconTheme: WidgetStateProperty.resolveWith(
        (estados) => IconThemeData(
          color: estados.contains(WidgetState.selected)
              ? textoDeSeleccion
              : esquema.onSurfaceVariant,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (estados) => TextStyle(
          fontFamily: familiaTipografica,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: estados.contains(WidgetState.selected)
              ? textoDeSeleccion
              : esquema.onSurfaceVariant,
        ),
      ),
    ),
    // `.sheet`: hoja inferior con esquinas superiores de 26.
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: esquema.surfaceContainer,
      modalBackgroundColor: esquema.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radios.hoja)),
      ),
    ),
    dividerTheme: DividerThemeData(color: extra.linea, space: 1, thickness: 1),
  );
}

/// Botón oscuro de la maqueta (`.btn.dark`): azul con texto blanco en claro y
/// `ink` en oscuro (nunca `navy` ni `mut` sobre `navybg`).
ButtonStyle estiloBotonOscuro(BuildContext context) {
  final c = context.colores;
  return FilledButton.styleFrom(
    backgroundColor: c.navyBg,
    foregroundColor: c.sobreNavyBg,
    side: BorderSide.none,
  );
}
