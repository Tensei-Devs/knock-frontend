# Mapa de código

> Generado por `scripts/codemap.py` el 2026-11-23T04:46:56Z. No editar a mano.
> **Antes de crear una clase, método o archivo, busca aquí o corre `python scripts/codemap.py --query "<qué necesitas>"`.**

## Resumen

| Módulo | Capas | Archivos | Tipos | Métodos públicos |
|---|---|---|---|---|
| `actividad` | -, data, domain, presentation | 45 | 114 | 158 |
| `app` | - | 3 | 2 | 5 |
| `cache` | core | 2 | 7 | 9 |
| `config` | core | 2 | 0 | 1 |
| `cuenta` | -, data, domain, presentation | 18 | 25 | 33 |
| `enlaces` | core | 2 | 3 | 6 |
| `entrada` | -, domain, presentation | 8 | 13 | 25 |
| `errores` | core | 3 | 23 | 3 |
| `explorar` | presentation | 1 | 1 | 1 |
| `home` | -, components, pages | 3 | 2 | 0 |
| `inicio` | -, data, domain, presentation | 26 | 50 | 35 |
| `l10n` | - | 3 | 4 | 79 |
| `layout` | core | 1 | 1 | 0 |
| `maqueta` | - | 25 | 170 | 384 |
| `notificaciones` | core | 7 | 17 | 20 |
| `oficios` | -, data, domain, presentation | 12 | 18 | 17 |
| `panel` | - | 3 | 1 | 0 |
| `permisos` | core | 2 | 4 | 4 |
| `plataforma` | core | 3 | 6 | 4 |
| `preferencias` | core | 6 | 12 | 25 |
| `previa` | -, domain, presentation | 16 | 32 | 48 |
| `red` | core | 8 | 5 | 21 |
| `router` | core | 4 | 4 | 15 |
| `sesion` | core | 15 | 25 | 46 |
| `tema` | core | 6 | 11 | 5 |
| `trabajo` | presentation | 1 | 1 | 1 |
| `widgets` | core | 4 | 5 | 5 |

## Tipos con el mismo nombre en varios lugares

- `EntradaCache`: `app/lib/core/cache/almacen_cache.dart:8`, `app/lib/core/red/cache_respuestas.dart:7`
- `SesionNotifier`: `app/lib/core/sesion/sesion.dart:62`, `app/lib/core/sesion/sesion_provider.dart:26`
- `Solicitud`: `app/lib/features/actividad/domain/solicitud.dart:30`, `app/lib/features/maqueta/estado.dart:161`
- `Visita`: `app/lib/features/actividad/domain/visita.dart:73`, `app/lib/features/maqueta/tecnico_estado.dart:153`

## Índice por módulo

### actividad

**-**

- `app/lib/features/actividad/actividad.dart` — —
- `app/lib/features/actividad/actividad_providers.dart` — —

**data**

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
  - `subirFoto()`:32, `crear()`:36, `obtener()`:63, `listar()`:74, `cotizaciones()`:94, `elegir()`:131
- `app/lib/features/actividad/data/solicitud_repository_de_prueba.dart` — class `SolicitudRepositoryDePrueba`
  - `subirFoto()`:72, `crear()`:75, `obtener()`:116, `listar()`:123, `cotizaciones()`:130, `elegir()`:160, `obtenerVisita()`:209, `pedirAviso()`:238, `cotizacion()`:256, `etiquetarComoElServidor()`:350, `ordenarComoElServidor()`:387, `porCalificacion()`:391, `porTope()`:393
- `app/lib/features/actividad/data/visita_contrato_mapper.dart` — class `VisitaContratoMapper`
  - `visita()`:14, `aviso()`:50
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
  - `desdeTexto()`:19, `desdeTexto()`:42, `aMapa()`:151, `desdeMapa()`:166

**presentation**

- `app/lib/features/actividad/presentation/actividad_screen.dart` — class `ActividadScreen`
  - `build()`:20, `PantallaTitulada()`:57
- `app/lib/features/actividad/presentation/aviso_controller.dart` — class `TextoDeAviso`, class `AvisoDelServidor`, class `AvisoDeRespaldo`, class `AvisoNoPermitido`, class `AvisoSinDatos`, class `ContactosController`
  - `build()`:84, `guardar()`:90, `borrar()`:127
- `app/lib/features/actividad/presentation/cotizaciones_controller.dart` — class `OrdenCotizacionesNotifier`, class `EstadoEleccion`, class `EleccionInactiva`, class `EleccionEnCurso`, class `EleccionHecha`, class `EleccionFallida`, class `EleccionController`
  - `build()`:18, `elegir()`:20, `build()`:76, `elegir()`:80, `reiniciar()`:146
