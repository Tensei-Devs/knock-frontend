# Spec 027 — Previa sin sesión (pantalla de inicio antes de entrar) según la maqueta

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Jira:** KNOCK-248 (por verificar) · **Capas:** Mobile · **Otra parte en:** knock-backend (spec 027 de búsqueda de expertos, sin implementar; queda fuera)
> **Relacionada con:** specs 002, 006, 009, 010, 014 y 026 de este repositorio. **Depende de la 026** (sesión única, Bearer solo en rutas protegidas, cierre de sesión que vuelve al login).

## 1. Objetivo
Hoy, sin sesión, la app abre directo en la pantalla de celular (`/entrar`). La maqueta muestra otra cosa: la persona ve primero la pantalla de inicio de Knock (barra de marca con «Entrar», buscador, chips de oficio, mapa con expertos y el acceso a «Explorar servicios y trabajos») y solo se le pide entrar cuando quiere actuar.

Esta spec agrega esa **previa sin sesión** con lo que hoy es posible de verdad, sin inventar datos:

- La barra de marca con «Entrar» y «Registrarme», el buscador, los chips de oficio y el catálogo de oficios **reales** (`GET /api/v1/oficios` responde sin token).
- Lo que requiere cuenta lleva al login y, al entrar, regresa a donde la persona estaba.
- El mapa con pines y la lista de expertos cercanos **no se pueden mostrar con datos reales** todavía (ver §2). En la compilación de tienda esas zonas dicen la verdad: «Muy pronto: expertos cerca de ti».
- Para la demostración ante el profesor existe un **modo demostración** (`--dart-define=KNOCK_DEMO_DATOS=true`) que, solo fuera de la tienda, llena esas zonas con datos de ejemplo rotulados «Datos de ejemplo».

## 2. Alcance
**Dentro**
- Ruta nueva de la previa, visible sin sesión y sin barra inferior; la ruta inicial sin sesión pasa a ser la previa.
- Barra de marca con «Entrar» y «Registrarme»; buscador visible que, al tocarlo, invita a entrar.
- Chips de oficio y catálogo con los oficios reales, con sus estados cargando, vacío, error y sin conexión.
- Tarjeta «Explorar servicios y trabajos» que abre el catálogo sin sesión.
- Acciones que requieren cuenta: llevan al login conservando a dónde volver; al entrar o registrarse pasa a la app normal.
- Panel «expertos cerca de ti» y zona del mapa con estado vacío honesto en tienda y datos de ejemplo en modo demostración.
- Textos ARB es/en mínimos, accesibilidad y pruebas.

**Fuera (y por qué)**
- **Mapa con pines reales y lista de expertos cercanos reales:** no existe el endpoint (la búsqueda de expertos es la spec 027 del backend, sin implementar) y el SDK de mapas necesita cuenta de facturación. Se muestra estado vacío honesto o, en demostración, datos de ejemplo.
- Búsqueda real por texto, perfil público del técnico con datos reales y «Pedir cotización» completo: dependen del mismo backend; aquí solo se deja el punto de entrada que pide cuenta.
- Cambios en la lógica de sesión de la spec 026, en `contracts/`, en `app/packages/knock_api/` o en `.github/`.
- Dependencias nuevas.

