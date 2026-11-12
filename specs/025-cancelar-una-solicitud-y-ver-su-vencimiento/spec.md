# Spec 025 — Cancelar una solicitud y ver su vencimiento (app)

> **Jira:** KNOCK-70 (HU-027 «Cancelar una solicitud») y KNOCK-71 (HU-028 «Vencer las solicitudes a las 48 h»), capa Mobile · **Épica:** EP-04 Solicitudes · **Módulo:** requests · **Responsable:** Erick Trejo Reséndiz (propuesto) · **Sprint:** S5 (propuesto; ambas claves tienen etiqueta `sprint-5`) · **Puntos:** 2 (la parte Mobile de las dos historias) · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend (spec 029 «Cancelar y vencer solicitudes», en Borrador; spec 020 «Solicitudes y cotizaciones» y 021 «Comparar y elegir cotización»)
> **Fuentes:** backlog `HU-027.md` y `HU-028.md` · `docs/descripcion-del-proyecto.md` §3 (estados de la solicitud: «vence a las 48 horas, y el cliente puede cancelarla antes») · maqueta `js/knock.js` (`A.cancelJob`: hoja de confirmación «Sí, cancelar» / «No, mantener»)
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`, `reuse-before-create`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye la cancelación ni `puedeVolverAPedir`; los fija backend 029 (§5) y se vendorizan antes de implementar (spec 006).
> **Estado:** Borrador

## 1. Objetivo

Que el cliente pueda cancelar una solicitud que ya no necesita mientras no haya elegido una cotización, con una confirmación clara y sin doble envío, y que vea en todo momento cuándo vence su solicitud y qué pasa cuando venció: el estado «Vencida», el motivo y la acción «Volver a pedir», que abre una solicitud nueva prellenada. Esta spec amplía el detalle de la solicitud de la spec 015 y cubre la capa **Mobile**; el cambio de estado, el vencimiento automático, la tarea programada y los avisos son del backend (spec 029).

## 2. Historia y casos de prueba

**KNOCK-70 (HU-027)** — Como cliente, quiero cancelar una solicitud que ya no necesito, para no hacer perder tiempo a los técnicos.
**KNOCK-71 (HU-028)** — Como cliente, quiero que mis solicitudes sin elegir se cierren solas a las 48 h, para que solo sigan abiertas las necesidades vigentes.

- **CA-01:** Dada una solicitud propia en `enviada` o `cotizando`, cuando el cliente abre su detalle, entonces ve «Cancelar solicitud» como acción secundaria; en `cita_confirmada`, `terminada`, `calificada`, `cancelada` o `vencida` el botón no aparece. · Verificación: `app/test/features/actividad/presentation/cancelar_solicitud_test.dart` → `CA_025_01`
- **CA-02:** Dado «Cancelar solicitud» tocado, cuando se abre la hoja de confirmación, entonces dice «¿Cancelar tu solicitud?», explica «Los técnicos que cotizaron recibirán un aviso y ya no podrás elegir una cotización.» ofrece un motivo **opcional** con cuatro chips («Ya no lo necesito», «Lo resolví por otro medio», «Tarda mucho», «Otro motivo»; ninguno seleccionado al abrir) y los botones «No, mantener» y «Sí, cancelar»; «No, mantener» cierra sin llamar al servidor y «Sí, cancelar» funciona con o sin motivo. · Verificación: `app/test/features/actividad/presentation/cancelar_solicitud_test.dart` → `CA_025_02`
- **CA-03:** Dada la confirmación, cuando el servidor responde 200 `{ id, estado, canceladaEn, motivo }`, entonces la app vuelve a pedir el detalle, que pasa a «Cancelada», muestra «Cancelaste esta solicitud.» y «Volver a pedir», se oculta «Ver y elegir» y Actividad muestra la tarjeta con el estado nuevo al volver. · Verificación: `app/test/features/actividad/presentation/cancelar_solicitud_test.dart` → `CA_025_03`
- **CA-04:** Dado un doble toque en «Sí, cancelar» o un reintento de la red tras un tiempo agotado, cuando se envía, entonces el botón queda deshabilitado con indicador de avance y una respuesta `200` repetida (también si la solicitud ya estaba cancelada desde otro dispositivo) se trata como éxito. · Verificación: `app/test/features/actividad/data/cancelar_solicitud_repository_test.dart` → `CA_025_04`
- **CA-05:** Dada una solicitud que ya tiene cita confirmada (el cliente eligió en otro dispositivo), cuando se confirma la cancelación, entonces el servidor responde 409 `request_with_appointment` y la app muestra «Ya elegiste una cotización: esta solicitud ya no se puede cancelar. Revisa tu visita.» con «Ver visita», y recarga el detalle. · Verificación: `app/test/features/actividad/presentation/cancelar_solicitud_test.dart` → `CA_025_05`
- **CA-06:** Dada una solicitud que venció mientras la hoja estaba abierta, cuando se confirma, entonces el servidor responde 409 `request_expired` y la app muestra el estado «Vencida» con «Volver a pedir» y el mensaje «Tu solicitud ya había vencido.». · Verificación: `app/test/features/actividad/presentation/cancelar_solicitud_test.dart` → `CA_025_06`
- **CA-07:** Dada la solicitud de otra persona o inexistente, cuando la app intenta cancelarla, entonces recibe 404 y muestra «Esta solicitud ya no está disponible» sin revelar que existe. · Verificación: `app/test/features/actividad/data/cancelar_solicitud_repository_test.dart` → `CA_025_07`
- **CA-08:** Dado un 429 con `Retry-After` (por ejemplo, la cancelación número 11 en una hora), un 400 (`errors.motivo` o id mal formado), un 5xx o sin conexión, cuando se confirma la cancelación, entonces la solicitud **no** cambia en pantalla, se muestra el error del catálogo con «Reintentar» (o la espera del 429, spec 009) y no se reintenta en bucle ni se encola para después. · Verificación: `app/test/features/actividad/presentation/cancelar_solicitud_estados_test.dart` → `CA_025_08`
- **CA-09:** Dada una solicitud en `enviada` o `cotizando` con `venceEn` a más de 24 h, cuando se abre el detalle, entonces se muestra «Vence el {día} a las {hora}» en la zona `America/Mexico_City` y en formato de 24 h; a 24 h o menos, «Vence en {n} h»; a menos de 1 h, «Vence en menos de una hora». · Verificación: `app/test/features/actividad/domain/vencimiento_test.dart` → `CA_025_09`
- **CA-10:** Dado que la hora del teléfono ya pasó `venceEn` pero el servidor todavía responde `enviada` o `cotizando`, cuando se pinta el detalle, entonces la app muestra «Cerrando tu solicitud…», no la marca como vencida por su cuenta y vuelve a pedir el detalle una sola vez a los 60 s; si sigue igual, deja el texto y el refresco manual (el barrido de respaldo de backend 029 corre cada 10 minutos). · Verificación: `app/test/features/actividad/domain/vencimiento_test.dart` → `CA_025_10`
- **CA-11:** Dada una solicitud `vencida`, cuando se abre su detalle (desde Actividad o desde el aviso `request_expired` de la spec 024), entonces muestra la etiqueta «Vencida» (con ícono y texto, no solo color), «Pasaron 48 horas sin que eligieras una cotización.», las cotizaciones que hubo sin el botón de elegir y, si el servidor responde `puedeVolverAPedir: true` (backend 029, R-13), la acción principal «Volver a pedir»; con `puedeVolverAPedir` falso o ausente, la acción no aparece. · Verificación: `app/test/features/actividad/presentation/solicitud_vencida_test.dart` → `CA_025_11`
- **CA-12:** Dado «Volver a pedir» en una solicitud vencida o cancelada, cuando se toca, entonces abre `/actividad/solicitud/nueva` con el oficio, la descripción y la franja de la anterior ya llenos, el día vacío (se elige de hoy a hoy + 5) y la dirección vacía si es a domicilio; nada se envía hasta tocar «Enviar». · Verificación: `app/test/features/actividad/presentation/volver_a_pedir_test.dart` → `CA_025_12`
- **CA-13:** Dado «Volver a pedir», cuando se prellena el formulario, entonces las fotos de la solicitud anterior se ofrecen como «Usar las mismas fotos» (activado) solo si las referencias que devuelve el detalle son aceptadas por `POST /api/v1/solicitudes` (backend 020, R-04); si la creación responde 400 por las fotos, o si el detalle no trae referencias reutilizables, el paso 2 pide agregarlas de nuevo con el mensaje de la spec 015. · Verificación: `app/test/features/actividad/presentation/volver_a_pedir_test.dart` → `CA_025_13`
- **CA-14:** Dada una solicitud vencida o cancelada en la comparación de cotizaciones (`/actividad/solicitud/:id/cotizaciones`), cuando el servidor responde `puedeElegir = false` con `motivo` `request_expired` o `request_cancelled` (backend 021, R-08), entonces se muestra la franja «Esta solicitud venció» o «Cancelaste esta solicitud» con «Volver a pedir» y ninguna tarjeta tiene «Elegir». · Verificación: `app/test/features/actividad/presentation/cotizaciones_estados_test.dart` → `CA_025_14`
- **CA-15:** Dado un técnico con sesión, cuando una solicitud que tenía en «Solicitudes nuevas» o con una cotización enviada se cancela o vence, entonces al refrescar Trabajo (o al recibir el aviso de la spec 024) la solicitud sale de «Solicitudes nuevas» (su envío quedó `cerrado`, backend 029 R-03) y su cotización, que el servidor deja `rechazada` con `motivoRechazo` `request_cancelled` o `request_expired`, muestra «Cancelada por el cliente» o «Vencida», sin datos del cliente. · Verificación: `app/test/features/trabajo/presentation/trabajo_estados_solicitud_test.dart` → `CA_025_15`
- **CA-16:** Dados el detalle, la hoja de confirmación y el estado vencido, cuando se recorren con lector de pantalla y texto al 200 % en 320 × 640, entonces cada control mide al menos 48 dp, tiene etiqueta, «Sí, cancelar» se anuncia como acción destructiva, el vencimiento se lee completo («Vence en 5 horas») y nada se corta. · Verificación: `app/test/features/actividad/presentation/accesibilidad_cancelar_test.dart` → `CA_025_16`
- **CA-17:** Dado el registro de la app, cuando se cancela, vence o se vuelve a pedir una solicitud, entonces ningún `print`, registro ni reporte de errores contiene la descripción, la dirección, las fotos, el motivo de cancelación ni el identificador de la solicitud (prueba global de la spec 009). · Verificación: `app/test/seguridad/seguridad_cliente_test.dart` → `CA_025_17`

## 3. Alcance / No-alcance

**Dentro (capa Mobile)**
- Botón «Cancelar solicitud», hoja de confirmación, envío con el botón deshabilitado y manejo de errores en el detalle (`/actividad/solicitud/:id`).
- Vencimiento visible en el detalle y su regla de presentación (absoluto, relativo, «Cerrando tu solicitud…»).
- Estados «Cancelada» y «Vencida» en el detalle y en la comparación, con «Volver a pedir».
- «Volver a pedir»: abrir el formulario de la spec 015 prellenado.
- Etiquetas «Cancelada por el cliente» y «Vencida» en Trabajo del técnico (spec 019), solo de presentación.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.

**Fuera**
- Cambiar el estado, vencer a las 48 h, la tarea programada, la concurrencia de dos copias, los avisos a técnicos y al cliente: backend 029.
- La notificación de cancelación o vencimiento: spec 024.
- Cancelar una cita confirmada, reprogramar, «no se presentó» y cancelación tardía: HU-034 y HU-041 (otras specs).
- Cancelar sin conexión con cola de envío: no se encola (D-04).
- La tarjeta de Actividad y su acción principal: spec 020 (aquí solo se fija el texto «Volver a pedir», D-06).
- Ampliar la solicitud a más técnicos (HU-025, backend 028).

### Requisitos

- **R-01:** «Cancelar solicitud» aparece solo en `enviada` y `cotizando`, como acción secundaria (no es el botón principal) y siempre pide confirmación en una hoja inferior.
- **R-02:** La cancelación llama a `POST /api/v1/solicitudes/{id}/cancelar` (backend 029) sin `Idempotency-Key` (retirada por ahora) y con el cuerpo `{ motivo }` solo si la persona eligió uno.
- **R-03:** La app muestra el estado nuevo solo con la respuesta del servidor; sin respuesta exitosa, la solicitud no cambia en pantalla.
- **R-04:** Los errores se traducen con el catálogo: `409 request_with_appointment`, `409 request_expired`, `404`, `400`, `429`, `5xx` y sin conexión, con los textos de §7; nunca el código HTTP, la URL ni el cuerpo.
- **R-05:** El vencimiento se calcula para mostrar a partir de `venceEn` del servidor (UTC) y se presenta en `America/Mexico_City`; la app nunca decide que una solicitud venció.
- **R-06:** Si la hora local ya pasó `venceEn` y el servidor aún no la vence, la app muestra «Cerrando tu solicitud…» y vuelve a pedir el detalle una sola vez a los 60 s; si sigue igual, deja el texto y el refresco manual (el barrido de respaldo de backend 029 corre cada 10 minutos).
- **R-07:** «Vencida» y «Cancelada» muestran su motivo y, si `puedeVolverAPedir` es verdadero, la acción principal «Volver a pedir»; las cotizaciones se ven sin la acción de elegir.
- **R-08:** «Volver a pedir» abre el formulario de la spec 015 con oficio, descripción y franja; día y dirección se vuelven a capturar; las fotos se reutilizan solo si la creación las acepta (backend 020, R-04).
- **R-09:** En Trabajo, una solicitud cancelada o vencida sale de «Solicitudes nuevas» y su cotización enviada muestra el estado correspondiente, sin revelar datos del cliente.
- **R-10:** Nada de lo anterior se guarda en caché de respuestas ni en disco, salvo el borrador de «Volver a pedir», que usa las reglas del borrador de la spec 015 (sin dirección).
- **R-11:** Todos los textos viven en los ARB de español e inglés y los colores y tipografías en el tema (spec 014).
- **R-12:** Cada control mide al menos 48 dp, tiene etiqueta semántica, cumple el contraste y funciona con texto al 200 %.

## 4. Contrato API y eventos

La app **consume**. La ruta de cancelación y el campo `puedeVolverAPedir` los fija backend 029 (§5); el resto ya está en backend 020, 021 y 028.

| Método y ruta | Uso en la app | Cuerpo / encabezados | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/solicitudes/{id}/cancelar` | Cancelar (backend 029, R-02 a R-07) | `{ motivo? }` con `motivo` en `no_longer_needed`, `solved_elsewhere`, `takes_too_long` u `otro` (se omite si la persona no eligió) | `200` `{ id, estado: "cancelada", canceladaEn, motivo }`; si ya estaba cancelada, el mismo cuerpo · `Cache-Control: no-store` | `400` (`errors.motivo` o id mal formado) · `401` · `404` (ajena o inexistente) · `409 request_with_appointment` (cita confirmada, terminada o calificada) · `409 request_expired` · `429` con `Retry-After` (10 cancelaciones por hora por persona) · `5xx` |
| `GET /api/v1/solicitudes/{id}` | Detalle con `estado`, `venceEn`, `puedeVolverAPedir` y la descripción, fotos, oficio, colonia, franja y dirección también en una solicitud cerrada (backend 020 R-08 y 029 R-13) | — | `200` | `400`, `401`, `404`, `429` |
| `GET /api/v1/solicitudes/{id}/cotizaciones` | Comparación de una solicitud vencida o cancelada (backend 021) | `orden?` | `200` con `puedeElegir = false` y `motivo` (`request_expired`, `request_cancelled`) | `401`, `404`, `429` |
| `GET /api/v1/solicitudes` | Actividad (backend 020; spec 020); admite `estado=vencida` y `estado=cancelada` (029 R-13) | `cursor?`, `limit?` (la app pide 20), `estado?` | `200` `CursorPage<SolicitudResumen>` con `estado` y `venceEn` | `400`, `401`, `429` |
| `POST /api/v1/solicitudes` | Volver a pedir: solicitud **nueva** (backend 020; formulario de la spec 015); el servidor no copia ni reabre la anterior (029 R-13) | El de la spec 015 | `201` | Los de la spec 015 |
| `GET /api/v1/tecnicos/me/solicitudes` | Solicitudes nuevas del técnico (backend 028, R-13): una cancelada o vencida ya no aparece | `cursor?`, `limit?` (1–20) | `200` `CursorPage<SolicitudRecibida>` | `401`, `403 not_a_technician`, `429` |
| `GET /api/v1/tecnicos/me/trabajo` | Cotizaciones enviadas del técnico (spec 019) — spec de backend 036 (Borrador) | — | Debe incluir el estado y `motivoRechazo` de cada cotización | Los de la spec 019 |

