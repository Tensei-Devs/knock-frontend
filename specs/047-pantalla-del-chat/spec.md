# Spec 047 — Pantalla del chat (abrir, leer y enviar mensajes)

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Redacción:** 2026-11-27, **después** de que las rutas existen en el backend. En `sprint-05` la app tiene lista, globo y contador (spec 020) y no tiene conversación; las pantallas `ChatScreen` y `TecChatScreen` de la maqueta son simuladas.
> **Claves de trabajo:** KNOCK-72 (HU-029) · **Sprint:** 5 · **Prioridad:** por definir
> **Otra parte en:** knock-backend (specs 026, 030 y 031). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`

## 1. Objetivo
Que el cliente y un técnico que recibió su solicitud conversen dentro de Knock: abrir la conversación, leer sus mensajes, enviar texto y recibir los nuevos en vivo.

## 2. Historia y casos de prueba
**Historia:** Como cliente o técnico, quiero conversar dentro de Knock, para aclarar el trabajo sin dar mi número.

- **CA-01:** Dado el cliente en una cotización, o el técnico en una solicitud nueva, cuando toca «Preguntar» o «Chatear», entonces la app llama a `POST /api/v1/conversaciones` (el cliente con `solicitudId` y `tecnicoId`; el técnico solo con `solicitudId`), acepta `200` y `201` igual y abre la conversación; nunca llama a `GET /api/v1/solicitudes/{id}/conversacion`. · Verificación: pruebas unitarias del repositorio y de widget.
- **CA-02:** Dada la lista de conversaciones (spec 020), cuando toca una, entonces abre esa conversación. · Verificación: prueba de widget.
- **CA-03:** Dada una conversación, cuando se abre, entonces muestra la contraparte, el servicio, el `avisoSeguridad` del servidor siempre visible y los mensajes del más antiguo (arriba) al más reciente (abajo), distinguiendo los propios (`autorRol` igual a `rol`) sin depender solo del color. · Verificación: prueba de widget.
- **CA-04:** Dados más de 30 mensajes, cuando se llega arriba, entonces pide la página anterior con `nextCursor` y no duplica mensajes. · Verificación: prueba de widget con repositorio falso.
- **CA-05:** Dado un texto de 1 a 1 000 caracteres (sin contar espacios de los extremos), cuando se envía, entonces sale una sola petición, el botón queda deshabilitado mientras responde y con `201` el mensaje aparece y el campo se vacía. Vacío o con más de 1 000 no se puede enviar. · Verificación: pruebas unitarias y de widget.
- **CA-06:** Dados `422` (`errors.texto` o `content_rejected`), `429` (`message_limit` o `moderation_limit`), `503` (`moderation_unavailable` o `market_unavailable`) o una falla de red, cuando se envía, entonces se conserva lo escrito, se muestra el texto de §7 (con la espera de `Retry-After`) y no se reintenta sola. · Verificación: prueba de widget por código.
- **CA-07:** Dado un envío sin respuesta, cuando vuelve a haber respuesta del servidor, entonces la app relee la primera página antes de permitir reenviar, porque el envío no es idempotente. · Verificación: prueba unitaria del controlador.
- **CA-08:** Dada una respuesta o un evento con `contactoOculto` verdadero, cuando se pinta, entonces se muestra «El número se comparte al elegir una cotización; te sugerimos no compartirlo antes.». · Verificación: prueba de widget.
- **CA-09:** Dada una conversación cerrada (`estado` cerrada o `409 conversation_closed`), cuando se muestra, entonces se puede leer, no hay campo ni respuestas rápidas y se ve el texto de su `motivoCierre`. · Verificación: prueba de widget por motivo.
- **CA-10:** Dada una conversación visible con mensajes, cuando se abre o llega uno nuevo, entonces llama a `POST /api/v1/conversaciones/{id}/leido` con `hasta` igual al `enviadoEn` del último mostrado; el globo se actualiza con lo que diga el servidor; si la llamada falla, no se inventa el contador. Sin mensajes no se llama. · Verificación: prueba unitaria del controlador.
- **CA-11:** Dada la conversación abierta y el canal disponible, cuando entra al chat, entonces invoca `UnirseAConversacion`, agrega cada `mensajeConversacion` sin duplicar por `mensajeId` y al salir invoca `SalirDeConversacion`; al reconectar se une de nuevo y relee la primera página. · Verificación: prueba con canal simulado.
- **CA-12:** Dado el canal caído, cuando se está en el chat, entonces muestra «Sin conexión en vivo» con «Actualizar», que relee la primera página; enviar sigue disponible. · Verificación: prueba de widget.
- **CA-13:** Dado un `401`, cuando llega, entonces se aplica el manejo de sesión de la spec 002; dado un `404`, «Esta conversación ya no está disponible.», sin decir si existe. · Verificación: pruebas unitarias y de widget.
- **CA-14:** Dado `rol` cliente o técnico en una conversación abierta, cuando se muestra, entonces ofrece las respuestas rápidas de §7 de su rol y al tocar una se envía como un mensaje normal. · Verificación: prueba de widget por rol.
- **CA-15:** Dado el menú del chat, cuando se abre, entonces solo ofrece lo que se puede cumplir: «Ver su perfil» si la app conoce el `tecnicoId`, y «Reportar» y «Bloquear» (flujos de la spec 033) solo al cliente cuando hay `visitaId`. Si no hay ninguna, el menú no aparece. · Verificación: prueba de widget por caso.
- **CA-16:** Dados registros, reportes de errores, caché y disco, cuando se revisan, entonces no contienen textos de mensajes, nombres ni identificadores de conversación; al cerrar sesión no queda nada en memoria. · Verificación: prueba de seguridad del cliente.
- **CA-17:** Dados español e inglés, lector de pantalla y texto al 200 % en 320 × 640, cuando se usa el chat, entonces los textos salen del ARB, los controles miden al menos 48 dp, cada mensaje se lee con autor y hora y el globo no aparece encima. · Verificación: pruebas de widget y accesibilidad.

## 3. Alcance / No-alcance
**Dentro:** pantalla de conversación para los dos roles, sus entradas (lista, cotización, solicitud nueva), envío, historial, leído, tiempo real, respuestas rápidas y menú.

**Fuera:**
- Fotos y audios en el chat (backend 030 no los acepta).
- «En línea», «escribiendo…» y marcas de enviado y leído (el backend no los publica). La descripción del proyecto y la maqueta los muestran: quedan para otra spec.
- Cola de mensajes sin conexión y copia local.
- Notificaciones push (spec 012), avisos (spec 024), «Continuar por WhatsApp», resumen y borrador con IA (spec 042).
- El precio de la cotización en la cabecera (la respuesta de la conversación no lo trae).

## 4. Contrato API y eventos

| Método y ruta | Cuerpo / consulta | Respuesta | Errores que la app distingue |
|---|---|---|---|
| `POST /api/v1/conversaciones` | `{ solicitudId, tecnicoId? }` | `201` o `200` `Conversacion` | `400`, `401`, `404`, `409 conversation_closed`, `422`, `429`, `503` |
| `GET /api/v1/conversaciones/{id}` | — | `200` `{ conversacionId, solicitudId, visitaId?, rol, contraparte{nombre, fotoUrl}, servicio, estado, motivoCierre?, contactoVisible, avisoSeguridad, noLeidos }` | `400`, `401`, `404`, `429` |
| `GET /api/v1/conversaciones/{id}/mensajes` | `cursor?`, `limit?` (1–50; la app pide 30) | `200` `{ items[{ mensajeId, autorRol, texto, contactoOculto, enviadoEn }], nextCursor }`, del más reciente al más antiguo | `400`, `401`, `404`, `422`, `429` |
| `POST /api/v1/conversaciones/{id}/mensajes` | `{ texto }` | `201` mensaje | `400`, `401`, `404`, `409 conversation_closed`, `422`, `429`, `503` |
| `POST /api/v1/conversaciones/{id}/leido` | `{ hasta }` | `204` | `401`, `404`, `422`, `429` |
| Hub `/hubs/chat` | `UnirseAConversacion(id)`, `SalirDeConversacion(id)` | `{ ok }` o `{ ok: false, codigo }`; evento `mensajeConversacion` `{ conversacionId, mensajeId, autorRol, texto, contactoOculto, enviadoEn }` | `unauthorized` |

- Rutas, métodos y campos están en la rama `contract/api-89d9be3`; mientras no se vendorice se escriben a mano con las condiciones del ADR-007 (vence 2026-12-15).
- La moderación, el ocultamiento de contacto, los límites y quién participa los decide el servidor.

## 5. Modelo de datos local
Nada se guarda en el teléfono. Mensajes y borrador viven en memoria.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso |
|---|---|---|
| Leer una conversación ajena | `404` uniforme, sin revelar existencia | CA-13 |
| Texto de mensajes en disco o registros | Solo memoria | CA-16 |
| Mensajes duplicados por reintento | Un envío a la vez, sin reintento automático y relectura | CA-05 a CA-07 |
| Compartir el número antes de elegir o pagar por adelantado | Ocultamiento del servidor, aviso y `avisoSeguridad` | CA-03, CA-08 |
| Token en la URL del canal registrada | El canal sigue sin registro (spec 020) | CA-16 |

## 7. Pantallas, textos y accesibilidad
| Pantalla (ruta) | Estados |
|---|---|
| Conversación (`/conversaciones/:id`) | carga, con mensajes, sin mensajes, enviando, cerrada, sin conexión en vivo, error, no disponible |

| Situación | Español | Inglés |
|---|---|---|
| Sin mensajes | Escribe el primer mensaje. | Write the first message. |
| Campo | Escribe un mensaje | Write a message |
| Contacto oculto | El número se comparte al elegir una cotización; te sugerimos no compartirlo antes. | The number is shared once a quote is chosen; we suggest not sharing it before. |
| `content_rejected` | No pudimos enviar ese mensaje. Revisa lo que escribiste. | We couldn’t send that message. Check what you wrote. |
| `message_limit`, `moderation_limit` | Enviaste muchos mensajes. Espera {segundos} segundos. | You sent many messages. Wait {segundos} seconds. |
| `503` | No pudimos enviar el mensaje. Intenta de nuevo en un momento. | We couldn’t send the message. Try again shortly. |
| Cerrada `request_cancelled` | La solicitud se canceló; la conversación está cerrada. | The request was cancelled; this chat is closed. |
| Cerrada `request_expired` | La solicitud venció; la conversación está cerrada. | The request expired; this chat is closed. |
| Cerrada `other_quote_chosen` | Se eligió otra cotización; la conversación está cerrada. | Another quote was chosen; this chat is closed. |
| Cerrada `dismissed` | La solicitud se descartó; la conversación está cerrada. | The request was dismissed; this chat is closed. |
| Cerrada `service_finished` u otro | La conversación está cerrada. | This chat is closed. |
| `404` | Esta conversación ya no está disponible. | This chat is no longer available. |
| Canal caído | Sin conexión en vivo · Actualizar | No live connection · Refresh |

**Respuestas rápidas** (textos de la app)
- Técnico: «¿Me manda una foto?», «¿Cuál es su colonia?», «¿Qué día le acomoda?», «Llevo los materiales».
- Cliente sin `visitaId`: «¿Cuándo puede venir?», «¿Incluye materiales?», «¿Cuánto tarda?».
- Cliente con `visitaId`: «¿Ya viene en camino?», «¿Incluye materiales?», «Gracias».

El `avisoSeguridad` se muestra tal como llega (el servidor lo entrega en español).

## 8. Pruebas, gates y límites
Unitarias (mapeo, errores, controlador), widget (estados, roles, idiomas, accesibilidad), canal simulado, seguridad del cliente y recorrido manual con dos cuentas. Puertas: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace 047`, `codemap.py --check`.

