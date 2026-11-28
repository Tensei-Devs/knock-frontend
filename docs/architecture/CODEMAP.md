# Mapa de código

> Generado por `scripts/codemap.py` el 2026-11-28T05:20:03Z. No editar a mano.
> **Antes de crear una clase, método o archivo, busca aquí o corre `python scripts/codemap.py --query "<qué necesitas>"`.**

## Resumen

| Módulo | Capas | Archivos | Tipos | Métodos públicos |
|---|---|---|---|---|
| `actividad` | -, data, domain, presentation | 48 | 130 | 163 |
| `app` | - | 3 | 2 | 5 |
| `asistente` | -, data, domain, presentation | 5 | 13 | 13 |
| `bandeja_avisos` | -, data, domain, presentation | 5 | 9 | 19 |
| `busqueda` | -, data, domain, presentation | 8 | 21 | 25 |
| `cache` | core | 2 | 7 | 9 |
| `config` | core | 5 | 0 | 1 |
| `cuenta` | -, data, domain, presentation | 27 | 43 | 55 |
| `direcciones` | -, data, domain, presentation | 6 | 7 | 15 |
| `enlaces` | core | 2 | 3 | 6 |
| `entrada` | -, domain, presentation | 9 | 14 | 27 |
| `errores` | core | 3 | 31 | 3 |
| `explorar` | -, data, domain, presentation | 7 | 11 | 7 |
| `home` | -, components, pages | 3 | 2 | 0 |
| `inicio` | -, data, domain, presentation | 26 | 51 | 36 |
| `l10n` | - | 3 | 4 | 215 |
| `layout` | core | 1 | 1 | 0 |
| `maqueta` | - | 66 | 321 | 600 |
| `mensajes` | -, data, domain, presentation | 15 | 31 | 45 |
| `mi` | -, data, domain, presentation | 6 | 11 | 21 |
| `notificaciones` | core | 7 | 17 | 20 |
| `oficios` | -, data, domain, presentation | 15 | 23 | 20 |
| `opiniones` | -, data, domain, presentation | 5 | 11 | 8 |
| `panel` | - | 3 | 1 | 0 |
| `permisos` | core | 2 | 4 | 4 |
| `plataforma` | core | 3 | 6 | 4 |
| `preferencias` | core | 6 | 12 | 25 |
| `previa` | -, domain, presentation | 16 | 32 | 48 |
| `red` | core | 9 | 6 | 22 |
| `reportes` | -, data, domain, presentation | 6 | 13 | 21 |
| `router` | core | 4 | 4 | 16 |
| `sesion` | core | 15 | 25 | 46 |
| `suspension` | -, data, domain, presentation | 6 | 8 | 12 |
| `tecnico` | -, data, domain, presentation | 22 | 47 | 42 |
| `tecnicos_confianza` | -, data, domain, presentation | 6 | 6 | 11 |
| `tema` | core | 6 | 11 | 5 |
| `trabajo` | -, data, domain, presentation | 10 | 27 | 25 |
| `verificacion` | -, data, domain, presentation | 5 | 5 | 2 |
| `visita` | -, data, domain, presentation | 15 | 24 | 25 |
| `widgets` | core | 5 | 6 | 6 |

## Tipos con el mismo nombre en varios lugares

- `Bitacora`: `app/lib/features/asistente/domain/asistente.dart:72`, `app/lib/features/maqueta/tecnico_estado.dart:123`
- `EntradaCache`: `app/lib/core/cache/almacen_cache.dart:8`, `app/lib/core/red/cache_respuestas.dart:7`
- `Franja`: `app/lib/features/actividad/domain/franja.dart:5`, `app/lib/features/tecnico/domain/horarios.dart:18`
- `Opinion`: `app/lib/features/maqueta/tecnico_estado.dart:173`, `app/lib/features/opiniones/domain/opinion.dart:35`
- `SesionNotifier`: `app/lib/core/sesion/sesion.dart:62`, `app/lib/core/sesion/sesion_provider.dart:26`
- `Solicitud`: `app/lib/features/actividad/domain/solicitud.dart:30`, `app/lib/features/maqueta/estado.dart:165`
- `TipoPrecio`: `app/lib/features/actividad/domain/cotizacion.dart:6`, `app/lib/features/trabajo/domain/cotizar.dart:59`
- `Visita`: `app/lib/features/actividad/domain/visita.dart:73`, `app/lib/features/maqueta/tecnico_estado.dart:153`

## Índice por módulo

### actividad

**-**

- `app/lib/features/actividad/actividad.dart` — —
- `app/lib/features/actividad/actividad_providers.dart` — —

**data**

- `app/lib/features/actividad/data/ampliar_solicitud_api.dart` — class `AmpliarSolicitudApi`
  - `ampliar()`:13
- `app/lib/features/actividad/data/aviso_local_repository.dart` — class `ContactosConfianzaSeguros`, class `RespaldoAvisoSeguro`
  - `listar()`:15, `guardar()`:28, `borrar()`:50, `leer()`:69, `guardar()`:93
- `app/lib/features/actividad/data/borrador_repository.dart` — class `BorradorRepository`
  - `leer()`:27, `guardar()`:53, `borrarTodo()`:60, `agregarFoto()`:73, `quitarFoto()`:94
- `app/lib/features/actividad/data/contrato_json.dart` — —
  - `obtenerJsonONoEncontrado()`:11, `diaLocalDelContrato()`:31, `mapaDelContrato()`:38, `textoDelContrato()`:44, `textoOpcionalDelContrato()`:52, `booleanoDelContrato()`:56
- `app/lib/features/actividad/data/foto_preparada.dart` — enum `MotivoFotoRechazada`, class `ResultadoFoto`, class `FotoLista`, class `FotoRechazada`, enum `_Formato`
  - `prepararFoto()`:88, `prepararFotoEnSegundoPlano()`:147
- `app/lib/features/actividad/data/fuente_de_fotos_sistema.dart` — class `FuenteDeFotosSistema`
  - `tomarConCamara()`:16, `elegirDeGaleria()`:22
- `app/lib/features/actividad/data/solicitud_contrato_mapper.dart` — class `SolicitudContratoMapper`
  - `detalle()`:30, `comparacion()`:53, `cita()`:72
- `app/lib/features/actividad/data/solicitud_mapper.dart` — —
  - `cuerpoDeSolicitud()`:11
- `app/lib/features/actividad/data/solicitud_repository_api.dart` — class `SolicitudRepositoryApi`
  - `cancelar()`:42, `subirFoto()`:86, `crear()`:93, `obtener()`:120, `listar()`:131, `cotizaciones()`:151, `elegir()`:188
- `app/lib/features/actividad/data/solicitud_repository_de_prueba.dart` — class `SolicitudRepositoryDePrueba`
  - `cancelar()`:24, `subirFoto()`:78, `crear()`:81, `obtener()`:122, `listar()`:129, `cotizaciones()`:136, `elegir()`:166, `obtenerVisita()`:215, `pedirAviso()`:244, `cotizacion()`:262, `etiquetarComoElServidor()`:356, `ordenarComoElServidor()`:393, `porCalificacion()`:397, `porTope()`:399
- `app/lib/features/actividad/data/subida_de_fotos_api.dart` — class `SubidaDeFotosApi`, class `_Enlace`
  - `subir()`:44
- `app/lib/features/actividad/data/visita_contrato_mapper.dart` — class `VisitaContratoMapper`
  - `visita()`:14, `aviso()`:51
- `app/lib/features/actividad/data/visita_local_repository.dart` — class `VisitaLocalRepositorySeguro`
  - `leer()`:15, `guardar()`:32, `borrar()`:44
- `app/lib/features/actividad/data/visita_repository_api.dart` — class `VisitaRepositoryApi`, class `AvisoRepositoryApi`
  - `obtenerVisita()`:19, `pedirAviso()`:40

**domain**

- `app/lib/features/actividad/domain/aviso.dart` — enum `ErrorContacto`, class `ContactoNoGuardado`, class `ContactoConfianza`, class `MensajeAviso`, class `DatosAvisoLocal`, class `PlantillaAviso`, enum `CanalDeAviso`, class `AvisoRepository`, class `ContactosConfianzaRepository`, class `RespaldoAvisoRepository`
  - `aMapa()`:39, `desdeMapa()`:45, `soloDigitos()`:57, `validarContacto()`:60, `puedeGuardarse()`:74, `textoContieneCodigo()`:110, `vigente()`:141, `armarAvisoLocal()`:170
- `app/lib/features/actividad/domain/borrador_solicitud.dart` — class `BorradorSolicitud`
  - `aMapa()`:38, `desdeMapa()`:51
- `app/lib/features/actividad/domain/cotizacion.dart` — enum `TipoPrecio`, enum `EtiquetaCotizacion`, enum `OrdenCotizaciones`, enum `MotivoSinEleccion`, class `TecnicoResumen`, class `Cotizacion`, class `ResultadoComparacion`, class `TecnicoElegido`, class `CitaConfirmada`
  - `desdeTexto()`:15, `desdeTexto()`:34, `desdeTexto()`:66
- `app/lib/features/actividad/domain/fotos_permitidas.dart` — —
  - `esFotoPermitida()`:10, `fotosPermitidas()`:23
- `app/lib/features/actividad/domain/franja.dart` — enum `Franja`
  - `desdeTexto()`:16
- `app/lib/features/actividad/domain/regla_cancelacion.dart` — class `ReglaCancelacion`, enum `MotivoCancelacion`, class `ResultadoCancelacion`, class `Cancelada`, class `CancelacionConCita`, class `CancelacionYaVencida`, class `CancelacionNoDisponible`, class `CancelacionInvalida`, class `CancelacionLimite`, class `CancelacionError`, class `CancelacionSinConexion`
- `app/lib/features/actividad/domain/solicitud.dart` — enum `EstadoSolicitud`, class `Solicitud`, class `PrellenadoSolicitud`, class `NuevaSolicitud`
  - `desdeTexto()`:21
- `app/lib/features/actividad/domain/solicitud_repository.dart` — class `SolicitudRepository`, class `BorradorSolicitudRepository`, class `FuenteDeFotos`
- `app/lib/features/actividad/domain/validacion_solicitud.dart` — enum `ErrorDeLargo`, enum `ErrorDeFotos`
  - `largoVisible()`:30, `validarDescripcion()`:40, `validarDireccion()`:44, `validarCantidadDeFotos()`:48, `puedeAgregarFoto()`:55, `soloFecha()`:58, `diasPermitidos()`:65, `esDiaPermitido()`:74, `diaDelContrato()`:78, `dos()`:79
- `app/lib/features/actividad/domain/vencimiento.dart` — class `ZonaMexico`, class `PresentacionVencimiento`, class `VencimientoAbsoluto`, class `VencimientoRelativo`, class `MenosDeUnaHora`, class `VencimientoCerrando`, class `Vencimiento`
  - `horaCivil()`:9
- `app/lib/features/actividad/domain/visita.dart` — enum `EstadoVisita`, enum `MotivoCodigo`, class `TecnicoDeVisita`, class `Visita`, class `VisitaGuardada`, class `VisitaRepository`, class `VisitaLocalRepository`
  - `desdeTexto()`:19, `desdeTexto()`:42, `aMapa()`:155, `desdeMapa()`:170

**presentation**

- `app/lib/features/actividad/presentation/actividad_screen.dart` — class `ActividadScreen`
  - `build()`:20, `PantallaTitulada()`:57
- `app/lib/features/actividad/presentation/aviso_controller.dart` — class `TextoDeAviso`, class `AvisoDelServidor`, class `AvisoDeRespaldo`, class `AvisoNoPermitido`, class `AvisoSinDatos`, class `ContactosController`
  - `build()`:84, `guardar()`:90, `borrar()`:127
- `app/lib/features/actividad/presentation/cotizaciones_controller.dart` — class `OrdenCotizacionesNotifier`, class `EstadoEleccion`, class `EleccionInactiva`, class `EleccionEnCurso`, class `EleccionHecha`, class `EleccionVisitaExistente`, class `EleccionFallida`, class `EleccionController`
  - `build()`:19, `elegir()`:21, `build()`:84, `elegir()`:88, `reiniciar()`:154
- `app/lib/features/actividad/presentation/cotizaciones_reales_controller.dart` — typedef `ConsultaCotizaciones`, class `EleccionRealController`
  - `build()`:33, `elegir()`:35, `reiniciar()`:88
- `app/lib/features/actividad/presentation/cotizaciones_screen.dart` — class `CotizacionesScreen`, class `_Lista`, class `_Aviso`
  - `build()`:24, `nombreOrden()`:29, `build()`:97, `EstadoKnock()`:118, `build()`:192
