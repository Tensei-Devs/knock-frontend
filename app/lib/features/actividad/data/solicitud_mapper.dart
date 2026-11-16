import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/validacion_solicitud.dart';

/// Cuerpo de `POST /api/v1/solicitudes` (backend 020 R-01, spec 015 CA-23).
///
/// Lleva `oficioClave`, `descripcion`, `fotos` (los `archivoId`), `dia`
/// (`AAAA-MM-DD`), `franja` y `coloniaId`; `direccion` solo si la hay (a
/// domicilio). **Nunca** lleva `modalidad`: la dicta el oficio en el
/// servidor. Lo usará `SolicitudRepositoryApi` cuando el contrato traiga la
/// ruta; hoy lo cubre su prueba.
Map<String, Object?> cuerpoDeSolicitud(NuevaSolicitud solicitud) {
  final direccion = solicitud.direccion?.trim();
  return {
    'oficioClave': solicitud.oficioClave,
    'descripcion': solicitud.descripcion.trim(),
    'fotos': List<String>.unmodifiable(solicitud.archivoIds),
    'dia': diaDelContrato(solicitud.dia),
    'franja': solicitud.franja.valor,
    'coloniaId': solicitud.coloniaId,
    if (direccion != null && direccion.isNotEmpty) 'direccion': direccion,
  };
}
