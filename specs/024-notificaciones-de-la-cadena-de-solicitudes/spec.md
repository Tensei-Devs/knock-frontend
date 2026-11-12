# Spec 024 — Notificaciones de la cadena de solicitudes

> **Jira:** KNOCK-60 (HU-050 «Recibir notificaciones push», capa Mobile); relacionadas: KNOCK-68 (HU-025 oleadas), KNOCK-70 (HU-027 cancelar), KNOCK-71 (HU-028 vencer) y KNOCK-72 (HU-029 chat) · **Épica:** EP-10 Mi cuenta y avisos · **Módulo:** notificaciones · **Responsable:** Erick Trejo Reséndiz (propuesto) · **Sprint:** S5 (propuesto; KNOCK-60 tiene etiqueta `sprint-5`) · **Puntos:** 3 (los de KNOCK-60 se reparten con backend) · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend (specs 020 «Solicitudes y cotizaciones», 021 «Comparar y elegir cotización», 022 «Visita segura con código», 026 «Mensajería en tiempo real» y las de la fase 2: 028 «Repartir la solicitud por oleadas», 029 «Cancelar y vencer solicitudes» y 030 «Chatear antes de elegir y mis conversaciones»; el envío de notificaciones y el registro de dispositivos son la spec 037 (Borrador, HU-050))
> **Fuentes:** `docs/descripcion-del-proyecto.md` §4 «Notificaciones push» · backlog `HU-050.md`, `HU-051.md`, `HU-025.md`, `HU-027.md`, `HU-028.md`, `HU-029.md` · spec 012 (aprobada) · maqueta `js/knock.js` (`S.notifConfig`, `cNotif`)
> **Skills:** `flutter-clean-architecture`, `security-core`, `testing-strategy-frontend`, `api-client-contract`, `reuse-before-create`
> **Contrato:** la carga de la notificación (§4.1) la define esta spec y la debe adoptar la spec de backend del envío de notificaciones (hoy no existe). Las rutas REST que abre cada aviso ya están en backend 020, 021 y 022; las de conversaciones dependen de backend 030.
> **Estado:** Borrador

## 1. Objetivo

Que el cliente y el técnico se enteren, sin abrir la app a cada rato, de lo que pasa con sus solicitudes: una solicitud nueva que les llegó por oleada, una cotización recibida, una cotización aceptada, una solicitud cancelada o vencida, una solicitud que no encontró técnicos y un mensaje nuevo. Cada aviso dice lo justo, sin datos personales ni en la carga ni en el texto, y al tocarlo abre la pantalla exacta del recurso, después de validar el enlace y de que el servidor confirme que el recurso es de quien lo abre.

La spec 012 (aprobada) dejó la infraestructura común: registro del identificador, carga con `tipo` y `destino`, revisión de textos sensibles, preferencias por tipo y modo «chat en vivo». Esta spec **no la repite**: define el catálogo de avisos de la cadena de solicitudes, amplía la carga con el evento y el identificador del recurso, valida el enlace profundo y fija qué hace la app con cada aviso en primer plano, en segundo plano y con la app cerrada. Cubre la capa **Mobile**.

## 2. Historia y casos de prueba

**KNOCK-60 (HU-050)** — Como cliente o técnico, quiero recibir avisos en mi teléfono, para enterarme de cotizaciones, mensajes y visitas sin abrir la app a cada rato.