Reglas del contrato que la app da por ciertas:
- **Estados de la solicitud** (backend 020 y 029 R-01): `enviada`, `cotizando`, `cita_confirmada`, `terminada`, `calificada`, `cancelada`, `vencida`. Se cancela solo desde `enviada` o `cotizando`; `cancelada` y `vencida` son finales.
- **Cotizaciones de una solicitud cerrada:** pasan a `rechazada` con `motivoRechazo` `request_cancelled` o `request_expired` (backend 029, decisión 1); no existe un estado `vencida` de cotización.
- **Vencimiento:** `venceEn = creadoEn + Solicitudes:HorasVencimiento` (48 h por omisión, de 1 a 168; backend 029 R-08); lo aplica la tarea `VencerSolicitud` y, si se pierde, el barrido cada 10 minutos (R-10). Mientras tanto `venceEn` ya bloquea cotizar y elegir (R-12). La app no calcula el plazo: solo muestra `venceEn`, y el texto «48 horas» del estado vencido es el valor por omisión (§13).
- **Idempotencia:** cancelar es idempotente (backend 029, R-04): una solicitud ya cancelada responde 200 con el mismo cuerpo y no hay un segundo aviso.
- **Autorización por recurso:** 404 para lo ajeno o inexistente.
- **Sin caché:** `Cache-Control: private, no-store` (backend 020, R-18); la app no guarda estas respuestas (spec 010, R-04).
- **Paginación:** la de Actividad y Trabajo es por cursor (specs 019 y 020); cancelar no cambia la página pedida, solo invalida la lista.
- **Eventos:** la app no escucha eventos de dominio; se entera del cambio por el aviso de la spec 024 (`request_cancelled` para técnicos, `request_expired` para el cliente) o al refrescar.

