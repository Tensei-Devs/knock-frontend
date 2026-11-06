# Mapa de código

> Generado por `scripts/codemap.py` el 2026-11-06T23:46:49Z. No editar a mano.
> **Antes de crear una clase, método o archivo, busca aquí o corre `python scripts/codemap.py --query "<qué necesitas>"`.**

## Resumen

| Módulo | Capas | Archivos | Tipos | Métodos públicos |
|---|---|---|---|---|
| `actividad` | presentation | 1 | 1 | 1 |
| `app` | - | 3 | 2 | 5 |
| `cache` | core | 2 | 7 | 9 |
| `cuenta` | -, data, domain, presentation | 11 | 15 | 19 |
| `entrada` | domain, presentation | 7 | 12 | 24 |
| `errores` | core | 3 | 15 | 3 |
| `explorar` | presentation | 1 | 1 | 1 |
| `home` | -, components, pages | 3 | 2 | 0 |
| `inicio` | -, data, domain, presentation | 19 | 41 | 28 |
| `l10n` | - | 3 | 4 | 11 |
| `layout` | core | 1 | 1 | 0 |
| `notificaciones` | core | 7 | 17 | 20 |
| `oficios` | -, data, domain, presentation | 11 | 18 | 17 |
| `panel` | - | 3 | 1 | 0 |
| `permisos` | core | 2 | 4 | 4 |
| `preferencias` | core | 4 | 9 | 17 |
| `red` | core | 6 | 4 | 10 |
| `router` | core | 3 | 3 | 6 |
| `sesion` | core | 13 | 25 | 42 |
| `tema` | core | 3 | 3 | 1 |
| `trabajo` | presentation | 1 | 1 | 1 |
| `widgets` | core | 1 | 1 | 1 |

## Tipos con el mismo nombre en varios lugares

- `EntradaCache`: `app/lib/core/cache/almacen_cache.dart:8`, `app/lib/core/red/cache_respuestas.dart:7`
- `SesionNotifier`: `app/lib/core/sesion/sesion.dart:80`, `app/lib/core/sesion/sesion_provider.dart:27`

## Índice por módulo

### actividad

**presentation**

- `app/lib/features/actividad/presentation/actividad_screen.dart` — class `ActividadScreen`
  - `build()`:11

### app

**-**

- `app/lib/app.dart` — class `KnockApp`
  - `build()`:16
- `app/lib/main.dart` — —
  - `main()`:14, `arrancar()`:19
- `app/lib/main_spike_mapa.dart` — class `SpikeMapaApp`
  - `main()`:11, `build()`:20

### cache

**core**

- `app/lib/core/cache/almacen_cache.dart` — class `EntradaCache`, class `AlmacenCache`, class `AlmacenCacheEnMemoria`, class `AlmacenCacheShared`
  - `conFecha()`:19, `esClaveCacheable()`:34, `leer()`:53, `guardar()`:56, `borrarTodo()`:62, `leer()`:78, `guardar()`:99, `borrarTodo()`:112
- `app/lib/core/cache/revalidador_etag.dart` — enum `OrigenCache`, class `RespuestaCache`, class `RevalidadorEtag`
  - `leerGuardado()`:52

### cuenta

**-**

- `app/lib/features/cuenta/cuenta_providers.dart` — —

**data**

- `app/lib/features/cuenta/data/perfil_repository_simulado.dart` — class `PerfilRepositorySimulado`
  - `obtener()`:22, `guardarNombre()`:25, `cerrarSesion()`:29

**domain**

- `app/lib/features/cuenta/domain/perfil.dart` — class `Perfil`
  - `validarNombre()`:31
- `app/lib/features/cuenta/domain/perfil_repository.dart` — class `PerfilRepository`

**presentation**

- `app/lib/features/cuenta/presentation/avatar_iniciales.dart` — class `AvatarIniciales`
  - `build()`:12
- `app/lib/features/cuenta/presentation/completar_perfil_screen.dart` — class `CompletarPerfilScreen`, class `_EstadoCompletar`, class `_Listo`
  - `dispose()`:26, `build()`:51, `build()`:103
- `app/lib/features/cuenta/presentation/configuracion_screen.dart` — class `ConfiguracionScreen`, class `_Encabezado`, class `_Opcion`
  - `build()`:17, `build()`:79, `build()`:96
- `app/lib/features/cuenta/presentation/cuenta_screen.dart` — class `CuentaScreen`
  - `build()`:43
- `app/lib/features/cuenta/presentation/perfil_controller.dart` — class `PerfilController`
  - `build()`:11, `guardarNombre()`:14, `cerrarSesion()`:22, `reintentar()`:31
