# Mapa de código

> Generado por `scripts/codemap.py` el 2026-11-26T22:07:19Z. No editar a mano.
> **Antes de crear una clase, método o archivo, busca aquí o corre `python scripts/codemap.py --query "<qué necesitas>"`.**

## Resumen

| Módulo | Capas | Archivos | Tipos | Métodos públicos |
|---|---|---|---|---|
| `actividad` | -, data, domain, presentation | 47 | 118 | 160 |
| `app` | - | 3 | 2 | 5 |
| `bandeja_avisos` | -, data, domain, presentation | 5 | 9 | 19 |
| `busqueda` | -, data, domain, presentation | 8 | 21 | 25 |
| `cache` | core | 2 | 7 | 9 |
| `config` | core | 4 | 0 | 1 |
| `cuenta` | -, data, domain, presentation | 27 | 43 | 55 |
| `direcciones` | -, data, domain, presentation | 6 | 7 | 15 |
| `enlaces` | core | 2 | 3 | 6 |
| `entrada` | -, domain, presentation | 8 | 13 | 25 |
| `errores` | core | 3 | 27 | 3 |
| `explorar` | -, data, domain, presentation | 7 | 11 | 7 |
| `home` | -, components, pages | 3 | 2 | 0 |
| `inicio` | -, data, domain, presentation | 26 | 51 | 36 |
| `l10n` | - | 3 | 4 | 155 |
| `layout` | core | 1 | 1 | 0 |
| `maqueta` | - | 48 | 265 | 511 |
| `mensajes` | data, domain, presentation | 4 | 9 | 9 |
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
| `router` | core | 4 | 4 | 15 |
| `sesion` | core | 15 | 25 | 46 |
| `tecnico` | -, data, domain, presentation | 13 | 31 | 29 |
| `tecnicos_confianza` | -, data, domain, presentation | 6 | 6 | 11 |
| `tema` | core | 6 | 11 | 5 |
| `trabajo` | presentation | 1 | 1 | 1 |
| `visita` | -, data, domain, presentation | 7 | 11 | 8 |
| `widgets` | core | 4 | 5 | 5 |

## Tipos con el mismo nombre en varios lugares

- `EntradaCache`: `app/lib/core/cache/almacen_cache.dart:8`, `app/lib/core/red/cache_respuestas.dart:7`
- `Franja`: `app/lib/features/actividad/domain/franja.dart:5`, `app/lib/features/tecnico/domain/horarios.dart:18`
- `Opinion`: `app/lib/features/maqueta/tecnico_estado.dart:173`, `app/lib/features/opiniones/domain/opinion.dart:35`
- `SesionNotifier`: `app/lib/core/sesion/sesion.dart:62`, `app/lib/core/sesion/sesion_provider.dart:26`
- `Solicitud`: `app/lib/features/actividad/domain/solicitud.dart:30`, `app/lib/features/maqueta/estado.dart:165`
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
  - `subirFoto()`:37, `crear()`:44, `obtener()`:71, `listar()`:82, `cotizaciones()`:102, `elegir()`:139
- `app/lib/features/actividad/data/solicitud_repository_de_prueba.dart` — class `SolicitudRepositoryDePrueba`
  - `subirFoto()`:72, `crear()`:75, `obtener()`:116, `listar()`:123, `cotizaciones()`:130, `elegir()`:160, `obtenerVisita()`:209, `pedirAviso()`:238, `cotizacion()`:256, `etiquetarComoElServidor()`:350, `ordenarComoElServidor()`:387, `porCalificacion()`:391, `porTope()`:393
- `app/lib/features/actividad/data/subida_de_fotos_api.dart` — class `SubidaDeFotosApi`, class `_Enlace`
  - `subir()`:40
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
- `app/lib/features/actividad/domain/solicitud.dart` — enum `EstadoSolicitud`, class `Solicitud`, class `NuevaSolicitud`
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
  - `esperaCotizaciones()`:34, `textoEstadoSolicitud()`:40, `build()`:61, `build()`:96
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
  - `dispose()`:35, `build()`:67
- `app/lib/features/entrada/presentation/cuenta_regresiva_controller.dart` — class `CuentaRegresivaNotifier`
  - `build()`:18, `reiniciar()`:25
