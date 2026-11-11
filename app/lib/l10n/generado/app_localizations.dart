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

  /// Nombre de la app (título de la tarea en el sistema). Es una marca: no se traduce.
  ///
  /// In es, this message translates to:
  /// **'Knock'**
  String get appTitle;

  /// Pestaña de la barra inferior y título de la pantalla de inicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get tabInicio;

  /// Pestaña de la barra inferior y título de la pantalla para buscar técnicos.
  ///
  /// In es, this message translates to:
  /// **'Explorar'**
  String get tabExplorar;

  /// Acceso temporal de Explorar a la pantalla de oficios (TT-PRU-02); lo reemplaza la historia de Explorar.
  ///
  /// In es, this message translates to:
  /// **'Oficios'**
  String get explorarOficios;

  /// Pestaña de la barra inferior y título de la pantalla con las solicitudes y su historial.
  ///
  /// In es, this message translates to:
  /// **'Actividad'**
  String get tabActividad;

  /// Título del estado vacío de la pestaña Actividad.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes actividad'**
  String get actividadVaciaTitulo;

  /// Detalle del estado vacío de la pestaña Actividad.
  ///
  /// In es, this message translates to:
  /// **'Cuando pidas una cotización, aquí verás en qué va cada una.'**
  String get actividadVaciaDetalle;

  /// Pestaña de la barra inferior y título de la pantalla de trabajo; solo la ven los técnicos.
  ///
  /// In es, this message translates to:
  /// **'Trabajo'**
  String get tabTrabajo;

  /// Pestaña de la barra inferior y título de la pantalla con los datos y la configuración de la cuenta.
  ///
  /// In es, this message translates to:
  /// **'Mi cuenta'**
  String get tabCuenta;

  /// Interruptor de prueba (solo fuera de la versión de tienda) que da el rol de técnico.
  ///
  /// In es, this message translates to:
  /// **'Modo técnico (prueba)'**
  String get pruebaModoTecnico;

  /// Entrada de Mi cuenta y título de la pantalla para elegir idioma y tema.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get configuracionTitulo;

  /// Encabezado del selector de idioma en Configuración.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get configuracionIdioma;

  /// Opción del selector de idioma. Se escribe siempre en español, en cualquier idioma.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get configuracionIdiomaEspanol;

  /// Opción del selector de idioma. Se escribe siempre en inglés, en cualquier idioma.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get configuracionIdiomaIngles;

  /// Encabezado del selector de tema en Configuración.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get configuracionTema;

  /// Opción del selector de tema: seguir el tema claro u oscuro del teléfono.
  ///
  /// In es, this message translates to:
  /// **'Automático'**
  String get configuracionTemaAutomatico;

  /// Subtítulo de la opción Automático del selector de tema.
  ///
  /// In es, this message translates to:
  /// **'Igual que el teléfono'**
  String get configuracionTemaAutomaticoDetalle;

  /// Opción del selector de tema: tema claro.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get configuracionTemaClaro;

  /// Opción del selector de tema: tema oscuro.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get configuracionTemaOscuro;

  /// Saludo de Inicio; el nombre de la persona va en un texto aparte.
  ///
  /// In es, this message translates to:
  /// **'Hola'**
  String get inicioSaludo;

  /// Título de la tarjeta de colonia en Inicio.
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
  /// **'Buscando tu colonia…'**
  String get inicioZonaBuscando;

  /// La ubicación está fuera de la cobertura.
  ///
  /// In es, this message translates to:
  /// **'Todavía no llegamos a tu zona.'**
  String get inicioZonaFuera;

  /// Sin permiso de ubicación o servicio apagado.
  ///
  /// In es, this message translates to:
  /// **'Necesitamos tu ubicación para ubicar tu colonia.'**
  String get inicioZonaSinUbicacion;

  /// Botón que consulta la colonia de la persona.
  ///
  /// In es, this message translates to:
  /// **'Ver mi colonia'**
  String get inicioVerColonia;

  /// Botón que vuelve a consultar la colonia.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get inicioActualizar;

  /// Botón tras un error al consultar la colonia o un intento fallido.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get inicioReintentar;

  /// Acceso de Inicio al catálogo de oficios.
  ///
  /// In es, this message translates to:
  /// **'Explorar oficios'**
  String get inicioExplorarOficios;

  /// Detalle del acceso a oficios en Inicio.
  ///
  /// In es, this message translates to:
  /// **'Mira qué técnicos puedes encontrar'**
  String get inicioExplorarOficiosDetalle;

  /// Detalle bajo el nombre en Mi cuenta.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get cuentaEditarPerfil;

  /// Entrada de Mi cuenta y botón de confirmación del diálogo.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get cuentaCerrarSesion;

  /// Título del diálogo de cierre de sesión.
  ///
  /// In es, this message translates to:
  /// **'¿Cerrar sesión?'**
  String get cuentaCerrarSesionTitulo;

  /// Cuerpo del diálogo de cierre de sesión.
  ///
  /// In es, this message translates to:
  /// **'Tendrás que volver a entrar para usar tu cuenta.'**
  String get cuentaCerrarSesionCuerpo;

  /// Botón que cierra el diálogo sin hacer nada.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cuentaCancelar;

  /// Botón del aviso previo a un permiso: seguir y ver la petición del sistema.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get permisoContinuar;

  /// Botón del aviso previo a un permiso: no pedirlo ahora.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get permisoAhoraNo;

  /// Título del aviso previo al permiso de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'¿Activar las notificaciones?'**
  String get permisoNotificacionesTitulo;

  /// Explicación previa al permiso de notificaciones: para qué sirve.
  ///
  /// In es, this message translates to:
  /// **'Te avisamos cuando haya novedades en tus solicitudes, mensajes y visitas. Los avisos no muestran códigos ni direcciones.'**
  String get permisoNotificacionesCuerpo;

  /// Título del aviso previo al permiso de ubicación.
  ///
  /// In es, this message translates to:
  /// **'¿Usar tu ubicación?'**
  String get permisoUbicacionTitulo;

  /// Explicación previa al permiso de ubicación: para qué sirve y la alternativa.
  ///
  /// In es, this message translates to:
  /// **'La usamos una sola vez para mostrarte técnicos de tu colonia. No la guardamos. Si prefieres, puedes escribir tu código postal.'**
  String get permisoUbicacionCuerpo;

  /// Encabezado de la sección de Configuración para elegir qué avisos recibir.
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

  /// Botón que inicia la petición del permiso de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Activar notificaciones'**
  String get avisosActivar;

  /// Mensaje cuando no hay permiso de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Las notificaciones están apagadas en tu teléfono. La app sigue funcionando; puedes activarlas cuando quieras.'**
  String get avisosApagadas;

  /// Botón que abre los ajustes del teléfono para cambiar un permiso negado.
  ///
  /// In es, this message translates to:
  /// **'Abrir ajustes'**
  String get avisosAbrirAjustes;

  /// Mensaje cuando el permiso de notificaciones está concedido.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones activadas'**
  String get avisosActivadas;

  /// Botón para elegir la zona con la ubicación del teléfono.
  ///
  /// In es, this message translates to:
  /// **'Usar mi ubicación'**
  String get zonaUsarUbicacion;

  /// Mensaje cuando no hay ubicación y se ofrece el código postal.
  ///
  /// In es, this message translates to:
  /// **'Sin la ubicación, escribe tu código postal para continuar.'**
  String get zonaPideCodigoPostal;

  /// Etiqueta del campo del código postal.
  ///
  /// In es, this message translates to:
  /// **'Código postal'**
  String get zonaCodigoPostal;

  /// Error del campo de código postal.
  ///
  /// In es, this message translates to:
  /// **'Escribe los 5 números de tu código postal.'**
  String get zonaCodigoPostalInvalido;

  /// Botón que confirma el código postal.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get zonaContinuar;

  /// Error común: sin conexión o servicio no disponible (5xx).
  ///
  /// In es, this message translates to:
  /// **'No pudimos conectar con Knock. Revisa tu conexión e inténtalo de nuevo.'**
  String get errorSinConexion;

  /// Error común: la API rechazó la credencial (401) y no se pudo renovar.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión ya no es válida. Inicia sesión de nuevo.'**
  String get errorSesionVencida;

  /// Error común: cuenta suspendida (403 account_suspended).
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta está suspendida. Contacta a soporte si crees que es un error.'**
  String get errorCuentaSuspendida;

  /// Error común: acceso negado (403).
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para hacer esto.'**
  String get errorAccesoDenegado;

  /// Error común: conflicto (409).
  ///
  /// In es, this message translates to:
  /// **'Esta acción choca con otra cuenta o con el estado actual. Revisa los datos e inténtalo de nuevo.'**
  String get errorConflicto;

  /// Error común: datos rechazados (400, 413 o 422).
  ///
  /// In es, this message translates to:
  /// **'Revisa los datos que escribiste e inténtalo de nuevo.'**
  String get errorDatosRechazados;

  /// Error común: límite de intentos (429).
  ///
  /// In es, this message translates to:
  /// **'Hiciste demasiados intentos. Espera un momento e inténtalo de nuevo.'**
  String get errorDemasiadosIntentos;

  /// Error común: la respuesta no cumple el contrato.
  ///
  /// In es, this message translates to:
  /// **'Recibimos información que no pudimos leer. Inténtalo más tarde.'**
  String get errorDatosInvalidos;

  /// Error común: falta KNOCK_API_URL al compilar.
  ///
  /// In es, this message translates to:
  /// **'La app no está conectada a un servidor. Instala una versión oficial.'**
  String get errorApiNoConfigurada;

  /// Error común: cualquier fallo no previsto; nunca muestra detalles técnicos.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Inténtalo de nuevo.'**
  String get errorInesperado;

  /// Error común: código de SMS incorrecto.
  ///
  /// In es, this message translates to:
  /// **'El código de verificación es incorrecto.'**
  String get errorCodigoIncorrecto;

  /// Error común: código de SMS vencido.
  ///
  /// In es, this message translates to:
  /// **'El código de verificación venció. Solicita otro.'**
  String get errorCodigoVencido;

  /// Error común: número de celular rechazado por Firebase.
  ///
  /// In es, this message translates to:
  /// **'El número de celular no es válido.'**
  String get errorCelularRechazado;

  /// Error común: falta google-services.json en la compilación.
  ///
  /// In es, this message translates to:
  /// **'La verificación por SMS no está disponible.'**
  String get errorVerificacionNoDisponible;

  /// Título de la pantalla de entrada con celular.
  ///
  /// In es, this message translates to:
  /// **'Entra con tu celular'**
  String get entradaCelularTitulo;

  /// Texto de ayuda debajo del título de entrada.
  ///
  /// In es, this message translates to:
  /// **'Te enviaremos un código por SMS'**
  String get entradaCelularDetalle;

  /// Etiqueta del campo de número de celular.
  ///
  /// In es, this message translates to:
  /// **'Número de celular'**
  String get entradaCelularEtiqueta;

  /// Texto de ayuda del campo de número de celular.
  ///
  /// In es, this message translates to:
  /// **'10 dígitos sin el +52'**
  String get entradaCelularAyuda;

  /// Error del campo de número de celular.
  ///
  /// In es, this message translates to:
  /// **'Escribe los 10 dígitos de tu celular'**
  String get entradaCelularError;

  /// Prefijo de país fijo mostrado junto al campo de celular (sin selector +52/+1).
  ///
  /// In es, this message translates to:
  /// **'+52'**
  String get entradaPrefijoPais;

  /// Botón de la pantalla de entrada para pedir el código SMS.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get entradaContinuar;

  /// Etiqueta del botón mientras se envía el código SMS.
  ///
  /// In es, this message translates to:
  /// **'Enviando código…'**
  String get entradaCargando;

  /// Texto del aviso de privacidad en la casilla de entrada.
  ///
  /// In es, this message translates to:
  /// **'aviso de privacidad'**
  String get entradaAvisoPrivacidad;

  /// Texto completo de la casilla de aceptación del aviso de privacidad.
  ///
  /// In es, this message translates to:
  /// **'Acepto el {aviso}'**
  String entradaAceptoAviso(String aviso);

  /// Error mostrado si no se acepta el aviso de privacidad.
  ///
  /// In es, this message translates to:
  /// **'Acepta el aviso de privacidad para continuar'**
  String get entradaAvisoError;

  /// Mensaje breve cuando el teléfono no puede abrir la página del aviso de privacidad (spec 028).
  ///
  /// In es, this message translates to:
  /// **'No pudimos abrir el aviso de privacidad. Inténtalo de nuevo más tarde.'**
  String get entradaAvisoNoSeAbrio;

  /// Indicación de accesibilidad del enlace del aviso de privacidad (spec 028).
  ///
  /// In es, this message translates to:
  /// **'Se abre en el navegador'**
  String get entradaAvisoAbrirIndicacion;

  /// Error de entrada: código SMS incorrecto.
  ///
  /// In es, this message translates to:
  /// **'El código no es correcto. Revísalo e inténtalo otra vez.'**
  String get entradaErrorCodigoIncorrecto;

  /// Error de entrada: código SMS vencido.
  ///
  /// In es, this message translates to:
  /// **'El código venció. Pide otro.'**
  String get entradaErrorCodigoVencido;

  /// Error de entrada: celular rechazado por Firebase.
  ///
  /// In es, this message translates to:
  /// **'Número de celular no válido.'**
  String get entradaErrorCelularRechazado;

  /// Error de entrada: cuenta suspendida.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta está suspendida. Si crees que es un error, escríbenos.'**
  String get entradaErrorCuentaSuspendida;

  /// Error de entrada: conflicto de cuenta.
  ///
  /// In es, this message translates to:
  /// **'Este número ya está ligado a otra cuenta. Escríbenos para revisarlo.'**
  String get entradaErrorConflicto;

  /// Error de entrada: datos rechazados o inválidos.
  ///
  /// In es, this message translates to:
  /// **'No pudimos procesar la entrada. Inténtalo otra vez.'**
  String get entradaErrorDatos;

  /// Error de entrada: demasiados intentos.
  ///
  /// In es, this message translates to:
  /// **'Hiciste muchos intentos. Espera un momento y vuelve a intentarlo.'**
  String get entradaErrorDemasiadosIntentos;

  /// Error de entrada: sin conexión.
  ///
  /// In es, this message translates to:
  /// **'No pudimos conectarnos. Revisa tu internet e inténtalo otra vez.'**
  String get entradaErrorSinConexion;

  /// Error de entrada: verificación SMS no disponible.
  ///
  /// In es, this message translates to:
  /// **'La verificación por SMS no está disponible en esta versión de la app.'**
  String get entradaErrorVerificacionNoDisponible;

  /// Error de entrada: API no configurada.
  ///
  /// In es, this message translates to:
  /// **'La app no tiene servidor configurado.'**
  String get entradaErrorApiNoConfigurada;

  /// Error de entrada genérico.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión. Inténtalo de nuevo.'**
  String get entradaErrorGenerico;

  /// Error de entrada: aviso de privacidad no aceptado.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar el aviso de privacidad antes de continuar.'**
  String get entradaErrorAvisoNoAceptado;

  /// Título de la pantalla de verificación del código SMS.
  ///
  /// In es, this message translates to:
  /// **'Escribe el código'**
  String get entradaCodigoTitulo;

  /// Texto de detalle de la pantalla de verificación.
  ///
  /// In es, this message translates to:
  /// **'Lo enviamos al +52 {celular}'**
  String entradaCodigoEnviadoA(String celular);

  /// Etiqueta del campo de código SMS.
  ///
  /// In es, this message translates to:
  /// **'Código de verificación'**
  String get entradaCodigoEtiqueta;

  /// Error del campo de código SMS.
  ///
  /// In es, this message translates to:
  /// **'Escribe los 6 dígitos del código'**
  String get entradaCodigoError;

  /// Botón de la pantalla de verificación para validar el código.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get entradaEntrar;

  /// Texto del botón de reenvío con cuenta regresiva.
  ///
  /// In es, this message translates to:
  /// **'Reenviar en {segundos} s'**
  String entradaReenviarEn(int segundos);

  /// Botón de texto para reenviar el código SMS.
  ///
  /// In es, this message translates to:
  /// **'Reenviar código'**
  String get entradaReenviarCodigo;

  /// Botón de texto para volver a escribir el número de celular.
  ///
  /// In es, this message translates to:
  /// **'Cambiar número'**
  String get entradaCambiarNumero;

  /// Botón de la barra de marca y de la hoja de invitación de la previa sin sesión; abre el flujo de celular.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get previaEntrar;

  /// Botón de la barra de marca y de la hoja de invitación de la previa; abre el mismo flujo de celular que Entrar.
  ///
  /// In es, this message translates to:
  /// **'Registrarme'**
  String get previaRegistrarme;

  /// Título del buscador de la previa sin sesión.
  ///
  /// In es, this message translates to:
  /// **'Busca un experto cerca de ti'**
  String get previaBuscadorTitulo;

  /// Leyenda de ejemplos bajo el título del buscador de la previa.
  ///
  /// In es, this message translates to:
  /// **'Mecánica · Plomería · Electricidad'**
  String get previaBuscadorLeyenda;

  /// Título de la hoja que invita a entrar cuando la persona toca el buscador o una acción que requiere cuenta.
  ///
  /// In es, this message translates to:
  /// **'Entra para continuar'**
  String get previaInvitacionTitulo;

  /// Detalle de la hoja de invitación a entrar.
  ///
  /// In es, this message translates to:
  /// **'Para buscar expertos, pedir cotizaciones y ver su contacto necesitas una cuenta.'**
  String get previaInvitacionDetalle;

  /// Botón que cierra la hoja de invitación sin entrar.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get previaAhoraNo;

  /// Etiqueta de lectura de pantalla del grupo de chips de oficio.
  ///
  /// In es, this message translates to:
  /// **'Oficios'**
  String get previaChipsEtiqueta;

  /// Chip que muestra todos los oficios del catálogo.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get previaChipTodos;

  /// Chip para quien no sabe qué oficio necesita; invita a entrar.
  ///
  /// In es, this message translates to:
  /// **'No sé cuál'**
  String get previaChipNoSeCual;

  /// Título de la lista del catálogo en la previa.
  ///
  /// In es, this message translates to:
  /// **'Oficios disponibles'**
  String get previaCatalogoTitulo;

  /// Etiqueta de lectura de pantalla del indicador de carga del catálogo.
  ///
  /// In es, this message translates to:
  /// **'Cargando oficios'**
  String get previaCargando;

  /// Título del estado vacío del catálogo de la previa.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay oficios disponibles'**
  String get previaVacioTitulo;

  /// Título del estado de error del catálogo de la previa.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar los oficios'**
  String get previaErrorTitulo;

  /// Aviso sobre la lista del catálogo cuando se muestra lo guardado por falta de red.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Se muestra lo último guardado.'**
  String get previaSinConexion;

  /// Botón para volver a pedir el catálogo de oficios.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get previaReintentar;

  /// Modalidad de un oficio que se presta en el domicilio.
  ///
  /// In es, this message translates to:
  /// **'A domicilio'**
  String get previaModalidadDomicilio;

  /// Modalidad de un oficio que se presta en taller.
  ///
  /// In es, this message translates to:
  /// **'En taller'**
  String get previaModalidadTaller;

  /// Título de la tarjeta que abre el catálogo de oficios sin sesión.
  ///
  /// In es, this message translates to:
  /// **'Explorar servicios y trabajos'**
  String get previaExplorarTitulo;

  /// Detalle de la tarjeta Explorar servicios y trabajos.
  ///
  /// In es, this message translates to:
  /// **'Mira los oficios que hay en Knock sin crear una cuenta.'**
  String get previaExplorarDetalle;

  /// Rótulo fijo que marca como inventados el panel, el mapa y las tarjetas de expertos de la previa; no se puede ocultar.
  ///
  /// In es, this message translates to:
  /// **'Datos de ejemplo'**
  String get previaDatosDeEjemplo;

  /// Botón del panel de expertos de la previa: sube el panel para ver la lista (no pide cuenta).
  ///
  /// In es, this message translates to:
  /// **'Ver lista'**
  String get previaVerLista;

  /// Etiqueta de lectura de pantalla del mapa dibujado de la previa.
  ///
  /// In es, this message translates to:
  /// **'Mapa de ejemplo con expertos. Datos de ejemplo.'**
  String get previaMapaSemantica;

  /// Encabezado del panel de la previa con el número de expertos de ejemplo.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, one{{cantidad} experto cerca de ti} other{{cantidad} expertos cerca de ti}}'**
  String previaExpertosCerca(int cantidad);

  /// Etiqueta de lectura de pantalla de un pin del mapa de demostración.
  ///
  /// In es, this message translates to:
  /// **'Experto de ejemplo: {nombre}. Datos de ejemplo. Toca para entrar.'**
  String previaPinSemantica(String nombre);

  /// Etiqueta de lectura de pantalla de una tarjeta de experto de demostración.
  ///
  /// In es, this message translates to:
  /// **'{nombre}, {oficio}. Datos de ejemplo. Toca para entrar.'**
  String previaTarjetaSemantica(String nombre, String oficio);

  /// Punto de ejemplo que marca dónde estás en el mapa dibujado de la previa; no usa ubicación real.
  ///
  /// In es, this message translates to:
  /// **'Tú estás aquí'**
  String get previaYoAqui;

  /// Botón del mapa de la previa: acerca el mapa.
  ///
  /// In es, this message translates to:
  /// **'Acercar'**
  String get previaMapaAcercar;

  /// Botón del mapa de la previa: aleja el mapa.
  ///
  /// In es, this message translates to:
  /// **'Alejar'**
  String get previaMapaAlejar;

  /// Botón del mapa de la previa: regresa a la vista inicial (punto de ejemplo, sin ubicación real).
  ///
  /// In es, this message translates to:
  /// **'Volver a mi ubicación'**
  String get previaMapaMiUbicacion;

  /// Botón del panel de expertos: baja el panel para ver el mapa.
  ///
  /// In es, this message translates to:
  /// **'Ver mapa'**
  String get previaVerMapa;

  /// Etiqueta de lectura de pantalla del panel inferior de la previa.
  ///
  /// In es, this message translates to:
  /// **'Panel de expertos cerca de ti'**
  String get previaPanelEtiqueta;

  /// Distancia de un experto de ejemplo en su tarjeta.
  ///
  /// In es, this message translates to:
  /// **'a {km} km'**
  String previaDistanciaKm(String km);
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