- `app/lib/features/cuenta/presentation/widgets/menu_de_prueba.dart` — class `MenuDePrueba`
  - `build()`:15
- `app/lib/features/cuenta/presentation/widgets/seccion_avisos.dart` — class `SeccionAvisos`, class `_SeccionAvisosState`
  - `initState()`:28, `build()`:55

### entrada

**domain**

- `app/lib/features/entrada/domain/validacion_entrada.dart` — —
  - `esCelularValido()`:17, `esCodigoValido()`:20, `formatearCelular()`:25

**presentation**

- `app/lib/features/entrada/presentation/celular_screen.dart` — class `CelularScreen`, class `_CelularScreenState`, class `_CasillaDelAviso`
  - `dispose()`:34, `build()`:58, `build()`:140, `CheckboxListTile()`:169
- `app/lib/features/entrada/presentation/codigo_screen.dart` — class `CodigoScreen`, class `_CodigoScreenState`
  - `dispose()`:35, `build()`:67
- `app/lib/features/entrada/presentation/cuenta_regresiva_controller.dart` — class `CuentaRegresivaNotifier`
  - `build()`:18, `reiniciar()`:25
- `app/lib/features/entrada/presentation/entrada_controller.dart` — class `EntradaUiState`, class `EntradaController`
  - `copyWith()`:23, `build()`:41, `enviarCodigo()`:46, `reenviar()`:64, `verificar()`:82, `limpiarError()`:106
- `app/lib/features/entrada/presentation/mensaje_de_error.dart` — —
  - `mensajeDeErrorDeEntrada()`:5
- `app/lib/features/entrada/presentation/widgets/marco_de_entrada.dart` — class `MarcoDeEntrada`, class `_Marca`, class `BotonPrincipalDeEntrada`, class `MensajeDeErrorDeEntrada`
  - `build()`:30, `build()`:95, `decoracionDeEntrada()`:132, `estiloBotonPrincipal()`:154, `build()`:181, `build()`:203

### errores

**core**

- `app/lib/core/errores/failure.dart` — class `Failure`, class `DatosInvalidosFailure`, class `ServicioNoDisponibleFailure`, class `ApiNoConfiguradaFailure`, class `NoAutorizadoFailure`, class `CuentaSuspendidaFailure`, class `AccesoDenegadoFailure`, class `ConflictoFailure`, class `DatosRechazadosFailure`, class `DemasiadosIntentosFailure`, class `AvisoNoAceptadoFailure`, class `CodigoIncorrectoFailure`, class `CodigoVencidoFailure`, class `CelularRechazadoFailure`, class `VerificacionNoDisponibleFailure`
  - `toString()`:10
- `app/lib/core/errores/mensaje_failure.dart` — —
  - `mensajeDeError()`:10
- `app/lib/core/errores/mensajes_failure.dart` — —
  - `mensajeDeFailure()`:7

### explorar

**presentation**

- `app/lib/features/explorar/presentation/explorar_screen.dart` — class `ExplorarScreen`
  - `build()`:15

### home

**-**

- `panel/src/app/features/home/home.routes.ts` — —

**components**

- `panel/src/app/features/home/components/static-menu.component.ts` — class `StaticMenuComponent`

**pages**

- `panel/src/app/features/home/pages/home-page.component.ts` — class `HomePageComponent`

### inicio

**-**

- `app/lib/features/inicio/inicio_providers.dart` — —
- `app/lib/features/inicio/zona_providers.dart` — class `EstadoZona`, class `ZonaSinElegir`, class `ZonaPideCodigoPostal`, class `ZonaPorUbicacion`, class `ZonaPorCodigoPostal`, class `ZonaController`
  - `esCodigoPostalValido()`:31, `build()`:40, `usarCodigoPostal()`:60

**data**

- `app/lib/features/inicio/data/colonia_mapper.dart` — class `ColoniaMapper`
  - `desdeContrato()`:7
- `app/lib/features/inicio/data/colonias_repository_http.dart` — class `ColoniasRepositoryHttp`
  - `enPunto()`:19
- `app/lib/features/inicio/data/colonias_repository_simulado.dart` — class `ColoniasRepositorySimulado`
  - `enPunto()`:11
- `app/lib/features/inicio/data/ubicacion_geolocator_repository.dart` — class `UbicacionGeolocatorRepository`
  - `obtenerUnaVez()`:19, `abrirAjustes()`:64

**domain**

