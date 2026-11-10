# Spec 027 — Previa sin sesión (pantalla de inicio antes de entrar) según la maqueta

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Jira:** KNOCK-248 (por verificar) · **Capas:** Mobile · **Otra parte en:** knock-backend (spec 027 de búsqueda de expertos, sin implementar; queda fuera)
> **Relacionada con:** specs 002, 006, 009, 010, 014 y 026 de este repositorio. **Depende de la 026** (sesión única, Bearer solo en rutas protegidas, cierre de sesión que vuelve al login).

## 1. Objetivo
Hoy, sin sesión, la app abre directo en la pantalla de celular (`/entrar`). La maqueta muestra otra cosa: la persona ve primero la pantalla de inicio de Knock (barra de marca con «Entrar», buscador, chips de oficio, mapa con expertos y el acceso a «Explorar servicios y trabajos») y solo se le pide entrar cuando quiere actuar.

Esta spec agrega esa **previa sin sesión** con lo que hoy es posible de verdad y, donde falta el backend, con datos de ejemplo siempre rotulados:

- La barra de marca con «Entrar» y «Registrarme», el buscador, los chips de oficio y el catálogo de oficios **reales** (`GET /api/v1/oficios` responde sin token).
- Lo que requiere cuenta lleva al login y, al entrar, regresa a donde la persona estaba.
- El mapa con pines y la lista de expertos cercanos **no se pueden mostrar con datos reales** todavía (ver §2). La previa muestra un **mapa a pantalla completa como el de la maqueta** (dibujado por la app) con **expertos de ejemplo siempre visibles y siempre rotulados «Datos de ejemplo»**, también en la tienda (decisión D-12 del Tech Lead). No hay bandera de compilación que los active.

## 2. Alcance
**Dentro**
- Ruta nueva de la previa, visible sin sesión y sin barra inferior; la ruta inicial sin sesión pasa a ser la previa.
- Barra de marca con «Entrar» y «Registrarme»; buscador visible que, al tocarlo, invita a entrar.
- Chips de oficio y catálogo con los oficios reales, con sus estados cargando, vacío, error y sin conexión.
- Tarjeta «Explorar servicios y trabajos» que abre el catálogo sin sesión.
- Acciones que requieren cuenta: llevan al login conservando a dónde volver; al entrar o registrarse pasa a la app normal.
- Mapa a pantalla completa dibujado por la app (calles, avenidas, parques, río, punto «Tú estás aquí»), con pan, zoom y botones, pines de ejemplo con su calificación y el color de su oficio, y panel inferior plegable «expertos cerca de ti»; todo rotulado «Datos de ejemplo».
- Textos ARB es/en mínimos, accesibilidad y pruebas.

**Fuera (y por qué)**
- **Mapa con pines reales y lista de expertos cercanos reales:** no existe el endpoint (la búsqueda de expertos es la spec 027 del backend, sin implementar) y el SDK de mapas necesita cuenta de facturación. Se muestran datos de ejemplo siempre rotulados.
- Búsqueda real por texto, perfil público del técnico con datos reales y «Pedir cotización» completo: dependen del mismo backend; aquí solo se deja el punto de entrada que pide cuenta.
- Cambios en la lógica de sesión de la spec 026, en `contracts/`, en `app/packages/knock_api/` o en `.github/`.
- Dependencias nuevas.

