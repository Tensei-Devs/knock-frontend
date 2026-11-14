import 'package:app/core/errores/failure.dart';

/// Texto en español, comprensible, para cada [Failure] (spec 002 R-03).
///
/// No incluye códigos, URLs ni detalles técnicos. Textos literales hasta que
/// pasen a ARB.
String mensajeDeFailure(Failure falla) => switch (falla) {
  DatosInvalidosFailure() => 'Recibimos datos que no entendimos.',
  ServicioNoDisponibleFailure() =>
    'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.',
  ApiNoConfiguradaFailure() => 'La app no tiene configurado el servidor.',
  NoAutorizadoFailure() => 'Inicia sesión para continuar.',
  CuentaSuspendidaFailure() => 'Tu cuenta está suspendida.',
  AccesoDenegadoFailure() => 'No tienes permiso para hacer esto.',
  ConflictoFailure() => 'Esa acción choca con el estado actual de tu cuenta.',
  DatosRechazadosFailure() => 'Revisa los datos e inténtalo de nuevo.',
  DemasiadosIntentosFailure() =>
    'Demasiados intentos. Espera un momento e inténtalo de nuevo.',
  // Sin texto propio hasta que KNOCK-228 traiga la pantalla del aviso.
  AvisoNoAceptadoFailure() => 'Revisa los datos e inténtalo de nuevo.',
  CodigoIncorrectoFailure() => 'El código de verificación es incorrecto.',
  CodigoVencidoFailure() => 'El código de verificación venció. Solicita otro.',
  CelularRechazadoFailure() => 'El número de celular no es válido.',
  VerificacionNoDisponibleFailure() =>
    'La verificación por SMS no está disponible.',
  NoEncontradoFailure() => 'Esta solicitud ya no está disponible.',
  ContenidoRechazadoFailure() =>
    'Tu descripción no se pudo publicar. Revísala y quita datos personales o '
        'palabras ofensivas.',
  ModeracionNoDisponibleFailure() =>
    'No pudimos revisar tu descripción en este momento. Intenta de nuevo en '
        'unos minutos.',
  OpcionNoDisponibleFailure() =>
    'Ese oficio o esa colonia ya no están disponibles. Elige otra opción.',
  FotoNoValidaFailure() =>
    'Esa foto es muy pesada o no es JPG ni PNG. Elige otra.',
  AvisoNoPermitidoFailure() => 'Esta visita ya no permite avisos.',
  EleccionRechazadaFailure() =>
    'No se pudo confirmar esa cotización. Revisa la lista.',
};
