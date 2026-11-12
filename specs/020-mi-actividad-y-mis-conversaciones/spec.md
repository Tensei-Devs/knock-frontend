# Spec 020 — Mi actividad y mis conversaciones

> **Jira:** KNOCK-69 («HU-026 · Ver mi actividad (lista única con estados y último mensaje)») y KNOCK-73 («HU-030 · Ver mis conversaciones (globo con contador)»), verificadas en Jira el 9 de noviembre de 2026 (etiqueta `sprint-5`) · **Épica:** EP-04 Solicitudes y EP-05 Chat y cotizaciones · **Módulo:** requests y messaging · **Responsable:** Erick Trejo Reséndiz · **Sprint:** S5 · **Puntos:** 5 (3 y 2 en Jira) · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend: 020 «Solicitudes y cotizaciones» (lista con cursor), 026 «Mensajería en tiempo real» (canal en vivo), 030 «Chatear antes de elegir y mis conversaciones» (en elaboración: lista de conversaciones, no leídos y marca de lectura; **pendiente de validar**) y 029 «Cancelar y vencer solicitudes» (estados `cancelada` y `vencida`)
> **Fuentes:** `docs/backlog/HU-026.md`, `HU-030.md` · `docs/referencia/FUNCIONES_Y_FLUJOS.md` §3.6 y §3.7
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye `GET /api/v1/solicitudes` ni las rutas de conversaciones; las fijan backend 020 (lista) y backend 030 (conversaciones, en elaboración). Se vendoriza antes de implementar (spec 006).
> **Estado:** Borrador

## 1. Objetivo

Que el cliente vea en la pestaña Actividad todos sus servicios en una sola lista (primero lo que sigue en curso, al final lo terminado), cada uno con su estado, su acción principal y su último mensaje con el contador de no leídos, y que un globo con contador abra la lista de conversaciones desde cualquier pestaña. Esta spec amplía la pantalla Actividad de la spec 015 y cubre la capa **Mobile**.

## 2. Historia y casos de prueba

**KNOCK-69** — Como cliente, quiero ver todos mis servicios en una sola lista, para saber en qué va cada uno.
**KNOCK-73** — Como cliente o técnico, quiero ver todas mis conversaciones en un globo flotante, para no perder ningún mensaje.