## 3. Requisitos
- **R-01:** Existe la ruta de la previa (`/previa`), fuera de la barra inferior, accesible sin sesión. Sin sesión, la ubicación inicial y el regreso tras cerrar sesión son la previa.
- **R-02:** `redireccionPorSesion` deja pasar sin sesión solo las rutas públicas (`/previa`, `/previa/oficios`, `/entrar` y sus subrutas); toda otra ruta sin sesión lleva a la previa. Con sesión, la previa y `/entrar` llevan a Inicio. No cambian `sesionIniciadaProvider` ni el resto de la lógica de la spec 026.
- **R-03:** La barra superior muestra el logo de marca y los botones «Entrar» y «Registrarme». Ambos abren `/entrar` (el alta y el ingreso comparten el flujo de celular de HU-001).
- **R-04:** El buscador «Busca un experto cerca de ti» con la leyenda «Mecánica · Plomería · Electricidad» se ve siempre. Al tocarlo abre una hoja que invita a entrar (con «Entrar», «Registrarme» y «Ahora no»); no se hace ninguna búsqueda.
- **R-05:** Los chips son «Todos», uno por cada oficio del catálogo real y «No sé cuál». «Todos» y los de oficio filtran la lista del catálogo en pantalla; «No sé cuál» invita a entrar.
- **R-06:** El catálogo usa el `OficiosRepository` existente (`GET /api/v1/oficios`, con caché y `ETag` de la spec 010) sin `Authorization`. Tiene estados cargando, vacío, error con «Reintentar» y sin conexión.
- **R-07:** La tarjeta «Explorar servicios y trabajos» abre el catálogo (`/previa/oficios`) sin pedir sesión.
- **R-08:** Toda acción que requiere cuenta (pedir cotización, ver el contacto, abrir el perfil completo de un experto) usa un solo punto, `requerirCuenta`, que lleva a `/entrar` con el destino al que volver. El destino se valida contra una lista de rutas internas permitidas; cualquier otro valor se ignora y se va a Inicio.
- **R-09:** Al entrar o registrarse con éxito, si hay destino válido se va a él; si no, a Inicio. Si el perfil está pendiente, manda la regla existente de completar perfil y luego se continúa al destino.
- **R-10:** En la compilación de tienda y sin modo demostración, el panel «N expertos cerca de ti» y la zona del mapa muestran «Muy pronto: expertos cerca de ti» con una explicación corta y sin ninguna cifra, nombre, pin ni calificación.
- **R-11:** La bandera `KNOCK_DEMO_DATOS` se lee con `String.fromEnvironment` y solo vale si la compilación **no** es `release` (`!kReleaseMode`). En `release` se ignora siempre y el código de los datos de ejemplo no queda en el binario.
- **R-12:** Con el modo demostración activo, el panel de expertos, los pines y la lista usan datos de ejemplo inventados (nombres ficticios, sin celular, sin dirección, sin coordenadas reales) y llevan siempre visible el rótulo «Datos de ejemplo». El mapa es un lienzo dibujado por la app, sin SDK de mapas.
- **R-13:** El panel muestra la colonia solo como texto de ejemplo en demostración. La previa no pide ubicación ni permisos del teléfono.
- **R-14:** Ningún dato personal ni token aparece en la previa, en los registros ni en los mensajes. Sin sesión no sale ninguna petición protegida.
- **R-15:** Textos nuevos solo en `app_es.arb` y `app_en.arb`, mínimos, con descripción. Sin dependencias nuevas.
- **R-16:** Accesibilidad: objetivos táctiles de al menos 48 dp, contraste según `contraste.dart`, etiquetas semánticas (botones, chips con estado seleccionado, pines y rótulo de ejemplo), foco ordenado y diseño que no se rompe con texto al 200 %.
- **R-17:** Los pines de ejemplo y el panel no se pueden confundir con datos reales: el rótulo «Datos de ejemplo» está en el panel, en el mapa y en la lectura de pantalla, y no se puede ocultar.