## 5. Modelo de datos

**Entidades de dominio** (`app/lib/features/actividad/domain/`, Dart puro)

| Entidad | Campos | Reglas |
|---|---|---|
| `Solicitud` (spec 015, se amplía) | + `canceladaEn?`, `vencidaEn?`, `puedeVolverAPedir` | `estado` incluye `cancelada` y `vencida`; ya existía `venceEn` |
| `Vencimiento` | `venceEn`, `ahora` | Devuelve `PresentacionVencimiento`: `absoluto(dia, hora)`, `relativo(horas)`, `menosDeUnaHora`, `cerrando` |
| `ReglaCancelacion` | `estado` | `puedeCancelar` es verdadero solo en `enviada` y `cotizando` |
| `ResultadoCancelacion` | `cancelada(canceladaEn)`, `conCita`, `yaVencida`, `noDisponible`, `invalida`, `limite(espera)`, `error`, `sinConexion` | Uno por respuesta de §4 |
| `MotivoCancelacion` (enum) | `yaNoLoNecesito`, `loResolviPorOtroMedio`, `tardaMucho`, `otro` | Nombres de contrato de backend 029 (R-02); opcional |
| `PrellenadoSolicitud` | `oficioId`, `descripcion`, `franja`, `fotos?` | Sin día ni dirección; se entrega al formulario de la spec 015 |