- **CA-01:** Dado un cliente con solicitudes en curso y terminadas, cuando abre Actividad, entonces ve primero las en curso (de la más reciente a la más antigua) y al final las terminadas. · Verificación: `app/test/features/actividad/domain/orden_actividad_test.dart` → `CA_020_01`
- **CA-02:** Dada una solicitud con 3 cotizaciones, cuando se pinta su tarjeta, entonces dice «3 cotizaciones listas» y su acción principal es «Ver y elegir», que abre `/actividad/solicitud/:id/cotizaciones` (spec 015). · Verificación: `app/test/features/actividad/presentation/tarjeta_actividad_test.dart` → `CA_020_02`
- **CA-03:** Dada una solicitud en cada estado de backend 020 (`enviada`, `cotizando`, `cita_confirmada`, `terminada`, `calificada`, `cancelada`, `vencida`), cuando se pinta, entonces la etiqueta y la acción principal corresponden al estado (tabla de §7), un estado desconocido se muestra como «En proceso» con «Ver detalle», y nada depende solo del color. · Verificación: `app/test/features/actividad/presentation/tarjeta_actividad_test.dart` → `CA_020_03`
- **CA-04:** Dado un experto que escribió, cuando se pinta la tarjeta de ese servicio, entonces aparece su último mensaje (recortado a una línea) con el contador de no leídos; si la solicitud tiene varias conversaciones (una por técnico, backend 030), la tarjeta muestra el último mensaje más reciente de todas y la suma de sus `noLeidos` (*decisión automática, revisar*). · Verificación: `app/test/features/actividad/presentation/tarjeta_actividad_test.dart` → `CA_020_04`
- **CA-05:** Dado un cliente sin servicios, cuando abre Actividad, entonces ve el estado vacío que invita a «Pedir mi primera cotización» y lleva a `/actividad/solicitud/nueva`. · Verificación: `app/test/features/actividad/presentation/actividad_screen_test.dart` → `CA_020_05`
- **CA-06:** Dado un cliente con más de 20 servicios, cuando llega al final de la lista, entonces la app pide la página siguiente con `nextCursor`, nunca pide más de 20 por vez y no duplica elementos. · Verificación: `app/test/features/actividad/data/actividad_repository_api_test.dart` → `CA_020_06`
- **CA-07:** Dada la solicitud de otra persona, cuando la app pide su detalle desde un aviso o un enlace, entonces recibe 404 y muestra «Esta solicitud ya no está disponible» sin revelar que existe. · Verificación: `app/test/features/actividad/data/actividad_repository_api_test.dart` → `CA_020_07`
- **CA-08:** Dado un mensaje sin leer, cuando la persona está en cualquier pestaña, entonces el globo flotante muestra el contador (con tope «9+») y su etiqueta semántica dice cuántos mensajes hay sin leer. · Verificación: `app/test/core/widgets/globo_conversaciones_test.dart` → `CA_020_08`
- **CA-09:** Dado el globo tocado, cuando se abre la lista, entonces muestra las conversaciones de la más reciente a la más antigua, cada una con la persona, el servicio, el último mensaje y su contador. · Verificación: `app/test/features/mensajes/presentation/conversaciones_screen_test.dart` → `CA_020_09`
- **CA-10:** Dada una conversación con mensajes sin leer, cuando la persona la abre y los lee, entonces la app avisa al servidor que se leyeron, el contador de esa conversación baja a cero y el del globo baja en la misma cantidad. · Verificación: `app/test/features/mensajes/presentation/conversaciones_controller_test.dart` → `CA_020_10`
- **CA-11:** Dado un cliente sin conversaciones, cuando toca el globo, entonces ve un estado vacío que explica que el chat se abre al recibir cotizaciones. · Verificación: `app/test/features/mensajes/presentation/conversaciones_screen_test.dart` → `CA_020_11`
- **CA-12:** Dada la pantalla de inicio de sesión o una conversación abierta, cuando se pinta la app, entonces el globo **no** aparece encima. · Verificación: `app/test/core/widgets/globo_conversaciones_test.dart` → `CA_020_12`
- **CA-13:** Dada la app abierta, cuando llega un mensaje en vivo por el canal de la spec 026, entonces el contador sube sin recargar y, si la conversación está abierta, no sube. · Verificación: `app/test/features/mensajes/data/canal_mensajes_test.dart` → `CA_020_13`
- **CA-14:** Dado el canal en tiempo real caído o sin conexión, cuando se abren Actividad o la lista de conversaciones, entonces se muestra lo último recibido del servidor con un aviso «Sin conexión», el contador queda congelado y «Reintentar» vuelve a pedir; nada se inventa. · Verificación: `app/test/features/mensajes/presentation/conversaciones_estados_test.dart` → `CA_020_14`
- **CA-15:** Dado un 429 con `Retry-After`, un 5xx o un tiempo agotado, cuando se abre cualquiera de las dos pantallas, entonces se muestra el aviso o el error con «Reintentar» y no se reintenta en bucle. · Verificación: `app/test/features/actividad/presentation/actividad_estados_test.dart` → `CA_020_15`
- **CA-16:** Dado el cierre de sesión, cuando entra otra persona, entonces no queda el último mensaje, el contador ni la lista de la cuenta anterior en memoria ni en disco. · Verificación: `app/test/features/mensajes/data/limpieza_mensajes_test.dart` → `CA_020_16`
- **CA-17:** Dados Actividad y la lista de conversaciones, cuando se recorren con lector de pantalla y texto al 200 %, entonces cada tarjeta se lee completa («Plomería, 3 cotizaciones listas, ver y elegir»), los controles miden al menos 48 dp y no se corta el contenido. · Verificación: `app/test/features/actividad/presentation/accesibilidad_actividad_test.dart` → `CA_020_17`
- **CA-18:** Dado el registro de la app, cuando llega o se lee un mensaje, entonces ningún `print`, registro ni reporte de errores contiene el texto del mensaje ni el nombre de la persona (prueba global de la spec 009). · Verificación: `app/test/seguridad/seguridad_cliente_test.dart` → `CA_020_18`

## 3. Alcance / No-alcance