## 9. Arquitectura y componentes
Se amplía `app/lib/features/mensajes/` (`domain/`, `data/`, `presentation/`) y el puerto `CanalMensajes`, reutilizando la única conexión del canal. La pantalla va en el diseño de la maqueta (spec 014), en un archivo nuevo, sin datos simulados en la vista real.

## 10. Dependencias con otras specs
Backend 026, 030 y 031; frontend 002, 006, 009, 015, 019, 020 y 033. Amplía la 020 (que deja fuera esta pantalla), agrega «Preguntar» en la comparación (015) y, para el chat, reemplaza la exclusión de la 019 (D-02) en «Solicitudes nuevas».

## 11. Definición de terminado
CA-01 a CA-17 con pruebas en verde, CI en verde, revisión de una persona, `Memoria.md` al día y recorrido real con dos cuentas contra el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Spec nueva y no enmienda de la 020: es una pantalla completa.
- **D-02:** Solo texto; sin presencia ni marcas de lectura, porque el servidor no las publica.
- **D-03:** El menú no ofrece lo que no puede cumplir (CA-15).
- **D-04:** El chat de una visita usa la misma conversación; no se usa `UnirseAVisita`.
- **D-05:** Sin cola local de mensajes, para no dejar datos personales en disco (spec 020, R-06).

## 13. Riesgos y dudas abiertas
- **Bloquear y reportar antes de elegir no es posible:** la conversación no trae el identificador de la otra persona. La descripción del proyecto pide bloquear desde el chat; requiere una enmienda del backend (030 o 043).
- El `tecnicoId` no viene en la conversación: «Ver su perfil» no aparece al entrar desde la lista.
- Sin probar contra el backend desplegado; confirmar que dev tiene el hub de la spec 030 y la moderación encendida (sin ella, enviar responde `503`).

## Aprobación
- [x] Revisor 1 — nombre: Julián Hernández fecha: 2026-11-27
- [x] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