- `app/lib/features/actividad/presentation/pasos/paso_cuando_donde.dart` — class `PasoCuandoDonde`, class `_PasoCuandoDondeState`
  - `initState()`:22, `dispose()`:30, `build()`:36, `nombreFranja()`:53
- `app/lib/features/actividad/presentation/pasos/paso_descripcion_fotos.dart` — class `PasoDescripcionFotos`, class `_PasoDescripcionFotosState`
  - `initState()`:22, `dispose()`:30, `build()`:36
- `app/lib/features/actividad/presentation/pasos/paso_oficio.dart` — class `PasoOficio`
  - `build()`:13
- `app/lib/features/actividad/presentation/solicitud_controller.dart` — enum `PasoSolicitud`, class `FormularioSolicitud`, class `SolicitudController`
  - `build()`:146, `iniciar()`:153, `reintentarOficios()`:181, `elegirOficio()`:191, `cambiarDescripcion()`:201, `elegirDia()`:204, `elegirFranja()`:209, `cambiarDireccion()`:213, `tomarFoto()`:217, `elegirFotos()`:222, `quitarFoto()`:257, `avanzar()`:270, `retroceder()`:287, `enviar()`:299, `descartar()`:368
- `app/lib/features/actividad/presentation/solicitud_detalle_screen.dart` — class `SolicitudDetalleScreen`, class `_Contenido`
  - `esperaCotizaciones()`:36, `textoEstadoSolicitud()`:42, `build()`:63, `build()`:98, `showModalBottomSheet()`:191
- `app/lib/features/actividad/presentation/solicitud_nueva_screen.dart` — class `SolicitudNuevaScreen`, class `_SolicitudNuevaScreenState`, class `_Avisos`, class `_Botones`
  - `initState()`:33, `build()`:45, `build()`:115, `build()`:157
- `app/lib/features/actividad/presentation/solicitudes_reales_controller.dart` — class `SolicitudesRealesController`
  - `build()`:21, `reintentar()`:25
- `app/lib/features/actividad/presentation/visita_controller.dart` — class `VistaDeVisita`, class `VisitaEnLinea`, class `VisitaSinConexion`
- `app/lib/features/actividad/presentation/visita_screen.dart` — class `VisitaScreen`, class `_VisitaScreenState`, class `_VisitaEnLinea`, class `_VisitaGuardada`, class `_Contacto`, class `_BotonEnlace`
  - `initState()`:39, `dispose()`:48, `didChangeAppLifecycleState()`:55, `build()`:62, `build()`:109, `build()`:208, `build()`:252, `build()`:299
- `app/lib/features/actividad/presentation/visitas_reales_controller.dart` — —
- `app/lib/features/actividad/presentation/widgets/codigo_visita.dart` — class `CodigoVisita`, class `_CodigoVisitaState`
  - `build()`:37
- `app/lib/features/actividad/presentation/widgets/formulario_contacto.dart` — class `_FormularioContacto`, class `_FormularioContactoState`
  - `mostrarFormularioContacto()`:10, `showDialog()`:14, `mensajeErrorContacto()`:24, `initState()`:54, `dispose()`:61, `build()`:88
- `app/lib/features/actividad/presentation/widgets/hoja_avisar.dart` — class `HojaAvisar`, class `_HojaAvisarState`
  - `mostrarHojaAvisar()`:14, `build()`:68
- `app/lib/features/actividad/presentation/widgets/hoja_confirmar_eleccion.dart` — class `HojaConfirmarEleccion`, class `_Confirmacion`, class `_Cita`
  - `mostrarHojaConfirmarEleccion()`:15, `showModalBottomSheet()`:21, `build()`:52, `build()`:104, `build()`:182
- `app/lib/features/actividad/presentation/widgets/selector_fotos.dart` — class `SelectorFotos`, class `_Miniatura`
  - `build()`:16, `build()`:117
- `app/lib/features/actividad/presentation/widgets/tarjeta_cotizacion.dart` — class `TarjetaCotizacion`
  - `build()`:28

### app

**-**

- `app/lib/app.dart` — class `KnockApp`
  - `build()`:19
- `app/lib/main.dart` — —
  - `main()`:17, `arrancar()`:27
- `app/lib/main_spike_mapa.dart` — class `SpikeMapaApp`
  - `main()`:11, `build()`:20

### asistente

**-**

- `app/lib/features/asistente/asistente.dart` — —
- `app/lib/features/asistente/asistente_providers.dart` — —

**data**

- `app/lib/features/asistente/data/asistente_repository_api.dart` — class `AsistenteRepositoryApi`
  - `turno()`:27, `resumir()`:43, `borrador()`:58, `rango()`:75, `bitacora()`:99, `guardarBitacora()`:109

**domain**

- `app/lib/features/asistente/domain/asistente.dart` — class `TurnoAsistente`, class `ResumenChat`, class `BorradorCotizacionIa`, class `RangoPrecio`, class `Bitacora`, class `AsistenteRepository`

**presentation**

- `app/lib/features/asistente/presentation/asistente_controller.dart` — class `TurnoController`, class `ResumenController`, class `BorradorController`, typedef `ConsultaDeRango`, class `RangoController`, class `BitacoraController`
  - `build()`:14, `enviar()`:19, `build()`:40, `build()`:58, `build()`:78, `build()`:98, `guardar()`:104

### bandeja_avisos

**-**

- `app/lib/features/bandeja_avisos/bandeja_avisos.dart` — —
- `app/lib/features/bandeja_avisos/bandeja_avisos_providers.dart` — —

**data**

- `app/lib/features/bandeja_avisos/data/bandeja_avisos_repository_api.dart` — class `BandejaAvisosRepositoryApi`
  - `listar()`:21, `sinLeer()`:37, `marcarLeido()`:52, `marcarTodos()`:60, `preferencias()`:64, `cambiar()`:69

**domain**

- `app/lib/features/bandeja_avisos/domain/aviso_en_bandeja.dart` — class `AvisoEnBandeja`, class `PaginaAvisos`, class `PreferenciaDeAviso`, class `AvisosSinLeer`, class `BandejaAvisosRepository`
  - `comoLeido()`:24, `toString()`:34

**presentation**

- `app/lib/features/bandeja_avisos/presentation/bandeja_avisos_controller.dart` — class `BandejaAvisosController`, class `AvisosSinLeerController`, class `PreferenciasDeAvisosController`
  - `build()`:13, `reintentar()`:19, `cursorDe()`:22, `pedirPagina()`:25, `unirPaginas()`:30, `marcarLeido()`:38, `marcarTodos()`:59, `build()`:84, `build()`:101, `reintentar()`:106, `cambiar()`:109

### busqueda

**-**

- `app/lib/features/busqueda/busqueda.dart` — —
- `app/lib/features/busqueda/busqueda_providers.dart` — —

**data**

- `app/lib/features/busqueda/data/busqueda_repository_api.dart` — class `BusquedaRepositoryApi`
  - `buscar()`:18, `sugerencias()`:62, `opcional()`:80

**domain**

- `app/lib/features/busqueda/domain/busqueda.dart` — class `OficioBuscado`, enum `EstadoInterpretacion`, class `InterpretacionBusqueda`, class `ExpertoBuscado`, class `PaginaBusqueda`, class `BusquedaNoDisponible`, class `SugerenciaBusqueda`
  - `normalizarConsulta()`:8, `desde()`:36
- `app/lib/features/busqueda/domain/busqueda_repository.dart` — class `BusquedaRepository`

**presentation**

- `app/lib/features/busqueda/presentation/busqueda_controller.dart` — class `ConsultaBusqueda`, class `ConsultaBusquedaNotifier`, class `BusquedaController`
  - `build()`:34, `escribir()`:42, `buscarYa()`:48, `filtrarOficio()`:59, `soloVerificados()`:65, `build()`:87, `reintentar()`:104, `cursorDe()`:107, `pedirPagina()`:110, `unirPaginas()`:119, `verMas()`:130
- `app/lib/features/busqueda/presentation/busqueda_screen.dart` — class `BusquedaScreen`, class `_BusquedaScreenState`, class `_SinZona`, class `_ResultadosView`, class `_ErrorView`, class `_PaginaView`, class `_BotonVerMas`, class `_BotonVerMasState`
  - `initState()`:30, `dispose()`:39, `build()`:55, `build()`:177, `build()`:209, `build()`:260, `build()`:299, `build()`:441
- `app/lib/features/busqueda/presentation/tarjeta_experto.dart` — class `TarjetaExperto`
  - `build()`:20

### cache

**core**

- `app/lib/core/cache/almacen_cache.dart` — class `EntradaCache`, class `AlmacenCache`, class `AlmacenCacheEnMemoria`, class `AlmacenCacheShared`
  - `conFecha()`:19, `esClaveCacheable()`:34, `leer()`:53, `guardar()`:56, `borrarTodo()`:62, `leer()`:78, `guardar()`:99, `borrarTodo()`:112
- `app/lib/core/cache/revalidador_etag.dart` — enum `OrigenCache`, class `RespuestaCache`, class `RevalidadorEtag`
  - `leerGuardado()`:52

### config

**core**

- `app/lib/core/config/asistente_ia.dart` — —
- `app/lib/core/config/aviso_de_privacidad.dart` — —
  - `direccionDelAvisoDePrivacidad()`:17
- `app/lib/core/config/exportacion_de_datos.dart` — —
- `app/lib/core/config/modo_maqueta.dart` — —
- `app/lib/core/config/subida_de_fotos.dart` — —

### cuenta

**-**

- `app/lib/features/cuenta/cuenta.dart` — —
- `app/lib/features/cuenta/cuenta_providers.dart` — —

**data**

- `app/lib/features/cuenta/data/eliminacion_repository_api.dart` — class `EliminacionRepositoryApi`
  - `pendientes()`:18, `programar()`:28, `cancelar()`:56
- `app/lib/features/cuenta/data/numero_repository_api.dart` — class `NumeroRepositoryApi`
  - `comprobar()`:17, `confirmar()`:21, `recuperar()`:27
- `app/lib/features/cuenta/data/perfil_mapper.dart` — class `PerfilMapper`
  - `desdeContrato()`:8
- `app/lib/features/cuenta/data/perfil_repository_api.dart` — class `PerfilRepositoryApi`
  - `obtener()`:30, `guardarNombre()`:35, `cerrarSesion()`:55
- `app/lib/features/cuenta/data/perfil_repository_simulado.dart` — class `PerfilRepositorySimulado`
  - `obtener()`:22, `guardarNombre()`:25, `cerrarSesion()`:29
- `app/lib/features/cuenta/data/privacidad_repository_api.dart` — class `PrivacidadRepositoryApi`
  - `consentimientos()`:18, `cambiarConsentimiento()`:24, `pedirExportacion()`:39, `ultimaExportacion()`:43
- `app/lib/features/cuenta/data/sesiones_repository_api.dart` — class `SesionesRepositoryApi`
  - `listar()`:16, `cerrar()`:24

**domain**

- `app/lib/features/cuenta/domain/eliminacion.dart` — class `PendientesDeCuenta`, class `ResultadoDeEliminacion`, class `EliminacionProgramada`, class `PideVerificacion`, class `EliminacionRepository`
- `app/lib/features/cuenta/domain/numero.dart` — enum `TipoDeCuenta`, class `NumeroRepository`
- `app/lib/features/cuenta/domain/perfil.dart` — class `Perfil`
  - `validarNombre()`:66
- `app/lib/features/cuenta/domain/perfil_repository.dart` — class `PerfilRepository`
- `app/lib/features/cuenta/domain/privacidad.dart` — class `Consentimiento`, enum `EstadoExportacion`, class `Exportacion`, class `PrivacidadRepository`
  - `toString()`:32
- `app/lib/features/cuenta/domain/sesion_dispositivo.dart` — class `SesionDispositivo`
- `app/lib/features/cuenta/domain/sesiones_repository.dart` — class `SesionesRepository`

**presentation**

- `app/lib/features/cuenta/presentation/avatar_iniciales.dart` — class `AvatarIniciales`
  - `build()`:12
- `app/lib/features/cuenta/presentation/completar_perfil_screen.dart` — class `CompletarPerfilScreen`, class `_EstadoCompletar`, class `_Listo`
  - `dispose()`:30, `build()`:61, `build()`:112
- `app/lib/features/cuenta/presentation/configuracion_screen.dart` — class `ConfiguracionScreen`, class `_Encabezado`, class `_Opcion`
  - `build()`:17, `build()`:79, `build()`:96
- `app/lib/features/cuenta/presentation/contactos_confianza_screen.dart` — class `ContactosConfianzaScreen`
  - `build()`:14