**Dentro (capa Mobile)**
- Lista única de Actividad con estados, acción principal, último mensaje y contador (reemplaza la tarjeta de «última solicitud» de la spec 015, D-03).
- Globo flotante con contador y lista de conversaciones; marcar como leído al abrir.
- Estados de carga, vacío, error, sin conexión y reintento; paginación por cursor.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.

**Fuera**
- Escribir y enviar mensajes dentro de una conversación (pantalla de chat): es una spec propia sobre backend 026.
- Historial con filtros (HU-026, fuera del MVP).
- Las notificaciones de mensajes (spec 024).
- Las reglas de qué se muestra a cada rol y el cálculo de no leídos: backend.
- La lista de Trabajo del técnico (spec 019); aquí el globo sirve a clientes y técnicos, pero la lista de Actividad es solo del cliente.

### Requisitos

- **R-01:** Actividad pide `GET /api/v1/solicitudes` con `cursor` y `limit=20` (el servidor acepta de 1 a 50) y muestra el orden que recibe (de la más reciente a la más antigua); solo agrupa «en curso» y «terminadas» con el campo `estado`. «Ver visita» abre la visita con el `visitaId` que trae el resumen (backend 020 lo agregó a `SolicitudResumen`), sin otra llamada.
- **R-02:** Cada tarjeta muestra oficio, estado, número de cotizaciones, acción principal y, si hay, último mensaje y contador; la acción principal depende solo del estado (tabla en §7).
- **R-03:** El globo existe en las cinco pestañas y no en Entrada, Completar perfil ni dentro de una conversación; su contador viene del servidor y se actualiza con el canal de la spec 026.
- **R-04:** El contador del globo es la suma de los no leídos de las conversaciones; la app no lo calcula sola a partir de mensajes que no tiene.
- **R-05:** Al abrir una conversación y leerla, la app avisa al servidor con una llamada idempotente y baja el contador; si falla, el contador vuelve a su valor anterior.
- **R-06:** El texto del último mensaje es dato personal: no se guarda en disco ni en la caché de respuestas (spec 010, R-04) y se borra al cerrar sesión.
- **R-07:** Si el canal en tiempo real no está disponible, la app muestra lo último que le dio el servidor, lo marca como sin conexión y no inventa contadores ni mensajes.
- **R-08:** Un `404` en una solicitud o conversación se trata como «ya no está disponible».
- **R-09:** Todo error de la API se muestra con un texto del catálogo; nunca con el código HTTP, la URL ni el cuerpo.
- **R-10:** Todos los textos viven en los ARB de español e inglés y los colores y tipografías en el tema (spec 014).
- **R-11:** Cada control mide al menos 48 dp, tiene etiqueta semántica y funciona con texto al 200 %.
- **R-12:** El globo no tapa controles: se coloca sobre la barra inferior, se puede mover o se oculta al abrir el teclado, y no aparece sobre una hoja modal.

## 4. Contrato API y eventos