**Estado local**
- «Volver a pedir» crea un borrador con las reglas de la spec 015 (R-07 y D-06: sin dirección, se borra al enviar o al cerrar sesión).
- Nada de esta spec se guarda en `shared_preferences`, caché de respuestas ni archivos.

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Acceso a lo ajeno (IDOR):** cancelar la solicitud de otra persona cambiando el `id` | El servidor autoriza por dueño y responde 404; la app no revela si existe | CA-07 |
| **Alteración:** cancelar algo que ya tiene cita o que venció (carrera entre dispositivos) | El servidor decide con 409; la app no cambia el estado sin respuesta exitosa y recarga | CA-05, CA-06 |
| **Repetición:** doble toque o reintento crean dos operaciones | Botón deshabilitado durante el envío; la cancelación ya es idempotente por estado en el servidor | CA-04 |
| **Error humano:** cancelar sin querer | Acción secundaria, hoja con confirmación y explicación, «No, mantener» primero en el orden de lectura | CA-02 |
| **Manipulación del reloj del teléfono:** adelantar la hora para ver la solicitud vencida | La app nunca vence por su cuenta; solo muestra «Cerrando tu solicitud…» y pregunta al servidor una vez | CA-10 |
| **Abuso:** cancelar y volver a pedir en ráfaga para molestar a los técnicos | Límite de 10 cancelaciones por hora del servidor (backend 029, R-14); la app respeta el 429 | CA-08 |
| **Denegación / abuso:** reintentos en bucle tras un 429 o una caída | Espera por `Retry-After` (spec 009), un solo reintento automático a los 60 s en el caso de R-06 y ninguno en la cancelación | CA-08, CA-10 |
| **Fuga de información:** datos del cliente al técnico al cancelar o vencer | Trabajo solo muestra el estado; la vista del técnico no incluye dirección ni datos de contacto (backend 020, R-06 y R-08) | CA-15 |
| **Fuga de información:** descripción, dirección o identificadores en registros | Sin `print`; prueba global de la spec 009; la dirección no viaja al borrador | CA-17, CA-12 |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido nuevo | Textos nuevos (ARB `solicitud*`) |
|---|---|---|---|
| Detalle (`/actividad/solicitud/:id`, spec 015, se modifica) | cargando, con datos (`enviada`, `cotizando`, `cancelada`, `vencida`, cerrando), error, sin conexión, no disponible (404) | Línea de vencimiento; «Cancelar solicitud» como botón de texto con ícono; estados «Cancelada» y «Vencida» con su motivo y «Volver a pedir» | `solicitudVenceEl`, `solicitudVenceEnHoras`, `solicitudVenceMenosHora`, `solicitudCerrando`, `solicitudCancelar`, `solicitudEstadoCancelada`, `solicitudCanceladaDetalle`, `solicitudEstadoVencida`, `solicitudVencidaDetalle`, `solicitudVolverAPedir` |
| Hoja «¿Cancelar tu solicitud?» (sobre el detalle) | lista, enviando, error, sin conexión | Título, explicación, motivo opcional en chips, «No, mantener» (primero) y «Sí, cancelar» (estilo de peligro) | `solicitudCancelarTitulo`, `solicitudCancelarDetalle`, `solicitudCancelarMotivo`, `solicitudMotivoYaNo`, `solicitudMotivoResolvi`, `solicitudMotivoTarda`, `solicitudMotivoOtro`, `solicitudCancelarConfirmar`, `solicitudCancelarMantener` |
| Comparar (`/actividad/solicitud/:id/cotizaciones`, spec 015) | con datos sin elección | Franja de motivo con «Volver a pedir»; tarjetas sin «Elegir» | `cotizacionSolicitudVencida`, `cotizacionSolicitudCancelada` |
| Pedir cotización (`/actividad/solicitud/nueva`, spec 015) | prellenado | Oficio, descripción y franja llenos; aviso «Revisa el día y la dirección»; interruptor «Usar las mismas fotos» si aplica | `solicitudPrellenadaAviso`, `solicitudUsarMismasFotos` |
| Trabajo (`/trabajo`, spec 019) | con datos | Estado de la cotización enviada | `trabajoEstadoCanceladaCliente` (y `trabajoEstadoVencida`, que ya propone la spec 019) |

