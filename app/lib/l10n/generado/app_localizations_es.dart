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
}
