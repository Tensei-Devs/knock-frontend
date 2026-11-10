# Spec 015 — Pedir y comparar cotizaciones (pantallas)

> **Jira:** KNOCK-59 (HU-024), KNOCK-81 (HU-032) y KNOCK-82 (HU-033); tareas de la capa Mobile KNOCK-244 («App: pantallas para pedir una cotización (HU-024)», 3 pts) y KNOCK-245 («App: pantalla para elegir una cotización y ver teléfono y dirección (HU-033)», 2 pts); claves y resúmenes verificados en Jira el 9 de noviembre de 2026 · **Épica:** EP-04 Solicitudes y EP-05 Chat y cotizaciones · **Módulo:** requests · **Responsable:** Erick Trejo Reséndiz · **Sprint:** S4 · **Puntos:** 5 (N-2 y N-3; las historias ya tienen 5, 3 y 5 en Jira) · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend (specs 020 «Solicitudes y cotizaciones» y 021 «Comparar y elegir cotización»)
> **Fuentes:** `docs/referencia/FUNCIONES_Y_FLUJOS.md` §3.5 y §3.6 · `docs/referencia/DECISIONES.md` #4 y #6 · `docs/backlog/HU-024.md`, `HU-032.md`, `HU-033.md`
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 020 y 021 y se vendoriza antes de implementar (spec 006).
> **Estado:** Borrador

## 1. Objetivo

Permitir que una persona describa su problema con fotos, pida cotizaciones, las compare y elija una, desde la app Android, contra el entorno desplegado y con estados de carga, vacío, error y sin conexión. Esta spec cubre la capa **Mobile**; el contrato, las reglas de reparto y la revelación de datos de contacto son del backend (specs 020 y 021).

## 2. Historia y casos de prueba

**KNOCK-59** — Como cliente, quiero describir mi problema con fotos y pedir cotizaciones, para recibir varias opciones sin llamar a nadie.
**KNOCK-81** — Como cliente, quiero comparar las cotizaciones que recibí, para elegir con información y no solo por precio.
**KNOCK-82** — Como cliente, quiero elegir una cotización, para confirmar la cita con el técnico que más me convence.