- `app/lib/features/entrada/presentation/entrada_controller.dart` — class `EntradaUiState`, class `EntradaController`
  - `copyWith()`:23, `build()`:41, `enviarCodigo()`:46, `reenviar()`:64, `verificar()`:82, `limpiarError()`:106
- `app/lib/features/entrada/presentation/mensaje_de_error.dart` — —
  - `mensajeDeErrorDeEntrada()`:5
- `app/lib/features/entrada/presentation/widgets/marco_de_entrada.dart` — class `MarcoDeEntrada`, class `_Marca`, class `BotonPrincipalDeEntrada`, class `MensajeDeErrorDeEntrada`
  - `build()`:29, `build()`:91, `decoracionDeEntrada()`:129, `estiloBotonPrincipal()`:147, `build()`:167, `build()`:189

### errores

**core**

- `app/lib/core/errores/failure.dart` — class `Failure`, class `DatosInvalidosFailure`, class `ServicioNoDisponibleFailure`, class `ApiNoConfiguradaFailure`, class `NoAutorizadoFailure`, class `CuentaSuspendidaFailure`, class `AccesoDenegadoFailure`, class `ConflictoFailure`, class `DatosRechazadosFailure`, class `DemasiadosIntentosFailure`, class `AvisoNoAceptadoFailure`, class `CodigoIncorrectoFailure`, class `CodigoVencidoFailure`, class `CelularRechazadoFailure`, class `VerificacionNoDisponibleFailure`, class `NoEncontradoFailure`, class `ContenidoRechazadoFailure`, class `ModeracionNoDisponibleFailure`, class `OpcionNoDisponibleFailure`, class `FotoNoValidaFailure`, enum `MotivoEleccionRechazada`, class `EleccionRechazadaFailure`, class `AvisoNoPermitidoFailure`, class `OpinionNoPermitidaFailure`, class `YaBloqueadoFailure`, class `ApelacionNoPermitidaFailure`, class `OpinionYaRespondidaFailure`
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
  - `of()`:70, `load()`:3815, `isSupported()`:3820, `shouldReload()`:3824, `lookupAppLocalizations()`:3827
- `app/lib/l10n/generado/app_localizations_en.dart` — class `AppLocalizationsEn`
  - `tecnicoCopia()`:22, `tecnicoCalificacion()`:30, `tecnicoAnios()`:35, `tecnicoRadio()`:49, `tecnicoLlega()`:61, `tecnicoNoLlega()`:66, `tecnicoDesde()`:77, `citaMonto()`:105, `citaTope()`:110, `busquedaContador()`:130, `busquedaBuscamos()`:147, `busquedaSinResultadosOficio()`:164, `busquedaTotal()`:185, `busquedaEspera()`:203, `busquedaCalificacion()`:208, `busquedaDistancia()`:213, `busquedaVerificado()`:218, `entradaAceptoAviso()`:473, `entradaCodigoEnviadoA()`:536, `entradaReenviarEn()`:550, `previaExpertosCerca()`:632, `previaPinSemantica()`:643, `previaTarjetaSemantica()`:648, `previaDistanciaKm()`:671, `solicitudPasoDeTotal()`:682 …
- `app/lib/l10n/generado/app_localizations_es.dart` — class `AppLocalizationsEs`
  - `tecnicoCopia()`:22, `tecnicoCalificacion()`:30, `tecnicoAnios()`:35, `tecnicoRadio()`:49, `tecnicoLlega()`:61, `tecnicoNoLlega()`:66, `tecnicoDesde()`:77, `citaMonto()`:105, `citaTope()`:110, `busquedaContador()`:130, `busquedaBuscamos()`:147, `busquedaSinResultadosOficio()`:165, `busquedaTotal()`:186, `busquedaEspera()`:204, `busquedaCalificacion()`:209, `busquedaDistancia()`:214, `busquedaVerificado()`:219, `entradaAceptoAviso()`:475, `entradaCodigoEnviadoA()`:540, `entradaReenviarEn()`:554, `previaExpertosCerca()`:638, `previaPinSemantica()`:649, `previaTarjetaSemantica()`:654, `previaDistanciaKm()`:677, `solicitudPasoDeTotal()`:688 …