- `app/lib/features/actividad/presentation/cotizaciones_reales_controller.dart` — typedef `ConsultaCotizaciones`, class `EleccionRealController`
  - `build()`:33, `elegir()`:35, `reiniciar()`:59
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
- `app/lib/core/config/modo_maqueta.dart` — —

### cuenta

**-**

- `app/lib/features/cuenta/cuenta_providers.dart` — —

**data**

- `app/lib/features/cuenta/data/perfil_mapper.dart` — class `PerfilMapper`
  - `desdeContrato()`:8
- `app/lib/features/cuenta/data/perfil_repository_api.dart` — class `PerfilRepositoryApi`
  - `obtener()`:30, `guardarNombre()`:35, `cerrarSesion()`:55
- `app/lib/features/cuenta/data/perfil_repository_simulado.dart` — class `PerfilRepositorySimulado`
  - `obtener()`:22, `guardarNombre()`:25, `cerrarSesion()`:29
- `app/lib/features/cuenta/data/sesiones_repository_api.dart` — class `SesionesRepositoryApi`
  - `listar()`:16, `cerrar()`:24

**domain**

- `app/lib/features/cuenta/domain/perfil.dart` — class `Perfil`
  - `validarNombre()`:63
- `app/lib/features/cuenta/domain/perfil_repository.dart` — class `PerfilRepository`
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
- `app/lib/features/cuenta/presentation/perfil_controller.dart` — class `PerfilController`
  - `build()`:14, `guardarNombre()`:26, `cerrarSesion()`:40, `reintentar()`:50, `perfilCargado()`:70
- `app/lib/features/cuenta/presentation/sesiones_controller.dart` — class `SesionesController`
  - `build()`:11, `reintentar()`:15, `cerrar()`:20
- `app/lib/features/cuenta/presentation/widgets/menu_de_prueba.dart` — class `MenuDePrueba`
  - `build()`:15
- `app/lib/features/cuenta/presentation/widgets/seccion_avisos.dart` — class `SeccionAvisos`, class `_SeccionAvisosState`
  - `initState()`:28, `build()`:55

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

- `app/lib/core/errores/failure.dart` — class `Failure`, class `DatosInvalidosFailure`, class `ServicioNoDisponibleFailure`, class `ApiNoConfiguradaFailure`, class `NoAutorizadoFailure`, class `CuentaSuspendidaFailure`, class `AccesoDenegadoFailure`, class `ConflictoFailure`, class `DatosRechazadosFailure`, class `DemasiadosIntentosFailure`, class `AvisoNoAceptadoFailure`, class `CodigoIncorrectoFailure`, class `CodigoVencidoFailure`, class `CelularRechazadoFailure`, class `VerificacionNoDisponibleFailure`, class `NoEncontradoFailure`, class `ContenidoRechazadoFailure`, class `ModeracionNoDisponibleFailure`, class `OpcionNoDisponibleFailure`, class `FotoNoValidaFailure`, enum `MotivoEleccionRechazada`, class `EleccionRechazadaFailure`, class `AvisoNoPermitidoFailure`
  - `toString()`:10
- `app/lib/core/errores/mensaje_failure.dart` — —
  - `mensajeDeError()`:10
- `app/lib/core/errores/mensajes_failure.dart` — —
  - `mensajeDeFailure()`:7

### explorar

**presentation**

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
- `app/lib/features/inicio/presentation/inicio_screen.dart` — class `InicioScreen`, class `_TarjetaColonia`
  - `build()`:24, `build()`:61, `consultar()`:64
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
  - `of()`:70, `load()`:1829, `isSupported()`:1834, `shouldReload()`:1838, `lookupAppLocalizations()`:1841
- `app/lib/l10n/generado/app_localizations_en.dart` — class `AppLocalizationsEn`
  - `entradaAceptoAviso()`:263, `entradaCodigoEnviadoA()`:326, `entradaReenviarEn()`:340, `previaExpertosCerca()`:422, `previaPinSemantica()`:433, `previaTarjetaSemantica()`:438, `previaDistanciaKm()`:461, `solicitudPasoDeTotal()`:472, `solicitudFotos()`:505, `solicitudFotoEtiqueta()`:523, `solicitudFotoQuitar()`:528, `solicitudEspera()`:595, `solicitudCuando()`:639, `solicitudTotalFotos()`:644, `solicitudVerCotizaciones()`:658, `cotizacionMostrandoDe()`:678, `cotizacionPrecioFijo()`:687, `cotizacionPrecioRango()`:692, `cotizacionPrecioVisita()`:697, `cotizacionTope()`:702, `cotizacionCalificacion()`:723, `cotizacionNivelVerificacion()`:728, `cotizacionCuando()`:733, `cotizacionConfirmarTitulo()`:759, `cotizacionTelefono()`:780 …