## 4. Criterios de aceptación
- **CA-01:** Dado que no hay sesión, cuando la app arranca, entonces se muestra la previa y no la pantalla de celular.
- **CA-02:** Dado que no hay sesión, cuando se abre cualquier ruta protegida (por ejemplo `/cuenta` o `/actividad`), entonces el router lleva a la previa.
- **CA-03:** Dado que no hay sesión, cuando se abre `/entrar` o `/entrar/codigo` (sin celular en memoria), entonces `/entrar` se muestra y la subruta regresa a `/entrar`, como hoy.
- **CA-04:** Dada una sesión iniciada, cuando se abre `/previa` o `/entrar`, entonces el router lleva a Inicio.
- **CA-05:** Dada una sesión cerrada desde «Mi cuenta» (spec 026), cuando termina, entonces la app queda en la previa.
- **CA-06:** Dada la previa, cuando se ve la barra superior, entonces muestra el logo, «Entrar» y «Registrarme», cada uno con al menos 48 dp.
- **CA-07:** Dada la previa, cuando se toca «Entrar» o «Registrarme», entonces se abre `/entrar`.
- **CA-08:** Dada la previa, cuando se ve el buscador, entonces dice «Busca un experto cerca de ti» y «Mecánica · Plomería · Electricidad».
- **CA-09:** Dada la previa, cuando se toca el buscador, entonces se abre la hoja que invita a entrar con «Entrar», «Registrarme» y «Ahora no», y no sale ninguna petición.
- **CA-10:** Dada la hoja de invitación, cuando se toca «Ahora no» o se desliza hacia abajo, entonces se cierra y la previa queda como estaba.
- **CA-11:** Dado un catálogo cargado, cuando se ven los chips, entonces están «Todos» (seleccionado), un chip por oficio real y «No sé cuál».
- **CA-12:** Dado un catálogo cargado, cuando se toca el chip de un oficio, entonces queda seleccionado (con su estado semántico) y la lista muestra solo ese oficio; con «Todos» vuelve a verse completa.
- **CA-13:** Dado un chip «No sé cuál», cuando se toca, entonces se abre la invitación a entrar.
- **CA-14:** Dada la previa sin sesión, cuando carga el catálogo, entonces `GET /api/v1/oficios` sale sin cabecera `Authorization`.
- **CA-15:** Dado el catálogo en proceso, cuando aún no responde, entonces se ve el estado cargando con etiqueta semántica.
- **CA-16:** Dado un catálogo vacío, cuando responde, entonces se ve el estado vacío sin botón de reintento falso.
- **CA-17:** Dado un fallo del servidor, cuando el catálogo falla, entonces se ve el mensaje de error existente con «Reintentar» y al tocarlo se vuelve a pedir.
- **CA-18:** Dado que no hay red y hay caché, cuando se abre la previa, entonces se muestra el catálogo guardado con el aviso de sin conexión; sin caché, el estado de sin conexión con «Reintentar».
- **CA-19:** Dada la previa, cuando se toca «Explorar servicios y trabajos», entonces se abre `/previa/oficios` con el catálogo y sin pedir sesión, y el botón de regreso vuelve a la previa.
- **CA-20:** Dada una acción que requiere cuenta, cuando se toca sin sesión, entonces se abre `/entrar` con el destino al que volver.
- **CA-21:** Dado un destino de regreso, cuando la persona entra con éxito, entonces la app va a ese destino; sin destino va a Inicio.
- **CA-22:** Dado un destino de regreso que no es una ruta interna permitida (por ejemplo `https://otro.sitio` o `//otro`), cuando la persona entra, entonces se ignora y va a Inicio.
- **CA-23:** Dada una cuenta nueva con destino de regreso, cuando entra, entonces primero completa el perfil y después llega al destino.
- **CA-24:** Dada una persona que se registró y entró, cuando termina, entonces ve la app normal con la barra inferior y la previa deja de ser accesible.
- **CA-25:** Dada la compilación `release` (o cualquiera sin la bandera), cuando se abre la previa, entonces el panel dice «Muy pronto: expertos cerca de ti» y no muestra pines, nombres, cifras ni calificaciones.
- **CA-26:** Dada la bandera `KNOCK_DEMO_DATOS=true` en una compilación no `release`, cuando se abre la previa, entonces el panel muestra «N expertos cerca de ti», la colonia, «Ver lista», las tarjetas de expertos y el mapa con pines, todo con el rótulo «Datos de ejemplo».
- **CA-27:** Dada la bandera `KNOCK_DEMO_DATOS=true` en una compilación `release`, cuando se abre la previa, entonces se comporta como CA-25 y el binario no contiene el rótulo ni los nombres de los datos de ejemplo.
- **CA-28:** Dado el modo demostración, cuando se toca una tarjeta de experto o un pin, entonces se pide cuenta (CA-20) y nunca se muestra contacto ni dirección.
- **CA-29:** Dado el modo demostración, cuando se lee la pantalla con lector de pantalla, entonces el panel, el mapa y cada tarjeta anuncian «Datos de ejemplo».
- **CA-30:** Dado el modo demostración, cuando se recorre la previa, entonces no se pide ubicación ni ningún permiso del teléfono.
- **CA-31:** Dado texto al 200 %, cuando se ve la previa y el catálogo, entonces nada se corta ni se traslapa y todo se alcanza con desplazamiento.
- **CA-32:** Dado el idioma en inglés o español, cuando se ve la previa, entonces todos los textos salen del ARB de ese idioma, sin cadenas fijas.
- **CA-33:** Dada la previa en cualquier estado, cuando se revisan registros, `toString` y mensajes, entonces no aparece ningún token, celular ni dato personal.
- **CA-34:** Dado el flujo previa → «Entrar» → celular → código → Inicio, cuando se completa, entonces el login se comporta igual que antes de esta spec (regresión de HU-001).