### layout

**core**

- `panel/src/app/core/layout/app-shell.component.ts` — class `AppShellComponent`

### maqueta

**-**

- `app/lib/features/maqueta/ampliar_real.dart` — class `AmpliarSolicitudReal`, enum `_Paso`, class `_AmpliarState`
  - `build()`:50
- `app/lib/features/maqueta/anim_k.dart` — class `Pulsa`, class `_PulsaState`, class `Aparece`, class `_ApareceState`, class `TransicionKnock`, class `ShimmerK`, class `_ShimmerKState`, class `BoneK`, class `EsqueletoLista`, class `CargaInicial`, class `_CargaInicialState`, class `PulsoInsignia`, class `_PulsoInsigniaState`, class `EsqueletoReputacion`
  - `sinMovimiento()`:20, `hapticoLigero()`:25, `hapticoExito()`:27, `hapticoSeleccion()`:29, `build()`:55, `Listener()`:57, `didChangeDependencies()`:90, `dispose()`:109, `build()`:116, `FadeTransition()`:118, `escalona()`:133, `buildTransitions()`:141, `didChangeDependencies()`:196, `dispose()`:209, `build()`:215, `AnimatedBuilder()`:219, `build()`:252, `build()`:271, `item()`:272, `didChangeDependencies()`:331, `dispose()`:346, `build()`:352, `initState()`:379, `didChangeDependencies()`:385, `didUpdateWidget()`:394 …
- `app/lib/features/maqueta/avisos_reales.dart` — class `AvisosReales`, class `_Fila`, class `PreferenciasDeAvisosReales`, class `ContadorDeAvisos`
  - `build()`:79, `build()`:127, `build()`:158, `build()`:226
- `app/lib/features/maqueta/bloqueos_reales.dart` — class `PersonasBloqueadasReales`, class `_FilaBloqueada`, class `DesbloquearReal`, class `_DesbloquearRealState`, class `BloquearReal`, class `_ConfirmarBloqueo`, class `_ConfirmarBloqueoState`
  - `textosDeLista()`:30, `filas()`:42, `hayMas()`:47, `reintentar()`:50, `cargarMas()`:54, `build()`:64, `build()`:121, `build()`:148, `build()`:261
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
- `app/lib/features/maqueta/datos.dart` — class `Cat`, class `Review`, class `Prov`
  - `guessCat()`:145, `longDate()`:648, `money()`:651, `nowH()`:661, `initials()`:666
- `app/lib/features/maqueta/detalle_oficio_real.dart` — class `FrasesDelOficio`
  - `build()`:31, `pedirOficioNuevo()`:70
- `app/lib/features/maqueta/direcciones_reales.dart` — class `DireccionesReales`, class `DireccionAlPedirReal`, class `_FormularioDireccion`, class `_FormularioState`, class `_Eliminar`, class `_EliminarState`
  - `build()`:59, `build()`:117, `editarDireccion()`:145, `dispose()`:173, `build()`:219, `build()`:295
- `app/lib/features/maqueta/eliminar_real.dart` — class `PendientesReales`, class `EliminarCuentaReal`, class `_EliminarCuentaRealState`, class `AvisoDeEliminacionReal`, class `EliminadaReal`
  - `build()`:22, `dispose()`:85, `build()`:157, `build()`:238, `build()`:267, `BtnK()`:303
- `app/lib/features/maqueta/en_dict.dart` — —
- `app/lib/features/maqueta/entrada_maqueta.dart` — class `EntradaMaqueta`, class `_EntradaState`
  - `initState()`:66, `dispose()`:72, `build()`:312, `head()`:321