- **CA-01:** Dada una carga válida de cada evento del catálogo (§4.2), cuando la app arma la notificación, entonces el título y el cuerpo salen de los ARB del idioma del teléfono, coinciden exactamente con la tabla de §7 la notificación va al canal de Android de su tipo de aviso y es privada, con la versión pública «Tienes un aviso nuevo» en la pantalla de bloqueo. · Verificación: `app/test/core/notificaciones/catalogo_avisos_test.dart` → `CA_024_01`
- **CA-02:** Dado cada texto del catálogo en español y en inglés, cuando se revisa con `revisarTextoDeNotificacion` (spec 012) y con la lista de palabras prohibidas de §6, entonces ninguno contiene códigos, números de 4 o más dígitos, montos, direcciones, colonias, nombres ni el texto de un mensaje. · Verificación: `app/test/core/notificaciones/catalogo_avisos_test.dart` → `CA_024_02`
- **CA-03:** Dado un `cotizacion_nueva` con `recurso` válido tocado por un cliente con sesión, cuando se abre la app (cerrada, en segundo plano o en primer plano), entonces llega a `/actividad/solicitud/:id/cotizaciones` con ese `id` y la pantalla pide `GET /api/v1/solicitudes/{id}/cotizaciones`. · Verificación: `app/test/core/notificaciones/destino_aviso_test.dart` → `CA_024_03`
- **CA-04:** Dado un `request_expired` tocado por el cliente, cuando se abre, entonces llega al detalle `/actividad/solicitud/:id`, que muestra el estado «Vencida» y la acción «Volver a pedir» de la spec 025; y dado un `solicitud_sin_tecnicos`, llega al mismo detalle, que sigue abierto. · Verificación: `app/test/core/notificaciones/destino_aviso_test.dart` → `CA_024_04`
- **CA-05:** Dados `solicitud_nueva`, `request_cancelled` y `cotizacion_vencida` tocados por un técnico, cuando se abre, entonces llega a `/trabajo` con la sección de solicitudes recargada; y dado `cotizacion_aceptada`, llega a `/trabajo/visita/:id` con el `visitaId` de la carga. · Verificación: `app/test/core/notificaciones/destino_aviso_test.dart` → `CA_024_05`
- **CA-06:** Dado un `mensaje_nuevo`, cuando se toca, entonces abre `/conversaciones` (spec 020) mientras no exista la pantalla de chat, y `/conversaciones/:id` cuando exista; nunca abre WhatsApp ni otra app. · Verificación: `app/test/core/notificaciones/destino_aviso_test.dart` → `CA_024_06`
- **CA-07:** Dado un aviso cuyo recurso ya no existe, es ajeno o la cuenta cambió, cuando la pantalla destino lo pide, entonces el servidor responde 404 y la app muestra «Esta solicitud ya no está disponible» (o «Esta visita ya no está disponible») con «Ir a Actividad» o «Ir a Trabajo», sin revelar que existe. · Verificación: `app/test/core/notificaciones/destino_aviso_test.dart` → `CA_024_07`
- **CA-08:** Dada una carga con `recurso` que no cumple `^[0-9a-f]{24}$`, con `evento` desconocido, con `v` distinto de `1`, con campos de más de 64 caracteres, con una ruta, una URL, un esquema (`http:`, `intent:`, `knock:`) o caracteres `/`, `?`, `#`, `%` o `..`, cuando se lee, entonces la app no navega a esa ruta: si el `tipo` es válido cae en la pestaña natural del tipo (spec 012) y si no, ignora el aviso; nunca lanza excepción. · Verificación: `app/test/core/notificaciones/carga_aviso_test.dart` → `CA_024_08`
- **CA-09:** Dado un aviso de técnico (`solicitud_nueva`, `request_cancelled`, `cotizacion_vencida`, `cotizacion_aceptada`) tocado en una cuenta sin rol de técnico, cuando se abre, entonces el `redirect` del router (spec 012) lo manda a Inicio y no se pide ningún recurso de Trabajo. · Verificación: `app/test/core/notificaciones/destino_aviso_test.dart` → `CA_024_09`
- **CA-10:** Dadas dos cargas con el mismo `aviso`, o dos `cotizacion_nueva` de la misma solicitud, cuando llegan seguidas, entonces se muestra una sola notificación: la segunda se descarta (mismo `aviso`) o reemplaza a la primera por su etiqueta `evento:recurso`. · Verificación: `app/test/core/notificaciones/presentador_avisos_test.dart` → `CA_024_10`
- **CA-11:** Dada la app en primer plano, cuando llega cualquier aviso del catálogo, entonces no se muestra una notificación del sistema: se muestra un aviso dentro de la app con el mismo texto y la acción «Ver», y se refrescan la lista o el detalle afectados (Actividad, Trabajo, detalle de la solicitud o contador de conversaciones). · Verificación: `app/test/core/notificaciones/aviso_en_primer_plano_test.dart` → `CA_024_11`
- **CA-12:** Dado un `mensaje_nuevo` de la conversación que está abierta, cuando llega con la app en primer plano, entonces no se muestra nada (spec 012, R-04); y dado uno de otra conversación, se muestra el aviso dentro de la app y sube el contador del globo (spec 020). · Verificación: `app/test/core/notificaciones/aviso_en_primer_plano_test.dart` → `CA_024_12`
- **CA-13:** Dado el tipo de aviso apagado en Configuración (por ejemplo «Mensajes»), cuando llega un aviso de ese tipo, entonces no se muestra la notificación del sistema ni el aviso dentro de la app, pero las listas sí se refrescan si la app está abierta; los avisos de tipo `sistema` no se pueden apagar. · Verificación: `app/test/core/notificaciones/presentador_avisos_test.dart` → `CA_024_13`
- **CA-14:** Dado que no hay sesión guardada en el teléfono (se cerró sesión o se borró la sesión), cuando llega un aviso, entonces no se muestra; y si se toca uno que ya estaba en la bandeja del sistema, la app abre Entrada, descarta el destino y después de entrar va a Inicio. · Verificación: `app/test/core/notificaciones/presentador_avisos_test.dart` → `CA_024_14`
- **CA-15:** Dado el permiso de notificaciones negado, cuando ocurre un evento, entonces la app sigue funcionando y la persona ve el cambio al abrir Actividad o Trabajo; en Configuración la sección de avisos muestra «Las notificaciones están apagadas en tu teléfono» con «Abrir ajustes». · Verificación: `app/test/core/notificaciones/seccion_avisos_test.dart` → `CA_024_15`
- **CA-16:** Dado el registro de la app, cuando llega, se muestra o se toca un aviso, entonces ningún `print`, registro ni reporte de errores contiene `recurso`, `aviso`, `conversacion`, el identificador de notificaciones ni el texto mostrado; solo el `evento` y el resultado (prueba global de la spec 009). · Verificación: `app/test/seguridad/seguridad_cliente_test.dart` → `CA_024_16`
- **CA-17:** Dados los avisos dentro de la app y la sección de avisos de Configuración, cuando se recorren con lector de pantalla y texto al 200 % en 320 × 640, entonces el aviso se anuncia completo («Recibiste una cotización. Ábrela para compararla. Ver»), «Ver» y cada interruptor miden al menos 48 dp, el contraste cumple 4.5:1 y nada se corta. · Verificación: `app/test/core/notificaciones/accesibilidad_avisos_test.dart` → `CA_024_17`
- **CA-18:** Dado el manifiesto de Android, cuando se revisa, entonces no hay `intent-filter` de enlaces (App Links ni esquema propio) para las rutas de esta spec y la actividad que recibe el toque no queda exportada a otras apps más allá de la principal. · Verificación: `app/test/seguridad/manifiesto_test.dart` → `CA_024_18`
- **CA-19:** Dado un aviso tocado sin conexión, cuando se abre la pantalla destino, entonces se muestra su estado sin conexión con «Reintentar» (specs 015, 016, 019 y 020) y no se inventan datos con la carga. · Verificación: `app/test/core/notificaciones/destino_aviso_test.dart` → `CA_024_19`

## 3. Alcance / No-alcance

**Dentro (capa Mobile)**
- Catálogo de avisos de la cadena de solicitudes (§4.2): evento, quién lo recibe, tipo de aviso, texto y pantalla que abre.
- Versión 1 de la carga (§4.1): campos, longitudes, formato y regla de lectura que ignora lo desconocido.
- Validación del enlace profundo: lista cerrada de eventos y plantillas de ruta; el identificador se valida antes de navegar y el servidor autoriza al abrir.
- Presentación: notificación del sistema con la app cerrada o en segundo plano; aviso dentro de la app en primer plano; deduplicación y reemplazo por etiqueta; canales de Android por tipo.
- Filtro por preferencias (spec 012, R-05) y por sesión presente.
- Refresco de las listas afectadas cuando llega un aviso con la app abierta.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.