- **CA-01:** Dada una persona con sesión que abre «Pedir cotización», cuando completa oficio, descripción de 8 a 500 caracteres, al menos una foto, día dentro de hoy a 5 días y franja, entonces se envía la solicitud con el `coloniaId` de la zona guardada, se muestra «Solicitud enviada» y se abre su detalle con el estado **Enviada**. · Verificación: `app/test/features/actividad/presentation/solicitud_controller_test.dart` → `CA_015_01`
- **CA-02:** Dado el paso «Qué pasa», cuando la descripción tiene menos de 8 o más de 500 caracteres, entonces el campo muestra el error en línea y no se avanza. · Verificación: `app/test/features/actividad/domain/validacion_solicitud_test.dart` → `CA_015_02`
- **CA-03:** Dado el paso «Qué pasa», cuando no hay fotos o se intenta agregar una sexta, entonces se explica «Agrega al menos una foto: le dice al técnico qué llevar» y el máximo es 5. · Verificación: `app/test/features/actividad/presentation/selector_fotos_test.dart` → `CA_015_03`
- **CA-04:** Dado el paso «Cuándo y dónde», cuando se elige un día anterior a hoy o posterior a hoy + 5, entonces no se puede seleccionar y solo se ofrecen 6 días. · Verificación: `app/test/features/actividad/domain/validacion_solicitud_test.dart` → `CA_015_04`
- **CA-05:** Dado el oficio mecánica con modalidad taller, cuando se llega al paso «Cuándo y dónde», entonces no se pide dirección y se avisa «Llevarás tu auto al taller». · Verificación: `app/test/features/actividad/presentation/paso_cuando_donde_test.dart` → `CA_015_05`
- **CA-06:** Dado un envío en curso, cuando la persona toca «Enviar» dos veces, entonces el botón queda deshabilitado y sale una sola petición. · Verificación: `app/test/features/actividad/data/solicitud_repository_api_test.dart` → `CA_015_06`
- **CA-07:** Dada una solicitud con cotizaciones, cuando se abre «Ver y elegir», entonces se muestran como máximo 5 tarjetas con foto, nombre, insignia y nivel de verificación, calificación, etiquetas del servidor (`verificado`, `mejor_precio`, `puede_ir_mas_pronto`), tipo de precio (fijo, rango o solo visita) con su máximo (`tope`), el texto «qué cubre», día, hora y nota; si `totalCotizaciones` es mayor que 5 se lee «Te mostramos 5 de N» y si `tiposMixtos` es verdadero se muestra «Las cotizaciones cubren cosas distintas: revisa qué incluye cada una». · Verificación: `app/test/features/actividad/presentation/cotizaciones_screen_test.dart` → `CA_015_07`
- **CA-08:** Dada la comparación abierta, cuando se elige «Recomendadas», «Menor precio», «Mejor calificadas» o «Más pronto», entonces la app pide al servidor el valor de `orden` correspondiente y muestra el orden recibido, sin reordenar en el teléfono. · Verificación: `app/test/features/actividad/presentation/cotizaciones_controller_test.dart` → `CA_015_08`
- **CA-09:** Dada una respuesta con `puedeElegir` falso, cuando se abre la comparación, entonces se oculta «Elegir» en todas las tarjetas y se muestra el texto del `motivo` (`sin_cotizaciones`, `solicitud_vencida`, `solicitud_cancelada` o `ya_elegida`); con `ya_elegida` aparece «Ver mi visita», que abre la visita de `visitaId`. · Verificación: `app/test/features/actividad/presentation/cotizaciones_controller_test.dart` → `CA_015_09`
- **CA-10:** Dada una cotización sin elegir, cuando se revisa la tarjeta y su detalle, entonces **no** aparecen teléfono ni dirección del técnico ni del cliente. · Verificación: `app/test/features/actividad/presentation/tarjeta_cotizacion_test.dart` → `CA_015_10`
- **CA-11:** Dada una cotización, cuando se confirma la elección, entonces se muestra la cita (técnico, día, hora, precio y máximo, modalidad), se revelan **solo después** de confirmar el contacto público del técnico (`telefono` o `whatsapp`; si no los publicó, «Este técnico no publicó un teléfono. Podrás escribirle por el chat cuando esté disponible») y el lugar (`lugar.direccion`: la del taller o la que escribiste), y el botón «Ver mi visita» abre la visita de `visitaId` (spec 016). · Verificación: `app/test/features/actividad/presentation/hoja_confirmar_eleccion_test.dart` → `CA_015_11`
- **CA-12:** Dada una elección que el servidor rechaza con 409 y `code` igual a `solicitud_ya_elegida`, `cotizacion_no_disponible`, `solicitud_vencida`, `solicitud_cancelada` o `solicitud_sin_cotizaciones`, cuando llega la respuesta, entonces se muestra el mensaje exacto de ese código (§7, tabla de mensajes), se refresca la lista, no se crea una cita y la elección no se reintenta sola. · Verificación: `app/test/features/actividad/presentation/cotizaciones_controller_test.dart` → `CA_015_12`
- **CA-13:** Dada una solicitud de otra persona, cuando la app la pide, entonces recibe 404 y se muestra «Esta solicitud ya no está disponible», sin revelar que existe. · Verificación: `app/test/features/actividad/data/solicitud_repository_api_test.dart` → `CA_015_13`
- **CA-14:** Dada una persona sin señal a media captura, cuando vuelve a abrir el formulario, entonces recupera lo escrito y las fotos elegidas del borrador local. · Verificación: `app/test/features/actividad/data/borrador_repository_test.dart` → `CA_015_14`
- **CA-15:** Dado un 429 con `Retry-After`, cuando se envía o se consulta, entonces la app espera el tiempo indicado, muestra el aviso y no reintenta en bucle. · Verificación: `app/test/features/actividad/presentation/solicitud_controller_test.dart` → `CA_015_15`
- **CA-16:** Dadas las pantallas del flujo, cuando se recorren con lector de pantalla y texto al 200 %, entonces cada control tiene etiqueta, mide al menos 48 dp y no se corta el contenido. · Verificación: `app/test/features/actividad/presentation/accesibilidad_solicitud_test.dart` → `CA_015_16`
- **CA-17:** Dado el oficio a domicilio sin dirección guardada, cuando se llega al paso «Cuándo y dónde», entonces se piden calle y número, se aceptan de 8 a 200 caracteres y con 7 o con 201 no se avanza. · Verificación: `app/test/features/actividad/domain/validacion_solicitud_test.dart` → `CA_015_17`
- **CA-18:** Dada una foto de 4000 px con metadatos de ubicación, cuando se prepara para subir, entonces se valida tipo y tamaño (JPEG o PNG de hasta 5 MB, el límite de backend 032) antes de decodificarla, se limita el número de píxeles, mide como máximo 1600 px de lado mayor, sin recomprimir agresivamente, y no conserva EXIF. · Verificación: `app/test/features/actividad/data/foto_preparada_test.dart` → `CA_015_18`
- **CA-19:** Dado un borrador con texto y fotos, cuando se envía, se descarta o se cierra sesión, entonces el borrador y el directorio privado de fotos quedan vacíos, la dirección del domicilio no aparece en `shared_preferences` ni en ninguna clave de caché, y el manifiesto excluye esas claves y el directorio de fotos de la copia de seguridad. · Verificación: `app/test/features/actividad/data/borrador_repository_test.dart` → `CA_015_19`
- **CA-20:** Dada una elección que agotó el tiempo, cuando la persona reintenta y el servidor responde 409 `solicitud_ya_elegida`, entonces la app consulta la solicitud, muestra la cita ya confirmada y no lo trata como error. · Verificación: `app/test/features/actividad/data/solicitud_repository_api_test.dart` → `CA_015_20`
- **CA-21:** Dadas las fotos de una solicitud, cuando se muestran en el detalle, entonces se cargan solo desde direcciones `https` de los dominios permitidos de Knock que devuelve el servidor, cualquier otra dirección se descarta sin pedirla y la imagen no se guarda en la caché de respuestas ni en la caché persistente de imágenes. · Verificación: `app/test/features/actividad/data/fotos_privadas_test.dart` → `CA_015_21`
- **CA-22:** Dado un envío que el servidor rechaza con 422 `contenido_rechazado` o con 503 `moderacion_no_disponible`, cuando llega la respuesta, entonces se muestra el mensaje exacto de §7, el paso 2 conserva el texto y las fotos, y no se reintenta solo. · Verificación: `app/test/features/actividad/presentation/solicitud_controller_test.dart` → `CA_015_22`
- **CA-23:** Dado el cuerpo de `POST /solicitudes`, cuando se arma, entonces lleva `oficioClave`, `descripcion`, `fotos`, `dia`, `franja` y `coloniaId`, lleva `direccion` solo si el oficio es a domicilio y **nunca** lleva `modalidad` (la dicta el oficio en el servidor). · Verificación: `app/test/features/actividad/data/solicitud_repository_api_test.dart` → `CA_015_23`

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Formulario de solicitud en tres pasos: oficio, «qué pasa» (texto y 1 a 5 fotos) y «cuándo y dónde» (día, franja y modalidad).
- Borrador local de lo escrito y de las fotos elegidas.
- Detalle de la solicitud con su estado y el número de cotizaciones.
- Comparación de cotizaciones con cuatro órdenes, aviso de tipos mixtos, motivo cuando no se puede elegir y detalle de cada tarjeta.
- Confirmación de la elección y paso a la visita (spec 016).
- Estados de carga, vacío, error, sin conexión y reintento en todas las pantallas.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.
- Pruebas unitarias, de widget, de contrato, de seguridad negativa, de accesibilidad y de integración.

**Fuera**
- El contrato, las reglas de reparto, el vencimiento de 48 h, la concurrencia y la revelación de datos de contacto: backend 020 y 021.
- La app del técnico (enviar cotización, HU-031): en la demo el técnico se simula con semillas (N-4).
- El chat antes de elegir y WhatsApp después: depende de mensajería (backend 026) y de una spec propia.
- Cancelar la solicitud (HU-028), reprogramar (HU-034) y calificar (HU-039): fuera del Sprint 4.
- La dirección guardada en el perfil (HU-010) y la zona (spec 017).
- La lista completa de solicitudes en Actividad (ver D-03).
- El panel interno de moderación y los avisos push concretos.

### Requisitos

