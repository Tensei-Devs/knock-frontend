// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Knock';

  @override
  String get tabInicio => 'Home';

  @override
  String get tabExplorar => 'Explore';

  @override
  String get explorarOficios => 'Trades';

  @override
  String get tabActividad => 'Activity';

  @override
  String get actividadVaciaTitulo => 'You have no activity yet';

  @override
  String get actividadVaciaDetalle =>
      'When you ask for a quote, you will see here where each one stands.';

  @override
  String get tabTrabajo => 'Work';

  @override
  String get tabCuenta => 'My account';

  @override
  String get pruebaModoTecnico => 'Technician mode (test)';

  @override
  String get configuracionTitulo => 'Settings';

  @override
  String get configuracionIdioma => 'Language';

  @override
  String get configuracionIdiomaEspanol => 'Español';

  @override
  String get configuracionIdiomaIngles => 'English';

  @override
  String get configuracionTema => 'Theme';

  @override
  String get configuracionTemaAutomatico => 'Automatic';

  @override
  String get configuracionTemaAutomaticoDetalle => 'Same as your phone';

  @override
  String get configuracionTemaClaro => 'Light';

  @override
  String get configuracionTemaOscuro => 'Dark';

  @override
  String get inicioSaludo => 'Hello';

  @override
  String get inicioZonaTitulo => 'Your area';

  @override
  String get inicioZonaSinPedir => 'Find out if your area is covered.';

  @override
  String get inicioZonaBuscando => 'Looking up your neighborhood…';

  @override
  String get inicioZonaFuera => 'We do not cover your area yet.';

  @override
  String get inicioZonaSinUbicacion =>
      'We need your location to find your neighborhood.';

  @override
  String get inicioVerColonia => 'See my neighborhood';

  @override
  String get inicioActualizar => 'Refresh';

  @override
  String get inicioReintentar => 'Retry';

  @override
  String get inicioExplorarOficios => 'Browse trades';

  @override
  String get inicioExplorarOficiosDetalle =>
      'See which technicians you can find';

  @override
  String get cuentaEditarPerfil => 'Edit profile';

  @override
  String get cuentaCerrarSesion => 'Sign out';

  @override
  String get cuentaCerrarSesionTitulo => 'Sign out?';

  @override
  String get cuentaCerrarSesionCuerpo =>
      'You will need to sign in again to use your account.';

  @override
  String get cuentaCancelar => 'Cancel';

  @override
  String get permisoContinuar => 'Continue';

  @override
  String get permisoAhoraNo => 'Not now';

  @override
  String get permisoNotificacionesTitulo => 'Turn on notifications?';

  @override
  String get permisoNotificacionesCuerpo =>
      'We let you know about updates to your requests, messages and visits. Notifications never show codes or addresses.';

  @override
  String get permisoUbicacionTitulo => 'Use your location?';

  @override
  String get permisoUbicacionCuerpo =>
      'We use it once to show you technicians in your area. We don\'t store it. If you prefer, you can type your postal code.';

  @override
  String get avisosTitulo => 'Notifications';

  @override
  String get avisosCotizaciones => 'Quotes';

  @override
  String get avisosMensajes => 'Messages';

  @override
  String get avisosVisitas => 'Visits';

  @override
  String get avisosActivar => 'Turn on notifications';

  @override
  String get avisosApagadas =>
      'Notifications are turned off on your phone. The app keeps working; you can turn them on whenever you like.';

  @override
  String get avisosAbrirAjustes => 'Open settings';

  @override
  String get avisosActivadas => 'Notifications are on';

  @override
  String get zonaUsarUbicacion => 'Use my location';

  @override
  String get zonaPideCodigoPostal =>
      'Without your location, type your postal code to continue.';

  @override
  String get zonaCodigoPostal => 'Postal code';

  @override
  String get zonaCodigoPostalInvalido =>
      'Type the 5 digits of your postal code.';

  @override
  String get zonaContinuar => 'Continue';

  @override
  String get errorSinConexion =>
      'We couldn\'t reach Knock. Check your connection and try again.';

  @override
  String get errorSesionVencida =>
      'Your session is no longer valid. Please sign in again.';

  @override
  String get errorCuentaSuspendida =>
      'Your account is suspended. Contact support if you think this is a mistake.';

  @override
  String get errorAccesoDenegado => 'You don\'t have permission to do this.';

  @override
  String get errorConflicto =>
      'This action conflicts with another account or the current state. Check the data and try again.';

  @override
  String get errorDatosRechazados =>
      'Check the information you entered and try again.';

  @override
  String get errorDemasiadosIntentos =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get errorDatosInvalidos =>
      'We received information we couldn\'t read. Please try again later.';

  @override
  String get errorApiNoConfigurada =>
      'The app isn\'t connected to a server. Install an official version.';

  @override
  String get errorInesperado => 'Something went wrong. Please try again.';

  @override
  String get errorCodigoIncorrecto => 'The verification code is incorrect.';

  @override
  String get errorCodigoVencido =>
      'The verification code expired. Request another one.';

  @override
  String get errorCelularRechazado => 'The phone number is not valid.';

  @override
  String get errorVerificacionNoDisponible =>
      'SMS verification is not available.';

  @override
  String get entradaCelularTitulo => 'Sign in with your phone';

  @override
  String get entradaCelularDetalle => 'We will send you a code by SMS';

  @override
  String get entradaCelularEtiqueta => 'Phone number';

  @override
  String get entradaCelularAyuda => '10 digits without the +52';

  @override
  String get entradaCelularError => 'Write the 10 digits of your phone number';

  @override
  String get entradaPrefijoPais => '+52';

  @override
  String get entradaContinuar => 'Continue';

  @override
  String get entradaCargando => 'Sending code…';

  @override
  String get entradaAvisoPrivacidad => 'privacy notice';

  @override
  String entradaAceptoAviso(String aviso) {
    return 'I accept the $aviso';
  }

  @override
  String get entradaAvisoError => 'Accept the privacy notice to continue';

  @override
  String get entradaErrorCodigoIncorrecto =>
      'The code is not correct. Review it and try again.';

  @override
  String get entradaErrorCodigoVencido =>
      'The code expired. Request another one.';

  @override
  String get entradaErrorCelularRechazado => 'Invalid phone number.';

  @override
  String get entradaErrorCuentaSuspendida =>
      'Your account is suspended. If you think this is a mistake, write to us.';

  @override
  String get entradaErrorConflicto =>
      'This number is already linked to another account. Write to us to review it.';

  @override
  String get entradaErrorDatos => 'We couldn\'t process the entry. Try again.';

  @override
  String get entradaErrorDemasiadosIntentos =>
      'You made too many attempts. Wait a moment and try again.';

  @override
  String get entradaErrorSinConexion =>
      'We couldn\'t connect. Check your internet and try again.';

  @override
  String get entradaErrorVerificacionNoDisponible =>
      'SMS verification is not available in this version of the app.';

  @override
  String get entradaErrorApiNoConfigurada =>
      'The app has no server configured.';

  @override
  String get entradaErrorGenerico => 'Error signing in. Try again.';

  @override
  String get entradaErrorAvisoNoAceptado =>
      'You must accept the privacy notice before continuing.';

  @override
  String get entradaCodigoTitulo => 'Enter the code';

  @override
  String entradaCodigoEnviadoA(String celular) {
    return 'We sent it to +52 $celular';
  }

  @override
  String get entradaCodigoEtiqueta => 'Verification code';

  @override
  String get entradaCodigoError => 'Write the 6 digits of the code';

  @override
  String get entradaEntrar => 'Sign in';

  @override
  String entradaReenviarEn(int segundos) {
    return 'Resend in $segundos s';
  }

  @override
  String get entradaReenviarCodigo => 'Resend code';

  @override
  String get entradaCambiarNumero => 'Change number';
}