- `app/lib/features/inicio/domain/colonia.dart` — class `Colonia`, class `ResultadoColonia`
- `app/lib/features/inicio/domain/colonias_repository.dart` — class `ColoniasRepository`
- `app/lib/features/inicio/domain/punto_mapa.dart` — class `PuntoMapa`
  - `toString()`:28
- `app/lib/features/inicio/domain/ubicacion_repository.dart` — class `ResultadoUbicacion`, class `Concedida`, class `Denegada`, class `DenegadaParaSiempre`, class `ServicioDesactivado`, class `UbicacionRepository`
  - `toString()`:16

**presentation**

- `app/lib/features/inicio/presentation/colonia_controller.dart` — class `EstadoColonia`, class `ColoniaSinPedir`, class `ColoniaConsultando`, class `ColoniaEncontrada`, class `ColoniaFueraDeCobertura`, class `ColoniaSinUbicacion`, class `ColoniaConError`, class `ColoniaController`
  - `build()`:44, `consultar()`:46
- `app/lib/features/inicio/presentation/inicio_screen.dart` — class `InicioScreen`, class `_TarjetaColonia`
  - `build()`:17, `build()`:57
- `app/lib/features/inicio/presentation/mapa/boton_mi_ubicacion.dart` — class `BotonMiUbicacion`
  - `build()`:23, `FloatingActionButton()`:43
- `app/lib/features/inicio/presentation/mapa/mapa_con_pines.dart` — class `MapaConPines`, class `_MapaConPinesState`, class `_CamaraGoogleMap`
  - `didUpdateWidget()`:37, `build()`:45, `moverA()`:71
- `app/lib/features/inicio/presentation/mapa/marcadores.dart` — —
  - `construirMarcadores()`:16
- `app/lib/features/inicio/presentation/mapa/mi_ubicacion_controller.dart` — class `CamaraMapa`, enum `AvisoUbicacion`, class `MiUbicacionController`
  - `build()`:43, `centrar()`:46, `abrirAjustes()`:65
- `app/lib/features/inicio/presentation/spike/mapa_spike_screen.dart` — class `MapaSpikeScreen`, class `_MapaSpikeScreenState`
  - `build()`:30, `Scaffold()`:31
- `app/lib/features/inicio/presentation/spike/pines_de_prueba.dart` — —
  - `pinesDePrueba()`:28
- `app/lib/features/inicio/presentation/zona/selector_de_zona.dart` — class `SelectorDeZona`, class `_SelectorDeZonaState`
  - `dispose()`:30, `build()`:53

### l10n

**-**

- `app/lib/l10n/generado/app_localizations.dart` — class `AppLocalizations`, class `_AppLocalizationsDelegate`
  - `of()`:70, `load()`:689, `isSupported()`:694, `shouldReload()`:698, `lookupAppLocalizations()`:701
- `app/lib/l10n/generado/app_localizations_en.dart` — class `AppLocalizationsEn`
  - `entradaAceptoAviso()`:256, `entradaCodigoEnviadoA()`:312, `entradaReenviarEn()`:326
- `app/lib/l10n/generado/app_localizations_es.dart` — class `AppLocalizationsEs`
  - `entradaAceptoAviso()`:257, `entradaCodigoEnviadoA()`:315, `entradaReenviarEn()`:329

### layout

**core**

- `panel/src/app/core/layout/app-shell.component.ts` — class `AppShellComponent`

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
  - `build()`:15, `build()`:54, `build()`:71, `build()`:80, `build()`:97, `build()`:125, `build()`:137

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

### preferencias

**core**

- `app/lib/core/preferencias/almacen_avisos.dart` — enum `TipoAviso`, class `AlmacenAvisos`, mixin `AvisosSobreShared`, mixin `AvisosEnMemoria`
  - `claveDeAviso()`:28, `leerAviso()`:34, `guardarAviso()`:40, `leerAviso()`:48, `guardarAviso()`:51
- `app/lib/core/preferencias/almacen_preferencias.dart` — class `AlmacenPreferencias`, class `AlmacenPreferenciasShared`, class `AlmacenPreferenciasEnMemoria`
  - `leerTema()`:47, `leerIdioma()`:50, `guardarTema()`:53, `guardarIdioma()`:57, `leerTema()`:73, `leerIdioma()`:76, `guardarTema()`:79, `guardarIdioma()`:82
- `app/lib/core/preferencias/arranque.dart` — —
- `app/lib/core/preferencias/preferencias_provider.dart` — class `Preferencias`, class `PreferenciasNotifier`
  - `copyWith()`:25, `build()`:47, `cambiarTema()`:55, `cambiarIdioma()`:61

### red

**core**