- `app/lib/features/maqueta/envio_de_visita.dart` — mixin `EnvioDeVisita`
- `app/lib/features/maqueta/estado.dart` — class `Quote`, class `Adjust`, class `Resched`, class `Job`, enum `CargaReal`, class `Msg`, class `Notif`, class `Contacto`, class `Casa`, class `Solicitud`, class `AsisMsg`, class `Asis`, class `UserData`, class `MaquetaEstado`, class `AvisoToast`
  - `qTope()`:46, `fijarOficios()`:252, `fijarSolicitudesReales()`:268, `refresh()`:276, `cargarTelefono()`:284, `guardarTelefono()`:290, `olvidarTelefono()`:296, `dispose()`:302, `after()`:309, `toast()`:320, `job()`:324, `notif()`:334, `results()`:344, `convIds()`:362, `accepted()`:366, `toggleSave()`:371, `openChat()`:376, `sendMsg()`:381, `block()`:404, `unblock()`:409, `startReq()`:415, `sendReq()`:434, `agregarSolicitudReal()`:475, `startClientQuotes()`:481, `reach()`:491 …
- `app/lib/features/maqueta/explorar_maqueta.dart` — class `ExplorarMaqueta`
  - `build()`:29
- `app/lib/features/maqueta/explorar_real.dart` — class `ExplorarReal`, class `_Aviso`, class `_Seccion`, class `_Fila`, class `_Servicio`, class `_Fotos`, class `_Tecnico`
  - `iconoDeOficio()`:14, `fechaDeCopia()`:21, `dos()`:22, `build()`:41, `reintentar()`:44, `build()`:112, `build()`:131, `build()`:151, `build()`:169, `build()`:220, `foto()`:221, `build()`:280
- `app/lib/features/maqueta/fachada_maqueta.dart` — class `PantallasMaqueta`, class `ShellMaqueta`, class `RaizMaqueta`, class `_PuenteDeDatos`, class `_PuenteDeDatosState`
  - `previa()`:38, `entrada()`:39, `inicio()`:40, `explorar()`:41, `actividad()`:42, `trabajo()`:43, `cuenta()`:44, `configuracion()`:45, `rutaMaqueta()`:49, `build()`:223, `preparar()`:236, `conTransiciones()`:243, `envolver()`:251, `initState()`:274, `dispose()`:352, `build()`:360
- `app/lib/features/maqueta/horarios_reales.dart` — class `HorariosSegunSesion`, class `HorariosReales`
  - `build()`:21, `build()`:51
- `app/lib/features/maqueta/inicio_maqueta.dart` — class `InicioMaqueta`, class `_InicioMaquetaState`, class `_PuntoDeAvisos`
  - `initState()`:158, `dispose()`:191, `build()`:245, `MaqBuilder()`:254, `Scaffold()`:365, `build()`:818
- `app/lib/features/maqueta/lista_paginada_real.dart` — class `ListaPaginadaReal`, typedef `TextosDeLista`
  - `build()`:23
- `app/lib/features/maqueta/mapa_google.dart` — class `MarcadorAgenda`, class `ControlMapaGoogle`, class `MapaGoogleKnock`, class `_MapaGoogleState`, class `ControlesMapaGoogle`
  - `posicionDeMundo()`:35, `posicionDeExperto()`:45, `acercar()`:79, `alejar()`:80, `moverA()`:83, `ir()`:90, `ajustar()`:93, `dibujarPin()`:151, `initState()`:282, `dispose()`:295, `didUpdateWidget()`:344, `build()`:430, `build()`:480, `b()`:500, `ListenableBuilder()`:517
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
  - `build()`:37, `build()`:61, `build()`:122, `build()`:159, `msgFab()`:237, `jobCard()`:304, `jobChat()`:525, `adjustCard()`:577, `build()`:637, `InkWell()`:672, `initState()`:758, `dispose()`:773, `build()`:844, `reprogBlock()`:1280, `BtnK()`:1288, `reprogSheet()`:1297, `cancelBlock()`:1369, `cancelSheet()`:1377, `build()`:1427, `VisitaRealGate()`:1431, `build()`:1734, `VisitaRealGate()`:1738, `initState()`:1945, `dispose()`:1952, `build()`:1982 …
- `app/lib/features/maqueta/pantallas_buscar.dart` — class `BuscarScreen`, class `_BuscarScreenState`, class `PerfilScreen`, class `_PerfilScreenState`, class `OpinionesScreen`, class `_OpinionesScreenState`, class `AsistenteScreen`, class `_AsistenteScreenState`
  - `provCard()`:25, `CardK()`:27, `initState()`:89, `dispose()`:95, `build()`:159, `reviewW()`:396, `build()`:503, `PerfilTecnicoReal()`:508, `build()`:978, `initState()`:1162, `dispose()`:1181, `build()`:1280, `composerK()`:1517, `quickK()`:1523, `burbujaK()`:1525
