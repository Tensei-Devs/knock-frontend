import 'package:app/features/actividad/domain/franja.dart';

/// Estado de una solicitud (backend 020). Solo lo cambia el servidor.
enum EstadoSolicitud {
  enviada('enviada'),
  cotizando('cotizando'),
  citaConfirmada('cita_confirmada'),
  terminada('terminada'),
  calificada('calificada'),
  cancelada('cancelada'),
  vencida('vencida'),

  /// Un estado que la app no conoce: se muestra como «En proceso».
  desconocido('');

  const EstadoSolicitud(this.valor);

  /// Texto del contrato.
  final String valor;

  static EstadoSolicitud desdeTexto(String texto) {
    for (final estado in values) {
      if (estado != desconocido && estado.valor == texto) return estado;
    }
    return desconocido;
  }
}

/// Una solicitud de cotización vista por su dueño (spec 015, §5).
final class Solicitud {
  const Solicitud({
    required this.id,
    required this.estado,
    required this.oficioNombre,
    required this.descripcion,
    required this.totalFotos,
    required this.dia,
    required this.franja,
    required this.creadoEn,
    this.venceEn,
  });

  final String id;
  final EstadoSolicitud estado;
  final String oficioNombre;
  final String descripcion;
  final int totalFotos;
  final DateTime dia;
  final Franja franja;
  final DateTime creadoEn;
  final DateTime? venceEn;
}

/// Lo que la persona manda al pedir una cotización (backend 020 R-01).
///
/// No lleva modalidad: la dicta el oficio en el servidor (CA-23). Las fotos
/// son los `archivoId` privados ya subidos y confirmados (R-03).
final class NuevaSolicitud {
  const NuevaSolicitud({
    required this.oficioClave,
    required this.descripcion,
    required this.archivoIds,
    required this.dia,
    required this.franja,
    required this.coloniaId,
    this.direccion,
  });

  final String oficioClave;
  final String descripcion;
  final List<String> archivoIds;
  final DateTime dia;
  final Franja franja;
  final String coloniaId;

  /// Solo en un oficio a domicilio.
  final String? direccion;
}