- `app/lib/l10n/generado/app_localizations_es.dart` — class `AppLocalizationsEs`
  - `entradaAceptoAviso()`:264, `entradaCodigoEnviadoA()`:329, `entradaReenviarEn()`:343, `previaExpertosCerca()`:427, `previaPinSemantica()`:438, `previaTarjetaSemantica()`:443, `previaDistanciaKm()`:466, `solicitudPasoDeTotal()`:477, `solicitudFotos()`:510, `solicitudFotoEtiqueta()`:528, `solicitudFotoQuitar()`:533, `solicitudEspera()`:600, `solicitudCuando()`:644, `solicitudTotalFotos()`:649, `solicitudVerCotizaciones()`:663, `cotizacionMostrandoDe()`:683, `cotizacionPrecioFijo()`:692, `cotizacionPrecioRango()`:697, `cotizacionPrecioVisita()`:702, `cotizacionTope()`:707, `cotizacionCalificacion()`:728, `cotizacionNivelVerificacion()`:733, `cotizacionCuando()`:738, `cotizacionConfirmarTitulo()`:764, `cotizacionTelefono()`:785 …

### layout

**core**

- `panel/src/app/core/layout/app-shell.component.ts` — class `AppShellComponent`

### maqueta

**-**

- `app/lib/features/maqueta/anim_k.dart` — class `Pulsa`, class `_PulsaState`, class `Aparece`, class `_ApareceState`, class `TransicionKnock`, class `ShimmerK`, class `_ShimmerKState`, class `BoneK`, class `EsqueletoLista`, class `CargaInicial`, class `_CargaInicialState`, class `PulsoInsignia`, class `_PulsoInsigniaState`, class `EsqueletoReputacion`
  - `sinMovimiento()`:20, `hapticoLigero()`:25, `hapticoExito()`:27, `hapticoSeleccion()`:29, `build()`:55, `Listener()`:57, `didChangeDependencies()`:90, `dispose()`:109, `build()`:116, `FadeTransition()`:118, `escalona()`:133, `buildTransitions()`:141, `didChangeDependencies()`:196, `dispose()`:209, `build()`:215, `AnimatedBuilder()`:219, `build()`:252, `build()`:271, `item()`:272, `didChangeDependencies()`:331, `dispose()`:346, `build()`:352, `initState()`:379, `didChangeDependencies()`:385, `didUpdateWidget()`:394 …
- `app/lib/features/maqueta/campo_buscar.dart` — class `CampoBuscarK`
  - `build()`:18
- `app/lib/features/maqueta/carga_k.dart` — enum `TipoCarga`, class `CargaK`, class `MensajesRotativos`, class `_MensajesRotativosState`, class `ExitoK`, class `_ExitoKState`
  - `build()`:76, `initState()`:122, `dispose()`:132, `build()`:138, `exitoRapido()`:182, `initState()`:219, `build()`:225
- `app/lib/features/maqueta/cobertura.dart` — class `ZonaKnock`, class `ResultadoCobertura`, class `PantallaFueraDeCobertura`
  - `distanciaKm()`:34, `evaluarCobertura()`:54, `build()`:104, `elegirZonaDisponible()`:182, `mostrarFueraDeCobertura()`:207, `hoja()`:211
- `app/lib/features/maqueta/datos.dart` — class `Cat`, class `Review`, class `Prov`
  - `guessCat()`:145, `longDate()`:648, `money()`:651, `nowH()`:661, `initials()`:666
- `app/lib/features/maqueta/en_dict.dart` — —
- `app/lib/features/maqueta/entrada_maqueta.dart` — class `EntradaMaqueta`, class `_EntradaState`
  - `initState()`:66, `dispose()`:72, `build()`:312, `head()`:321