- `app/lib/features/cuenta/presentation/cuenta_screen.dart` — class `CuentaScreen`, class `_ErrorDePerfil`, class `_TarjetaDePerfil`, class `_ConfirmarCierreDeSesion`
  - `build()`:38, `build()`:97, `build()`:122, `build()`:172
- `app/lib/features/cuenta/presentation/eliminacion_controller.dart` — class `PendientesController`, class `EliminacionController`
  - `build()`:12, `reintentar()`:17, `build()`:27, `programar()`:34, `cancelar()`:46
- `app/lib/features/cuenta/presentation/perfil_controller.dart` — class `PerfilController`
  - `build()`:15, `guardarNombre()`:32, `cerrarSesion()`:46, `reintentar()`:56, `perfilCargado()`:76
- `app/lib/features/cuenta/presentation/privacidad_controller.dart` — class `ConsentimientosController`, class `ExportacionController`
  - `build()`:10, `reintentar()`:16, `cambiar()`:19, `build()`:42, `reintentar()`:48, `pedir()`:52
- `app/lib/features/cuenta/presentation/sesiones_controller.dart` — class `SesionesController`
  - `build()`:11, `reintentar()`:15, `cerrar()`:20
- `app/lib/features/cuenta/presentation/widgets/menu_de_prueba.dart` — class `MenuDePrueba`
  - `build()`:15
- `app/lib/features/cuenta/presentation/widgets/seccion_avisos.dart` — class `SeccionAvisos`, class `_SeccionAvisosState`
  - `initState()`:28, `build()`:55

### direcciones

**-**

- `app/lib/features/direcciones/direcciones.dart` — —
- `app/lib/features/direcciones/direcciones_providers.dart` — —

**data**

- `app/lib/features/direcciones/data/direcciones_repository_api.dart` — class `DireccionesRepositoryApi`
  - `listar()`:17, `crear()`:28, `editar()`:45, `eliminar()`:65, `texto()`:78

**domain**

- `app/lib/features/direcciones/domain/direccion.dart` — class `Direccion`, class `DireccionNueva`, class `CambiosDireccion`
  - `toString()`:22, `toString()`:41, `toString()`:66
- `app/lib/features/direcciones/domain/direcciones_repository.dart` — class `DireccionesRepository`

**presentation**

- `app/lib/features/direcciones/presentation/direcciones_controller.dart` — class `DireccionesController`, class `DireccionElegida`
  - `build()`:12, `reintentar()`:18, `crear()`:20, `editar()`:23, `eliminar()`:27, `build()`:56, `elegir()`:61

### enlaces

**core**

- `app/lib/core/enlaces/abridor_de_enlaces.dart` — class `AbridorDeEnlaces`, class `AbridorDeEnlacesDelSistema`
  - `abrir()`:19
- `app/lib/core/enlaces/enlaces.dart` — class `Enlaces`
  - `mapa()`:7, `llamada()`:13, `whatsapp()`:19, `sms()`:28, `whatsappConTexto()`:36

### entrada

**-**

- `app/lib/features/entrada/entrada.dart` — —

**domain**

- `app/lib/features/entrada/domain/validacion_entrada.dart` — —
  - `esCelularValido()`:17, `esCodigoValido()`:20, `formatearCelular()`:25

**presentation**

- `app/lib/features/entrada/presentation/celular_screen.dart` — class `CelularScreen`, class `_CelularScreenState`, class `_CasillaDelAviso`, class `_CasillaDelAvisoState`
  - `dispose()`:38, `build()`:62, `dispose()`:154, `build()`:172, `CheckboxListTile()`:202
- `app/lib/features/entrada/presentation/codigo_screen.dart` — class `CodigoScreen`, class `_CodigoScreenState`
  - `dispose()`:36, `build()`:59
- `app/lib/features/entrada/presentation/cuenta_regresiva_controller.dart` — class `CuentaRegresivaNotifier`
  - `build()`:18, `reiniciar()`:25
- `app/lib/features/entrada/presentation/entrada_controller.dart` — class `EntradaUiState`, class `EntradaController`
  - `copyWith()`:23, `build()`:41, `enviarCodigo()`:46, `reenviar()`:64, `verificar()`:82, `limpiarError()`:106
- `app/lib/features/entrada/presentation/mensaje_de_error.dart` — —
  - `mensajeDeErrorDeEntrada()`:5
- `app/lib/features/entrada/presentation/widgets/marco_de_entrada.dart` — class `MarcoDeEntrada`, class `_Marca`, class `BotonPrincipalDeEntrada`, class `MensajeDeErrorDeEntrada`
  - `build()`:29, `build()`:91, `decoracionDeEntrada()`:129, `estiloBotonPrincipal()`:147, `build()`:167, `build()`:189
- `app/lib/features/entrada/presentation/widgets/pie_de_codigo.dart` — class `PieDeCodigo`
  - `build()`:32, `TextButton()`:53

### errores

**core**

- `app/lib/core/errores/failure.dart` — class `Failure`, class `DatosInvalidosFailure`, class `ServicioNoDisponibleFailure`, class `ApiNoConfiguradaFailure`, class `NoAutorizadoFailure`, class `CuentaSuspendidaFailure`, class `AccesoDenegadoFailure`, class `ConflictoFailure`, class `DatosRechazadosFailure`, class `DemasiadosIntentosFailure`, class `AvisoNoAceptadoFailure`, class `CodigoIncorrectoFailure`, class `CodigoVencidoFailure`, class `CelularRechazadoFailure`, class `VerificacionNoDisponibleFailure`, class `NoEncontradoFailure`, class `ContenidoRechazadoFailure`, class `ModeracionNoDisponibleFailure`, class `OpcionNoDisponibleFailure`, class `FotoNoValidaFailure`, enum `MotivoEleccionRechazada`, class `EleccionRechazadaFailure`, class `AvisoNoPermitidoFailure`, class `OpinionNoPermitidaFailure`, class `YaBloqueadoFailure`, class `ApelacionNoPermitidaFailure`, class `OpinionYaRespondidaFailure`, class `SinPerfilTecnicoFailure`, enum `MotivoCotizacionRechazada`, class `CotizacionNoPermitidaFailure`, class `AsistenteNoDisponibleFailure`
  - `toString()`:10
- `app/lib/core/errores/mensaje_failure.dart` — —
  - `mensajeDeError()`:10
- `app/lib/core/errores/mensajes_failure.dart` — —
  - `mensajeDeFailure()`:7

### explorar

**-**

- `app/lib/features/explorar/explorar.dart` — —
- `app/lib/features/explorar/explorar_providers.dart` — —

**data**

- `app/lib/features/explorar/data/explorar_repository_api.dart` — class `ExplorarRepositoryApi`
  - `cargar()`:17, `explorarDesdeJson()`:31, `tecnicoDesdeJson()`:48
- `app/lib/features/explorar/data/explorar_repository_simulado.dart` — class `ExplorarRepositorySimulado`
  - `cargar()`:42, `entra()`:43

**domain**

- `app/lib/features/explorar/domain/explorar.dart` — enum `FiltroExplorar`, class `ServicioPopular`, class `IdeaExplorar`, class `TecnicoDestacado`, class `FotoTrabajo`, class `Explorar`, class `ExplorarRepository`
  - `deOficio()`:18

**presentation**

- `app/lib/features/explorar/presentation/explorar_controller.dart` — class `VistaExplorar`
- `app/lib/features/explorar/presentation/explorar_screen.dart` — class `ExplorarScreen`
  - `build()`:17

### home

**-**

- `panel/src/app/features/home/home.routes.ts` — —

**components**

- `panel/src/app/features/home/components/static-menu.component.ts` — class `StaticMenuComponent`

**pages**

- `panel/src/app/features/home/pages/home-page.component.ts` — class `HomePageComponent`

### inicio

**-**

- `app/lib/features/inicio/inicio.dart` — —
- `app/lib/features/inicio/inicio_providers.dart` — —
- `app/lib/features/inicio/zona_providers.dart` — class `EstadoZona`, class `ZonaSinElegir`, class `ZonaPideCodigoPostal`, class `ZonaPorUbicacion`, class `ZonaPorCodigoPostal`, class `ZonaController`
  - `build()`:40, `usarCodigoPostal()`:60

**data**

- `app/lib/features/inicio/data/colonia_mapper.dart` — class `ColoniaMapper`
  - `desdeContrato()`:7
- `app/lib/features/inicio/data/colonias_repository_http.dart` — class `ColoniasRepositoryHttp`
  - `enPunto()`:20
- `app/lib/features/inicio/data/colonias_repository_simulado.dart` — class `ColoniasRepositorySimulado`
  - `enPunto()`:11
- `app/lib/features/inicio/data/ubicacion_geolocator_repository.dart` — class `UbicacionGeolocatorRepository`
  - `permisoConcedido()`:19, `obtenerUnaVez()`:30, `abrirAjustes()`:75
- `app/lib/features/inicio/data/zona_mapper.dart` — class `ZonaMapper`
  - `zonaDesdeContrato()`:8, `registroDesdeContrato()`:24
- `app/lib/features/inicio/data/zonas_repository_http.dart` — class `ZonasRepositoryHttp`, class `ListaEsperaRepositoryHttp`
  - `porCodigoPostal()`:18, `registrar()`:37
- `app/lib/features/inicio/data/zonas_repository_simulado.dart` — class `ZonasRepositorySimulado`, class `ListaEsperaRepositorySimulado`
  - `porCodigoPostal()`:15, `registrar()`:43

**domain**

- `app/lib/features/inicio/domain/colonia.dart` — class `Colonia`, class `ResultadoColonia`
- `app/lib/features/inicio/domain/colonias_repository.dart` — class `ColoniasRepository`
- `app/lib/features/inicio/domain/punto_mapa.dart` — class `PuntoMapa`
  - `toString()`:28
- `app/lib/features/inicio/domain/ubicacion_repository.dart` — class `ResultadoUbicacion`, class `Concedida`, class `Denegada`, class `DenegadaParaSiempre`, class `ServicioDesactivado`, class `UbicacionRepository`
  - `toString()`:16
- `app/lib/features/inicio/domain/ubicar_con_aviso.dart` — —
  - `ubicarSiHayPermiso()`:24
- `app/lib/features/inicio/domain/zona.dart` — class `ResultadoZona`, class `RegistroListaEspera`
  - `esCodigoPostalValido()`:34
- `app/lib/features/inicio/domain/zonas_repository.dart` — class `ZonasRepository`, class `ListaEsperaRepository`

**presentation**

- `app/lib/features/inicio/presentation/colonia_controller.dart` — class `EstadoColonia`, class `ColoniaSinPedir`, class `ColoniaConsultando`, class `ColoniaEncontrada`, class `ColoniaFueraDeCobertura`, class `ColoniaSinUbicacion`, class `ColoniaConError`, class `ColoniaController`
  - `build()`:46
- `app/lib/features/inicio/presentation/inicio_screen.dart` — class `InicioScreen`, class `_TarjetaColonia`, class `_BarraBusqueda`
  - `build()`:24, `build()`:67, `consultar()`:70, `build()`:130
- `app/lib/features/inicio/presentation/mapa/boton_mi_ubicacion.dart` — class `BotonMiUbicacion`
  - `build()`:25, `FloatingActionButton()`:45
- `app/lib/features/inicio/presentation/mapa/mapa_con_pines.dart` — class `MapaConPines`, class `_MapaConPinesState`, class `_CamaraGoogleMap`
  - `didUpdateWidget()`:37, `build()`:45, `moverA()`:71
- `app/lib/features/inicio/presentation/mapa/marcadores.dart` — —
  - `construirMarcadores()`:16
- `app/lib/features/inicio/presentation/mapa/mi_ubicacion_controller.dart` — class `CamaraMapa`, enum `AvisoUbicacion`, class `MiUbicacionController`
  - `build()`:44, `abrirAjustes()`:73
- `app/lib/features/inicio/presentation/spike/mapa_spike_screen.dart` — class `MapaSpikeScreen`, class `_MapaSpikeScreenState`
  - `build()`:30, `Scaffold()`:31
- `app/lib/features/inicio/presentation/spike/pines_de_prueba.dart` — —
  - `pinesDePrueba()`:28
- `app/lib/features/inicio/presentation/zona/selector_de_zona.dart` — class `SelectorDeZona`, class `_SelectorDeZonaState`
  - `dispose()`:30, `build()`:53

### l10n

**-**

- `app/lib/l10n/generado/app_localizations.dart` — class `AppLocalizations`, class `_AppLocalizationsDelegate`
  - `of()`:70, `load()`:5423, `isSupported()`:5428, `shouldReload()`:5432, `lookupAppLocalizations()`:5435