**Textos exactos (español)**

| Clave | Texto |
|---|---|
| `solicitudVenceEl` | Vence el {dia} a las {hora} |
| `solicitudVenceEnHoras` | Vence en {horas, plural, =1{1 hora} other{{horas} horas}} |
| `solicitudVenceMenosHora` | Vence en menos de una hora |
| `solicitudCerrando` | Cerrando tu solicitud… |
| `solicitudCancelar` | Cancelar solicitud |
| `solicitudCancelarTitulo` | ¿Cancelar tu solicitud? |
| `solicitudCancelarDetalle` | Los técnicos que cotizaron recibirán un aviso y ya no podrás elegir una cotización. |
| `solicitudCancelarMotivo` | ¿Por qué cancelas? (opcional) |
| `solicitudMotivoYaNo` | Ya no lo necesito |
| `solicitudMotivoResolvi` | Lo resolví por otro medio |
| `solicitudMotivoTarda` | Tarda mucho |
| `solicitudMotivoOtro` | Otro motivo |
| `solicitudCancelarConfirmar` | Sí, cancelar |
| `solicitudCancelarMantener` | No, mantener |
| `solicitudEstadoCancelada` | Cancelada |
| `solicitudCanceladaDetalle` | Cancelaste esta solicitud. |
| `solicitudEstadoVencida` | Vencida |
| `solicitudVencidaDetalle` | Pasaron 48 horas sin que eligieras una cotización. |
| `solicitudVolverAPedir` | Volver a pedir |
| `solicitudErrorConCita` | Ya elegiste una cotización: esta solicitud ya no se puede cancelar. Revisa tu visita. |
| `solicitudErrorYaVencida` | Tu solicitud ya había vencido. |
| `solicitudVerVisita` | Ver visita |
| `cotizacionSolicitudVencida` | Esta solicitud venció |
| `cotizacionSolicitudCancelada` | Cancelaste esta solicitud |
| `solicitudPrellenadaAviso` | Usamos los datos de tu solicitud anterior. Revisa el día y la dirección. |
| `solicitudUsarMismasFotos` | Usar las mismas fotos |
| `trabajoEstadoCanceladaCliente` | Cancelada por el cliente |