La app **consume**. `GET /api/v1/solicitudes` ya está fijado por backend 020 (CA-14) y las rutas de conversaciones por el borrador de backend 030 (R-15, R-17, R-18 y R-19); ambos siguen sin aprobar y se confirman al vendorizar.

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/solicitudes` | Lista de Actividad (backend 020) | `cursor?`, `limit?` (1–50; la app pide 20), `estado?` | `200` `CursorPage<SolicitudResumen>`: `id`, `estado`, `oficioNombre`, `coloniaNombre`, `dia`, `franja`, `totalFotos`, `totalCotizaciones`, `visitaId?` (presente cuando la solicitud tiene visita), `venceEn`, `creadoEn` y `nextCursor` | `400`, `401`, `429` con `Retry-After` |
| ~~`GET /api/v1/me/actividad`~~ | Eliminada en la revisión cruzada (*decisión automática, revisar*): no hay spec de backend para ella; la pantalla usa `GET /solicitudes` (backend 020) y `GET /conversaciones` (backend 030 R-17, con `ultimoMensaje` y `noLeidos`), cada una con su estado de carga y error | — | — | — |
| `GET /api/v1/conversaciones` | Lista de conversaciones (backend 030 R-17, borrador) | `cursor?`, `limit?` (1–20) | `200` con `items[]`: `conversacionId`, `solicitudId`, `visitaId?`, `rol`, `contraparte{nombre, fotoUrl}`, `servicio`, `estado`, `ultimoMensaje{texto, enviadoEn, autorRol}` o `null`, `noLeidos`, y `totalNoLeidos`, `nextCursor` | `400`, `401`, `429` |
| `GET /api/v1/conversaciones/no-leidas` | Contador del globo (backend 030 R-18) | — | `200` con `{ total }` | `401`, `429` |
| `POST /api/v1/conversaciones/{id}/leido` | Marcar como leída (backend 030 R-19, borrador) | `hasta` (marca de tiempo del último mensaje leído) | `204` | `401`, `404`, `429` |
| Hub `/hubs/chat` (backend 026 y 030) | Mensajes en vivo | `UnirseAConversacion(conversacionId)` (backend 030 R-15; el chat de una visita de backend 026 usa `UnirseAVisita(visitaId)`); la conexión entra sola al grupo `usuario:{sub}` y recibe el evento `noLeidos` `{ conversacionId, noLeidos, total }`; evento `mensaje` `{ visitaId, mensajeId, texto, enviadoEn }` (chat de visita) y evento `mensajeConversacion` `{ conversacionId, mensajeId, autorRol, texto, contactoOculto, enviadoEn }` (conversación previa a elegir, backend 030) | — | `no_autorizado`, `conversacion_no_disponible`, `limite_de_mensajes`, `chat_apagado` |

Reglas del contrato que la app da por ciertas:
- **Autorización por recurso:** `404` para lo ajeno o inexistente.
- **Paginación:** cursor, máximo 20 pedidos por la app.
- **Conflicto detectado con backend 026:** esa spec dice que **no** guarda mensajes (CA-12: «no hay colección de mensajes») y que el evento `mensaje` no lleva quién escribe. Con eso el servidor no puede dar `ultimoMensaje` ni `noLeidos` (HU-030 menciona `messaging.lecturas`). Esta spec lo deja como **bloqueante** (§13) y define la capa `data` detrás de una interfaz para no depender de la decisión.
- **Eventos:** `mensaje` (chat de visita, backend 026) y `mensajeConversacion` (conversación previa a elegir, backend 030) suben el contador de la conversación que corresponda, salvo que esté abierta; la app no guarda el texto. *Decisión automática, revisar:* son eventos distintos por grupo y por carga, y la app escucha los dos.

**Alineación del 9 de noviembre de 2026:** `GET /api/v1/solicitudes` responde `CursorPage<SolicitudResumen>` con `items[]` y `nextCursor` (backend 002), `Cache-Control: private, no-store` y filtro opcional `estado`; los errores son ProblemDetails con `code`. Las rutas de conversaciones se toman del borrador de backend 030; si su forma cambia, se corrige esta tabla antes de implementar. El globo pide `GET /conversaciones/no-leidas` y se actualiza con el evento `noLeidos`; no pide la lista entera para contar.

## 5. Modelo de datos

**Entidades de dominio** (`app/lib/features/actividad/domain/` y `app/lib/features/mensajes/domain/`)

| Entidad | Campos | Reglas |
|---|---|---|
| `ServicioDeActividad` | `id`, `estado`, `oficioNombre`, `coloniaNombre`, `dia`, `franja`, `numeroFotos`, `numeroCotizaciones`, `venceEn`, `creadoEn` (forma `SolicitudResumen` de backend 020; `numeroFotos` y `numeroCotizaciones` se mapean desde `totalFotos` y `totalCotizaciones`), `visitaId?`, `accionPrincipal`, `ultimoMensaje?`, `noLeidos?` | `accionPrincipal` se deriva solo del estado; el último mensaje y los no leídos solo existen cuando backend 030 los dé |
| `AccionPrincipal` | `verYElegir`, `verVisita`, `verDetalle`, `pedirDeNuevo`, `ninguna` | Ver tabla de §7 |
| `Conversacion` | `id`, `solicitudId`, `visitaId?`, `rol`, `estado`, `contraparte` (nombre y foto), `servicio`, `ultimoMensaje?`, `noLeidos` | Inmutable; el servidor decide el orden; `ultimoMensaje` puede ser `null` |
| `UltimoMensaje` | `texto`, `enviadoEn`, `autorRol` | Solo en memoria |
| `ContadorDeNoLeidos` | `total` | Suma de `noLeidos`; baja al leer y sube con el evento en vivo |

**Estado local**
- Todo en memoria (Riverpod). **Nada** de mensajes, nombres ni contadores en `shared_preferences`, disco ni caché de respuestas (R-06).
- Se limpia al cerrar sesión (providers invalidados).
- La tarjeta de «última solicitud guardada» de la spec 015 (D-03) deja de usarse cuando existe la lista; la clave local se borra.

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Fuga de información:** ver servicios o conversaciones de otra persona | El servidor autoriza por recurso y responde 404; la app no mezcla cuentas y limpia al cerrar sesión | CA-07, CA-16 |
| **Fuga de información:** texto de mensajes en disco, copias de seguridad, registros o reportes de errores | Solo memoria; sin `print`; prueba global de la spec 009; sin caché de respuestas | CA-16, CA-18 |
| **Fuga de información:** el último mensaje visible en pantalla bloqueada o en capturas | Los avisos no llevan el texto (spec 012, R-03); en la lista el texto se recorta a una línea | CA-04 |
| **Alteración:** marcar como leído algo no leído, o doble marca | Llamada idempotente con marca de tiempo y regreso al valor anterior si falla | CA-10 |
| **Suplantación:** mensajes de una conexión sin sesión | El canal exige token (backend 026); la app no abre el canal sin sesión | CA-13 |
| **Denegación:** reconexión y recarga en bucle tras un 429 o una caída | Espera con `Retry-After`, reintento acotado con retroceso y sin bucle | CA-14, CA-15 |
| **Elevación de privilegios:** un técnico ve la lista de Actividad del cliente | La lista de Actividad es solo para el rol cliente; el globo muestra solo conversaciones propias | CA-09 |
| **Repudio:** «nunca lo leí» | El servidor guarda la marca de lectura; la app no guarda historial | CA-10 |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos nuevos (ARB `actividad*`, `conversacion*`) |
|---|---|---|---|
| Actividad (`/actividad`, se modifica) | carga, con datos, vacío, error, sin conexión, espera por 429 | Secciones «En curso» y «Terminados»; tarjetas; «Pedir cotización» | `actividadEnCurso`, `actividadTerminados`, `actividadCotizacionesListas`, `actividadVerYElegir`, `actividadVerVisita`, `actividadVerDetalle`, `actividadPedirDeNuevo`, `actividadSinConexion`, `actividadCargarMas` |
| Globo de conversaciones (en todas las pestañas) | sin mensajes, con contador, `9+` | Botón flotante con contador | `globoEtiqueta`, `globoNoLeidos` |
| Conversaciones (`/conversaciones`) | carga, con datos, vacío, error, sin conexión | Lista con contraparte, servicio, último mensaje y contador | `conversacionesTitulo`, `conversacionesVacioTitulo`, `conversacionesVacioDetalle`, `conversacionNoLeidos`, `conversacionNoDisponible` |

**Acción principal por estado** (R-02): `enviada` → «Ver detalle»; `cotizando` con cotizaciones → «Ver y elegir»; `citaConfirmada` → «Ver visita»; `terminada` y `calificada` → «Ver detalle»; `cancelada` o `vencida` → «Volver a pedir» (la cancelación y el vencimiento los define backend 029 y la spec 025 de frontend).

**Mensajes exactos** (español; el inglés va en `app_en.arb`)

| Situación | Texto en pantalla |
|---|---|
| Actividad vacía | «Aún no tienes servicios» + «Pedir mi primera cotización» |
| Tarjeta con cotizaciones | «{n} cotizaciones listas» |
| Sin conversaciones | «Aquí verás tus conversaciones cuando elijas una cotización» |
| Canal en vivo caído | «Sin conexión. Los mensajes nuevos llegarán cuando vuelva la señal.» |
| 404 | «Esta solicitud ya no está disponible.» |
| 429 | «Hiciste muchos intentos. Espera {segundos} segundos.» |
| 5xx | «Algo salió mal de nuestro lado. Intenta de nuevo.» |

Reglas de pantalla:
- Las terminadas no muestran contador salvo que haya mensajes sin leer.
- El globo se coloca sobre la barra inferior, a la derecha, con área táctil de 56 dp y sin tapar acciones.
- Accesibilidad: contraste según la spec 014; el globo se anuncia como «Conversaciones, 3 mensajes sin leer»; cada tarjeta es un solo nodo semántico; el estado no depende solo del color.

## 8. Pruebas, gates y límites

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Orden, acción por estado, contador, mapeos |
| Widget (W) | Sí | Tarjeta, lista, globo, estados |
| Aceptación (ACC) | Sí | CA-01 a CA-18 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración (INT) | Sí | API simulada y canal simulado en `integration_test/` |
| Seguridad negativa (NEG) | Sí | 404 ajeno, 429, canal sin sesión, ausencia de texto en registros |
| Accesibilidad (A11Y) | Sí | `expectAccesible` y texto al 200 % |
| Mutación (MUT) | Sí | `domain/` con meta 70 % |
| E2E | Sí | Pedir cotización → ver su tarjeta → recibir mensaje en vivo → abrir la lista |
| Regresión | Sí | Suite completa; barra inferior y redirecciones sin cambios |
| Análisis estático y vulnerabilidades | Sí | `flutter analyze`, `dart format`, Semgrep, CodeQL, OSV |
| Rendimiento (PERF) | No | Volumen bajo del piloto |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Dos en curso y una terminada: las dos primeras arriba, la terminada al final |
| Positivo | Llega un mensaje: el contador sube de 0 a 1 en el globo |
| Negativo | Solicitud ajena por enlace: 404 y mensaje sin revelar existencia |
| Error esperado | 401 → renueva una vez; si falla, cierra sesión |
| Error esperado | 429, 5xx, tiempo agotado: aviso o error con «Reintentar» |
| Caso límite | 0, 1, 20 y 21 servicios; contador 0, 9 y 10 (`9+`) |
| Caso límite | Mensaje que llega mientras se lee otra conversación |
| Caso límite | Texto de último mensaje de 1 000 caracteres: se recorta sin romper la tarjeta |
| Caso límite | Canal caído a media lectura: el contador no baja hasta que el servidor confirme |

**Gates:** los de la spec 015 (§8).

## 9. Arquitectura y componentes

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/actividad/domain/servicio_de_actividad.dart` | Crear | Entidad y `AccionPrincipal` |
| `app/lib/features/actividad/domain/orden_actividad.dart` | Crear | Agrupa en curso y terminadas |
| `app/lib/features/actividad/domain/actividad_repository.dart` | Crear | `listar(cursor)` |
| `app/lib/features/actividad/data/actividad_repository_api.dart` | Crear | Sobre el cliente generado; reutiliza `solicitud_mapper.dart` de la spec 015 |
| `app/lib/features/actividad/presentation/actividad_screen.dart` | Modificar | Lista, secciones y estados |
| `app/lib/features/actividad/presentation/widgets/tarjeta_actividad.dart` | Crear | Tarjeta con la tarjeta del tema (spec 014) |
| `app/lib/features/mensajes/domain/conversacion.dart` | Crear | Entidades de §5 |
| `app/lib/features/mensajes/domain/conversaciones_repository.dart` | Crear | `listar`, `marcarLeido` |
| `app/lib/features/mensajes/data/conversaciones_repository_api.dart` | Crear | Sobre el cliente generado |
| `app/lib/features/mensajes/data/canal_mensajes.dart` | Crear | Canal en vivo (spec 026); solo sube contadores |
| `app/lib/features/mensajes/mensajes_providers.dart` | Crear | Raíz de composición |
| `app/lib/features/mensajes/presentation/conversaciones_screen.dart` | Crear | Lista |
| `app/lib/features/mensajes/presentation/conversaciones_controller.dart` | Crear | Carga, lectura y contador |
| `app/lib/core/widgets/globo_conversaciones.dart` | Crear | Globo reutilizable (se coloca en el `AppShell`) |
| `app/lib/core/router/app_shell.dart`, `rutas.dart`, `app_router.dart` | Modificar | Insertar el globo y la ruta `/conversaciones` |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 |
| `app/pubspec.yaml` | Modificar | Cliente de SignalR **si** no existe (D-04; se evalúa y se registra en `Memoria.md`) |