- `app/lib/core/red/cache_respuestas.dart` — class `EntradaCache`, class `CacheRespuestas`, class `ClienteConCache`
  - `obtener()`:38, `guardar()`:48, `borrarTodo()`:63, `send()`:80, `close()`:125
- `app/lib/core/red/cliente_api_provider.dart` — —
- `app/lib/core/red/configuracion_api.dart` — —
  - `normalizarUrlApi()`:15
- `app/lib/core/red/errores_api.dart` — —
  - `mapearErrorApi()`:11
- `app/lib/core/red/espera_por_limite.dart` — class `ClienteConEspera`
  - `send()`:32, `close()`:75
- `app/lib/core/red/obtener_json.dart` — —
  - `obtenerJson()`:15

### router

**core**

- `app/lib/core/router/app_router.dart` — —
- `app/lib/core/router/app_shell.dart` — class `_Destino`, class `AppShell`
  - `ramasVisibles()`:35, `build()`:48, `Scaffold()`:53
- `app/lib/core/router/rutas.dart` — class `Rutas`
  - `redireccionPorSesion()`:30, `redireccionPorRol()`:45, `redireccionPorPerfil()`:55

### sesion

**core**

- `app/lib/core/sesion/almacen_seguro.dart` — class `AlmacenSeguro`, class `AlmacenSeguroEnMemoria`, class `AlmacenSeguroFlutterSecureStorage`
  - `leer()`:25, `escribir()`:28, `borrar()`:32, `leer()`:44, `escribir()`:47, `borrar()`:51
- `app/lib/core/sesion/almacen_sesion.dart` — class `AlmacenSesion`
  - `guardar()`:17, `leerAcceso()`:25, `leerRefresco()`:27, `cerrarSesion()`:29
- `app/lib/core/sesion/arranque_sesion.dart` — —
  - `iniciarFirebase()`:16, `haySesionGuardada()`:35
- `app/lib/core/sesion/canje_sesion.dart` — class `SesionEmitida`, class `CanjeSesion`, class `CanjeSesionApi`
  - `toString()`:24, `canjear()`:46
- `app/lib/core/sesion/cliente_autenticado.dart` — class `ClienteAutenticado`
  - `send()`:23, `close()`:47
- `app/lib/core/sesion/es_tecnico_provider.dart` — class `EsTecnicoNotifier`
  - `build()`:13, `cambiar()`:16
- `app/lib/core/sesion/identificador_dispositivo.dart` — class `IdentificadorDispositivo`
  - `obtener()`:25
- `app/lib/core/sesion/preparar_canje.dart` — class `PrepararCanje`
  - `preparar()`:18
- `app/lib/core/sesion/servicio_entrada.dart` — class `ResultadoEntrada`, class `ServicioEntrada`, class `ServicioEntradaReal`
  - `enviarCodigo()`:45, `verificarCodigo()`:51
- `app/lib/core/sesion/sesion.dart` — class `TokensSesion`, class `AlmacenTokens`, class `AlmacenTokensEnMemoria`, class `RenovadorSesion`, class `RenovadorNoDisponible`, class `SesionNotifier`
  - `toString()`:25, `leer()`:44, `guardar()`:47, `borrar()`:50, `renovar()`:68, `build()`:84, `iniciar()`:87, `cerrar()`:94, `renovar()`:103
- `app/lib/core/sesion/sesion_provider.dart` — class `SesionNotifier`
  - `build()`:29, `iniciar()`:32, `nombreDeDispositivo()`:56
- `app/lib/core/sesion/verificador_celular.dart` — class `SolicitudCodigo`, class `VerificadorCelular`, class `VerificadorNoConfigurado`
  - `toString()`:26, `enviarCodigo()`:52, `tokenDeId()`:58, `cerrarSesion()`:62
- `app/lib/core/sesion/verificador_celular_firebase.dart` — class `VerificadorCelularFirebase`
  - `enviarCodigo()`:21, `tokenDeId()`:66, `cerrarSesion()`:84, `mapearErrorFirebase()`:88

### tema

**core**

- `app/lib/core/tema/colores.dart` — class `ColoresClaro`, class `ColoresOscuro`, class `ColoresError`
- `app/lib/core/tema/contraste.dart` — —
  - `relacionDeContraste()`:16
- `app/lib/core/tema/tema.dart` — —

### trabajo

**presentation**

- `app/lib/features/trabajo/presentation/trabajo_screen.dart` — class `TrabajoScreen`
  - `build()`:11

### widgets

**core**

- `app/lib/core/widgets/pantalla_titulada.dart` — class `PantallaTitulada`
  - `build()`:14