- `app/lib/features/maqueta/pantallas_cuenta.dart` — class `CuentaMaqueta`, class `_Gl`, class `MiCasaScreen`, class `ConfianzaScreen`, class `ConfigMaqueta`, class `AvisosConfigScreen`, class `AvisosScreen`, class `AvisoScreen`, class `TerminosScreen`, class `PrivacidadScreen`, class `Eliminar1Screen`, class `_Eliminar1State`, class `Eliminar2Screen`, class `_Eliminar2State`, class `EliminadoScreen`, class `AyudaScreen`, class `_AyudaState`, class `SinConexionScreen`, class `_SinConexionState`
  - `hoja()`:44, `build()`:63, `MaqBuilder()`:75, `build()`:386, `editarDatos()`:392, `FieldK()`:457, `cambiarNumero()`:519, `e()`:536, `phone()`:537, `build()`:878, `build()`:940, `Pg()`:963, `CardK()`:983, `build()`:1028, `build()`:1159, `build()`:1224, `build()`:1405, `build()`:1476, `build()`:1534, `MaqBuilder()`:1536, `build()`:1668, `dispose()`:1790, `build()`:1796, `build()`:1855, `EliminadaReal()`:1857 …
- `app/lib/features/maqueta/pantallas_solicitud.dart` — class `SolicitarScreen`, class `_SolicitarScreenState`, class `EnviadaScreen`, class `CompararScreen`, class `_CompararScreenState`
  - `initState()`:65, `dispose()`:73, `build()`:130, `FieldK()`:410, `build()`:490, `step()`:496, `stateK0()`:613, `widenBlock()`:639, `initState()`:696, `build()`:1219, `CardK()`:1253
- `app/lib/features/maqueta/pantallas_tecnico.dart` — class `Servicio`, class `TecRegistroScreen`, class `_TecRegistroState`, class `VerifScreen`, class `_VerifState`, class `PendienteScreen`, class `_PendienteState`, class `VerificadoScreen`, class `RechazadaScreen`, class `TrabajoMaqueta`, class `AgendaEnMapaBloque`, class `TecMensajesScreen`, class `TecChatScreen`, class `_TecChatState`
  - `registrarRutasTecnico()`:44, `dispose()`:157, `clean()`:236, `advErrors()`:238, `initState()`:287, `dispose()`:294, `build()`:530, `openVerif()`:905, `privacyCard()`:918, `BtnK()`:1099, `build()`:1124, `initState()`:1256, `dispose()`:1262, `build()`:1268, `build()`:1411, `build()`:1500, `visitCard()`:1594, `BtnK()`:1662, `reqCard()`:1819, `workFab()`:1870, `Positioned()`:1874, `build()`:1936, `verifRow()`:1948, `build()`:2251, `build()`:2351 …
- `app/lib/features/maqueta/pantallas_tecnico2.dart` — class `CotizarScreen`, class `_CotizarState`, class `IniciarScreen`, class `_IniciarState`, class `CerrarScreen`, class `_CerrarState`, class `PerfilEditarScreen`, class `_PerfilEditarState`, class `ReputacionScreen`, class `_ReputacionState`
  - `dispose()`:40, `doSend()`:55, `build()`:66, `upd()`:104, `seg()`:109, `BtnK()`:279, `FieldK()`:364, `dispose()`:471, `build()`:477, `Pg()`:481, `check()`:567, `dispose()`:662, `build()`:723, `BtnK()`:847, `initState()`:897, `dispose()`:917, `build()`:980, `dispose()`:1194, `build()`:1200
- `app/lib/features/maqueta/perfil_publico_real.dart` — class `PerfilPublicoReal`, class `_Resumen`, class `_Colonia`, class `_ColoniaState`, class `_Servicios`, class `_Fotos`
  - `build()`:56, `build()`:80, `build()`:130, `FutureBuilder()`:132, `build()`:172, `build()`:220
- `app/lib/features/maqueta/precio_de_visita_real.dart` — class `PrecioDeVisitaReal`, class `_TarjetaPorDecidir`, class `_TarjetaPorDecidirState`
  - `build()`:21, `NoteK()`:76, `build()`:157