## 5. Contrato consumido
Versión de la API: `v1`. La URL base llega por `--dart-define=KNOCK_API_URL`, nunca fija en el código. Fuente: especificación de oficios del backend y spec 026 (§5).

| Endpoint | Auth | Cuerpo / consulta | Respuestas | Notas para la app |
|---|---|---|---|---|
| `GET /oficios` | No | — | 200 lista de oficios, 304, 5xx | Es lo único que consume la previa. Con `ETag` y caché (spec 010). **Nunca** lleva `Authorization`. |

No se consume ningún otro endpoint sin sesión. La búsqueda de expertos, la lista cercana y el mapa **no tienen endpoint**: por eso son vacío honesto o datos de ejemplo (§2). `GET /colonias/en-punto` es protegido (spec 026) y la previa no lo llama.

## 6. Modelo de datos local
- Sin tablas ni almacenamiento nuevos. El oficio elegido en los chips y el estado de la hoja viven en memoria de la pantalla.
- El destino de regreso viaja como parámetro de ruta interno (`volver`), validado contra la lista de rutas permitidas; no se guarda en disco.
- Los datos de ejemplo son constantes de código en un archivo aparte (`datos_de_ejemplo.dart`) importado solo detrás de la condición del modo demostración, para que `release` los elimine.

## 7. Arquitectura
- `core/router/rutas.dart`: `Rutas.previa` (`/previa`), `Rutas.previaOficios` (`/previa/oficios`) y la lista de destinos permitidos; `redireccionPorSesion` pasa a usar la previa como destino sin sesión.
- `core/router/app_router.dart`: ruta de la previa fuera del `StatefulShellRoute`; `initialLocation` pasa a la previa cuando no hay sesión.
- `features/previa/` (nueva): `presentation/previa_screen.dart`, `barra_marca.dart`, `buscador_previa.dart`, `chips_oficio.dart`, `hoja_invitacion.dart`, `panel_expertos.dart`, `mapa_ejemplo.dart`; `domain/requerir_cuenta.dart` y `domain/destino_de_regreso.dart`.
- `core/config/modo_demostracion.dart`: `demoActivo({required bool bandera, required bool esRelease})` puro y `demoDatosActivo`, que usa `const bool.fromEnvironment('KNOCK_DEMO_DATOS')` y `kReleaseMode`.
- `features/previa/demo/datos_de_ejemplo.dart`: expertos, pines y colonia ficticios; solo se importa desde el panel y el mapa detrás de `if (demoDatosActivo)`.
- El catálogo reutiliza `OficiosScreen`, `OficiosController` y `oficiosRepositoryProvider`. `presentation/` no importa `data/` (regla vigente).
- Verificación de `release`: script `scripts/verificar_release_sin_demo.py` que busca el rótulo y los nombres de ejemplo en el binario compilado.

