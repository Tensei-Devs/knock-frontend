// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Knock';

  @override
  String get tabInicio => 'Inicio';

  @override
  String get tabExplorar => 'Explorar';

  @override
  String get explorarOficios => 'Oficios';

  @override
  String get tabActividad => 'Actividad';

  @override
  String get actividadVaciaTitulo => 'Aún no tienes actividad';

  @override
  String get actividadVaciaDetalle =>
      'Cuando pidas una cotización, aquí verás en qué va cada una.';

  @override
  String get tabTrabajo => 'Trabajo';

  @override
  String get tabCuenta => 'Mi cuenta';

  @override
  String get pruebaModoTecnico => 'Modo técnico (prueba)';

  @override
  String get configuracionTitulo => 'Configuración';

  @override
  String get configuracionIdioma => 'Idioma';

  @override
  String get configuracionIdiomaEspanol => 'Español';

  @override
  String get configuracionIdiomaIngles => 'English';

  @override
  String get configuracionTema => 'Tema';

  @override
  String get configuracionTemaAutomatico => 'Automático';

  @override
  String get configuracionTemaAutomaticoDetalle => 'Igual que el teléfono';

  @override
  String get configuracionTemaClaro => 'Claro';

  @override
  String get configuracionTemaOscuro => 'Oscuro';

  @override
  String get inicioSaludo => 'Hola';

  @override
  String get inicioZonaTitulo => 'Tu zona';

  @override
  String get inicioZonaSinPedir => 'Descubre si tu zona tiene cobertura.';

  @override
  String get inicioZonaBuscando => 'Buscando tu colonia…';

  @override
  String get inicioZonaFuera => 'Todavía no llegamos a tu zona.';

  @override
  String get inicioZonaSinUbicacion =>
      'Necesitamos tu ubicación para ubicar tu colonia.';

  @override
  String get inicioVerColonia => 'Ver mi colonia';

  @override
  String get inicioActualizar => 'Actualizar';

  @override
  String get inicioReintentar => 'Reintentar';

  @override
  String get inicioExplorarOficios => 'Explorar oficios';

  @override
  String get inicioExplorarOficiosDetalle =>
      'Mira qué técnicos puedes encontrar';

  @override
  String get cuentaEditarPerfil => 'Editar perfil';

  @override
  String get cuentaCerrarSesion => 'Cerrar sesión';

  @override
  String get cuentaCerrarSesionTitulo => '¿Cerrar sesión?';

  @override
  String get cuentaCerrarSesionCuerpo =>
      'Tendrás que volver a entrar para usar tu cuenta.';

  @override
  String get cuentaCancelar => 'Cancelar';

  @override
  String get permisoContinuar => 'Continuar';

  @override
  String get permisoAhoraNo => 'Ahora no';

  @override
  String get permisoNotificacionesTitulo => '¿Activar las notificaciones?';

  @override
  String get permisoNotificacionesCuerpo =>
      'Te avisamos cuando haya novedades en tus solicitudes, mensajes y visitas. Los avisos no muestran códigos ni direcciones.';

  @override
  String get permisoUbicacionTitulo => '¿Usar tu ubicación?';

  @override
  String get permisoUbicacionCuerpo =>
      'La usamos una sola vez para mostrarte técnicos de tu colonia. No la guardamos. Si prefieres, puedes escribir tu código postal.';

  @override
  String get avisosTitulo => 'Avisos';

  @override
  String get avisosCotizaciones => 'Cotizaciones';

  @override
  String get avisosMensajes => 'Mensajes';

  @override
  String get avisosVisitas => 'Visitas';

  @override
  String get avisosActivar => 'Activar notificaciones';

  @override
  String get avisosApagadas =>
      'Las notificaciones están apagadas en tu teléfono. La app sigue funcionando; puedes activarlas cuando quieras.';

  @override
  String get avisosAbrirAjustes => 'Abrir ajustes';

  @override
  String get avisosActivadas => 'Notificaciones activadas';

  @override
  String get zonaUsarUbicacion => 'Usar mi ubicación';

  @override
  String get zonaPideCodigoPostal =>
      'Sin la ubicación, escribe tu código postal para continuar.';

  @override
  String get zonaCodigoPostal => 'Código postal';

  @override
  String get zonaCodigoPostalInvalido =>
      'Escribe los 5 números de tu código postal.';

  @override
  String get zonaContinuar => 'Continuar';

  @override
  String get errorSinConexion =>
      'No pudimos conectar con Knock. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get errorSesionVencida =>
      'Tu sesión ya no es válida. Inicia sesión de nuevo.';

  @override
  String get errorCuentaSuspendida =>
      'Tu cuenta está suspendida. Contacta a soporte si crees que es un error.';

  @override
  String get errorAccesoDenegado => 'No tienes permiso para hacer esto.';

  @override
  String get errorConflicto =>
      'Esta acción choca con otra cuenta o con el estado actual. Revisa los datos e inténtalo de nuevo.';

  @override
  String get errorDatosRechazados =>
      'Revisa los datos que escribiste e inténtalo de nuevo.';

  @override
  String get errorDemasiadosIntentos =>
      'Hiciste demasiados intentos. Espera un momento e inténtalo de nuevo.';

  @override
  String get errorDatosInvalidos =>
      'Recibimos información que no pudimos leer. Inténtalo más tarde.';

  @override
  String get errorApiNoConfigurada =>
      'La app no está conectada a un servidor. Instala una versión oficial.';

  @override
  String get errorInesperado => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get errorCodigoIncorrecto =>
      'El código de verificación es incorrecto.';

  @override
  String get errorCodigoVencido =>
      'El código de verificación venció. Solicita otro.';

  @override
  String get errorCelularRechazado => 'El número de celular no es válido.';

  @override
  String get errorVerificacionNoDisponible =>
      'La verificación por SMS no está disponible.';

  @override
  String get entradaCelularTitulo => 'Entra con tu celular';

  @override
  String get entradaCelularDetalle => 'Te enviaremos un código por SMS';

  @override
  String get entradaCelularEtiqueta => 'Número de celular';

  @override
  String get entradaCelularAyuda => '10 dígitos sin el +52';

  @override
  String get entradaCelularError => 'Escribe los 10 dígitos de tu celular';

  @override
  String get entradaPrefijoPais => '+52';

  @override
  String get entradaContinuar => 'Continuar';

  @override
  String get entradaCargando => 'Enviando código…';

  @override
  String get entradaAvisoPrivacidad => 'aviso de privacidad';

  @override
  String entradaAceptoAviso(String aviso) {
    return 'Acepto el $aviso';
  }

  @override
  String get entradaAvisoError =>
      'Acepta el aviso de privacidad para continuar';

  @override
  String get entradaErrorCodigoIncorrecto =>
      'El código no es correcto. Revísalo e inténtalo otra vez.';

  @override
  String get entradaErrorCodigoVencido => 'El código venció. Pide otro.';

  @override
  String get entradaErrorCelularRechazado => 'Número de celular no válido.';

  @override
  String get entradaErrorCuentaSuspendida =>
      'Tu cuenta está suspendida. Si crees que es un error, escríbenos.';

  @override
  String get entradaErrorConflicto =>
      'Este número ya está ligado a otra cuenta. Escríbenos para revisarlo.';

  @override
  String get entradaErrorDatos =>
      'No pudimos procesar la entrada. Inténtalo otra vez.';

  @override
  String get entradaErrorDemasiadosIntentos =>
      'Hiciste muchos intentos. Espera un momento y vuelve a intentarlo.';

  @override
  String get entradaErrorSinConexion =>
      'No pudimos conectarnos. Revisa tu internet e inténtalo otra vez.';

  @override
  String get entradaErrorVerificacionNoDisponible =>
      'La verificación por SMS no está disponible en esta versión de la app.';

  @override
  String get entradaErrorApiNoConfigurada =>
      'La app no tiene servidor configurado.';

  @override
  String get entradaErrorGenerico =>
      'Error al iniciar sesión. Inténtalo de nuevo.';

  @override
  String get entradaErrorAvisoNoAceptado =>
      'Debes aceptar el aviso de privacidad antes de continuar.';

  @override
  String get entradaCodigoTitulo => 'Escribe el código';

  @override
  String entradaCodigoEnviadoA(String celular) {
    return 'Lo enviamos al +52 $celular';
  }

  @override
  String get entradaCodigoEtiqueta => 'Código de verificación';

  @override
  String get entradaCodigoError => 'Escribe los 6 dígitos del código';

  @override
  String get entradaEntrar => 'Entrar';

  @override
  String entradaReenviarEn(int segundos) {
    return 'Reenviar en $segundos s';
  }

  @override
  String get entradaReenviarCodigo => 'Reenviar código';

  @override
  String get entradaCambiarNumero => 'Cambiar número';
}