- `app/lib/features/maqueta/estado.dart` — class `Quote`, class `Adjust`, class `Resched`, class `Job`, enum `CargaReal`, class `Msg`, class `Notif`, class `Contacto`, class `Casa`, class `Solicitud`, class `AsisMsg`, class `Asis`, class `UserData`, class `MaquetaEstado`, class `AvisoToast`
  - `qTope()`:46, `fijarOficios()`:248, `fijarSolicitudesReales()`:264, `refresh()`:272, `cargarTelefono()`:280, `guardarTelefono()`:286, `olvidarTelefono()`:292, `dispose()`:298, `after()`:305, `toast()`:316, `job()`:320, `notif()`:330, `results()`:340, `convIds()`:358, `accepted()`:362, `toggleSave()`:367, `openChat()`:372, `sendMsg()`:377, `block()`:400, `unblock()`:405, `startReq()`:411, `sendReq()`:430, `startClientQuotes()`:468, `reach()`:478, `widen()`:506 …
- `app/lib/features/maqueta/explorar_maqueta.dart` — class `ExplorarMaqueta`
  - `build()`:32, `sec()`:107, `row()`:119, `pro()`:125, `tile()`:170
- `app/lib/features/maqueta/fachada_maqueta.dart` — class `PantallasMaqueta`, class `ShellMaqueta`, class `RaizMaqueta`, class `_PuenteDeDatos`, class `_PuenteDeDatosState`
  - `previa()`:38, `entrada()`:39, `inicio()`:40, `explorar()`:41, `actividad()`:42, `trabajo()`:43, `cuenta()`:44, `configuracion()`:45, `rutaMaqueta()`:49, `build()`:219, `preparar()`:232, `conTransiciones()`:239, `envolver()`:247, `initState()`:270, `dispose()`:348, `build()`:356
- `app/lib/features/maqueta/inicio_maqueta.dart` — class `InicioMaqueta`, class `_InicioMaquetaState`
  - `initState()`:157, `dispose()`:190, `build()`:244, `MaqBuilder()`:253, `Scaffold()`:365
- `app/lib/features/maqueta/mapa_google.dart` — class `MarcadorAgenda`, class `ControlMapaGoogle`, class `MapaGoogleKnock`, class `_MapaGoogleState`, class `ControlesMapaGoogle`
  - `posicionDeMundo()`:35, `posicionDeExperto()`:45, `acercar()`:79, `alejar()`:80, `moverA()`:83, `ir()`:90, `ajustar()`:93, `dibujarPin()`:151, `initState()`:282, `dispose()`:295, `didUpdateWidget()`:344, `build()`:430, `build()`:480, `b()`:500, `ListenableBuilder()`:517
- `app/lib/features/maqueta/nav.dart` — class `RM`
  - `experto()`:17, `opiniones()`:18, `enviada()`:21, `comparar()`:22, `visita()`:23, `cita()`:24, `calificar()`:25, `reportar()`:26, `compartir()`:28, `chat()`:30, `ayuda()`:42, `hayCuenta()`:46, `pedirCuenta()`:51, `registrarIrA()`:60, `elegirFotos()`:70
- `app/lib/features/maqueta/oficios_reales.dart` — class `AvisoOficios`
  - `build()`:11
- `app/lib/features/maqueta/pantallas_actividad.dart` — class `Marca`, class `BarraMarcaK`, class `PgTab`, class `ActividadMaqueta`, class `MensajesScreen`, class `ChatScreen`, class `_ChatScreenState`, class `VisitaMaqueta`, class `CitaScreen`, class `CalificarScreen`, class `_CalificarScreenState`, class `ReportarScreen`, class `_ReportarScreenState`, class `CompartirScreen`, class `_CompartirScreenState`
  - `build()`:31, `build()`:55, `build()`:116, `build()`:153, `msgFab()`:231, `jobCard()`:298, `jobChat()`:507, `adjustCard()`:559, `build()`:619, `InkWell()`:654, `initState()`:740, `dispose()`:755, `build()`:812, `reprogBlock()`:1248, `BtnK()`:1256, `reprogSheet()`:1265, `cancelBlock()`:1337, `cancelSheet()`:1345, `build()`:1395, `VisitaRealGate()`:1399, `build()`:1684, `VisitaRealGate()`:1688, `initState()`:1891, `dispose()`:1898, `build()`:1928 …
- `app/lib/features/maqueta/pantallas_buscar.dart` — class `BuscarScreen`, class `_BuscarScreenState`, class `PerfilScreen`, class `_PerfilScreenState`, class `OpinionesScreen`, class `_OpinionesScreenState`, class `AsistenteScreen`, class `_AsistenteScreenState`
  - `provCard()`:16, `CardK()`:18, `initState()`:80, `dispose()`:86, `build()`:148, `reviewW()`:379, `build()`:486, `build()`:946, `initState()`:1117, `dispose()`:1136, `build()`:1235, `composerK()`:1472, `quickK()`:1478, `burbujaK()`:1480