## 8. Amenazas y controles
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| La bandera de demostración llega a la tienda y se muestran expertos inventados como si fueran reales | `demoActivo` exige `!kReleaseMode`; los datos viven en un archivo que `release` descarta; el script revisa el binario; el CI compila `release` con la bandera y falla si encuentra el rótulo | CA-25, CA-27 |
| Datos de ejemplo confundidos con reales en la demo | Rótulo «Datos de ejemplo» fijo en panel, mapa y tarjetas, también en la lectura de pantalla; nombres claramente ficticios | CA-26, CA-29 |
| Datos de ejemplo con personas reales o contacto | Nombres inventados, sin celular, dirección ni coordenadas reales; tocar una tarjeta pide cuenta | CA-28 |
| Redirección abierta con el destino de regreso (`volver`) | Lista de rutas internas permitidas; todo lo demás va a Inicio | CA-22 |
| Petición protegida sin sesión o Bearer enviado a un endpoint público | Solo `GET /oficios` sin `Authorization`; pruebas del transporte de la spec 026 | CA-14, CA-33 |
| Acceso a pantallas protegidas sin sesión | `redireccionPorSesion` lleva a la previa y deja pasar solo lo público | CA-02, CA-03 |
| Fuga de datos personales o tokens en logs o mensajes | Sin `print`; errores como `Failure` sin cuerpo | CA-33 |
| Permisos del teléfono pedidos antes de tener cuenta | La previa no usa ubicación ni notificaciones | CA-30 |
| Bucle de redirecciones previa, entrar e inicio | Pruebas de la tabla completa de rutas y estados de sesión | CA-02 a CA-05 |

## 9. Plan de pruebas
Las pruebas citan el caso como `CA-027-NN` en el nombre (para `python scripts/sdd_lint.py --trace 027`).

| Tipo | ¿Aplica? | Qué se prueba / herramienta |
|---|---|---|
| Unitarias | Sí | `redireccionPorSesion` (tabla de rutas por sesión): CA-02 a CA-04; `destino_de_regreso` válido e inválido: CA-22; `demoActivo` (bandera por release): CA-25, CA-27; datos de ejemplo sin celular ni dirección: CA-28; filtro por chip: CA-12 |
| Widget por estado | Sí | Previa con catálogo cargando, vacío, error, sin conexión y con datos: CA-11, CA-15 a CA-18; panel en tienda y en demostración: CA-25, CA-26; hoja de invitación: CA-09, CA-10, CA-13; barra de marca: CA-06, CA-07; español e inglés: CA-32 |
| Integración del flujo | Sí | Previa → «Entrar» → celular → código → Inicio con servicio de entrada simulado; acción protegida → login → regreso al destino; cuenta nueva → completar perfil → destino; cerrar sesión → previa: CA-01, CA-05, CA-19 a CA-21, CA-23, CA-24, CA-34 |
| Seguridad negativa | Sí | `GET /oficios` sin `Authorization` con `MockClient`: CA-14; destinos de regreso hostiles: CA-22; `release` ignora la bandera, con `demoActivo` y con el script sobre el binario: CA-27; sin tokens ni datos personales en registros: CA-33; sin permisos: CA-30 |
| Accesibilidad | Sí | `meetsGuideline(androidTapTargetGuideline)` y de contraste, etiquetas semánticas de chips, pines y rótulo, texto al 200 % sin desbordes: CA-06, CA-29, CA-31 |
| Regresión del login | Sí | Las pruebas existentes de `celular_screen`, `codigo_screen` y `entrada_controller` siguen en verde sin cambios: CA-03, CA-34 |
| Manual | Sí | Humo en teléfono: compilación de tienda (vacío honesto) y compilación de demostración (maqueta) con capturas para el PR; no sustituye lo automático |

## 10. Escenarios
1. **Primera vez, tienda.** Abre la app, ve la barra con «Entrar», el buscador y los chips con oficios reales; el panel dice «Muy pronto: expertos cerca de ti». Toca «Explorar servicios y trabajos», ve el catálogo, toca el buscador y se le invita a entrar.
2. **Sin internet.** Con caché ve el catálogo y el aviso; sin caché, el estado de sin conexión y «Reintentar».
3. **Demostración ante el profesor.** Compilación con `--dart-define=KNOCK_DEMO_DATOS=true`: ve «3 expertos cerca de ti», la colonia de ejemplo, «Ver lista», el mapa con pines y «Datos de ejemplo» en todo. Toca un experto y se le pide entrar.
4. **Entra desde una acción.** Toca una acción protegida, entra con celular y código y regresa a donde estaba.
5. **Cierra sesión.** Vuelve a la previa, no a la pantalla de celular.