**No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/`.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| Backend 020 | `GET /solicitudes` paginada | Actividad queda vacía o vuelve a la última solicitud (spec 015, D-03) |
| Backend 026 | Canal en vivo, límites y errores | Contador sin tiempo real |
| Backend 030 Chatear antes de elegir y mis conversaciones (borrador) | `ultimoMensaje`, `noLeidos`, `GET /conversaciones/no-leidas`, evento `noLeidos` y marca de lectura | **Bloqueante** para CA-04, CA-09 a CA-11 |
| 015 Pedir y comparar cotizaciones | Entidad `Solicitud`, rutas y mapeo | Se duplicarían modelos |
| 016 Visita con código | Destino de «Ver visita» | La acción no tiene a dónde ir |
| 012 Notificaciones | Aviso de mensaje con tipo y destino sin contenido | El contador solo cambia con la app abierta |
| 014 Alinear la UI | la tarjeta del tema y el «estado vacío o de error» de la spec 014, la «fila» de la spec 014, contraste | Estilos duplicados |
| 002, 009, 010 | Errores, espera por 429, política de caché | Manejo de datos incompleto |

## 11. Definición de terminado

- CA-01 a CA-18 con prueba que falla si la lógica está mal; `python scripts/sdd_lint.py --trace 020` sin `FALTA`.
- `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 %.
- ARB completos y prueba de traducciones en verde.
- El contrato vendorizado incluye las rutas de §4 y el cliente generado compila.
- Recorrido real con datos de prueba, con capturas sin datos reales.
- `Memoria.md` al día; PR con la plantilla completa, etiqueta `puntos-app-N` y CI en verde.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | Actividad usa `GET /api/v1/solicitudes` de backend 020 y reemplaza la tarjeta de «última solicitud» de la spec 015 (D-03) | Backend 020 ya publica el listado (CA-14), que era la condición de D-03 | Mantener el listado local, que se desincroniza del servidor |
| D-02 | La app pide 20 por página aunque el servidor acepte hasta 50 | HU-026 fija paginación de 20 | Pedir 50 y gastar datos |
| D-03 | La capa `data` de conversaciones va detrás de una interfaz y no se implementa hasta que backend fije el contrato | Backend 026 no guarda mensajes y contradice `GET /conversaciones` | Guardar mensajes y contadores en el teléfono, que es dato personal en disco |
| D-04 | El canal en vivo usa el cliente de SignalR que se evalúe y se registre en `Memoria.md` antes de agregarlo | La regla del repositorio exige evaluar dependencias | Escribir el protocolo a mano |
| D-05 | El globo vive en el `AppShell` (una sola vez) y se oculta en rutas de entrada y de chat | Evita repetirlo en cinco pantallas | Un globo por pantalla |
| D-06 | El contador viene del servidor y solo se ajusta con el evento en vivo y con la marca de lectura | La app no tiene mensajes para recalcularlo | Contar mensajes recibidos en el teléfono |