Errores comunes: se reutilizan `errorSinConexion`, `errorServicio`, `errorDemasiadosIntentos` (spec 002) y «Esta solicitud ya no está disponible» (spec 015).

**Reglas de pantalla**
- El vencimiento se muestra debajo del estado, con ícono de reloj; a 6 h o menos usa el color de advertencia del tema **y** el texto relativo (no depende solo del color).
- «Cancelar solicitud» es un botón de texto al final del detalle, separado de «Ver y elegir», para que no se toque por error.
- En la hoja, el foco inicial del lector de pantalla va al título; «Sí, cancelar» lleva la indicación semántica de acción destructiva.
- «Vencida» y «Cancelada» usan etiqueta con ícono y texto; contraste 4.5:1 en claro y oscuro (spec 014).
- Sin conexión, «Sí, cancelar» se deshabilita y la hoja muestra `errorSinConexion`; no se encola (D-04).

## 8. Pruebas, gates y límites

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | `ReglaCancelacion`, `Vencimiento` (límites de 1 h, 24 h y vencido), mapeo de errores a `ResultadoCancelacion`, `PrellenadoSolicitud` |
| Widget (W) | Sí | Detalle por estado, hoja de confirmación, franja de la comparación, formulario prellenado, etiqueta de Trabajo |
| Aceptación (ACC) | Sí | CA-01 a CA-17 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` con la ruta de backend 029 vendorizada (spec 006) |
| Integración (INT) | Sí | `integration_test/cancelar_y_vencer_test.dart` con API simulada: cancelar, 409 por cita, 409 por vencida, vencida desde el aviso |
| Seguridad negativa (NEG) | Sí | 404 ajeno, reloj adelantado, doble toque, 429 sin bucle, registros sin datos |
| Accesibilidad (A11Y) | Sí | `expectAccesible`, texto al 200 % en 320 × 640, contraste |
| Mutación (MUT) | Sí | `vencimiento.dart` y `regla_cancelacion.dart` con meta 70 % |
| E2E | Sí | Pedir → cancelar → ver «Cancelada» → «Volver a pedir»; y solicitud de semilla vencida → «Volver a pedir» (emulador, datos ficticios) |
| Regresión | Sí | Suite completa; las pruebas de la spec 015 (detalle y comparación) siguen en verde |
| CI/CD | Sí | `ci-pr.yml`: `flutter analyze --fatal-infos --fatal-warnings`, `dart format --set-exit-if-changed`, `flutter test` con cobertura ≥ 50 % y el `gate` |
| Análisis estático y vulnerabilidades | Sí | `flutter analyze`, Semgrep, Gitleaks, OSV; sin dependencias nuevas |
| Rendimiento (PERF) | No | Volumen bajo del piloto |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Solicitud `cotizando` con 2 cotizaciones: cancelar → «Cancelada» y los técnicos reciben aviso (backend) |
| Positivo | Solicitud creada hace 47 h: «Vence en 1 hora» |
| Positivo | Solicitud vencida desde el aviso: «Vencida», cotizaciones visibles sin elegir, «Volver a pedir» prellena oficio, descripción y franja |
| Negativo | Cancelar con cita confirmada: 409 y «Ya elegiste una cotización…» con «Ver visita» |
| Negativo | Cancelar la solicitud de otra cuenta: 404 y «Esta solicitud ya no está disponible» |
| Negativo | Reloj del teléfono 3 días adelantado: «Cerrando tu solicitud…», un solo reintento, nunca «Vencida» sin el servidor |
| Error esperado | 429 con `Retry-After: 30`: aviso de espera y «Sí, cancelar» deshabilitado 30 s |
| Error esperado | 5xx o tiempo agotado: error con «Reintentar» que repite la cancelación |
| Error esperado | Sin conexión: «Sí, cancelar» deshabilitado; nada se encola |
| Error esperado | 11.ª cancelación en una hora: 429 con `Retry-After` y aviso de espera |
| Negativo | Motivo fuera de la lista (cliente alterado): 400 `errors.motivo`, mensaje genérico y la solicitud no cambia |
| Caso límite | `venceEn` a exactamente 24 h: «Vence en 24 horas»; a 24 h + 1 min: absoluto |
| Caso límite | `venceEn` a 59 min: «Vence en menos de una hora»; a 0 s: «Cerrando tu solicitud…» |
| Caso límite | Cancelar dos veces la misma solicitud (dos dispositivos): la segunda recibe 200 repetido o el estado `cancelada`; ninguna muestra error |
| Caso límite | Solicitud vencida mientras la hoja está abierta: 409 `request_expired` y estado «Vencida» |
| Caso límite | Cambio de horario o zona del teléfono: el vencimiento se sigue mostrando en `America/Mexico_City` |

**Gates:** los de la spec 015 (§8) y `AGENTS.md` (Definición de terminado).
**Límites y dudas abiertas:** ver §13.

## 9. Arquitectura y componentes

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/actividad/domain/solicitud.dart` | Modificar | `canceladaEn`, `vencidaEn`; estados `cancelada` y `vencida` si faltan |
| `app/lib/features/actividad/domain/vencimiento.dart` | Crear | `Vencimiento` y `PresentacionVencimiento` (Dart puro; recibe `ahora` para probar) |
| `app/lib/features/actividad/domain/regla_cancelacion.dart` | Crear | `puedeCancelar` por estado |
| `app/lib/features/actividad/domain/solicitud_repository.dart` | Modificar | `cancelar(id, motivo?)` → `ResultadoCancelacion` |
| `app/lib/features/actividad/data/solicitud_repository_api.dart` | Modificar | Llamada de backend 029 sobre el cliente generado; mapeo de 409 por `code` |
| `app/lib/features/actividad/data/solicitud_mapper.dart` | Modificar | Campos nuevos |
| `app/lib/features/actividad/presentation/solicitud_detalle_screen.dart` | Modificar | Vencimiento, botón, estados nuevos |
| `app/lib/features/actividad/presentation/widgets/hoja_cancelar_solicitud.dart` | Crear | Hoja de confirmación (componente de hoja de la spec 014 si existe) |
| `app/lib/features/actividad/presentation/cancelar_solicitud_controller.dart` | Crear | Envío, errores y refresco |
| `app/lib/features/actividad/presentation/cotizaciones_screen.dart` | Modificar | Franja de motivo y «Volver a pedir» |
| `app/lib/features/actividad/presentation/solicitud_nueva_screen.dart` | Modificar | Acepta `PrellenadoSolicitud` |
| `app/lib/features/trabajo/presentation/` (spec 019) | Modificar | Etiqueta «Cancelada por el cliente» |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 |

