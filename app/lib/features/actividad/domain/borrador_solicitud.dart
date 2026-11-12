import 'dart:convert';

import 'package:app/features/actividad/domain/franja.dart';

/// Lo escrito en el formulario, guardado en el teléfono para recuperarlo si se
/// pierde la señal (spec 015, R-07).
///
/// **No** guarda la dirección del domicilio: el borrador queda en claro.
final class BorradorSolicitud {
  const BorradorSolicitud({
    required this.oficioClave,
    required this.descripcion,
    required this.rutasDeFotos,
    required this.actualizadoEn,
    this.dia,
    this.franja,
  });

  final String? oficioClave;
  final String descripcion;
  final List<String> rutasDeFotos;
  final DateTime? dia;
  final Franja? franja;
  final DateTime actualizadoEn;

  /// Texto JSON para el almacén de preferencias.
  String comoTexto() => jsonEncode({
    'oficioClave': oficioClave,
    'descripcion': descripcion,
    'rutasDeFotos': rutasDeFotos,
    'dia': dia?.toIso8601String(),
    'franja': franja?.valor,
    'actualizadoEn': actualizadoEn.toIso8601String(),
  });

  /// Lee un borrador guardado; `null` si el texto no es uno válido.
  static BorradorSolicitud? desdeTexto(String? texto) {
    if (texto == null) return null;
    try {
      final datos = jsonDecode(texto);
      if (datos is! Map<String, dynamic>) return null;
      final descripcion = datos['descripcion'];
      final fotos = datos['rutasDeFotos'];
      final actualizado = datos['actualizadoEn'];
      if (descripcion is! String || fotos is! List || actualizado is! String) {
        return null;
      }
      final dia = datos['dia'];
      return BorradorSolicitud(
        oficioClave: datos['oficioClave'] as String?,
        descripcion: descripcion,
        rutasDeFotos: [for (final f in fotos) f as String],
        dia: dia is String ? DateTime.parse(dia) : null,
        franja: Franja.desdeValor(datos['franja'] as String?),
        actualizadoEn: DateTime.parse(actualizado),
      );
    } on Object {
      return null;
    }
  }
}