## 3. Requisitos
- **R-01:** Existe la ruta de la previa (`/previa`), fuera de la barra inferior, accesible sin sesión. Sin sesión, la ubicación inicial y el regreso tras cerrar sesión son la previa.
- **R-02:** `redireccionPorSesion` deja pasar sin sesión solo las rutas públicas (`/previa`, `/previa/oficios`, `/entrar` y sus subrutas); toda otra ruta sin sesión lleva a la previa. Con sesión, la previa y `/entrar` llevan a Inicio. No cambian `sesionIniciadaProvider` ni el resto de la lógica de la spec 026.
- **R-03:** La barra superior muestra el logo de marca y los botones «Entrar» y «Registrarme». Ambos abren `/entrar` (el alta y el ingreso comparten el flujo de celular de HU-001).
- **R-04:** El buscador «Busca un experto cerca de ti» con la leyenda «Mecánica · Plomería · Electricidad» se ve siempre. Al tocarlo abre una hoja que invita a entrar (con «Entrar», «Registrarme» y «Ahora no»); no se hace ninguna búsqueda.
- **R-05:** Los chips son «Todos», uno por cada oficio del catálogo real y «No sé cuál». «Todos» y los de oficio filtran la lista del catálogo, los pines y las tarjetas de expertos de ejemplo; «No sé cuál» invita a entrar. Van en una fila que se desplaza de lado, flotando sobre el mapa.
- **R-06:** El catálogo usa el `OficiosRepository` existente (`GET /api/v1/oficios`, con caché y `ETag` de la spec 010) sin `Authorization`. Tiene estados cargando, vacío, error con «Reintentar» y sin conexión.
- **R-07:** La tarjeta «Explorar servicios y trabajos» abre el catálogo (`/previa/oficios`) sin pedir sesión.
- **R-08:** Toda acción que requiere cuenta (pedir cotización, ver el contacto, abrir el perfil completo de un experto) usa un solo punto, `requerirCuenta`, que lleva a `/entrar` con el destino al que volver. El destino se valida contra una lista de rutas internas permitidas; cualquier otro valor se ignora y se va a Inicio.
- **R-09:** Al entrar o registrarse con éxito, si hay destino válido se va a él; si no, a Inicio. Si el perfil está pendiente, manda la regla existente de completar perfil y luego se continúa al destino.
- **R-10:** El panel inferior «N expertos cerca de ti» (N = expertos de ejemplo visibles) es plegable, como la hoja de la maqueta: asomado, a la mitad (inicial) y casi completo; «Ver lista» lo sube y «Ver mapa» lo baja. Trae la colonia de ejemplo, «Explorar servicios y trabajos», las tarjetas de los expertos y el catálogo real de oficios.
- **R-11:** Los expertos, los pines y la colonia de ejemplo se muestran **siempre**, también en la compilación de tienda: no dependen de ninguna bandera ni de `kReleaseMode` (decisión D-12, que reemplaza a la bandera `KNOCK_DEMO_DATOS` de la versión anterior de esta spec).
- **R-12:** Los datos de ejemplo son inventados (nombres ficticios con «Muestra», sin celular, sin dirección, sin coordenadas geográficas) y llevan siempre visible el rótulo «Datos de ejemplo». El mapa es un lienzo dibujado por la app, sin SDK de mapas.
- **R-13:** La colonia del panel es solo texto de ejemplo y el punto «Tú estás aquí» es un punto fijo de ejemplo. La previa no pide ubicación ni permisos del teléfono.
- **R-14:** Ningún dato personal ni token aparece en la previa, en los registros ni en los mensajes. Sin sesión no sale ninguna petición protegida.
- **R-15:** Textos nuevos solo en `app_es.arb` y `app_en.arb`, mínimos, con descripción. Sin dependencias nuevas.
- **R-16:** Accesibilidad: objetivos táctiles de al menos 48 dp, contraste según `contraste.dart`, etiquetas semánticas (botones, chips con estado seleccionado, pines y rótulo de ejemplo), foco ordenado y diseño que no se rompe con texto al 200 %.
- **R-17:** Los pines de ejemplo y el panel no se pueden confundir con datos reales: el rótulo «Datos de ejemplo» está sobre el mapa, en el panel y en la lectura de pantalla, y no se puede ocultar.
- **R-18:** El mapa ocupa toda la pantalla bajo la barra de marca y reproduce el mundo de la maqueta (barrios con cuadrícula, parques, río y avenidas con nombre). Se arrastra y se pellizca; trae los botones «Acercar», «Alejar» y «Volver a mi ubicación» (48 dp); el zoom está limitado y la vista nunca sale del mundo dibujado. Los pines y el punto mantienen su tamaño al hacer zoom y colorean por oficio. Tiene variante clara y oscura.
- **R-19:** El buscador y los chips flotan sobre el mapa; los botones del mapa se acomodan encima del panel mientras este se mueve.

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
- **CA-25:** Dada la previa, cuando se abre en cualquier compilación (tienda o desarrollo), entonces se ven el mapa y el panel con los expertos de ejemplo y el rótulo «Datos de ejemplo» sobre el mapa y en el panel, no aparece «Muy pronto» y el código no lee ninguna bandera de compilación.
- **CA-26:** Dada la previa, cuando se abre, entonces el mapa ocupa la pantalla bajo la barra de marca con su dibujo, el punto «Tú estás aquí» y un pin por experto de ejemplo con su calificación y el color de su oficio, y el panel muestra «N expertos cerca de ti», la colonia, «Ver lista», «Explorar servicios y trabajos» y las tarjetas de los expertos.
- **CA-27:** Dado el mapa, cuando se arrastra, se pellizca o se tocan «Acercar», «Alejar» y «Volver a mi ubicación», entonces la vista cambia como se espera, nunca sale del mundo dibujado, el zoom queda entre su mínimo y su máximo y los pines no cambian de tamaño.
- **CA-28:** Dado un experto de ejemplo, cuando se toca su pin o su tarjeta, entonces se pide cuenta (CA-20) y nunca se muestra contacto ni dirección; «Ver lista» no pide cuenta, solo sube el panel.
- **CA-29:** Dada la previa, cuando se lee con lector de pantalla, entonces el rótulo, el mapa, cada pin y cada tarjeta anuncian «Datos de ejemplo».
- **CA-30:** Dada la previa, cuando se recorre, entonces no se pide ubicación ni ningún permiso del teléfono y no se usa ningún SDK de mapas.
- **CA-31:** Dado texto al 200 %, cuando se ve la previa y el catálogo, entonces nada se corta ni se traslapa y todo se alcanza con desplazamiento.
- **CA-32:** Dado el idioma en inglés o español, cuando se ve la previa, entonces todos los textos salen del ARB de ese idioma, sin cadenas fijas.
- **CA-33:** Dada la previa en cualquier estado, cuando se revisan registros, `toString`, mensajes y datos de ejemplo, entonces no aparece ningún token, celular, dirección ni dato personal.
- **CA-34:** Dado el flujo previa → «Entrar» → celular → código → Inicio, cuando se completa, entonces el login se comporta igual que antes de esta spec (regresión de HU-001).
- **CA-35:** Dados los chips, cuando se elige un oficio, entonces los pines, las tarjetas, el contador «N expertos cerca de ti» y el catálogo muestran solo ese oficio; con «Todos» vuelven todos.
- **CA-36:** Dado el panel inferior, cuando se toca «Ver lista» sube y el botón pasa a «Ver mapa», que lo baja a la mitad; al arrastrarlo hacia abajo queda asomado y el título sigue visible.

