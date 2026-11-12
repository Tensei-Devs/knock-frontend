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

  @override
  String get previaEntrar => 'Sign in';

  @override
  String get previaRegistrarme => 'Sign up';

  @override
  String get previaBuscadorTitulo => 'Find an expert near you';

  @override
  String get previaBuscadorLeyenda => 'Mechanics · Plumbing · Electrical';

  @override
  String get previaInvitacionTitulo => 'Sign in to continue';

  @override
  String get previaInvitacionDetalle =>
      'To find experts, request quotes and see their contact details you need an account.';

  @override
  String get previaAhoraNo => 'Not now';

  @override
  String get previaChipsEtiqueta => 'Trades';

  @override
  String get previaChipTodos => 'All';

  @override
  String get previaChipNoSeCual => 'I\'m not sure which';

  @override
  String get previaCatalogoTitulo => 'Available trades';

  @override
  String get previaCargando => 'Loading trades';

  @override
  String get previaVacioTitulo => 'There are no trades available yet';

  @override
  String get previaErrorTitulo => 'We couldn\'t load the trades';

  @override
  String get previaSinConexion => 'No connection. Showing the last saved data.';

  @override
  String get previaReintentar => 'Retry';

  @override
  String get previaModalidadDomicilio => 'At your home';

  @override
  String get previaModalidadTaller => 'At the workshop';

  @override
  String get previaExplorarTitulo => 'Explore services and jobs';

  @override
  String get previaExplorarDetalle =>
      'See the trades available on Knock without creating an account.';

  @override
  String get previaDatosDeEjemplo => 'Sample data';

  @override
  String get previaVerLista => 'See list';

  @override
  String get previaMapaSemantica => 'Sample map with experts. Sample data.';

  @override
  String previaExpertosCerca(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad experts near you',
      one: '$cantidad expert near you',
    );
    return '$_temp0';
  }

  @override
  String previaPinSemantica(String nombre) {
    return 'Sample expert: $nombre. Sample data. Tap to sign in.';
  }

  @override
  String previaTarjetaSemantica(String nombre, String oficio) {
    return '$nombre, $oficio. Sample data. Tap to sign in.';
  }

  @override
  String get previaYoAqui => 'You are here';

  @override
  String get previaMapaAcercar => 'Zoom in';

  @override
  String get previaMapaAlejar => 'Zoom out';

  @override
  String get previaMapaMiUbicacion => 'Back to my location';

  @override
  String get previaVerMapa => 'See map';

  @override
  String get previaPanelEtiqueta => 'Panel of experts near you';

  @override
  String previaDistanciaKm(String km) {
    return '$km km away';
  }

  @override
  String get actividadPedirCotizacion => 'Request your first quote';

  @override
  String get solicitudTitulo => 'Request a quote';

  @override
  String solicitudPasoDeTotal(int paso, int total) {
    return 'Step $paso of $total';
  }

  @override
  String get solicitudPaso1 => 'What do you need?';

  @override
  String get solicitudPaso2 => 'What\'s wrong?';

  @override
  String get solicitudPaso3 => 'When and where?';

  @override
  String get solicitudModalidadDomicilio => 'They come to your home';

  @override
  String get solicitudModalidadTaller => 'You take your car to the shop';

  @override
  String get solicitudDescripcion => 'Describe the problem';

  @override
  String get solicitudDescripcionAyuda =>
      'Tell the pro what happens, since when and what you already tried.';

  @override
  String get solicitudDescripcionCorta => 'Write at least 8 characters.';

  @override
  String get solicitudDescripcionLarga => 'Write 500 characters at most.';

  @override
  String solicitudFotos(int cantidad) {
    return 'Photos ($cantidad of 5)';
  }

  @override
  String get solicitudFotoFalta =>
      'Add at least one photo: it tells the pro what to bring';

  @override
  String get solicitudFotoMaximo => 'You already have 5 photos, the maximum.';

  @override
  String get solicitudFotoTomar => 'Take photo';

  @override
  String get solicitudFotoElegir => 'Choose from gallery';

  @override
  String solicitudFotoEtiqueta(int numero, int total) {
    return 'Photo $numero of $total';
  }

  @override
  String solicitudFotoQuitar(int numero) {
    return 'Remove photo $numero';
  }

  @override
  String get solicitudFotoNoValida =>
      'That photo is too large or isn\'t a JPG or PNG. Choose another one.';

  @override
  String get solicitudDia => 'Day';

  @override
  String get solicitudHoy => 'Today';

  @override
  String get solicitudFranja => 'Time';

  @override
  String get solicitudFranjaManana => 'Morning';

  @override
  String get solicitudFranjaTarde => 'Afternoon';

  @override
  String get solicitudFranjaNoche => 'Evening';

  @override
  String get solicitudFaltaDiaYFranja => 'Choose the day and the time.';

  @override
  String get solicitudTallerAviso => 'You\'ll take your car to the shop';

  @override
  String get solicitudDireccion => 'Street and number';

  @override
  String get solicitudDireccionAyuda => 'Only the pro you choose will see it.';

  @override
  String get solicitudDireccionCorta => 'Write at least 8 characters.';

  @override
  String get solicitudDireccionLarga => 'Write 200 characters at most.';

  @override
  String get solicitudSinZona =>
      'Choose your area in My account to send your request.';

  @override
  String get solicitudSiguiente => 'Next';

  @override
  String get solicitudAtras => 'Back';

  @override
  String get solicitudEnviar => 'Send request';

  @override
  String get solicitudEnviando => 'Sending…';

  @override
  String get solicitudEnviada => 'Request sent';

  @override
  String get solicitudDescartar => 'Discard draft';

  @override
  String solicitudEspera(int segundos) {
    return 'Too many attempts. Wait $segundos seconds.';
  }

  @override
  String get solicitudErrorContenidoRechazado =>
      'Your description couldn\'t be posted. Review it and remove personal data or offensive words.';

  @override
  String get solicitudErrorModeracion =>
      'We couldn\'t review your description right now. Try again in a few minutes.';

  @override
  String get solicitudErrorOpcionNoDisponible =>
      'That service or area is no longer available. Choose another option.';

  @override
  String get solicitudNoDisponible => 'This request is no longer available.';

  @override
  String get solicitudDetalleTitulo => 'Your request';

  @override
  String get solicitudEstadoEnviada => 'Sent';

  @override
  String get solicitudEstadoCotizando => 'Receiving quotes';

  @override
  String get solicitudEstadoCita => 'Appointment confirmed';

  @override
  String get solicitudEstadoTerminada => 'Done';

  @override
  String get solicitudEstadoCancelada => 'Canceled';

  @override
  String get solicitudEstadoVencida => 'Expired';

  @override
  String get solicitudEstadoEnProceso => 'In progress';

  @override
  String solicitudCuando(String dia, String franja) {
    return '$dia, $franja';
  }

  @override
  String solicitudTotalFotos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get solicitudVolverActividad => 'Back to Activity';
}