**Fuera**
- Registro y desregistro del identificador, permiso y su explicación previa: spec 012 (aprobada) y su adaptador real pendiente (Memoria 2026-11-05).
- El envío desde el servidor, la plantilla del lado del servidor, la deduplicación por evento (`notifications.enviados`) y el límite de envíos: spec de backend de HU-050, que **no existe** (§13).
- Bandeja de avisos dentro de la app y sincronizar preferencias con el servidor: HU-051 (KNOCK-105, Sprint 6).
- Avisos de visitas que no son de la cadena de solicitudes: recordatorios (HU-040), reprogramación, cancelación de cita, cambio de precio, trabajo terminado, opiniones y verificación.
- Avisar al cliente que su solicitud se amplió a otra oleada, avisar al técnico que su cotización no fue elegida o que una solicitud venció, y el recordatorio «tu solicitud está por vencer» (D-08).
- Pantallas destino: son de las specs 015, 016, 019, 020 y 025; aquí solo se navega a ellas.

### Requisitos

- **R-01:** La app reconoce exactamente los ocho eventos de §4.2; cualquier otro `evento` se trata como desconocido.
- **R-02:** La carga es la de §4.1 y solo lleva identificadores opacos; la app nunca muestra un texto que venga en la carga ni en el bloque `notification` de Firebase.
- **R-03:** El título y el cuerpo visibles salen de los ARB por `evento` y del idioma del teléfono; son genéricos y pasan la revisión de la spec 012 (R-03).
- **R-04:** Antes de navegar, la app valida `v`, `evento`, `tipo` y `recurso`; arma la ruta con una plantilla de la lista cerrada de §4.2 y nunca con un texto recibido.
- **R-05:** La pantalla destino pide el recurso al servidor; un 404 se muestra como «ya no está disponible» y un 401 sigue la renovación de la spec 002.
- **R-06:** Los avisos de técnico solo abren rutas de `/trabajo`; el rol lo decide el `redirect` del router y el servidor.
- **R-07:** Con la app en primer plano no se muestra la notificación del sistema: se muestra un aviso dentro de la app y se refresca lo afectado; un `mensaje_nuevo` de la conversación abierta no muestra nada.
- **R-08:** Una carga con el mismo `aviso` se muestra una sola vez por sesión de la app; dos cargas con el mismo `evento:recurso` se reemplazan en la bandeja del sistema.
- **R-09:** Un tipo de aviso apagado en Configuración no muestra notificación ni aviso dentro de la app; `sistema` no se apaga.
- **R-10:** Sin sesión guardada no se muestra ningún aviso y el destino de un toque se descarta.
- **R-11:** Sin permiso de notificaciones la app sigue funcionando y Configuración lo explica con un acceso a los ajustes del teléfono.
- **R-12:** Nada de la carga ni del texto se registra, se guarda en disco ni se envía en reportes de errores; solo el `evento` y el `ResultadoAviso` de §5.
- **R-13:** La app no declara enlaces de Android para estas rutas: solo se llega a ellas desde la propia app o desde una notificación de Firebase del proyecto.
- **R-14:** Todos los textos viven en los ARB de español e inglés y los colores y tipografías en el tema (spec 014).
- **R-15:** Cada control mide al menos 48 dp, tiene etiqueta semántica, cumple el contraste y funciona con texto al 200 %.

## 4. Contrato API y eventos

La app **consume** dos cosas: (1) mensajes de datos de Firebase Cloud Messaging con la carga de §4.1, que envía el servicio de Mensajería y notificaciones al procesar los eventos del buzón de salida de Mercado y de Mensajería; y (2) las rutas REST que pide cada pantalla destino, ya definidas en backend.

### 4.1 Carga de la notificación (versión 1)

Mensaje **solo de datos** (sin bloque `notification`), con prioridad alta para que Android lo entregue con la app cerrada. Todos los valores son cadenas, como exige Firebase.

| Campo | Obligatorio | Formato y límite | Para qué |
|---|---|---|---|
| `v` | Sí | Exactamente `1` | Versión de la carga; otro valor → se trata como carga sin evento (cae en la regla de la spec 012) |
| `tipo` | Sí | `cotizaciones`, `mensajes`, `visitas` o `sistema` (nombres de `TipoAviso`, spec 012) | Preferencias y canal de Android; compatibilidad con la carga de la spec 012 |
| `evento` | Sí | Uno de los ocho de §4.2; `^[a-z_]{3,40}$` | Texto del aviso y plantilla de ruta |
| `recurso` | Sí, salvo en `sistema` | `ObjectId` de MongoDB: `^[0-9a-f]{24}$` | Identificador de la solicitud, de la visita o de la conversación (según el evento) |
| `aviso` | Sí | UUID: `^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$` | Identificador único del envío, para no mostrarlo dos veces |
| `conversacion` | Solo en `mensaje_nuevo` | Igual que `recurso` | Compatibilidad con el modo «chat en vivo» de la spec 012 (R-04) |
| `destino` | No (se ignora si viene) | — | Lo deja la spec 012 como respaldo; con `evento` válido la app no lo usa |

Reglas de lectura:
- Tamaño total de la carga ≤ 1 KB; cualquier campo de más de 64 caracteres invalida la carga completa.
- Los campos que no están en la tabla se ignoran y **nunca** se muestran.
- La carga **no** lleva nombres, teléfono, dirección, colonia, oficio, montos, fechas de la cita, códigos, texto de mensajes, `sub`, celular ni el identificador de notificaciones.
- Con `evento` desconocido o `recurso` inválido, la app aplica la regla de la spec 012: si `tipo` es válido abre la pestaña natural del tipo; si no, ignora el aviso.

### 4.2 Catálogo de avisos de la cadena de solicitudes