- **R-01:** La app arma la solicitud en tres pasos y solo la envía cuando los tres están completos y válidos.
- **R-02:** La descripción acepta de 8 a 500 caracteres; el contador se ve siempre y el error aparece junto al campo.
- **R-03:** La solicitud lleva de 1 a 5 fotos JPG o PNG de hasta 5 MB cada una, sin repetidas, subidas antes por el flujo de archivos privados de la spec 013 (`POST /api/v1/archivos/subidas`, `PUT`, `POST /api/v1/archivos/{id}/confirmar`, `uso: solicitud`) y enviadas como `archivoId` (*decisión automática, revisar*: las fotos de una solicitud son privadas, spec 020 R-04); la app valida tipo y tamaño antes de decodificar, limita el número de píxeles, las reduce solo si su lado mayor pasa de 1600 px, sin recomprimirlas agresivamente (la recodificación final es de backend 032 R-09), y quita sus metadatos de ubicación antes de subirlas (*decisión automática, revisar*). Las fotos se toman con la cámara del sistema o se eligen del selector del sistema, y **no** se declara el permiso `CAMERA` ni permisos de almacenamiento (misma decisión que la spec 018, D-05).
- **R-04:** El día se elige entre hoy y hoy + 5 días; la franja es mañana, tarde o noche, y es obligatoria.
- **R-05:** La modalidad la dicta el oficio (catálogo de oficios) y la app **no** la envía. Si el oficio se atiende en taller no se pide dirección ni se envía `direccion`; si es a domicilio y la persona no tiene dirección guardada, se pide calle y número en el mismo paso y se validan de 8 a 200 caracteres. La solicitud lleva el `coloniaId` de la zona guardada (spec 017); si no hay zona, se pide elegirla antes de enviar.
- **R-06:** La app no envía `Idempotency-Key` al crear una solicitud ni al elegir una cotización (retirada por ahora, ver los riesgos): deshabilita el botón mientras hay una operación en curso.
- **R-07:** Lo que la persona escribe y las fotos elegidas se guardan como borrador local y se recuperan al volver; el borrador **no** guarda la dirección del domicilio (se captura al enviar) y se borra al enviar, al cancelar el formulario de forma explícita y al cerrar sesión.
- **R-08:** La comparación muestra como máximo 5 cotizaciones y no reordena ni filtra en el teléfono: envía solo `orden` (`recomendadas`, `precio`, `calificacion` o `pronto`) y respeta el orden, las etiquetas, `totalCotizaciones`, `tiposMixtos`, `puedeElegir` y `motivo` que devuelve el servidor.
- **R-09:** Antes de elegir no se muestra ningún dato de contacto ni la dirección exacta de nadie; después de elegir se muestran los que devuelve el servidor.
- **R-10:** La app nunca registra en consola, en caché ni en un reporte de errores el texto de la solicitud, las fotos, el teléfono ni la dirección.
- **R-11:** Las solicitudes y sus cotizaciones **no** se guardan en la caché de respuestas (spec 010, R-04); solo se cachean los catálogos de oficios y colonias.
- **R-12:** Todo error de la API se muestra con un texto del catálogo de traducciones; nunca con el código HTTP, la URL ni el cuerpo de la respuesta.
- **R-13:** Cada pantalla tiene estados de carga, con datos, vacío, error y sin conexión, y un botón de reintentar cuando aplica.
- **R-14:** Todos los textos visibles viven en los ARB de español e inglés y todos los colores y tipografías en el tema.
- **R-15:** Cada control interactivo tiene etiqueta semántica, mide al menos 48 dp y funciona con el texto del sistema al 200 %.
- **R-17:** Cada `code` de error del contrato (§4) tiene su mensaje exacto en el catálogo (§7); un `code` desconocido cae en `errorServicio`. El 422 de moderación y el 503 conservan el borrador.
- **R-18:** Mientras la elección está en curso no se puede elegir otra tarjeta ni cerrar la hoja de confirmación; la respuesta de la elección no se guarda en disco: el contacto y el lugar se vuelven a leer de la visita (spec 016).
- **R-16:** El borrador, las fotos y su clave de preferencias quedan fuera de la copia de seguridad del sistema (`android:allowBackup="false"` o reglas de extracción que excluyan `knock.*` y el directorio de fotos), comprobado con una prueba del manifiesto.

## 4. Contrato API y eventos

