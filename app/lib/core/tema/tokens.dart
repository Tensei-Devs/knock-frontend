import 'package:flutter/painting.dart';

/// Tokens de medida de la maqueta (`maqueta-knock/css/knock.css`), spec 014
/// (KNOCK-242), R-02. Ninguna pantalla escribe radios, alturas, sombras ni
/// espaciados sueltos: los toma de aquí.

/// Radios de esquina (`--r-lg`, `--r-md`, `--r-sm`, `.btn`, `.sheet`).
abstract final class Radios {
  /// `--r-lg`: tarjetas y grupos de filas.
  static const double grande = 22;

  /// `--r-md`: avisos y opciones grandes.
  static const double medio = 16;

  /// `--r-sm`: campos de texto.
  static const double pequeno = 12;

  /// `.btn`: botón en forma de píldora.
  static const double boton = 28;

  /// `.btn.sm`: botón chico.
  static const double botonChico = 23;

  /// `.chip`.
  static const double chip = 22;

  /// `.sheet`: esquinas superiores de la hoja inferior.
  static const double hoja = 26;

  /// `.li .ic`: cuadro del ícono de una fila.
  static const double iconoFila = 12;

  /// `.grab`: barra para arrastrar una hoja.
  static const double asa = 3;
}

/// Alturas mínimas. Son **mínimas**, nunca fijas: el texto al 200 % crece.
abstract final class Alturas {
  /// `.btn`.
  static const double boton = 56;

  /// `.btn.sm`.
  static const double botonChico = 46;

  /// `.btn.ghost`.
  static const double botonGhost = 48;

  /// `.inp`.
  static const double campo = 56;

  /// `.li`.
  static const double fila = 62;

  /// `.chip` (la maqueta dibuja 44; el área táctil mínima es [areaTactil]).
  static const double chip = 44;

  /// `.top`.
  static const double barraSuperior = 60;

  /// `.tab`.
  static const double pestana = 54;

  /// Cuadro del ícono de una fila (`.li .ic`).
  static const double iconoFila = 40;

  /// Círculo de un estado vacío (`.empty .big`).
  static const double estadoVacio = 96;

  /// Área táctil mínima (guía de Android y regla de la app).
  static const double areaTactil = 48;
}

/// Espaciado (`.pad`, `.stack`, `.stack-s`, `.row`, `.li`, `.card`).
abstract final class Espaciado {
  /// `.pad`: margen del cuerpo de una pantalla.
  static const double cuerpo = 20;

  /// `.stack`: separación entre bloques.
  static const double bloque = 16;

  /// `.stack-s`: separación entre bloques chicos.
  static const double bloqueChico = 8;

  /// `.row`: separación dentro de una fila.
  static const double fila = 12;

  /// `.li`: del ícono al texto.
  static const double iconoAFila = 14;

  /// `.card`: relleno interior.
  static const double tarjeta = 16;
}

/// Sombras de la maqueta.
abstract final class Sombras {
  /// `.card`: `0 1px 3px rgba(30,58,95,.06), 0 4px 14px rgba(30,58,95,.05)`.
  static const List<BoxShadow> tarjeta = [
    BoxShadow(color: Color(0x0F1E3A5F), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(color: Color(0x0D1E3A5F), offset: Offset(0, 4), blurRadius: 14),
  ];
}