| `evento` | Quién lo recibe | Lo dispara (backend) | `tipo` | `recurso` | Abre (plantilla de ruta) | Llamada de la pantalla destino |
|---|---|---|---|---|---|---|
| `solicitud_nueva` | Cada técnico que recibe la solicitud en cualquier oleada (hasta 3, `Oleadas:MaximoOleadas`) | `SolicitudEnviadaATecnico { solicitudId, tecnicoId, oleada }`, backend 028 (R-16) | `cotizaciones` | `solicitudId` | `/trabajo` (sección «Solicitudes nuevas», spec 019) | `GET /api/v1/tecnicos/me/solicitudes` (backend 028, R-13) |
| `solicitud_sin_tecnicos` | Cliente dueño | `SolicitudSinTecnicos { solicitudId }`, backend 028 (R-07): ninguna oleada encontró técnicos | `cotizaciones` | `solicitudId` | `/actividad/solicitud/{recurso}` (spec 015) | `GET /api/v1/solicitudes/{id}` (backend 020) |
| `cotizacion_nueva` | Cliente dueño | `CotizacionEnviada`, backend 020 (R-16 y CA-06) | `cotizaciones` | `solicitudId` | `/actividad/solicitud/{recurso}/cotizaciones` (spec 015) | `GET /api/v1/solicitudes/{id}/cotizaciones` (backend 021) |
| `cotizacion_aceptada` | Técnico elegido | `CotizacionAceptada` y `VisitaConfirmada`, backend 021 (R-18) | `visitas` | `visitaId` | `/trabajo/visita/{recurso}` (spec 016) | `GET /api/v1/visitas/{id}` (backend 022) |
| `request_cancelled` | Técnicos con cotización `enviada` al cancelar (`tecnicosAvisar`) | `SolicitudCancelada { solicitudId, tecnicosAvisar[] }`, backend 029 (R-07) | `cotizaciones` | `solicitudId` | `/trabajo` | `GET /api/v1/tecnicos/me/solicitudes` (028) y la lista de Trabajo de la spec 019 |
| `request_expired` | Cliente dueño (`clienteId`) | `SolicitudVencida { solicitudId, clienteId, tecnicosAvisar[] }`, backend 029 (R-09) | `cotizaciones` | `solicitudId` | `/actividad/solicitud/{recurso}` (specs 015 y 025) | `GET /api/v1/solicitudes/{id}` (backend 020, con `puedeVolverAPedir` de 029) |
| `cotizacion_vencida` | Técnicos con cotización `enviada` al vencer (`tecnicosAvisar` del mismo evento) | `SolicitudVencida`, backend 029 (R-09) | `cotizaciones` | `solicitudId` | `/trabajo` | La lista de Trabajo de la spec 019 |
| `mensaje_nuevo` | La otra parte de la conversación cuando no está conectada (`destinatarioUsuarioId`) | `MensajeNuevo { conversacionId, destinatarioUsuarioId }`, backend 030 (R-14), sin texto | `mensajes` | `conversacionId` (`ObjectId`) | `/conversaciones` hoy; `/conversaciones/{recurso}` cuando exista la pantalla de chat (D-06) | `GET /api/v1/conversaciones` y, con chat, `GET /api/v1/conversaciones/{id}` (backend 030, R-17 y R-05) |

### 4.3 Rutas REST que se consumen al abrir

| Método y ruta | Spec de backend | Errores que la app distingue al llegar desde un aviso |
|---|---|---|
| `GET /api/v1/solicitudes/{id}` | 020 (R-08) | `400` id mal formado → «ya no está disponible»; `401` → renovar (spec 002); `404` → «Esta solicitud ya no está disponible»; `429` con `Retry-After` |
| `GET /api/v1/solicitudes/{id}/cotizaciones` | 021 | Igual; además `200` con `puedeElegir = false` y `motivo` (`request_expired`, `request_cancelled`, `request_already_chosen`) lo pinta la spec 015 |
| `GET /api/v1/visitas/{id}` | 022 | `404` → «Esta visita ya no está disponible»; `401`, `429` |
| `GET /api/v1/conversaciones` | 030 (R-17): `cursor?`, `limit?` (1–20); `{ items[], totalNoLeidos, nextCursor }` | `400`, `401`, `429` |
| `GET /api/v1/conversaciones/{id}` | 030 (R-05), cuando exista la pantalla de chat | `404` → «Esta conversación ya no está disponible»; `401`, `429` |
| `GET /api/v1/tecnicos/me/solicitudes` | 028 (R-13): `cursor?`, `limit?` (1–20) | `401`, `403 not_a_technician`, `429` |
| `GET /api/v1/tecnicos/me/trabajo` | Propuesta de la spec 019; spec de backend 036 (Borrador) | Los de la spec 019 |

Reglas del contrato que la app da por ciertas:
- **Autorización por recurso:** el servidor responde 404 para lo ajeno o inexistente; la carga nunca prueba que el recurso sea de quien la recibe.
- **Sin caché:** las respuestas de estas rutas llevan `Cache-Control: private, no-store` (backend 020, R-18) y la app no las guarda (spec 010, R-04).
- **Idempotencia y deduplicación:** el servidor no envía dos veces el mismo evento a la misma persona (HU-050 CA4); la app además descarta un `aviso` repetido (R-08).
- **Paginación:** las listas que se refrescan usan su propio cursor (specs 019 y 020); un aviso no cambia la página pedida.

## 5. Modelo de datos

**Entidades de dominio** (`app/lib/core/notificaciones/`, Dart puro salvo el adaptador)

| Entidad | Campos | Reglas |
|---|---|---|
| `EventoAviso` (enum) | `solicitudNueva`, `solicitudSinTecnicos`, `cotizacionNueva`, `cotizacionAceptada`, `solicitudCancelada`, `solicitudVencida`, `cotizacionVencida`, `mensajeNuevo` | Nombre de contrato en `snake_case`; tabla de §4.2 en un solo lugar |
| `CargaAviso` | `version`, `tipo` (`TipoAviso`), `evento?`, `recurso?`, `aviso`, `conversacion?` | Se construye solo con `CargaAviso.desde(Map)`; inválida → `null` o carga de la spec 012 |
| `IdRecurso` | `valor` | Solo `^[0-9a-f]{24}$`; `toString()` no lo muestra |
| `DestinoAviso` | `ruta` (resuelta) y `rolRequerido` (`cliente`, `tecnico`, `cualquiera`) | Sale de una plantilla de la lista cerrada; nunca de un texto recibido |
| `TextoAviso` | `titulo`, `cuerpo` | Sale de los ARB por `evento`; pasa `esTextoSeguro` |
| `ResultadoAviso` (enum) | `mostrado`, `enPrimerPlano`, `filtradoPorPreferencia`, `sinSesion`, `duplicado`, `invalido`, `abierto` | Único dato que se registra, junto con el `evento` |