## 13. Riesgos y dudas abiertas
- **`Idempotency-Key` retirada por ahora (decisión del 2026-11-10).** La marca de leído no la envía y backend 030 la quitó; sigue idempotente por su marca de tiempo.

- **Bloqueante:** `GET /conversaciones` y la marca de lectura dependen de backend 030 (R-17 y R-19; `GET /me/actividad` ya no se usa) «Chatear antes de elegir y mis conversaciones», cuyo borrador ya fija esas rutas pero aún no está aprobado; backend 026 no persiste mensajes y el último mensaje y los no leídos los guarda backend 030 (R-14). Hasta que se apruebe, CA-04 y CA-09 a CA-11 quedan detrás de la interfaz de D-03.
- **Conflicto detectado:** backend 026 no incluye en el evento `mensaje` quién escribe; la lista necesita la contraparte. Se resuelve con la visita (una conversación por visita), pero conviene confirmarlo.
- **Resuelto en la revisión:** la app pide `limit=20` y backend 020 acepta de 1 a 50; la spec 015 ya no pagina.
- **Resuelto en la revisión:** backend 020 ya agregó `visitaId?` al `SolicitudResumen`; «Ver visita» no necesita otra llamada.
- **Riesgo:** el globo puede tapar controles en pantallas pequeñas con texto al 200 % (R-12); se prueba a 320×640.
- **Duda abierta (para José):** ¿el globo es para técnicos también? HU-030 dice «cliente o técnico»; esta spec lo permite, pero el técnico no tiene Actividad.
- **Duda abierta (para el equipo):** ¿las conversaciones nacen al recibir una cotización (HU-029) o solo al elegir? Backend 026 solo permite chat en una visita confirmada, así que antes de elegir no hay conversación.

## Aprobación

- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
