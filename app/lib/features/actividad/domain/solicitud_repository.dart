import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/solicitud.dart';

/// Fuente de las solicitudes (spec 015). Falla con un `Failure` de
/// `core/errores`.
///
/// Mientras el contrato no publique `/solicitudes` ni `/archivos` (backend 020
/// y spec 013), la app usa una implementación de prueba; la API real se
/// conecta después sin tocar la pantalla.
abstract interface class SolicitudRepository {
  /// Sube la foto de [rutaLocal] por el flujo de archivos privados (spec 013,
  /// `uso: solicitud`) y devuelve su `archivoId`.
  Future<String> subirFoto(String rutaLocal);

  /// Crea la solicitud. Sin `Idempotency-Key` (R-06, retirada por ahora):
  /// la pantalla evita el doble envío deshabilitando el botón.
  Future<Solicitud> crear(NuevaSolicitud solicitud);

  /// La solicitud de la persona; `NoEncontradoFailure` si no existe o es de
  /// otra persona (CA-13).
  Future<Solicitud> obtener(String id);

  /// Las cotizaciones de la solicitud [solicitudId] en el [orden] pedido; el
  /// servidor ordena y etiqueta (R-08). `NoEncontradoFailure` si es ajena.
  Future<ResultadoComparacion> cotizaciones(
    String solicitudId, {
    OrdenCotizaciones orden = OrdenCotizaciones.recomendadas,
  });
}

/// El borrador del formulario y las copias privadas de sus fotos (R-07).
abstract interface class BorradorSolicitudRepository {
  Future<BorradorSolicitud?> leer();

  Future<void> guardar(BorradorSolicitud borrador);

  /// Prepara la foto (tipo, tamaño, 1600 px, sin EXIF) y guarda la copia en
  /// la carpeta privada. Devuelve su ruta, o lanza `FotoNoValidaFailure`.
  Future<String> agregarFoto(List<int> bytesOriginales);

  /// Borra la copia de una foto que la persona quitó.
  Future<void> quitarFoto(String ruta);

  /// Borra el borrador y todas las fotos (al enviar o descartar, CA-19).
  Future<void> borrarTodo();
}

/// De dónde salen las fotos: la cámara o el selector del sistema, sin pedir
/// permisos propios (D-12).
abstract interface class FuenteDeFotos {
  /// Los bytes de la foto tomada, o `null` si la persona canceló.
  Future<List<int>?> tomarConCamara();

  /// Los bytes de hasta [maximo] fotos elegidas (vacío si canceló).
  Future<List<List<int>>> elegirDeGaleria(int maximo);
}