**Estado local**
- `avisosVistos`: los últimos 100 valores de `aviso`, **solo en memoria**, para descartar duplicados; se vacía al cerrar sesión.
- Preferencias por tipo: las de `AlmacenAvisos` (spec 012), un booleano por tipo; nada nuevo en disco.
- La bandeja del sistema guarda la notificación con su etiqueta `evento:recurso`; al cerrar sesión la app cancela todas las notificaciones mostradas.
- Nada de la carga se guarda en `shared_preferences`, SQLite, caché de respuestas ni archivos.

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Fuga de información:** datos personales en la pantalla de bloqueo, en la bandeja o en el reloj | Texto genérico de los ARB por evento; la carga no trae texto; revisión con `revisarTextoDeNotificacion` y lista de palabras prohibidas (`código`, `dirección`, `calle`, `colonia`, `$`, `pesos`, `teléfono`, `WhatsApp`, dígitos ≥ 4) | CA-01, CA-02 |
| **Fuga de información:** la carga viaja por Firebase (tercero) y queda en los registros del sistema | Solo identificadores opacos y el evento; sin nombre, monto, colonia, oficio ni texto de mensajes | CA-02, CA-08, CA-16 |
| **Fuga de información:** un tercero ve el aviso en la pantalla de bloqueo | Notificación privada con versión pública genérica (`avisoPublico`) | CA-01 |
| **Fuga de información:** registros o reportes de errores con identificadores | Solo se registra `evento` y `ResultadoAviso`; `toString()` de `CargaAviso` e `IdRecurso` no los muestra | CA-16 |
| **Suplantación:** otra app del teléfono abre una ruta interna con un enlace o `Intent` armado | Sin `intent-filter` de enlaces para estas rutas; el toque viaja en un `PendingIntent` inmutable creado por la app; la ruta se arma con plantillas cerradas; solo se aceptan toques de notificaciones que la propia app mostró | CA-08, CA-18 |
| **Suplantación:** una carga falsa o manipulada (evento inventado, ruta, URL, `..`) | Lectura estricta de §4.1; lista cerrada de eventos; validación del `ObjectId`; lo inválido se ignora o cae en la pestaña del tipo | CA-08 |
| **Elevación de privilegios:** un cliente abre una ruta de técnico desde un aviso | `redirect` por rol del router (spec 012) y autorización por recurso del servidor | CA-09 |
| **Acceso a lo ajeno (IDOR):** un `recurso` de otra persona | La pantalla pide el recurso al servidor; 404 → «ya no está disponible», sin revelar que existe | CA-07 |
| **Cambio de cuenta:** avisos de la cuenta anterior tras cerrar sesión | Desregistro del identificador (spec 012), avisos no mostrados sin sesión, notificaciones mostradas canceladas al cerrar sesión y destino descartado | CA-14 |
| **Denegación / abuso:** ráfaga de avisos (muchas cotizaciones o mensajes) | Reemplazo por etiqueta `evento:recurso`, descarte por `aviso` repetido; el límite de envíos es del servidor (§13) | CA-10 |
| **Repudio:** «nunca me avisaron» | La app no es la fuente: el servidor registra el envío (`notifications.enviados`, HU-050); la app solo registra el resultado sin datos | CA-16 |
| **Ingeniería social:** un aviso empuja a pagar o a salir de Knock | Ningún aviso abre WhatsApp, el navegador ni otra app; todos abren pantallas de Knock | CA-06 |

## 7. Pantallas, textos y accesibilidad

Esta spec no crea pantallas: crea la notificación del sistema, el aviso dentro de la app y un ajuste a la sección de avisos de Configuración (spec 012). Las pantallas destino son de las specs 015, 016, 019, 020 y 025 y conservan sus estados (cargando, con datos, vacío, error y sin conexión).

**Textos por evento** (ARB `aviso*`; español exacto y propuesta en inglés)

| `evento` | Título (es) | Cuerpo (es) | Title (en) | Body (en) | Claves ARB |
|---|---|---|---|---|---|
| `solicitud_nueva` | Tienes una solicitud nueva | Revísala y cotiza antes de que venza. | You have a new request | Check it and send a quote before it expires. | `avisoSolicitudNuevaTitulo`, `avisoSolicitudNuevaCuerpo` |
| `cotizacion_nueva` | Recibiste una cotización | Ábrela para compararla. | You got a quote | Open it to compare. | `avisoCotizacionNuevaTitulo`, `avisoCotizacionNuevaCuerpo` |
| `cotizacion_aceptada` | Te eligieron para un trabajo | Revisa el día y la hora de la visita. | You were chosen for a job | Check the visit day and time. | `avisoCotizacionAceptadaTitulo`, `avisoCotizacionAceptadaCuerpo` |
| `solicitud_sin_tecnicos` | Todavía no hay técnicos disponibles | Tu solicitud sigue abierta. Revisa el detalle. | No pros available yet | Your request is still open. Check the details. | `avisoSolicitudSinTecnicosTitulo`, `avisoSolicitudSinTecnicosCuerpo` |
| `request_cancelled` | Una solicitud se canceló | El cliente ya no necesita el servicio. | A request was canceled | The client no longer needs the service. | `avisoSolicitudCanceladaTitulo`, `avisoSolicitudCanceladaCuerpo` |
| `cotizacion_vencida` | Una solicitud que cotizaste venció | El cliente no eligió a tiempo. | A request you quoted expired | The client did not choose in time. | `avisoCotizacionVencidaTitulo`, `avisoCotizacionVencidaCuerpo` |
| `request_expired` | Tu solicitud venció | Puedes volver a pedirla con un toque. | Your request expired | You can request it again with one tap. | `avisoSolicitudVencidaTitulo`, `avisoSolicitudVencidaCuerpo` |
| `mensaje_nuevo` | Tienes un mensaje nuevo | Ábrelo en Knock. | You have a new message | Open it in Knock. | `avisoMensajeNuevoTitulo`, `avisoMensajeNuevoCuerpo` |

**Otros textos nuevos**

| Clave | Español | Uso |
|---|---|---|
| `avisoVer` | Ver | Acción del aviso dentro de la app |
| `avisoPublico` | Tienes un aviso nuevo | Versión pública en la pantalla de bloqueo |
| `avisoCanalCotizaciones` | Cotizaciones y solicitudes | Nombre del canal de Android y del interruptor en Configuración |
| `avisoCanalMensajes` | Mensajes | Canal e interruptor |
| `avisoCanalVisitas` | Visitas y citas | Canal e interruptor |
| `avisoCanalSistema` | Cuenta y seguridad | Canal; no se apaga |
| `avisosApagadosTelefono` | Las notificaciones están apagadas en tu teléfono. | Configuración, sin permiso |
| `avisosAbrirAjustes` | Abrir ajustes | Configuración, sin permiso |
| `avisoSolicitudNoDisponible` | Esta solicitud ya no está disponible. | Destino con 404 (reutiliza el de la spec 015 si ya existe) |
| `avisoVisitaNoDisponible` | Esta visita ya no está disponible. | Destino con 404 (reutiliza el de la spec 016 si ya existe) |
| `avisoConversacionNoDisponible` | Esta conversación ya no está disponible. | Destino con 404 en el chat (backend 030, R-05) |
| `avisoIrAActividad` / `avisoIrATrabajo` | Ir a Actividad / Ir a Trabajo | Botón tras el 404 |

