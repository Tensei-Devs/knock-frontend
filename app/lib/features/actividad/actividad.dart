// Lo que la función Actividad ofrece a otras funciones: los contactos de
// confianza (spec 022, D-01), que Mi cuenta administra sin una visita.
export 'package:app/features/actividad/domain/aviso.dart'
    show ContactoConfianza;
export 'package:app/features/actividad/presentation/aviso_controller.dart'
    show contactosProvider;
export 'package:app/features/actividad/presentation/widgets/formulario_contacto.dart'
    show mostrarFormularioContacto;
export 'package:app/features/actividad/actividad_providers.dart'
    show solicitudesRealesRepositoryProvider;
export 'package:app/features/actividad/domain/franja.dart' show Franja;
export 'package:app/features/actividad/domain/solicitud.dart'
    show EstadoSolicitud, NuevaSolicitud, Solicitud;
export 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart'
    show
        solicitudRealDetalleProvider,
        solicitudesRealesActivasProvider,
        solicitudesRealesControllerProvider;
export 'package:app/features/actividad/domain/cotizacion.dart'
    show
        CitaConfirmada,
        Cotizacion,
        EtiquetaCotizacion,
        MotivoSinEleccion,
        OrdenCotizaciones,
        ResultadoComparacion,
        TecnicoResumen,
        TipoPrecio;
export 'package:app/features/actividad/presentation/cotizaciones_controller.dart'
    show
        EleccionEnCurso,
        EleccionFallida,
        EleccionHecha,
        EleccionVisitaExistente,
        EleccionInactiva,
        EstadoEleccion;
export 'package:app/features/actividad/presentation/cotizaciones_reales_controller.dart'
    show ConsultaCotizaciones, cotizacionesRealesProvider, eleccionRealProvider;
export 'package:app/features/actividad/domain/aviso.dart' show MensajeAviso;
export 'package:app/features/actividad/domain/visita.dart'
    show EstadoVisita, MotivoCodigo, TecnicoDeVisita, Visita;
export 'package:app/features/actividad/presentation/visitas_reales_controller.dart'
    show avisoRealProvider, visitaRealProvider;
