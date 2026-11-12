import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/oficios/oficios.dart';

/// Estado de una solicitud. Solo lo cambia el servidor (spec 015, §5).
enum EstadoSolicitud {
  enviada('enviada'),
  cotizando('cotizando'),
  citaConfirmada('cita_confirmada'),
  terminada('terminada'),
  calificada('calificada'),
  cancelada('cancelada'),
  vencida('vencida'),

  /// Un estado que esta versión de la app no conoce: se muestra «En proceso».
  enProceso('');

  const EstadoSolicitud(this.valor);

  final String valor;

  static EstadoSolicitud desdeValor(String? texto) {
    for (final estado in values) {
      if (estado != enProceso && estado.valor == texto) return estado;
    }
    return enProceso;
  }
}

/// Lo que la persona captura y la app envía para crear una solicitud.
///
/// No lleva `modalidad` (la dicta el oficio en el servidor) y la [direccion]
/// solo existe si el oficio es a domicilio (spec 015, CA-23).
final class SolicitudNueva {
  const SolicitudNueva({
    required this.oficioClave,
    required this.descripcion,
    required this.fotos,
    required this.dia,
    required this.franja,
    required this.coloniaId,
    this.direccion,
  });

  final String oficioClave;
  final String descripcion;

  /// Identificadores `archivoId` de fotos privadas ya subidas.
  final List<String> fotos;
  final DateTime dia;
  final Franja franja;
  final String coloniaId;
  final String? direccion;
}

/// Una solicitud ya creada en el servidor (inmutable).
final class Solicitud {
  const Solicitud({
    required this.id,
    required this.estado,
    required this.oficioClave,
    required this.oficioNombre,
    required this.modalidad,
    required this.descripcion,
    required this.fotos,
    required this.dia,
    required this.franja,
    required this.creadoEn,
    this.direccion,
    this.venceEn,
  });

  final String id;
  final EstadoSolicitud estado;
  final String oficioClave;
  final String oficioNombre;
  final Modalidad modalidad;
  final String descripcion;

  /// Enlaces de lectura firmados que devuelve el servidor (CA-21).
  final List<String> fotos;
  final DateTime dia;
  final Franja franja;
  final String? direccion;
  final DateTime? venceEn;
  final DateTime creadoEn;
}
