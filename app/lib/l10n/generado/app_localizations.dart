import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generado/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Nombre de la app (t├¡tulo de la tarea en el sistema). Es una marca: no se traduce.
  ///
  /// In es, this message translates to:
  /// **'Knock'**
  String get appTitle;

  /// Pesta├▒a de la barra inferior y t├¡tulo de la pantalla de inicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get tabInicio;

  /// Pesta├▒a de la barra inferior y t├¡tulo de la pantalla para buscar t├®cnicos.
  ///
  /// In es, this message translates to:
  /// **'Explorar'**
  String get tabExplorar;

  /// Acceso temporal de Explorar a la pantalla de oficios (TT-PRU-02); lo reemplaza la historia de Explorar.
  ///
  /// In es, this message translates to:
  /// **'Oficios'**
  String get explorarOficios;

  /// Pesta├▒a de la barra inferior y t├¡tulo de la pantalla con las solicitudes y su historial.
  ///
  /// In es, this message translates to:
  /// **'Actividad'**
  String get tabActividad;

  /// Pesta├▒a de la barra inferior y t├¡tulo de la pantalla de trabajo; solo la ven los t├®cnicos.
  ///
  /// In es, this message translates to:
  /// **'Trabajo'**
  String get tabTrabajo;

  /// Pesta├▒a de la barra inferior y t├¡tulo de la pantalla con los datos y la configuraci├│n de la cuenta.
  ///
  /// In es, this message translates to:
  /// **'Mi cuenta'**
  String get tabCuenta;

  /// Interruptor de prueba (solo fuera de la versi├│n de tienda) que da el rol de t├®cnico.
  ///
  /// In es, this message translates to:
  /// **'Modo t├®cnico (prueba)'**
  String get pruebaModoTecnico;

  /// Entrada de Mi cuenta y t├¡tulo de la pantalla para elegir idioma y tema.
  ///
  /// In es, this message translates to:
  /// **'Configuraci├│n'**
  String get configuracionTitulo;

  /// Encabezado del selector de idioma en Configuraci├│n.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get configuracionIdioma;

  /// Opci├│n del selector de idioma. Se escribe siempre en espa├▒ol, en cualquier idioma.
  ///
  /// In es, this message translates to:
  /// **'Espa├▒ol'**
  String get configuracionIdiomaEspanol;

  /// Opci├│n del selector de idioma. Se escribe siempre en ingl├®s, en cualquier idioma.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get configuracionIdiomaIngles;

  /// Encabezado del selector de tema en Configuraci├│n.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get configuracionTema;

  /// Opci├│n del selector de tema: seguir el tema claro u oscuro del tel├®fono.
  ///
  /// In es, this message translates to:
  /// **'Autom├ítico'**
  String get configuracionTemaAutomatico;

  /// Subt├¡tulo de la opci├│n Autom├ítico del selector de tema.
  ///
  /// In es, this message translates to:
  /// **'Igual que el tel├®fono'**
  String get configuracionTemaAutomaticoDetalle;

  /// Opci├│n del selector de tema: tema claro.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get configuracionTemaClaro;

  /// Opci├│n del selector de tema: tema oscuro.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get configuracionTemaOscuro;

  /// Saludo de Inicio; el nombre de la persona va en un texto aparte.
  ///
  /// In es, this message translates to:
  /// **'Hola'**
  String get inicioSaludo;

  /// T├¡tulo de la tarjeta de colonia en Inicio.
  ///
  /// In es, this message translates to:
  /// **'Tu zona'**
  String get inicioZonaTitulo;

  /// Texto inicial de la tarjeta de colonia en Inicio.
  ///
  /// In es, this message translates to:
  /// **'Descubre si tu zona tiene cobertura.'**
  String get inicioZonaSinPedir;

  /// Estado cargando de la tarjeta de colonia.
  ///
  /// In es, this message translates to:
  /// **'Buscando tu coloniaÔÇª'**
  String get inicioZonaBuscando;

  /// La ubicaci├│n est├í fuera de la cobertura.
  ///
  /// In es, this message translates to:
  /// **'Todav├¡a no llegamos a tu zona.'**
  String get inicioZonaFuera;

  /// Sin permiso de ubicaci├│n o servicio apagado.
  ///
  /// In es, this message translates to:
  /// **'Necesitamos tu ubicaci├│n para ubicar tu colonia.'**
  String get inicioZonaSinUbicacion;

  /// Bot├│n que consulta la colonia de la persona.
  ///
  /// In es, this message translates to:
  /// **'Ver mi colonia'**
  String get inicioVerColonia;

  /// Bot├│n que vuelve a consultar la colonia.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get inicioActualizar;

  /// Bot├│n tras un error al consultar la colonia o un intento fallido.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get inicioReintentar;

  /// Acceso de Inicio al cat├ílogo de oficios.
  ///
  /// In es, this message translates to:
  /// **'Explorar oficios'**
  String get inicioExplorarOficios;

  /// Detalle del acceso a oficios en Inicio.
  ///
  /// In es, this message translates to:
  /// **'Mira qu├® t├®cnicos puedes encontrar'**
  String get inicioExplorarOficiosDetalle;

  /// Detalle bajo el nombre en Mi cuenta.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get cuentaEditarPerfil;

  /// Entrada de Mi cuenta y bot├│n de confirmaci├│n del di├ílogo.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesi├│n'**
  String get cuentaCerrarSesion;

  /// T├¡tulo del di├ílogo de cierre de sesi├│n.
  ///
  /// In es, this message translates to:
  /// **'┬┐Cerrar sesi├│n?'**
  String get cuentaCerrarSesionTitulo;

  /// Cuerpo del di├ílogo de cierre de sesi├│n.
  ///
  /// In es, this message translates to:
  /// **'Tendr├ís que volver a entrar para usar tu cuenta.'**
  String get cuentaCerrarSesionCuerpo;

  /// Bot├│n que cierra el di├ílogo sin hacer nada.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cuentaCancelar;

  /// Bot├│n del aviso previo a un permiso: seguir y ver la petici├│n del sistema.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get permisoContinuar;

  /// Bot├│n del aviso previo a un permiso: no pedirlo ahora.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get permisoAhoraNo;

  /// T├¡tulo del aviso previo al permiso de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'┬┐Activar las notificaciones?'**
  String get permisoNotificacionesTitulo;

  /// Explicaci├│n previa al permiso de notificaciones: para qu├® sirve.
  ///
  /// In es, this message translates to:
  /// **'Te avisamos cuando haya novedades en tus solicitudes, mensajes y visitas. Los avisos no muestran c├│digos ni direcciones.'**
  String get permisoNotificacionesCuerpo;

  /// T├¡tulo del aviso previo al permiso de ubicaci├│n.
  ///
  /// In es, this message translates to:
  /// **'┬┐Usar tu ubicaci├│n?'**
  String get permisoUbicacionTitulo;

  /// Explicaci├│n previa al permiso de ubicaci├│n: para qu├® sirve y la alternativa.
  ///
  /// In es, this message translates to:
  /// **'La usamos una sola vez para mostrarte t├®cnicos de tu colonia. No la guardamos. Si prefieres, puedes escribir tu c├│digo postal.'**
  String get permisoUbicacionCuerpo;

  /// Encabezado de la secci├│n de Configuraci├│n para elegir qu├® avisos recibir.
  ///
  /// In es, this message translates to:
  /// **'Avisos'**
  String get avisosTitulo;

  /// Interruptor: avisos de cotizaciones.
  ///
  /// In es, this message translates to:
  /// **'Cotizaciones'**
  String get avisosCotizaciones;

  /// Interruptor: avisos de mensajes.
  ///
  /// In es, this message translates to:
  /// **'Mensajes'**
  String get avisosMensajes;

  /// Interruptor: avisos de visitas.
  ///
  /// In es, this message translates to:
  /// **'Visitas'**
  String get avisosVisitas;

  /// Bot├│n que inicia la petici├│n del permiso de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Activar notificaciones'**
  String get avisosActivar;

  /// Mensaje cuando no hay permiso de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Las notificaciones est├ín apagadas en tu tel├®fono. La app sigue funcionando; puedes activarlas cuando quieras.'**
  String get avisosApagadas;

  /// Bot├│n que abre los ajustes del tel├®fono para cambiar un permiso negado.
  ///
  /// In es, this message translates to:
  /// **'Abrir ajustes'**
  String get avisosAbrirAjustes;

  /// Mensaje cuando el permiso de notificaciones est├í concedido.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones activadas'**
  String get avisosActivadas;

  /// Bot├│n para elegir la zona con la ubicaci├│n del tel├®fono.
  ///
  /// In es, this message translates to:
  /// **'Usar mi ubicaci├│n'**
  String get zonaUsarUbicacion;

  /// Mensaje cuando no hay ubicaci├│n y se ofrece el c├│digo postal.
  ///
  /// In es, this message translates to:
  /// **'Sin la ubicaci├│n, escribe tu c├│digo postal para continuar.'**
  String get zonaPideCodigoPostal;

  /// Etiqueta del campo del c├│digo postal.
  ///
  /// In es, this message translates to:
  /// **'C├│digo postal'**
  String get zonaCodigoPostal;

  /// Error del campo de c├│digo postal.
  ///
  /// In es, this message translates to:
  /// **'Escribe los 5 n├║meros de tu c├│digo postal.'**
  String get zonaCodigoPostalInvalido;

  /// Bot├│n que confirma el c├│digo postal.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get zonaContinuar;

  /// Error com├║n: sin conexi├│n o servicio no disponible (5xx).
  ///
  /// In es, this message translates to:
  /// **'No pudimos conectar con Knock. Revisa tu conexi├│n e int├®ntalo de nuevo.'**
  String get errorSinConexion;

  /// Error com├║n: la API rechaz├│ la credencial (401) y no se pudo renovar.
  ///
  /// In es, this message translates to:
  /// **'Tu sesi├│n ya no es v├ílida. Inicia sesi├│n de nuevo.'**
  String get errorSesionVencida;

  /// Error com├║n: cuenta suspendida (403 account_suspended).
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta est├í suspendida. Contacta a soporte si crees que es un error.'**
  String get errorCuentaSuspendida;

  /// Error com├║n: acceso negado (403).
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para hacer esto.'**
  String get errorAccesoDenegado;

  /// Error com├║n: conflicto (409).
  ///
  /// In es, this message translates to:
  /// **'Esta acci├│n choca con otra cuenta o con el estado actual. Revisa los datos e int├®ntalo de nuevo.'**
  String get errorConflicto;

  /// Error com├║n: datos rechazados (400, 413 o 422).
  ///
  /// In es, this message translates to:
  /// **'Revisa los datos que escribiste e int├®ntalo de nuevo.'**
  String get errorDatosRechazados;

  /// Error com├║n: l├¡mite de intentos (429).
  ///
  /// In es, this message translates to:
  /// **'Hiciste demasiados intentos. Espera un momento e int├®ntalo de nuevo.'**
  String get errorDemasiadosIntentos;

  /// Error com├║n: la respuesta no cumple el contrato.
  ///
  /// In es, this message translates to:
  /// **'Recibimos informaci├│n que no pudimos leer. Int├®ntalo m├ís tarde.'**
  String get errorDatosInvalidos;

  /// Error com├║n: falta KNOCK_API_URL al compilar.
  ///
  /// In es, this message translates to:
  /// **'La app no est├í conectada a un servidor. Instala una versi├│n oficial.'**
  String get errorApiNoConfigurada;

  /// Error com├║n: cualquier fallo no previsto; nunca muestra detalles t├®cnicos.
  ///
  /// In es, this message translates to:
  /// **'Algo sali├│ mal. Int├®ntalo de nuevo.'**
  String get errorInesperado;

  /// Error com├║n: c├│digo de SMS incorrecto.
  ///
  /// In es, this message translates to:
  /// **'El c├│digo de verificaci├│n es incorrecto.'**
  String get errorCodigoIncorrecto;

  /// Error com├║n: c├│digo de SMS vencido.
  ///
  /// In es, this message translates to:
  /// **'El c├│digo de verificaci├│n venci├│. Solicita otro.'**
  String get errorCodigoVencido;

  /// Error com├║n: n├║mero de celular rechazado por Firebase.
  ///
  /// In es, this message translates to:
  /// **'El n├║mero de celular no es v├ílido.'**
  String get errorCelularRechazado;

  /// Error com├║n: falta google-services.json en la compilaci├│n.
  ///
  /// In es, this message translates to:
  /// **'La verificaci├│n por SMS no est├í disponible.'**
  String get errorVerificacionNoDisponible;

  /// T├Łtulo de la pantalla de entrada con celular.
  ///
  /// In es, this message translates to:
  /// **'Entra con tu celular'**
  String get entradaCelularTitulo;

  /// Texto de ayuda debajo del t├Łtulo de entrada.
  ///
  /// In es, this message translates to:
  /// **'Te enviaremos un código por SMS'**
  String get entradaCelularDetalle;

  /// Etiqueta del campo de n├║mero de celular.
  ///
  /// In es, this message translates to:
  /// **'N├║mero de celular'**
  String get entradaCelularEtiqueta;

  /// Texto de ayuda del campo de n├║mero de celular.
  ///
  /// In es, this message translates to:
  /// **'10 d├Łgitos sin el +52'**
  String get entradaCelularAyuda;

  /// Error del campo de n├║mero de celular.
  ///
  /// In es, this message translates to:
  /// **'Escribe los 10 dígitos de tu celular'**
  String get entradaCelularError;

  /// Prefijo de pa├Łs fijo mostrado junto al campo de celular (sin selector +52/+1).
  ///
  /// In es, this message translates to:
  /// **'+52'**
  String get entradaPrefijoPais;

  /// Bot├│n de la pantalla de entrada para pedir el c├│digo SMS.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get entradaContinuar;

  /// Etiqueta del bot├│n mientras se env├Ła el c├│digo SMS.
  ///
  /// In es, this message translates to:
  /// **'Enviando c├│digo…'**
  String get entradaCargando;

  /// Texto del aviso de privacidad en la casilla de entrada.
  ///
  /// In es, this message translates to:
  /// **'Acepto el aviso de privacidad'**
  String get entradaAvisoPrivacidad;

  /// Texto completo de la casilla de aceptaci├│n del aviso de privacidad.
  ///
  /// In es, this message translates to:
  /// **'Acepto el {aviso}'**
  String entradaAceptoAviso(String aviso);

  /// Error mostrado si no se acepta el aviso de privacidad.
  ///
  /// In es, this message translates to:
  /// **'Acepta el aviso de privacidad para continuar'**
  String get entradaAvisoError;

  /// Error de entrada: c├│digo SMS incorrecto.
  ///
  /// In es, this message translates to:
  /// **'El c├│digo no es correcto. Revísalo e int├®ntalo otra vez.'**
  String get entradaErrorCodigoIncorrecto;

  /// Error de entrada: c├│digo SMS vencido.
  ///
  /// In es, this message translates to:
  /// **'El c├│digo venci├│. Pide otro.'**
  String get entradaErrorCodigoVencido;

  /// Error de entrada: celular rechazado por Firebase.
  ///
  /// In es, this message translates to:
  /// **'N├║mero de celular no v├ílido.'**
  String get entradaErrorCelularRechazado;

  /// Error de entrada: cuenta suspendida.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta est├í suspendida. Si crees que es un error, escr├¡benos.'**
  String get entradaErrorCuentaSuspendida;

  /// Error de entrada: conflicto de cuenta.
  ///
  /// In es, this message translates to:
  /// **'Este n├║mero ya est├í ligado a otra cuenta. Escr├¡benos para revisarlo.'**
  String get entradaErrorConflicto;

  /// Error de entrada: datos rechazados o inv├ílidos.
  ///
  /// In es, this message translates to:
  /// **'No pudimos procesar la entrada. Int├®ntalo otra vez.'**
  String get entradaErrorDatos;

  /// Error de entrada: demasiados intentos.
  ///
  /// In es, this message translates to:
  /// **'Hiciste muchos intentos. Espera un momento y vuelve a intentarlo.'**
  String get entradaErrorDemasiadosIntentos;

  /// Error de entrada: sin conexi├│n.
  ///
  /// In es, this message translates to:
  /// **'No pudimos conectarnos. Revisa tu internet e int├®ntalo otra vez.'**
  String get entradaErrorSinConexion;

  /// Error de entrada: verificaci├│n SMS no disponible.
  ///
  /// In es, this message translates to:
  /// **'La verificaci├│n por SMS no est├í disponible en esta versi├│n de la app.'**
  String get entradaErrorVerificacionNoDisponible;

  /// Error de entrada: API no configurada.
  ///
  /// In es, this message translates to:
  /// **'La app no tiene servidor configurado.'**
  String get entradaErrorApiNoConfigurada;

  /// Error de entrada gen├®rico.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesi├│n. Int├®ntalo de nuevo.'**
  String get entradaErrorGenerico;

  /// Error de entrada: aviso de privacidad no aceptado.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar el aviso de privacidad antes de continuar.'**
  String get entradaErrorAvisoNoAceptado;

  /// T├Łtulo de la pantalla de verificaci├│n del c├│digo SMS.
  ///
  /// In es, this message translates to:
  /// **'Escribe el c├│digo'**
  String get entradaCodigoTitulo;

  /// Texto de detalle de la pantalla de verificaci├│n.
  ///
  /// In es, this message translates to:
  /// **'Lo enviamos al +52 {celular}'**
  String entradaCodigoEnviadoA(String celular);

  /// Etiqueta del campo de c├│digo SMS.
  ///
  /// In es, this message translates to:
  /// **'C├│digo de verificaci├│n'**
  String get entradaCodigoEtiqueta;

  /// Error del campo de c├│digo SMS.
  ///
  /// In es, this message translates to:
  /// **'Escribe los 6 dígitos del código'**
  String get entradaCodigoError;

  /// Bot├│n de la pantalla de verificaci├│n para validar el c├│digo.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get entradaEntrar;

  /// Texto del bot├│n de reenv├Ło con cuenta regresiva.
  ///
  /// In es, this message translates to:
  /// **'Reenviar en {segundos} s'**
  String entradaReenviarEn(int segundos);

  /// Bot├│n de texto para reenviar el c├│digo SMS.
  ///
  /// In es, this message translates to:
  /// **'Reenviar código'**
  String get entradaReenviarCodigo;

  /// Bot├│n de texto para volver a escribir el n├║mero de celular.
  ///
  /// In es, this message translates to:
  /// **'Cambiar n├║mero'**
  String get entradaCambiarNumero;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