- `app/lib/l10n/generado/app_localizations_en.dart` — class `AppLocalizationsEn`
  - `tecnicoCopia()`:22, `tecnicoCalificacion()`:30, `tecnicoAnios()`:35, `tecnicoRadio()`:49, `tecnicoLlega()`:61, `tecnicoNoLlega()`:66, `tecnicoDesde()`:77, `citaMonto()`:105, `citaTope()`:110, `solicitudVenceEnHoras()`:166, `solicitudVenceEl()`:177, `busquedaContador()`:197, `busquedaBuscamos()`:214, `busquedaSinResultadosOficio()`:231, `busquedaTotal()`:252, `busquedaEspera()`:270, `busquedaCalificacion()`:275, `busquedaDistancia()`:280, `busquedaVerificado()`:285, `entradaAceptoAviso()`:540, `entradaCodigoEnviadoA()`:603, `entradaReenviarEn()`:617, `previaExpertosCerca()`:699, `previaPinSemantica()`:710, `previaTarjetaSemantica()`:715 …
- `app/lib/l10n/generado/app_localizations_es.dart` — class `AppLocalizationsEs`
  - `tecnicoCopia()`:22, `tecnicoCalificacion()`:30, `tecnicoAnios()`:35, `tecnicoRadio()`:49, `tecnicoLlega()`:61, `tecnicoNoLlega()`:66, `tecnicoDesde()`:77, `citaMonto()`:105, `citaTope()`:110, `solicitudVenceEnHoras()`:166, `solicitudVenceEl()`:177, `busquedaContador()`:197, `busquedaBuscamos()`:214, `busquedaSinResultadosOficio()`:232, `busquedaTotal()`:253, `busquedaEspera()`:271, `busquedaCalificacion()`:276, `busquedaDistancia()`:281, `busquedaVerificado()`:286, `entradaAceptoAviso()`:542, `entradaCodigoEnviadoA()`:607, `entradaReenviarEn()`:621, `previaExpertosCerca()`:705, `previaPinSemantica()`:716, `previaTarjetaSemantica()`:721 …

### layout

**core**

- `panel/src/app/core/layout/app-shell.component.ts` — class `AppShellComponent`

### maqueta

**-**

- `app/lib/features/maqueta/agenda_real.dart` — class `AgendaReal`
  - `build()`:23
- `app/lib/features/maqueta/ampliar_real.dart` — class `AmpliarSolicitudReal`, enum `_Paso`, class `_AmpliarState`
  - `build()`:50
- `app/lib/features/maqueta/anim_k.dart` — class `Pulsa`, class `_PulsaState`, class `Aparece`, class `_ApareceState`, class `TransicionKnock`, class `ShimmerK`, class `_ShimmerKState`, class `BoneK`, class `EsqueletoLista`, class `CargaInicial`, class `_CargaInicialState`, class `PulsoInsignia`, class `_PulsoInsigniaState`, class `EsqueletoReputacion`
  - `sinMovimiento()`:20, `hapticoLigero()`:25, `hapticoExito()`:27, `hapticoSeleccion()`:29, `build()`:55, `Listener()`:57, `didChangeDependencies()`:90, `dispose()`:109, `build()`:116, `FadeTransition()`:118, `escalona()`:133, `buildTransitions()`:141, `didChangeDependencies()`:196, `dispose()`:209, `build()`:215, `AnimatedBuilder()`:219, `build()`:252, `build()`:271, `item()`:272, `didChangeDependencies()`:331, `dispose()`:346, `build()`:352, `initState()`:379, `didChangeDependencies()`:385, `didUpdateWidget()`:394 …
- `app/lib/features/maqueta/asistente_real.dart` — class `NotaIaDeEjemplo`, class `_Pantalla`, class `AsistenteChatReal`, class `_ChatState`, class `ResumenReal`, class `BorradorReal`, class `_BorradorEditable`, class `_BorradorState`, class `RangoReal`, class `BitacoraReal`, class `_BitacoraEditable`, class `_BitacoraState`
  - `build()`:30, `rutasAsistente()`:53, `build()`:94, `dispose()`:160, `build()`:177, `build()`:217, `build()`:243, `dispose()`:274, `build()`:282, `build()`:303, `build()`:342, `dispose()`:379, `build()`:410
- `app/lib/features/maqueta/avisos_reales.dart` — class `AvisosReales`, class `_Fila`, class `PreferenciasDeAvisosReales`, class `ContadorDeAvisos`
  - `build()`:79, `build()`:127, `build()`:158, `build()`:226
- `app/lib/features/maqueta/bandeja_trabajo_real.dart` — class `TarjetaDeCotizacionPropia`, class `SolicitudesNuevasReal`, class `_TarjetaDeSolicitud`, class `_TarjetaDeSolicitudState`, class `CotizacionesEnviadasReal`
  - `precioDeCotizacion()`:14, `build()`:29, `textosDeLista()`:55, `textoDeError()`:63, `filas()`:71, `hayMas()`:77, `reintentar()`:80, `cargarMas()`:84, `build()`:162, `textosDeLista()`:202, `textoDeError()`:210, `filas()`:218, `hayMas()`:223, `reintentar()`:226, `cargarMas()`:230
- `app/lib/features/maqueta/bloqueos_reales.dart` — class `PersonasBloqueadasReales`, class `_FilaBloqueada`, class `DesbloquearReal`, class `_DesbloquearRealState`, class `BloquearReal`, class `_ConfirmarBloqueo`, class `_ConfirmarBloqueoState`
  - `textosDeLista()`:30, `filas()`:42, `hayMas()`:47, `reintentar()`:50, `cargarMas()`:54, `build()`:64, `build()`:121, `build()`:148, `build()`:261
- `app/lib/features/maqueta/boton_conversacion.dart` — class `BotonConversacion`, class `_BotonConversacionState`
  - `build()`:76
- `app/lib/features/maqueta/busqueda_real.dart` — class `BusquedaReal`, class `_BusquedaRealState`, class `_SinZona`, class `_Error`, class `_Sugerencias`, class `_Resultados`, class `_Experto`
  - `initState()`:55, `dispose()`:61, `build()`:87, `Pg()`:93, `stack()`:148, `build()`:167, `build()`:183, `build()`:199, `build()`:219, `stack()`:245, `build()`:311
- `app/lib/features/maqueta/campo_buscar.dart` — class `CampoBuscarK`
  - `build()`:18
- `app/lib/features/maqueta/carga_k.dart` — enum `TipoCarga`, class `CargaK`, class `MensajesRotativos`, class `_MensajesRotativosState`, class `ExitoK`, class `_ExitoKState`
  - `build()`:76, `initState()`:122, `dispose()`:132, `build()`:138, `exitoRapido()`:182, `initState()`:219, `build()`:225
- `app/lib/features/maqueta/casa_y_auto_real.dart` — class `CasaYAutoReal`, class `_Fila`, class `_Formulario`, class `_FormularioState`
  - `build()`:18, `stack()`:21, `build()`:72, `Semantics()`:74, `nombreDeTipo()`:124, `textoDeErrorCasa()`:133, `abrirFormulario()`:188, `dispose()`:217, `build()`:255, `abrirHistorial()`:313, `hoja()`:325, `cargar()`:326
- `app/lib/features/maqueta/cobertura.dart` — class `ZonaKnock`, class `ResultadoCobertura`, class `PantallaFueraDeCobertura`
  - `distanciaKm()`:34, `evaluarCobertura()`:54, `build()`:104, `elegirZonaDisponible()`:182, `mostrarFueraDeCobertura()`:207, `hoja()`:211
- `app/lib/features/maqueta/confianza_real.dart` — class `ConfianzaReal`, class `_Tarjeta`, class `GuardarTecnicoReal`, class `_GuardarTecnicoState`
  - `idDeTecnicoReal()`:15, `build()`:33, `stack()`:36, `build()`:73, `build()`:140
- `app/lib/features/maqueta/conversacion_real.dart` — class `ConversacionReal`, class `_ConversacionRealState`, class `_Burbuja`
  - `initState()`:41, `didChangeAppLifecycleState()`:67, `dispose()`:101, `build()`:110, `LayoutBuilder()`:161, `NotificationListener()`:222, `PopupMenuButton()`:326, `build()`:355
- `app/lib/features/maqueta/conversaciones_reales.dart` — class `ConversacionesReales`, class `_ConversacionesRealesState`
  - `initState()`:24, `dispose()`:69, `build()`:76
- `app/lib/features/maqueta/cotizar_real.dart` — class `CotizarReal`, class `_Detalle`, class `_Envio`, class `_EnvioState`
  - `build()`:18, `build()`:46, `dispose()`:108, `build()`:157
- `app/lib/features/maqueta/datos.dart` — class `Cat`, class `Review`, class `Prov`
  - `guessCat()`:145, `longDate()`:648, `money()`:651, `nowH()`:661, `initials()`:666
- `app/lib/features/maqueta/detalle_oficio_real.dart` — class `FrasesDelOficio`
  - `build()`:31, `pedirOficioNuevo()`:70
- `app/lib/features/maqueta/direcciones_reales.dart` — class `DireccionesReales`, class `DireccionAlPedirReal`, class `_FormularioDireccion`, class `_FormularioState`, class `_Eliminar`, class `_EliminarState`
  - `build()`:59, `build()`:117, `editarDireccion()`:145, `dispose()`:173, `build()`:219, `build()`:295
- `app/lib/features/maqueta/disponible_hoy_real.dart` — class `DisponibleHoyReal`, class `_DisponibleHoyState`
  - `build()`:41
- `app/lib/features/maqueta/eliminar_real.dart` — class `PendientesReales`, class `EliminarCuentaReal`, class `_EliminarCuentaRealState`, class `AvisoDeEliminacionReal`, class `EliminadaReal`
  - `build()`:22, `dispose()`:85, `build()`:157, `build()`:238, `build()`:267, `BtnK()`:303
- `app/lib/features/maqueta/en_dict.dart` — —
- `app/lib/features/maqueta/entrada_maqueta.dart` — class `EntradaMaqueta`, class `_EntradaState`
  - `initState()`:65, `dispose()`:71, `build()`:311, `head()`:320
- `app/lib/features/maqueta/envio_de_visita.dart` — mixin `EnvioDeVisita`, class `ErrorDeCargaDeVisita`
  - `build()`:60
- `app/lib/features/maqueta/estado.dart` — class `Quote`, class `Adjust`, class `Resched`, class `Job`, enum `CargaReal`, class `Msg`, class `Notif`, class `Contacto`, class `Casa`, class `Solicitud`, class `AsisMsg`, class `Asis`, class `UserData`, class `MaquetaEstado`, class `AvisoToast`
  - `qTope()`:46, `fijarOficios()`:252, `fijarSolicitudesReales()`:268, `refresh()`:276, `cargarTelefono()`:284, `guardarTelefono()`:290, `olvidarTelefono()`:296, `dispose()`:302, `after()`:309, `toast()`:320, `job()`:324, `notif()`:334, `results()`:344, `convIds()`:362, `accepted()`:366, `toggleSave()`:371, `openChat()`:376, `sendMsg()`:381, `block()`:404, `unblock()`:409, `startReq()`:415, `sendReq()`:434, `agregarSolicitudReal()`:475, `startClientQuotes()`:481, `reach()`:491 …
- `app/lib/features/maqueta/explorar_maqueta.dart` — class `ExplorarMaqueta`
  - `build()`:29
- `app/lib/features/maqueta/explorar_real.dart` — class `ExplorarReal`, class `_Aviso`, class `_Seccion`, class `_Fila`, class `_Servicio`, class `_Fotos`, class `_Tecnico`
  - `iconoDeOficio()`:14, `fechaDeCopia()`:21, `dos()`:22, `build()`:41, `reintentar()`:44, `build()`:112, `build()`:131, `build()`:151, `build()`:169, `build()`:220, `foto()`:221, `build()`:280
- `app/lib/features/maqueta/fachada_maqueta.dart` — class `PantallasMaqueta`, class `ShellMaqueta`, class `RaizMaqueta`, class `_PuenteDeDatos`, class `_PuenteDeDatosState`
  - `previa()`:48, `entrada()`:49, `inicio()`:50, `explorar()`:51, `actividad()`:52, `trabajo()`:53, `cuenta()`:54, `conversacion()`:57, `configuracion()`:59, `rutaMaqueta()`:63, `Consumer()`:87, `build()`:260, `preparar()`:276, `conTransiciones()`:283, `envolver()`:291, `initState()`:314, `dispose()`:392, `build()`:400
- `app/lib/features/maqueta/globo_real.dart` — class `GloboReal`, class `AvisoCanalCaido`
  - `build()`:23, `GloboConversaciones()`:28, `build()`:49
