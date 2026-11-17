import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/validacion_solicitud.dart';

/// Lo que la persona lleva capturado en «Pedir cotización» (spec 015, R-07).
///
/// Vive solo en el teléfono y se borra al enviar, al descartar y al cerrar
/// sesión. **No** guarda la dirección del domicilio (D-06): se captura en el
/// paso 3 y viaja solo en la solicitud.
final class BorradorSolicitud {
  const BorradorSolicitud({
    required this.actualizadoEn,
    this.oficioClave,
    this.descripcion = '',
    this.rutasDeFotos = const [],
    this.dia,
    this.franja,
  });

  final String? oficioClave;
  final String descripcion;

  /// Rutas de las copias de las fotos en el directorio privado de la app.
  final List<String> rutasDeFotos;

  final DateTime? dia;
  final Franja? franja;
  final DateTime actualizadoEn;

  /// Si no tiene nada que valga la pena recuperar.
  bool get estaVacio =>
      oficioClave == null &&
      descripcion.trim().isEmpty &&
      rutasDeFotos.isEmpty &&
      dia == null &&
      franja == null;

  /// Mapa para guardarlo. Sin dirección ni datos de la cuenta.
  Map<String, Object?> aMapa() => {
    'v': 1,
    'oficioClave': oficioClave,
    'descripcion': descripcion,
    'fotos': rutasDeFotos,
    'dia': dia == null ? null : diaDelContrato(dia!),
    'franja': franja?.valor,
    'actualizadoEn': actualizadoEn.toUtc().toIso8601String(),
  };

  /// El borrador de un mapa guardado, o `null` si no se puede leer (versión
  /// distinta o datos dañados): un borrador ilegible se descarta, no rompe el
  /// formulario.
  static BorradorSolicitud? desdeMapa(Map<String, Object?> mapa) {
    if (mapa['v'] != 1) return null;
    final actualizado = DateTime.tryParse('${mapa['actualizadoEn']}');
    final fotos = mapa['fotos'];
    final descripcion = mapa['descripcion'];
    if (actualizado == null ||
        fotos is! List ||
        descripcion is! String ||
        fotos.any((f) => f is! String)) {
      return null;
    }
    final oficio = mapa['oficioClave'];
    final dia = mapa['dia'];
    final franja = mapa['franja'];
    return BorradorSolicitud(
      oficioClave: oficio is String ? oficio : null,
      descripcion: descripcion,
      rutasDeFotos: List.unmodifiable(fotos.cast<String>()),
      dia: dia is String ? DateTime.tryParse(dia) : null,
      franja: franja is String ? Franja.desdeTexto(franja) : null,
      actualizadoEn: actualizado,
    );
  }
}
