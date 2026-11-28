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

  /// No description provided for @tecnicoCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando…'**
  String get tecnicoCargando;

  /// No description provided for @tecnicoReintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get tecnicoReintentar;

  /// No description provided for @tecnicoNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Ese técnico ya no está disponible.'**
  String get tecnicoNoDisponible;

  /// No description provided for @tecnicoCopia.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Es la copia del {fecha}; puede estar desactualizada.'**
  String tecnicoCopia(DateTime fecha);

  /// No description provided for @tecnicoCalificacion.
  ///
  /// In es, this message translates to:
  /// **'★ {calificacion}'**
  String tecnicoCalificacion(String calificacion);

  /// No description provided for @tecnicoAnios.
  ///
  /// In es, this message translates to:
  /// **'{n} años de experiencia'**
  String tecnicoAnios(int n);

  /// No description provided for @tecnicoAtiendeTaller.
  ///
  /// In es, this message translates to:
  /// **'Atiende en su taller'**
  String get tecnicoAtiendeTaller;

  /// No description provided for @tecnicoAtiendeDomicilio.
  ///
  /// In es, this message translates to:
  /// **'Va a domicilio'**
  String get tecnicoAtiendeDomicilio;

  /// No description provided for @tecnicoAtiendeAmbos.
  ///
  /// In es, this message translates to:
  /// **'En taller y a domicilio'**
  String get tecnicoAtiendeAmbos;

  /// No description provided for @tecnicoRadio.
  ///
  /// In es, this message translates to:
  /// **'hasta {km} km'**
  String tecnicoRadio(int km);

  /// No description provided for @tecnicoDisponibleHoy.
  ///
  /// In es, this message translates to:
  /// **'Disponible hoy'**
  String get tecnicoDisponibleHoy;

  /// No description provided for @tecnicoSinColonia.
  ///
  /// In es, this message translates to:
  /// **'Elige tu colonia para saber si llega hasta ti.'**
  String get tecnicoSinColonia;

  /// No description provided for @tecnicoLlega.
  ///
  /// In es, this message translates to:
  /// **'Sí atiende {colonia}'**
  String tecnicoLlega(String colonia);

  /// No description provided for @tecnicoNoLlega.
  ///
  /// In es, this message translates to:
  /// **'No atiende {colonia}'**
  String tecnicoNoLlega(String colonia);

  /// No description provided for @tecnicoServicios.
  ///
  /// In es, this message translates to:
  /// **'Servicios y precios'**
  String get tecnicoServicios;

  /// No description provided for @tecnicoSinServicios.
  ///
  /// In es, this message translates to:
  /// **'Todavía no publica servicios.'**
  String get tecnicoSinServicios;

  /// No description provided for @tecnicoDesde.
  ///
  /// In es, this message translates to:
  /// **'desde {precio}'**
  String tecnicoDesde(String precio);

  /// No description provided for @tecnicoPreciosDeReferencia.
  ///
  /// In es, this message translates to:
  /// **'Son precios de referencia. El precio final lo acuerdas con el técnico.'**
  String get tecnicoPreciosDeReferencia;

  /// No description provided for @tecnicoFotos.
  ///
  /// In es, this message translates to:
  /// **'Fotos de sus trabajos'**
  String get tecnicoFotos;

  /// No description provided for @tecnicoSinFotos.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay fotos de sus trabajos.'**
  String get tecnicoSinFotos;

  /// No description provided for @tecnicoFotoEtiqueta.
  ///
  /// In es, this message translates to:
  /// **'Foto de un trabajo terminado'**
  String get tecnicoFotoEtiqueta;

  /// No description provided for @tecnicoVerMasFotos.
  ///
  /// In es, this message translates to:
  /// **'Ver más fotos'**
  String get tecnicoVerMasFotos;

  /// No description provided for @citaExistente.
  ///
  /// In es, this message translates to:
  /// **'Cita existente'**
  String get citaExistente;

  /// No description provided for @visitaRecuperacionFallida.
  ///
  /// In es, this message translates to:
  /// **'No pudimos recuperar la visita. Consulta tu actividad.'**
  String get visitaRecuperacionFallida;

  /// No description provided for @citaMonto.
  ///
  /// In es, this message translates to:
  /// **'Cotización: {monto}'**
  String citaMonto(String monto);

  /// No description provided for @citaTope.
  ///
  /// In es, this message translates to:
  /// **'Máximo: {monto}'**
  String citaTope(String monto);

  /// No description provided for @solicitudCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar solicitud'**
  String get solicitudCancelar;

  /// No description provided for @solicitudCancelarTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Cancelar tu solicitud?'**
  String get solicitudCancelarTitulo;

  /// No description provided for @solicitudCancelarDetalle.
  ///
  /// In es, this message translates to:
  /// **'Los técnicos que cotizaron recibirán un aviso y ya no podrás elegir una cotización.'**
  String get solicitudCancelarDetalle;

  /// No description provided for @solicitudCancelarMotivo.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué cancelas? (opcional)'**
  String get solicitudCancelarMotivo;

  /// No description provided for @solicitudMotivoYaNo.
  ///
  /// In es, this message translates to:
  /// **'Ya no lo necesito'**
  String get solicitudMotivoYaNo;

  /// No description provided for @solicitudMotivoResolvi.
  ///
  /// In es, this message translates to:
  /// **'Lo resolví por otro medio'**
  String get solicitudMotivoResolvi;

  /// No description provided for @solicitudMotivoTarda.
  ///
  /// In es, this message translates to:
  /// **'Tarda mucho'**
  String get solicitudMotivoTarda;

  /// No description provided for @solicitudMotivoOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro motivo'**
  String get solicitudMotivoOtro;

  /// No description provided for @solicitudCancelarConfirmar.
  ///
  /// In es, this message translates to:
  /// **'Sí, cancelar'**
  String get solicitudCancelarConfirmar;

  /// No description provided for @solicitudCancelarMantener.
  ///
  /// In es, this message translates to:
  /// **'No, mantener'**
  String get solicitudCancelarMantener;

  /// No description provided for @solicitudCanceladaDetalle.
  ///
  /// In es, this message translates to:
  /// **'Cancelaste esta solicitud.'**
  String get solicitudCanceladaDetalle;

  /// No description provided for @solicitudVencidaDetalle.
  ///
  /// In es, this message translates to:
  /// **'Pasaron 48 horas sin que eligieras una cotización.'**
  String get solicitudVencidaDetalle;

  /// No description provided for @solicitudErrorConCita.
  ///
  /// In es, this message translates to:
  /// **'Ya elegiste una cotización: esta solicitud ya no se puede cancelar. Revisa tu visita.'**
  String get solicitudErrorConCita;

  /// No description provided for @solicitudErrorYaVencida.
  ///
  /// In es, this message translates to:
  /// **'Tu solicitud ya había vencido.'**
  String get solicitudErrorYaVencida;

  /// No description provided for @solicitudVenceMenosHora.
  ///
  /// In es, this message translates to:
  /// **'Vence en menos de una hora'**
  String get solicitudVenceMenosHora;

  /// No description provided for @solicitudCerrando.
  ///
  /// In es, this message translates to:
  /// **'Cerrando tu solicitud…'**
  String get solicitudCerrando;

  /// No description provided for @solicitudVenceEnHoras.
  ///
  /// In es, this message translates to:
  /// **'Vence en {horas, plural, =1{1 hora} other{{horas} horas}}'**
  String solicitudVenceEnHoras(int horas);

  /// No description provided for @solicitudVenceEl.
  ///
  /// In es, this message translates to:
  /// **'Vence el {dia} a las {hora}'**
  String solicitudVenceEl(String dia, String hora);

  /// Nombre de la app (título de la tarea en el sistema). Es una marca: no se traduce.
  ///
  /// In es, this message translates to:
  /// **'Knock'**
  String get appTitle;

  /// No description provided for @busquedaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get busquedaTitulo;

  /// No description provided for @busquedaEtiqueta.
  ///
  /// In es, this message translates to:
  /// **'¿Qué necesitas?'**
  String get busquedaEtiqueta;

  /// No description provided for @busquedaPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej.: boiler, frenos, un contacto'**
  String get busquedaPlaceholder;

  /// No description provided for @busquedaMinimo.
  ///
  /// In es, this message translates to:
  /// **'Escribe al menos 2 letras'**
  String get busquedaMinimo;

  /// No description provided for @busquedaContador.
  ///
  /// In es, this message translates to:
  /// **'{n}/80'**
  String busquedaContador(int n);

  /// No description provided for @busquedaCargando.
  ///
  /// In es, this message translates to:
  /// **'Buscando…'**
  String get busquedaCargando;

  /// No description provided for @busquedaSugerencias.
  ///
  /// In es, this message translates to:
  /// **'Sugerencias'**
  String get busquedaSugerencias;

  /// No description provided for @busquedaSoloVerificados.
  ///
  /// In es, this message translates to:
  /// **'Solo verificados'**
  String get busquedaSoloVerificados;

  /// No description provided for @busquedaSoloVerificadosActivo.
  ///
  /// In es, this message translates to:
  /// **'Solo verificados, seleccionado'**
  String get busquedaSoloVerificadosActivo;

  /// No description provided for @busquedaBuscamos.
  ///
  /// In es, this message translates to:
  /// **'Buscamos: {oficio}'**
  String busquedaBuscamos(String oficio);

  /// No description provided for @busquedaAmbiguo.
  ///
  /// In es, this message translates to:
  /// **'¿Cuál de estos buscas?'**
  String get busquedaAmbiguo;

  /// No description provided for @busquedaNoEntendimos.
  ///
  /// In es, this message translates to:
  /// **'No entendimos qué necesitas'**
  String get busquedaNoEntendimos;

  /// No description provided for @busquedaElegirCategoria.
  ///
  /// In es, this message translates to:
  /// **'Elige una categoría'**
  String get busquedaElegirCategoria;

  /// No description provided for @busquedaSinResultados.
  ///
  /// In es, this message translates to:
  /// **'No encontramos expertos con esa búsqueda.'**
  String get busquedaSinResultados;

  /// No description provided for @busquedaSinResultadosOficio.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay expertos de {oficio} en tu colonia'**
  String busquedaSinResultadosOficio(String oficio);

  /// No description provided for @busquedaPedirCotizacion.
  ///
  /// In es, this message translates to:
  /// **'Pedir cotización de todos modos'**
  String get busquedaPedirCotizacion;

  /// No description provided for @busquedaSinZona.
  ///
  /// In es, this message translates to:
  /// **'Elige tu zona para buscar expertos cerca'**
  String get busquedaSinZona;

  /// No description provided for @busquedaElegirZona.
  ///
  /// In es, this message translates to:
  /// **'Elegir mi zona'**
  String get busquedaElegirZona;

  /// No description provided for @busquedaCargarMas.
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get busquedaCargarMas;

  /// No description provided for @busquedaTope.
  ///
  /// In es, this message translates to:
  /// **'Mostramos los primeros 100. Agrega más palabras para afinar.'**
  String get busquedaTope;

  /// No description provided for @busquedaTotal.
  ///
  /// In es, this message translates to:
  /// **'{n} resultados'**
  String busquedaTotal(int n);

  /// No description provided for @busquedaReintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get busquedaReintentar;

  /// No description provided for @busquedaSinConexion.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get busquedaSinConexion;

  /// No description provided for @busquedaNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'La búsqueda no está disponible en este momento. Intenta de nuevo.'**
  String get busquedaNoDisponible;

  /// No description provided for @busquedaOtrasPalabras.
  ///
  /// In es, this message translates to:
  /// **'Prueba con otras palabras'**
  String get busquedaOtrasPalabras;

  /// No description provided for @busquedaEspera.
  ///
  /// In es, this message translates to:
  /// **'Hiciste muchas búsquedas seguidas. Espera {segundos} segundos.'**
  String busquedaEspera(int segundos);

  /// No description provided for @busquedaCalificacion.
  ///
  /// In es, this message translates to:
  /// **'{calificacion} estrellas, {n} reseñas'**
  String busquedaCalificacion(String calificacion, int n);

  /// No description provided for @busquedaDistancia.
  ///
  /// In es, this message translates to:
  /// **'a unos {km} km'**
  String busquedaDistancia(int km);

  /// No description provided for @busquedaVerificado.
  ///
  /// In es, this message translates to:
  /// **'Verificado: {nivel}'**
  String busquedaVerificado(String nivel);

  /// No description provided for @busquedaNoAtiende.
  ///
  /// In es, this message translates to:
  /// **'No atiende tu colonia'**
  String get busquedaNoAtiende;

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

  /// Título de la hoja del aviso (spec 022).
  ///
  /// In es, this message translates to:
  /// **'Avisar a alguien de confianza'**
  String get avisoTitulo;

  /// Título de la vista previa (R-04).
  ///
  /// In es, this message translates to:
  /// **'Así llegará tu mensaje'**
  String get avisoVistaPrevia;

  /// Título de la lista de contactos.
  ///
  /// In es, this message translates to:
  /// **'¿A quién le avisas?'**
  String get avisoElige;

  /// Sin contactos (§7).
  ///
  /// In es, this message translates to:
  /// **'Agrega a alguien de confianza para avisarle cuando tengas una visita'**
  String get avisoSinContactos;

  /// Texto de privacidad (CA-14).
  ///
  /// In es, this message translates to:
  /// **'Tus contactos se guardan solo en este teléfono'**
  String get avisoPrivacidad;

  /// Botón para agregar un contacto.
  ///
  /// In es, this message translates to:
  /// **'Agregar contacto'**
  String get avisoAgregarContacto;

  /// Título al editar un contacto.
  ///
  /// In es, this message translates to:
  /// **'Editar contacto'**
  String get avisoEditarContacto;

  /// Botón para borrar un contacto.
  ///
  /// In es, this message translates to:
  /// **'Borrar a {nombre}'**
  String avisoBorrarContacto(String nombre);

  /// Botón para editar un contacto.
  ///
  /// In es, this message translates to:
  /// **'Editar a {nombre}'**
  String avisoEditarA(String nombre);

  /// Campo nombre del contacto.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get avisoNombre;

  /// Campo celular del contacto.
  ///
  /// In es, this message translates to:
  /// **'Celular (10 dígitos)'**
  String get avisoCelular;

  /// Guardar el contacto.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get avisoGuardar;

  /// Cancelar el formulario.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get avisoCancelar;

  /// Nombre inválido (CA-05).
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre de 2 a 40 caracteres'**
  String get avisoErrorNombre;

  /// Celular inválido (CA-05).
  ///
  /// In es, this message translates to:
  /// **'Escribe los 10 números del celular'**
  String get avisoErrorCelular;

  /// Celular repetido (CA-07).
  ///
  /// In es, this message translates to:
  /// **'Ese celular ya está en tu lista'**
  String get avisoErrorRepetido;

  /// Máximo de 10 (CA-06).
  ///
  /// In es, this message translates to:
  /// **'Ya tienes 10 contactos. Borra uno para agregar otro.'**
  String get avisoErrorLleno;

  /// Canal SMS (CA-09).
  ///
  /// In es, this message translates to:
  /// **'Enviar por SMS'**
  String get avisoEnviarSms;

  /// Canal WhatsApp (CA-10).
  ///
  /// In es, this message translates to:
  /// **'Enviar por WhatsApp'**
  String get avisoEnviarWhatsapp;

  /// Hoja de compartir del sistema (CA-12).
  ///
  /// In es, this message translates to:
  /// **'Compartir sin guardar'**
  String get avisoCompartir;

  /// Sin app de mensajes o WhatsApp (§7).
  ///
  /// In es, this message translates to:
  /// **'No encontramos una app para enviar. Usa «Compartir».'**
  String get avisoSinApp;

  /// 409 visit_not_notifiable (CA-16).
  ///
  /// In es, this message translates to:
  /// **'Esta visita ya no permite avisos'**
  String get avisoNoPermitido;

  /// Error o sin conexión (CA-16).
  ///
  /// In es, this message translates to:
  /// **'No pudimos registrar el aviso; puedes enviarlo de todos modos'**
  String get avisoSinRegistro;

  /// Sin texto del servidor ni copia local.
  ///
  /// In es, this message translates to:
  /// **'No pudimos preparar el aviso. Intenta de nuevo con conexión.'**
  String get avisoSinDatos;

  /// Plantilla local, encabezado (R-12).
  ///
  /// In es, this message translates to:
  /// **'Hoy recibo a un técnico de Knock.'**
  String get avisoLocalEncabezado;

  /// Plantilla local, técnico verificado.
  ///
  /// In es, this message translates to:
  /// **'Se llama {nombre} y está verificado por Knock.'**
  String avisoLocalVerificado(String nombre);

  /// Plantilla local, técnico sin verificar.
  ///
  /// In es, this message translates to:
  /// **'Se llama {nombre}; todavía no está verificado.'**
  String avisoLocalSinVerificar(String nombre);

  /// Plantilla local, día y hora.
  ///
  /// In es, this message translates to:
  /// **'Viene el {dia} a las {hora}.'**
  String avisoLocalCuando(String dia, String hora);

  /// Plantilla local, recomendación.
  ///
  /// In es, this message translates to:
  /// **'Le pediré el código en la puerta antes de abrir.'**
  String get avisoLocalRecomendacion;

  /// Entrada de Mi cuenta (CA-14).
  ///
  /// In es, this message translates to:
  /// **'Contactos de confianza'**
  String get cuentaContactosConfianza;

  /// Cerrar la hoja del aviso.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get avisoCerrar;

  /// No description provided for @cuentaDescargarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Descargar mis datos'**
  String get cuentaDescargarTitulo;

  /// No description provided for @cuentaDescargarNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'La descarga de tus datos todavía no está disponible en esta versión.'**
  String get cuentaDescargarNoDisponible;

  /// No description provided for @cuentaDescargarCargando.
  ///
  /// In es, this message translates to:
  /// **'Revisando tu archivo…'**
  String get cuentaDescargarCargando;

  /// No description provided for @cuentaDescargarSinPedir.
  ///
  /// In es, this message translates to:
  /// **'Aún no has pedido tu archivo. Lo preparamos en un máximo de 48 horas.'**
  String get cuentaDescargarSinPedir;

  /// No description provided for @cuentaDescargarEnPreparacion.
  ///
  /// In es, this message translates to:
  /// **'Estamos preparando tu archivo. Puede tardar hasta 48 horas.'**
  String get cuentaDescargarEnPreparacion;

  /// No description provided for @cuentaDescargarLista.
  ///
  /// In es, this message translates to:
  /// **'Tu archivo está listo. El enlace vence el {fecha}.'**
  String cuentaDescargarLista(String fecha);

  /// No description provided for @cuentaDescargarVencida.
  ///
  /// In es, this message translates to:
  /// **'Tu archivo anterior venció. Puedes pedirlo otra vez.'**
  String get cuentaDescargarVencida;

  /// No description provided for @cuentaDescargarPedir.
  ///
  /// In es, this message translates to:
  /// **'Pedir mi archivo'**
  String get cuentaDescargarPedir;

  /// No description provided for @cuentaActualizar.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get cuentaActualizar;

  /// No description provided for @cuentaDescargarAbrir.
  ///
  /// In es, this message translates to:
  /// **'Descargar'**
  String get cuentaDescargarAbrir;

  /// No description provided for @cuentaDescargarPedida.
  ///
  /// In es, this message translates to:
  /// **'Pedimos tu archivo. Puede tardar hasta 48 horas.'**
  String get cuentaDescargarPedida;

  /// No description provided for @cuentaDescargarYaEnCurso.
  ///
  /// In es, this message translates to:
  /// **'Ya estamos preparando tu archivo.'**
  String get cuentaDescargarYaEnCurso;

  /// No description provided for @cuentaDescargarNoAbrio.
  ///
  /// In es, this message translates to:
  /// **'No pudimos abrir el enlace.'**
  String get cuentaDescargarNoAbrio;

  /// No description provided for @cuentaReintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get cuentaReintentar;

  /// No description provided for @cuentaConsentimientosCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando tus consentimientos…'**
  String get cuentaConsentimientosCargando;

  /// No description provided for @cuentaConsentimientosVacio.
  ///
  /// In es, this message translates to:
  /// **'No hay consentimientos para mostrar.'**
  String get cuentaConsentimientosVacio;

  /// No description provided for @cuentaConsentimientoPromociones.
  ///
  /// In es, this message translates to:
  /// **'Promociones y novedades'**
  String get cuentaConsentimientoPromociones;

  /// No description provided for @cuentaConsentimientoPromocionesDetalle.
  ///
  /// In es, this message translates to:
  /// **'Ofertas de expertos y noticias de Knock'**
  String get cuentaConsentimientoPromocionesDetalle;

  /// No description provided for @cuentaConsentimientoEncuestas.
  ///
  /// In es, this message translates to:
  /// **'Encuestas para mejorar Knock'**
  String get cuentaConsentimientoEncuestas;

  /// No description provided for @cuentaConsentimientoEncuestasDetalle.
  ///
  /// In es, this message translates to:
  /// **'Preguntas cortas después de un servicio'**
  String get cuentaConsentimientoEncuestasDetalle;

  /// No description provided for @cuentaConsentimientoRecomendaciones.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones personalizadas'**
  String get cuentaConsentimientoRecomendaciones;

  /// No description provided for @cuentaConsentimientoRecomendacionesDetalle.
  ///
  /// In es, this message translates to:
  /// **'Sugerencias según tu casa y tu auto'**
  String get cuentaConsentimientoRecomendacionesDetalle;

  /// No description provided for @cuentaConsentimientoAviso.
  ///
  /// In es, this message translates to:
  /// **'Aviso de privacidad'**
  String get cuentaConsentimientoAviso;

  /// No description provided for @cuentaConsentimientoTerminos.
  ///
  /// In es, this message translates to:
  /// **'Términos y condiciones'**
  String get cuentaConsentimientoTerminos;

  /// No description provided for @cuentaConsentimientoOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro consentimiento'**
  String get cuentaConsentimientoOtro;

  /// No description provided for @cuentaConsentimientoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Obligatorio: no se puede apagar'**
  String get cuentaConsentimientoObligatorio;

  /// No description provided for @cuentaConsentimientoRegistro.
  ///
  /// In es, this message translates to:
  /// **'Versión {version} · {fecha}'**
  String cuentaConsentimientoRegistro(String version, String fecha);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Opiniones'**
  String get opinionesTitulo;

  /// No description provided for @conversacionesSinConexion.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get conversacionesSinConexion;

  /// No description provided for @conversacionesGlobo.
  ///
  /// In es, this message translates to:
  /// **'Mensajes'**
  String get conversacionesGlobo;

  /// No description provided for @conversacionesGloboConTotal.
  ///
  /// In es, this message translates to:
  /// **'Mensajes, {total}'**
  String conversacionesGloboConTotal(String total);

  /// No description provided for @conversacionesCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando conversaciones…'**
  String get conversacionesCargando;

  /// No description provided for @conversacionesVacias.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes conversaciones. El chat se abre al recibir cotizaciones.'**
  String get conversacionesVacias;

  /// No description provided for @conversacionesNoLeidos.
  ///
  /// In es, this message translates to:
  /// **'{total, plural, =1{1 mensaje sin leer} other{{total} mensajes sin leer}}'**
  String conversacionesNoLeidos(int total);

  /// No description provided for @chatEnvioCampo.
  ///
  /// In es, this message translates to:
  /// **'Escribe un mensaje'**
  String get chatEnvioCampo;

  /// No description provided for @chatEnvioEnviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get chatEnvioEnviar;

  /// No description provided for @chatEnvioPendiente.
  ///
  /// In es, this message translates to:
  /// **'Enviando…'**
  String get chatEnvioPendiente;

  /// No description provided for @chatEnvioFallido.
  ///
  /// In es, this message translates to:
  /// **'No se envió'**
  String get chatEnvioFallido;

  /// No description provided for @chatEnvioReintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get chatEnvioReintentar;

  /// No description provided for @chatEnvioDescartar.
  ///
  /// In es, this message translates to:
  /// **'Descartar'**
  String get chatEnvioDescartar;

  /// No description provided for @chatEnvioMuyLargo.
  ///
  /// In es, this message translates to:
  /// **'El mensaje admite hasta 1000 caracteres.'**
  String get chatEnvioMuyLargo;

  /// No description provided for @chatEnvioCaracterNoPermitido.
  ///
  /// In es, this message translates to:
  /// **'El mensaje tiene caracteres que no se pueden enviar.'**
  String get chatEnvioCaracterNoPermitido;

  /// No description provided for @chatEnvioErrorContenido.
  ///
  /// In es, this message translates to:
  /// **'No pudimos enviar ese mensaje. Revisa lo que escribiste.'**
  String get chatEnvioErrorContenido;

  /// No description provided for @chatEnvioErrorLimite.
  ///
  /// In es, this message translates to:
  /// **'Enviaste muchos mensajes. Espera {segundos} segundos.'**
  String chatEnvioErrorLimite(int segundos);

  /// No description provided for @chatEnvioErrorNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'No pudimos enviar el mensaje. Intenta de nuevo en un momento.'**
  String get chatEnvioErrorNoDisponible;

  /// No description provided for @chatEnvioConversacionNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Esta conversación ya no está disponible.'**
  String get chatEnvioConversacionNoDisponible;

  /// No description provided for @chatEnvioCerrada.
  ///
  /// In es, this message translates to:
  /// **'La conversación está cerrada.'**
  String get chatEnvioCerrada;

  /// No description provided for @conversacionAtras.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get conversacionAtras;

  /// No description provided for @conversacionTitulo.
  ///
  /// In es, this message translates to:
  /// **'Conversación'**
  String get conversacionTitulo;

  /// No description provided for @conversacionCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando conversación…'**
  String get conversacionCargando;

  /// No description provided for @conversacionSinMensajes.
  ///
  /// In es, this message translates to:
  /// **'Escribe el primer mensaje.'**
  String get conversacionSinMensajes;

  /// No description provided for @conversacionSinEnVivo.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión en vivo'**
  String get conversacionSinEnVivo;

  /// No description provided for @conversacionActualizar.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get conversacionActualizar;

  /// No description provided for @conversacionVerAnteriores.
  ///
  /// In es, this message translates to:
  /// **'Ver mensajes anteriores'**
  String get conversacionVerAnteriores;

  /// No description provided for @conversacionTu.
  ///
  /// In es, this message translates to:
  /// **'Tú'**
  String get conversacionTu;

  /// No description provided for @conversacionCerradaCancelada.
  ///
  /// In es, this message translates to:
  /// **'La solicitud se canceló; la conversación está cerrada.'**
  String get conversacionCerradaCancelada;

  /// No description provided for @conversacionCerradaVencida.
  ///
  /// In es, this message translates to:
  /// **'La solicitud venció; la conversación está cerrada.'**
  String get conversacionCerradaVencida;

  /// No description provided for @conversacionCerradaOtraElegida.
  ///
  /// In es, this message translates to:
  /// **'Se eligió otra cotización; la conversación está cerrada.'**
  String get conversacionCerradaOtraElegida;

  /// No description provided for @conversacionCerradaDescartada.
  ///
  /// In es, this message translates to:
  /// **'La solicitud se descartó; la conversación está cerrada.'**
  String get conversacionCerradaDescartada;

  /// No description provided for @conversacionPreguntar.
  ///
  /// In es, this message translates to:
  /// **'Preguntar'**
  String get conversacionPreguntar;

  /// No description provided for @conversacionChatear.
  ///
  /// In es, this message translates to:
  /// **'Chatear'**
  String get conversacionChatear;

  /// No description provided for @conversacionAbrirError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos abrir el chat. Intenta de nuevo en un momento.'**
  String get conversacionAbrirError;

  /// No description provided for @conversacionMenu.
  ///
  /// In es, this message translates to:
  /// **'Más opciones'**
  String get conversacionMenu;

  /// No description provided for @conversacionVerPerfil.
  ///
  /// In es, this message translates to:
  /// **'Ver su perfil'**
  String get conversacionVerPerfil;

  /// No description provided for @conversacionReportar.
  ///
  /// In es, this message translates to:
  /// **'Reportar'**
  String get conversacionReportar;

  /// No description provided for @conversacionBloquear.
  ///
  /// In es, this message translates to:
  /// **'Bloquear'**
  String get conversacionBloquear;

  /// No description provided for @conversacionRapidaFoto.
  ///
  /// In es, this message translates to:
  /// **'¿Me manda una foto?'**
  String get conversacionRapidaFoto;

  /// No description provided for @conversacionRapidaColonia.
  ///
  /// In es, this message translates to:
  /// **'¿Cuál es su colonia?'**
  String get conversacionRapidaColonia;

  /// No description provided for @conversacionRapidaDia.
  ///
  /// In es, this message translates to:
  /// **'¿Qué día le acomoda?'**
  String get conversacionRapidaDia;

  /// No description provided for @conversacionRapidaMateriales.
  ///
  /// In es, this message translates to:
  /// **'Llevo los materiales'**
  String get conversacionRapidaMateriales;

  /// No description provided for @conversacionRapidaCuando.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo puede venir?'**
  String get conversacionRapidaCuando;

  /// No description provided for @conversacionRapidaIncluye.
  ///
  /// In es, this message translates to:
  /// **'¿Incluye materiales?'**
  String get conversacionRapidaIncluye;

  /// No description provided for @conversacionRapidaTarda.
  ///
  /// In es, this message translates to:
  /// **'¿Cuánto tarda?'**
  String get conversacionRapidaTarda;

  /// No description provided for @conversacionRapidaEnCamino.
  ///
  /// In es, this message translates to:
  /// **'¿Ya viene en camino?'**
  String get conversacionRapidaEnCamino;

  /// No description provided for @conversacionRapidaGracias.
  ///
  /// In es, this message translates to:
  /// **'Gracias'**
  String get conversacionRapidaGracias;

  /// No description provided for @chatContactoOculto.
  ///
  /// In es, this message translates to:
  /// **'El número se comparte al elegir una cotización; te sugerimos no compartirlo antes.'**
  String get chatContactoOculto;

  /// Nivel de reputación enviado por el servidor
  ///
  /// In es, this message translates to:
  /// **'Nivel: {nivel}'**
  String reputacionNivel(String nivel);

  /// No description provided for @reputacionNuevo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get reputacionNuevo;

  /// No description provided for @reputacionConfiable.
  ///
  /// In es, this message translates to:
  /// **'Confiable'**
  String get reputacionConfiable;

  /// No description provided for @reputacionDestacado.
  ///
  /// In es, this message translates to:
  /// **'Destacado'**
  String get reputacionDestacado;

  /// No description provided for @trabajoProximasVisitas.
  ///
  /// In es, this message translates to:
  /// **'Próximas visitas'**
  String get trabajoProximasVisitas;

  /// No description provided for @trabajoPendiente.
  ///
  /// In es, this message translates to:
  /// **'Los trabajos terminados todavía no se muestran aquí.'**
  String get trabajoPendiente;

  /// No description provided for @trabajoVerificacion.
  ///
  /// In es, this message translates to:
  /// **'Mi verificación'**
  String get trabajoVerificacion;

  /// No description provided for @trabajoReputacion.
  ///
  /// In es, this message translates to:
  /// **'Mi reputación'**
  String get trabajoReputacion;

  /// No description provided for @trabajoDisponibleHoy.
  ///
  /// In es, this message translates to:
  /// **'Disponible hoy'**
  String get trabajoDisponibleHoy;

  /// No description provided for @trabajoDisponibleDetalle.
  ///
  /// In es, this message translates to:
  /// **'Enciéndelo si hoy puedes atender solicitudes. Se apaga solo al terminar el día.'**
  String get trabajoDisponibleDetalle;

  /// No description provided for @trabajoDisponibleCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando tu disponibilidad…'**
  String get trabajoDisponibleCargando;

  /// No description provided for @visitaAusenteBoton.
  ///
  /// In es, this message translates to:
  /// **'El cliente no estaba'**
  String get visitaAusenteBoton;

  /// No description provided for @visitaAusenteExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Se registra que el cliente no estaba. A ti no se te penaliza. Solo se puede dentro de la ventana de la cita.'**
  String get visitaAusenteExplicacion;

  /// No description provided for @visitaAusenteConfirmar.
  ///
  /// In es, this message translates to:
  /// **'Registrar que no estaba'**
  String get visitaAusenteConfirmar;

  /// No description provided for @visitaAusenteRegistrada.
  ///
  /// In es, this message translates to:
  /// **'Registramos que el cliente no estaba.'**
  String get visitaAusenteRegistrada;

  /// No description provided for @visitaAusenteFueraDeVentana.
  ///
  /// In es, this message translates to:
  /// **'Ahora no se puede registrar: solo dentro de la ventana de la cita.'**
  String get visitaAusenteFueraDeVentana;

  /// No description provided for @visitaTecnicoAusenteBoton.
  ///
  /// In es, this message translates to:
  /// **'El técnico no se presentó'**
  String get visitaTecnicoAusenteBoton;

  /// No description provided for @visitaTecnicoAusenteExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Confirma solo si el técnico no llegó. Se puede registrar desde 15 minutos hasta 2 horas después de la hora de la cita.'**
  String get visitaTecnicoAusenteExplicacion;

  /// No description provided for @visitaTecnicoAusenteConfirmar.
  ///
  /// In es, this message translates to:
  /// **'Registrar que no llegó'**
  String get visitaTecnicoAusenteConfirmar;

  /// No description provided for @visitaTecnicoAusenteRegistrada.
  ///
  /// In es, this message translates to:
  /// **'Registraste que el técnico no se presentó.'**
  String get visitaTecnicoAusenteRegistrada;

  /// No description provided for @visitaTerminarBoton.
  ///
  /// In es, this message translates to:
  /// **'Terminar servicio'**
  String get visitaTerminarBoton;

  /// No description provided for @visitaTerminarFotos.
  ///
  /// In es, this message translates to:
  /// **'Fotos del trabajo terminado (de 1 a 5)'**
  String get visitaTerminarFotos;

  /// No description provided for @visitaTerminarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué hiciste?'**
  String get visitaTerminarDescripcion;

  /// No description provided for @visitaTerminarDescripcionAyuda.
  ///
  /// In es, this message translates to:
  /// **'De 8 a 500 caracteres.'**
  String get visitaTerminarDescripcionAyuda;

  /// No description provided for @visitaTerminarRecomendacion.
  ///
  /// In es, this message translates to:
  /// **'Recomendación para el cliente (opcional)'**
  String get visitaTerminarRecomendacion;

  /// No description provided for @visitaTerminarSinSubida.
  ///
  /// In es, this message translates to:
  /// **'La subida de fotos todavía no está disponible, así que no puedes terminar el servicio desde la app.'**
  String get visitaTerminarSinSubida;

  /// No description provided for @visitaTerminarNoEnCurso.
  ///
  /// In es, this message translates to:
  /// **'Esta visita no está en curso: no se puede terminar.'**
  String get visitaTerminarNoEnCurso;

  /// No description provided for @visitaTerminarHecho.
  ///
  /// In es, this message translates to:
  /// **'Servicio terminado.'**
  String get visitaTerminarHecho;

  /// No description provided for @llegadaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Confirmar llegada'**
  String get llegadaTitulo;

  /// No description provided for @llegadaCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando tu visita…'**
  String get llegadaCargando;

  /// No description provided for @llegadaInstruccion.
  ///
  /// In es, this message translates to:
  /// **'Pide en la puerta el código de 4 dígitos y escríbelo aquí.'**
  String get llegadaInstruccion;

  /// No description provided for @llegadaCodigo.
  ///
  /// In es, this message translates to:
  /// **'Código de 4 dígitos'**
  String get llegadaCodigo;

  /// No description provided for @llegadaConfirmar.
  ///
  /// In es, this message translates to:
  /// **'Ya llegué'**
  String get llegadaConfirmar;

  /// No description provided for @llegadaConfirmando.
  ///
  /// In es, this message translates to:
  /// **'Confirmando…'**
  String get llegadaConfirmando;

  /// No description provided for @llegadaConfirmada.
  ///
  /// In es, this message translates to:
  /// **'Llegada confirmada. La visita está en curso.'**
  String get llegadaConfirmada;

  /// No description provided for @llegadaHora.
  ///
  /// In es, this message translates to:
  /// **'Hora de llegada: {hora}'**
  String llegadaHora(String hora);

  /// No description provided for @llegadaIncorrecto.
  ///
  /// In es, this message translates to:
  /// **'El código no coincide. Confirma que estás en la dirección correcta.'**
  String get llegadaIncorrecto;

  /// No description provided for @llegadaIntentos.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Te queda 1 intento} other{Te quedan {n} intentos}}'**
  String llegadaIntentos(int n);

  /// No description provided for @llegadaCuatroDigitos.
  ///
  /// In es, this message translates to:
  /// **'Escribe los 4 dígitos.'**
  String get llegadaCuatroDigitos;

  /// No description provided for @llegadaBloqueada.
  ///
  /// In es, this message translates to:
  /// **'Esta visita quedó bloqueada por seguridad. El equipo de Knock la revisará.'**
  String get llegadaBloqueada;

  /// No description provided for @llegadaYaUsado.
  ///
  /// In es, this message translates to:
  /// **'Este código ya se usó.'**
  String get llegadaYaUsado;

  /// No description provided for @llegadaVencido.
  ///
  /// In es, this message translates to:
  /// **'El código de esta visita ya venció.'**
  String get llegadaVencido;

  /// No description provided for @llegadaCancelada.
  ///
  /// In es, this message translates to:
  /// **'Esta visita se canceló.'**
  String get llegadaCancelada;

  /// No description provided for @errorFueraDeVentana.
  ///
  /// In es, this message translates to:
  /// **'Podrás confirmar la llegada el día de la cita, desde las 00:00.'**
  String get errorFueraDeVentana;

  /// No description provided for @errorVisitaNoVigente.
  ///
  /// In es, this message translates to:
  /// **'Esta visita ya no está vigente.'**
  String get errorVisitaNoVigente;

  /// No description provided for @llegadaTaller.
  ///
  /// In es, this message translates to:
  /// **'Esta cita es en el taller y no necesita código.'**
  String get llegadaTaller;

  /// No description provided for @llegadaNoTecnico.
  ///
  /// In es, this message translates to:
  /// **'Solo el técnico de la visita puede confirmar la llegada.'**
  String get llegadaNoTecnico;

  /// No description provided for @llegadaNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Esta visita ya no está disponible.'**
  String get llegadaNoDisponible;

  /// No description provided for @llegadaAunNo.
  ///
  /// In es, this message translates to:
  /// **'Podrás confirmar tu llegada el día de la cita.'**
  String get llegadaAunNo;

  /// No description provided for @llegadaReintentoCuenta.
  ///
  /// In es, this message translates to:
  /// **'Si el código era incorrecto, este reintento cuenta como intento.'**
  String get llegadaReintentoCuenta;

  /// No description provided for @llegadaEspera.
  ///
  /// In es, this message translates to:
  /// **'Hiciste muchos intentos. Espera {segundos} segundos.'**
  String llegadaEspera(int segundos);

  /// No description provided for @agendaCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando tu agenda…'**
  String get agendaCargando;

  /// No description provided for @agendaError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tu agenda.'**
  String get agendaError;

  /// No description provided for @agendaVacia.
  ///
  /// In es, this message translates to:
  /// **'No tienes visitas próximas.'**
  String get agendaVacia;

  /// No description provided for @agendaSinMapa.
  ///
  /// In es, this message translates to:
  /// **'La ubicación de las visitas no está disponible en el mapa.'**
  String get agendaSinMapa;

  /// No description provided for @agendaVerMas.
  ///
  /// In es, this message translates to:
  /// **'Ver más visitas'**
  String get agendaVerMas;

  /// No description provided for @agendaEstado.
  ///
  /// In es, this message translates to:
  /// **'{estado, select, confirmada{Confirmada} en_curso{En curso} terminada{Terminada} cancelada{Cancelada} no_presentado{No se presentó} other{Estado no disponible}}'**
  String agendaEstado(String estado);

  /// No description provided for @agendaModalidad.
  ///
  /// In es, this message translates to:
  /// **'{modalidad, select, domicilio{A domicilio} taller{En taller} other{Modalidad no disponible}}'**
  String agendaModalidad(String modalidad);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Cargando las opiniones…'**
  String get opinionesCargando;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar las opiniones.'**
  String get opinionesError;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Ese técnico ya no está disponible.'**
  String get opinionesNoDisponible;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get opinionesReintentar;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Aún sin opiniones. Las primeras llegan después de su primer servicio por Knock.'**
  String get opinionesVacio;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Es lo que viste el {fecha}; puede estar desactualizado.'**
  String opinionesCopia(String fecha);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'★ {promedio} de 5'**
  String opinionesPromedio(String promedio);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'{total, plural, =1{1 opinión} other{{total} opiniones}}'**
  String opinionesTotal(int total);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'{estrellas} estrellas: {total}'**
  String opinionesEstrellas(int estrellas, int total);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Ver las opiniones'**
  String get opinionesVerTodas;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get opinionesVerMas;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Servicio verificado'**
  String get opinionesServicioVerificado;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Usuario eliminado'**
  String get opinionesAnonima;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Respuesta del técnico: {texto}'**
  String opinionesRespuesta(String texto);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Puntualidad'**
  String get opinionesPuntualidad;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Calidad'**
  String get opinionesCalidad;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Precio justo'**
  String get opinionesPrecioJusto;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Trato'**
  String get opinionesTrato;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Califica el servicio'**
  String get opinionesCalificarTitulo;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'¿Cómo te fue?'**
  String get opinionesCalificarPregunta;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Calificar el servicio'**
  String get opinionesCalificarBoton;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'{estrella} de 5 estrellas'**
  String opinionesEstrellaBoton(int estrella);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'{parte}: {estrella} de 5 estrellas'**
  String opinionesParteBoton(String parte, int estrella);

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Por partes (opcional)'**
  String get opinionesPorPartes;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Cuéntale a otros cómo fue'**
  String get opinionesComentario;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Guardar en mis técnicos de confianza'**
  String get opinionesGuardarConfianza;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Publicar opinión'**
  String get opinionesPublicar;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Publicando…'**
  String get opinionesPublicando;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Elige cuántas estrellas para continuar'**
  String get opinionesElige;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Recibimos tu opinión. ¡Gracias!'**
  String get opinionesEnviada;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Esta visita ya no se puede calificar: ya opinaste o pasaron los 30 días.'**
  String get opinionesErrorNoPermitida;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Esta opinión ya tiene respuesta.'**
  String get opinionesErrorYaRespondida;

  /// Opiniones (spec 041).
  ///
  /// In es, this message translates to:
  /// **'Esa visita ya no está disponible.'**
  String get opinionesVisitaNoDisponible;

  /// No description provided for @cuentaPendientesCargando.
  ///
  /// In es, this message translates to:
  /// **'Revisando lo que tienes pendiente…'**
  String get cuentaPendientesCargando;

  /// No description provided for @cuentaPendientesVacio.
  ///
  /// In es, this message translates to:
  /// **'No tienes citas ni cotizaciones abiertas.'**
  String get cuentaPendientesVacio;

  /// No description provided for @cuentaPendientesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Lo que tienes pendiente'**
  String get cuentaPendientesTitulo;

  /// No description provided for @cuentaPendientesCitas.
  ///
  /// In es, this message translates to:
  /// **'Citas abiertas: {total}'**
  String cuentaPendientesCitas(int total);

  /// No description provided for @cuentaPendientesCotizaciones.
  ///
  /// In es, this message translates to:
  /// **'Cotizaciones abiertas: {total}'**
  String cuentaPendientesCotizaciones(int total);

  /// No description provided for @cuentaPendientesNota.
  ///
  /// In es, this message translates to:
  /// **'Al programar la eliminación se cancelan tus solicitudes abiertas y las cotizaciones pendientes, y avisamos a las personas involucradas.'**
  String get cuentaPendientesNota;

  /// No description provided for @cuentaEliminarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get cuentaEliminarTitulo;

  /// No description provided for @cuentaEliminarPregunta.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar tu cuenta?'**
  String get cuentaEliminarPregunta;

  /// No description provided for @cuentaEliminarGracia.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta quedará programada para eliminarse en 7 días y puedes cancelarlo antes.'**
  String get cuentaEliminarGracia;

  /// No description provided for @cuentaEliminarEscribe.
  ///
  /// In es, this message translates to:
  /// **'Escribe ELIMINAR para confirmar'**
  String get cuentaEliminarEscribe;

  /// No description provided for @cuentaEliminarVerifica.
  ///
  /// In es, this message translates to:
  /// **'Por seguridad, confirma tu celular con un código por SMS.'**
  String get cuentaEliminarVerifica;

  /// No description provided for @cuentaEliminarCelular.
  ///
  /// In es, this message translates to:
  /// **'Tu celular (10 dígitos)'**
  String get cuentaEliminarCelular;

  /// No description provided for @cuentaEliminarEnviarCodigo.
  ///
  /// In es, this message translates to:
  /// **'Enviarme el código'**
  String get cuentaEliminarEnviarCodigo;

  /// No description provided for @cuentaEliminarCodigo.
  ///
  /// In es, this message translates to:
  /// **'Código de 6 dígitos'**
  String get cuentaEliminarCodigo;

  /// No description provided for @cuentaEliminarVerificacionRechazada.
  ///
  /// In es, this message translates to:
  /// **'No pudimos confirmar tu identidad con ese número. Usa el celular de esta cuenta y pide otro código.'**
  String get cuentaEliminarVerificacionRechazada;

  /// No description provided for @cuentaEliminarNoPermitida.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar ahora: ya está programada o tienes una visita en curso.'**
  String get cuentaEliminarNoPermitida;

  /// No description provided for @cuentaEliminarEnviando.
  ///
  /// In es, this message translates to:
  /// **'Un momento…'**
  String get cuentaEliminarEnviando;

  /// No description provided for @cuentaEliminarBoton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar mi cuenta'**
  String get cuentaEliminarBoton;

  /// No description provided for @cuentaEliminarMejorNo.
  ///
  /// In es, this message translates to:
  /// **'Mejor no'**
  String get cuentaEliminarMejorNo;

  /// No description provided for @cuentaEliminacionProgramada.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta está programada para eliminarse'**
  String get cuentaEliminacionProgramada;

  /// No description provided for @cuentaEliminacionProgramadaEl.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta se eliminará el {fecha}'**
  String cuentaEliminacionProgramadaEl(String fecha);

  /// No description provided for @cuentaEliminacionDetalle.
  ///
  /// In es, this message translates to:
  /// **'Tienes 7 días para arrepentirte: antes de que termine el plazo puedes cancelar la eliminación.'**
  String get cuentaEliminacionDetalle;

  /// No description provided for @cuentaEliminacionCargando.
  ///
  /// In es, this message translates to:
  /// **'Revisando tu cuenta…'**
  String get cuentaEliminacionCargando;

  /// No description provided for @cuentaEliminacionNinguna.
  ///
  /// In es, this message translates to:
  /// **'No tienes una eliminación programada'**
  String get cuentaEliminacionNinguna;

  /// No description provided for @cuentaEliminacionCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar la eliminación'**
  String get cuentaEliminacionCancelar;

  /// No description provided for @cuentaEliminacionCancelada.
  ///
  /// In es, this message translates to:
  /// **'Cancelaste la eliminación de tu cuenta'**
  String get cuentaEliminacionCancelada;

  /// No description provided for @cuentaEliminacionNadaQueCancelar.
  ///
  /// In es, this message translates to:
  /// **'No hay una eliminación programada que cancelar.'**
  String get cuentaEliminacionNadaQueCancelar;

  /// No description provided for @cuentaEliminacionIrACuenta.
  ///
  /// In es, this message translates to:
  /// **'Ir a Mi cuenta'**
  String get cuentaEliminacionIrACuenta;

  /// No description provided for @cuentaEliminacionSalir.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get cuentaEliminacionSalir;

  /// No description provided for @bloqueosMotivoAcoso.
  ///
  /// In es, this message translates to:
  /// **'Acoso'**
  String get bloqueosMotivoAcoso;

  /// No description provided for @bloqueosMotivoFraude.
  ///
  /// In es, this message translates to:
  /// **'Fraude'**
  String get bloqueosMotivoFraude;

  /// No description provided for @bloqueosMotivoMalServicio.
  ///
  /// In es, this message translates to:
  /// **'Mal servicio'**
  String get bloqueosMotivoMalServicio;

  /// No description provided for @bloqueosMotivoComportamiento.
  ///
  /// In es, this message translates to:
  /// **'Comportamiento inapropiado'**
  String get bloqueosMotivoComportamiento;

  /// No description provided for @bloqueosMotivoPeligro.
  ///
  /// In es, this message translates to:
  /// **'Peligro'**
  String get bloqueosMotivoPeligro;

  /// No description provided for @bloqueosMotivoOtro.
  ///
  /// In es, this message translates to:
  /// **'Otra cosa'**
  String get bloqueosMotivoOtro;

  /// No description provided for @bloqueosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Reportar un problema'**
  String get bloqueosTitulo;

  /// No description provided for @bloqueosCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando…'**
  String get bloqueosCargando;

  /// No description provided for @bloqueosNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'No es posible reportar desde esta visita.'**
  String get bloqueosNoDisponible;

  /// No description provided for @bloqueosReintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get bloqueosReintentar;

  /// No description provided for @bloqueosAviso911.
  ///
  /// In es, this message translates to:
  /// **'Si estás en peligro, llama al 911.'**
  String get bloqueosAviso911;

  /// No description provided for @bloqueosRecibido.
  ///
  /// In es, this message translates to:
  /// **'Recibimos tu reporte'**
  String get bloqueosRecibido;

  /// No description provided for @bloqueosVolver.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get bloqueosVolver;

  /// No description provided for @bloqueosQuePaso.
  ///
  /// In es, this message translates to:
  /// **'¿Qué pasó?'**
  String get bloqueosQuePaso;

  /// No description provided for @bloqueosDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos qué pasó (de 8 a 500 caracteres)'**
  String get bloqueosDescripcion;

  /// No description provided for @bloqueosEnviando.
  ///
  /// In es, this message translates to:
  /// **'Enviando…'**
  String get bloqueosEnviando;

  /// No description provided for @bloqueosEnviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar reporte'**
  String get bloqueosEnviar;

  /// No description provided for @bloqueosFalta.
  ///
  /// In es, this message translates to:
  /// **'Elige qué pasó y escribe al menos 8 caracteres'**
  String get bloqueosFalta;

  /// No description provided for @bloqueosMios.
  ///
  /// In es, this message translates to:
  /// **'Mis reportes'**
  String get bloqueosMios;

  /// No description provided for @bloqueosCargandoLista.
  ///
  /// In es, this message translates to:
  /// **'Cargando tus reportes…'**
  String get bloqueosCargandoLista;

  /// No description provided for @bloqueosErrorLista.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus reportes.'**
  String get bloqueosErrorLista;

  /// No description provided for @bloqueosVacio.
  ///
  /// In es, this message translates to:
  /// **'No has hecho reportes.'**
  String get bloqueosVacio;

  /// No description provided for @bloqueosVerMas.
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get bloqueosVerMas;

  /// No description provided for @bloqueosApelacionEnviada.
  ///
  /// In es, this message translates to:
  /// **'Enviamos tu apelación'**
  String get bloqueosApelacionEnviada;

  /// No description provided for @bloqueosEstadoAbierto.
  ///
  /// In es, this message translates to:
  /// **'En revisión'**
  String get bloqueosEstadoAbierto;

  /// No description provided for @bloqueosEstadoDecidido.
  ///
  /// In es, this message translates to:
  /// **'Decidido'**
  String get bloqueosEstadoDecidido;

  /// No description provided for @bloqueosEstadoEnApelacion.
  ///
  /// In es, this message translates to:
  /// **'En apelación'**
  String get bloqueosEstadoEnApelacion;

  /// No description provided for @bloqueosEstadoOtro.
  ///
  /// In es, this message translates to:
  /// **'Estado no disponible'**
  String get bloqueosEstadoOtro;

  /// No description provided for @bloqueosApelar.
  ///
  /// In es, this message translates to:
  /// **'Apelar la decisión'**
  String get bloqueosApelar;

  /// No description provided for @bloqueosApelacionTexto.
  ///
  /// In es, this message translates to:
  /// **'Explica por qué apelas (de 8 a 500 caracteres)'**
  String get bloqueosApelacionTexto;

  /// No description provided for @bloqueosEnviarApelacion.
  ///
  /// In es, this message translates to:
  /// **'Enviar apelación'**
  String get bloqueosEnviarApelacion;

  /// No description provided for @bloqueosErrorYaBloqueado.
  ///
  /// In es, this message translates to:
  /// **'Ya habías bloqueado a esta persona.'**
  String get bloqueosErrorYaBloqueado;

  /// No description provided for @bloqueosErrorApelacion.
  ///
  /// In es, this message translates to:
  /// **'Este reporte ya no se puede apelar.'**
  String get bloqueosErrorApelacion;

  /// No description provided for @bloqueosPantallaBloquear.
  ///
  /// In es, this message translates to:
  /// **'Bloquear a una persona'**
  String get bloqueosPantallaBloquear;

  /// No description provided for @bloqueosPersonasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Personas bloqueadas'**
  String get bloqueosPersonasTitulo;

  /// No description provided for @bloqueosPersonasCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando a quién bloqueaste…'**
  String get bloqueosPersonasCargando;

  /// No description provided for @bloqueosPersonasError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus bloqueos.'**
  String get bloqueosPersonasError;

  /// No description provided for @bloqueosPersonasVacio.
  ///
  /// In es, this message translates to:
  /// **'No has bloqueado a nadie.'**
  String get bloqueosPersonasVacio;

  /// No description provided for @bloqueosBloqueadaEl.
  ///
  /// In es, this message translates to:
  /// **'Bloqueada el'**
  String get bloqueosBloqueadaEl;

  /// No description provided for @bloqueosDesbloquear.
  ///
  /// In es, this message translates to:
  /// **'Desbloquear'**
  String get bloqueosDesbloquear;

  /// No description provided for @bloqueosDesbloqueando.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueando…'**
  String get bloqueosDesbloqueando;

  /// No description provided for @bloqueosDesbloqueada.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueaste a esta persona.'**
  String get bloqueosDesbloqueada;

  /// No description provided for @bloqueosBloquear.
  ///
  /// In es, this message translates to:
  /// **'Bloquear a esta persona'**
  String get bloqueosBloquear;

  /// No description provided for @bloqueosBloqueando.
  ///
  /// In es, this message translates to:
  /// **'Bloqueando…'**
  String get bloqueosBloqueando;

  /// No description provided for @bloqueosBloqueada.
  ///
  /// In es, this message translates to:
  /// **'Bloqueaste a esta persona.'**
  String get bloqueosBloqueada;

  /// No description provided for @bloqueosBloquearAviso.
  ///
  /// In es, this message translates to:
  /// **'Ya no podrá escribirte ni verte en las búsquedas.'**
  String get bloqueosBloquearAviso;

  /// No description provided for @bloqueosConfirmarBloqueoTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Bloquear a esta persona?'**
  String get bloqueosConfirmarBloqueoTitulo;

  /// No description provided for @bloqueosConfirmarBloqueo.
  ///
  /// In es, this message translates to:
  /// **'Sí, bloquear'**
  String get bloqueosConfirmarBloqueo;

  /// No description provided for @bloqueosCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get bloqueosCancelar;

  /// No description provided for @bloqueosDeshacer.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get bloqueosDeshacer;

  /// No description provided for @bloqueosNoEncontrada.
  ///
  /// In es, this message translates to:
  /// **'Esa persona ya no está disponible.'**
  String get bloqueosNoEncontrada;

  /// No description provided for @bloqueosErrorYaNoBloqueada.
  ///
  /// In es, this message translates to:
  /// **'Esa persona ya no estaba bloqueada.'**
  String get bloqueosErrorYaNoBloqueada;

  /// No description provided for @bloqueosErrorNoBloquearse.
  ///
  /// In es, this message translates to:
  /// **'No puedes bloquearte a ti mismo.'**
  String get bloqueosErrorNoBloquearse;

  /// No description provided for @direccionesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Mis direcciones'**
  String get direccionesTitulo;

  /// No description provided for @direccionesCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando tus direcciones…'**
  String get direccionesCargando;

  /// No description provided for @direccionesError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus direcciones.'**
  String get direccionesError;

  /// No description provided for @direccionesReintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get direccionesReintentar;

  /// No description provided for @direccionesVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes direcciones guardadas.'**
  String get direccionesVacio;

  /// No description provided for @direccionesAgregar.
  ///
  /// In es, this message translates to:
  /// **'Agregar dirección'**
  String get direccionesAgregar;

  /// No description provided for @direccionesEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get direccionesEditar;

  /// No description provided for @direccionesEliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get direccionesEliminar;

  /// No description provided for @direccionesPrincipal.
  ///
  /// In es, this message translates to:
  /// **'Principal'**
  String get direccionesPrincipal;

  /// No description provided for @direccionesSinReferencias.
  ///
  /// In es, this message translates to:
  /// **'Sin referencias'**
  String get direccionesSinReferencias;

  /// No description provided for @direccionesNueva.
  ///
  /// In es, this message translates to:
  /// **'Nueva dirección'**
  String get direccionesNueva;

  /// No description provided for @direccionesEditarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar dirección'**
  String get direccionesEditarTitulo;

  /// No description provided for @direccionesCalle.
  ///
  /// In es, this message translates to:
  /// **'Calle y número'**
  String get direccionesCalle;

  /// No description provided for @direccionesReferencias.
  ///
  /// In es, this message translates to:
  /// **'Referencias (opcional)'**
  String get direccionesReferencias;

  /// No description provided for @direccionesColonia.
  ///
  /// In es, this message translates to:
  /// **'Colonia: {colonia}'**
  String direccionesColonia(String colonia);

  /// No description provided for @direccionesCambiarColonia.
  ///
  /// In es, this message translates to:
  /// **'Usar mi colonia actual: {colonia}'**
  String direccionesCambiarColonia(String colonia);

  /// No description provided for @direccionesMarcarPrincipal.
  ///
  /// In es, this message translates to:
  /// **'Usar como principal'**
  String get direccionesMarcarPrincipal;

  /// No description provided for @direccionesGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar dirección'**
  String get direccionesGuardar;

  /// No description provided for @direccionesGuardando.
  ///
  /// In es, this message translates to:
  /// **'Guardando…'**
  String get direccionesGuardando;

  /// No description provided for @direccionesCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get direccionesCancelar;

  /// No description provided for @direccionesConfirmarEliminar.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar esta dirección?'**
  String get direccionesConfirmarEliminar;

  /// No description provided for @direccionesNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Esa dirección ya no está disponible.'**
  String get direccionesNoDisponible;

  /// No description provided for @visitaReprogramar.
  ///
  /// In es, this message translates to:
  /// **'Reprogramar la cita'**
  String get visitaReprogramar;

  /// No description provided for @visitaCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar el servicio'**
  String get visitaCancelar;

  /// No description provided for @visitaCambioPendiente.
  ///
  /// In es, this message translates to:
  /// **'Hay un cambio de fecha esperando respuesta. Mientras tanto, la cita actual sigue en pie.'**
  String get visitaCambioPendiente;

  /// No description provided for @visitaCancelarTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Cancelar el servicio?'**
  String get visitaCancelarTitulo;

  /// No description provided for @visitaCancelarConfirmar.
  ///
  /// In es, this message translates to:
  /// **'Sí, cancelar'**
  String get visitaCancelarConfirmar;

  /// No description provided for @visitaCancelarAviso.
  ///
  /// In es, this message translates to:
  /// **'Con más de 24 h de anticipación es sin costo. Con menos, queda como cancelación tardía y avisamos de inmediato.'**
  String get visitaCancelarAviso;

  /// No description provided for @visitaCancelarMotivo.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué cancelas?'**
  String get visitaCancelarMotivo;

  /// No description provided for @visitaMotivoResuelto.
  ///
  /// In es, this message translates to:
  /// **'Ya lo resolví'**
  String get visitaMotivoResuelto;

  /// No description provided for @visitaMotivoPlanes.
  ///
  /// In es, this message translates to:
  /// **'Cambié de planes'**
  String get visitaMotivoPlanes;

  /// No description provided for @visitaMotivoOtraOpcion.
  ///
  /// In es, this message translates to:
  /// **'Encontré otra opción'**
  String get visitaMotivoOtraOpcion;

  /// No description provided for @visitaMotivoOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro motivo'**
  String get visitaMotivoOtro;

  /// No description provided for @visitaCancelada.
  ///
  /// In es, this message translates to:
  /// **'Cancelaste el servicio'**
  String get visitaCancelada;

  /// No description provided for @visitaCanceladaTardia.
  ///
  /// In es, this message translates to:
  /// **'Cancelaste el servicio. Quedó como cancelación tardía.'**
  String get visitaCanceladaTardia;

  /// No description provided for @visitaYaCerrada.
  ///
  /// In es, this message translates to:
  /// **'Esta visita ya terminó o ya estaba cancelada.'**
  String get visitaYaCerrada;

  /// No description provided for @visitaReprogramarEnviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar cambio'**
  String get visitaReprogramarEnviar;

  /// No description provided for @visitaReprogramarExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Elige otro día y hora. La otra parte tiene que confirmarlo; mientras tanto la cita actual sigue en pie.'**
  String get visitaReprogramarExplicacion;

  /// No description provided for @visitaDia.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get visitaDia;

  /// No description provided for @visitaHora.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get visitaHora;

  /// No description provided for @visitaFechaMuyCercana.
  ///
  /// In es, this message translates to:
  /// **'Elige una hora con al menos 2 horas de anticipación.'**
  String get visitaFechaMuyCercana;

  /// No description provided for @visitaReprogramacionEnviada.
  ///
  /// In es, this message translates to:
  /// **'Enviaste el cambio de fecha. Falta que lo confirmen.'**
  String get visitaReprogramacionEnviada;

  /// No description provided for @visitaNoReprogramable.
  ///
  /// In es, this message translates to:
  /// **'Esta cita ya no se puede reprogramar: ya empezó o terminó, hay un cambio pendiente o ya se cambió dos veces.'**
  String get visitaNoReprogramable;

  /// No description provided for @visitaNoTerminadoBoton.
  ///
  /// In es, this message translates to:
  /// **'No se terminó el trabajo'**
  String get visitaNoTerminadoBoton;

  /// No description provided for @visitaNoTerminadoTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿No se terminó el trabajo?'**
  String get visitaNoTerminadoTitulo;

  /// No description provided for @visitaNoTerminadoCampo.
  ///
  /// In es, this message translates to:
  /// **'¿Qué quedó pendiente?'**
  String get visitaNoTerminadoCampo;

  /// No description provided for @visitaNoTerminadoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Escribe al menos 8 caracteres. Puedes reportarlo una sola vez, hasta 7 días después.'**
  String get visitaNoTerminadoAyuda;

  /// No description provided for @visitaNoTerminadoEnviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar reporte'**
  String get visitaNoTerminadoEnviar;

  /// No description provided for @visitaNoTerminadoEnviado.
  ///
  /// In es, this message translates to:
  /// **'Enviaste tu reporte. Pasa a revisión.'**
  String get visitaNoTerminadoEnviado;

  /// No description provided for @visitaReporteCerrado.
  ///
  /// In es, this message translates to:
  /// **'Ya no se puede reportar: pasaron más de 7 días o ya lo reportaste.'**
  String get visitaReporteCerrado;

  /// No description provided for @visitaEnviando.
  ///
  /// In es, this message translates to:
  /// **'Enviando…'**
  String get visitaEnviando;

  /// Texto de la app: cotizacionFinalTitulo
  ///
  /// In es, this message translates to:
  /// **'Cotización final'**
  String get cotizacionFinalTitulo;

  /// Texto de la app: cotizacionFinalExplicacion
  ///
  /// In es, this message translates to:
  /// **'Si la apruebas, el trabajo sigue con este precio. Si la rechazas, pagas solo la visita.'**
  String get cotizacionFinalExplicacion;

  /// Texto de la app: cotizacionFinalAprobada
  ///
  /// In es, this message translates to:
  /// **'Aprobaste la cotización final.'**
  String get cotizacionFinalAprobada;

  /// Texto de la app: cotizacionFinalRechazada
  ///
  /// In es, this message translates to:
  /// **'Rechazaste la cotización final: pagas solo la visita.'**
  String get cotizacionFinalRechazada;

  /// Texto de la app: cotizacionFinalVencida
  ///
  /// In es, this message translates to:
  /// **'La cotización final venció sin respuesta.'**
  String get cotizacionFinalVencida;

  /// Texto de la app: cotizacionFinalYaDecidida
  ///
  /// In es, this message translates to:
  /// **'Esta cotización final ya se decidió o venció.'**
  String get cotizacionFinalYaDecidida;

  /// Texto de la app: cotizacionAjusteTitulo
  ///
  /// In es, this message translates to:
  /// **'Cambio de precio por aprobar'**
  String get cotizacionAjusteTitulo;

  /// Texto de la app: cotizacionAjusteExplicacion
  ///
  /// In es, this message translates to:
  /// **'Si lo rechazas, el precio se queda en el tope que ya aprobaste.'**
  String get cotizacionAjusteExplicacion;

  /// Texto de la app: cotizacionAjusteAprobado
  ///
  /// In es, this message translates to:
  /// **'Aprobaste el nuevo precio.'**
  String get cotizacionAjusteAprobado;

  /// Texto de la app: cotizacionAjusteRechazado
  ///
  /// In es, this message translates to:
  /// **'Rechazaste el cambio de precio.'**
  String get cotizacionAjusteRechazado;

  /// Texto de la app: cotizacionAjusteYaDecidido
  ///
  /// In es, this message translates to:
  /// **'Este cambio de precio ya se decidió o venció.'**
  String get cotizacionAjusteYaDecidido;

  /// Texto de la app: cotizacionRespondeAntes
  ///
  /// In es, this message translates to:
  /// **'Responde antes del {fecha}'**
  String cotizacionRespondeAntes(String fecha);

  /// Texto de la app: cotizacionAprobar
  ///
  /// In es, this message translates to:
  /// **'Aprobar'**
  String get cotizacionAprobar;

  /// Texto de la app: cotizacionRechazar
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get cotizacionRechazar;

  /// Texto de la app: cotizacionActualizar
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get cotizacionActualizar;

  /// Texto de la app: cotizacionCargandoPrecio
  ///
  /// In es, this message translates to:
  /// **'Revisando si hay un precio por aprobar…'**
  String get cotizacionCargandoPrecio;

  /// No description provided for @cotizacionFinalNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'La cotización final no está disponible.'**
  String get cotizacionFinalNoDisponible;

  /// No description provided for @cotizacionSinAjustes.
  ///
  /// In es, this message translates to:
  /// **'No hay cambios de precio pendientes.'**
  String get cotizacionSinAjustes;

  /// No description provided for @serviciosPrecioDesde.
  ///
  /// In es, this message translates to:
  /// **'Desde \${precio}'**
  String serviciosPrecioDesde(int precio);

  /// No description provided for @serviciosSinPerfil.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes perfil de técnico.'**
  String get serviciosSinPerfil;

  /// No description provided for @serviciosNoExiste.
  ///
  /// In es, this message translates to:
  /// **'Ese servicio ya no existe.'**
  String get serviciosNoExiste;

  /// No description provided for @serviciosLimite.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes el máximo de 50 servicios. Quita uno para agregar otro.'**
  String get serviciosLimite;

  /// No description provided for @serviciosOficioNoValido.
  ///
  /// In es, this message translates to:
  /// **'Ese oficio no es uno de los tuyos.'**
  String get serviciosOficioNoValido;

  /// No description provided for @serviciosOficioMecanica.
  ///
  /// In es, this message translates to:
  /// **'Mecánica'**
  String get serviciosOficioMecanica;

  /// No description provided for @serviciosOficioPlomeria.
  ///
  /// In es, this message translates to:
  /// **'Plomería'**
  String get serviciosOficioPlomeria;

  /// No description provided for @serviciosOficioElectricidad.
  ///
  /// In es, this message translates to:
  /// **'Electricidad'**
  String get serviciosOficioElectricidad;

  /// No description provided for @serviciosTituloPropio.
  ///
  /// In es, this message translates to:
  /// **'Servicios y precio de referencia'**
  String get serviciosTituloPropio;

  /// No description provided for @serviciosCrearPerfil.
  ///
  /// In es, this message translates to:
  /// **'Crear mi perfil de técnico'**
  String get serviciosCrearPerfil;

  /// No description provided for @serviciosCargandoPropios.
  ///
  /// In es, this message translates to:
  /// **'Cargando tus servicios…'**
  String get serviciosCargandoPropios;

  /// No description provided for @serviciosErrorPropios.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus servicios.'**
  String get serviciosErrorPropios;

  /// No description provided for @serviciosReintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get serviciosReintentar;

  /// No description provided for @serviciosListaParcial.
  ///
  /// In es, this message translates to:
  /// **'Por ahora no podemos consultar los servicios que ya tienes guardados. Aquí ves los cambios que hagas ahora.'**
  String get serviciosListaParcial;

  /// No description provided for @serviciosVacioPropios.
  ///
  /// In es, this message translates to:
  /// **'Aún no agregas servicios.'**
  String get serviciosVacioPropios;

  /// No description provided for @serviciosEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get serviciosEditar;

  /// No description provided for @serviciosQuitar.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get serviciosQuitar;

  /// No description provided for @serviciosAgregar.
  ///
  /// In es, this message translates to:
  /// **'Agregar servicio'**
  String get serviciosAgregar;

  /// No description provided for @serviciosErrorNombre.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre del servicio'**
  String get serviciosErrorNombre;

  /// No description provided for @serviciosErrorNombreMax.
  ///
  /// In es, this message translates to:
  /// **'El nombre admite hasta {maximo} caracteres'**
  String serviciosErrorNombreMax(int maximo);

  /// No description provided for @serviciosErrorDetalleMax.
  ///
  /// In es, this message translates to:
  /// **'El detalle admite hasta {maximo} caracteres'**
  String serviciosErrorDetalleMax(int maximo);

  /// No description provided for @serviciosErrorPrecio.
  ///
  /// In es, this message translates to:
  /// **'Escribe un precio en pesos, sin decimales y mayor que cero'**
  String get serviciosErrorPrecio;

  /// No description provided for @serviciosErrorOficio.
  ///
  /// In es, this message translates to:
  /// **'Elige el oficio'**
  String get serviciosErrorOficio;

  /// No description provided for @serviciosNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre del servicio'**
  String get serviciosNombre;

  /// No description provided for @serviciosNombreEjemplo.
  ///
  /// In es, this message translates to:
  /// **'Ej. Cambio de llave'**
  String get serviciosNombreEjemplo;

  /// No description provided for @serviciosDetalle.
  ///
  /// In es, this message translates to:
  /// **'Detalle'**
  String get serviciosDetalle;

  /// No description provided for @serviciosPrecio.
  ///
  /// In es, this message translates to:
  /// **'Precio de referencia (pesos)'**
  String get serviciosPrecio;

  /// No description provided for @serviciosOficioPregunta.
  ///
  /// In es, this message translates to:
  /// **'¿De qué oficio es?'**
  String get serviciosOficioPregunta;

  /// No description provided for @serviciosGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar servicio'**
  String get serviciosGuardar;

  /// No description provided for @serviciosCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get serviciosCancelar;

  /// No description provided for @serviciosTituloPublico.
  ///
  /// In es, this message translates to:
  /// **'Servicios y precios'**
  String get serviciosTituloPublico;

  /// No description provided for @serviciosCargandoPublicos.
  ///
  /// In es, this message translates to:
  /// **'Cargando sus servicios…'**
  String get serviciosCargandoPublicos;

  /// No description provided for @serviciosNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Ese técnico ya no está disponible.'**
  String get serviciosNoDisponible;

  /// No description provided for @serviciosErrorPublicos.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar sus servicios.'**
  String get serviciosErrorPublicos;

  /// No description provided for @serviciosCopia.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Es la copia del {fecha} y puede estar desactualizada.'**
  String serviciosCopia(String fecha);

  /// No description provided for @serviciosVacioPublico.
  ///
  /// In es, this message translates to:
  /// **'Todavía no publica servicios.'**
  String get serviciosVacioPublico;

  /// No description provided for @serviciosReferencia.
  ///
  /// In es, this message translates to:
  /// **'Precios de referencia: no son una cotización.'**
  String get serviciosReferencia;

  /// Texto de la app: pedirCargandoOpciones
  ///
  /// In es, this message translates to:
  /// **'Cargando opciones…'**
  String get pedirCargandoOpciones;

  /// Texto de la app: pedirOficioNoDisponible
  ///
  /// In es, this message translates to:
  /// **'Este oficio ya no está disponible. Puedes escribir lo que pasa.'**
  String get pedirOficioNoDisponible;

  /// Texto de la app: pedirSinOpciones
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar las opciones. Puedes escribir lo que pasa.'**
  String get pedirSinOpciones;

  /// Texto de la app: pedirOpcionesVacias
  ///
  /// In es, this message translates to:
  /// **'No hay opciones sugeridas: escribe lo que pasa.'**
  String get pedirOpcionesVacias;

  /// Texto de la app: pedirReintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get pedirReintentar;

  /// Texto de la app: pedirCopiaGuardada
  ///
  /// In es, this message translates to:
  /// **'Sin conexión: opciones guardadas el {fecha}, pueden estar desactualizadas.'**
  String pedirCopiaGuardada(String fecha);

  /// Texto de la app: pedirOficioNuevoFallo
  ///
  /// In es, this message translates to:
  /// **'Tu oficio quedó en tu perfil, pero no pudimos avisar a Knock. {motivo}'**
  String pedirOficioNuevoFallo(String motivo);

  /// Texto de la app: solicitudesAmpliar
  ///
  /// In es, this message translates to:
  /// **'Pedir también a otros'**
  String get solicitudesAmpliar;

  /// Texto de la app: solicitudesAmpliarExplicacion
  ///
  /// In es, this message translates to:
  /// **'Puedes seguir esperando o pedir también a otros expertos cerca.'**
  String get solicitudesAmpliarExplicacion;

  /// Texto de la app: solicitudesAmpliada
  ///
  /// In es, this message translates to:
  /// **'Listo: pedimos cotización a más expertos.'**
  String get solicitudesAmpliada;

  /// Texto de la app: solicitudesNoAmpliable
  ///
  /// In es, this message translates to:
  /// **'Esta solicitud ya no se puede ampliar.'**
  String get solicitudesNoAmpliable;

  /// Texto de la app: solicitudesNoDisponible
  ///
  /// In es, this message translates to:
  /// **'Esta solicitud ya no está disponible.'**
  String get solicitudesNoDisponible;

  /// Texto de la app: cuentaNumeroTitulo
  ///
  /// In es, this message translates to:
  /// **'Cambiar mi número'**
  String get cuentaNumeroTitulo;

  /// Texto de la app: cuentaRecuperarTitulo
  ///
  /// In es, this message translates to:
  /// **'Recuperar mi cuenta'**
  String get cuentaRecuperarTitulo;

  /// Texto de la app: cuentaNumeroExplicacion
  ///
  /// In es, this message translates to:
  /// **'Te mandaremos un código por SMS al número nuevo. Tu cuenta, tus trabajos y tus mensajes se quedan igual.'**
  String get cuentaNumeroExplicacion;

  /// Texto de la app: cuentaRecuperarExplicacion
  ///
  /// In es, this message translates to:
  /// **'Escribe tu número anterior, qué cuenta es y tu número nuevo. Te mandaremos un código al número nuevo.'**
  String get cuentaRecuperarExplicacion;

  /// Texto de la app: cuentaNumeroAnterior
  ///
  /// In es, this message translates to:
  /// **'Tu número anterior (10 dígitos)'**
  String get cuentaNumeroAnterior;

  /// Texto de la app: cuentaNumeroNuevo
  ///
  /// In es, this message translates to:
  /// **'Número nuevo (10 dígitos)'**
  String get cuentaNumeroNuevo;

  /// Texto de la app: cuentaTipoCliente
  ///
  /// In es, this message translates to:
  /// **'Soy cliente'**
  String get cuentaTipoCliente;

  /// Texto de la app: cuentaTipoTecnico
  ///
  /// In es, this message translates to:
  /// **'Soy técnico'**
  String get cuentaTipoTecnico;

  /// Texto de la app: cuentaNumeroCodigo
  ///
  /// In es, this message translates to:
  /// **'Código de 6 números'**
  String get cuentaNumeroCodigo;

  /// Texto de la app: cuentaNumeroEnviarCodigo
  ///
  /// In es, this message translates to:
  /// **'Enviarme el código'**
  String get cuentaNumeroEnviarCodigo;

  /// Texto de la app: cuentaNumeroConfirmar
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get cuentaNumeroConfirmar;

  /// Texto de la app: cuentaNumeroEntendido
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get cuentaNumeroEntendido;

  /// Texto de la app: cuentaNumeroOtro
  ///
  /// In es, this message translates to:
  /// **'Usar otro número'**
  String get cuentaNumeroOtro;

  /// Texto de la app: cuentaNumeroEnUso
  ///
  /// In es, this message translates to:
  /// **'Ese número ya pertenece a otra cuenta.'**
  String get cuentaNumeroEnUso;

  /// Texto de la app: cuentaNumeroCambiado
  ///
  /// In es, this message translates to:
  /// **'Tu número cambió.'**
  String get cuentaNumeroCambiado;

  /// Texto de la app: cuentaRecuperarRecibida
  ///
  /// In es, this message translates to:
  /// **'Recibimos tu solicitud. Una persona del equipo la revisará.'**
  String get cuentaRecuperarRecibida;

  /// Texto de la app: verificacionCargando
  ///
  /// In es, this message translates to:
  /// **'Cargando tu verificación…'**
  String get verificacionCargando;

  /// Texto de la app: verificacionReintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get verificacionReintentar;

  /// Texto de la app: verificacionSinVerificar
  ///
  /// In es, this message translates to:
  /// **'Sin verificar'**
  String get verificacionSinVerificar;

  /// Texto de la app: verificacionSinVerificarDetalle
  ///
  /// In es, this message translates to:
  /// **'La verificación es opcional y le da más confianza a tus clientes.'**
  String get verificacionSinVerificarDetalle;

  /// Texto de la app: verificacionFotosBorradas
  ///
  /// In es, this message translates to:
  /// **'Tus fotos se borraron porque no se revisaron a tiempo. Puedes enviarlas de nuevo.'**
  String get verificacionFotosBorradas;

  /// Texto de la app: verificacionEnRevision
  ///
  /// In es, this message translates to:
  /// **'En revisión'**
  String get verificacionEnRevision;

  /// Texto de la app: verificacionEnRevisionDetalle
  ///
  /// In es, this message translates to:
  /// **'Revisamos en menos de 24 h'**
  String get verificacionEnRevisionDetalle;

  /// Texto de la app: verificacionVerificadoBasico
  ///
  /// In es, this message translates to:
  /// **'Verificado: básica'**
  String get verificacionVerificadoBasico;

  /// Texto de la app: verificacionVerificadoCompleto
  ///
  /// In es, this message translates to:
  /// **'Verificado: completa'**
  String get verificacionVerificadoCompleto;

  /// Texto de la app: verificacionVerificadoDetalle
  ///
  /// In es, this message translates to:
  /// **'Tu perfil muestra la insignia de verificado.'**
  String get verificacionVerificadoDetalle;

  /// Texto de la app: verificacionNoVerificado
  ///
  /// In es, this message translates to:
  /// **'No se pudo verificar'**
  String get verificacionNoVerificado;

  /// Texto de la app: verificacionSinMotivo
  ///
  /// In es, this message translates to:
  /// **'No se indicó el motivo.'**
  String get verificacionSinMotivo;

  /// Texto de la app: verificacionEnviadaEl
  ///
  /// In es, this message translates to:
  /// **'Enviada el {fecha}'**
  String verificacionEnviadaEl(String fecha);

  /// Texto de la app: verificacionEnvioNoDisponible
  ///
  /// In es, this message translates to:
  /// **'Enviar tus fotos desde la app todavía no está disponible.'**
  String get verificacionEnvioNoDisponible;

  /// No description provided for @tecnicosMapaCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando expertos en el mapa…'**
  String get tecnicosMapaCargando;

  /// No description provided for @tecnicosMapaError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar los expertos del mapa.'**
  String get tecnicosMapaError;

  /// No description provided for @tecnicosMapaVacio.
  ///
  /// In es, this message translates to:
  /// **'No hay expertos en esta zona del mapa.'**
  String get tecnicosMapaVacio;

  /// No description provided for @tecnicosOrdenRecomendados.
  ///
  /// In es, this message translates to:
  /// **'Recomendados'**
  String get tecnicosOrdenRecomendados;

  /// No description provided for @tecnicosOrdenCalificacion.
  ///
  /// In es, this message translates to:
  /// **'Mejor calificados'**
  String get tecnicosOrdenCalificacion;

  /// No description provided for @tecnicosOrdenDistancia.
  ///
  /// In es, this message translates to:
  /// **'Más cercanos'**
  String get tecnicosOrdenDistancia;

  /// No description provided for @tecnicosRadio.
  ///
  /// In es, this message translates to:
  /// **'Hasta {km} km'**
  String tecnicosRadio(int km);

  /// No description provided for @tecnicosListadoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Expertos'**
  String get tecnicosListadoTitulo;

  /// Asistente de IA (spec 042): asistenteNoDisponible
  ///
  /// In es, this message translates to:
  /// **'El asistente de IA no está disponible. Puedes seguir sin él.'**
  String get asistenteNoDisponible;

  /// Asistente de IA (spec 042): asistenteEjemplo
  ///
  /// In es, this message translates to:
  /// **'Esto es un ejemplo: no lo generó una IA.'**
  String get asistenteEjemplo;

  /// Asistente de IA (spec 042): asistenteLimite
  ///
  /// In es, this message translates to:
  /// **'Llegaste al límite de uso del asistente. Inténtalo más tarde.'**
  String get asistenteLimite;

  /// Asistente de IA (spec 042): asistenteCargando
  ///
  /// In es, this message translates to:
  /// **'Consultando al asistente…'**
  String get asistenteCargando;

  /// Asistente de IA (spec 042): asistenteReintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get asistenteReintentar;

  /// Asistente de IA (spec 042): asistenteGeneradoPorIa
  ///
  /// In es, this message translates to:
  /// **'Generado por IA. Revísalo antes de usarlo.'**
  String get asistenteGeneradoPorIa;

  /// Asistente de IA (spec 042): asistenteDePlantilla
  ///
  /// In es, this message translates to:
  /// **'Respuesta automática de plantilla: no la generó una IA.'**
  String get asistenteDePlantilla;

  /// Asistente de IA (spec 042): asistenteTitulo
  ///
  /// In es, this message translates to:
  /// **'Asistente Knock'**
  String get asistenteTitulo;

  /// Asistente de IA (spec 042): asistenteEscribe
  ///
  /// In es, this message translates to:
  /// **'¿Qué necesitas arreglar?'**
  String get asistenteEscribe;

  /// Asistente de IA (spec 042): asistenteSinTurno
  ///
  /// In es, this message translates to:
  /// **'Cuéntale tu problema al asistente.'**
  String get asistenteSinTurno;

  /// Asistente de IA (spec 042): asistenteEnviar
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get asistenteEnviar;

  /// Asistente de IA (spec 042): asistentePideFoto
  ///
  /// In es, this message translates to:
  /// **'Agrega una foto al armar tu solicitud.'**
  String get asistentePideFoto;

  /// Asistente de IA (spec 042): asistenteArmarSolicitud
  ///
  /// In es, this message translates to:
  /// **'Revisar y editar mi solicitud'**
  String get asistenteArmarSolicitud;

  /// Asistente de IA (spec 042): asistenteResumenTitulo
  ///
  /// In es, this message translates to:
  /// **'Resumen de la conversación'**
  String get asistenteResumenTitulo;

  /// Asistente de IA (spec 042): asistenteResumenVacio
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay nada que resumir.'**
  String get asistenteResumenVacio;

  /// Asistente de IA (spec 042): asistenteSabe
  ///
  /// In es, this message translates to:
  /// **'Lo que sabes'**
  String get asistenteSabe;

  /// Asistente de IA (spec 042): asistentePorConfirmar
  ///
  /// In es, this message translates to:
  /// **'Por confirmar'**
  String get asistentePorConfirmar;

  /// Asistente de IA (spec 042): asistenteQueLlevar
  ///
  /// In es, this message translates to:
  /// **'Qué llevar'**
  String get asistenteQueLlevar;

  /// Asistente de IA (spec 042): asistenteBorradorTitulo
  ///
  /// In es, this message translates to:
  /// **'Borrador de cotización'**
  String get asistenteBorradorTitulo;

  /// Asistente de IA (spec 042): asistentePrecio
  ///
  /// In es, this message translates to:
  /// **'Precio sugerido (MXN)'**
  String get asistentePrecio;

  /// Asistente de IA (spec 042): asistenteTiempo
  ///
  /// In es, this message translates to:
  /// **'Tiempo estimado'**
  String get asistenteTiempo;

  /// Asistente de IA (spec 042): asistenteDia
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get asistenteDia;

  /// Asistente de IA (spec 042): asistenteNota
  ///
  /// In es, this message translates to:
  /// **'Nota para el cliente'**
  String get asistenteNota;

  /// Asistente de IA (spec 042): asistenteNadaSeEnvia
  ///
  /// In es, this message translates to:
  /// **'Es un borrador: nada se envía desde aquí.'**
  String get asistenteNadaSeEnvia;

  /// Asistente de IA (spec 042): asistenteRangoTitulo
  ///
  /// In es, this message translates to:
  /// **'Rango de precio'**
  String get asistenteRangoTitulo;

  /// Asistente de IA (spec 042): asistenteRangoVacio
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay referencia de precio para este trabajo.'**
  String get asistenteRangoVacio;

  /// Asistente de IA (spec 042): asistenteBitacoraTitulo
  ///
  /// In es, this message translates to:
  /// **'Bitácora del trabajo'**
  String get asistenteBitacoraTitulo;

  /// Asistente de IA (spec 042): asistenteBitacoraVacia
  ///
  /// In es, this message translates to:
  /// **'Aún no guardas bitácora para este trabajo.'**
  String get asistenteBitacoraVacia;

  /// Asistente de IA (spec 042): asistenteUnoPorLinea
  ///
  /// In es, this message translates to:
  /// **'Un elemento por línea, hasta 10 de 200 caracteres.'**
  String get asistenteUnoPorLinea;

  /// Asistente de IA (spec 042): asistenteGuardar
  ///
  /// In es, this message translates to:
  /// **'Guardar en bitácora'**
  String get asistenteGuardar;

  /// Asistente de IA (spec 042): asistenteGuardada
  ///
  /// In es, this message translates to:
  /// **'Bitácora guardada.'**
  String get asistenteGuardada;

  /// Asistente de IA (spec 042): asistenteRango
  ///
  /// In es, this message translates to:
  /// **'De {minimo} a {maximo} MXN'**
  String asistenteRango(String minimo, String maximo);

  /// Asistente de IA (spec 042): asistenteMuestras
  ///
  /// In es, this message translates to:
  /// **'Muestras: {n}. Fuente: {fuente}.'**
  String asistenteMuestras(String n, String fuente);

  /// Asistente de IA (spec 042): asistenteCopia
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Esta es la copia del {fecha}; puede estar desactualizada.'**
  String asistenteCopia(String fecha);

  /// Texto de la app: cotizarSinPerfil
  ///
  /// In es, this message translates to:
  /// **'Necesitas un perfil de técnico para ver esto.'**
  String get cotizarSinPerfil;

  /// Texto de la app: cotizarYaNoSeCotiza
  ///
  /// In es, this message translates to:
  /// **'Esta solicitud ya no admite cotizaciones.'**
  String get cotizarYaNoSeCotiza;

  /// Texto de la app: cotizarYaCotizada
  ///
  /// In es, this message translates to:
  /// **'Ya enviaste una cotización para esta solicitud.'**
  String get cotizarYaCotizada;

  /// Texto de la app: cotizarCupoLleno
  ///
  /// In es, this message translates to:
  /// **'Esta solicitud ya tiene el máximo de cotizaciones.'**
  String get cotizarCupoLleno;

  /// Texto de la app: cotizarTitulo
  ///
  /// In es, this message translates to:
  /// **'Cotizar'**
  String get cotizarTitulo;

  /// No description provided for @trabajoDescartar.
  ///
  /// In es, this message translates to:
  /// **'Descartar'**
  String get trabajoDescartar;

  /// No description provided for @trabajoDescartarTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Descartar esta solicitud?'**
  String get trabajoDescartarTitulo;

  /// No description provided for @trabajoDescartarExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Ya no la verás en tu lista.'**
  String get trabajoDescartarExplicacion;

  /// No description provided for @trabajoConservarSolicitud.
  ///
  /// In es, this message translates to:
  /// **'Conservar solicitud'**
  String get trabajoConservarSolicitud;

  /// No description provided for @trabajoConfirmarDescarte.
  ///
  /// In es, this message translates to:
  /// **'Sí, descartar'**
  String get trabajoConfirmarDescarte;

  /// No description provided for @trabajoNoDescartable.
  ///
  /// In es, this message translates to:
  /// **'Esta solicitud ya no se puede descartar.'**
  String get trabajoNoDescartable;

  /// Texto de la app: cotizarNuevas
  ///
  /// In es, this message translates to:
  /// **'Solicitudes nuevas'**
  String get cotizarNuevas;

  /// Texto de la app: cotizarNuevasVacio
  ///
  /// In es, this message translates to:
  /// **'No tienes solicitudes nuevas.'**
  String get cotizarNuevasVacio;

  /// Texto de la app: cotizarVer
  ///
  /// In es, this message translates to:
  /// **'Ver y cotizar'**
  String get cotizarVer;

  /// Texto de la app: cotizarVerPropia
  ///
  /// In es, this message translates to:
  /// **'Ver mi cotización'**
  String get cotizarVerPropia;

  /// Texto de la app: cotizarEnviadas
  ///
  /// In es, this message translates to:
  /// **'Cotizaciones enviadas'**
  String get cotizarEnviadas;

  /// Texto de la app: cotizarEnviadasVacio
  ///
  /// In es, this message translates to:
  /// **'Todavía no has enviado cotizaciones.'**
  String get cotizarEnviadasVacio;

  /// Texto de la app: cotizarCargando
  ///
  /// In es, this message translates to:
  /// **'Cargando…'**
  String get cotizarCargando;

  /// Texto de la app: cotizarTipoLabel
  ///
  /// In es, this message translates to:
  /// **'Tipo de precio'**
  String get cotizarTipoLabel;

  /// Texto de la app: cotizarPrecio
  ///
  /// In es, this message translates to:
  /// **'Precio en pesos'**
  String get cotizarPrecio;

  /// Texto de la app: cotizarPrecioVisita
  ///
  /// In es, this message translates to:
  /// **'Precio de la visita en pesos'**
  String get cotizarPrecioVisita;

  /// Texto de la app: cotizarPrecioMin
  ///
  /// In es, this message translates to:
  /// **'Mínimo en pesos'**
  String get cotizarPrecioMin;

  /// Texto de la app: cotizarPrecioMax
  ///
  /// In es, this message translates to:
  /// **'Máximo en pesos'**
  String get cotizarPrecioMax;

  /// Texto de la app: cotizarDia
  ///
  /// In es, this message translates to:
  /// **'Día de la visita'**
  String get cotizarDia;

  /// Texto de la app: cotizarHora
  ///
  /// In es, this message translates to:
  /// **'Hora (HH:mm)'**
  String get cotizarHora;

  /// Texto de la app: cotizarPrecioVisitaRango
  ///
  /// In es, this message translates to:
  /// **'De {minimo} a {maximo} pesos.'**
  String cotizarPrecioVisitaRango(int minimo, int maximo);

  /// Texto de la app: cotizarErrorMontoVisita
  ///
  /// In es, this message translates to:
  /// **'Escribe un número entero de {minimo} a {maximo}.'**
  String cotizarErrorMontoVisita(int minimo, int maximo);

  /// Texto de la app: cotizarSinDias
  ///
  /// In es, this message translates to:
  /// **'Ya no quedan días disponibles para esta solicitud.'**
  String get cotizarSinDias;

  /// Texto de la app: cotizarErrorMonto
  ///
  /// In es, this message translates to:
  /// **'Escribe un número entero de 1 a 200 000.'**
  String get cotizarErrorMonto;

  /// Texto de la app: cotizarErrorMaximo
  ///
  /// In es, this message translates to:
  /// **'El máximo debe ser un entero mayor que el mínimo, hasta 200 000.'**
  String get cotizarErrorMaximo;

  /// Texto de la app: cotizarErrorDia
  ///
  /// In es, this message translates to:
  /// **'Elige un día.'**
  String get cotizarErrorDia;

  /// Texto de la app: cotizarErrorHora
  ///
  /// In es, this message translates to:
  /// **'Escribe la hora como 09:30.'**
  String get cotizarErrorHora;

  /// Texto de la app: cotizarEnviar
  ///
  /// In es, this message translates to:
  /// **'Enviar cotización'**
  String get cotizarEnviar;

  /// Texto de la app: cotizarEnviada
  ///
  /// In es, this message translates to:
  /// **'Cotización enviada'**
  String get cotizarEnviada;

  /// Texto de la app: cotizarRequiereAprobacion
  ///
  /// In es, this message translates to:
  /// **'El cliente tendrá que aprobar el precio final.'**
  String get cotizarRequiereAprobacion;

  /// Texto de la app: cotizarSinAprobacion
  ///
  /// In es, this message translates to:
  /// **'No requiere otra aprobación del cliente.'**
  String get cotizarSinAprobacion;

  /// Texto de la app: cotizarFotoDe
  ///
  /// In es, this message translates to:
  /// **'Foto {numero} de la solicitud'**
  String cotizarFotoDe(int numero);

  /// Texto de la app: cotizarTope
  ///
  /// In es, this message translates to:
  /// **'Tope: \${monto}'**
  String cotizarTope(int monto);

  /// Texto de la app: cotizarMonto
  ///
  /// In es, this message translates to:
  /// **'\${monto}'**
  String cotizarMonto(int monto);

  /// Texto de la app: cotizarRango
  ///
  /// In es, this message translates to:
  /// **'\${min} a \${max}'**
  String cotizarRango(int min, int max);

  /// Texto de la app: cotizarCuando
  ///
  /// In es, this message translates to:
  /// **'{dia} · {franja}'**
  String cotizarCuando(String dia, String franja);

  /// Texto de la app: cotizarTipo
  ///
  /// In es, this message translates to:
  /// **'{tipo, select, fijo{Precio fijo} rango{Rango} visita{Por visita} other{{tipo}}}'**
  String cotizarTipo(String tipo);

  /// Texto de la app: cotizarFranja
  ///
  /// In es, this message translates to:
  /// **'{franja, select, manana{Mañana} tarde{Tarde} noche{Noche} other{{franja}}}'**
  String cotizarFranja(String franja);

  /// Texto de la app: cotizarEstado
  ///
  /// In es, this message translates to:
  /// **'{estado, select, enviada{Esperando respuesta} aceptada{Aceptada} rechazada{Rechazada} retirada{Retirada} other{{estado}}}'**
  String cotizarEstado(String estado);

  /// No description provided for @precioFinalBoton.
  ///
  /// In es, this message translates to:
  /// **'Enviar cotización final'**
  String get precioFinalBoton;

  /// No description provided for @precioAjusteBoton.
  ///
  /// In es, this message translates to:
  /// **'Proponer otro precio'**
  String get precioAjusteBoton;

  /// No description provided for @precioFinalExplicacion.
  ///
  /// In es, this message translates to:
  /// **'Solo aplica a las visitas de diagnóstico. El cliente la aprueba o la rechaza.'**
  String get precioFinalExplicacion;

  /// No description provided for @precioFinalMonto.
  ///
  /// In es, this message translates to:
  /// **'Precio final en pesos'**
  String get precioFinalMonto;

  /// No description provided for @precioFinalDescripcion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué incluye?'**
  String get precioFinalDescripcion;

  /// No description provided for @precioDescripcionAyuda.
  ///
  /// In es, this message translates to:
  /// **'De 8 a 500 caracteres.'**
  String get precioDescripcionAyuda;

  /// No description provided for @precioMontoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Pesos sin centavos, mayor que cero.'**
  String get precioMontoAyuda;

  /// No description provided for @precioFinalEnviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar al cliente'**
  String get precioFinalEnviar;

  /// No description provided for @precioFinalEnviada.
  ///
  /// In es, this message translates to:
  /// **'Enviamos tu cotización final. Falta que el cliente la apruebe.'**
  String get precioFinalEnviada;

  /// No description provided for @precioFinalNoPermitida.
  ///
  /// In es, this message translates to:
  /// **'Ahora no se puede enviar: solo una vez, con la visita de diagnóstico en curso.'**
  String get precioFinalNoPermitida;

  /// No description provided for @precioAjusteCargando.
  ///
  /// In es, this message translates to:
  /// **'Buscando tu cotización aceptada…'**
  String get precioAjusteCargando;

  /// No description provided for @precioAjusteSinCotizacion.
  ///
  /// In es, this message translates to:
  /// **'No encontramos la cotización aceptada de esta visita.'**
  String get precioAjusteSinCotizacion;

  /// No description provided for @precioAjusteMonto.
  ///
  /// In es, this message translates to:
  /// **'Nuevo precio total en pesos'**
  String get precioAjusteMonto;

  /// No description provided for @precioAjusteMinimo.
  ///
  /// In es, this message translates to:
  /// **'Mínimo {monto} pesos.'**
  String precioAjusteMinimo(int monto);

  /// No description provided for @precioAjusteMotivo.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué cambia el precio?'**
  String get precioAjusteMotivo;

  /// No description provided for @precioAjusteMotivoAyuda.
  ///
  /// In es, this message translates to:
  /// **'De 10 a 300 caracteres.'**
  String get precioAjusteMotivoAyuda;

  /// No description provided for @precioAjusteEnviar.
  ///
  /// In es, this message translates to:
  /// **'Proponer al cliente'**
  String get precioAjusteEnviar;

  /// No description provided for @precioAjusteEnviado.
  ///
  /// In es, this message translates to:
  /// **'Enviamos tu propuesta. Falta que el cliente la apruebe.'**
  String get precioAjusteEnviado;

  /// No description provided for @precioAjusteMotivoRechazado.
  ///
  /// In es, this message translates to:
  /// **'El motivo no se pudo publicar. Revísalo y quita datos personales o palabras ofensivas.'**
  String get precioAjusteMotivoRechazado;

  /// No description provided for @precioAjusteSinRevision.
  ///
  /// In es, this message translates to:
  /// **'No pudimos revisar el motivo en este momento. Intenta de nuevo en unos minutos.'**
  String get precioAjusteSinRevision;

  /// No description provided for @precioAjusteNoPermitido.
  ///
  /// In es, this message translates to:
  /// **'Ahora no se puede proponer: la visita debe estar en curso y sin otro cambio pendiente.'**
  String get precioAjusteNoPermitido;

  /// No description provided for @visitaPermisoFotosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Fotos del trabajo'**
  String get visitaPermisoFotosTitulo;

  /// No description provided for @visitaPermisoFotosCasilla.
  ///
  /// In es, this message translates to:
  /// **'Permitir que estas fotos se muestren en el perfil del técnico y en Explorar'**
  String get visitaPermisoFotosCasilla;

  /// No description provided for @visitaPermisoFotosDetalle.
  ///
  /// In es, this message translates to:
  /// **'Es opcional. Solo se muestran con tu permiso y después de una revisión de contenido. Puedes cambiar tu respuesta.'**
  String get visitaPermisoFotosDetalle;

  /// No description provided for @visitaPermisoFotosGuardado.
  ///
  /// In es, this message translates to:
  /// **'Guardamos tu respuesta.'**
  String get visitaPermisoFotosGuardado;

  /// No description provided for @visitaPermisoFotosCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando tu respuesta…'**
  String get visitaPermisoFotosCargando;

  /// Texto de la app: suspensionApelar
  ///
  /// In es, this message translates to:
  /// **'Apelar la suspensión'**
  String get suspensionApelar;

  /// Texto de la app: suspensionTitulo
  ///
  /// In es, this message translates to:
  /// **'Tu apelación'**
  String get suspensionTitulo;

  /// Texto de la app: suspensionDetalle
  ///
  /// In es, this message translates to:
  /// **'Verifica tu número con un código por SMS. Esto no inicia sesión.'**
  String get suspensionDetalle;

  /// Texto de la app: suspensionEnviarCodigo
  ///
  /// In es, this message translates to:
  /// **'Enviarme el código'**
  String get suspensionEnviarCodigo;

  /// Texto de la app: suspensionVerificar
  ///
  /// In es, this message translates to:
  /// **'Verificar'**
  String get suspensionVerificar;

  /// Texto de la app: suspensionSinConsulta
  ///
  /// In es, this message translates to:
  /// **'No hay una apelación disponible para consultar. Si quieres apelar, escribe tus motivos.'**
  String get suspensionSinConsulta;

  /// Texto de la app: suspensionTexto
  ///
  /// In es, this message translates to:
  /// **'Tus motivos'**
  String get suspensionTexto;

  /// Texto de la app: suspensionTextoAyuda
  ///
  /// In es, this message translates to:
  /// **'Escribe entre 8 y 500 caracteres.'**
  String get suspensionTextoAyuda;

  /// Texto de la app: suspensionPresentar
  ///
  /// In es, this message translates to:
  /// **'Enviar apelación'**
  String get suspensionPresentar;

  /// Texto de la app: suspensionNoDisponible
  ///
  /// In es, this message translates to:
  /// **'No hay una apelación disponible.'**
  String get suspensionNoDisponible;

  /// Texto de la app: suspensionNoPermitida
  ///
  /// In es, this message translates to:
  /// **'No se puede presentar otra apelación.'**
  String get suspensionNoPermitida;

  /// Texto de la app: suspensionVerificarOtraVez
  ///
  /// In es, this message translates to:
  /// **'Verifica tu número otra vez con un código por SMS.'**
  String get suspensionVerificarOtraVez;

  /// Texto de la app: suspensionVolver
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get suspensionVolver;

  /// Texto de la app: suspensionEstado
  ///
  /// In es, this message translates to:
  /// **'{estado, select, pendiente{Tu apelación está en revisión.} aceptada{Tu apelación fue aceptada.} rechazada{Tu apelación fue rechazada.} other{Estado de tu apelación: {estado}}}'**
  String suspensionEstado(String estado);

  /// Texto de la app: suspensionPresentadaEl
  ///
  /// In es, this message translates to:
  /// **'Presentada el {fecha}'**
  String suspensionPresentadaEl(String fecha);

  /// Texto de la app: suspensionResueltaEl
  ///
  /// In es, this message translates to:
  /// **'Resuelta el {fecha}'**
  String suspensionResueltaEl(String fecha);

  /// No description provided for @cotizarReferenciaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Referencia de mercado'**
  String get cotizarReferenciaTitulo;

  /// No description provided for @cotizarReferenciaRango.
  ///
  /// In es, this message translates to:
  /// **'Otros técnicos cobran de \${p25} a \${p75}. Lo más común: \${mediana}.'**
  String cotizarReferenciaRango(int p25, int p75, int mediana);

  /// No description provided for @cotizarReferenciaCategoria.
  ///
  /// In es, this message translates to:
  /// **'Referencia general del oficio.'**
  String get cotizarReferenciaCategoria;

  /// No description provided for @cotizarReferenciaSinDatos.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay suficientes datos para darte una referencia.'**
  String get cotizarReferenciaSinDatos;

  /// No description provided for @cotizarReferenciaUsarRango.
  ///
  /// In es, this message translates to:
  /// **'Usar este rango'**
  String get cotizarReferenciaUsarRango;
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