**Estados de cada superficie**

| Superficie | Estados | Reglas |
|---|---|---|
| Notificación del sistema (app cerrada o en segundo plano) | mostrada, reemplazada (misma etiqueta), filtrada (preferencia o sin sesión), descartada (inválida o duplicada) | Ícono monocromo de la app; color de acento del tema; visibilidad privada con versión pública «Knock · Tienes un aviso nuevo» (`avisoPublico`) para la pantalla de bloqueo; canal por tipo |
| Aviso dentro de la app (primer plano) | visible 6 s, con acción, cerrado | Usa el componente de aviso de la spec 014; no tapa la barra inferior ni el globo (spec 020); se anuncia con una región en vivo cortés; se puede cerrar; con varios seguidos se muestra solo el último |
| Pantalla destino | cargando, con datos, vacía, error, sin conexión, no disponible (404) | La de cada spec; esta spec agrega el estado «no disponible» con su botón de regreso donde aún no exista |
| Configuración → avisos (spec 012) | permiso concedido, permiso negado, cargando | Cuatro filas (tres interruptores y «Cuenta y seguridad» sin interruptor, con la nota «Siempre activo»); con permiso negado, franja con `avisosApagadosTelefono` y `avisosAbrirAjustes` |

**Accesibilidad**
- Áreas táctiles ≥ 48 dp en «Ver», cerrar y cada interruptor; texto al 200 % en 320 × 640 sin cortes (el aviso crece hacia arriba).
- Contraste 4.5:1 (3:1 en bordes) en claro y oscuro con `relacionDeContraste` (spec 014).
- El aviso dentro de la app se anuncia como una sola frase: título, cuerpo y «Ver»; no se anuncia más de una vez el mismo aviso.
- El estado de cada interruptor se anuncia («Mensajes, activado») y no depende solo del color.

## 8. Pruebas, gates y límites

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | `CargaAviso.desde`, `IdRecurso`, tabla evento → destino, filtro por preferencias y sesión, deduplicación (`flutter_test`) |
| Widget (W) | Sí | Aviso dentro de la app, sección de avisos con permiso negado, estado «no disponible» de los destinos |
| Aceptación (ACC) | Sí | CA-01 a CA-19 |
| Contrato (CON) | Sí | Ejemplos de carga v1 en `app/test/fixtures/avisos/*.json` (uno válido por evento y uno inválido por regla) comparados con §4.1; cuando la spec de backend de HU-050 exista, los mismos ejemplos se validan del otro lado |
| Integración (INT) | Sí | `integration_test/avisos_test.dart`: servicio de notificaciones simulado que emite toques con la app cerrada, en segundo plano y en primer plano, con API simulada |
| Seguridad negativa (NEG) | Sí | Cargas manipuladas (ruta, URL, `..`, `%2F`, campos largos, versión distinta), rol equivocado, sin sesión, 404 ajeno, manifiesto sin enlaces |
| Accesibilidad (A11Y) | Sí | `expectAccesible` (spec 008), texto al 200 %, contraste |
| Mutación (MUT) | Sí | `carga_aviso.dart` y `destino_aviso.dart` con meta 70 % (`mutation_test`) |
| E2E | Sí | En emulador con un número de prueba de Firebase: enviar un mensaje de datos de prueba desde la consola de Firebase y tocarlo (manual, evidencia en el PR, sin datos reales) |
| Regresión | Sí | Suite completa; las pruebas de la spec 012 (`CargaNotificacion`, `abrirPantallaDesdeNotificaciones`) siguen en verde |
| CI/CD | Sí | `ci-pr.yml` corre `flutter analyze --fatal-infos --fatal-warnings`, `dart format --set-exit-if-changed`, `flutter test` con cobertura ≥ 50 % y el `gate` |
| Análisis estático y vulnerabilidades | Sí | `flutter analyze`, Semgrep, Gitleaks, OSV sobre `pubspec.lock` (incluida la dependencia de notificaciones locales, D-02) |
| Rendimiento (PERF) | No | Volumen bajo del piloto; la carga es de menos de 1 KB |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Cliente con la app cerrada recibe `cotizacion_nueva`: ve «Recibiste una cotización»; al tocar abre la comparación de esa solicitud |
| Positivo | Técnico en primer plano recibe `solicitud_nueva`: aviso dentro de la app con «Ver» y la sección «Solicitudes nuevas» se recarga |
| Positivo | Cliente recibe `request_expired`: al tocar ve el detalle con «Vencida» y «Volver a pedir» |
| Negativo | Carga con `recurso = "../cuenta"` o `"https://x"`: no navega a esa ruta; abre la pestaña del tipo |
| Negativo | Cliente toca `cotizacion_aceptada` (de técnico): el router lo manda a Inicio |
| Negativo | Aviso de la cuenta anterior tocado después de cerrar sesión: abre Entrada y descarta el destino |
| Error esperado | 404 al abrir: «Esta solicitud ya no está disponible» con «Ir a Actividad» |
| Error esperado | 401 al abrir: renueva una vez (spec 002); si falla, cierra sesión y descarta el destino |
| Error esperado | 429 al abrir: aviso con la espera de `Retry-After` (spec 009) y sin reintento en bucle |
| Error esperado | Sin conexión al abrir: estado sin conexión de la pantalla destino con «Reintentar» |
| Caso límite | Mismo `aviso` dos veces: una sola notificación |
| Caso límite | Cinco `cotizacion_nueva` de la misma solicitud: una sola notificación en la bandeja (la última) |
| Caso límite | Carga de exactamente 64 caracteres en un campo: válida; de 65: inválida |
| Caso límite | `mensaje_nuevo` de la conversación abierta: nada; de otra conversación: aviso dentro de la app |
| Caso límite | Idioma del teléfono distinto de español e inglés: textos en español |
| Caso límite | Permiso de notificaciones negado: no hay notificación; Configuración lo explica |