- `app/lib/features/maqueta/privacidad_real.dart` — class `ExportacionReal`, class `ConsentimientosReales`, class `_FilaConsentimiento`
  - `build()`:20, `pedir()`:49, `fechaDeCuenta()`:81, `build()`:112, `build()`:156
- `app/lib/features/maqueta/reportes_reales.dart` — class `ReportarReal`, class `_Formulario`, class `_FormularioState`, class `MisReportesReales`, class `_TarjetaDeReporte`, class `_TarjetaDeReporteState`
  - `build()`:40, `soloTexto()`:42, `dispose()`:101, `build()`:137, `textosDeLista()`:196, `filas()`:208, `hayMas()`:214, `reintentar()`:217, `cargarMas()`:221, `dispose()`:241, `build()`:268
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
- `app/lib/features/maqueta/ui.dart` — class `KC`, class `T`, enum `Bk`, class `BtnK`, class `LinkK`, class `CardK`, class `Pill`, class `NoteK`, class `Av`, class `Stars`, class `ChipK`, class `ChoiceK`, class `GroupK`, class `LiK`, class `FoldK`, class `_FoldKState`, class `Sw`, class `Prog`, class `FieldK`, class `PhoneCc`, class `PhotoTile`, class `AddPhoto`, class `Pg`, class `MaqBuilder`, class `AvisosHost`, class `_AvisosHostState`
  - `tr()`:29, `hit()`:32, `kc()`:99, `build()`:136, `h1()`:150, `h2()`:153, `h3()`:155, `bT()`:157, `tT()`:159, `sMut()`:162, `mutT()`:172, `labT()`:175, `stack()`:188, `rowW()`:199, `icn()`:214, `build()`:298, `build()`:394, `build()`:427, `build()`:485, `build()`:536, `rich()`:566, `build()`:617, `build()`:676, `rateW()`:697, `whereTxt()`:724 …
- `app/lib/features/maqueta/visita_acciones_reales.dart` — class `AccionesVisitaReal`, class `BotonNoTerminadoReal`, class `_HojaDeEnvio`, class `_HojaDeEnvioState`
  - `build()`:23, `build()`:60, `elegida()`:110, `aTiempo()`:116, `dispose()`:226, `build()`:245
- `app/lib/features/maqueta/visita_real.dart` — class `VisitaRealGate`
  - `build()`:29, `textoDeMotivoDeCodigo()`:75

### mensajes

**data**

- `app/lib/features/mensajes/data/conversaciones_repository_api.dart` — class `ConversacionesRepositoryApi`
  - `consultar()`:17, `contador()`:35, `marcarLeido()`:45

**domain**

- `app/lib/features/mensajes/domain/conversacion.dart` — class `Conversacion`, class `ContraparteConversacion`, class `UltimoMensaje`, class `ContadorDeNoLeidos`, class `ResumenConversaciones`
- `app/lib/features/mensajes/domain/conversaciones_repository.dart` — class `ConversacionesRepository`

**presentation**

- `app/lib/features/mensajes/presentation/conversaciones_controller.dart` — class `EstadoConversaciones`, class `ConversacionesController`
  - `reintentar()`:30, `canalConectado()`:62, `canalDesconectado()`:66, `actualizarTotalDesdeServidor()`:78, `limpiar()`:90, `dispose()`:103

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
  - `ramasVisibles()`:36, `build()`:53
- `app/lib/core/router/destino_de_regreso_provider.dart` — class `DestinoDeRegreso`
  - `build()`:10, `recordar()`:13, `olvidar()`:18
- `app/lib/core/router/rutas.dart` — class `Rutas`
  - `solicitud()`:25, `cotizaciones()`:29, `visita()`:33, `esRutaPublica()`:68, `redireccionPorSesion()`:91, `rutaDeEntrada()`:109, `destinoDeRegreso()`:128, `destinoValidoODescartar()`:133, `redireccionPorRol()`:161, `redireccionPorPerfil()`:171

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

### tecnico

**-**

- `app/lib/features/tecnico/tecnico.dart` — —
- `app/lib/features/tecnico/tecnico_providers.dart` — —