## 5. Contrato consumido
Versión de la API: `v1`. La URL base llega por `--dart-define=KNOCK_API_URL`, nunca fija en el código. Fuente: especificación de oficios del backend y spec 026 (§5).

| Endpoint | Auth | Cuerpo / consulta | Respuestas | Notas para la app |
|---|---|---|---|---|
| `GET /oficios` | No | — | 200 lista de oficios, 304, 5xx | Es lo único que consume la previa. Con `ETag` y caché (spec 010). **Nunca** lleva `Authorization`. |

No se consume ningún otro endpoint sin sesión. La búsqueda de expertos, la lista cercana y el mapa **no tienen endpoint**: por eso son vacío honesto o datos de ejemplo (§2). `GET /colonias/en-punto` es protegido (spec 026) y la previa no lo llama.

## 6. Modelo de datos local
- Sin tablas ni almacenamiento nuevos. El oficio elegido en los chips y el estado de la hoja viven en memoria de la pantalla.
- El destino de regreso viaja como parámetro de ruta interno (`volver`), validado contra la lista de rutas permitidas; no se guarda en disco.
- Los datos de ejemplo son constantes de código en un archivo aparte (`datos_de_ejemplo.dart`); se muestran siempre y no dependen de ninguna bandera.

## 7. Arquitectura
- `core/router/rutas.dart`: `Rutas.previa` (`/previa`), `Rutas.previaOficios` (`/previa/oficios`) y la lista de destinos permitidos; `redireccionPorSesion` pasa a usar la previa como destino sin sesión.
- `core/router/app_router.dart`: ruta de la previa fuera del `StatefulShellRoute`; `initialLocation` pasa a la previa cuando no hay sesión.
- `features/previa/` (nueva): `presentation/previa_screen.dart`, `barra_marca.dart`, `buscador_previa.dart`, `chips_oficio.dart`, `hoja_invitacion.dart`, `panel_expertos.dart`, `rotulo_ejemplo.dart` y `mapa/` (`mapa_previa.dart`, `lienzo_mapa.dart`, `pin_experto.dart`, `controlador_mapa.dart`); `domain/requerir_cuenta.dart`, `domain/destino_de_regreso.dart` y `domain/vista_mapa.dart` (pan y zoom puros).
- `core/tema/colores_mapa.dart`: colores del mapa dibujado (claro y oscuro) y de los pines por oficio, porque ningún widget escribe colores sueltos.
- `features/previa/demo/datos_de_ejemplo.dart`: expertos, pines y colonia ficticios; se muestran siempre con el rótulo «Datos de ejemplo».
- El catálogo reutiliza `OficiosScreen`, `OficiosController` y `oficiosRepositoryProvider`. `presentation/` no importa `data/` (regla vigente).
- No hay bandera de compilación ni script de verificación del binario: los ejemplos son parte de la app y siempre llevan el rótulo (D-12).