**Gates:** los de la spec 015 (§8) y `AGENTS.md` (Definición de terminado).
**Límites y dudas abiertas:** ver §13.

## 9. Arquitectura y componentes

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/core/notificaciones/evento_aviso.dart` | Crear | `EventoAviso`, tabla de §4.2 (tipo, plantilla de ruta, rol requerido, claves ARB) |
| `app/lib/core/notificaciones/carga_aviso.dart` | Crear | `CargaAviso.desde(Map)`, `IdRecurso` y validaciones de §4.1 |
| `app/lib/core/notificaciones/destino_aviso.dart` | Crear | Resuelve la ruta con la plantilla; sin evento válido delega en `CargaNotificacion` (spec 012) |
| `app/lib/core/notificaciones/presentador_avisos.dart` | Crear | Decide `ResultadoAviso`: sesión, preferencia, duplicado, primer plano, conversación abierta |
| `app/lib/core/notificaciones/texto_aviso.dart` | Crear | Texto por evento desde los ARB y revisión con `esTextoSeguro` |
| `app/lib/core/notificaciones/notificaciones_locales.dart` | Crear | Puerto para mostrar y cancelar notificaciones del sistema con canal y etiqueta; adaptador sobre la dependencia de D-02 |
| `app/lib/core/notificaciones/navegacion_notificaciones.dart` | Modificar | Usa `destino_aviso.dart`; descarta el destino sin sesión |
| `app/lib/core/notificaciones/servicio_notificaciones.dart` | Modificar | Expone los mensajes recibidos en primer plano (además de los toques) |
| `app/lib/core/widgets/aviso_en_app.dart` | Crear o reutilizar | Aviso dentro de la app (el componente de aviso de la spec 014 si ya existe; `reuse-before-create`) |
| `app/lib/core/notificaciones/refresco_por_aviso.dart` | Crear | Invalida los providers de Actividad, Trabajo, detalle y conversaciones según el evento |
| `app/lib/features/cuenta/presentation/seccion_avisos.dart` | Modificar | Nombres de los tipos, «Siempre activo» y franja de permiso negado |
| `app/lib/core/sesion/` (cierre de sesión) | Modificar | Al cerrar sesión, cancela las notificaciones mostradas y vacía `avisosVistos` |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 |
| `app/pubspec.yaml` y `Memoria.md` | Modificar | Dependencia de D-02, evaluada y registrada |
| `app/android/app/src/main/AndroidManifest.xml` | Revisar | Sin `intent-filter` de enlaces nuevos (CA-18); `POST_NOTIFICATIONS` llega con el adaptador real de la spec 012 |

**No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/`.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| 012 Notificaciones push y permisos (aprobada) | Identificador, permiso, carga `tipo`/`destino`, revisión de textos, preferencias, modo chat en vivo | **Bloqueante**: sin el adaptador real de Firebase no llega nada al teléfono (hoy `ServicioNotificacionesNoDisponible`) |
| Backend (HU-050, KNOCK-60): envío y registro de dispositivos, spec 037 (Borrador) | Envía la carga v1 con los eventos de §4.2; deduplica; registra el identificador | **Bloqueante** para el E2E; las pruebas de la app usan dobles |
| Backend 020 | `CotizacionEnviada`, `GET /solicitudes/{id}` | Sin `cotizacion_nueva` |
| Backend 021 | `CotizacionAceptada`, `VisitaConfirmada`, `GET /solicitudes/{id}/cotizaciones` | Sin `cotizacion_aceptada` |
| Backend 022 | `GET /visitas/{id}` | El técnico no puede abrir la visita |
| Backend 028 (Borrador) | `SolicitudEnviadaATecnico`, `SolicitudSinTecnicos`, `GET /tecnicos/me/solicitudes` | Sin `solicitud_nueva` ni `solicitud_sin_tecnicos` |
| Backend 029 (Borrador) | `SolicitudCancelada`, `SolicitudVencida`, `puedeVolverAPedir` | Sin `request_cancelled`, `request_expired` ni `cotizacion_vencida` |
| Backend 030 (Borrador) y 026 | `MensajeNuevo`, conversaciones y contador de no leídos | Sin `mensaje_nuevo` |
| 015, 016, 019, 020, 025 | Pantallas destino y sus estados | El toque abre la pestaña natural del tipo (regla de la spec 012) |
| 014 Alinear la UI (reservada) | Componente de aviso y contraste | Se crea un aviso propio y se migra después |
| 002, 008, 009, 010 | Errores, accesibilidad, espera por 429, política de caché | Manejo incompleto |

## 11. Definición de terminado