**data**

- `app/lib/features/tecnico/data/horarios_repository_api.dart` — class `HorariosRepositoryApi`
  - `horarios()`:19, `guardar()`:23, `cambiarDisponibilidad()`:37
- `app/lib/features/tecnico/data/perfil_publico_repository_api.dart` — class `PerfilPublicoRepositoryApi`
  - `perfil()`:33, `servicios()`:53, `fotos()`:59, `llegaAColonia()`:67, `texto()`:91
- `app/lib/features/tecnico/data/servicios_repository_api.dart` — class `ServiciosRepositoryApi`
  - `deTecnico()`:22, `agregar()`:36, `editar()`:40, `quitar()`:44
- `app/lib/features/tecnico/data/tecnico_repository_api.dart` — class `TecnicoRepositoryApi`
  - `registrar()`:17, `cuerpoDeAlta()`:69

**domain**

- `app/lib/features/tecnico/domain/alta_tecnico.dart` — enum `Atencion`, class `AltaTecnico`, class `PerfilTecnico`, class `TecnicoRepository`
- `app/lib/features/tecnico/domain/horarios.dart` — enum `DiaSemana`, typedef `Franja`, class `HorarioDelDia`, class `Disponibilidad`, class `HorariosRepository`
- `app/lib/features/tecnico/domain/perfil_publico.dart` — class `DetallePerfil`, class `PerfilPublico`, class `ServicioPublico`, class `FotoDeTrabajo`, class `PaginaFotos`, class `PerfilPublicoRepository`
- `app/lib/features/tecnico/domain/servicios.dart` — class `ServicioTecnico`, class `DatosDeServicio`, enum `RechazoDeServicio`, typedef `ServicioGuardado`, class `ServiciosRepository`

**presentation**

- `app/lib/features/tecnico/presentation/horarios_controller.dart` — class `HorariosController`
  - `franjasDeLaMaqueta()`:9, `build()`:24, `reintentar()`:30, `franjasParaAbrir()`:33, `cambiar()`:38
- `app/lib/features/tecnico/presentation/perfil_publico_controller.dart` — class `ConFecha`, class `FotosDeTrabajosController`
  - `build()`:79, `reintentar()`:82, `cursorDe()`:85, `pedirPagina()`:89
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

**presentation**

- `app/lib/features/trabajo/presentation/trabajo_screen.dart` — class `TrabajoScreen`
  - `build()`:11

### visita

**-**

- `app/lib/features/visita/visita.dart` — —
- `app/lib/features/visita/visita_providers.dart` — —

**data**

- `app/lib/features/visita/data/acciones_visita_repository_api.dart` — class `AccionesVisitaRepositoryApi`
  - `cancelar()`:33, `reprogramar()`:42, `reportarNoTerminado()`:57
- `app/lib/features/visita/data/precio_de_visita_repository_api.dart` — class `PrecioDeVisitaRepositoryApi`
  - `cotizacionFinal()`:37, `ajustesPendientes()`:53, `decidirCotizacionFinal()`:69, `decidirAjuste()`:75

**domain**

- `app/lib/features/visita/domain/acciones_visita.dart` — class `VisitaCancelada`, class `PropuestaDeFecha`, class `ReglasDeVisita`, class `AccionesVisitaRepository`
- `app/lib/features/visita/domain/precio_de_visita.dart` — class `CotizacionFinal`, class `AjusteDePrecio`, class `PrecioDeVisita`, class `PrecioDeVisitaRepository`

**presentation**

- `app/lib/features/visita/presentation/precio_de_visita_controller.dart` — class `PrecioDeVisitaController`
  - `build()`:14

### widgets

**core**

- `app/lib/core/widgets/estado_knock.dart` — class `EstadoKnock`
  - `build()`:25
- `app/lib/core/widgets/fila_knock.dart` — class `GrupoDeFilas`, class `FilaKnock`
  - `build()`:13, `build()`:59
- `app/lib/core/widgets/pantalla_titulada.dart` — class `PantallaTitulada`
  - `build()`:14
- `app/lib/core/widgets/tarjeta_knock.dart` — class `TarjetaKnock`
  - `build()`:21