## 8. Amenazas y controles
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Los datos de ejemplo se toman por reales | Rótulo «Datos de ejemplo» fijo sobre el mapa, en el panel y en la lectura de pantalla; nombres claramente ficticios («Muestra»); una prueba revisa que el código no lea ninguna bandera que los apague | CA-25, CA-29 |
| Datos de ejemplo con personas reales o contacto | Nombres inventados, sin celular, dirección ni coordenadas reales; tocar un pin o una tarjeta pide cuenta | CA-28, CA-33 |
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
| Unitarias | Sí | `redireccionPorSesion` (tabla de rutas por sesión): CA-02 a CA-04; `destino_de_regreso` válido e inválido: CA-22; `VistaMapa` (centro inicial, zoom con límites, arrastre acotado, volver a mi ubicación): CA-27; datos de ejemplo sin celular ni dirección: CA-33; filtro por chip: CA-12 |
| Widget por estado | Sí | Previa con catálogo cargando, vacío, error, sin conexión y con datos: CA-11, CA-15 a CA-18; mapa, pines, panel y rótulo: CA-25, CA-26; botones y gestos del mapa: CA-27; chips que filtran pines y tarjetas: CA-35; panel plegable: CA-36; hoja de invitación: CA-09, CA-10, CA-13; barra de marca: CA-06, CA-07; español e inglés: CA-32 |
| Integración del flujo | Sí | Previa → «Entrar» → celular → código → Inicio con servicio de entrada simulado; acción protegida → login → regreso al destino; cuenta nueva → completar perfil → destino; cerrar sesión → previa: CA-01, CA-05, CA-19 a CA-21, CA-23, CA-24, CA-34 |
| Seguridad negativa | Sí | `GET /oficios` sin `Authorization` con `MockClient`: CA-14; destinos de regreso hostiles: CA-22; el código no lee ninguna bandera que apague los ejemplos: CA-25; sin tokens ni datos personales en registros: CA-33; sin permisos ni SDK de mapas: CA-30 |
| Accesibilidad | Sí | `meetsGuideline(androidTapTargetGuideline)` y de contraste, etiquetas semánticas de chips, pines, botones del mapa y rótulo, texto al 200 % sin desbordes: CA-06, CA-29, CA-31 |
| Regresión del login | Sí | Las pruebas existentes de `celular_screen`, `codigo_screen` y `entrada_controller` siguen en verde sin cambios: CA-03, CA-34 |
| Manual | Sí | Humo en teléfono (claro y oscuro): mapa, pan y zoom, panel plegable, pines y «Datos de ejemplo»; capturas para el PR; no sustituye lo automático |