- CA-01 a CA-19 con prueba que falla si la lógica está mal; `python3 scripts/sdd_lint.py --trace 024` sin `FALTA`.
- `flutter analyze --fatal-infos --fatal-warnings`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 % y mutación ≥ 70 % en `carga_aviso.dart` y `destino_aviso.dart`.
- ARB en español e inglés completos y prueba de traducciones en verde.
- La dependencia de D-02 evaluada (licencia, mantenimiento, OSV) y registrada en `Memoria.md`.
- Recorrido real en emulador con un aviso de prueba por evento disponible en backend, con capturas sin datos reales.
- La spec 037 adopta la carga v1 de §4.1 (o esta spec se ajusta antes de implementar).
- `Memoria.md` al día; PR con la plantilla completa, etiqueta `puntos-app-N` y CI en verde; revisión de un par.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | La carga lleva `evento`, `recurso` y `aviso` además de `tipo` (versión `1`), y sigue aceptando la carga de la spec 012 | La spec 012 solo abre pestañas; HU-050 CA3 pide llegar al recurso. Mantener `tipo` evita romper lo ya implementado | Mandar una ruta en la carga, que permite abrir pantallas arbitrarias |
| D-02 | Mensajes solo de datos y texto armado en la app desde los ARB, con una dependencia de notificaciones locales que se evalúa y registra antes de agregarla | Garantiza que el servidor no pueda filtrar datos en el texto, traduce según el idioma del teléfono y permite etiqueta y canal por tipo | Bloque `notification` con texto del servidor, que deja el contenido fuera del control de la app y no se puede filtrar por preferencia |
| D-03 | `recurso` es un `ObjectId` validado con `^[0-9a-f]{24}$` y la ruta se arma con plantillas cerradas | Los identificadores de backend 020 a 022 son `ObjectId`; validar el formato corta cargas manipuladas antes de navegar | Aceptar cualquier cadena y confiar en el 404 del servidor |
| D-04 | Sin sesión, el destino de un toque se descarta y después de entrar se va a Inicio | Evita abrir recursos de otra cuenta y simplifica el flujo | Guardar el destino pendiente y abrirlo tras entrar, que puede mezclar cuentas |
| D-05 | En primer plano no hay notificación del sistema: aviso dentro de la app y refresco de lo afectado | Una notificación del sistema con la app abierta duplica la información y distrae | Mostrar siempre la notificación del sistema |
| D-06 | `mensaje_nuevo` abre `/conversaciones` hasta que exista la pantalla de chat | La spec 020 dejó el chat como spec propia; abrir una ruta inexistente fallaría | Abrir el detalle de la solicitud |
| D-07 | Todos los avisos de la cadena, salvo `cotizacion_aceptada` y `mensaje_nuevo`, usan el tipo `cotizaciones`, rebautizado en pantalla como «Cotizaciones y solicitudes» | `TipoAviso` (spec 012) no tiene un tipo «solicitudes» y agregar uno cambia la spec aprobada | Agregar un quinto tipo |
| D-08 | No se avisa al cliente de la ampliación a otra oleada, ni al técnico de una cotización no elegida (`other_quote_chosen`, backend 021), ni a los técnicos que recibieron la solicitud sin cotizar cuando se cancela o vence (backend 029, decisión 2), ni hay recordatorio «por vencer» | No lo pide ninguna historia (HU-025, HU-027, HU-028) ni la descripción §4, y backend no emite esos eventos; menos avisos, menos ruido | Avisar todo cambio de estado |
| D-12 | Un mismo evento de backend (`SolicitudVencida`) se convierte en dos avisos distintos: `request_expired` para el cliente y `cotizacion_vencida` para los técnicos de `tecnicosAvisar` | Cada destinatario necesita otro texto y otra pantalla; con un solo `evento` la app tendría que decidir el destino por rol | Un solo `evento` con el destino resuelto por rol en la app |
| D-09 | `avisosVistos` vive solo en memoria (100 entradas) | No hace falta persistir para evitar duplicados cercanos y no deja rastro en disco | Guardarlo en `shared_preferences` |
| D-10 | Las preferencias se aplican en la app (filtro local) mientras no exista la sincronización con el servidor | HU-051 (Sprint 6) define `PUT /me/preferencias-avisos`; la spec 012 ya guarda la preferencia localmente | Esperar a HU-051 para respetar preferencias |
| D-11 | Se sigue la spec 012 (cada tipo se puede apagar, salvo `sistema`) aunque la maqueta muestre cotizaciones, mensajes y visitas como «Siempre activos» | La spec 012 está aprobada y manda sobre la maqueta | Copiar la maqueta, que contradice R-05 de la spec 012 |

## 13. Riesgos y dudas abiertas

- **Resuelto en la revisión cruzada (decisión automática, revisar):** la spec de backend del envío de notificaciones y del registro de dispositivos es la 037 (Borrador; define `POST /api/v1/dispositivos`, que la spec 016 de backend cita como `DIS-02` sin definirlo). Debe adoptar la carga v1 de §4.1, enviar mensajes solo de datos con prioridad alta, deduplicar por evento y persona, limitar ráfagas (por ejemplo, un `mensaje_nuevo` por conversación cada pocos minutos) y no enviar `mensaje_nuevo` a quien está conectado al canal en vivo.
- **Validado:** los eventos de backend 028 (`SolicitudEnviadaATecnico`, `SolicitudSinTecnicos`) y 029 (`SolicitudCancelada`, `SolicitudVencida`) coinciden con §4.2. También backend 030 (`MensajeNuevo { conversacionId, destinatarioUsuarioId }`, sin texto; `conversacionId` es `ObjectId`). **Pendiente de validar en backend 030:** qué significa «no está conectado» (conectado al hub o unido a esa conversación); la app de todos modos no muestra el aviso si la conversación está abierta (R-07).
- **Resuelto (backend 028 §15):** `GET /api/v1/tecnicos/me/trabajo` (spec 019) tiene spec de backend 036 (Borrador); los avisos de técnico abren `/trabajo` igual.
- **Riesgo:** con mensajes solo de datos, Android puede retrasar la entrega si el servidor no usa prioridad alta o si el fabricante restringe la app en segundo plano.
- **Riesgo:** la dependencia de notificaciones locales (D-02) agrega permisos o receptores al manifiesto; se revisa con la prueba de manifiesto de la spec 009.
- **Riesgo:** esta spec depende de la implementación de la spec 012 (permisos y registro de dispositivo), que aún no está hecha: el `pubspec.yaml` no trae `firebase_messaging` ni `flutter_local_notifications`. La 012 se implementa antes que esta.
- **Conflicto detectado:** la maqueta (`S.notifConfig`) dice que cotizaciones, mensajes y visitas no se pueden apagar; la spec 012 dice que sí (D-11). **Propuesta por defecto:** seguir la spec 012 (aprobada): la persona puede apagar cada tipo de aviso, y se ajusta la maqueta.
- **Duda abierta (entre specs):** las specs 016 (aviso «tu técnico llegó») y 018 (CA-12, cambio de estado de la verificación) dicen que su aviso lo define esta spec, pero §4.2 no tiene un evento de llegada ni de verificación. Backend 022 ya emite `VisitaEnCurso` y backend 025 emite `VerificacionDecidida` «para el aviso». Opciones: agregar `visita_en_curso` (cliente → `/actividad/visita/{recurso}`) y un evento de verificación (técnico → `/trabajo/verificacion`) a §4.2, o quitar esos avisos de las specs 016 y 018. **Propuesta por defecto:** agregar ambos eventos, alineados con `VisitaEnCurso` y `VerificacionDecidida` de backend; esta spec sigue con ocho eventos hasta que se apruebe el cambio.
- **Duda abierta:** ¿el técnico debe recibir aviso cuando el cliente eligió a otro? HU-027 y la descripción no lo piden (D-08).

## Aprobación

- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