- `app/lib/features/maqueta/horarios_reales.dart` — class `HorariosSegunSesion`, class `HorariosReales`
  - `build()`:21, `build()`:51
- `app/lib/features/maqueta/inicio_maqueta.dart` — class `InicioMaqueta`, class `_InicioMaquetaState`, class `_PuntoDeAvisos`
  - `initState()`:190, `dispose()`:223, `build()`:277, `MaqBuilder()`:303, `Scaffold()`:414, `build()`:885
- `app/lib/features/maqueta/lista_paginada_real.dart` — class `ListaPaginadaReal`, typedef `TextosDeLista`
  - `textoDeError()`:23, `build()`:29
- `app/lib/features/maqueta/lista_tecnicos_reales.dart` — class `ListaTecnicosReales`, class `_ListaTecnicosRealesState`
  - `build()`:37
- `app/lib/features/maqueta/llegada_real.dart` — class `LlegadaReal`, class `_LlegadaRealState`
  - `initState()`:31, `dispose()`:39, `build()`:46
- `app/lib/features/maqueta/mapa_google.dart` — class `MarcadorAgenda`, class `ControlMapaGoogle`, class `MapaGoogleKnock`, class `_MapaGoogleState`, class `ControlesMapaGoogle`
  - `posicionDeMundo()`:36, `posicionDeExperto()`:46, `vista()`:81, `acercar()`:87, `alejar()`:88, `moverA()`:91, `ir()`:98, `ajustar()`:101, `consultaDeVista()`:120, `grados()`:125, `dibujarPin()`:177, `initState()`:318, `dispose()`:331, `didUpdateWidget()`:380, `build()`:498, `build()`:549, `b()`:569, `ListenableBuilder()`:586
- `app/lib/features/maqueta/mapa_tecnicos_real.dart` — class `EstadoDelMapaReal`
  - `build()`:26, `abrirTecnicoDelMapa()`:54
- `app/lib/features/maqueta/nav.dart` — class `RM`
  - `experto()`:17, `opiniones()`:18, `enviada()`:21, `comparar()`:22, `visita()`:23, `cita()`:24, `calificar()`:25, `reportar()`:26, `bloquear()`:28, `compartir()`:29, `chat()`:31, `ayuda()`:43, `hayCuenta()`:47, `pedirCuenta()`:52, `registrarIrA()`:61, `elegirFotos()`:71
- `app/lib/features/maqueta/numero_real.dart` — enum `_Paso`, class `HojaDeNumeroReal`, class `_HojaDeNumeroState`
  - `dispose()`:40, `build()`:125
- `app/lib/features/maqueta/oficios_reales.dart` — class `AvisoOficios`
  - `build()`:11
- `app/lib/features/maqueta/opiniones_reales.dart` — class `_EstadoDeOpiniones`, class `_Resumen`, class `_Tarjeta`, class `OpinionesReales`, class `PerfilTecnicoReal`, class `CalificarReal`, class `_CalificarRealState`
  - `build()`:29, `aviso()`:33, `build()`:63, `build()`:87, `build()`:129, `build()`:173, `BtnK()`:213, `dispose()`:249, `build()`:326
- `app/lib/features/maqueta/pantalla_segun_sesion.dart` — class `PantallaSegunSesion`
  - `build()`:22
- `app/lib/features/maqueta/pantallas_actividad.dart` — class `Marca`, class `BarraMarcaK`, class `PgTab`, class `ActividadMaqueta`, class `MensajesScreen`, class `ChatScreen`, class `_ChatScreenState`, class `VisitaMaqueta`, class `CitaScreen`, class `CalificarScreen`, class `_CalificarScreenState`, class `BloquearScreen`, class `ReportarScreen`, class `_ReportarScreenState`, class `CompartirScreen`, class `_CompartirScreenState`
  - `build()`:42, `build()`:66, `build()`:131, `build()`:175, `msgFab()`:255, `Positioned()`:256, `GloboConversaciones()`:266, `jobCard()`:279, `jobChat()`:509, `adjustCard()`:561, `build()`:621, `InkWell()`:662, `initState()`:748, `dispose()`:763, `build()`:834, `reprogBlock()`:1270, `BtnK()`:1278, `reprogSheet()`:1287, `cancelBlock()`:1359, `cancelSheet()`:1367, `build()`:1417, `VisitaRealGate()`:1421, `build()`:1724, `VisitaRealGate()`:1728, `initState()`:1935 …
- `app/lib/features/maqueta/pantallas_buscar.dart` — class `BuscarScreen`, class `_BuscarScreenState`, class `PerfilScreen`, class `_PerfilScreenState`, class `OpinionesScreen`, class `_OpinionesScreenState`, class `AsistenteScreen`, class `_AsistenteScreenState`
  - `provCard()`:26, `CardK()`:28, `initState()`:90, `dispose()`:96, `build()`:160, `reviewW()`:397, `build()`:504, `PerfilTecnicoReal()`:509, `build()`:979, `initState()`:1163, `dispose()`:1182, `build()`:1281, `composerK()`:1519, `quickK()`:1525, `burbujaK()`:1527
- `app/lib/features/maqueta/pantallas_cuenta.dart` — class `CuentaMaqueta`, class `_Gl`, class `MiCasaScreen`, class `ConfianzaScreen`, class `ConfigMaqueta`, class `AvisosConfigScreen`, class `AvisosScreen`, class `AvisoScreen`, class `TerminosScreen`, class `PrivacidadScreen`, class `Eliminar1Screen`, class `_Eliminar1State`, class `Eliminar2Screen`, class `_Eliminar2State`, class `EliminadoScreen`, class `AyudaScreen`, class `_AyudaState`, class `SinConexionScreen`, class `_SinConexionState`
  - `hoja()`:44, `build()`:67, `MaqBuilder()`:79, `build()`:390, `editarDatos()`:396, `FieldK()`:461, `cambiarNumero()`:523, `e()`:540, `phone()`:541, `build()`:882, `build()`:944, `Pg()`:967, `CardK()`:987, `build()`:1032, `build()`:1163, `build()`:1228, `build()`:1409, `build()`:1480, `build()`:1538, `MaqBuilder()`:1540, `build()`:1672, `dispose()`:1794, `build()`:1800, `build()`:1859, `EliminadaReal()`:1861 …
- `app/lib/features/maqueta/pantallas_solicitud.dart` — class `SolicitarScreen`, class `_SolicitarScreenState`, class `EnviadaScreen`, class `CompararScreen`, class `_CompararScreenState`
  - `initState()`:83, `dispose()`:91, `build()`:148, `FieldK()`:428, `build()`:508, `step()`:514, `stateK0()`:631, `widenBlock()`:657, `initState()`:716, `dispose()`:741, `showModalBottomSheet()`:751, `build()`:1462, `CardK()`:1496, `BtnK()`:1615
- `app/lib/features/maqueta/pantallas_tecnico.dart` — class `Servicio`, class `TecRegistroScreen`, class `_TecRegistroState`, class `VerifScreen`, class `_VerifState`, class `PendienteScreen`, class `_PendienteState`, class `VerificadoScreen`, class `RechazadaScreen`, class `TrabajoMaqueta`, class `AgendaEnMapaBloque`, class `TecMensajesScreen`, class `TecChatScreen`, class `_TecChatState`
  - `registrarRutasTecnico()`:47, `dispose()`:160, `clean()`:239, `advErrors()`:241, `initState()`:290, `dispose()`:297, `build()`:533, `openVerif()`:908, `privacyCard()`:929, `BtnK()`:1110, `build()`:1135, `initState()`:1267, `dispose()`:1273, `build()`:1279, `build()`:1422, `build()`:1511, `visitCard()`:1605, `BtnK()`:1673, `reqCard()`:1830, `workFab()`:1881, `Positioned()`:1888, `build()`:1950, `verifRow()`:1962, `build()`:2265, `build()`:2365 …
- `app/lib/features/maqueta/pantallas_tecnico2.dart` — class `CotizarScreen`, class `_CotizarState`, class `IniciarScreen`, class `_IniciarState`, class `CerrarScreen`, class `_CerrarState`, class `PerfilEditarScreen`, class `_PerfilEditarState`, class `ReputacionScreen`, class `_ReputacionState`
  - `dispose()`:43, `doSend()`:58, `build()`:69, `upd()`:107, `seg()`:112, `BtnK()`:283, `FieldK()`:368, `dispose()`:475, `build()`:481, `Pg()`:485, `check()`:571, `dispose()`:666, `build()`:727, `BtnK()`:851, `initState()`:901, `dispose()`:921, `build()`:984, `dispose()`:1198, `build()`:1204
- `app/lib/features/maqueta/perfil_publico_real.dart` — class `PerfilPublicoReal`, class `_Resumen`, class `_Colonia`, class `_ColoniaState`, class `_Servicios`, class `_Fotos`
  - `build()`:56, `build()`:80, `build()`:130, `FutureBuilder()`:132, `build()`:172, `build()`:220
- `app/lib/features/maqueta/permiso_fotos_real.dart` — class `BotonPermisoFotosReal`, class `_HojaPermisoFotos`, class `PermisoFotosReal`, class `_PermisoFotosState`
  - `build()`:18, `build()`:36, `build()`:74
- `app/lib/features/maqueta/precio_de_visita_real.dart` — class `PrecioDeVisitaReal`, class `_TarjetaPorDecidir`, class `_TarjetaPorDecidirState`
  - `build()`:22, `NoteK()`:78, `build()`:159
- `app/lib/features/maqueta/precio_tecnico_real.dart` — class `PrecioTecnicoReal`, class `_HojaCotizacionFinal`, class `_FinalState`, class `_HojaAjuste`, class `_AjusteState`
  - `build()`:20, `stack()`:22, `dispose()`:58, `build()`:82, `dispose()`:131, `build()`:160
- `app/lib/features/maqueta/privacidad_real.dart` — class `ExportacionReal`, class `ConsentimientosReales`, class `_FilaConsentimiento`
  - `build()`:20, `pedir()`:49, `fechaDeCuenta()`:81, `build()`:112, `build()`:156
- `app/lib/features/maqueta/reportes_reales.dart` — class `ReportarReal`, class `_Formulario`, class `_FormularioState`, class `MisReportesReales`, class `_TarjetaDeReporte`, class `_TarjetaDeReporteState`
  - `build()`:40, `soloTexto()`:42, `dispose()`:101, `build()`:137, `textosDeLista()`:196, `filas()`:208, `hayMas()`:214, `reintentar()`:217, `cargarMas()`:221, `dispose()`:241, `build()`:268
- `app/lib/features/maqueta/reputacion_real.dart` — class `ReputacionReal`
  - `build()`:12, `aviso()`:17
- `app/lib/features/maqueta/rutas_tecnico.dart` — class `RT`
  - `chat()`:9, `cotizar()`:10, `iniciar()`:11, `cerrar()`:12
- `app/lib/features/maqueta/servicios_reales.dart` — class `MisServiciosSegunSesion`, class `MisServiciosReales`, class `_MisServiciosState`, class `_FilaDeServicio`, class `FormularioDeServicio`, class `_FormularioState`, class `ServiciosDeTecnicoReal`
  - `build()`:26, `build()`:105, `stack()`:119, `build()`:192, `dispose()`:240, `build()`:284, `build()`:344
- `app/lib/features/maqueta/sesiones_reales.dart` — class `SesionesAbiertas`
  - `build()`:16, `GroupK()`:20, `BtnK()`:82, `haceTiempo()`:117
- `app/lib/features/maqueta/solicitudes_reales.dart` — —
  - `claveDeOficio()`:19, `estadoDeJob()`:33, `preferenciaDeSolicitud()`:47, `jobDeSolicitud()`:57, `cuandoDeCotizacion()`:87, `provDeTecnico()`:93, `quoteDeCotizacion()`:120, `textoDeErrorReal()`:140, `provDeVisita()`:165, `aplicarVisitaAlJob()`:193, `coloniaIdDeLaPersona()`:211, `crearSolicitudReal()`:233
- `app/lib/features/maqueta/tecnico_estado.dart` — class `Cliente`, class `Cot`, class `Borrador`, class `Bitacora`, class `Req`, class `Visita`, class `Opinion`, class `Trabajo`, class `AvisoT`, class `Yo`, class `TecEstado`
  - `cliente()`:18, `copy()`:89, `seed()`:261, `dl()`:262, `seedDemo()`:340, `req()`:419, `reqOfClient()`:420, `visita()`:421, `dayLabel()`:432, `verifLabel()`:441, `register()`:453, `defaultSvcs()`:493, `syncMe()`:509, `verifSkip()`:587, `verifSend()`:596, `startTicker()`:619, `dispose()`:661, `ensureThread()`:664, `workerMsgs()`:668, `t()`:680, `workerSay()`:707, `reject()`:732, `dayIndexFor()`:807, `norm()`:808, `summary0()`:823 …