## 11. Definición de terminado
- Los 34 criterios de aceptación tienen prueba (la prueba en teléfono, evidencia manual) y `sdd_lint --trace 027` no reporta drift.
- `flutter analyze`, `dart format` y `flutter test` en verde; el CI en verde.
- Se compiló `release` con `KNOCK_DEMO_DATOS=true` y el script confirma que no hay rastro de los datos de ejemplo.
- Se probó el flujo previa → login → app y la regresión de HU-001.
- Un par revisó el cambio y la sección «Uso de IA» está en el PR.
- `Memoria.md` registra la decisión, lo pendiente (spec 027 del backend, mapa) y qué evitar; el mapa de arquitectura se regeneró con `scripts/codemap.py`.
- No se tocaron `contracts/`, `app/packages/knock_api/` ni `.github/`.

## 12. Decisiones tomadas sin consulta
Quien aprueba la spec las acepta o las cambia aquí antes de aprobar.

- **D-01 «Registrarme» y «Entrar» abren el mismo flujo.** HU-001 crea la cuenta si no existe; no hay pantalla de alta aparte. Cambia si José quiere un texto o paso distinto.
- **D-02 Chips con los oficios reales del catálogo** en lugar de los fijos de la maqueta («Mi auto», «Agua y tuberías», «Luz y contactos»), porque esos nombres no existen en la API. «Todos» y «No sé cuál» se conservan. Para la demostración se puede pedir que los chips usen las palabras de la maqueta.
- **D-03 Cerrar sesión lleva a la previa,** no a `/entrar` (la spec 026 decía `/entrar`). Es solo la ruta de destino; la lógica de sesión no cambia.
- **D-04 La previa vive fuera del shell** (sin barra inferior): la maqueta sin cuenta usa su propia barra de marca.
- **D-05 La bandera solo actúa si `!kReleaseMode`.** Un perfil `profile` o `debug` sí la respeta; solo `release` (la tienda) la ignora.
- **D-06 El mapa de ejemplo es un lienzo dibujado por la app,** sin SDK de mapas, para no depender de facturación.
- **D-07 El buscador no busca:** abre la invitación a entrar. La búsqueda real espera al backend.
- **D-08 Destinos de regreso permitidos:** las pestañas de la app, `/previa/oficios` y las subrutas de Explorar. Cualquier otra cosa va a Inicio.
- **D-09 El CI de `release` sin demostración** se pide a quien tenga permiso sobre `.github/`; aquí se entrega el script y la prueba local.
- **D-10 Clave de Jira** `KNOCK-248 (por verificar)`: no hubo acceso a Jira.
- **D-11 Numeración:** esta spec es la 027 del frontend; la «spec 027 del backend» es otra (búsqueda de expertos).

## 13. Riesgos y dudas abiertas
- **Demostración vista como producto:** si el profesor cree que los expertos son reales. Mitigación: rótulo fijo y aclararlo en la presentación.
- **Binario de demostración instalado en la tienda por error:** mitigación en R-11 y en el CI; depende de que el paso del CI se agregue.
- **La maqueta promete más que la tienda:** la compilación de tienda mostrará «Muy pronto» hasta que exista la búsqueda en el backend.
- **Duda:** ¿«Mi auto», «Agua y tuberías» y «Luz y contactos» deben existir como nombres comunes en el catálogo del backend? Se confirma con el backend.
- **Duda:** ¿el panel de ejemplo debe poder abrir un perfil de ejemplo sin sesión para la demostración? Hoy no, por seguridad.
- **Dependencia de la spec 026:** si no está implementada, `GET /oficios` y el cierre de sesión no se comportan como esta spec supone.
- No se verificó la clave de Jira ni el contrato desplegado en esta etapa.

## Aprobación
- [ ] Revisor 1 — nombre: ____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
