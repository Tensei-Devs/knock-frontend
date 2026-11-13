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

  /// Botón del estado vacío de Actividad que abre «Pedir cotización».
  ///
  /// In es, this message translates to:
  /// **'Pide tu primera cotización'**
  String get actividadPedirCotizacion;

  /// Título del formulario de solicitud (spec 015).
  ///
  /// In es, this message translates to:
  /// **'Pedir cotización'**
  String get solicitudTitulo;

  /// Indicador del paso del formulario.
  ///
  /// In es, this message translates to:
  /// **'Paso {paso} de {total}'**
  String solicitudPasoDeTotal(int paso, int total);

  /// Título del paso 1: elegir el oficio.
  ///
  /// In es, this message translates to:
  /// **'¿Qué necesitas?'**
  String get solicitudPaso1;

  /// Título del paso 2: descripción y fotos.
  ///
  /// In es, this message translates to:
  /// **'¿Qué pasa?'**
  String get solicitudPaso2;

  /// Título del paso 3: día, franja y lugar.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo y dónde?'**
  String get solicitudPaso3;

  /// Modalidad del oficio: a domicilio.
  ///
  /// In es, this message translates to:
  /// **'Va a tu domicilio'**
  String get solicitudModalidadDomicilio;

  /// Modalidad del oficio: en taller.
  ///
  /// In es, this message translates to:
  /// **'Llevas tu auto al taller'**
  String get solicitudModalidadTaller;

  /// Etiqueta del campo de descripción.
  ///
  /// In es, this message translates to:
  /// **'Describe el problema'**
  String get solicitudDescripcion;

  /// Ayuda bajo el campo de descripción.
  ///
  /// In es, this message translates to:
  /// **'Cuéntale al técnico qué pasa, desde cuándo y qué ya intentaste.'**
  String get solicitudDescripcionAyuda;

  /// Error: descripción corta (CA-02).
  ///
  /// In es, this message translates to:
  /// **'Escribe al menos 8 caracteres.'**
  String get solicitudDescripcionCorta;

  /// Error: descripción larga (CA-02).
  ///
  /// In es, this message translates to:
  /// **'Escribe como máximo 500 caracteres.'**
  String get solicitudDescripcionLarga;

  /// Título de la sección de fotos.
  ///
  /// In es, this message translates to:
  /// **'Fotos ({cantidad} de 5)'**
  String solicitudFotos(int cantidad);

  /// Aviso de foto obligatoria (CA-03).
  ///
  /// In es, this message translates to:
  /// **'Agrega al menos una foto: le dice al técnico qué llevar'**
  String get solicitudFotoFalta;

  /// Aviso del máximo de fotos (CA-03).
  ///
  /// In es, this message translates to:
  /// **'Ya tienes 5 fotos, el máximo.'**
  String get solicitudFotoMaximo;

  /// Botón para tomar una foto con la cámara.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get solicitudFotoTomar;

  /// Botón para elegir fotos del teléfono.
  ///
  /// In es, this message translates to:
  /// **'Elegir de la galería'**
  String get solicitudFotoElegir;

  /// Etiqueta de accesibilidad de una miniatura.
  ///
  /// In es, this message translates to:
  /// **'Foto {numero} de {total}'**
  String solicitudFotoEtiqueta(int numero, int total);

  /// Botón para quitar una foto.
  ///
  /// In es, this message translates to:
  /// **'Quitar foto {numero}'**
  String solicitudFotoQuitar(int numero);

  /// Error: foto no válida (spec 015 §7).
  ///
  /// In es, this message translates to:
  /// **'Esa foto es muy pesada o no es JPG ni PNG. Elige otra.'**
  String get solicitudFotoNoValida;

  /// Título de la elección de día.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get solicitudDia;

  /// Chip del día de hoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get solicitudHoy;

  /// Título de la elección de franja.
  ///
  /// In es, this message translates to:
  /// **'Horario'**
  String get solicitudFranja;

  /// Franja de la mañana.
  ///
  /// In es, this message translates to:
  /// **'Mañana'**
  String get solicitudFranjaManana;

  /// Franja de la tarde.
  ///
  /// In es, this message translates to:
  /// **'Tarde'**
  String get solicitudFranjaTarde;

  /// Franja de la noche.
  ///
  /// In es, this message translates to:
  /// **'Noche'**
  String get solicitudFranjaNoche;

  /// Error: falta día o franja.
  ///
  /// In es, this message translates to:
  /// **'Elige el día y el horario.'**
  String get solicitudFaltaDiaYFranja;

  /// Aviso del oficio en taller (CA-05).
  ///
  /// In es, this message translates to:
  /// **'Llevarás tu auto al taller'**
  String get solicitudTallerAviso;

  /// Etiqueta del campo de dirección (CA-17).
  ///
  /// In es, this message translates to:
  /// **'Calle y número'**
  String get solicitudDireccion;

  /// Ayuda del campo de dirección.
  ///
  /// In es, this message translates to:
  /// **'Solo la verá el técnico que elijas.'**
  String get solicitudDireccionAyuda;

  /// Error: dirección corta (CA-17).
  ///
  /// In es, this message translates to:
  /// **'Escribe al menos 8 caracteres.'**
  String get solicitudDireccionCorta;

  /// Error: dirección larga (CA-17).
  ///
  /// In es, this message translates to:
  /// **'Escribe como máximo 200 caracteres.'**
  String get solicitudDireccionLarga;

  /// Aviso cuando no hay zona guardada (R-05, spec 017).
  ///
  /// In es, this message translates to:
  /// **'Elige tu zona en Mi cuenta para poder enviar tu solicitud.'**
  String get solicitudSinZona;

  /// Botón para avanzar de paso.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get solicitudSiguiente;

  /// Botón para volver al paso anterior.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get solicitudAtras;

  /// Botón para enviar la solicitud.
  ///
  /// In es, this message translates to:
  /// **'Enviar solicitud'**
  String get solicitudEnviar;

  /// Indicador mientras se envía.
  ///
  /// In es, this message translates to:
  /// **'Enviando…'**
  String get solicitudEnviando;

  /// Aviso al crear la solicitud (CA-01).
  ///
  /// In es, this message translates to:
  /// **'Solicitud enviada'**
  String get solicitudEnviada;

  /// Botón para descartar el borrador.
  ///
  /// In es, this message translates to:
  /// **'Descartar borrador'**
  String get solicitudDescartar;

  /// Aviso de 429 con Retry-After (CA-15).
  ///
  /// In es, this message translates to:
  /// **'Hiciste muchos intentos. Espera {segundos} segundos.'**
  String solicitudEspera(int segundos);

  /// Error 422 content_rejected (CA-22).
  ///
  /// In es, this message translates to:
  /// **'Tu descripción no se pudo publicar. Revísala y quita datos personales o palabras ofensivas.'**
  String get solicitudErrorContenidoRechazado;

  /// Error 503 moderation_unavailable (CA-22).
  ///
  /// In es, this message translates to:
  /// **'No pudimos revisar tu descripción en este momento. Intenta de nuevo en unos minutos.'**
  String get solicitudErrorModeracion;

  /// Error 422 trade_invalid o colonia_not_found.
  ///
  /// In es, this message translates to:
  /// **'Ese oficio o esa colonia ya no están disponibles. Elige otra opción.'**
  String get solicitudErrorOpcionNoDisponible;

  /// Error 404 (CA-13).
  ///
  /// In es, this message translates to:
  /// **'Esta solicitud ya no está disponible.'**
  String get solicitudNoDisponible;

  /// Título del detalle de la solicitud.
  ///
  /// In es, this message translates to:
  /// **'Tu solicitud'**
  String get solicitudDetalleTitulo;

  /// Estado enviada.
  ///
  /// In es, this message translates to:
  /// **'Enviada'**
  String get solicitudEstadoEnviada;

  /// Estado cotizando.
  ///
  /// In es, this message translates to:
  /// **'Recibiendo cotizaciones'**
  String get solicitudEstadoCotizando;

  /// Estado cita_confirmada.
  ///
  /// In es, this message translates to:
  /// **'Cita confirmada'**
  String get solicitudEstadoCita;

  /// Estado terminada o calificada.
  ///
  /// In es, this message translates to:
  /// **'Terminada'**
  String get solicitudEstadoTerminada;

  /// Estado cancelada.
  ///
  /// In es, this message translates to:
  /// **'Cancelada'**
  String get solicitudEstadoCancelada;

  /// Estado vencida.
  ///
  /// In es, this message translates to:
  /// **'Vencida'**
  String get solicitudEstadoVencida;

  /// Estado desconocido.
  ///
  /// In es, this message translates to:
  /// **'En proceso'**
  String get solicitudEstadoEnProceso;

  /// Día y franja en el detalle.
  ///
  /// In es, this message translates to:
  /// **'{dia}, {franja}'**
  String solicitudCuando(String dia, String franja);

  /// Número de fotos en el detalle.
  ///
  /// In es, this message translates to:
  /// **'{cantidad, plural, =1{1 foto} other{{cantidad} fotos}}'**
  String solicitudTotalFotos(int cantidad);

  /// Botón para volver a Actividad.
  ///
  /// In es, this message translates to:
  /// **'Volver a Actividad'**
  String get solicitudVolverActividad;

  /// Botón del detalle que abre la comparación (spec 015 §7).
  ///
  /// In es, this message translates to:
  /// **'Ver y elegir ({cantidad})'**
  String solicitudVerCotizaciones(int cantidad);

  /// Título de la comparación de cotizaciones.
  ///
  /// In es, this message translates to:
  /// **'Cotizaciones'**
  String get cotizacionTitulo;

  /// Orden recomendadas (CA-08).
  ///
  /// In es, this message translates to:
  /// **'Recomendadas'**
  String get cotizacionOrdenRecomendadas;

  /// Orden por precio (CA-08).
  ///
  /// In es, this message translates to:
  /// **'Menor precio'**
  String get cotizacionOrdenPrecio;

  /// Orden por calificación (CA-08).
  ///
  /// In es, this message translates to:
  /// **'Mejor calificadas'**
  String get cotizacionOrdenCalificacion;

  /// Orden por fecha (CA-08).
  ///
  /// In es, this message translates to:
  /// **'Más pronto'**
  String get cotizacionOrdenPronto;

  /// Aviso cuando hay más de 5 cotizaciones (CA-07).
  ///
  /// In es, this message translates to:
  /// **'Te mostramos {mostradas} de {total}'**
  String cotizacionMostrandoDe(int mostradas, int total);

  /// Aviso de tipos de precio mixtos (CA-07).
  ///
  /// In es, this message translates to:
  /// **'Las cotizaciones cubren cosas distintas: revisa qué incluye cada una'**
  String get cotizacionTiposMixtos;

  /// Precio fijo ya formateado en pesos.
  ///
  /// In es, this message translates to:
  /// **'{precio}'**
  String cotizacionPrecioFijo(String precio);

  /// Rango de precio.
  ///
  /// In es, this message translates to:
  /// **'De {minimo} a {maximo}'**
  String cotizacionPrecioRango(String minimo, String maximo);

  /// Cuota de solo visita.
  ///
  /// In es, this message translates to:
  /// **'Visita: {precio}'**
  String cotizacionPrecioVisita(String precio);

  /// Máximo que se puede cobrar (tope).
  ///
  /// In es, this message translates to:
  /// **'Hasta {tope}'**
  String cotizacionTope(String tope);

  /// Aviso de requiereAprobacion.
  ///
  /// In es, this message translates to:
  /// **'Si el precio sube, el técnico te pedirá tu aprobación'**
  String get cotizacionRequiereAprobacion;

  /// Etiqueta verificado.
  ///
  /// In es, this message translates to:
  /// **'Verificado'**
  String get cotizacionEtiquetaVerificado;

  /// Etiqueta mejor_precio.
  ///
  /// In es, this message translates to:
  /// **'Mejor precio'**
  String get cotizacionEtiquetaMejorPrecio;

  /// Etiqueta puede_ir_mas_pronto.
  ///
  /// In es, this message translates to:
  /// **'Puede ir más pronto'**
  String get cotizacionEtiquetaPronto;

  /// Técnico sin calificaciones.
  ///
  /// In es, this message translates to:
  /// **'Sin calificaciones'**
  String get cotizacionSinCalificaciones;

  /// Calificación del técnico.
  ///
  /// In es, this message translates to:
  /// **'{calificacion} de 5'**
  String cotizacionCalificacion(String calificacion);

  /// Nivel de verificación del técnico.
  ///
  /// In es, this message translates to:
  /// **'Verificación {nivel}'**
  String cotizacionNivelVerificacion(String nivel);

  /// Día y hora propuestos.
  ///
  /// In es, this message translates to:
  /// **'{dia} a las {hora}'**
  String cotizacionCuando(String dia, String hora);

  /// Motivo request_without_quotes (CA-09).
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay cotizaciones. Te avisaremos cuando llegue la primera.'**
  String get cotizacionMotivoSinCotizaciones;

  /// Motivo request_expired (CA-09).
  ///
  /// In es, this message translates to:
  /// **'Esta solicitud venció. Puedes pedir una nueva.'**
  String get cotizacionMotivoVencida;

  /// Motivo request_cancelled (CA-09).
  ///
  /// In es, this message translates to:
  /// **'Esta solicitud se canceló.'**
  String get cotizacionMotivoCancelada;

  /// Motivo request_already_chosen (CA-09).
  ///
  /// In es, this message translates to:
  /// **'Ya elegiste una cotización para esta solicitud.'**
  String get cotizacionYaElegida;

  /// Botón que abre la visita (CA-09).
  ///
  /// In es, this message translates to:
  /// **'Ver mi visita'**
  String get cotizacionVerMiVisita;

  /// Botón de la tarjeta que abre la confirmación (spec 015 §7).
  ///
  /// In es, this message translates to:
  /// **'Elegir'**
  String get cotizacionElegir;

  /// Título de la hoja de confirmación.
  ///
  /// In es, this message translates to:
  /// **'¿Eliges a {tecnico}?'**
  String cotizacionConfirmarTitulo(String tecnico);

  /// Aviso antes de confirmar (spec 015 §7).
  ///
  /// In es, this message translates to:
  /// **'Al elegir, verás el teléfono del técnico y él verá la dirección de tu servicio. Las demás cotizaciones se cerrarán.'**
  String get cotizacionConfirmarAvisoContacto;

  /// Botón que confirma la elección.
  ///
  /// In es, this message translates to:
  /// **'Confirmar elección'**
  String get cotizacionConfirmar;

  /// Botón que cierra la hoja sin elegir.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cotizacionCancelar;

  /// Indicador mientras se elige.
  ///
  /// In es, this message translates to:
  /// **'Confirmando tu elección…'**
  String get cotizacionEligiendo;

  /// Título de la hoja tras elegir (CA-11).
  ///
  /// In es, this message translates to:
  /// **'Cita confirmada'**
  String get cotizacionCitaConfirmada;

  /// Teléfono público del técnico, solo tras elegir.
  ///
  /// In es, this message translates to:
  /// **'Teléfono: {telefono}'**
  String cotizacionTelefono(String telefono);

  /// WhatsApp público del técnico, solo tras elegir.
  ///
  /// In es, this message translates to:
  /// **'WhatsApp: {whatsapp}'**
  String cotizacionWhatsapp(String whatsapp);

  /// Técnico sin contacto público (CA-11).
  ///
  /// In es, this message translates to:
  /// **'Este técnico no publicó un teléfono. Podrás escribirle por el chat cuando esté disponible'**
  String get cotizacionSinTelefono;

  /// Dirección de la cita: la del taller o la que escribió la persona.
  ///
  /// In es, this message translates to:
  /// **'Lugar: {direccion}'**
  String cotizacionLugar(String direccion);

  /// Botón que cierra la hoja de la cita.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get cotizacionListo;

  /// Error 409 quote_unavailable (CA-12).
  ///
  /// In es, this message translates to:
  /// **'Esta cotización ya no está disponible. Elige otra.'**
  String get cotizacionRetirada;

  /// Error 503 service_unavailable al elegir (CA-20).
  ///
  /// In es, this message translates to:
  /// **'No pudimos confirmar tu elección. Intenta de nuevo.'**
  String get cotizacionErrorEleccion;

  /// Título de la pantalla de la visita (spec 016).
  ///
  /// In es, this message translates to:
  /// **'Tu visita'**
  String get visitaTitulo;

  /// Insignia de técnico verificado.
  ///
  /// In es, this message translates to:
  /// **'Verificado'**
  String get visitaVerificado;

  /// Técnico sin verificar.
  ///
  /// In es, this message translates to:
  /// **'Sin verificar'**
  String get visitaSinVerificar;

  /// Día y hora de la visita.
  ///
  /// In es, this message translates to:
  /// **'{dia} a las {hora}'**
  String visitaCuando(String dia, String hora);

  /// Título del código de 4 dígitos.
  ///
  /// In es, this message translates to:
  /// **'Tu código'**
  String get visitaCodigoTitulo;

  /// Regla de seguridad (CA-01).
  ///
  /// In es, this message translates to:
  /// **'Pídele a {tecnico} que te diga este código en la puerta. Si no lo sabe, no abras.'**
  String visitaCodigoRegla(String tecnico);

  /// Lectura del código dígito por dígito (CA-14).
  ///
  /// In es, this message translates to:
  /// **'Código: {digitos}'**
  String visitaCodigoEtiqueta(String digitos);

  /// Botón para tapar el código (CA-08).
  ///
  /// In es, this message translates to:
  /// **'Ocultar código'**
  String get visitaOcultarCodigo;

  /// Botón para destapar el código (CA-08).
  ///
  /// In es, this message translates to:
  /// **'Mostrar código'**
  String get visitaMostrarCodigo;

  /// Anuncio al ocultar el código (CA-08).
  ///
  /// In es, this message translates to:
  /// **'Código oculto'**
  String get visitaCodigoOculto;

  /// motivoCodigo usado (CA-07).
  ///
  /// In es, this message translates to:
  /// **'El técnico ya confirmó su llegada con este código.'**
  String get visitaMotivoUsado;

  /// motivoCodigo vencido (CA-07).
  ///
  /// In es, this message translates to:
  /// **'Este código ya venció.'**
  String get visitaMotivoVencido;

  /// motivoCodigo bloqueada (CA-07).
  ///
  /// In es, this message translates to:
  /// **'Esta visita quedó bloqueada por seguridad. El equipo de Knock la revisará.'**
  String get visitaMotivoBloqueada;

  /// motivoCodigo no_aplica (CA-07).
  ///
  /// In es, this message translates to:
  /// **'Esta cita no necesita código.'**
  String get visitaMotivoNoAplica;

  /// Título de la cita en taller (CA-04).
  ///
  /// In es, this message translates to:
  /// **'Cita en el taller'**
  String get visitaTaller;

  /// Dirección del taller (CA-04).
  ///
  /// In es, this message translates to:
  /// **'Dirección: {direccion}'**
  String visitaDireccionTaller(String direccion);

  /// Botón que abre la app de mapas (CA-04).
  ///
  /// In es, this message translates to:
  /// **'Cómo llegar'**
  String get visitaComoLlegar;

  /// Aviso sin app de mapas (R-05).
  ///
  /// In es, this message translates to:
  /// **'No encontramos una app de mapas. Copia la dirección para buscarla.'**
  String get visitaSinMapas;

  /// Botón para llamar al técnico (CA-21).
  ///
  /// In es, this message translates to:
  /// **'Llamar'**
  String get visitaLlamar;

  /// Botón para escribir por WhatsApp (CA-21).
  ///
  /// In es, this message translates to:
  /// **'WhatsApp'**
  String get visitaWhatsapp;

  /// Aviso si no hay app para llamar o WhatsApp.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir la app. El número es {numero}.'**
  String visitaNoSePudoAbrir(String numero);

  /// Botón que abre la hoja de la spec 022 (CA-06).
  ///
  /// In es, this message translates to:
  /// **'Avisar a alguien de confianza'**
  String get visitaAvisar;

  /// Error 404 (CA-05).
  ///
  /// In es, this message translates to:
  /// **'Esta visita ya no está disponible.'**
  String get visitaNoDisponible;

  /// Copia local sin conexión (CA-02).
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Te mostramos los datos guardados de tu visita.'**
  String get visitaSinConexion;

  /// Estado confirmada.
  ///
  /// In es, this message translates to:
  /// **'Confirmada'**
  String get visitaEstadoConfirmada;

  /// Estado en_curso.
  ///
  /// In es, this message translates to:
  /// **'En curso'**
  String get visitaEstadoEnCurso;

  /// Estado terminada.
  ///
  /// In es, this message translates to:
  /// **'Terminada'**
  String get visitaEstadoTerminada;

  /// Estado cancelada o no presentado.
  ///
  /// In es, this message translates to:
  /// **'Cancelada'**
  String get visitaEstadoCancelada;
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
