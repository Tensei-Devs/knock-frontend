import 'package:app/core/errores/failure.dart';
import 'package:app/l10n/generado/app_localizations.dart';

/// Texto del ARB para cada error de la entrada (sin detalles técnicos).
String mensajeDeErrorDeEntrada(AppLocalizations textos, Failure error) =>
    switch (error) {
      CodigoIncorrectoFailure() => textos.entradaErrorCodigoIncorrecto,
      CodigoVencidoFailure() => textos.entradaErrorCodigoVencido,
      CelularRechazadoFailure() => textos.entradaErrorCelularRechazado,
      CuentaSuspendidaFailure() => textos.entradaErrorCuentaSuspendida,
      ConflictoFailure() => textos.entradaErrorConflicto,
      DatosRechazadosFailure() ||
      DatosInvalidosFailure() => textos.entradaErrorDatos,
      DemasiadosIntentosFailure() => textos.entradaErrorDemasiadosIntentos,
      ServicioNoDisponibleFailure() => textos.entradaErrorSinConexion,
      VerificacionNoDisponibleFailure() =>
        textos.entradaErrorVerificacionNoDisponible,
      ApiNoConfiguradaFailure() => textos.entradaErrorApiNoConfigurada,
      AvisoNoAceptadoFailure() => textos.entradaErrorAvisoNoAceptado,
      AccesoDenegadoFailure() ||
      NoAutorizadoFailure() ||
      // Errores de solicitudes (spec 015): no ocurren en la entrada.
      NoEncontradoFailure() ||
      ContenidoRechazadoFailure() ||
      ModeracionNoDisponibleFailure() ||
      OpcionNoDisponibleFailure() ||
      FotoNoValidaFailure() ||
      AvisoNoPermitidoFailure() ||
      EleccionRechazadaFailure() => textos.entradaErrorGenerico,
    };