- `app/lib/features/maqueta/pantallas_cuenta.dart` — class `CuentaMaqueta`, class `_Gl`, class `MiCasaScreen`, class `ConfianzaScreen`, class `ConfigMaqueta`, class `AvisosConfigScreen`, class `AvisosScreen`, class `AvisoScreen`, class `TerminosScreen`, class `PrivacidadScreen`, class `Eliminar1Screen`, class `_Eliminar1State`, class `Eliminar2Screen`, class `_Eliminar2State`, class `EliminadoScreen`, class `AyudaScreen`, class `_AyudaState`, class `SinConexionScreen`, class `_SinConexionState`
  - `hoja()`:28, `build()`:47, `MaqBuilder()`:57, `build()`:357, `editarDatos()`:363, `cambiarNumero()`:470, `e()`:481, `phone()`:482, `build()`:897, `build()`:1084, `Pg()`:1100, `CardK()`:1120, `build()`:1165, `build()`:1296, `build()`:1354, `build()`:1528, `build()`:1599, `build()`:1657, `build()`:1780, `dispose()`:1893, `build()`:1899, `build()`:1955, `build()`:2022, `build()`:2099
- `app/lib/features/maqueta/pantallas_solicitud.dart` — class `SolicitarScreen`, class `_SolicitarScreenState`, class `EnviadaScreen`, class `CompararScreen`, class `_CompararScreenState`
  - `initState()`:47, `dispose()`:55, `build()`:81, `FieldK()`:346, `build()`:429, `step()`:435, `stateK0()`:552, `widenBlock()`:578, `initState()`:630, `build()`:1126, `CardK()`:1160
- `app/lib/features/maqueta/pantallas_tecnico.dart` — class `RT`, class `Servicio`, class `TecRegistroScreen`, class `_TecRegistroState`, class `VerifScreen`, class `_VerifState`, class `PendienteScreen`, class `_PendienteState`, class `VerificadoScreen`, class `RechazadaScreen`, class `TrabajoMaqueta`, class `AgendaEnMapaBloque`, class `TecMensajesScreen`, class `TecChatScreen`, class `_TecChatState`
  - `chat()`:37, `cotizar()`:38, `iniciar()`:39, `cerrar()`:40, `registrarRutasTecnico()`:45, `dispose()`:158, `clean()`:237, `advErrors()`:239, `initState()`:288, `dispose()`:295, `build()`:468, `openVerif()`:830, `privacyCard()`:843, `BtnK()`:1024, `build()`:1049, `initState()`:1181, `dispose()`:1187, `build()`:1193, `build()`:1336, `build()`:1425, `visitCard()`:1519, `BtnK()`:1587, `reqCard()`:1744, `workFab()`:1795, `Positioned()`:1799 …
- `app/lib/features/maqueta/pantallas_tecnico2.dart` — class `CotizarScreen`, class `_CotizarState`, class `IniciarScreen`, class `_IniciarState`, class `CerrarScreen`, class `_CerrarState`, class `PerfilEditarScreen`, class `_PerfilEditarState`, class `ReputacionScreen`, class `_ReputacionState`
  - `dispose()`:38, `doSend()`:53, `build()`:64, `upd()`:102, `seg()`:107, `BtnK()`:277, `FieldK()`:362, `dispose()`:469, `build()`:475, `Pg()`:479, `check()`:565, `dispose()`:660, `build()`:721, `BtnK()`:845, `initState()`:895, `dispose()`:915, `build()`:978, `dispose()`:1185, `build()`:1191
- `app/lib/features/maqueta/sesiones_reales.dart` — class `SesionesAbiertas`
  - `build()`:16, `GroupK()`:20, `BtnK()`:82, `haceTiempo()`:117
- `app/lib/features/maqueta/solicitudes_reales.dart` — —
  - `claveDeOficio()`:16, `estadoDeJob()`:30, `preferenciaDeSolicitud()`:44, `jobDeSolicitud()`:54, `cuandoDeCotizacion()`:82, `provDeTecnico()`:88, `quoteDeCotizacion()`:115, `textoDeErrorReal()`:135, `provDeVisita()`:160, `aplicarVisitaAlJob()`:188