## 10. Escenarios
1. **Primera vez.** Abre la app y ve la barra con «Entrar» y «Registrarme», el mapa a pantalla completa con el buscador y los chips encima, los pines de ejemplo y el panel «6 expertos cerca de ti» con «Datos de ejemplo». Arrastra y acerca el mapa, toca «Explorar servicios y trabajos», ve el catálogo, toca el buscador y se le invita a entrar.
2. **Sin internet.** Con caché ve el catálogo y el aviso; sin caché, el estado de sin conexión y «Reintentar».
3. **Demostración ante el profesor.** Sube el panel con «Ver lista», elige el chip «Mecánica» y ve solo esos pines y tarjetas; toca un experto y se le pide entrar. Todo lo que ve lleva «Datos de ejemplo».
4. **Entra desde una acción.** Toca una acción protegida, entra con celular y código y regresa a donde estaba.
5. **Cierra sesión.** Vuelve a la previa, no a la pantalla de celular.

## 11. Definición de terminado
- Los 36 criterios de aceptación tienen prueba (la prueba en teléfono, evidencia manual) y `sdd_lint --trace 027` no reporta drift.
- `flutter analyze`, `dart format` y `flutter test` en verde; el CI en verde.
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
- **D-05 (reemplazada por D-12).** La bandera `KNOCK_DEMO_DATOS` ya no existe.
- **D-06 El mapa de ejemplo es un lienzo dibujado por la app,** sin SDK de mapas, para no depender de facturación; con D-12 ocupa toda la pantalla y se mueve.
- **D-07 El buscador no busca:** abre la invitación a entrar. La búsqueda real espera al backend.
- **D-08 Destinos de regreso permitidos:** las pestañas de la app, `/previa/oficios` y las subrutas de Explorar. Cualquier otra cosa va a Inicio.
- **D-09 (obsoleta por D-12).** Ya no hay paso de CI para `release` sin demostración.
- **D-10 Clave de Jira** `KNOCK-248 (por verificar)`: no hubo acceso a Jira.
- **D-11 Numeración:** esta spec es la 027 del frontend; la «spec 027 del backend» es otra (búsqueda de expertos).
- **D-12 Mapa completo y ejemplos siempre visibles** (decisión del Tech Lead, 2026-11-10, sobre la spec ya aprobada). La previa se parece a la maqueta: mapa a pantalla completa dibujado, con pan, zoom y botones, pines por oficio, buscador y chips encima y panel plegable. Los expertos y pines de ejemplo se muestran **siempre**, también en la tienda, con el rótulo fijo «Datos de ejemplo»; se elimina la bandera `KNOCK_DEMO_DATOS`, el panel «Muy pronto» y el script `scripts/verificar_release_sin_demo.py`. «Ver lista» sube el panel y ya no pide cuenta. Se añaden R-18, R-19, CA-35 y CA-36. Riesgo aceptado: que alguien tome los ejemplos por reales; se mitiga con el rótulo y se retira cuando exista el endpoint de expertos.

## 13. Riesgos y dudas abiertas
- **Ejemplos vistos como datos reales:** si el profesor o una persona de la tienda cree que los expertos son reales. Mitigación: rótulo fijo y aclararlo en la presentación; se retiran al existir la búsqueda real.
- **La tienda muestra datos inventados:** decisión consciente de D-12 para que la demo se parezca a la maqueta; revisar la política de la tienda sobre contenido de ejemplo antes de publicar fuera de la prueba interna.
- **Mapa dibujado, no real:** el mapa no se corresponde con las calles reales; la búsqueda y el mapa real esperan al backend y a la decisión de facturación del SDK de mapas.
- **Duda:** ¿«Mi auto», «Agua y tuberías» y «Luz y contactos» deben existir como nombres comunes en el catálogo del backend? Se confirma con el backend.
- **Duda:** ¿el panel de ejemplo debe poder abrir un perfil de ejemplo sin sesión para la demostración? Hoy no, por seguridad.
- **Dependencia de la spec 026:** si no está implementada, `GET /oficios` y el cierre de sesión no se comportan como esta spec supone.
- No se verificó la clave de Jira ni el contrato desplegado en esta etapa.

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-10
- [x] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
