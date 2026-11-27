// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tecnicoCargando => 'Cargando…';

  @override
  String get tecnicoReintentar => 'Reintentar';

  @override
  String get tecnicoNoDisponible => 'Ese técnico ya no está disponible.';

  @override
  String tecnicoCopia(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Sin conexión. Es la copia del $fechaString; puede estar desactualizada.';
  }

  @override
  String tecnicoCalificacion(String calificacion) {
    return '★ $calificacion';
  }

  @override
  String tecnicoAnios(int n) {
    return '$n años de experiencia';
  }

  @override
  String get tecnicoAtiendeTaller => 'Atiende en su taller';

  @override
  String get tecnicoAtiendeDomicilio => 'Va a domicilio';

  @override
  String get tecnicoAtiendeAmbos => 'En taller y a domicilio';

  @override
  String tecnicoRadio(int km) {
    return 'hasta $km km';
  }

  @override
  String get tecnicoDisponibleHoy => 'Disponible hoy';

  @override
  String get tecnicoSinColonia =>
      'Elige tu colonia para saber si llega hasta ti.';

  @override
  String tecnicoLlega(String colonia) {
    return 'Sí atiende $colonia';
  }

  @override
  String tecnicoNoLlega(String colonia) {
    return 'No atiende $colonia';
  }

  @override
  String get tecnicoServicios => 'Servicios y precios';

  @override
  String get tecnicoSinServicios => 'Todavía no publica servicios.';

  @override
  String tecnicoDesde(String precio) {
    return 'desde $precio';
  }

  @override
  String get tecnicoPreciosDeReferencia =>
      'Son precios de referencia. El precio final lo acuerdas con el técnico.';

  @override
  String get tecnicoFotos => 'Fotos de sus trabajos';

  @override
  String get tecnicoSinFotos => 'Todavía no hay fotos de sus trabajos.';

  @override
  String get tecnicoFotoEtiqueta => 'Foto de un trabajo terminado';

  @override
  String get tecnicoVerMasFotos => 'Ver más fotos';

  @override
  String get citaExistente => 'Cita existente';

  @override
  String get visitaRecuperacionFallida =>
      'No pudimos recuperar la visita. Consulta tu actividad.';

  @override
  String citaMonto(String monto) {
    return 'Cotización: $monto';
  }

  @override
  String citaTope(String monto) {
    return 'Máximo: $monto';
  }

  @override
  String get appTitle => 'Knock';

  @override
  String get busquedaTitulo => 'Buscar';

  @override
  String get busquedaEtiqueta => '¿Qué necesitas?';

  @override
  String get busquedaPlaceholder => 'Ej.: boiler, frenos, un contacto';

  @override
  String get busquedaMinimo => 'Escribe al menos 2 letras';

  @override
  String busquedaContador(int n) {
    return '$n/80';
  }

  @override
  String get busquedaCargando => 'Buscando…';

  @override
  String get busquedaSugerencias => 'Sugerencias';

  @override
  String get busquedaSoloVerificados => 'Solo verificados';

  @override
  String get busquedaSoloVerificadosActivo => 'Solo verificados, seleccionado';

  @override
  String busquedaBuscamos(String oficio) {
    return 'Buscamos: $oficio';
  }

  @override
  String get busquedaAmbiguo => '¿Cuál de estos buscas?';

  @override
  String get busquedaNoEntendimos => 'No entendimos qué necesitas';

  @override
  String get busquedaElegirCategoria => 'Elige una categoría';

  @override
  String get busquedaSinResultados =>
      'No encontramos expertos con esa búsqueda.';

  @override
  String busquedaSinResultadosOficio(String oficio) {
    return 'Todavía no hay expertos de $oficio en tu colonia';
  }

  @override
  String get busquedaPedirCotizacion => 'Pedir cotización de todos modos';

  @override
  String get busquedaSinZona => 'Elige tu zona para buscar expertos cerca';

  @override
  String get busquedaElegirZona => 'Elegir mi zona';

  @override
  String get busquedaCargarMas => 'Ver más';

  @override
  String get busquedaTope =>
      'Mostramos los primeros 100. Agrega más palabras para afinar.';

  @override
  String busquedaTotal(int n) {
    return '$n resultados';
  }

  @override
  String get busquedaReintentar => 'Reintentar';

  @override
  String get busquedaSinConexion => 'Sin conexión';

  @override
  String get busquedaNoDisponible =>
      'La búsqueda no está disponible en este momento. Intenta de nuevo.';

  @override
  String get busquedaOtrasPalabras => 'Prueba con otras palabras';

  @override
  String busquedaEspera(int segundos) {
    return 'Hiciste muchas búsquedas seguidas. Espera $segundos segundos.';
  }

  @override
  String busquedaCalificacion(String calificacion, int n) {
    return '$calificacion estrellas, $n reseñas';
  }

  @override
  String busquedaDistancia(int km) {
    return 'a unos $km km';
  }

  @override
  String busquedaVerificado(String nivel) {
    return 'Verificado: $nivel';
  }

  @override
  String get busquedaNoAtiende => 'No atiende tu colonia';

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
  String get entradaAvisoNoSeAbrio =>
      'No pudimos abrir el aviso de privacidad. Inténtalo de nuevo más tarde.';

  @override
  String get entradaAvisoAbrirIndicacion => 'Se abre en el navegador';

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

  @override
  String get previaEntrar => 'Entrar';

  @override
  String get previaRegistrarme => 'Registrarme';

  @override
  String get previaBuscadorTitulo => 'Busca un experto cerca de ti';

  @override
  String get previaBuscadorLeyenda => 'Mecánica · Plomería · Electricidad';

  @override
  String get previaInvitacionTitulo => 'Entra para continuar';

  @override
  String get previaInvitacionDetalle =>
      'Para buscar expertos, pedir cotizaciones y ver su contacto necesitas una cuenta.';

  @override
  String get previaAhoraNo => 'Ahora no';

  @override
  String get previaChipsEtiqueta => 'Oficios';

  @override
  String get previaChipTodos => 'Todos';

  @override
  String get previaChipNoSeCual => 'No sé cuál';

  @override
  String get previaCatalogoTitulo => 'Oficios disponibles';

  @override
  String get previaCargando => 'Cargando oficios';

  @override
  String get previaVacioTitulo => 'Todavía no hay oficios disponibles';

  @override
  String get previaErrorTitulo => 'No pudimos cargar los oficios';

  @override
  String get previaSinConexion =>
      'Sin conexión. Se muestra lo último guardado.';

  @override
  String get previaReintentar => 'Reintentar';

  @override
  String get previaModalidadDomicilio => 'A domicilio';

  @override
  String get previaModalidadTaller => 'En taller';

  @override
  String get previaExplorarTitulo => 'Explorar servicios y trabajos';

  @override
  String get previaExplorarDetalle =>
      'Mira los oficios que hay en Knock sin crear una cuenta.';

  @override
  String get previaDatosDeEjemplo => 'Datos de ejemplo';

  @override
  String get previaVerLista => 'Ver lista';

  @override
  String get previaMapaSemantica =>
      'Mapa de ejemplo con expertos. Datos de ejemplo.';

  @override
  String previaExpertosCerca(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad expertos cerca de ti',
      one: '$cantidad experto cerca de ti',
    );
    return '$_temp0';
  }

  @override
  String previaPinSemantica(String nombre) {
    return 'Experto de ejemplo: $nombre. Datos de ejemplo. Toca para entrar.';
  }

  @override
  String previaTarjetaSemantica(String nombre, String oficio) {
    return '$nombre, $oficio. Datos de ejemplo. Toca para entrar.';
  }

  @override
  String get previaYoAqui => 'Tú estás aquí';

  @override
  String get previaMapaAcercar => 'Acercar';

  @override
  String get previaMapaAlejar => 'Alejar';

  @override
  String get previaMapaMiUbicacion => 'Volver a mi ubicación';

  @override
  String get previaVerMapa => 'Ver mapa';

  @override
  String get previaPanelEtiqueta => 'Panel de expertos cerca de ti';

  @override
  String previaDistanciaKm(String km) {
    return 'a $km km';
  }

  @override
  String get actividadPedirCotizacion => 'Pide tu primera cotización';

  @override
  String get solicitudTitulo => 'Pedir cotización';

  @override
  String solicitudPasoDeTotal(int paso, int total) {
    return 'Paso $paso de $total';
  }

  @override
  String get solicitudPaso1 => '¿Qué necesitas?';

  @override
  String get solicitudPaso2 => '¿Qué pasa?';

  @override
  String get solicitudPaso3 => '¿Cuándo y dónde?';

  @override
  String get solicitudModalidadDomicilio => 'Va a tu domicilio';

  @override
  String get solicitudModalidadTaller => 'Llevas tu auto al taller';

  @override
  String get solicitudDescripcion => 'Describe el problema';

  @override
  String get solicitudDescripcionAyuda =>
      'Cuéntale al técnico qué pasa, desde cuándo y qué ya intentaste.';

  @override
  String get solicitudDescripcionCorta => 'Escribe al menos 8 caracteres.';

  @override
  String get solicitudDescripcionLarga => 'Escribe como máximo 500 caracteres.';

  @override
  String solicitudFotos(int cantidad) {
    return 'Fotos ($cantidad de 5)';
  }

  @override
  String get solicitudFotoFalta =>
      'Agrega al menos una foto: le dice al técnico qué llevar';

  @override
  String get solicitudFotoMaximo => 'Ya tienes 5 fotos, el máximo.';

  @override
  String get solicitudFotoTomar => 'Tomar foto';

  @override
  String get solicitudFotoElegir => 'Elegir de la galería';

  @override
  String solicitudFotoEtiqueta(int numero, int total) {
    return 'Foto $numero de $total';
  }

  @override
  String solicitudFotoQuitar(int numero) {
    return 'Quitar foto $numero';
  }

  @override
  String get solicitudFotoNoValida =>
      'Esa foto es muy pesada o no es JPG ni PNG. Elige otra.';

  @override
  String get solicitudDia => 'Día';

  @override
  String get solicitudHoy => 'Hoy';

  @override
  String get solicitudFranja => 'Horario';

  @override
  String get solicitudFranjaManana => 'Mañana';

  @override
  String get solicitudFranjaTarde => 'Tarde';

  @override
  String get solicitudFranjaNoche => 'Noche';

  @override
  String get solicitudFaltaDiaYFranja => 'Elige el día y el horario.';

  @override
  String get solicitudTallerAviso => 'Llevarás tu auto al taller';

  @override
  String get solicitudDireccion => 'Calle y número';

  @override
  String get solicitudDireccionAyuda => 'Solo la verá el técnico que elijas.';

  @override
  String get solicitudDireccionCorta => 'Escribe al menos 8 caracteres.';

  @override
  String get solicitudDireccionLarga => 'Escribe como máximo 200 caracteres.';

  @override
  String get solicitudSinZona =>
      'Elige tu zona en Mi cuenta para poder enviar tu solicitud.';

  @override
  String get solicitudSiguiente => 'Siguiente';

  @override
  String get solicitudAtras => 'Atrás';

  @override
  String get solicitudEnviar => 'Enviar solicitud';

  @override
  String get solicitudEnviando => 'Enviando…';

  @override
  String get solicitudEnviada => 'Solicitud enviada';

  @override
  String get solicitudDescartar => 'Descartar borrador';

  @override
  String solicitudEspera(int segundos) {
    return 'Hiciste muchos intentos. Espera $segundos segundos.';
  }

  @override
  String get solicitudErrorContenidoRechazado =>
      'Tu descripción no se pudo publicar. Revísala y quita datos personales o palabras ofensivas.';

  @override
  String get solicitudErrorModeracion =>
      'No pudimos revisar tu descripción en este momento. Intenta de nuevo en unos minutos.';

  @override
  String get solicitudErrorOpcionNoDisponible =>
      'Ese oficio o esa colonia ya no están disponibles. Elige otra opción.';

  @override
  String get solicitudNoDisponible => 'Esta solicitud ya no está disponible.';

  @override
  String get solicitudDetalleTitulo => 'Tu solicitud';

  @override
  String get solicitudEstadoEnviada => 'Enviada';

  @override
  String get solicitudEstadoCotizando => 'Recibiendo cotizaciones';

  @override
  String get solicitudEstadoCita => 'Cita confirmada';

  @override
  String get solicitudEstadoTerminada => 'Terminada';

  @override
  String get solicitudEstadoCancelada => 'Cancelada';

  @override
  String get solicitudEstadoVencida => 'Vencida';

  @override
  String get solicitudEstadoEnProceso => 'En proceso';

  @override
  String solicitudCuando(String dia, String franja) {
    return '$dia, $franja';
  }

  @override
  String solicitudTotalFotos(int cantidad) {
    String _temp0 = intl.Intl.pluralLogic(
      cantidad,
      locale: localeName,
      other: '$cantidad fotos',
      one: '1 foto',
    );
    return '$_temp0';
  }

  @override
  String get solicitudVolverActividad => 'Volver a Actividad';

  @override
  String solicitudVerCotizaciones(int cantidad) {
    return 'Ver y elegir ($cantidad)';
  }

  @override
  String get cotizacionTitulo => 'Cotizaciones';

  @override
  String get cotizacionOrdenRecomendadas => 'Recomendadas';

  @override
  String get cotizacionOrdenPrecio => 'Menor precio';

  @override
  String get cotizacionOrdenCalificacion => 'Mejor calificadas';

  @override
  String get cotizacionOrdenPronto => 'Más pronto';

  @override
  String cotizacionMostrandoDe(int mostradas, int total) {
    return 'Te mostramos $mostradas de $total';
  }

  @override
  String get cotizacionTiposMixtos =>
      'Las cotizaciones cubren cosas distintas: revisa qué incluye cada una';

  @override
  String cotizacionPrecioFijo(String precio) {
    return '$precio';
  }

  @override
  String cotizacionPrecioRango(String minimo, String maximo) {
    return 'De $minimo a $maximo';
  }

  @override
  String cotizacionPrecioVisita(String precio) {
    return 'Visita: $precio';
  }

  @override
  String cotizacionTope(String tope) {
    return 'Hasta $tope';
  }

  @override
  String get cotizacionRequiereAprobacion =>
      'Si el precio sube, el técnico te pedirá tu aprobación';

  @override
  String get cotizacionEtiquetaVerificado => 'Verificado';

  @override
  String get cotizacionEtiquetaMejorPrecio => 'Mejor precio';

  @override
  String get cotizacionEtiquetaPronto => 'Puede ir más pronto';

  @override
  String get cotizacionSinCalificaciones => 'Sin calificaciones';

  @override
  String cotizacionCalificacion(String calificacion) {
    return '$calificacion de 5';
  }

  @override
  String cotizacionNivelVerificacion(String nivel) {
    return 'Verificación $nivel';
  }

  @override
  String cotizacionCuando(String dia, String hora) {
    return '$dia a las $hora';
  }

  @override
  String get cotizacionMotivoSinCotizaciones =>
      'Todavía no hay cotizaciones. Te avisaremos cuando llegue la primera.';

  @override
  String get cotizacionMotivoVencida =>
      'Esta solicitud venció. Puedes pedir una nueva.';

  @override
  String get cotizacionMotivoCancelada => 'Esta solicitud se canceló.';

  @override
  String get cotizacionYaElegida =>
      'Ya elegiste una cotización para esta solicitud.';

  @override
  String get cotizacionVerMiVisita => 'Ver mi visita';

  @override
  String get cotizacionElegir => 'Elegir';

  @override
  String cotizacionConfirmarTitulo(String tecnico) {
    return '¿Eliges a $tecnico?';
  }

  @override
  String get cotizacionConfirmarAvisoContacto =>
      'Al elegir, verás el teléfono del técnico y él verá la dirección de tu servicio. Las demás cotizaciones se cerrarán.';

  @override
  String get cotizacionConfirmar => 'Confirmar elección';

  @override
  String get cotizacionCancelar => 'Cancelar';

  @override
  String get cotizacionEligiendo => 'Confirmando tu elección…';

  @override
  String get cotizacionCitaConfirmada => 'Cita confirmada';

  @override
  String cotizacionTelefono(String telefono) {
    return 'Teléfono: $telefono';
  }

  @override
  String cotizacionWhatsapp(String whatsapp) {
    return 'WhatsApp: $whatsapp';
  }

  @override
  String get cotizacionSinTelefono =>
      'Este técnico no publicó un teléfono. Podrás escribirle por el chat cuando esté disponible';

  @override
  String cotizacionLugar(String direccion) {
    return 'Lugar: $direccion';
  }

  @override
  String get cotizacionListo => 'Listo';

  @override
  String get cotizacionRetirada =>
      'Esta cotización ya no está disponible. Elige otra.';

  @override
  String get cotizacionErrorEleccion =>
      'No pudimos confirmar tu elección. Intenta de nuevo.';

  @override
  String get visitaTitulo => 'Tu visita';

  @override
  String get visitaVerificado => 'Verificado';

  @override
  String get visitaSinVerificar => 'Sin verificar';

  @override
  String visitaCuando(String dia, String hora) {
    return '$dia a las $hora';
  }

  @override
  String get visitaCodigoTitulo => 'Tu código';

  @override
  String visitaCodigoRegla(String tecnico) {
    return 'Pídele a $tecnico que te diga este código en la puerta. Si no lo sabe, no abras.';
  }

  @override
  String visitaCodigoEtiqueta(String digitos) {
    return 'Código: $digitos';
  }

  @override
  String get visitaOcultarCodigo => 'Ocultar código';

  @override
  String get visitaMostrarCodigo => 'Mostrar código';

  @override
  String get visitaCodigoOculto => 'Código oculto';

  @override
  String get visitaMotivoUsado =>
      'El técnico ya confirmó su llegada con este código.';

  @override
  String get visitaMotivoVencido => 'Este código ya venció.';

  @override
  String get visitaMotivoBloqueada =>
      'Esta visita quedó bloqueada por seguridad. El equipo de Knock la revisará.';

  @override
  String get visitaMotivoNoAplica => 'Esta cita no necesita código.';

  @override
  String get visitaTaller => 'Cita en el taller';

  @override
  String visitaDireccionTaller(String direccion) {
    return 'Dirección: $direccion';
  }

  @override
  String get visitaComoLlegar => 'Cómo llegar';

  @override
  String get visitaSinMapas =>
      'No encontramos una app de mapas. Copia la dirección para buscarla.';

  @override
  String get visitaLlamar => 'Llamar';

  @override
  String get visitaWhatsapp => 'WhatsApp';

  @override
  String visitaNoSePudoAbrir(String numero) {
    return 'No se pudo abrir la app. El número es $numero.';
  }

  @override
  String get visitaAvisar => 'Avisar a alguien de confianza';

  @override
  String get visitaNoDisponible => 'Esta visita ya no está disponible.';

  @override
  String get visitaSinConexion =>
      'Sin conexión. Te mostramos los datos guardados de tu visita.';

  @override
  String get visitaEstadoConfirmada => 'Confirmada';

  @override
  String get visitaEstadoEnCurso => 'En curso';

  @override
  String get visitaEstadoTerminada => 'Terminada';

  @override
  String get visitaEstadoCancelada => 'Cancelada';

  @override
  String get avisoTitulo => 'Avisar a alguien de confianza';

  @override
  String get avisoVistaPrevia => 'Así llegará tu mensaje';

  @override
  String get avisoElige => '¿A quién le avisas?';

  @override
  String get avisoSinContactos =>
      'Agrega a alguien de confianza para avisarle cuando tengas una visita';

  @override
  String get avisoPrivacidad =>
      'Tus contactos se guardan solo en este teléfono';

  @override
  String get avisoAgregarContacto => 'Agregar contacto';

  @override
  String get avisoEditarContacto => 'Editar contacto';

  @override
  String avisoBorrarContacto(String nombre) {
    return 'Borrar a $nombre';
  }

  @override
  String avisoEditarA(String nombre) {
    return 'Editar a $nombre';
  }

  @override
  String get avisoNombre => 'Nombre';

  @override
  String get avisoCelular => 'Celular (10 dígitos)';

  @override
  String get avisoGuardar => 'Guardar';

  @override
  String get avisoCancelar => 'Cancelar';

  @override
  String get avisoErrorNombre => 'Escribe un nombre de 2 a 40 caracteres';

  @override
  String get avisoErrorCelular => 'Escribe los 10 números del celular';

  @override
  String get avisoErrorRepetido => 'Ese celular ya está en tu lista';

  @override
  String get avisoErrorLleno =>
      'Ya tienes 10 contactos. Borra uno para agregar otro.';

  @override
  String get avisoEnviarSms => 'Enviar por SMS';

  @override
  String get avisoEnviarWhatsapp => 'Enviar por WhatsApp';

  @override
  String get avisoCompartir => 'Compartir sin guardar';

  @override
  String get avisoSinApp =>
      'No encontramos una app para enviar. Usa «Compartir».';

  @override
  String get avisoNoPermitido => 'Esta visita ya no permite avisos';

  @override
  String get avisoSinRegistro =>
      'No pudimos registrar el aviso; puedes enviarlo de todos modos';

  @override
  String get avisoSinDatos =>
      'No pudimos preparar el aviso. Intenta de nuevo con conexión.';

  @override
  String get avisoLocalEncabezado => 'Hoy recibo a un técnico de Knock.';

  @override
  String avisoLocalVerificado(String nombre) {
    return 'Se llama $nombre y está verificado por Knock.';
  }

  @override
  String avisoLocalSinVerificar(String nombre) {
    return 'Se llama $nombre; todavía no está verificado.';
  }

  @override
  String avisoLocalCuando(String dia, String hora) {
    return 'Viene el $dia a las $hora.';
  }

  @override
  String get avisoLocalRecomendacion =>
      'Le pediré el código en la puerta antes de abrir.';

  @override
  String get cuentaContactosConfianza => 'Contactos de confianza';

  @override
  String get avisoCerrar => 'Cerrar';

  @override
  String get cuentaDescargarTitulo => 'Descargar mis datos';

  @override
  String get cuentaDescargarNoDisponible =>
      'La descarga de tus datos todavía no está disponible en esta versión.';

  @override
  String get cuentaDescargarCargando => 'Revisando tu archivo…';

  @override
  String get cuentaDescargarSinPedir =>
      'Aún no has pedido tu archivo. Lo preparamos en un máximo de 48 horas.';

  @override
  String get cuentaDescargarEnPreparacion =>
      'Estamos preparando tu archivo. Puede tardar hasta 48 horas.';

  @override
  String cuentaDescargarLista(String fecha) {
    return 'Tu archivo está listo. El enlace vence el $fecha.';
  }

  @override
  String get cuentaDescargarVencida =>
      'Tu archivo anterior venció. Puedes pedirlo otra vez.';

  @override
  String get cuentaDescargarPedir => 'Pedir mi archivo';

  @override
  String get cuentaActualizar => 'Actualizar';

  @override
  String get cuentaDescargarAbrir => 'Descargar';

  @override
  String get cuentaDescargarPedida =>
      'Pedimos tu archivo. Puede tardar hasta 48 horas.';

  @override
  String get cuentaDescargarYaEnCurso => 'Ya estamos preparando tu archivo.';

  @override
  String get cuentaDescargarNoAbrio => 'No pudimos abrir el enlace.';

  @override
  String get cuentaReintentar => 'Reintentar';

  @override
  String get cuentaConsentimientosCargando => 'Cargando tus consentimientos…';

  @override
  String get cuentaConsentimientosVacio =>
      'No hay consentimientos para mostrar.';

  @override
  String get cuentaConsentimientoPromociones => 'Promociones y novedades';

  @override
  String get cuentaConsentimientoPromocionesDetalle =>
      'Ofertas de expertos y noticias de Knock';

  @override
  String get cuentaConsentimientoEncuestas => 'Encuestas para mejorar Knock';

  @override
  String get cuentaConsentimientoEncuestasDetalle =>
      'Preguntas cortas después de un servicio';

  @override
  String get cuentaConsentimientoRecomendaciones =>
      'Recomendaciones personalizadas';

  @override
  String get cuentaConsentimientoRecomendacionesDetalle =>
      'Sugerencias según tu casa y tu auto';

  @override
  String get cuentaConsentimientoAviso => 'Aviso de privacidad';

  @override
  String get cuentaConsentimientoTerminos => 'Términos y condiciones';

  @override
  String get cuentaConsentimientoOtro => 'Otro consentimiento';

  @override
  String get cuentaConsentimientoObligatorio =>
      'Obligatorio: no se puede apagar';

  @override
  String cuentaConsentimientoRegistro(String version, String fecha) {
    return 'Versión $version · $fecha';
  }

  @override
  String get opinionesTitulo => 'Opiniones';

  @override
  String get conversacionesSinConexion => 'Sin conexión';

  @override
  String get conversacionesGlobo => 'Mensajes';

  @override
  String conversacionesGloboConTotal(String total) {
    return 'Mensajes, $total';
  }

  @override
  String get conversacionesCargando => 'Cargando conversaciones…';

  @override
  String get conversacionesVacias =>
      'Aún no tienes conversaciones. El chat se abre al recibir cotizaciones.';

  @override
  String get conversacionesAbrirPendiente =>
      'Abrir conversaciones aún no está disponible.';

  @override
  String conversacionesNoLeidos(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total mensajes sin leer',
      one: '1 mensaje sin leer',
    );
    return '$_temp0';
  }

  @override
  String reputacionNivel(String nivel) {
    return 'Nivel: $nivel';
  }

  @override
  String get reputacionNuevo => 'Nuevo';

  @override
  String get reputacionConfiable => 'Confiable';

  @override
  String get reputacionDestacado => 'Destacado';

  @override
  String get trabajoProximasVisitas => 'Próximas visitas';

  @override
  String get trabajoPendiente =>
      'Los trabajos terminados todavía no se muestran aquí.';

  @override
  String get trabajoVerificacion => 'Mi verificación';

  @override
  String get trabajoReputacion => 'Mi reputación';

  @override
  String get trabajoDisponibleHoy => 'Disponible hoy';

  @override
  String get trabajoDisponibleDetalle =>
      'Enciéndelo si hoy puedes atender solicitudes. Se apaga solo al terminar el día.';

  @override
  String get trabajoDisponibleCargando => 'Cargando tu disponibilidad…';

  @override
  String get visitaAusenteBoton => 'El cliente no estaba';

  @override
  String get visitaAusenteExplicacion =>
      'Se registra que el cliente no estaba. A ti no se te penaliza. Solo se puede dentro de la ventana de la cita.';

  @override
  String get visitaAusenteConfirmar => 'Registrar que no estaba';

  @override
  String get visitaAusenteRegistrada => 'Registramos que el cliente no estaba.';

  @override
  String get visitaAusenteFueraDeVentana =>
      'Ahora no se puede registrar: solo dentro de la ventana de la cita.';

  @override
  String get visitaTecnicoAusenteBoton => 'El técnico no se presentó';

  @override
  String get visitaTecnicoAusenteExplicacion =>
      'Confirma solo si el técnico no llegó. Se puede registrar desde 15 minutos hasta 2 horas después de la hora de la cita.';

  @override
  String get visitaTecnicoAusenteConfirmar => 'Registrar que no llegó';

  @override
  String get visitaTecnicoAusenteRegistrada =>
      'Registraste que el técnico no se presentó.';

  @override
  String get visitaTerminarBoton => 'Terminar servicio';

  @override
  String get visitaTerminarFotos => 'Fotos del trabajo terminado (de 1 a 5)';

  @override
  String get visitaTerminarDescripcion => '¿Qué hiciste?';

  @override
  String get visitaTerminarDescripcionAyuda => 'De 8 a 500 caracteres.';

  @override
  String get visitaTerminarRecomendacion =>
      'Recomendación para el cliente (opcional)';

  @override
  String get visitaTerminarSinSubida =>
      'La subida de fotos todavía no está disponible, así que no puedes terminar el servicio desde la app.';

  @override
  String get visitaTerminarNoEnCurso =>
      'Esta visita no está en curso: no se puede terminar.';

  @override
  String get visitaTerminarHecho => 'Servicio terminado.';

  @override
  String get llegadaTitulo => 'Confirmar llegada';

  @override
  String get llegadaCargando => 'Cargando tu visita…';

  @override
  String get llegadaInstruccion =>
      'Pide en la puerta el código de 4 dígitos y escríbelo aquí.';

  @override
  String get llegadaCodigo => 'Código de 4 dígitos';

  @override
  String get llegadaConfirmar => 'Ya llegué';

  @override
  String get llegadaConfirmando => 'Confirmando…';

  @override
  String get llegadaConfirmada =>
      'Llegada confirmada. La visita está en curso.';

  @override
  String llegadaHora(String hora) {
    return 'Hora de llegada: $hora';
  }

  @override
  String get llegadaIncorrecto =>
      'El código no coincide. Confirma que estás en la dirección correcta.';

  @override
  String llegadaIntentos(int n) {
    return 'Te quedan $n intentos';
  }

  @override
  String get llegadaCuatroDigitos => 'Escribe los 4 dígitos.';

  @override
  String get llegadaBloqueada =>
      'Esta visita quedó bloqueada por seguridad. El equipo de Knock la revisará.';

  @override
  String get llegadaYaUsado => 'Este código ya se usó.';

  @override
  String get llegadaVencido => 'El código de esta visita ya venció.';

  @override
  String get llegadaCancelada => 'Esta visita se canceló.';

  @override
  String get errorFueraDeVentana =>
      'Podrás confirmar la llegada el día de la cita, desde las 00:00.';

  @override
  String get errorVisitaNoVigente => 'Esta visita ya no está vigente.';

  @override
  String get llegadaTaller => 'Esta cita es en el taller y no necesita código.';

  @override
  String get llegadaNoTecnico =>
      'Solo el técnico de la visita puede confirmar la llegada.';

  @override
  String get llegadaNoDisponible => 'Esta visita ya no está disponible.';

  @override
  String get llegadaAunNo => 'Podrás confirmar tu llegada el día de la cita.';

  @override
  String get llegadaReintentoCuenta =>
      'Si el código era incorrecto, este reintento cuenta como intento.';

  @override
  String llegadaEspera(int segundos) {
    return 'Hiciste muchos intentos. Espera $segundos segundos.';
  }

  @override
  String get agendaCargando => 'Cargando tu agenda…';

  @override
  String get agendaError => 'No pudimos cargar tu agenda.';

  @override
  String get agendaVacia => 'No tienes visitas próximas.';

  @override
  String get agendaSinMapa =>
      'La ubicación de las visitas no está disponible en el mapa.';

  @override
  String get agendaVerMas => 'Ver más visitas';

  @override
  String agendaEstado(String estado) {
    String _temp0 = intl.Intl.selectLogic(estado, {
      'confirmada': 'Confirmada',
      'en_curso': 'En curso',
      'terminada': 'Terminada',
      'cancelada': 'Cancelada',
      'no_presentado': 'No se presentó',
      'other': 'Estado no disponible',
    });
    return '$_temp0';
  }

  @override
  String agendaModalidad(String modalidad) {
    String _temp0 = intl.Intl.selectLogic(modalidad, {
      'domicilio': 'A domicilio',
      'taller': 'En taller',
      'other': 'Modalidad no disponible',
    });
    return '$_temp0';
  }

  @override
  String get opinionesCargando => 'Cargando las opiniones…';

  @override
  String get opinionesError => 'No pudimos cargar las opiniones.';

  @override
  String get opinionesNoDisponible => 'Ese técnico ya no está disponible.';

  @override
  String get opinionesReintentar => 'Reintentar';

  @override
  String get opinionesVacio =>
      'Aún sin opiniones. Las primeras llegan después de su primer servicio por Knock.';

  @override
  String opinionesCopia(String fecha) {
    return 'Sin conexión. Es lo que viste el $fecha; puede estar desactualizado.';
  }

  @override
  String opinionesPromedio(String promedio) {
    return '★ $promedio de 5';
  }

  @override
  String opinionesTotal(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total opiniones',
      one: '1 opinión',
    );
    return '$_temp0';
  }

  @override
  String opinionesEstrellas(int estrellas, int total) {
    return '$estrellas estrellas: $total';
  }

  @override
  String get opinionesVerTodas => 'Ver las opiniones';

  @override
  String get opinionesVerMas => 'Ver más';

  @override
  String get opinionesServicioVerificado => 'Servicio verificado';

  @override
  String get opinionesAnonima => 'Usuario eliminado';

  @override
  String opinionesRespuesta(String texto) {
    return 'Respuesta del técnico: $texto';
  }

  @override
  String get opinionesPuntualidad => 'Puntualidad';

  @override
  String get opinionesCalidad => 'Calidad';

  @override
  String get opinionesPrecioJusto => 'Precio justo';

  @override
  String get opinionesTrato => 'Trato';

  @override
  String get opinionesCalificarTitulo => 'Califica el servicio';

  @override
  String get opinionesCalificarPregunta => '¿Cómo te fue?';

  @override
  String get opinionesCalificarBoton => 'Calificar el servicio';

  @override
  String opinionesEstrellaBoton(int estrella) {
    return '$estrella de 5 estrellas';
  }

  @override
  String opinionesParteBoton(String parte, int estrella) {
    return '$parte: $estrella de 5 estrellas';
  }

  @override
  String get opinionesPorPartes => 'Por partes (opcional)';

  @override
  String get opinionesComentario => 'Cuéntale a otros cómo fue';

  @override
  String get opinionesGuardarConfianza =>
      'Guardar en mis técnicos de confianza';

  @override
  String get opinionesPublicar => 'Publicar opinión';

  @override
  String get opinionesPublicando => 'Publicando…';

  @override
  String get opinionesElige => 'Elige cuántas estrellas para continuar';

  @override
  String get opinionesEnviada => 'Recibimos tu opinión. ¡Gracias!';

  @override
  String get opinionesErrorNoPermitida =>
      'Esta visita ya no se puede calificar: ya opinaste o pasaron los 30 días.';

  @override
  String get opinionesErrorYaRespondida => 'Esta opinión ya tiene respuesta.';

  @override
  String get opinionesVisitaNoDisponible => 'Esa visita ya no está disponible.';

  @override
  String get cuentaPendientesCargando => 'Revisando lo que tienes pendiente…';

  @override
  String get cuentaPendientesVacio =>
      'No tienes citas ni cotizaciones abiertas.';

  @override
  String get cuentaPendientesTitulo => 'Lo que tienes pendiente';

  @override
  String cuentaPendientesCitas(int total) {
    return 'Citas abiertas: $total';
  }

  @override
  String cuentaPendientesCotizaciones(int total) {
    return 'Cotizaciones abiertas: $total';
  }

  @override
  String get cuentaPendientesNota =>
      'Al programar la eliminación se cancelan tus solicitudes abiertas y las cotizaciones pendientes, y avisamos a las personas involucradas.';

  @override
  String get cuentaEliminarTitulo => 'Eliminar cuenta';

  @override
  String get cuentaEliminarPregunta =>
      '¿Seguro que quieres eliminar tu cuenta?';

  @override
  String get cuentaEliminarGracia =>
      'Tu cuenta quedará programada para eliminarse en 7 días y puedes cancelarlo antes.';

  @override
  String get cuentaEliminarEscribe => 'Escribe ELIMINAR para confirmar';

  @override
  String get cuentaEliminarVerifica =>
      'Por seguridad, confirma tu celular con un código por SMS.';

  @override
  String get cuentaEliminarCelular => 'Tu celular (10 dígitos)';

  @override
  String get cuentaEliminarEnviarCodigo => 'Enviarme el código';

  @override
  String get cuentaEliminarCodigo => 'Código de 6 dígitos';

  @override
  String get cuentaEliminarVerificacionRechazada =>
      'No pudimos confirmar tu identidad con ese número. Usa el celular de esta cuenta y pide otro código.';

  @override
  String get cuentaEliminarNoPermitida =>
      'No se puede eliminar ahora: ya está programada o tienes una visita en curso.';

  @override
  String get cuentaEliminarEnviando => 'Un momento…';

  @override
  String get cuentaEliminarBoton => 'Eliminar mi cuenta';

  @override
  String get cuentaEliminarMejorNo => 'Mejor no';

  @override
  String get cuentaEliminacionProgramada =>
      'Tu cuenta está programada para eliminarse';

  @override
  String cuentaEliminacionProgramadaEl(String fecha) {
    return 'Tu cuenta se eliminará el $fecha';
  }

  @override
  String get cuentaEliminacionDetalle =>
      'Tienes 7 días para arrepentirte: antes de que termine el plazo puedes cancelar la eliminación.';

  @override
  String get cuentaEliminacionCargando => 'Revisando tu cuenta…';

  @override
  String get cuentaEliminacionNinguna => 'No tienes una eliminación programada';

  @override
  String get cuentaEliminacionCancelar => 'Cancelar la eliminación';

  @override
  String get cuentaEliminacionCancelada =>
      'Cancelaste la eliminación de tu cuenta';

  @override
  String get cuentaEliminacionNadaQueCancelar =>
      'No hay una eliminación programada que cancelar.';

  @override
  String get cuentaEliminacionIrACuenta => 'Ir a Mi cuenta';

  @override
  String get cuentaEliminacionSalir => 'Salir';

  @override
  String get bloqueosMotivoAcoso => 'Acoso';

  @override
  String get bloqueosMotivoFraude => 'Fraude';

  @override
  String get bloqueosMotivoMalServicio => 'Mal servicio';

  @override
  String get bloqueosMotivoComportamiento => 'Comportamiento inapropiado';

  @override
  String get bloqueosMotivoPeligro => 'Peligro';

  @override
  String get bloqueosMotivoOtro => 'Otra cosa';

  @override
  String get bloqueosTitulo => 'Reportar un problema';

  @override
  String get bloqueosCargando => 'Cargando…';

  @override
  String get bloqueosNoDisponible =>
      'No es posible reportar desde esta visita.';

  @override
  String get bloqueosReintentar => 'Reintentar';

  @override
  String get bloqueosAviso911 => 'Si estás en peligro, llama al 911.';

  @override
  String get bloqueosRecibido => 'Recibimos tu reporte';

  @override
  String get bloqueosVolver => 'Volver';

  @override
  String get bloqueosQuePaso => '¿Qué pasó?';

  @override
  String get bloqueosDescripcion =>
      'Cuéntanos qué pasó (de 8 a 500 caracteres)';

  @override
  String get bloqueosEnviando => 'Enviando…';

  @override
  String get bloqueosEnviar => 'Enviar reporte';

  @override
  String get bloqueosFalta => 'Elige qué pasó y escribe al menos 8 caracteres';

  @override
  String get bloqueosMios => 'Mis reportes';

  @override
  String get bloqueosCargandoLista => 'Cargando tus reportes…';

  @override
  String get bloqueosErrorLista => 'No pudimos cargar tus reportes.';

  @override
  String get bloqueosVacio => 'No has hecho reportes.';

  @override
  String get bloqueosVerMas => 'Ver más';

  @override
  String get bloqueosApelacionEnviada => 'Enviamos tu apelación';

  @override
  String get bloqueosEstadoAbierto => 'En revisión';

  @override
  String get bloqueosEstadoDecidido => 'Decidido';

  @override
  String get bloqueosEstadoEnApelacion => 'En apelación';

  @override
  String get bloqueosEstadoOtro => 'Estado no disponible';

  @override
  String get bloqueosApelar => 'Apelar la decisión';

  @override
  String get bloqueosApelacionTexto =>
      'Explica por qué apelas (de 8 a 500 caracteres)';

  @override
  String get bloqueosEnviarApelacion => 'Enviar apelación';

  @override
  String get bloqueosErrorYaBloqueado => 'Ya habías bloqueado a esta persona.';

  @override
  String get bloqueosErrorApelacion => 'Este reporte ya no se puede apelar.';

  @override
  String get bloqueosPantallaBloquear => 'Bloquear a una persona';

  @override
  String get bloqueosPersonasTitulo => 'Personas bloqueadas';

  @override
  String get bloqueosPersonasCargando => 'Cargando a quién bloqueaste…';

  @override
  String get bloqueosPersonasError => 'No pudimos cargar tus bloqueos.';

  @override
  String get bloqueosPersonasVacio => 'No has bloqueado a nadie.';

  @override
  String get bloqueosBloqueadaEl => 'Bloqueada el';

  @override
  String get bloqueosDesbloquear => 'Desbloquear';

  @override
  String get bloqueosDesbloqueando => 'Desbloqueando…';

  @override
  String get bloqueosDesbloqueada => 'Desbloqueaste a esta persona.';

  @override
  String get bloqueosBloquear => 'Bloquear a esta persona';

  @override
  String get bloqueosBloqueando => 'Bloqueando…';

  @override
  String get bloqueosBloqueada => 'Bloqueaste a esta persona.';

  @override
  String get bloqueosBloquearAviso =>
      'Ya no podrá escribirte ni verte en las búsquedas.';

  @override
  String get bloqueosConfirmarBloqueoTitulo => '¿Bloquear a esta persona?';

  @override
  String get bloqueosConfirmarBloqueo => 'Sí, bloquear';

  @override
  String get bloqueosCancelar => 'Cancelar';

  @override
  String get bloqueosDeshacer => 'Deshacer';

  @override
  String get bloqueosNoEncontrada => 'Esa persona ya no está disponible.';

  @override
  String get bloqueosErrorYaNoBloqueada =>
      'Esa persona ya no estaba bloqueada.';

  @override
  String get bloqueosErrorNoBloquearse => 'No puedes bloquearte a ti mismo.';

  @override
  String get direccionesTitulo => 'Mis direcciones';

  @override
  String get direccionesCargando => 'Cargando tus direcciones…';

  @override
  String get direccionesError => 'No pudimos cargar tus direcciones.';

  @override
  String get direccionesReintentar => 'Reintentar';

  @override
  String get direccionesVacio => 'Aún no tienes direcciones guardadas.';

  @override
  String get direccionesAgregar => 'Agregar dirección';

  @override
  String get direccionesEditar => 'Editar';

  @override
  String get direccionesEliminar => 'Eliminar';

  @override
  String get direccionesPrincipal => 'Principal';

  @override
  String get direccionesSinReferencias => 'Sin referencias';

  @override
  String get direccionesNueva => 'Nueva dirección';

  @override
  String get direccionesEditarTitulo => 'Editar dirección';

  @override
  String get direccionesCalle => 'Calle y número';

  @override
  String get direccionesReferencias => 'Referencias (opcional)';

  @override
  String direccionesColonia(String colonia) {
    return 'Colonia: $colonia';
  }

  @override
  String direccionesCambiarColonia(String colonia) {
    return 'Usar mi colonia actual: $colonia';
  }

  @override
  String get direccionesMarcarPrincipal => 'Usar como principal';

  @override
  String get direccionesGuardar => 'Guardar dirección';

  @override
  String get direccionesGuardando => 'Guardando…';

  @override
  String get direccionesCancelar => 'Cancelar';

  @override
  String get direccionesConfirmarEliminar => '¿Eliminar esta dirección?';

  @override
  String get direccionesNoDisponible => 'Esa dirección ya no está disponible.';

  @override
  String get visitaReprogramar => 'Reprogramar la cita';

  @override
  String get visitaCancelar => 'Cancelar el servicio';

  @override
  String get visitaCambioPendiente =>
      'Hay un cambio de fecha esperando respuesta. Mientras tanto, la cita actual sigue en pie.';

  @override
  String get visitaCancelarTitulo => '¿Cancelar el servicio?';

  @override
  String get visitaCancelarConfirmar => 'Sí, cancelar';

  @override
  String get visitaCancelarAviso =>
      'Con más de 24 h de anticipación es sin costo. Con menos, queda como cancelación tardía y avisamos de inmediato.';

  @override
  String get visitaCancelarMotivo => '¿Por qué cancelas?';

  @override
  String get visitaMotivoResuelto => 'Ya lo resolví';

  @override
  String get visitaMotivoPlanes => 'Cambié de planes';

  @override
  String get visitaMotivoOtraOpcion => 'Encontré otra opción';

  @override
  String get visitaMotivoOtro => 'Otro motivo';

  @override
  String get visitaCancelada => 'Cancelaste el servicio';

  @override
  String get visitaCanceladaTardia =>
      'Cancelaste el servicio. Quedó como cancelación tardía.';

  @override
  String get visitaYaCerrada => 'Esta visita ya terminó o ya estaba cancelada.';

  @override
  String get visitaReprogramarEnviar => 'Enviar cambio';

  @override
  String get visitaReprogramarExplicacion =>
      'Elige otro día y hora. La otra parte tiene que confirmarlo; mientras tanto la cita actual sigue en pie.';

  @override
  String get visitaDia => 'Día';

  @override
  String get visitaHora => 'Hora';

  @override
  String get visitaFechaMuyCercana =>
      'Elige una hora con al menos 2 horas de anticipación.';

  @override
  String get visitaReprogramacionEnviada =>
      'Enviaste el cambio de fecha. Falta que lo confirmen.';

  @override
  String get visitaNoReprogramable =>
      'Esta cita ya no se puede reprogramar: ya empezó o terminó, hay un cambio pendiente o ya se cambió dos veces.';

  @override
  String get visitaNoTerminadoBoton => 'No se terminó el trabajo';

  @override
  String get visitaNoTerminadoTitulo => '¿No se terminó el trabajo?';

  @override
  String get visitaNoTerminadoCampo => '¿Qué quedó pendiente?';

  @override
  String get visitaNoTerminadoAyuda =>
      'Escribe al menos 8 caracteres. Puedes reportarlo una sola vez, hasta 7 días después.';

  @override
  String get visitaNoTerminadoEnviar => 'Enviar reporte';

  @override
  String get visitaNoTerminadoEnviado =>
      'Enviaste tu reporte. Pasa a revisión.';

  @override
  String get visitaReporteCerrado =>
      'Ya no se puede reportar: pasaron más de 7 días o ya lo reportaste.';

  @override
  String get visitaEnviando => 'Enviando…';

  @override
  String get cotizacionFinalTitulo => 'Cotización final';

  @override
  String get cotizacionFinalExplicacion =>
      'Si la apruebas, el trabajo sigue con este precio. Si la rechazas, pagas solo la visita.';

  @override
  String get cotizacionFinalAprobada => 'Aprobaste la cotización final.';

  @override
  String get cotizacionFinalRechazada =>
      'Rechazaste la cotización final: pagas solo la visita.';

  @override
  String get cotizacionFinalVencida =>
      'La cotización final venció sin respuesta.';

  @override
  String get cotizacionFinalYaDecidida =>
      'Esta cotización final ya se decidió o venció.';

  @override
  String get cotizacionAjusteTitulo => 'Cambio de precio por aprobar';

  @override
  String get cotizacionAjusteExplicacion =>
      'Si lo rechazas, el precio se queda en el tope que ya aprobaste.';

  @override
  String get cotizacionAjusteAprobado => 'Aprobaste el nuevo precio.';

  @override
  String get cotizacionAjusteRechazado => 'Rechazaste el cambio de precio.';

  @override
  String get cotizacionAjusteYaDecidido =>
      'Este cambio de precio ya se decidió o venció.';

  @override
  String cotizacionRespondeAntes(String fecha) {
    return 'Responde antes del $fecha';
  }

  @override
  String get cotizacionAprobar => 'Aprobar';

  @override
  String get cotizacionRechazar => 'Rechazar';

  @override
  String get cotizacionActualizar => 'Actualizar';

  @override
  String get cotizacionCargandoPrecio =>
      'Revisando si hay un precio por aprobar…';

  @override
  String get cotizacionFinalNoDisponible =>
      'La cotización final no está disponible.';

  @override
  String get cotizacionSinAjustes => 'No hay cambios de precio pendientes.';

  @override
  String serviciosPrecioDesde(int precio) {
    return 'Desde \$$precio';
  }

  @override
  String get serviciosSinPerfil => 'Todavía no tienes perfil de técnico.';

  @override
  String get serviciosNoExiste => 'Ese servicio ya no existe.';

  @override
  String get serviciosLimite =>
      'Ya tienes el máximo de 50 servicios. Quita uno para agregar otro.';

  @override
  String get serviciosOficioNoValido => 'Ese oficio no es uno de los tuyos.';

  @override
  String get serviciosOficioMecanica => 'Mecánica';

  @override
  String get serviciosOficioPlomeria => 'Plomería';

  @override
  String get serviciosOficioElectricidad => 'Electricidad';

  @override
  String get serviciosTituloPropio => 'Servicios y precio de referencia';

  @override
  String get serviciosCrearPerfil => 'Crear mi perfil de técnico';

  @override
  String get serviciosCargandoPropios => 'Cargando tus servicios…';

  @override
  String get serviciosErrorPropios => 'No pudimos cargar tus servicios.';

  @override
  String get serviciosReintentar => 'Reintentar';

  @override
  String get serviciosListaParcial =>
      'Por ahora no podemos consultar los servicios que ya tienes guardados. Aquí ves los cambios que hagas ahora.';

  @override
  String get serviciosVacioPropios => 'Aún no agregas servicios.';

  @override
  String get serviciosEditar => 'Editar';

  @override
  String get serviciosQuitar => 'Quitar';

  @override
  String get serviciosAgregar => 'Agregar servicio';

  @override
  String get serviciosErrorNombre => 'Escribe el nombre del servicio';

  @override
  String serviciosErrorNombreMax(int maximo) {
    return 'El nombre admite hasta $maximo caracteres';
  }

  @override
  String serviciosErrorDetalleMax(int maximo) {
    return 'El detalle admite hasta $maximo caracteres';
  }

  @override
  String get serviciosErrorPrecio =>
      'Escribe un precio en pesos, sin decimales y mayor que cero';

  @override
  String get serviciosErrorOficio => 'Elige el oficio';

  @override
  String get serviciosNombre => 'Nombre del servicio';

  @override
  String get serviciosNombreEjemplo => 'Ej. Cambio de llave';

  @override
  String get serviciosDetalle => 'Detalle';

  @override
  String get serviciosPrecio => 'Precio de referencia (pesos)';

  @override
  String get serviciosOficioPregunta => '¿De qué oficio es?';

  @override
  String get serviciosGuardar => 'Guardar servicio';

  @override
  String get serviciosCancelar => 'Cancelar';

  @override
  String get serviciosTituloPublico => 'Servicios y precios';

  @override
  String get serviciosCargandoPublicos => 'Cargando sus servicios…';

  @override
  String get serviciosNoDisponible => 'Ese técnico ya no está disponible.';

  @override
  String get serviciosErrorPublicos => 'No pudimos cargar sus servicios.';

  @override
  String serviciosCopia(String fecha) {
    return 'Sin conexión. Es la copia del $fecha y puede estar desactualizada.';
  }

  @override
  String get serviciosVacioPublico => 'Todavía no publica servicios.';

  @override
  String get serviciosReferencia =>
      'Precios de referencia: no son una cotización.';

  @override
  String get pedirCargandoOpciones => 'Cargando opciones…';

  @override
  String get pedirOficioNoDisponible =>
      'Este oficio ya no está disponible. Puedes escribir lo que pasa.';

  @override
  String get pedirSinOpciones =>
      'No pudimos cargar las opciones. Puedes escribir lo que pasa.';

  @override
  String get pedirOpcionesVacias =>
      'No hay opciones sugeridas: escribe lo que pasa.';

  @override
  String get pedirReintentar => 'Reintentar';

  @override
  String pedirCopiaGuardada(String fecha) {
    return 'Sin conexión: opciones guardadas el $fecha, pueden estar desactualizadas.';
  }

  @override
  String pedirOficioNuevoFallo(String motivo) {
    return 'Tu oficio quedó en tu perfil, pero no pudimos avisar a Knock. $motivo';
  }

  @override
  String get solicitudesAmpliar => 'Pedir también a otros';

  @override
  String get solicitudesAmpliarExplicacion =>
      'Puedes seguir esperando o pedir también a otros expertos cerca.';

  @override
  String get solicitudesAmpliada => 'Listo: pedimos cotización a más expertos.';

  @override
  String get solicitudesNoAmpliable => 'Esta solicitud ya no se puede ampliar.';

  @override
  String get solicitudesNoDisponible => 'Esta solicitud ya no está disponible.';

  @override
  String get cuentaNumeroTitulo => 'Cambiar mi número';

  @override
  String get cuentaRecuperarTitulo => 'Recuperar mi cuenta';

  @override
  String get cuentaNumeroExplicacion =>
      'Te mandaremos un código por SMS al número nuevo. Tu cuenta, tus trabajos y tus mensajes se quedan igual.';

  @override
  String get cuentaRecuperarExplicacion =>
      'Escribe tu número anterior, qué cuenta es y tu número nuevo. Te mandaremos un código al número nuevo.';

  @override
  String get cuentaNumeroAnterior => 'Tu número anterior (10 dígitos)';

  @override
  String get cuentaNumeroNuevo => 'Número nuevo (10 dígitos)';

  @override
  String get cuentaTipoCliente => 'Soy cliente';

  @override
  String get cuentaTipoTecnico => 'Soy técnico';

  @override
  String get cuentaNumeroCodigo => 'Código de 6 números';

  @override
  String get cuentaNumeroEnviarCodigo => 'Enviarme el código';

  @override
  String get cuentaNumeroConfirmar => 'Confirmar';

  @override
  String get cuentaNumeroEntendido => 'Entendido';

  @override
  String get cuentaNumeroOtro => 'Usar otro número';

  @override
  String get cuentaNumeroEnUso => 'Ese número ya pertenece a otra cuenta.';

  @override
  String get cuentaNumeroCambiado => 'Tu número cambió.';

  @override
  String get cuentaRecuperarRecibida =>
      'Recibimos tu solicitud. Una persona del equipo la revisará.';

  @override
  String get verificacionCargando => 'Cargando tu verificación…';

  @override
  String get verificacionReintentar => 'Reintentar';

  @override
  String get verificacionSinVerificar => 'Sin verificar';

  @override
  String get verificacionSinVerificarDetalle =>
      'La verificación es opcional y le da más confianza a tus clientes.';

  @override
  String get verificacionFotosBorradas =>
      'Tus fotos se borraron porque no se revisaron a tiempo. Puedes enviarlas de nuevo.';

  @override
  String get verificacionEnRevision => 'En revisión';

  @override
  String get verificacionEnRevisionDetalle => 'Revisamos en menos de 24 h';

  @override
  String get verificacionVerificadoBasico => 'Verificado: básica';

  @override
  String get verificacionVerificadoCompleto => 'Verificado: completa';

  @override
  String get verificacionVerificadoDetalle =>
      'Tu perfil muestra la insignia de verificado.';

  @override
  String get verificacionNoVerificado => 'No se pudo verificar';

  @override
  String get verificacionSinMotivo => 'No se indicó el motivo.';

  @override
  String verificacionEnviadaEl(String fecha) {
    return 'Enviada el $fecha';
  }

  @override
  String get verificacionEnvioNoDisponible =>
      'Enviar tus fotos desde la app todavía no está disponible.';

  @override
  String get tecnicosMapaCargando => 'Cargando expertos en el mapa…';

  @override
  String get tecnicosMapaError => 'No pudimos cargar los expertos del mapa.';

  @override
  String get tecnicosMapaVacio => 'No hay expertos en esta zona del mapa.';

  @override
  String get tecnicosOrdenRecomendados => 'Recomendados';

  @override
  String get tecnicosOrdenCalificacion => 'Mejor calificados';

  @override
  String get tecnicosOrdenDistancia => 'Más cercanos';

  @override
  String tecnicosRadio(int km) {
    return 'Hasta $km km';
  }

  @override
  String get tecnicosListadoTitulo => 'Expertos';

  @override
  String get asistenteNoDisponible =>
      'El asistente de IA no está disponible. Puedes seguir sin él.';

  @override
  String get asistenteEjemplo => 'Esto es un ejemplo: no lo generó una IA.';

  @override
  String get asistenteLimite =>
      'Llegaste al límite de uso del asistente. Inténtalo más tarde.';

  @override
  String get asistenteCargando => 'Consultando al asistente…';

  @override
  String get asistenteReintentar => 'Reintentar';

  @override
  String get asistenteGeneradoPorIa =>
      'Generado por IA. Revísalo antes de usarlo.';

  @override
  String get asistenteDePlantilla =>
      'Respuesta automática de plantilla: no la generó una IA.';

  @override
  String get asistenteTitulo => 'Asistente Knock';

  @override
  String get asistenteEscribe => '¿Qué necesitas arreglar?';

  @override
  String get asistenteSinTurno => 'Cuéntale tu problema al asistente.';

  @override
  String get asistenteEnviar => 'Enviar';

  @override
  String get asistentePideFoto => 'Agrega una foto al armar tu solicitud.';

  @override
  String get asistenteArmarSolicitud => 'Revisar y editar mi solicitud';

  @override
  String get asistenteResumenTitulo => 'Resumen de la conversación';

  @override
  String get asistenteResumenVacio => 'Todavía no hay nada que resumir.';

  @override
  String get asistenteSabe => 'Lo que sabes';

  @override
  String get asistentePorConfirmar => 'Por confirmar';

  @override
  String get asistenteQueLlevar => 'Qué llevar';

  @override
  String get asistenteBorradorTitulo => 'Borrador de cotización';

  @override
  String get asistentePrecio => 'Precio sugerido (MXN)';

  @override
  String get asistenteTiempo => 'Tiempo estimado';

  @override
  String get asistenteDia => 'Día';

  @override
  String get asistenteNota => 'Nota para el cliente';

  @override
  String get asistenteNadaSeEnvia =>
      'Es un borrador: nada se envía desde aquí.';

  @override
  String get asistenteRangoTitulo => 'Rango de precio';

  @override
  String get asistenteRangoVacio =>
      'Todavía no hay referencia de precio para este trabajo.';

  @override
  String get asistenteBitacoraTitulo => 'Bitácora del trabajo';

  @override
  String get asistenteBitacoraVacia =>
      'Aún no guardas bitácora para este trabajo.';

  @override
  String get asistenteUnoPorLinea =>
      'Un elemento por línea, hasta 10 de 200 caracteres.';

  @override
  String get asistenteGuardar => 'Guardar en bitácora';

  @override
  String get asistenteGuardada => 'Bitácora guardada.';

  @override
  String asistenteRango(String minimo, String maximo) {
    return 'De $minimo a $maximo MXN';
  }

  @override
  String asistenteMuestras(String n, String fuente) {
    return 'Muestras: $n. Fuente: $fuente.';
  }

  @override
  String asistenteCopia(String fecha) {
    return 'Sin conexión. Esta es la copia del $fecha; puede estar desactualizada.';
  }

  @override
  String get cotizarSinPerfil =>
      'Necesitas un perfil de técnico para ver esto.';

  @override
  String get cotizarYaNoSeCotiza => 'Esta solicitud ya no admite cotizaciones.';

  @override
  String get cotizarYaCotizada =>
      'Ya enviaste una cotización para esta solicitud.';

  @override
  String get cotizarCupoLleno =>
      'Esta solicitud ya tiene el máximo de cotizaciones.';

  @override
  String get cotizarTitulo => 'Cotizar';

  @override
  String get cotizarNuevas => 'Solicitudes nuevas';

  @override
  String get cotizarNuevasVacio => 'No tienes solicitudes nuevas.';

  @override
  String get cotizarVer => 'Ver y cotizar';

  @override
  String get cotizarVerPropia => 'Ver mi cotización';

  @override
  String get cotizarEnviadas => 'Cotizaciones enviadas';

  @override
  String get cotizarEnviadasVacio => 'Todavía no has enviado cotizaciones.';

  @override
  String get cotizarCargando => 'Cargando…';

  @override
  String get cotizarTipoLabel => 'Tipo de precio';

  @override
  String get cotizarPrecio => 'Precio en pesos';

  @override
  String get cotizarPrecioVisita => 'Precio de la visita en pesos';

  @override
  String get cotizarPrecioMin => 'Mínimo en pesos';

  @override
  String get cotizarPrecioMax => 'Máximo en pesos';

  @override
  String get cotizarDia => 'Día de la visita';

  @override
  String get cotizarHora => 'Hora (HH:mm)';

  @override
  String get cotizarErrorMonto => 'Escribe un número entero de 1 a 200 000.';

  @override
  String get cotizarErrorMaximo =>
      'El máximo debe ser un entero mayor que el mínimo, hasta 200 000.';

  @override
  String get cotizarErrorDia => 'Elige un día.';

  @override
  String get cotizarErrorHora => 'Escribe la hora como 09:30.';

  @override
  String get cotizarEnviar => 'Enviar cotización';

  @override
  String get cotizarEnviada => 'Cotización enviada';

  @override
  String get cotizarRequiereAprobacion =>
      'El cliente tendrá que aprobar el precio final.';

  @override
  String get cotizarSinAprobacion => 'No requiere otra aprobación del cliente.';

  @override
  String cotizarFotoDe(int numero) {
    return 'Foto $numero de la solicitud';
  }

  @override
  String cotizarTope(int monto) {
    return 'Tope: \$$monto';
  }

  @override
  String cotizarMonto(int monto) {
    return '\$$monto';
  }

  @override
  String cotizarRango(int min, int max) {
    return '\$$min a \$$max';
  }

  @override
  String cotizarCuando(String dia, String franja) {
    return '$dia · $franja';
  }

  @override
  String cotizarTipo(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'fijo': 'Precio fijo',
      'rango': 'Rango',
      'visita': 'Por visita',
      'other': '$tipo',
    });
    return '$_temp0';
  }

  @override
  String cotizarFranja(String franja) {
    String _temp0 = intl.Intl.selectLogic(franja, {
      'manana': 'Mañana',
      'tarde': 'Tarde',
      'noche': 'Noche',
      'other': '$franja',
    });
    return '$_temp0';
  }

  @override
  String cotizarEstado(String estado) {
    String _temp0 = intl.Intl.selectLogic(estado, {
      'enviada': 'Esperando respuesta',
      'aceptada': 'Aceptada',
      'rechazada': 'Rechazada',
      'retirada': 'Retirada',
      'other': '$estado',
    });
    return '$_temp0';
  }

  @override
  String get precioFinalBoton => 'Enviar cotización final';

  @override
  String get precioAjusteBoton => 'Proponer otro precio';

  @override
  String get precioFinalExplicacion =>
      'Solo aplica a las visitas de diagnóstico. El cliente la aprueba o la rechaza.';

  @override
  String get precioFinalMonto => 'Precio final en pesos';

  @override
  String get precioFinalDescripcion => '¿Qué incluye?';

  @override
  String get precioDescripcionAyuda => 'De 8 a 500 caracteres.';

  @override
  String get precioMontoAyuda => 'Pesos sin centavos, mayor que cero.';

  @override
  String get precioFinalEnviar => 'Enviar al cliente';

  @override
  String get precioFinalEnviada =>
      'Enviamos tu cotización final. Falta que el cliente la apruebe.';

  @override
  String get precioFinalNoPermitida =>
      'Ahora no se puede enviar: solo una vez, con la visita de diagnóstico en curso.';

  @override
  String get precioAjusteCargando => 'Buscando tu cotización aceptada…';

  @override
  String get precioAjusteSinCotizacion =>
      'No encontramos la cotización aceptada de esta visita.';

  @override
  String get precioAjusteMonto => 'Nuevo precio total en pesos';

  @override
  String precioAjusteMinimo(int monto) {
    return 'Mínimo $monto pesos.';
  }

  @override
  String get precioAjusteMotivo => '¿Por qué cambia el precio?';

  @override
  String get precioAjusteMotivoAyuda => 'De 10 a 300 caracteres.';

  @override
  String get precioAjusteEnviar => 'Proponer al cliente';

  @override
  String get precioAjusteEnviado =>
      'Enviamos tu propuesta. Falta que el cliente la apruebe.';

  @override
  String get precioAjusteNoPermitido =>
      'Ahora no se puede proponer: la visita debe estar en curso y sin otro cambio pendiente.';

  @override
  String get visitaPermisoFotosTitulo => 'Fotos del trabajo';

  @override
  String get visitaPermisoFotosCasilla =>
      'Permitir que estas fotos se muestren en el perfil del técnico y en Explorar';

  @override
  String get visitaPermisoFotosDetalle =>
      'Es opcional. Solo se muestran con tu permiso y después de una revisión de contenido. Puedes cambiar tu respuesta.';

  @override
  String get visitaPermisoFotosGuardado => 'Guardamos tu respuesta.';

  @override
  String get visitaPermisoFotosCargando => 'Cargando tu respuesta…';

  @override
  String get suspensionApelar => 'Apelar la suspensión';

  @override
  String get suspensionTitulo => 'Tu apelación';

  @override
  String get suspensionDetalle =>
      'Verifica tu número con un código por SMS. Esto no inicia sesión.';

  @override
  String get suspensionEnviarCodigo => 'Enviarme el código';

  @override
  String get suspensionVerificar => 'Verificar';

  @override
  String get suspensionSinConsulta =>
      'No hay una apelación disponible para consultar. Si quieres apelar, escribe tus motivos.';

  @override
  String get suspensionTexto => 'Tus motivos';

  @override
  String get suspensionTextoAyuda => 'Escribe entre 8 y 500 caracteres.';

  @override
  String get suspensionPresentar => 'Enviar apelación';

  @override
  String get suspensionNoDisponible => 'No hay una apelación disponible.';

  @override
  String get suspensionNoPermitida => 'No se puede presentar otra apelación.';

  @override
  String get suspensionVerificarOtraVez =>
      'Verifica tu número otra vez con un código por SMS.';

  @override
  String get suspensionVolver => 'Volver';

  @override
  String suspensionEstado(String estado) {
    String _temp0 = intl.Intl.selectLogic(estado, {
      'pendiente': 'Tu apelación está en revisión.',
      'aceptada': 'Tu apelación fue aceptada.',
      'rechazada': 'Tu apelación fue rechazada.',
      'other': 'Estado de tu apelación: $estado',
    });
    return '$_temp0';
  }

  @override
  String suspensionPresentadaEl(String fecha) {
    return 'Presentada el $fecha';
  }

  @override
  String suspensionResueltaEl(String fecha) {
    return 'Resuelta el $fecha';
  }
}