- `app/lib/features/maqueta/tecnico_estado.dart` — class `Cliente`, class `Cot`, class `Borrador`, class `Bitacora`, class `Req`, class `Visita`, class `Opinion`, class `Trabajo`, class `AvisoT`, class `Yo`, class `TecEstado`
  - `cliente()`:18, `copy()`:89, `seed()`:261, `dl()`:262, `seedDemo()`:340, `req()`:419, `reqOfClient()`:420, `visita()`:421, `dayLabel()`:432, `verifLabel()`:441, `register()`:453, `defaultSvcs()`:493, `syncMe()`:509, `verifSkip()`:587, `verifSend()`:596, `startTicker()`:619, `dispose()`:661, `ensureThread()`:664, `workerMsgs()`:668, `t()`:680, `workerSay()`:707, `reject()`:732, `dayIndexFor()`:807, `norm()`:808, `summary0()`:823 …
- `app/lib/features/maqueta/ui.dart` — class `KC`, class `T`, enum `Bk`, class `BtnK`, class `LinkK`, class `CardK`, class `Pill`, class `NoteK`, class `Av`, class `Stars`, class `ChipK`, class `ChoiceK`, class `GroupK`, class `LiK`, class `FoldK`, class `_FoldKState`, class `Sw`, class `Prog`, class `FieldK`, class `PhoneCc`, class `PhotoTile`, class `AddPhoto`, class `Pg`, class `MaqBuilder`, class `AvisosHost`, class `_AvisosHostState`
  - `tr()`:29, `hit()`:32, `kc()`:99, `build()`:136, `h1()`:150, `h2()`:153, `h3()`:155, `bT()`:157, `tT()`:159, `sMut()`:162, `mutT()`:172, `labT()`:175, `stack()`:188, `rowW()`:199, `icn()`:214, `build()`:298, `build()`:394, `build()`:427, `build()`:485, `build()`:534, `rich()`:564, `build()`:615, `build()`:674, `rateW()`:695, `whereTxt()`:722 …
- `app/lib/features/maqueta/visita_real.dart` — class `VisitaRealGate`
  - `build()`:29, `textoDeMotivoDeCodigo()`:75

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

- `app/lib/features/oficios/data/oficio_mapper.dart` — class `OficioMapper`
  - `listaDesdeContrato()`:13, `desdeContrato()`:21
- `app/lib/features/oficios/data/oficios_repository_api.dart` — class `OficiosRepositoryApi`
  - `listar()`:25, `observar()`:28
- `app/lib/features/oficios/data/oficios_repository_de_prueba.dart` — class `OficiosRepositoryDePrueba`
  - `listar()`:24
- `app/lib/features/oficios/data/oficios_repository_http.dart` — class `OficiosRepositoryHttp`
  - `listar()`:15

**domain**

- `app/lib/features/oficios/domain/modalidad.dart` — class `Modalidad`
- `app/lib/features/oficios/domain/oficio.dart` — class `Oficio`
- `app/lib/features/oficios/domain/oficios_repository.dart` — class `OficiosRepository`
- `app/lib/features/oficios/domain/resultado_oficios.dart` — class `ResultadoOficios`, class `OficiosRepositoryConCache`

**presentation**

- `app/lib/features/oficios/presentation/oficios_controller.dart` — class `OficiosSinConexion`, class `OficiosController`
  - `build()`:12, `fijar()`:14, `build()`:26, `reintentar()`:53
- `app/lib/features/oficios/presentation/oficios_screen.dart` — class `OficiosScreen`, class `_AvisoSinConexion`, class `_Cargando`, class `_Vacio`, class `_ConError`, class `_Lista`, class `_FilaOficio`
  - `build()`:19, `build()`:58, `build()`:83, `build()`:92, `build()`:104, `build()`:120, `build()`:136

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

### router

**core**

- `app/lib/core/router/app_router.dart` — —
- `app/lib/core/router/app_shell.dart` — class `_Destino`, class `AppShell`
  - `ramasVisibles()`:36, `build()`:53
- `app/lib/core/router/destino_de_regreso_provider.dart` — class `DestinoDeRegreso`
  - `build()`:10, `recordar()`:13, `olvidar()`:18
- `app/lib/core/router/rutas.dart` — class `Rutas`
  - `solicitud()`:21, `cotizaciones()`:25, `visita()`:29, `esRutaPublica()`:64, `redireccionPorSesion()`:87, `rutaDeEntrada()`:105, `destinoDeRegreso()`:124, `destinoValidoODescartar()`:129, `redireccionPorRol()`:157, `redireccionPorPerfil()`:167

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
  - `send()`:40, `close()`:76
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
