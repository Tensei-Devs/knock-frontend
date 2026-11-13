/// Error tipado de la app (constitución: los errores de la API y de los datos
/// llegan a la interfaz como `Failure`, nunca como excepciones crudas).
///
/// No lleva mensajes técnicos, URLs ni datos: la pantalla decide el texto que
/// ve la persona. TT-MOB-03 lo amplía con los ProblemDetails de la API.
sealed class Failure implements Exception {
  const Failure();

  @override
  String toString() => runtimeType.toString();
}

/// Los datos recibidos no cumplen el contrato (campo ausente, vacío o de otro
/// tipo).
final class DatosInvalidosFailure extends Failure {
  const DatosInvalidosFailure();
}

/// No se pudo obtener la información (sin conexión o servicio no disponible).
final class ServicioNoDisponibleFailure extends Failure {
  const ServicioNoDisponibleFailure();
}

/// La app se compiló sin `--dart-define=KNOCK_API_URL=...` (spec 006).
final class ApiNoConfiguradaFailure extends Failure {
  const ApiNoConfiguradaFailure();
}

/// La API rechazó la credencial (401).
final class NoAutorizadoFailure extends Failure {
  const NoAutorizadoFailure();
}

/// La cuenta está suspendida (403 con `code = account_suspended`).
final class CuentaSuspendidaFailure extends Failure {
  const CuentaSuspendidaFailure();
}

/// La API negó el acceso por otro motivo (403).
final class AccesoDenegadoFailure extends Failure {
  const AccesoDenegadoFailure();
}

/// Conflicto con otra cuenta o con el estado actual (409).
final class ConflictoFailure extends Failure {
  const ConflictoFailure();
}

/// La API rechazó los datos enviados (400, 413 o 422).
final class DatosRechazadosFailure extends Failure {
  const DatosRechazadosFailure();
}

/// Demasiados intentos en poco tiempo (429).
///
/// [espera] es el tiempo que la API pidió con `Retry-After` (spec 009, R-09);
/// `null` si el error no viene de una respuesta con esa cabecera.
final class DemasiadosIntentosFailure extends Failure {
  const DemasiadosIntentosFailure({this.espera});

  final Duration? espera;
}

/// La persona no aceptó el aviso de privacidad: no se llama al servidor
/// (spec 009, R-08).
final class AvisoNoAceptadoFailure extends Failure {
  const AvisoNoAceptadoFailure();
}

/// El código del SMS no es el correcto (Firebase `invalid-verification-code`).
final class CodigoIncorrectoFailure extends Failure {
  const CodigoIncorrectoFailure();
}

/// El código del SMS ya venció; hay que pedir otro.
final class CodigoVencidoFailure extends Failure {
  const CodigoVencidoFailure();
}

/// Firebase rechazó el número de celular (`invalid-phone-number`).
final class CelularRechazadoFailure extends Failure {
  const CelularRechazadoFailure();
}

/// La verificación por SMS no está disponible: falta la configuración de
/// Firebase (`google-services.json`) en esta compilación.
final class VerificacionNoDisponibleFailure extends Failure {
  const VerificacionNoDisponibleFailure();
}

/// El recurso no existe o es de otra persona (404). La app no distingue los
/// dos casos (spec 015, CA-13).
final class NoEncontradoFailure extends Failure {
  const NoEncontradoFailure();
}

/// La moderación rechazó el texto (422 `content_rejected`, spec 015 CA-22).
final class ContenidoRechazadoFailure extends Failure {
  const ContenidoRechazadoFailure();
}

/// La moderación no respondió (503 `moderation_unavailable`, spec 015 CA-22).
final class ModeracionNoDisponibleFailure extends Failure {
  const ModeracionNoDisponibleFailure();
}

/// El oficio o la colonia ya no existen (422 `trade_invalid` o
/// `colonia_not_found`, spec 015 §7).
final class OpcionNoDisponibleFailure extends Failure {
  const OpcionNoDisponibleFailure();
}

/// Una foto no se puede usar: no es JPEG ni PNG, pesa más de 5 MB, es enorme
/// o no se puede leer (spec 015, CA-18).
final class FotoNoValidaFailure extends Failure {
  const FotoNoValidaFailure();
}

/// Por qué el servidor rechazó una elección de cotización (409, spec 015
/// CA-12, códigos de backend 021 en inglés).
enum MotivoEleccionRechazada {
  /// `request_already_chosen`.
  yaElegida,

  /// `quote_unavailable`.
  cotizacionNoDisponible,

  /// `request_expired`.
  vencida,

  /// `request_cancelled`.
  cancelada,

  /// `request_without_quotes`.
  sinCotizaciones,
}

/// El servidor rechazó la elección por el estado de la solicitud o de la
/// cotización (409). No se crea cita y la app no reintenta sola (CA-12).
final class EleccionRechazadaFailure extends Failure {
  const EleccionRechazadaFailure(this.motivo);

  final MotivoEleccionRechazada motivo;
}