La app **consume**; el contrato lo fijan backend 020 («Solicitudes y cotizaciones») y 021 («Comparar y elegir cotización») y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006). Esta tabla se alineó el 9 de noviembre de 2026 con los borradores de backend 020 y 021; si al vendorizar cambia un nombre o un tipo, se corrige aquí antes de implementar.

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/solicitudes` | Enviar la solicitud | `{ oficioClave, descripcion (8–500), fotos[] (1–5 `archivoId` privados sin repetir), dia (AAAA-MM-DD, hoy a hoy + 5 en America/Mexico_City), franja (manana\|tarde\|noche), coloniaId, direccion? (8–200, solo domicilio) }` | `201` con la solicitud | `400` formato (incluye `direccion_no_aplica`), `401`, `422` (`oficio_no_valido`, `colonia_no_encontrada`, `contenido_rechazado`), `429` con `Retry-After` (`limite_moderacion`: «Llegaste al límite de publicaciones de hoy. Intenta mañana.»), `503 moderacion_no_disponible` |
| `GET /api/v1/solicitudes/{id}` | Detalle y estado | — | `200` con `{ id, estado, modalidad, oficio{clave, nombre}, colonia{id, nombre, cp}, descripcion, fotos[], dia, franja, direccion?, venceEn, creadoEn }` | `400` id mal formado, `401`, `404` (también si es de otra persona), `429` |
| `GET /api/v1/solicitudes/{id}/cotizaciones` | Comparar | `orden?` = `recomendadas` (omisión)\|`precio`\|`calificacion`\|`pronto` | `200` con `{ solicitudId, cotizaciones[] (≤ 5), totalCotizaciones, tiposMixtos, puedeElegir, motivo?, visitaId? }`; cada cotización: `{ id, estado, tipoPrecio (fijo\|rango\|visita), precio, precioMin?, precioMax?, tope, requiereAprobacion, dia, hora, nota?, cubre, etiquetas[], tecnico{id, nombre, fotoUrl, calificacion, verificado, nivelVerificacion} }` | `400`, `401`, `404` ajena o inexistente, `429` |
| `POST /api/v1/solicitudes/{id}/elegir` | Elegir | `{ cotizacionId }` | `200` con `{ visitaId, solicitudId, cotizacionId, estado, modalidad, dia, hora, precio, tope, tecnico{id, nombre, fotoUrl, verificado, nivelVerificacion, telefono?, whatsapp?}, lugar{tipo, direccion} }` | `400`, `401`, `404` (solicitud o cotización ajena), `409` (`solicitud_ya_elegida`, `cotizacion_no_disponible`, `solicitud_vencida`, `solicitud_cancelada`, `solicitud_sin_cotizaciones`), `429`, `500` |
| `POST /api/v1/imagenes/subidas` (backend 032) | Pedir el enlace de subida de cada foto | `{ proposito: "solicitud", tipoContenido (image/jpeg\|image/png), tamanoBytes (1 a 5 242 880) }` | `201` con `{ id, urlSubida, metodo: "PUT", encabezados, venceEn, confirmarAntesDe }` | `400` con `errors`, `401`, `429` con `Retry-After`, `503 almacenamiento_no_disponible` |
| `PUT {urlSubida}` | Subir los bytes directo al almacenamiento | Bytes con los `encabezados` recibidos | `201` del almacenamiento | `403` enlace vencido |
| `POST /api/v1/imagenes/subidas/{id}/confirmar` (backend 032) | Confirmar y obtener la dirección pública | sin cuerpo | `200` con `{ url, ancho, alto, bytes }` (idempotente) | `404 subida_no_encontrada`, `409` (`subida_vencida`, `archivo_no_subido`), `422` (`imagen_demasiado_grande`, `formato_no_admitido`, `imagen_invalida`, `imagen_rechazada`), `429`, `503` (`moderacion_no_disponible`, `almacenamiento_no_disponible`) |

Reglas del contrato que la app da por ciertas:
- **Autorización por recurso:** un `404` es la respuesta para una solicitud o una cotización de otra persona; la app lo trata como «ya no está disponible» y no lo distingue de inexistente.
- **Idempotencia:** la app no envía clave de idempotencia (retirada por ahora). Si una elección agota el tiempo, el reintento puede recibir `409 solicitud_ya_elegida`: la app consulta `GET /solicitudes/{id}` y, si la cita ya existe, la muestra como éxito.
- **Paginación:** las cotizaciones no paginan (tope de 5 y `totalCotizaciones`); el listado `GET /solicitudes` con cursor lo consume la spec 020.
- **Límites del servidor:** 5 fotos, 500 caracteres de descripción, 200 de dirección, 10 elecciones por minuto por persona, más el límite global y el de usuario del gateway; la app obedece `Retry-After`.
- **Caché:** todas estas respuestas llegan con `Cache-Control: private, no-store` y la app no las guarda (R-11).
- **Errores:** ProblemDetails con `code`, `correlationId` y `traceId`; la app decide por `code`, nunca por el texto, y no muestra `correlationId` salvo en «Detalles para soporte».
- **Privacidad:** el listado de cotizaciones no trae contacto ni dirección; solo la respuesta de `elegir` y la visita (backend 022) los traen. No hay distancia en kilómetros (backend 021, decisión 2).
- **Vencimiento:** la solicitud vence a las 48 h (`venceEn`); el estado `vencida` o el `motivo = solicitud_vencida` ocultan «Elegir».
- **Fotos:** backend 020 guarda `archivoId` privados (R-04 de esa spec) y devuelve enlaces de lectura firmados de 5 minutos; la app solo pinta direcciones `https` de los dominios permitidos que devuelve el servidor y no las guarda en disco (CA-21).
- **Eventos:** la app no consume eventos en este sprint; los avisos push de «nueva cotización» llegan por la infraestructura de la spec 012 y su contenido lo fija la spec 024.

## 5. Modelo de datos

**Entidades de dominio** (`app/lib/features/actividad/domain/`, Dart puro, sin Flutter ni HTTP)

| Entidad | Campos | Reglas |
|---|---|---|
| `Solicitud` | `id`, `estado` (`enviada`, `cotizando`, `citaConfirmada`, `terminada`, `calificada`, `cancelada`, `vencida`, mapeados desde `enviada`, `cotizando`, `cita_confirmada`, `terminada`, `calificada`, `cancelada`, `vencida`), `modalidad`, `oficio` (`clave`, `nombre`), `colonia` (`id`, `nombre`, `cp`), `descripcion`, `fotos`, `dia`, `franja`, `direccion?`, `venceEn`, `creadoEn` | Inmutable; el estado solo lo cambia el servidor; un estado desconocido se muestra como «En proceso» y se registra sin datos personales |
| `Cotizacion` | `id`, `estado`, `tipoPrecio` (`fijo`, `rango`, `visita`), `precio`, `precioMin?`, `precioMax?`, `tope`, `requiereAprobacion`, `dia`, `hora`, `nota?`, `cubre`, `etiquetas` (`verificado`, `mejorPrecio`, `puedeIrMasPronto`), `tecnico` (`TecnicoResumen`: `id`, `nombre`, `fotoUrl`, `calificacion`, `verificado`, `nivelVerificacion`) | Sin contacto ni dirección; una etiqueta desconocida se ignora |
| `ResultadoComparacion` | `cotizaciones`, `totalCotizaciones`, `tiposMixtos`, `puedeElegir`, `motivo?` (`sinCotizaciones`, `solicitudVencida`, `solicitudCancelada`, `yaElegida`), `visitaId?` | El orden es el del servidor |
| `CitaConfirmada` | `visitaId`, `solicitudId`, `cotizacionId`, `estado`, `modalidad`, `dia`, `hora`, `precio`, `tope`, `tecnico` (con `telefono?` y `whatsapp?`), `lugar` (`tipo`, `direccion`) | Solo existe después de elegir; vive en memoria y no se persiste (R-18) |
| `Franja` | `manana`, `tarde`, `noche` | Valor de contrato en minúsculas |
| `Modalidad` | `domicilio`, `taller` | Se **reutiliza** `app/lib/features/oficios/domain/modalidad.dart`; no se crea otra |
| `BorradorSolicitud` | `oficioClave`, `descripcion`, `rutasDeFotos[]`, `dia`, `franja`, `actualizadoEn` | Vive solo en el teléfono y se borra al enviar, descartar o cerrar sesión; **no** guarda la dirección del domicilio |

**Estado de pantalla** (un `sealed class` por pantalla, spec 001): `Cargando`, `ConDatos`, `Vacio`, `ConError(Failure)` y `SinConexion`; el formulario agrega `Enviando` y `Validando`.

**Estado local**
- Borrador guardado con clave `knock.borrador.solicitud` a través de `app/lib/core/preferencias/almacen_borrador_solicitud.dart`, que es el único archivo que importa `shared_preferences` (regla vigente de `core/preferencias/` y `core/cache/`); el repositorio de la función solo lo inyecta. Nunca guarda tokens ni datos de otra cuenta.
- Fotos del borrador copiadas al directorio privado de la app (`path_provider`), con nombre aleatorio; se borran al enviar, al descartar el borrador y al cerrar sesión.
- El borrador, las fotos y su clave quedan fuera de la copia de seguridad del sistema (`android:allowBackup="false"` o reglas de extracción que excluyan `knock.*` y el directorio de fotos), comprobado con una prueba del manifiesto.
- **Sin caché** de solicitudes ni de cotizaciones (R-11). La lista de oficios sí se cachea con la infraestructura de la spec 010.
- Última solicitud vista: solo su `id` y `estado`, para que la pestaña Actividad tenga a qué volver (D-03).

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Fuga de información:** ver solicitudes, cotizaciones o datos de contacto de otra persona | El servidor decide por recurso y responde 404; la app no guarda en caché ni en borrador datos de otra cuenta y los limpia al cerrar sesión | CA-13, CA-10 |
| **Fuga de información:** teléfono o dirección visibles antes de elegir | La app solo pinta los campos de contacto que llegan en la respuesta de `elegir`; antes de elegir el modelo ni siquiera los tiene | CA-10, CA-11 |
| **Fuga de información:** datos personales en registros, reportes de errores o notificaciones | Nada de `print`/`debugPrint` con texto, fotos, teléfono o dirección (prueba global de la spec 009, `seguridad_cliente_test.dart`); los errores se mapean a `Failure` y a un texto del catálogo; los avisos push llevan tipo y destino, no contenido (spec 012, R-03) | CA-19, CA-12, CA-15 |
| **Alteración:** doble solicitud o doble cita por reintento o doble toque | Botón deshabilitado mientras hay una operación en curso y consulta del estado tras un `409 solicitud_ya_elegida` | CA-06, CA-20 |
| **Alteración:** el cliente elige dos cotizaciones a la vez | La decisión es del servidor (409); la app refresca y muestra el estado real, sin reintentar la elección | CA-12 |
| **Denegación:** subir archivos enormes o muchos de golpe | Máximo 5 fotos, 5 MB por foto (validados antes de decodificar), límite de píxeles, reducción a 1600 px antes de subir y una subida a la vez | CA-03, CA-18 |
| **Denegación:** martillear la API tras un 429 | `ClienteConEspera` de la spec 009 obedece `Retry-After` y la pantalla no reintenta sola | CA-15 |
| **Suplantación:** usar el flujo sin sesión válida | El router exige sesión (spec 001) y el cliente pone el token; un 401 renueva una sola vez y, si falla, cierra la sesión (spec 002) | CA-13 (401 en §8, escenario «error esperado») |
| **Elevación de privilegios:** un técnico opera como cliente o al revés | La app no cambia roles; las rutas de cliente no dependen de `esTecnico` y el servidor autoriza | CA-13 |
| **Repudio:** «yo no pedí esto» | El servidor audita la creación y la elección; la app muestra el identificador y la fecha de la solicitud en el detalle | CA-01, CA-11 |
| **Datos sensibles en el teléfono:** fotos de la casa de la persona | Copia privada de la app, sin galería, sin EXIF, fuera de la copia de seguridad y borrada al enviar, al descartar o al cerrar sesión; se muestran solo desde dominios permitidos de Knock y sin caché en disco | CA-18, CA-19, CA-21 |
| **Abuso:** enviar muchas solicitudes o elecciones seguidas | Botón deshabilitado durante la operación, una clave por operación, sin reintento automático y respeto de `Retry-After` (10 elecciones por minuto en el servidor) | CA-06, CA-15, CA-20 |
| **Inyección de contenido:** una dirección de foto de otro dominio en la respuesta | El mapeador descarta direcciones que no son `https` de los dominios permitidos | CA-21 |
| **Dependencias:** plugin de cámara o de imágenes vulnerable o con licencia no permitida | Se evalúa licencia, mantenimiento y avisos (OSV) antes de agregarlo y se registra en `Memoria.md` (D-10) | (comando) `flutter pub outdated` + revisión en el PR |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos nuevos (ARB `solicitud*`, `cotizacion*`) |
|---|---|---|---|
| Actividad (`/actividad`, se modifica) | vacío, carga, con datos, error, sin conexión | Si hay solicitud reciente: tarjeta con oficio, estado y «Ver cotizaciones». Si no: ilustración y «Pide tu primera cotización» | `actividadVacioTitulo`, `actividadVacioDetalle`, `actividadPedirCotizacion`, `actividadUltimaSolicitud` |
| Pedir cotización, paso 1 (`/actividad/solicitud/nueva`) | carga de oficios, error, sin conexión | Lista de oficios con su modalidad; tres frases sugeridas por oficio piloto | `solicitudTitulo`, `solicitudPaso1`, `solicitudEligeOficio`, `solicitudFraseMecanica1..3`, `solicitudFrasePlomeria1..3`, `solicitudFraseElectricidad1..3` |
| Paso 2 «Qué pasa» | vacío, error de validación, con fotos | Campo de texto con contador `n/500`, botón «Agregar foto», miniaturas con «Quitar», aviso de la foto obligatoria | `solicitudPaso2`, `solicitudDescripcionAyuda`, `solicitudDescripcionCorta`, `solicitudDescripcionLarga`, `solicitudFotoFalta`, `solicitudFotoMaximo`, `solicitudFotoQuitar`, `solicitudFotoEtiqueta` |
| Paso 3 «Cuándo y dónde» | vacío, error de validación | Seis días en chips, tres franjas, modalidad del oficio, dirección si es a domicilio, botón «Enviar» | `solicitudPaso3`, `solicitudDia`, `solicitudFranjaManana`, `solicitudFranjaTarde`, `solicitudFranjaNoche`, `solicitudDomicilio`, `solicitudTaller`, `solicitudTallerAviso`, `solicitudDireccion`, `solicitudDireccionAyuda`, `solicitudEnviar`, `solicitudEnviando` |
| Detalle (`/actividad/solicitud/:id`) | carga, con datos, vacío de cotizaciones, error, sin conexión, vencida | Estado, resumen, fotos, «Ver y elegir» con el número de cotizaciones, aviso de vencimiento | `solicitudDetalleTitulo`, `solicitudEstadoEnviada`, `solicitudEstadoCotizando`, `solicitudEstadoCita`, `solicitudEstadoVencida`, `solicitudVerCotizaciones`, `solicitudSinCotizaciones`, `solicitudVencidaAviso`, `solicitudNoDisponible` |
| Comparar (`/actividad/solicitud/:id/cotizaciones`) | carga, con datos, vacío, error, sin conexión | Chips de orden, «Te mostramos 5 de N», aviso de tipos mixtos, tarjetas, motivo cuando no se puede elegir, hoja de confirmación | `cotizacionTitulo`, `cotizacionOrdenRecomendadas`, `cotizacionOrdenPrecio`, `cotizacionOrdenCalificacion`, `cotizacionOrdenPronto`, `cotizacionMostrandoDe`, `cotizacionTiposMixtos`, `cotizacionPrecioFijo`, `cotizacionPrecioRango`, `cotizacionPrecioVisita`, `cotizacionTope`, `cotizacionRequiereAprobacion`, `cotizacionEtiquetaVerificado`, `cotizacionEtiquetaMejorPrecio`, `cotizacionEtiquetaPronto`, `cotizacionElegir`, `cotizacionConfirmarTitulo`, `cotizacionConfirmarAvisoContacto`, `cotizacionConfirmar`, `cotizacionYaElegida`, `cotizacionRetirada`, `cotizacionSinConexion`, `cotizacionVerMiVisita`, `cotizacionSinTelefono`, `cotizacionMotivoSinCotizaciones`, `cotizacionMotivoVencida`, `cotizacionMotivoCancelada` |
| Común | — | Errores del catálogo y botón de reintentar | Reutiliza `errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos` de la spec 002; agrega `solicitudErrorVencida` y `solicitudErrorLimite` |

**Mensajes exactos por código de error** (español; el inglés va en `app_en.arb` con el mismo sentido)

| `code` o situación | Texto en pantalla | Acción ofrecida |
|---|---|---|
| `contenido_rechazado` (422) | «Tu descripción no se pudo publicar. Revísala y quita datos personales o palabras ofensivas.» | Volver al paso 2 |
| `moderacion_no_disponible` (503) | «No pudimos revisar tu descripción en este momento. Intenta de nuevo en unos minutos.» | Reintentar |
| `oficio_no_valido` o `colonia_no_encontrada` (422) | «Ese oficio o esa colonia ya no están disponibles. Elige otra opción.» | Volver al paso 1 o a «Tu zona» |
| `solicitud_ya_elegida` (409) | «Ya elegiste una cotización para esta solicitud.» | Ver mi visita |
| `cotizacion_no_disponible` (409) | «Esta cotización ya no está disponible. Elige otra.» | Refrescar |
| `solicitud_vencida` (409) o `motivo = solicitud_vencida` | «Esta solicitud venció. Puedes pedir una nueva.» | Pedir cotización |
| `solicitud_cancelada` (409) o `motivo = solicitud_cancelada` | «Esta solicitud se canceló.» | Volver a Actividad |
| `solicitud_sin_cotizaciones` (409) o `motivo = sin_cotizaciones` | «Todavía no hay cotizaciones. Te avisaremos cuando llegue la primera.» | — |
| 404 | «Esta solicitud ya no está disponible.» | Volver a Actividad |
| `imagen_demasiado_grande`, `formato_no_admitido` o `imagen_invalida` (422) | «Esa foto es muy pesada o no es JPG ni PNG. Elige otra.» | Elegir otra foto |
| `imagen_rechazada` (422) | «Esa foto no se pudo usar. Elige otra.» | Quitar la miniatura |
| `subida_vencida` o `archivo_no_subido` (409), o `403` del almacenamiento | «No se pudo subir la foto. Intenta de nuevo.» | Reintentar esa foto con un enlace nuevo |
| 429 | «Hiciste muchos intentos. Espera {segundos} segundos.» | Botón activo al terminar la espera |
| Sin conexión | «Sin conexión. Guardamos tu borrador.» | Reintentar |
| 5xx o `code` desconocido | «Algo salió mal de nuestro lado. Intenta de nuevo.» | Reintentar |

Reglas de pantalla:
- El paso 1 se salta cuando la persona llega desde un oficio concreto (parámetro `oficioClave`), como pide HU-024 CA5.
- El formulario conserva los pasos anteriores al retroceder y restaura el borrador al reabrir.
- El botón «Enviar» se deshabilita mientras hay una operación en curso y muestra un indicador de avance.
- La hoja de confirmación dice, antes del botón: «Al elegir, verás el teléfono del técnico y él verá la dirección de tu servicio. Las demás cotizaciones se cerrarán.»
- La tarjeta muestra el máximo como «Hasta $1,100» y, si `requiereAprobacion` es verdadero, «Si el precio sube, el técnico te pedirá tu aprobación»; los montos usan el formato de pesos mexicanos del sistema.
- Accesibilidad: contraste según la spec 014 (reservada); etiquetas semánticas en miniaturas («Foto 1 de 3»), en los chips («Mañana, seleccionado») y en el indicador de avance; nada depende solo del color.

## 8. Pruebas, gates y límites

**Plan de pruebas** (Sí/No con motivo; meta de mutación del módulo: 70 % en `domain/`)

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Validaciones, mapeo del contrato, máquina de estados del controlador, borrador |
| Widget (W) | Sí | Tres pasos, errores en línea, estados vacío/carga/error/sin conexión, comparación y confirmación |
| Aceptación (ACC) | Sí | CA-01 a CA-23 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` y `flutter test test/api/cliente_generado_test.dart` (spec 006) |
| Integración (INT) | Sí | Recorrido completo con API simulada en `integration_test/` y humo contra el entorno desplegado |
| Seguridad negativa (NEG) | Sí | 404 ajeno, 409 de doble elección, 401 con renovación, 429, datos sensibles en registros |
| Accesibilidad (A11Y) | Sí | `expectAccesible` de la spec 008, lector de pantalla y texto al 200 % |
| Mutación (MUT) | Sí | Reglas de `domain/` con `mutation_test`, meta 70 % |
| E2E | Sí | Un recorrido: oficio → fotos → día → enviar → comparar → elegir → visita |
| Regresión | Sí | `flutter test` completo; no se rompen Inicio, Explorar, Oficios, Entrada ni Cuenta |
| Análisis estático y vulnerabilidades | Sí | `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed`, Semgrep y CodeQL del CI, `flutter pub outdated` y OSV para las dependencias nuevas |
| Rendimiento (PERF) | No | Volumen bajo del piloto; la reducción de fotos se mide en la prueba unitaria, no con k6 |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Los tres pasos completos crean una solicitud y llevan al detalle |
| Positivo | Llegan cotizaciones y la comparación muestra 5 tarjetas con el orden pedido |
| Positivo | Elegir revela el contacto y abre la visita |
| Negativo | Sin fotos, con 7 caracteres, con día fuera de rango, sin franja o con dirección de 7 u 201 caracteres no se avanza |
| Negativo | Un técnico suspendido o una cotización retirada no aparecen o desaparecen al refrescar |
| Error esperado | 401 → renueva una vez; si falla, cierra sesión y pide entrar (CA de la spec 002) |
| Error esperado | 409 al elegir → mensaje, refresco y sin cita duplicada |
| Error esperado | 413 por foto grande → mensaje que pide otra foto, sin perder lo escrito |
| Error esperado | 429 → espera el `Retry-After` y lo dice |
| Error esperado | 5xx o tiempo agotado → estado de error con reintentar |
| Caso límite | Exactamente 1 y exactamente 5 fotos; 8 y 500 caracteres; hoy y hoy + 5 |
| Caso límite | Foto de exactamente 5 242 880 bytes y de 5 242 881 bytes; imagen de 4000 px con EXIF de ubicación |
| Caso límite | 0 cotizaciones, 1 cotización, 5 cotizaciones y `totalCotizaciones` = 7 |
| Caso límite | Mezcla de precio fijo, rango y solo visita (`tiposMixtos`) y técnico sin teléfono público |
| Error esperado | 422 `contenido_rechazado` y 503 `moderacion_no_disponible` → mensaje exacto y borrador intacto |
| Error esperado | `409 solicitud_ya_elegida` tras un reintento de la elección → se consulta la solicitud y se muestra la cita |
| Caso límite | Cotización que se retira entre la lista y la confirmación |
| Caso límite | Solicitud que vence mientras la pantalla está abierta |
| Caso límite | Sin señal a media captura y al confirmar la elección |

