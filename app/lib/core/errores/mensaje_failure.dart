import 'package:app/core/errores/failure.dart';
import 'package:app/l10n/generado/app_localizations.dart';

/// Texto que ve la persona para un error (spec 002, R-03 y CA-02).
///
/// Sale de los ARB, así que sigue el idioma activo (en español para quien usa
/// la app en español). Nunca incluye el cuerpo de la respuesta, URLs ni
/// `toString()` del error: un fallo que no es [Failure] cae en el mensaje
/// genérico.
String mensajeDeError(AppLocalizations textos, Object error) {
  if (error is! Failure) return textos.errorInesperado;
  return switch (error) {
    ServicioNoDisponibleFailure() => textos.errorSinConexion,
    NoAutorizadoFailure() => textos.errorSesionVencida,
    CuentaSuspendidaFailure() => textos.errorCuentaSuspendida,
    AccesoDenegadoFailure() => textos.errorAccesoDenegado,
    ConflictoFailure() => textos.errorConflicto,
    DatosRechazadosFailure() => textos.errorDatosRechazados,
    DemasiadosIntentosFailure() => textos.errorDemasiadosIntentos,
    DatosInvalidosFailure() => textos.errorDatosInvalidos,
    ApiNoConfiguradaFailure() => textos.errorApiNoConfigurada,
    // Sin texto propio hasta que KNOCK-228 traiga la pantalla del aviso.
    AvisoNoAceptadoFailure() => textos.errorDatosRechazados,
    CodigoIncorrectoFailure() => textos.errorCodigoIncorrecto,
    CodigoVencidoFailure() => textos.errorCodigoVencido,
    CelularRechazadoFailure() => textos.errorCelularRechazado,
    VerificacionNoDisponibleFailure() => textos.errorVerificacionNoDisponible,
    NoEncontradoFailure() => textos.solicitudNoDisponible,
    SolicitudVencidaFailure() => textos.solicitudVencidaAviso,
    SolicitudRechazadaFailure(:final motivo) => switch (motivo) {
      MotivoSolicitudRechazada.contenidoRechazado =>
        textos.solicitudErrorContenido,
      MotivoSolicitudRechazada.moderacionNoDisponible =>
        textos.solicitudErrorModeracion,
      MotivoSolicitudRechazada.oficioOColoniaNoDisponible =>
        textos.solicitudErrorOficioColonia,
      MotivoSolicitudRechazada.fotoNoValida =>
        textos.solicitudErrorFotoNoValida,
    },
  };
}
