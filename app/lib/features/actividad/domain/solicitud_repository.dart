import 'package:app/features/actividad/domain/solicitud.dart';

/// Fuente de las solicitudes. La implementación puede ser la API (con el
/// cliente generado) o una simulada, sin tocar la pantalla.
///
/// Falla con un `Failure` de `core/errores`.
abstract interface class SolicitudRepository {
  /// Sube una foto elegida y devuelve su `archivoId` privado.
  Future<String> subirFoto(String ruta);

  Future<Solicitud> crear(SolicitudNueva solicitud);

  /// 404 si no existe o es de otra persona (sin revelar cuál, CA-13).
  Future<Solicitud> obtener(String id);
}