- `app/lib/features/maqueta/terminar_servicio_real.dart` — class `TerminarServicioReal`, class `_TerminarState`
  - `dispose()`:44, `build()`:81
- `app/lib/features/maqueta/trabajo_real.dart` — class `TrabajoSegunSesion`, class `_TrabajoReal`, class `_TrabajoRealState`
  - `build()`:25, `initState()`:45, `dispose()`:51, `build()`:79
- `app/lib/features/maqueta/ui.dart` — class `KC`, class `T`, enum `Bk`, class `BtnK`, class `LinkK`, class `CardK`, class `Pill`, class `NoteK`, class `Av`, class `Stars`, class `ChipK`, class `ChoiceK`, class `GroupK`, class `LiK`, class `FoldK`, class `_FoldKState`, class `Sw`, class `Prog`, class `FieldK`, class `PhoneCc`, class `PhotoTile`, class `AddPhoto`, class `Pg`, class `MaqBuilder`, class `AvisosHost`, class `_AvisosHostState`
  - `tr()`:29, `hit()`:32, `kc()`:99, `build()`:136, `h1()`:150, `h2()`:153, `h3()`:155, `bT()`:157, `tT()`:159, `sMut()`:162, `mutT()`:172, `labT()`:175, `fechaLegible()`:179, `stack()`:197, `rowW()`:208, `icn()`:223, `build()`:307, `build()`:403, `build()`:436, `build()`:494, `build()`:545, `rich()`:575, `build()`:626, `build()`:685, `rateW()`:706 …
- `app/lib/features/maqueta/verificacion_real.dart` — class `EstadoDeVerificacionReal`, class `_EstadoState`
  - `initState()`:23, `dispose()`:31, `build()`:37
- `app/lib/features/maqueta/visita_acciones_reales.dart` — class `AccionesVisitaReal`, class `BotonNoTerminadoReal`, class `_HojaDeEnvio`, class `_HojaDeEnvioState`
  - `build()`:24, `build()`:72, `hojaClienteAusente()`:83, `elegida()`:181, `aTiempo()`:187, `dispose()`:297, `build()`:316
- `app/lib/features/maqueta/visita_real.dart` — class `VisitaRealGate`
  - `build()`:29, `textoDeMotivoDeCodigo()`:75

### mensajes

**-**

- `app/lib/features/mensajes/mensajes.dart` — —
- `app/lib/features/mensajes/mensajes_providers.dart` — —

**data**

- `app/lib/features/mensajes/data/canal_mensajes_signalr.dart` — class `CanalMensajesSignalR`
  - `unirse()`:66, `salir()`:84, `cerrar()`:97, `mensajeDelCanal()`:110, `totalDeNoLeidos()`:143
- `app/lib/features/mensajes/data/conversaciones_repository_api.dart` — class `ConversacionesRepositoryApi`
  - `consultar()`:24, `contador()`:44, `abrir()`:55, `detalle()`:73, `mensajes()`:99, `marcarLeido()`:118, `enviar()`:139

**domain**

- `app/lib/features/mensajes/domain/canal_mensajes.dart` — class `CanalMensajes`
- `app/lib/features/mensajes/domain/conversacion.dart` — class `Conversacion`, class `ContraparteConversacion`, class `UltimoMensaje`, class `ContadorDeNoLeidos`, class `ResumenConversaciones`
- `app/lib/features/mensajes/domain/conversacion_abierta.dart` — class `DetalleDeConversacion`, class `PaginaDeMensajes`, class `MensajeEnVivo`, class `LecturaDeConversacion`
- `app/lib/features/mensajes/domain/conversaciones_repository.dart` — class `ConversacionesRepository`
- `app/lib/features/mensajes/domain/envio_de_mensajes.dart` — class `EnvioDeMensajes`
- `app/lib/features/mensajes/domain/mensaje.dart` — class `Mensaje`, enum `MotivoTextoInvalido`, class `TextoDeMensaje`
  - `preparar()`:46, `validar()`:49

**presentation**

- `app/lib/features/mensajes/presentation/campo_envio_mensaje.dart` — class `CampoEnvioMensaje`, class `_CampoEnvioMensajeState`, class `_MensajePropioVista`
  - `textoDeFallaDeEnvio()`:12, `initState()`:62, `didUpdateWidget()`:69, `dispose()`:96, `build()`:103, `build()`:160
- `app/lib/features/mensajes/presentation/conversacion_controller.dart` — class `EstadoDeConversacion`, class `_EnvioConHuella`, class `ConversacionController`
  - `enviar()`:74, `visible()`:121, `cargar()`:131, `releer()`:159, `cargarAnteriores()`:234, `canalConectado()`:278, `canalCaido()`:285, `limpiar()`:288, `dispose()`:358
- `app/lib/features/mensajes/presentation/conversaciones_controller.dart` — class `EstadoConversaciones`, class `ConversacionesController`
  - `reintentar()`:33, `cargarMas()`:71, `canalConectado()`:118, `canalDesconectado()`:122, `actualizarTotalDesdeServidor()`:135, `limpiar()`:148, `dispose()`:161
- `app/lib/features/mensajes/presentation/envio_mensajes_controller.dart` — enum `EstadoDeEnvio`, class `MensajePropio`, class `EstadoEnvioMensajes`, class `EnvioMensajesController`
  - `enviar()`:92, `reintentar()`:134, `descartar()`:168, `limpiar()`:206, `marcarCerrada()`:209, `dispose()`:284
- `app/lib/features/mensajes/presentation/globo_controller.dart` — class `EstadoGlobo`, class `GloboController`
  - `build()`:44, `reintentar()`:58, `actualizar()`:64

### mi

**-**

- `app/lib/features/mi/mi.dart` — —
- `app/lib/features/mi/mi_providers.dart` — —

**data**

- `app/lib/features/mi/data/casa_y_auto_repository_api.dart` — class `CasaYAutoRepositoryApi`
  - `listar()`:19, `agregar()`:26, `editar()`:44, `quitar()`:64, `historial()`:76, `elementoDesdeJson()`:108, `paginaDesdeJson()`:134
- `app/lib/features/mi/data/casa_y_auto_repository_simulado.dart` — class `CasaYAutoRepositorySimulado`
  - `listar()`:15, `agregar()`:18, `editar()`:39, `quitar()`:60, `historial()`:67

**domain**

- `app/lib/features/mi/domain/casa_y_auto.dart` — enum `TipoElemento`, class `ElementoCasa`, class `TrabajoDelElemento`, class `PaginaHistorial`, enum `CampoElemento`, class `ReglasElemento`, class `CasaYAutoRepository`
  - `deClave()`:13, `anioMaximo()`:77, `validar()`:81

**presentation**

- `app/lib/features/mi/presentation/casa_y_auto_controller.dart` — class `CasaYAutoController`, class `HistorialElemento`
  - `build()`:12, `reintentar()`:16, `agregar()`:18, `editar()`:29, `quitar()`:44, `cargarMas()`:89

### notificaciones

**core**

- `app/lib/core/notificaciones/avisos_provider.dart` — class `PreferenciasAvisos`, class `AvisosNotifier`, class `ConversacionAbiertaNotifier`
  - `recibe()`:28, `build()`:33, `elegir()`:42, `build()`:67, `abrir()`:69
- `app/lib/core/notificaciones/carga_notificacion.dart` — enum `DestinoNotificacion`, class `CargaNotificacion`
  - `desde()`:39, `toString()`:82
- `app/lib/core/notificaciones/contenido_notificacion.dart` — enum `MotivoSensible`
  - `revisarTextoDeNotificacion()`:27, `esTextoSeguro()`:34
- `app/lib/core/notificaciones/navegacion_notificaciones.dart` — —
  - `abrirPantallaDesdeNotificaciones()`:13, `abrir()`:14
- `app/lib/core/notificaciones/registro_dispositivo_controller.dart` — class `EstadoRegistro`, class `SinRegistrar`, class `SinPermisoDeNotificaciones`, class `SinIdentificador`, class `RegistroFallido`, class `Registrado`, class `RegistroDispositivoController`
  - `toString()`:38, `build()`:48, `alIniciarSesion()`:52, `alCerrarSesion()`:86
- `app/lib/core/notificaciones/registro_dispositivos.dart` — class `RegistroDispositivosRepository`, class `RegistroDispositivosSimulado`
  - `registrar()`:21, `desregistrar()`:27
- `app/lib/core/notificaciones/servicio_notificaciones.dart` — class `ServicioNotificaciones`, class `ServicioNotificacionesNoDisponible`
  - `obtenerIdentificador()`:30, `borrarIdentificador()`:33, `toqueInicial()`:39

### oficios

**-**

- `app/lib/features/oficios/oficios.dart` — —
- `app/lib/features/oficios/oficios_providers.dart` — —

**data**

- `app/lib/features/oficios/data/detalle_oficio_repository_api.dart` — class `DetalleOficioRepositoryApi`
  - `detalle()`:16, `pedirOficio()`:34
- `app/lib/features/oficios/data/oficio_mapper.dart` — class `OficioMapper`
  - `listaDesdeContrato()`:13, `desdeContrato()`:21
- `app/lib/features/oficios/data/oficios_repository_api.dart` — class `OficiosRepositoryApi`
  - `listar()`:25, `observar()`:28
- `app/lib/features/oficios/data/oficios_repository_de_prueba.dart` — class `OficiosRepositoryDePrueba`
  - `listar()`:24
- `app/lib/features/oficios/data/oficios_repository_http.dart` — class `OficiosRepositoryHttp`
  - `listar()`:15

**domain**

- `app/lib/features/oficios/domain/detalle_oficio.dart` — class `DetalleOficio`, class `DetalleOficioRepository`
- `app/lib/features/oficios/domain/modalidad.dart` — class `Modalidad`
- `app/lib/features/oficios/domain/oficio.dart` — class `Oficio`
- `app/lib/features/oficios/domain/oficios_repository.dart` — class `OficiosRepository`
- `app/lib/features/oficios/domain/resultado_oficios.dart` — class `ResultadoOficios`, class `OficiosRepositoryConCache`

**presentation**

- `app/lib/features/oficios/presentation/detalle_oficio_controller.dart` — class `VistaDetalleOficio`, class `DetalleOficioController`
  - `build()`:30
- `app/lib/features/oficios/presentation/oficios_controller.dart` — class `OficiosSinConexion`, class `OficiosController`
  - `build()`:12, `fijar()`:14, `build()`:26, `reintentar()`:53
- `app/lib/features/oficios/presentation/oficios_screen.dart` — class `OficiosScreen`, class `_AvisoSinConexion`, class `_Cargando`, class `_Vacio`, class `_ConError`, class `_Lista`, class `_FilaOficio`
  - `build()`:19, `build()`:58, `build()`:83, `build()`:92, `build()`:104, `build()`:120, `build()`:136

### opiniones

**-**

- `app/lib/features/opiniones/opiniones.dart` — —
- `app/lib/features/opiniones/opiniones_providers.dart` — —

**data**

- `app/lib/features/opiniones/data/opiniones_repository_api.dart` — class `OpinionesRepositoryApi`
  - `listar()`:18, `calificar()`:35, `responder()`:68

**domain**

- `app/lib/features/opiniones/domain/opinion.dart` — class `PartesDeOpinion`, class `RespuestaDeOpinion`, class `Opinion`, class `ResumenDeOpiniones`, class `PaginaOpiniones`, class `NuevaOpinion`, class `OpinionCreada`, class `OpinionesRepository`

**presentation**

- `app/lib/features/opiniones/presentation/opiniones_controller.dart` — class `VistaOpiniones`, class `OpinionesController`
  - `build()`:40, `reintentar()`:56, `cursorDe()`:59, `pedirPagina()`:62, `unirPaginas()`:70

### panel

**-**

- `panel/src/app/app.routes.ts` — —
- `panel/src/app/app.ts` — class `App`
- `panel/src/main.ts` — —

### permisos

**core**

- `app/lib/core/permisos/explicacion_permiso.dart` — —
  - `explicarPermiso()`:10
- `app/lib/core/permisos/gestor_permisos.dart` — enum `PermisoApp`, enum `EstadoPermiso`, class `GestorPermisos`, class `GestorPermisosNoDisponible`
  - `estado()`:39, `pedir()`:43, `abrirAjustes()`:47

### plataforma

**core**

- `app/lib/core/plataforma/captura_en_recientes.dart` — class `CapturaEnRecientes`, class `CapturaEnRecientesAndroid`
  - `permitir()`:17