**Gates:** `flutter analyze --fatal-infos`, `dart format`, `flutter test` con cobertura ≥ 50 % (spec 008), revisión de la constitución, revisión de seguridad y PR con CI en verde (spec 007).
**Límites y dudas abiertas:** ver §13.

## 9. Arquitectura y componentes

Se respeta la arquitectura de la spec 001: `domain` en Dart puro, `presentation` sin `data/`, un archivo `<funcion>_providers.dart` como raíz de composición y el cliente generado como única puerta a la API (spec 006).

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/actividad/domain/solicitud.dart` | Crear | Entidad `Solicitud` y `EstadoSolicitud` |
| `app/lib/features/actividad/domain/cotizacion.dart` | Crear | `Cotizacion`, `TecnicoResumen`, `TipoPrecio`, `Cita` |
| `app/lib/features/actividad/domain/franja.dart` | Crear | `Franja` con su nombre de contrato |
| `app/lib/features/actividad/domain/validacion_solicitud.dart` | Crear | Reglas puras de R-02 a R-05 y mensajes por código de error |
| `app/lib/features/actividad/domain/borrador_solicitud.dart` | Crear | Entidad del borrador y su vigencia |
| `app/lib/features/actividad/domain/solicitud_repository.dart` | Crear | Interfaz: `crear`, `obtener`, `listar`, `cotizaciones`, `elegir`, `subirFoto` |
| `app/lib/features/actividad/data/solicitud_mapper.dart` | Crear | Contrato → dominio, con validación de campos |
| `app/lib/features/actividad/data/solicitud_repository_api.dart` | Crear | Implementación sobre el cliente generado y el transporte de la app |
| `app/lib/features/actividad/data/borrador_repository.dart` | Crear | Borrador y fotos en el directorio privado; delega la persistencia en `core/preferencias/` |
| `app/lib/core/preferencias/almacen_borrador_solicitud.dart` | Crear | Único archivo de la app que importa `shared_preferences` para el borrador (`knock.borrador.solicitud`) |
| `app/lib/features/actividad/data/foto_preparada.dart` | Crear | Validación de tipo y tamaño, límite de píxeles, reducción a 1600 px y borrado de EXIF |
| `app/lib/features/actividad/actividad_providers.dart` | Crear | Raíz de composición de la función |
| `app/lib/features/actividad/presentation/actividad_screen.dart` | Modificar | Estado vacío y tarjeta de la última solicitud |
| `app/lib/features/actividad/presentation/solicitud_nueva_screen.dart` | Crear | Contenedor de los tres pasos |
| `app/lib/features/actividad/presentation/pasos/paso_oficio.dart` | Crear | Paso 1 (reutiliza el catálogo de oficios con caché) |
| `app/lib/features/actividad/presentation/pasos/paso_descripcion_fotos.dart` | Crear | Paso 2 |
| `app/lib/features/actividad/presentation/pasos/paso_cuando_donde.dart` | Crear | Paso 3 |
| `app/lib/features/actividad/presentation/solicitud_controller.dart` | Crear | Estado de los pasos, envío y errores |
| `app/lib/features/actividad/presentation/solicitud_detalle_screen.dart` | Crear | Detalle y estados |
| `app/lib/features/actividad/presentation/cotizaciones_screen.dart` | Crear | Comparación |
| `app/lib/features/actividad/presentation/cotizaciones_controller.dart` | Crear | Orden, filtro, elección y errores |
| `app/lib/features/actividad/presentation/widgets/tarjeta_cotizacion.dart` | Crear | Tarjeta de la maqueta |
| `app/lib/features/actividad/presentation/widgets/hoja_confirmar_eleccion.dart` | Crear | Confirmación y revelación |
| `app/lib/features/actividad/presentation/widgets/selector_fotos.dart` | Crear | Agregar, quitar y validar fotos |
| `app/lib/core/router/rutas.dart` | Modificar | Cuatro constantes nuevas y su rama |
| `app/lib/core/router/app_router.dart` | Modificar | Rutas dentro de la rama Actividad |
| `app/lib/core/errores/failure.dart` | Modificar | `SolicitudVencidaFailure`, `CotizacionRetiradaFailure` y `NoEncontradoFailure` (404, compartido con 016 y 018) |
| `app/lib/core/red/errores_api.dart` | Modificar | Mapear 404 a `NoEncontradoFailure` en lugar del mensaje de «sin conexión» |
| `app/lib/core/errores/mensaje_failure.dart` | Modificar | Traducción de los tres errores nuevos |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 en ambos idiomas |
| `app/pubspec.yaml` | Modificar | Dependencias nuevas evaluadas (D-10) |

**No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/` y las specs aprobadas.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| Backend 032 CDN de imágenes (otro repositorio, Sprint 5 propuesto) | Enlace de subida, confirmación y dirección pública de cada foto | Sin fotos no se puede enviar la solicitud (ver §13) |
| Backend 020 y 021 (otro repositorio) | Rutas, esquemas, códigos y reglas de reparto y revelación | Sin contrato vendorizado no se implementa la capa `data` |
| 006 Contrato y cliente generado | Cliente Dart y verificación en CI | No hay forma permitida de llamar a la API |
| 002 Piezas comunes | Sesión, renovación, `Failure` y mensajes | Sin token ni manejo de errores común |
| 010 Caché y sin conexión | Caché de catálogos y política de borradores | Se duplicaría la caché y se guardarían datos que no deben guardarse |
| 012 Notificaciones y permisos | Aviso previo y reglas de permisos; apertura del detalle desde un aviso | No se puede llegar desde la notificación; el permiso de cámara **no** se pide (R-03) |
| 008 Calidad y pruebas | Reglas del analizador, accesibilidad y cobertura | Los gates no existirían |
| 009 Seguridad del cliente | Espera por 429, almacenamiento seguro y reglas de privacidad | Se incumpliría el manejo de límites y de datos |
| 014 Alinear la UI con la maqueta (reservada) | Tokens, tipografía y contraste | La comparación visual queda pendiente |
| 016 Visita con código | Pantalla a la que se llega después de elegir | La elección termina en un detalle sin visita |
| 017 Zona | Colonia de la solicitud | Sin colonia no se puede enviar a domicilio |
| 020 Mi actividad | Lista completa de solicitudes | Actividad solo muestra la última solicitud |
| 024 Notificaciones de la cadena | Contenido y destino del aviso «nueva cotización» | El aviso no abre el detalle correcto |

