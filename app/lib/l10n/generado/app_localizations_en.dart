// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tecnicoCargando => 'Loading…';

  @override
  String get tecnicoReintentar => 'Try again';

  @override
  String get tecnicoNoDisponible => 'That pro is no longer available.';

  @override
  String tecnicoCopia(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'No connection. This is the copy from $fechaString; it may be out of date.';
  }

  @override
  String tecnicoCalificacion(String calificacion) {
    return '★ $calificacion';
  }

  @override
  String tecnicoAnios(int n) {
    return '$n years of experience';
  }

  @override
  String get tecnicoAtiendeTaller => 'Works at their shop';

  @override
  String get tecnicoAtiendeDomicilio => 'Comes to your home';

  @override
  String get tecnicoAtiendeAmbos => 'At the shop and at your home';

  @override
  String tecnicoRadio(int km) {
    return 'up to $km km';
  }

  @override
  String get tecnicoDisponibleHoy => 'Available today';

  @override
  String get tecnicoSinColonia =>
      'Choose your neighborhood to know whether they serve it.';

  @override
  String tecnicoLlega(String colonia) {
    return 'They serve $colonia';
  }

  @override
  String tecnicoNoLlega(String colonia) {
    return 'They don’t serve $colonia';
  }

  @override
  String get tecnicoServicios => 'Services and prices';

  @override
  String get tecnicoSinServicios => 'No services published yet.';

  @override
  String tecnicoDesde(String precio) {
    return 'from $precio';
  }

  @override
  String get tecnicoPreciosDeReferencia =>
      'These are reference prices. You agree the final price with the pro.';

  @override
  String get tecnicoFotos => 'Photos of their work';

  @override
  String get tecnicoSinFotos => 'No work photos yet.';

  @override
  String get tecnicoFotoEtiqueta => 'Photo of a finished job';

  @override
  String get tecnicoVerMasFotos => 'See more photos';

  @override
  String get citaExistente => 'Existing appointment';

  @override
  String get visitaRecuperacionFallida =>
      'We couldn\'t retrieve the visit. Check your activity.';

  @override
  String citaMonto(String monto) {
    return 'Quote: $monto';
  }

  @override
  String citaTope(String monto) {
    return 'Maximum: $monto';
  }

  @override
  String get appTitle => 'Knock';

  @override
  String get busquedaTitulo => 'Search';

  @override
  String get busquedaEtiqueta => 'What do you need?';

  @override
  String get busquedaPlaceholder => 'E.g.: boiler, brakes, an outlet';

  @override
  String get busquedaMinimo => 'Type at least 2 letters';

  @override
  String busquedaContador(int n) {
    return '$n/80';
  }

  @override
  String get busquedaCargando => 'Searching…';

  @override
  String get busquedaSugerencias => 'Suggestions';

  @override
  String get busquedaSoloVerificados => 'Verified only';

  @override
  String get busquedaSoloVerificadosActivo => 'Verified only, selected';

  @override
  String busquedaBuscamos(String oficio) {
    return 'Searching for: $oficio';
  }

  @override
  String get busquedaAmbiguo => 'Which of these do you need?';

  @override
  String get busquedaNoEntendimos => 'We didn’t understand what you need';

  @override
  String get busquedaElegirCategoria => 'Choose a category';

  @override
  String get busquedaSinResultados => 'We found no pros for that search.';

  @override
  String busquedaSinResultadosOficio(String oficio) {
    return 'There are no $oficio pros in your neighborhood yet';
  }

  @override
  String get busquedaPedirCotizacion => 'Request a quote anyway';

  @override
  String get busquedaSinZona => 'Choose your area to search for pros nearby';

  @override
  String get busquedaElegirZona => 'Choose my area';

  @override
  String get busquedaCargarMas => 'See more';

  @override
  String get busquedaTope =>
      'We show the first 100. Add more words to narrow it down.';

  @override
  String busquedaTotal(int n) {
    return '$n results';
  }

  @override
  String get busquedaReintentar => 'Try again';

  @override
  String get busquedaSinConexion => 'No connection';

  @override
  String get busquedaNoDisponible =>
      'Search is not available right now. Try again.';

  @override
  String get busquedaOtrasPalabras => 'Try other words';

  @override
  String busquedaEspera(int segundos) {
    return 'You searched many times in a row. Wait $segundos seconds.';
  }

  @override
  String busquedaCalificacion(String calificacion, int n) {
    return '$calificacion stars, $n reviews';
  }

  @override
  String busquedaDistancia(int km) {
    return 'about $km km away';
  }

  @override
  String busquedaVerificado(String nivel) {
    return 'Verified: $nivel';
  }

  @override
  String get busquedaNoAtiende => 'Doesn’t serve your neighborhood';

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
  String get entradaAvisoNoSeAbrio =>
      'We couldn\'t open the privacy notice. Please try again later.';

  @override
  String get entradaAvisoAbrirIndicacion => 'Opens in the browser';

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

  @override
  String solicitudVerCotizaciones(int cantidad) {
    return 'See and choose ($cantidad)';
  }

  @override
  String get cotizacionTitulo => 'Quotes';

  @override
  String get cotizacionOrdenRecomendadas => 'Recommended';

  @override
  String get cotizacionOrdenPrecio => 'Lowest price';

  @override
  String get cotizacionOrdenCalificacion => 'Top rated';

  @override
  String get cotizacionOrdenPronto => 'Soonest';

  @override
  String cotizacionMostrandoDe(int mostradas, int total) {
    return 'Showing $mostradas of $total';
  }

  @override
  String get cotizacionTiposMixtos =>
      'These quotes cover different things: check what each one includes';

  @override
  String cotizacionPrecioFijo(String precio) {
    return '$precio';
  }

  @override
  String cotizacionPrecioRango(String minimo, String maximo) {
    return '$minimo to $maximo';
  }

  @override
  String cotizacionPrecioVisita(String precio) {
    return 'Visit: $precio';
  }

  @override
  String cotizacionTope(String tope) {
    return 'Up to $tope';
  }

  @override
  String get cotizacionRequiereAprobacion =>
      'If the price goes up, the pro will ask for your approval';

  @override
  String get cotizacionEtiquetaVerificado => 'Verified';

  @override
  String get cotizacionEtiquetaMejorPrecio => 'Best price';

  @override
  String get cotizacionEtiquetaPronto => 'Can come sooner';

  @override
  String get cotizacionSinCalificaciones => 'No ratings yet';

  @override
  String cotizacionCalificacion(String calificacion) {
    return '$calificacion out of 5';
  }

  @override
  String cotizacionNivelVerificacion(String nivel) {
    return '$nivel verification';
  }

  @override
  String cotizacionCuando(String dia, String hora) {
    return '$dia at $hora';
  }

  @override
  String get cotizacionMotivoSinCotizaciones =>
      'No quotes yet. We\'ll let you know when the first one arrives.';

  @override
  String get cotizacionMotivoVencida =>
      'This request expired. You can make a new one.';

  @override
  String get cotizacionMotivoCancelada => 'This request was canceled.';

  @override
  String get cotizacionYaElegida =>
      'You already chose a quote for this request.';

  @override
  String get cotizacionVerMiVisita => 'See my visit';

  @override
  String get cotizacionElegir => 'Choose';

  @override
  String cotizacionConfirmarTitulo(String tecnico) {
    return 'Choose $tecnico?';
  }

  @override
  String get cotizacionConfirmarAvisoContacto =>
      'When you choose, you\'ll see the pro\'s phone and they\'ll see your service address. The other quotes will close.';

  @override
  String get cotizacionConfirmar => 'Confirm choice';

  @override
  String get cotizacionCancelar => 'Cancel';

  @override
  String get cotizacionEligiendo => 'Confirming your choice…';

  @override
  String get cotizacionCitaConfirmada => 'Appointment confirmed';

  @override
  String cotizacionTelefono(String telefono) {
    return 'Phone: $telefono';
  }

  @override
  String cotizacionWhatsapp(String whatsapp) {
    return 'WhatsApp: $whatsapp';
  }

  @override
  String get cotizacionSinTelefono =>
      'This pro didn\'t share a phone number. You\'ll be able to message them in the chat when it\'s available';

  @override
  String cotizacionLugar(String direccion) {
    return 'Place: $direccion';
  }

  @override
  String get cotizacionListo => 'Done';

  @override
  String get cotizacionRetirada =>
      'This quote is no longer available. Choose another one.';

  @override
  String get cotizacionErrorEleccion =>
      'We couldn\'t confirm your choice. Try again.';

  @override
  String get visitaTitulo => 'Your visit';

  @override
  String get visitaVerificado => 'Verified';

  @override
  String get visitaSinVerificar => 'Not verified';

  @override
  String visitaCuando(String dia, String hora) {
    return '$dia at $hora';
  }

  @override
  String get visitaCodigoTitulo => 'Your code';

  @override
  String visitaCodigoRegla(String tecnico) {
    return 'Ask $tecnico to tell you this code at the door. If they don\'t know it, don\'t open.';
  }

  @override
  String visitaCodigoEtiqueta(String digitos) {
    return 'Code: $digitos';
  }

  @override
  String get visitaOcultarCodigo => 'Hide code';

  @override
  String get visitaMostrarCodigo => 'Show code';

  @override
  String get visitaCodigoOculto => 'Code hidden';

  @override
  String get visitaMotivoUsado =>
      'The pro already confirmed their arrival with this code.';

  @override
  String get visitaMotivoVencido => 'This code expired.';

  @override
  String get visitaMotivoBloqueada =>
      'This visit was locked for security. The Knock team will review it.';

  @override
  String get visitaMotivoNoAplica => 'This appointment doesn\'t need a code.';

  @override
  String get visitaTaller => 'Appointment at the shop';

  @override
  String visitaDireccionTaller(String direccion) {
    return 'Address: $direccion';
  }

  @override
  String get visitaComoLlegar => 'Get directions';

  @override
  String get visitaSinMapas =>
      'We couldn\'t find a maps app. Copy the address to look it up.';

  @override
  String get visitaLlamar => 'Call';

  @override
  String get visitaWhatsapp => 'WhatsApp';

  @override
  String visitaNoSePudoAbrir(String numero) {
    return 'Couldn\'t open the app. The number is $numero.';
  }

  @override
  String get visitaAvisar => 'Tell someone you trust';

  @override
  String get visitaNoDisponible => 'This visit is no longer available.';

  @override
  String get visitaSinConexion =>
      'You\'re offline. We\'re showing your saved visit details.';

  @override
  String get visitaEstadoConfirmada => 'Confirmed';

  @override
  String get visitaEstadoEnCurso => 'In progress';

  @override
  String get visitaEstadoTerminada => 'Done';

  @override
  String get visitaEstadoCancelada => 'Canceled';

  @override
  String get avisoTitulo => 'Tell someone you trust';

  @override
  String get avisoVistaPrevia => 'Here\'s your message';

  @override
  String get avisoElige => 'Who do you want to tell?';

  @override
  String get avisoSinContactos =>
      'Add someone you trust to let them know when you have a visit';

  @override
  String get avisoPrivacidad => 'Your contacts are saved only on this phone';

  @override
  String get avisoAgregarContacto => 'Add contact';

  @override
  String get avisoEditarContacto => 'Edit contact';

  @override
  String avisoBorrarContacto(String nombre) {
    return 'Delete $nombre';
  }

  @override
  String avisoEditarA(String nombre) {
    return 'Edit $nombre';
  }

  @override
  String get avisoNombre => 'Name';

  @override
  String get avisoCelular => 'Mobile (10 digits)';

  @override
  String get avisoGuardar => 'Save';

  @override
  String get avisoCancelar => 'Cancel';

  @override
  String get avisoErrorNombre => 'Write a name of 2 to 40 characters';

  @override
  String get avisoErrorCelular => 'Write the 10 digits of the mobile number';

  @override
  String get avisoErrorRepetido => 'That number is already on your list';

  @override
  String get avisoErrorLleno =>
      'You already have 10 contacts. Delete one to add another.';

  @override
  String get avisoEnviarSms => 'Send by SMS';

  @override
  String get avisoEnviarWhatsapp => 'Send by WhatsApp';

  @override
  String get avisoCompartir => 'Share without saving';

  @override
  String get avisoSinApp => 'We couldn\'t find an app to send it. Use “Share”.';

  @override
  String get avisoNoPermitido => 'This visit no longer allows notices';

  @override
  String get avisoSinRegistro =>
      'We couldn\'t record the notice; you can still send it';

  @override
  String get avisoSinDatos =>
      'We couldn\'t prepare the notice. Try again when you\'re online.';

  @override
  String get avisoLocalEncabezado =>
      'Today I\'m getting a visit from a Knock pro.';

  @override
  String avisoLocalVerificado(String nombre) {
    return 'Their name is $nombre and they\'re verified by Knock.';
  }

  @override
  String avisoLocalSinVerificar(String nombre) {
    return 'Their name is $nombre; they\'re not verified yet.';
  }

  @override
  String avisoLocalCuando(String dia, String hora) {
    return 'They\'re coming on $dia at $hora.';
  }

  @override
  String get avisoLocalRecomendacion =>
      'I\'ll ask for the code at the door before opening.';

  @override
  String get cuentaContactosConfianza => 'Trusted contacts';

  @override
  String get avisoCerrar => 'Close';

  @override
  String get cuentaDescargarTitulo => 'Download my data';

  @override
  String get cuentaDescargarNoDisponible =>
      'Downloading your data is not available in this version yet.';

  @override
  String get cuentaDescargarCargando => 'Checking your file…';

  @override
  String get cuentaDescargarSinPedir =>
      'You have not requested your file yet. We prepare it within 48 hours.';

  @override
  String get cuentaDescargarEnPreparacion =>
      'We are preparing your file. It can take up to 48 hours.';

  @override
  String cuentaDescargarLista(String fecha) {
    return 'Your file is ready. The link expires on $fecha.';
  }

  @override
  String get cuentaDescargarVencida =>
      'Your previous file expired. You can request it again.';

  @override
  String get cuentaDescargarPedir => 'Request my file';

  @override
  String get cuentaActualizar => 'Refresh';

  @override
  String get cuentaDescargarAbrir => 'Download';

  @override
  String get cuentaDescargarPedida =>
      'We requested your file. It can take up to 48 hours.';

  @override
  String get cuentaDescargarYaEnCurso => 'We are already preparing your file.';

  @override
  String get cuentaDescargarNoAbrio => 'We could not open the link.';

  @override
  String get cuentaReintentar => 'Retry';

  @override
  String get cuentaConsentimientosCargando => 'Loading your consents…';

  @override
  String get cuentaConsentimientosVacio => 'There are no consents to show.';

  @override
  String get cuentaConsentimientoPromociones => 'Offers and news';

  @override
  String get cuentaConsentimientoPromocionesDetalle =>
      'Offers from experts and news from Knock';

  @override
  String get cuentaConsentimientoEncuestas => 'Surveys to improve Knock';

  @override
  String get cuentaConsentimientoEncuestasDetalle =>
      'Short questions after a service';

  @override
  String get cuentaConsentimientoRecomendaciones => 'Personalised suggestions';

  @override
  String get cuentaConsentimientoRecomendacionesDetalle =>
      'Suggestions based on your home and car';

  @override
  String get cuentaConsentimientoAviso => 'Privacy notice';

  @override
  String get cuentaConsentimientoTerminos => 'Terms and conditions';

  @override
  String get cuentaConsentimientoOtro => 'Other consent';

  @override
  String get cuentaConsentimientoObligatorio =>
      'Required: it cannot be turned off';

  @override
  String cuentaConsentimientoRegistro(String version, String fecha) {
    return 'Version $version · $fecha';
  }

  @override
  String get opinionesTitulo => 'Reviews';

  @override
  String reputacionNivel(String nivel) {
    return 'Level: $nivel';
  }

  @override
  String get reputacionNuevo => 'New';

  @override
  String get reputacionConfiable => 'Trusted';

  @override
  String get reputacionDestacado => 'Outstanding';

  @override
  String get agendaCargando => 'Loading your schedule…';

  @override
  String get agendaError => 'We could not load your schedule.';

  @override
  String get agendaVacia => 'You have no upcoming visits.';

  @override
  String get agendaSinMapa => 'Visit locations are not available on the map.';

  @override
  String get agendaVerMas => 'See more visits';

  @override
  String agendaEstado(String estado) {
    String _temp0 = intl.Intl.selectLogic(estado, {
      'confirmada': 'Confirmed',
      'en_curso': 'In progress',
      'terminada': 'Finished',
      'cancelada': 'Cancelled',
      'other': 'Status unavailable',
    });
    return '$_temp0';
  }

  @override
  String agendaModalidad(String modalidad) {
    String _temp0 = intl.Intl.selectLogic(modalidad, {
      'domicilio': 'At home',
      'taller': 'At workshop',
      'other': 'Mode unavailable',
    });
    return '$_temp0';
  }

  @override
  String get opinionesCargando => 'Loading reviews…';

  @override
  String get opinionesError => 'We could not load the reviews.';

  @override
  String get opinionesNoDisponible => 'That technician is no longer available.';

  @override
  String get opinionesReintentar => 'Try again';

  @override
  String get opinionesVacio =>
      'No reviews yet. The first ones arrive after their first job through Knock.';

  @override
  String opinionesCopia(String fecha) {
    return 'You are offline. This is what you saw on $fecha; it may be out of date.';
  }

  @override
  String opinionesPromedio(String promedio) {
    return '★ $promedio out of 5';
  }

  @override
  String opinionesTotal(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String opinionesEstrellas(int estrellas, int total) {
    return '$estrellas stars: $total';
  }

  @override
  String get opinionesVerTodas => 'See the reviews';

  @override
  String get opinionesVerMas => 'See more';

  @override
  String get opinionesServicioVerificado => 'Verified job';

  @override
  String get opinionesAnonima => 'Deleted user';

  @override
  String opinionesRespuesta(String texto) {
    return 'Technician reply: $texto';
  }

  @override
  String get opinionesPuntualidad => 'Punctuality';

  @override
  String get opinionesCalidad => 'Quality';

  @override
  String get opinionesPrecioJusto => 'Fair price';

  @override
  String get opinionesTrato => 'Treatment';

  @override
  String get opinionesCalificarTitulo => 'Rate the job';

  @override
  String get opinionesCalificarPregunta => 'How did it go?';

  @override
  String get opinionesCalificarBoton => 'Rate the job';

  @override
  String opinionesEstrellaBoton(int estrella) {
    return '$estrella out of 5 stars';
  }

  @override
  String opinionesParteBoton(String parte, int estrella) {
    return '$parte: $estrella out of 5 stars';
  }

  @override
  String get opinionesPorPartes => 'By category (optional)';

  @override
  String get opinionesComentario => 'Tell others how it went';

  @override
  String get opinionesGuardarConfianza => 'Save to my trusted technicians';

  @override
  String get opinionesPublicar => 'Post review';

  @override
  String get opinionesPublicando => 'Posting…';

  @override
  String get opinionesElige => 'Choose a star rating to continue';

  @override
  String get opinionesEnviada => 'We got your review. Thank you!';

  @override
  String get opinionesErrorNoPermitida =>
      'This visit can no longer be rated: you already reviewed it or 30 days have passed.';

  @override
  String get opinionesErrorYaRespondida => 'This review already has a reply.';

  @override
  String get opinionesVisitaNoDisponible =>
      'That visit is no longer available.';

  @override
  String get cuentaPendientesCargando => 'Checking what you have pending…';

  @override
  String get cuentaPendientesVacio =>
      'You have no open appointments or quotes.';

  @override
  String get cuentaPendientesTitulo => 'What you have pending';

  @override
  String cuentaPendientesCitas(int total) {
    return 'Open appointments: $total';
  }

  @override
  String cuentaPendientesCotizaciones(int total) {
    return 'Open quotes: $total';
  }

  @override
  String get cuentaPendientesNota =>
      'When you schedule the deletion, your open requests and pending quotes are cancelled and we let the people involved know.';

  @override
  String get cuentaEliminarTitulo => 'Delete account';

  @override
  String get cuentaEliminarPregunta =>
      'Are you sure you want to delete your account?';

  @override
  String get cuentaEliminarGracia =>
      'Your account will be scheduled for deletion in 7 days and you can cancel before then.';

  @override
  String get cuentaEliminarEscribe => 'Type ELIMINAR to confirm';

  @override
  String get cuentaEliminarVerifica =>
      'For your security, confirm your phone with an SMS code.';

  @override
  String get cuentaEliminarCelular => 'Your phone number (10 digits)';

  @override
  String get cuentaEliminarEnviarCodigo => 'Send me the code';

  @override
  String get cuentaEliminarCodigo => '6-digit code';

  @override
  String get cuentaEliminarVerificacionRechazada =>
      'We could not confirm your identity with that number. Use the phone number of this account and ask for a new code.';

  @override
  String get cuentaEliminarNoPermitida =>
      'It cannot be deleted right now: it is already scheduled or you have a visit in progress.';

  @override
  String get cuentaEliminarEnviando => 'One moment…';

  @override
  String get cuentaEliminarBoton => 'Delete my account';

  @override
  String get cuentaEliminarMejorNo => 'Never mind';

  @override
  String get cuentaEliminacionProgramada =>
      'Your account is scheduled for deletion';

  @override
  String cuentaEliminacionProgramadaEl(String fecha) {
    return 'Your account will be deleted on $fecha';
  }

  @override
  String get cuentaEliminacionDetalle =>
      'You have 7 days to change your mind: you can cancel the deletion before the period ends.';

  @override
  String get cuentaEliminacionCargando => 'Checking your account…';

  @override
  String get cuentaEliminacionNinguna => 'You have no scheduled deletion';

  @override
  String get cuentaEliminacionCancelar => 'Cancel the deletion';

  @override
  String get cuentaEliminacionCancelada =>
      'You cancelled the deletion of your account';

  @override
  String get cuentaEliminacionNadaQueCancelar =>
      'There is no scheduled deletion to cancel.';

  @override
  String get cuentaEliminacionIrACuenta => 'Go to My account';

  @override
  String get cuentaEliminacionSalir => 'Sign out';

  @override
  String get bloqueosMotivoAcoso => 'Harassment';

  @override
  String get bloqueosMotivoFraude => 'Fraud';

  @override
  String get bloqueosMotivoMalServicio => 'Poor service';

  @override
  String get bloqueosMotivoComportamiento => 'Inappropriate behavior';

  @override
  String get bloqueosMotivoPeligro => 'Danger';

  @override
  String get bloqueosMotivoOtro => 'Something else';

  @override
  String get bloqueosTitulo => 'Report a problem';

  @override
  String get bloqueosCargando => 'Loading…';

  @override
  String get bloqueosNoDisponible => 'You can\'t report from this visit.';

  @override
  String get bloqueosReintentar => 'Try again';

  @override
  String get bloqueosAviso911 => 'If you are in danger, call 911.';

  @override
  String get bloqueosRecibido => 'We got your report';

  @override
  String get bloqueosVolver => 'Back';

  @override
  String get bloqueosQuePaso => 'What happened?';

  @override
  String get bloqueosDescripcion =>
      'Tell us what happened (8 to 500 characters)';

  @override
  String get bloqueosEnviando => 'Sending…';

  @override
  String get bloqueosEnviar => 'Send report';

  @override
  String get bloqueosFalta =>
      'Choose what happened and write at least 8 characters';

  @override
  String get bloqueosMios => 'My reports';

  @override
  String get bloqueosCargandoLista => 'Loading your reports…';

  @override
  String get bloqueosErrorLista => 'We couldn\'t load your reports.';

  @override
  String get bloqueosVacio => 'You haven\'t made any reports.';

  @override
  String get bloqueosVerMas => 'See more';

  @override
  String get bloqueosApelacionEnviada => 'We sent your appeal';

  @override
  String get bloqueosEstadoAbierto => 'Under review';

  @override
  String get bloqueosEstadoDecidido => 'Decided';

  @override
  String get bloqueosEstadoEnApelacion => 'Under appeal';

  @override
  String get bloqueosEstadoOtro => 'Status unavailable';

  @override
  String get bloqueosApelar => 'Appeal the decision';

  @override
  String get bloqueosApelacionTexto =>
      'Explain why you appeal (8 to 500 characters)';

  @override
  String get bloqueosEnviarApelacion => 'Send appeal';

  @override
  String get bloqueosErrorYaBloqueado => 'You had already blocked this person.';

  @override
  String get bloqueosErrorApelacion => 'This report can no longer be appealed.';

  @override
  String get bloqueosPantallaBloquear => 'Block a person';

  @override
  String get bloqueosPersonasTitulo => 'Blocked people';

  @override
  String get bloqueosPersonasCargando => 'Loading who you blocked…';

  @override
  String get bloqueosPersonasError => 'We couldn\'t load your blocks.';

  @override
  String get bloqueosPersonasVacio => 'You haven\'t blocked anyone.';

  @override
  String get bloqueosBloqueadaEl => 'Blocked on';

  @override
  String get bloqueosDesbloquear => 'Unblock';

  @override
  String get bloqueosDesbloqueando => 'Unblocking…';

  @override
  String get bloqueosDesbloqueada => 'You unblocked this person.';

  @override
  String get bloqueosBloquear => 'Block this person';

  @override
  String get bloqueosBloqueando => 'Blocking…';

  @override
  String get bloqueosBloqueada => 'You blocked this person.';

  @override
  String get bloqueosBloquearAviso =>
      'They won\'t be able to message you or see you in searches.';

  @override
  String get bloqueosConfirmarBloqueoTitulo => 'Block this person?';

  @override
  String get bloqueosConfirmarBloqueo => 'Yes, block';

  @override
  String get bloqueosCancelar => 'Cancel';

  @override
  String get bloqueosDeshacer => 'Undo';

  @override
  String get bloqueosNoEncontrada => 'That person is no longer available.';

  @override
  String get bloqueosErrorYaNoBloqueada =>
      'That person wasn\'t blocked anymore.';

  @override
  String get bloqueosErrorNoBloquearse => 'You can\'t block yourself.';

  @override
  String get direccionesTitulo => 'My addresses';

  @override
  String get direccionesCargando => 'Loading your addresses…';

  @override
  String get direccionesError => 'We couldn’t load your addresses.';

  @override
  String get direccionesReintentar => 'Try again';

  @override
  String get direccionesVacio => 'You don’t have saved addresses yet.';

  @override
  String get direccionesAgregar => 'Add address';

  @override
  String get direccionesEditar => 'Edit';

  @override
  String get direccionesEliminar => 'Delete';

  @override
  String get direccionesPrincipal => 'Main';

  @override
  String get direccionesSinReferencias => 'No landmarks';

  @override
  String get direccionesNueva => 'New address';

  @override
  String get direccionesEditarTitulo => 'Edit address';

  @override
  String get direccionesCalle => 'Street and number';

  @override
  String get direccionesReferencias => 'Landmarks (optional)';

  @override
  String direccionesColonia(String colonia) {
    return 'Neighborhood: $colonia';
  }

  @override
  String direccionesCambiarColonia(String colonia) {
    return 'Use my current neighborhood: $colonia';
  }

  @override
  String get direccionesMarcarPrincipal => 'Use as main address';

  @override
  String get direccionesGuardar => 'Save address';

  @override
  String get direccionesGuardando => 'Saving…';

  @override
  String get direccionesCancelar => 'Cancel';

  @override
  String get direccionesConfirmarEliminar => 'Delete this address?';

  @override
  String get direccionesNoDisponible => 'That address is no longer available.';

  @override
  String get visitaReprogramar => 'Reschedule the appointment';

  @override
  String get visitaCancelar => 'Cancel the service';

  @override
  String get visitaCambioPendiente =>
      'A new date is waiting for a reply. Meanwhile, the current appointment stands.';

  @override
  String get visitaCancelarTitulo => 'Cancel the service?';

  @override
  String get visitaCancelarConfirmar => 'Yes, cancel';

  @override
  String get visitaCancelarAviso =>
      'With more than 24 h notice it is free. With less, it is recorded as a late cancellation and we notify right away.';

  @override
  String get visitaCancelarMotivo => 'Why are you cancelling?';

  @override
  String get visitaMotivoResuelto => 'I already solved it';

  @override
  String get visitaMotivoPlanes => 'My plans changed';

  @override
  String get visitaMotivoOtraOpcion => 'I found another option';

  @override
  String get visitaMotivoOtro => 'Another reason';

  @override
  String get visitaCancelada => 'You cancelled the service';

  @override
  String get visitaCanceladaTardia =>
      'You cancelled the service. It was recorded as a late cancellation.';

  @override
  String get visitaYaCerrada =>
      'This visit already ended or was already cancelled.';

  @override
  String get visitaReprogramarEnviar => 'Send change';

  @override
  String get visitaReprogramarExplicacion =>
      'Pick another day and time. The other person has to confirm it; meanwhile the current appointment stands.';

  @override
  String get visitaDia => 'Day';

  @override
  String get visitaHora => 'Time';

  @override
  String get visitaFechaMuyCercana => 'Pick a time at least 2 hours from now.';

  @override
  String get visitaReprogramacionEnviada =>
      'You sent the new date. It still has to be confirmed.';

  @override
  String get visitaNoReprogramable =>
      'This appointment can no longer be rescheduled: it started or ended, a change is pending, or it was changed twice.';

  @override
  String get visitaNoTerminadoBoton => 'The job was not finished';

  @override
  String get visitaNoTerminadoTitulo => 'Was the job not finished?';

  @override
  String get visitaNoTerminadoCampo => 'What is still pending?';

  @override
  String get visitaNoTerminadoAyuda =>
      'Write at least 8 characters. You can report it only once, up to 7 days later.';

  @override
  String get visitaNoTerminadoEnviar => 'Send report';

  @override
  String get visitaNoTerminadoEnviado =>
      'You sent your report. It will be reviewed.';

  @override
  String get visitaReporteCerrado =>
      'It can no longer be reported: more than 7 days passed or you already reported it.';

  @override
  String get visitaEnviando => 'Sending…';

  @override
  String get cotizacionFinalTitulo => 'Final quote';

  @override
  String get cotizacionFinalExplicacion =>
      'If you approve it, the job goes ahead at this price. If you reject it, you only pay for the visit.';

  @override
  String get cotizacionFinalAprobada => 'You approved the final quote.';

  @override
  String get cotizacionFinalRechazada =>
      'You rejected the final quote: you only pay for the visit.';

  @override
  String get cotizacionFinalVencida =>
      'The final quote expired without an answer.';

  @override
  String get cotizacionFinalYaDecidida =>
      'This final quote was already decided or has expired.';

  @override
  String get cotizacionAjusteTitulo => 'Price change to approve';

  @override
  String get cotizacionAjusteExplicacion =>
      'If you reject it, the price stays at the cap you already approved.';

  @override
  String get cotizacionAjusteAprobado => 'You approved the new price.';

  @override
  String get cotizacionAjusteRechazado => 'You rejected the price change.';

  @override
  String get cotizacionAjusteYaDecidido =>
      'This price change was already decided or has expired.';

  @override
  String cotizacionRespondeAntes(String fecha) {
    return 'Answer before $fecha';
  }

  @override
  String get cotizacionAprobar => 'Approve';

  @override
  String get cotizacionRechazar => 'Reject';

  @override
  String get cotizacionActualizar => 'Refresh';

  @override
  String get cotizacionCargandoPrecio => 'Checking for a price to approve…';

  @override
  String serviciosPrecioDesde(int precio) {
    return 'From \$$precio';
  }

  @override
  String get serviciosSinPerfil => 'You do not have a technician profile yet.';

  @override
  String get serviciosNoExiste => 'That service no longer exists.';

  @override
  String get serviciosLimite =>
      'You already have the maximum of 50 services. Remove one to add another.';

  @override
  String get serviciosOficioNoValido => 'That trade is not one of yours.';

  @override
  String get serviciosOficioMecanica => 'Auto repair';

  @override
  String get serviciosOficioPlomeria => 'Plumbing';

  @override
  String get serviciosOficioElectricidad => 'Electrical';

  @override
  String get serviciosTituloPropio => 'Services and reference prices';

  @override
  String get serviciosCrearPerfil => 'Create my technician profile';

  @override
  String get serviciosCargandoPropios => 'Loading your services…';

  @override
  String get serviciosErrorPropios => 'We could not load your services.';

  @override
  String get serviciosReintentar => 'Retry';

  @override
  String get serviciosListaParcial =>
      'For now we cannot look up the services you already saved. Changes you make now appear here.';

  @override
  String get serviciosVacioPropios => 'You have not added services yet.';

  @override
  String get serviciosEditar => 'Edit';

  @override
  String get serviciosQuitar => 'Remove';

  @override
  String get serviciosAgregar => 'Add service';

  @override
  String get serviciosErrorNombre => 'Enter the service name';

  @override
  String serviciosErrorNombreMax(int maximo) {
    return 'The name allows up to $maximo characters';
  }

  @override
  String serviciosErrorDetalleMax(int maximo) {
    return 'The details allow up to $maximo characters';
  }

  @override
  String get serviciosErrorPrecio =>
      'Enter a price in pesos, no decimals, greater than zero';

  @override
  String get serviciosErrorOficio => 'Choose the trade';

  @override
  String get serviciosNombre => 'Service name';

  @override
  String get serviciosNombreEjemplo => 'E.g. Faucet replacement';

  @override
  String get serviciosDetalle => 'Details';

  @override
  String get serviciosPrecio => 'Reference price (pesos)';

  @override
  String get serviciosOficioPregunta => 'Which trade is it for?';

  @override
  String get serviciosGuardar => 'Save service';

  @override
  String get serviciosCancelar => 'Cancel';

  @override
  String get serviciosTituloPublico => 'Services and prices';

  @override
  String get serviciosCargandoPublicos => 'Loading their services…';

  @override
  String get serviciosNoDisponible => 'That technician is no longer available.';

  @override
  String get serviciosErrorPublicos => 'We could not load their services.';

  @override
  String serviciosCopia(String fecha) {
    return 'Offline. This is the copy from $fecha and may be out of date.';
  }

  @override
  String get serviciosVacioPublico => 'No services published yet.';

  @override
  String get serviciosReferencia => 'Reference prices: this is not a quote.';

  @override
  String get pedirCargandoOpciones => 'Loading options…';

  @override
  String get pedirOficioNoDisponible =>
      'This trade is no longer available. You can type what is wrong.';

  @override
  String get pedirSinOpciones =>
      'We could not load the options. You can type what is wrong.';

  @override
  String get pedirOpcionesVacias =>
      'There are no suggestions: type what is wrong.';

  @override
  String get pedirReintentar => 'Try again';

  @override
  String pedirCopiaGuardada(String fecha) {
    return 'Offline: options saved on $fecha, they may be outdated.';
  }

  @override
  String pedirOficioNuevoFallo(String motivo) {
    return 'Your trade is on your profile, but we could not tell Knock. $motivo';
  }

  @override
  String get solicitudesAmpliar => 'Ask others too';

  @override
  String get solicitudesAmpliarExplicacion =>
      'You can keep waiting or also ask other experts nearby.';

  @override
  String get solicitudesAmpliada => 'Done: we asked more experts for a quote.';

  @override
  String get solicitudesNoAmpliable =>
      'This request can no longer be extended.';

  @override
  String get solicitudesNoDisponible => 'This request is no longer available.';

  @override
  String get cuentaNumeroTitulo => 'Change my number';

  @override
  String get cuentaRecuperarTitulo => 'Recover my account';

  @override
  String get cuentaNumeroExplicacion =>
      'We will text a code to your new number. Your account, jobs and messages stay the same.';

  @override
  String get cuentaRecuperarExplicacion =>
      'Enter your old number, the account type and your new number. We will text a code to the new one.';

  @override
  String get cuentaNumeroAnterior => 'Your old number (10 digits)';

  @override
  String get cuentaNumeroNuevo => 'New number (10 digits)';

  @override
  String get cuentaTipoCliente => 'I am a client';

  @override
  String get cuentaTipoTecnico => 'I am a technician';

  @override
  String get cuentaNumeroCodigo => '6-digit code';

  @override
  String get cuentaNumeroEnviarCodigo => 'Text me the code';

  @override
  String get cuentaNumeroConfirmar => 'Confirm';

  @override
  String get cuentaNumeroEntendido => 'Got it';

  @override
  String get cuentaNumeroOtro => 'Use another number';

  @override
  String get cuentaNumeroEnUso =>
      'That number already belongs to another account.';

  @override
  String get cuentaNumeroCambiado => 'Your number was changed.';

  @override
  String get cuentaRecuperarRecibida =>
      'We received your request. Someone on the team will review it.';

  @override
  String get verificacionCargando => 'Loading your verification…';

  @override
  String get verificacionReintentar => 'Try again';

  @override
  String get verificacionSinVerificar => 'Not verified';

  @override
  String get verificacionSinVerificarDetalle =>
      'Verification is optional and helps clients trust you.';

  @override
  String get verificacionFotosBorradas =>
      'Your photos were deleted because they were not reviewed in time. You can send them again.';

  @override
  String get verificacionEnRevision => 'Under review';

  @override
  String get verificacionEnRevisionDetalle => 'We review in less than 24 h';

  @override
  String get verificacionVerificadoBasico => 'Verified: basic';

  @override
  String get verificacionVerificadoCompleto => 'Verified: complete';

  @override
  String get verificacionVerificadoDetalle =>
      'Your profile shows the verified badge.';

  @override
  String get verificacionNoVerificado => 'We could not verify you';

  @override
  String get verificacionSinMotivo => 'No reason was given.';

  @override
  String verificacionEnviadaEl(String fecha) {
    return 'Sent on $fecha';
  }

  @override
  String get verificacionEnvioNoDisponible =>
      'Sending your photos from the app is not available yet.';
}