- `app/lib/core/plataforma/compartir.dart` — class `CompartidorDeTexto`, class `CompartidorDelSistema`
  - `compartir()`:14
- `app/lib/core/plataforma/modo_noche_de_la_app.dart` — class `ModoNocheDeLaApp`, class `ModoNocheDeLaAppAndroid`
  - `codigo()`:26, `fijar()`:33

### preferencias

**core**

- `app/lib/core/preferencias/almacen_avisos.dart` — enum `TipoAviso`, class `AlmacenAvisos`, mixin `AvisosSobreShared`, mixin `AvisosEnMemoria`
  - `claveDeAviso()`:28, `leerAviso()`:34, `guardarAviso()`:40, `leerAviso()`:48, `guardarAviso()`:51
- `app/lib/core/preferencias/almacen_borrador_solicitud.dart` — class `AlmacenBorradorSolicitud`, mixin `BorradorSobreShared`, mixin `BorradorEnMemoria`
  - `leerBorrador()`:28, `guardarBorrador()`:40, `borrarBorrador()`:47, `leerBorrador()`:55, `guardarBorrador()`:58, `borrarBorrador()`:62
- `app/lib/core/preferencias/almacen_preferencias.dart` — class `AlmacenPreferencias`, class `AlmacenPreferenciasShared`, class `AlmacenPreferenciasEnMemoria`
  - `leerTema()`:53, `leerIdioma()`:56, `guardarTema()`:59, `guardarIdioma()`:63, `leerTema()`:79, `leerIdioma()`:82, `guardarTema()`:85, `guardarIdioma()`:88
- `app/lib/core/preferencias/arranque.dart` — —
- `app/lib/core/preferencias/directorio_fotos_borrador.dart` — —
  - `directorioFotosBorrador()`:14, `borrarBorradorDeSolicitud()`:30
- `app/lib/core/preferencias/preferencias_provider.dart` — class `Preferencias`, class `PreferenciasNotifier`
  - `copyWith()`:25, `build()`:47, `cambiarTema()`:55, `cambiarIdioma()`:61

### previa

**-**

- `app/lib/features/previa/demo/datos_de_ejemplo.dart` — class `ExpertoDeEjemplo`

**domain**

- `app/lib/features/previa/domain/requerir_cuenta.dart` — —
- `app/lib/features/previa/domain/vista_mapa.dart` — class `VistaMapa`
  - `kMin()`:33, `acotada()`:37, `inicial()`:48, `zoomEn()`:53, `desplazada()`:64, `toString()`:79

**presentation**

- `app/lib/features/previa/presentation/barra_marca.dart` — class `BarraMarca`
  - `build()`:17
- `app/lib/features/previa/presentation/buscador_previa.dart` — class `BuscadorPrevia`
  - `build()`:15
- `app/lib/features/previa/presentation/catalogo_previa.dart` — class `CatalogoPrevia`, class `_AvisoSinConexion`, class `_FilaOficio`
  - `build()`:22, `build()`:80, `build()`:110
- `app/lib/features/previa/presentation/chips_oficio.dart` — class `ChipsOficio`
  - `build()`:28
- `app/lib/features/previa/presentation/hoja_invitacion.dart` — class `_HojaInvitacion`
  - `mostrarHojaInvitacion()`:12, `showModalBottomSheet()`:14, `build()`:33
- `app/lib/features/previa/presentation/mapa/controlador_mapa.dart` — class `ControladorMapa`
  - `ajustarCaja()`:20, `acercar()`:36, `alejar()`:38, `ubicarme()`:53, `gesto()`:59, `dispose()`:75
- `app/lib/features/previa/presentation/mapa/lienzo_mapa.dart` — class `LienzoMapa`, class `_Avenida`
  - `paint()`:24, `shouldRepaint()`:37
- `app/lib/features/previa/presentation/mapa/mapa_previa.dart` — class `MapaPrevia`, class `_MapaPreviaState`, class `_Capas`, class `_PuntoYo`, class `ControlesMapa`, class `_Boton`
  - `build()`:48, `LayoutBuilder()`:54, `GestureDetector()`:57, `build()`:135, `build()`:179, `build()`:199, `build()`:237
- `app/lib/features/previa/presentation/mapa/pin_experto.dart` — class `PinExperto`, class `_Punta`
  - `colorDeOficio()`:8, `iconoDeOficio()`:16, `build()`:37, `paint()`:110, `shouldRepaint()`:120
- `app/lib/features/previa/presentation/panel_expertos.dart` — class `TamanosPanel`, class `PanelExpertos`, class `_PanelExpertosState`, class `_Asa`, class `_Encabezado`, class `_TarjetaExplorar`, class `_TarjetaExperto`
  - `dispose()`:58, `build()`:70, `NotificationListener()`:74, `build()`:154, `build()`:183, `build()`:241, `abrir()`:245, `build()`:303
- `app/lib/features/previa/presentation/previa_oficios_screen.dart` — class `PreviaOficiosScreen`
  - `build()`:12
- `app/lib/features/previa/presentation/previa_screen.dart` — class `PreviaScreen`, class `_PreviaScreenState`, class `_Superior`
  - `dispose()`:46, `build()`:59, `build()`:157
- `app/lib/features/previa/presentation/rotulo_ejemplo.dart` — class `RotuloDeEjemplo`
  - `build()`:12

### red

**core**

- `app/lib/core/red/cache_respuestas.dart` — class `EntradaCache`, class `CacheRespuestas`, class `ClienteConCache`
  - `obtener()`:38, `guardar()`:48, `borrarTodo()`:63, `send()`:85, `close()`:132
- `app/lib/core/red/cliente_api_provider.dart` — —
  - `usaApiReal()`:29
- `app/lib/core/red/configuracion_api.dart` — —
  - `validarConfiguracionApi()`:11, `normalizarUrlApi()`:24
- `app/lib/core/red/contrato_json.dart` — —
  - `objetoDelContrato()`:10, `listaDelContrato()`:16, `textoObligatorio()`:22, `textoOpcional()`:30, `booleanoObligatorio()`:37, `enteroObligatorio()`:43, `fechaHoraObligatoria()`:49, `enviarJsonONoEncontrado()`:58
- `app/lib/core/red/enviar_json.dart` — class `RespuestaJson`
  - `enviarJson()`:35
- `app/lib/core/red/errores_api.dart` — —
  - `mapearErrorApi()`:11
- `app/lib/core/red/espera_por_limite.dart` — class `ClienteConEspera`
  - `send()`:32, `close()`:75
- `app/lib/core/red/obtener_json.dart` — —
  - `obtenerJson()`:11
- `app/lib/core/red/paginas_por_cursor.dart` — mixin `PaginasPorCursor`
  - `cargarMas()`:18

### reportes

**-**

- `app/lib/features/reportes/reportes.dart` — —
- `app/lib/features/reportes/reportes_providers.dart` — —

**data**

- `app/lib/features/reportes/data/reportes_repository_api.dart` — class `ReportesRepositoryApi`
  - `destinoDeVisita()`:18, `crear()`:36, `listar()`:74, `apelar()`:80, `bloquear()`:97, `desbloquear()`:113, `bloqueados()`:117

**domain**

- `app/lib/features/reportes/domain/reporte.dart` — enum `MotivoDeReporte`, class `DestinoDeReporte`, class `NuevoReporte`, class `ReporteCreado`, class `ResumenDeReporte`, class `PaginaReportes`, class `PersonaBloqueada`, class `PaginaBloqueados`, class `ReportesRepository`, class `BloqueosRepository`
  - `desdeTexto()`:20

**presentation**

- `app/lib/features/reportes/presentation/bloqueos_controller.dart` — class `BloqueosController`
  - `build()`:13, `reintentar()`:19, `cursorDe()`:22, `pedirPagina()`:25, `unirPaginas()`:30, `bloquear()`:40, `desbloquear()`:51
- `app/lib/features/reportes/presentation/mis_reportes_controller.dart` — class `MisReportesController`
  - `build()`:13, `reintentar()`:19, `cursorDe()`:22, `pedirPagina()`:25, `unirPaginas()`:30, `apelar()`:37

### router

**core**

- `app/lib/core/router/app_router.dart` — —
- `app/lib/core/router/app_shell.dart` — class `_Destino`, class `AppShell`
  - `ramasVisibles()`:36, `build()`:62
- `app/lib/core/router/destino_de_regreso_provider.dart` — class `DestinoDeRegreso`
  - `build()`:10, `recordar()`:13, `olvidar()`:18
- `app/lib/core/router/rutas.dart` — class `Rutas`
  - `solicitud()`:25, `cotizaciones()`:29, `visita()`:33, `conversacion()`:38, `esRutaPublica()`:78, `redireccionPorSesion()`:101, `rutaDeEntrada()`:119, `destinoDeRegreso()`:138, `destinoValidoODescartar()`:143, `redireccionPorRol()`:171, `redireccionPorPerfil()`:181

### sesion

**core**

- `app/lib/core/sesion/almacen_seguro.dart` — class `AlmacenSeguro`, class `AlmacenSeguroEnMemoria`, class `AlmacenSeguroFlutterSecureStorage`
  - `leer()`:25, `escribir()`:28, `borrar()`:32, `leer()`:46, `escribir()`:49, `borrar()`:53
- `app/lib/core/sesion/almacen_sesion.dart` — class `AlmacenSesion`
  - `guardar()`:24, `leerAcceso()`:32, `leerRefresco()`:34, `cerrarSesion()`:39
- `app/lib/core/sesion/arranque_sesion.dart` — —
  - `iniciarFirebase()`:17, `leerTokensGuardados()`:31
- `app/lib/core/sesion/canje_sesion.dart` — class `SesionEmitida`, class `CanjeSesion`, class `CanjeSesionApi`
  - `toString()`:24, `canjear()`:46
- `app/lib/core/sesion/cliente_autenticado.dart` — class `ClienteAutenticado`
  - `send()`:42, `close()`:84
- `app/lib/core/sesion/datos_de_visita.dart` — —
  - `leerIndiceDeVisitas()`:21, `escribirIndiceDeVisitas()`:32, `borrarDatosDeVisita()`:40
- `app/lib/core/sesion/es_tecnico_provider.dart` — class `EsTecnicoNotifier`
  - `build()`:13, `cambiar()`:16
- `app/lib/core/sesion/identificador_dispositivo.dart` — class `IdentificadorDispositivo`
  - `obtener()`:25
- `app/lib/core/sesion/preparar_canje.dart` — class `PrepararCanje`
  - `preparar()`:18
- `app/lib/core/sesion/renovador_sesion_api.dart` — class `RenovadorSesionApi`
  - `renovar()`:21
- `app/lib/core/sesion/servicio_entrada.dart` — class `ResultadoEntrada`, class `ServicioEntrada`, class `ServicioEntradaReal`
  - `enviarCodigo()`:48, `verificarCodigo()`:54
- `app/lib/core/sesion/sesion.dart` — class `TokensSesion`, class `RenovadorSesion`, class `RenovadorNoDisponible`, class `SesionNotifier`, class `CierresDeSesion`
  - `toString()`:34, `renovar()`:51, `build()`:66, `iniciar()`:69, `cerrar()`:83, `renovar()`:106, `build()`:195, `registrar()`:197
- `app/lib/core/sesion/sesion_provider.dart` — class `SesionNotifier`
  - `build()`:28, `iniciar()`:31, `cerrar()`:34, `nombreDeDispositivo()`:53
- `app/lib/core/sesion/verificador_celular.dart` — class `SolicitudCodigo`, class `VerificadorCelular`, class `VerificadorNoConfigurado`
  - `toString()`:26, `enviarCodigo()`:52, `tokenDeId()`:58, `cerrarSesion()`:62
- `app/lib/core/sesion/verificador_celular_firebase.dart` — class `VerificadorCelularFirebase`
  - `enviarCodigo()`:21, `tokenDeId()`:66, `cerrarSesion()`:84, `mapearErrorFirebase()`:88

### suspension

**-**

- `app/lib/features/suspension/suspension.dart` — —
- `app/lib/features/suspension/suspension_providers.dart` — —

**data**

- `app/lib/features/suspension/data/apelacion_suspension_repository_api.dart` — class `ApelacionSuspensionRepositoryApi`
  - `consultar()`:45, `presentar()`:49

**domain**

- `app/lib/features/suspension/domain/apelacion_suspension.dart` — class `ApelacionDeSuspension`, class `ApelacionSuspensionRepository`
  - `textoDeApelacionValido()`:22

**presentation**

- `app/lib/features/suspension/presentation/apelacion_controller.dart` — enum `PasoDeApelacion`, class `ApelacionUiState`, class `ApelacionController`
  - `build()`:49, `enviarCodigo()`:53, `verificar()`:58, `reenviarCodigo()`:75, `cambiarNumero()`:91, `reintentarConsulta()`:97, `presentar()`:113