## 11. Definición de terminado

- CA-01 a CA-23 con prueba que falla si la lógica está mal; `python scripts/sdd_lint.py --trace 015` sin `FALTA`.
- `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 %.
- Los ARB de español e inglés completos y la prueba de traducciones en verde; ningún texto escrito en la pantalla.
- El contrato vendorizado incluye las rutas de §4 y el cliente generado compila; el manifiesto del cliente coincide (spec 006).
- Recorrido real contra el entorno desplegado: crear, comparar y elegir, con capturas en el PR tomadas con datos de prueba; **nunca** con el teléfono o la dirección de una persona real.
- Pruebas de accesibilidad y de seguridad negativa en verde.
- `Memoria.md` con las decisiones, las dependencias nuevas y lo que quedó pendiente.
- PR con la plantilla completa, la etiqueta `puntos-app-N` y CI en verde.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | La función vive en `features/actividad/` (domain, data y presentation), no en una función nueva `solicitudes` | La constitución §4 nombra cinco funciones y la pestaña Actividad es donde la persona ve sus solicitudes | Crear `features/solicitudes/`, que rompe la lista de funciones y la barra inferior |
| D-02 | La app no envía `Idempotency-Key` en `POST /solicitudes` ni en `POST /elegir` (retirada por ahora, decisión del 2026-11-10) | Backend 020 y 021 la quitaron de sus requisitos | Enviarla de todos modos, que el servidor no lee |
| D-03 | En esta spec Actividad muestra solo la última solicitud guardada en el teléfono (`id` y `estado`); el listado completo con `GET /solicitudes` (que backend 020 ya publica) lo construye la spec 020 de frontend | Mantiene la ola A pequeña y la lista paginada tiene su propia spec | Construir la lista aquí, que duplica la spec 020 |
| D-04 | No se cachean solicitudes ni cotizaciones | Spec 010, R-04: lo personal que cambia al crear algo no se guarda en caché | Cachear con ETag, que mostraría cotizaciones viejas como vigentes |
| D-05 | Las fotos del borrador se copian al directorio privado de la app y se borran al enviar o cerrar sesión | R-07 lo pide y la galería del teléfono no debe recibir copias | Guardar solo la ruta temporal del selector, que el sistema puede borrar |
| D-06 | La dirección se captura en el paso 3 y solo viaja en la solicitud; no se guarda en el perfil **ni en el borrador** | No existe todavía el endpoint de dirección del perfil (HU-010) y el borrador se guarda en claro | Guardarla en `shared_preferences`, que la dejaría en claro y sin dueño |
| D-07 | El botón «Preguntar» se oculta hasta que exista mensajería | Backend 026 está en el Sprint 5 y un botón que no hace nada confunde | Abrir WhatsApp antes de elegir, que revela el número y contradice la regla de privacidad |
| D-08 | La confirmación de la elección es una hoja modal, no una ruta | Son dos decisiones sobre la misma pantalla y una ruta extra complica el regreso | Ruta `/elegir/:cotizacionId` |
| D-09 | Se agregan tres `Failure` (`SolicitudVencidaFailure`, `CotizacionRetiradaFailure` y `NoEncontradoFailure`) | La persona necesita un mensaje distinto para «venció», «ya la eligieron» y «ya no está disponible»; hoy un 404 cae en el mensaje de «sin conexión» | Un solo `ConflictoFailure` con un mensaje genérico |
| D-10 | Se proponen `image_picker`, `image` y `path_provider` como dependencias nuevas; se evalúan (licencia, mantenimiento, OSV) y se registran en `Memoria.md` antes de agregarlas | Hacen falta cámara, galería, reducción a 1600 px, borrado de EXIF y el directorio privado de fotos | Escribir el manejo de imágenes a mano, que duplica trabajo y riesgo |
| D-11 | El borrador se persiste desde `core/preferencias/almacen_borrador_solicitud.dart` y la función solo lo inyecta | La regla vigente solo permite `shared_preferences` en `core/preferencias/` y `core/cache/`; la spec 012 ya lo resolvió así | Dejar `shared_preferences` dentro de `features/actividad/data/`, que rompe la prueba de arquitectura |
| D-13 | Se quita el filtro «Solo verificados» | Backend 021 no recibe ese parámetro y R-08 prohíbe filtrar en el teléfono; la etiqueta `verificado` y el orden `recomendadas` ya ponen primero a los verificados | Filtrar las 5 tarjetas en el teléfono o pedir el parámetro a backend |
| D-14 | No se muestra la distancia | Backend 021 no devuelve `distanciaKm` para no guardar la ubicación del cliente | Calcularla con la colonia, que engaña |
| D-15 | Los mensajes de error se eligen por `code` y viven en la tabla de §7 | Un mismo HTTP 409 tiene cinco causas con acciones distintas | Un mensaje genérico por código HTTP |
| D-16 | La respuesta de `elegir` no se guarda en disco; el contacto y el lugar se vuelven a pedir con `GET /visitas/{id}` | Evita dejar teléfono y dirección en el teléfono; la copia sin conexión es solo la de la spec 016 | Guardar la cita completa para verla sin conexión |
| D-12 | No se declara el permiso `CAMERA` ni permisos de almacenamiento | La cámara y el selector del sistema se abren por intención y no necesitan permiso propio; el manifiesto solo declara ubicación aproximada e Internet (spec 009) | Pedir `CAMERA`, que obliga a explicarlo y amplía la superficie de permisos |

## 13. Riesgos y dudas abiertas

- **Bloqueante:** las rutas de §4 no están en `contracts/openapi.v1.json`; hasta que backend 020 y 021 las publiquen y se vendorice, la capa `data` no se puede implementar ni probar contra el contrato.
- **Riesgo:** si el backend cambia `franja`, `modalidad` o los nombres de los campos, hay que corregir el mapeo y esta spec antes de implementar.
- **Riesgo:** la confirmación de backend 032 puede rechazar una foto por moderación (`422 imagen_rechazada`) después de subirla; la app quita esa miniatura, muestra «Esa foto no se pudo usar. Elige otra.» y conserva las demás.
- **Resuelto en la revisión:** backend 020 ya publica `GET /solicitudes` con cursor; la lista completa vive en la spec 020 de frontend (D-03).
- **Riesgo:** la reducción a 1600 px y el borrado de EXIF cambian la calidad de la evidencia para el técnico; se valida con fotos de prueba antes de cerrar.
- **Duda abierta (para José):** ¿la dirección a domicilio se pide en este sprint o se espera a HU-010? Esta spec la pide por solicitud (D-06).
- **Duda abierta (para el equipo):** ¿la lista de frases sugeridas por oficio se queda en los ARB o la sirve el catálogo de oficios? Esta spec las deja en los ARB para los tres oficios piloto.
- **Duda abierta (para quien mantiene la spec 009):** `android:allowBackup` sigue sin decidirse. Esta spec exige excluir el borrador, las fotos y `knock.*` de la copia de seguridad (R-16); la decisión y el cambio del manifiesto deben quedar en una sola spec.
- **Resuelto en la revisión cruzada (decisión de revisión, confirmar):** las fotos de una solicitud son privadas (backend 020 R-04, `archivoId`; backend 032 ya no las publica). La app envía `archivoId` y pinta solo los enlaces firmados que devuelve el servidor (CA-21).
- **Conflicto de calendario:** la subida de fotos la define backend 032 («CDN de imágenes con caché y enlaces firmados»), propuesta para el Sprint 5, mientras esta spec es de la ola A del Sprint 4. Sin backend 032 no hay fotos y HU-024 exige al menos una. Hay que adelantar al Sprint 4 al menos los dos endpoints de subida de backend 032 o aceptar fotos de semilla en la demo.
- **Pendiente de validar:** backend 020 no publica el catálogo de oficios con su `modalidad` en esta spec; la app usa el catálogo ya desplegado (spec 002) y se confirma al vendorizar.
- **`Idempotency-Key` retirada por ahora (decisión del 2026-11-10).** La spec 010 §5 ya decía que la app no la usa en esta etapa y backend 020 y 021 la quitaron. Sin ella, un doble toque o un reintento de red puede crear dos solicitudes (el botón deshabilitado y el límite de 10 por hora del servidor lo acotan); en la elección, el reintento recibe 409 `solicitud_ya_elegida` y la app consulta la solicitud. HU-024 CA4 y HU-033 CA3 la exigían como criterio de aceptación: una persona debe decidir si se relajan esas historias.

## Aprobación

- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