**No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/`.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| Backend 029 (Borrador) | Ruta de cancelación, `request_with_appointment`, vencimiento con tarea y barrido, `canceladaEn`, `puedeVolverAPedir`, cierre de cotizaciones y envíos | **Bloqueante** para CA-03 a CA-08, CA-11 y CA-15; el dominio y la presentación del vencimiento sí se pueden hacer |
| Backend 028 (Borrador) | `GET /tecnicos/me/solicitudes` y envíos cerrados | Sin CA-15 en «Solicitudes nuevas» |
| Backend 020 | `venceEn`, estados, detalle y listado | Sin vencimiento visible |
| Backend 021 | `puedeElegir` y `motivo` | Sin franja en la comparación (CA-14) |
| 015 Pedir y comparar cotizaciones | Detalle, comparación, formulario, borrador y entidad `Solicitud` | Se duplicarían pantallas y modelos |
| 019 Pestaña Trabajo | Lista del técnico | Sin CA-15 |
| 020 Mi actividad | Tarjeta con acción principal por estado | La tarjeta usaría otro texto (D-06) |
| 024 Notificaciones | Aviso `request_expired` que abre el detalle y `request_cancelled` para técnicos | El cambio solo se ve al refrescar |
| 014 Alinear la UI (reservada) | Hoja inferior, botones de peligro y contraste | Estilos propios que se migran después |
| 002, 006, 009, 010 | Errores, cliente generado, espera por 429, política de caché | Manejo incompleto |

## 11. Definición de terminado

- CA-01 a CA-17 con prueba que falla si la lógica está mal; `python3 scripts/sdd_lint.py --trace 025` sin `FALTA`.
- `flutter analyze --fatal-infos --fatal-warnings`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 % y mutación ≥ 70 % en `vencimiento.dart` y `regla_cancelacion.dart`.
- ARB en español e inglés completos y prueba de traducciones en verde.
- El contrato vendorizado incluye la ruta de cancelación de backend 029 y el cliente generado compila.
- Recorrido real con datos de prueba (semillas de KNOCK-246), con capturas sin datos reales.
- `Memoria.md` al día; PR con la plantilla completa, etiqueta `puntos-app-N` y CI en verde; revisión de un par.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | El motivo es **opcional**, con los cuatro valores de backend 029 en chips y ninguno seleccionado al abrir | Backend 029 lo acepta opcional y cerrado a una lista (su decisión 4); obligarlo frena una acción que HU-027 pide simple | Motivo obligatorio como en la cancelación de una cita de la maqueta (HU-041) |
| D-02 | La hoja usa los textos de la maqueta («No, mantener» y «Sí, cancelar») y pone «No, mantener» primero | Reutiliza el patrón aprobado de la maqueta y reduce cancelaciones por error | Un diálogo del sistema con «Aceptar» y «Cancelar», ambiguo con la palabra «cancelar» |
| D-03 | La app nunca vence una solicitud por su cuenta: con la hora local pasada muestra «Cerrando tu solicitud…» y pregunta una vez a los 60 s | El vencimiento lo decide la tarea programada del servidor y el reloj del teléfono no es confiable | Mostrar «Vencida» con la hora local |
| D-04 | Sin conexión no se encola la cancelación | La cola de envío de la spec 010 no está implementada (Memoria 2026-11-05) y una cancelación diferida puede chocar con una elección | Encolar y enviar al volver la señal |
| D-05 | «Volver a pedir» prellena oficio, descripción y franja; día y dirección se capturan otra vez; las fotos solo si backend las deja reutilizar | El día anterior ya pasó y la dirección no se guarda en el borrador (spec 015, D-06) | Reenviar la misma solicitud con un toque, sin revisar |
| D-06 | El texto de la acción es «Volver a pedir» (HU-028) en lugar de «Pedir de nuevo» (spec 020) | Es el texto de la historia y del aviso de la spec 024 | Mantener dos textos para la misma acción |
| D-07 | El vencimiento se muestra en `America/Mexico_City` con formato de 24 h | Backend 020 fija esa zona para el día de la solicitud; la ciudad piloto está en México | Usar la zona del teléfono, que puede no coincidir con la del servicio |
| D-08 | Tras un 200 de la cancelación, la app vuelve a pedir el detalle en lugar de armarlo con la respuesta | Backend 029 responde solo `{ id, estado, canceladaEn, motivo }`; el detalle trae `puedeVolverAPedir` y las cotizaciones | Mezclar la respuesta con el detalle en memoria |
| D-09 | «Volver a pedir» se muestra solo con `puedeVolverAPedir: true` del servidor | Es el campo que backend 029 agrega para eso (R-13); la app no decide por estado | Mostrarlo en todo estado `cancelada` o `vencida` |

## 13. Riesgos y dudas abiertas
- **`Idempotency-Key` retirada por ahora (decisión del 2026-11-10).** La cancelación no la envía y backend 029 la quitó; cancelar ya es idempotente por estado. Un doble toque se evita con el botón deshabilitado.

- **Validado con backend 029 (Borrador):** ruta, cuerpo con motivo opcional, respuesta `200` con `{ id, estado, canceladaEn, motivo }`, `409 request_with_appointment` y `request_expired`, idempotencia por estado, límite de 10 por hora, `puedeVolverAPedir` y cotizaciones a `rechazada` con `motivoRechazo`.
- **Pendiente de validar:** si el detalle de una solicitud cerrada devuelve `vencidaEn` (029 lo guarda pero no lo lista en la respuesta) y si las referencias de fotos del detalle se pueden reenviar en `POST /solicitudes` (029 no lo dice; la spec 015 habla de URL firmadas de 5 minutos, que no servirían).
- **Dependencia:** `GET /api/v1/tecnicos/me/trabajo` (spec 019) lo fija la spec 036 (Borrador); sin ella, CA-15 solo se cumple en «Solicitudes nuevas».
- **Riesgo:** el texto «Pasaron 48 horas…» supone el plazo por omisión; si el servidor configura otro (`Solicitudes:HorasVencimiento`), el texto quedaría mal. Alternativa para quien apruebe: «Se cerró sin que eligieras una cotización.»
- **Conflicto detectado:** la spec 020 usa «Pedir de nuevo» y esta spec «Volver a pedir» (D-06); conviene unificar en la 020.
- **Resuelto con backend 029:** la cotización de una solicitud cerrada queda `rechazada` con `motivoRechazo`; la etiqueta «Vencida» de la spec 019 (`trabajoEstadoVencida`) debe leerse de ese motivo y no de un estado.
- **Riesgo:** si la tarea `VencerSolicitud` se pierde, el barrido de respaldo tarda hasta 10 minutos y el cliente verá «Cerrando tu solicitud…» ese tiempo; se mitiga con un solo reintento y el refresco manual.
- **Resuelto:** backend 029 avisa a los técnicos que cotizaron cuando la solicitud vence (`tecnicosAvisar` de `SolicitudVencida`); la spec 024 lo entrega como `cotizacion_vencida`.

## Aprobación

- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