- `app/lib/features/suspension/presentation/apelacion_screen.dart` — class `ApelacionScreen`, class `_ApelacionScreenState`
  - `dispose()`:32, `build()`:88

### tecnico

**-**

- `app/lib/features/tecnico/tecnico.dart` — —
- `app/lib/features/tecnico/tecnico_providers.dart` — —

**data**

- `app/lib/features/tecnico/data/buscar_tecnicos_repository_api.dart` — class `BuscarTecnicosRepositoryApi`
  - `listar()`:14, `mapa()`:51
- `app/lib/features/tecnico/data/disponible_hoy_repository_api.dart` — class `DisponibleHoyRepositoryApi`
  - `consultar()`:17
- `app/lib/features/tecnico/data/horarios_repository_api.dart` — class `HorariosRepositoryApi`
  - `horarios()`:19, `guardar()`:23, `cambiarDisponibilidad()`:37
- `app/lib/features/tecnico/data/perfil_publico_repository_api.dart` — class `PerfilPublicoRepositoryApi`
  - `perfil()`:33, `servicios()`:53, `fotos()`:59, `llegaAColonia()`:67, `texto()`:91
- `app/lib/features/tecnico/data/reputacion_repository_api.dart` — class `ReputacionRepositoryApi`
  - `obtener()`:13
- `app/lib/features/tecnico/data/servicios_repository_api.dart` — class `ServiciosRepositoryApi`
  - `deTecnico()`:22, `agregar()`:36, `editar()`:40, `quitar()`:44
- `app/lib/features/tecnico/data/tecnico_repository_api.dart` — class `TecnicoRepositoryApi`
  - `registrar()`:17, `cuerpoDeAlta()`:69

**domain**

- `app/lib/features/tecnico/domain/alta_tecnico.dart` — enum `Atencion`, class `AltaTecnico`, class `PerfilTecnico`, class `TecnicoRepository`
- `app/lib/features/tecnico/domain/buscar_tecnicos.dart` — class `TecnicoEncontrado`, class `PaginaTecnicos`, class `GrupoMapa`, typedef `ConsultaMapa`
- `app/lib/features/tecnico/domain/disponible_hoy.dart` — class `DisponibleHoyRepository`
- `app/lib/features/tecnico/domain/horarios.dart` — enum `DiaSemana`, typedef `Franja`, class `HorarioDelDia`, class `Disponibilidad`, class `HorariosRepository`
- `app/lib/features/tecnico/domain/perfil_publico.dart` — class `DetallePerfil`, class `PerfilPublico`, class `ServicioPublico`, class `FotoDeTrabajo`, class `PaginaFotos`, class `PerfilPublicoRepository`
- `app/lib/features/tecnico/domain/reputacion.dart` — class `Reputacion`, class `ReputacionRepository`
- `app/lib/features/tecnico/domain/servicios.dart` — class `ServicioTecnico`, class `DatosDeServicio`, enum `RechazoDeServicio`, typedef `ServicioGuardado`, class `ServiciosRepository`

**presentation**

- `app/lib/features/tecnico/presentation/horarios_controller.dart` — class `HorariosController`
  - `franjasDeLaMaqueta()`:9, `build()`:24, `reintentar()`:30, `franjasParaAbrir()`:33, `cambiar()`:38
- `app/lib/features/tecnico/presentation/lista_tecnicos_controller.dart` — typedef `FiltrosTecnicos`, class `ListaTecnicosController`
  - `build()`:28, `reintentar()`:46, `cursorDe()`:49, `pedirPagina()`:51, `unirPaginas()`:53
- `app/lib/features/tecnico/presentation/mapa_tecnicos_controller.dart` — class `MapaTecnicosController`
  - `build()`:13, `reintentar()`:27
- `app/lib/features/tecnico/presentation/perfil_publico_controller.dart` — class `ConFecha`, class `FotosDeTrabajosController`
  - `build()`:79, `reintentar()`:82, `cursorDe()`:85, `pedirPagina()`:89
- `app/lib/features/tecnico/presentation/reputacion_controller.dart` — class `VistaReputacion`, class `_Copia`, class `ReputacionController`
  - `build()`:25, `reintentar()`:40
- `app/lib/features/tecnico/presentation/servicios_controller.dart` — typedef `ServiciosVistos`, class `MiTecnicoId`, typedef `MisServicios`, class `MisServiciosController`
  - `build()`:47, `recordar()`:52, `build()`:65, `reintentar()`:75, `guardar()`:79, `quitar()`:100

### tecnicos_confianza

**-**

- `app/lib/features/tecnicos_confianza/tecnicos_confianza.dart` — —
- `app/lib/features/tecnicos_confianza/tecnicos_confianza_providers.dart` — —

**data**

- `app/lib/features/tecnicos_confianza/data/tecnicos_confianza_repository_api.dart` — class `TecnicosConfianzaRepositoryApi`
  - `listar()`:22, `guardar()`:38, `quitar()`:50

**domain**

- `app/lib/features/tecnicos_confianza/domain/tecnico_confianza.dart` — class `TecnicoDeConfianza`, class `PaginaTecnicosConfianza`, class `ResultadoGuardado`
  - `toString()`:19
- `app/lib/features/tecnicos_confianza/domain/tecnicos_confianza_repository.dart` — class `TecnicosConfianzaRepository`

**presentation**

- `app/lib/features/tecnicos_confianza/presentation/tecnicos_confianza_controller.dart` — class `TecnicosConfianzaController`
  - `build()`:13, `reintentar()`:19, `cursorDe()`:22, `pedirPagina()`:25, `unirPaginas()`:30, `guardar()`:38, `quitar()`:61

### tema

**core**

- `app/lib/core/tema/colores.dart` — class `ColoresClaro`, class `ColoresOscuro`, class `ColoresError`, class `ColoresKnock`, extension `ColoresKnockEnContexto`
  - `copyWith()`:258, `lerp()`:277
- `app/lib/core/tema/colores_mapa.dart` — class `ColoresMapa`, class `PaletaMapa`
- `app/lib/core/tema/contraste.dart` — —
  - `relacionDeContraste()`:16
- `app/lib/core/tema/tema.dart` — —
  - `sinRelleno()`:26, `estiloBotonOscuro()`:168
- `app/lib/core/tema/tipografia.dart` — —
- `app/lib/core/tema/tokens.dart` — class `Radios`, class `Alturas`, class `Espaciado`, class `Sombras`

### trabajo

**-**

- `app/lib/features/trabajo/cotizar_providers.dart` — —
- `app/lib/features/trabajo/llegada_providers.dart` — —
- `app/lib/features/trabajo/trabajo.dart` — —

**data**

- `app/lib/features/trabajo/data/cotizar_repository_api.dart` — class `CotizarRepositoryApi`
  - `recibidas()`:65, `descartar()`:77, `enviadas()`:97, `solicitud()`:139, `enviar()`:154
- `app/lib/features/trabajo/data/llegada_repository_api.dart` — class `LlegadaRepositoryApi`
  - `obtener()`:26, `confirmar()`:37

**domain**

- `app/lib/features/trabajo/domain/cotizar.dart` — class `FotoParaCotizar`, class `SolicitudParaCotizar`, class `SolicitudRecibida`, enum `TipoPrecio`, class `CotizacionPropia`, class `PaginaDeSolicitudes`, class `PaginaDeCotizaciones`, class `CotizacionNueva`, enum `CampoCotizacion`, class `RevisionDeCotizacion`, enum `ResultadoDescarte`, class `CotizarRepository`
  - `montoValido()`:140, `horaValida()`:147, `diasParaCotizar()`:153, `revisarCotizacion()`:175
- `app/lib/features/trabajo/domain/llegada.dart` — class `VisitaDelTecnico`, enum `MotivoLlegada`, class `ResultadoLlegada`, class `LlegadaConfirmada`, class `LlegadaRechazada`, class `ReglasDeLlegada`, class `LlegadaRepository`
  - `codigoValido()`:79

**presentation**

- `app/lib/features/trabajo/presentation/cotizar_controller.dart` — class `ListaDelTecnicoController`, class `SolicitudesRecibidasController`, class `CotizacionesEnviadasController`
  - `build()`:15, `reintentar()`:20, `pedirPagina()`:23, `build()`:33, `pedir()`:42, `cursorDe()`:46, `retirar()`:48, `unirPaginas()`:64, `pedir()`:88, `cursorDe()`:92, `unirPaginas()`:95
- `app/lib/features/trabajo/presentation/llegada_controller.dart` — class `EstadoLlegada`, class `LlegadaController`
  - `build()`:46
- `app/lib/features/trabajo/presentation/trabajo_screen.dart` — class `TrabajoScreen`
  - `build()`:11

### verificacion

**-**

- `app/lib/features/verificacion/verificacion.dart` — —
- `app/lib/features/verificacion/verificacion_providers.dart` — —

**data**

- `app/lib/features/verificacion/data/verificacion_repository_api.dart` — class `VerificacionRepositoryApi`
  - `miEstado()`:26

**domain**

- `app/lib/features/verificacion/domain/verificacion.dart` — enum `EstadoDeVerificacion`, class `Verificacion`, class `VerificacionRepository`

**presentation**

- `app/lib/features/verificacion/presentation/verificacion_controller.dart` — class `VerificacionController`
  - `build()`:10

### visita

**-**

- `app/lib/features/visita/visita.dart` — —
- `app/lib/features/visita/visita_providers.dart` — —

**data**

- `app/lib/features/visita/data/acciones_visita_repository_api.dart` — class `AccionesVisitaRepositoryApi`
  - `cancelar()`:35, `reprogramar()`:44, `reportarNoTerminado()`:59, `clienteAusente()`:65, `tecnicoAusente()`:69, `terminar()`:80
- `app/lib/features/visita/data/agenda_repository_api.dart` — class `AgendaRepositoryApi`
  - `listar()`:12
- `app/lib/features/visita/data/permiso_fotos_repository_api.dart` — class `PermisoFotosRepositoryApi`
  - `consultar()`:33, `guardar()`:48
- `app/lib/features/visita/data/precio_de_visita_repository_api.dart` — class `PrecioDeVisitaRepositoryApi`
  - `cotizacionFinal()`:37, `ajustesPendientes()`:53, `decidirCotizacionFinal()`:69, `decidirAjuste()`:75
- `app/lib/features/visita/data/precio_tecnico_repository_api.dart` — class `PrecioTecnicoRepositoryApi`
  - `cotizacionAceptada()`:16, `enviarFinal()`:43, `proponerAjuste()`:61

**domain**

- `app/lib/features/visita/domain/acciones_visita.dart` — class `VisitaCancelada`, class `PropuestaDeFecha`, class `ReglasDeVisita`, class `AccionesVisitaRepository`
- `app/lib/features/visita/domain/agenda.dart` — class `VisitaAgenda`, class `PaginaAgenda`, class `AgendaRepository`
- `app/lib/features/visita/domain/permiso_fotos.dart` — class `PermisoDeFotos`, class `PermisoFotosRepository`
- `app/lib/features/visita/domain/precio_de_visita.dart` — class `CotizacionFinal`, class `AjusteDePrecio`, class `PrecioDeVisita`, class `PrecioDeVisitaRepository`
- `app/lib/features/visita/domain/precio_tecnico.dart` — class `CotizacionAceptada`, class `ReglasDePrecioTecnico`, class `PrecioTecnicoRepository`
  - `pesos()`:26

**presentation**

- `app/lib/features/visita/presentation/agenda_controller.dart` — class `AgendaController`
  - `build()`:10, `reintentar()`:15, `cursorDe()`:18, `pedirPagina()`:21, `unirPaginas()`:25
- `app/lib/features/visita/presentation/precio_de_visita_controller.dart` — class `PrecioDeVisitaController`
  - `build()`:14
- `app/lib/features/visita/presentation/tecnico_ausente_controller.dart` — class `TecnicoAusenteController`
  - `build()`:9, `anotar()`:14

### widgets

**core**

- `app/lib/core/widgets/estado_knock.dart` — class `EstadoKnock`
  - `build()`:25
- `app/lib/core/widgets/fila_knock.dart` — class `GrupoDeFilas`, class `FilaKnock`
  - `build()`:13, `build()`:59
- `app/lib/core/widgets/globo_conversaciones.dart` — class `GloboConversaciones`
  - `build()`:24
- `app/lib/core/widgets/pantalla_titulada.dart` — class `PantallaTitulada`
  - `build()`:14
- `app/lib/core/widgets/tarjeta_knock.dart` — class `TarjetaKnock`
  - `build()`:21
