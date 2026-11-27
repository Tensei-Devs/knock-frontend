# Spec 033 — Bloqueos entre personas y reportes con apelación (pantallas)

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints BLO-01, BLO-02, BLO-03, REP-01, REP-02, REP-03.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 043). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 043 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 043 en la app móvil: Como persona, quiero bloquear a alguien y reportar un abuso, para sentirme segura usando Knock.

## 2. Historia y casos de prueba
**Historia:** Como persona, quiero bloquear a alguien y reportar un abuso, para sentirme segura usando Knock.

- **CA-01:** Dada una respuesta correcta de `POST /api/v1/usuarios/{id}/bloqueo`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `POST /api/v1/usuarios/{id}/bloqueo`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 404 `user_not_found`, 409 `already_blocked` de `POST /api/v1/usuarios/{id}/bloqueo`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dada una respuesta correcta de `DELETE /api/v1/usuarios/{id}/bloqueo`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-05:** Dada una respuesta 401 de `DELETE /api/v1/usuarios/{id}/bloqueo`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-06:** Dadas las respuestas 404 `block_not_found` de `DELETE /api/v1/usuarios/{id}/bloqueo`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-07:** Dada una respuesta correcta de `GET /api/v1/me/bloqueos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-08:** Dada una respuesta 401 de `GET /api/v1/me/bloqueos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-09:** Dado un listado de `/api/v1/me/bloqueos`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-10:** Dada una respuesta correcta de `POST /api/v1/reportes`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-11:** Dada una respuesta 401 de `POST /api/v1/reportes`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-12:** Dadas las respuestas 422 de `POST /api/v1/reportes`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-13:** Dada una respuesta correcta de `GET /api/v1/reportes/me`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-14:** Dada una respuesta 401 de `GET /api/v1/reportes/me`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-15:** Dado un listado de `/api/v1/reportes/me`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-16:** Dada una respuesta correcta de `POST /api/v1/reportes/{id}/apelacion`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-17:** Dada una respuesta 401 de `POST /api/v1/reportes/{id}/apelacion`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-18:** Dadas las respuestas 403, 409 `appeal_not_allowed` de `POST /api/v1/reportes/{id}/apelacion`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-19:** Dada la pantalla «Chat (menú Bloquear)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-20:** Dada la pantalla «Chat (Desbloquear)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-21:** Dada la pantalla «Chat», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-22:** Dada la pantalla «Reportar un problema», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-23:** Dada la pantalla «Reportar», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-24:** Dada la pantalla «Centro de ayuda», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-25:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-26:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-27:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Chat (menú Bloquear)» (endpoints BLO-01).
- Pantalla «Chat (Desbloquear)» (endpoints BLO-02).
- Pantalla «Chat» (endpoints BLO-03).
- Pantalla «Reportar un problema» (endpoints REP-01).
- Pantalla «Reportar» (endpoints REP-02, REP-03).
- Pantalla «Centro de ayuda» (endpoints REP-02).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 043.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 043 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/usuarios/{id}/bloqueo` | Bloquea a una persona | Ruta: id de quien se bloquea | 201 | 201; 401; 404; 409 |
| `DELETE /api/v1/usuarios/{id}/bloqueo` | Desbloquea (Deshacer) | Ruta: id | 204 | 204; 401; 404 |
| `GET /api/v1/me/bloqueos` | Lista a quién tiene bloqueado la persona | Ninguno | 200 | 200; 401 |
| `POST /api/v1/reportes` | Crea un reporte con motivo, texto y evidencia. Avisa de llamar al 911 si hay peligro | Cuerpo: reportadoId, referencia, motivo, descripcion, evidencia | 201 | 201; 400; 401; 422 |
| `GET /api/v1/reportes/me` | Lista los reportes hechos por la persona | Ninguno | 200 | 200; 401 |
| `POST /api/v1/reportes/{id}/apelacion` | Apela una decisión (una sola vez) | Ruta: id. Cuerpo: texto | 200 | 200; 400; 401; 403; 409 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-06, CA-12, CA-18 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-05, CA-08, CA-11, CA-14, CA-17 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-27 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-25 a CA-26 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Chat (menú Bloquear) | carga, con datos, vacío, error, sin conexión | BLO-01 | claves `bloqueos*` en `app_es.arb` y `app_en.arb` |
| Chat (Desbloquear) | carga, con datos, vacío, error, sin conexión | BLO-02 | claves `bloqueos*` en `app_es.arb` y `app_en.arb` |
| Chat | carga, con datos, vacío, error, sin conexión | BLO-03 | claves `bloqueos*` en `app_es.arb` y `app_en.arb` |
| Reportar un problema | carga, con datos, vacío, error, sin conexión | REP-01 | claves `bloqueos*` en `app_es.arb` y `app_en.arb` |
| Reportar | carga, con datos, vacío, error, sin conexión | REP-02, REP-03 | claves `bloqueos*` en `app_es.arb` y `app_en.arb` |
| Centro de ayuda | carga, con datos, vacío, error, sin conexión | REP-02 | claves `bloqueos*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-27 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 033`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/bloqueos/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 043 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 026.
- Backend 030.
- Backend 033.
**Prerrequisitos que hoy no existen (trabajo pendiente, no capacidades implementadas):**
- Mensajería y conversaciones de las specs 026 y 030 y el reparto de solicitudes de la 028 (hoy no implementados)
- Cola del panel de la spec 053 (hoy no implementada)
- Eventos `BloqueoCreado` y `BloqueoEliminado` por la bandeja de salida de la spec 054 y la proyección `bloqueos` en Mercado y Mensajería (hoy no existen)

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 033` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** El bloqueo se hace desde el perfil o el chat con «Bloquear» y un «Deshacer» inmediato.
- **D-04:** El reporte muestra primero el aviso de llamar al 911 si el motivo implica peligro.
- **D-05:** Las correcciones de la revisión del 2026-11-13 están en la §14 de la spec de backend 043 y se reflejan en esta spec.

## 13. Riesgos y dudas abiertas
- Sin dudas abiertas: todas las decisiones de esta spec quedaron resueltas en el cierre del 2026-11-13.

## Nota de enmienda (2026-11-26, apelación de una cuenta suspendida)

- **Estado de esta enmienda:** propuesta **SIN FIRMA**; vale desde que se firma la línea «Enmienda 2026-11-26 (rutas publicadas)» de la sección Aprobación. La aprobación original y las enmiendas ya firmadas se conservan.
- **Momento de redacción:** se redacta el 2026-11-26, **después** de que la ruta existe en el backend (contrato `docs/openapi.*.json` de `origin/develop` de knock-backend). En `sprint-05` no se encontró código de la app que la llame.
- Fuente: backend 060. Es distinta de `POST /api/v1/reportes/{id}/apelacion`, que exige sesión y no cambia.
- Las dos rutas **no usan la sesión de Knock**: llevan `Authorization: Bearer <idToken de Firebase>` de un inicio de sesión por SMS de hace 10 minutos como máximo. No emiten sesión. Una cuenta suspendida recibe `403 account_suspended` en `POST /api/v1/auth/firebase`.

| Método y ruta | Cuerpo | Respuesta | Errores |
|---|---|---|---|
| `POST /api/v1/suspension/apelacion` | `{ texto }` (8 a 500 caracteres) | `200` `{ estado, presentadaEn, resueltaEn? }` | `400`, `401`, `404 not_found`, `409 appeal_not_allowed`, `413`, `422` (`errors.texto`), `429 rate_limited` |
| `GET /api/v1/suspension/apelacion` | — | `200` `{ estado (pendiente, aceptada o rechazada), presentadaEn, resueltaEn? }` | `401`, `404 not_found`, `429` |

- **CA-E01:** Dada una persona suspendida, cuando la app consulta o envía la apelación, entonces usa el `idToken` de Firebase, no el token de Knock, y no guarda el `idToken` ni el texto. · Verificación: prueba unitaria del repositorio.
- **CA-E02:** Dado un `401`, cuando llega en estas rutas, entonces la app pide verificar el número otra vez por SMS (no hay sesión de Knock que cerrar). · Verificación: prueba de widget.
- **CA-E03:** Dado un `404 not_found`, cuando llega, entonces la app muestra que no hay una apelación disponible, sin afirmar si la cuenta existe o está suspendida. · Verificación: prueba de widget.
- **Decisión pendiente:** desde dónde se llega (propuesta: aviso tras el `403 account_suspended` de la entrada), y los textos y estados de la pantalla en español e inglés.
- **Decisión pendiente:** confirmar en backend qué responde `GET` a una persona suspendida que aún no ha apelado, para saber cuándo mostrar el formulario.

## Nota de enmienda (2026-11-27, pantalla de apelación de una cuenta suspendida)

- **Estado de esta enmienda:** PROPUESTA SIN FIRMA; vale desde que se firma la línea «Enmienda 2026-11-27 (pantalla de apelación)» de la sección Aprobación. La aprobación original y las enmiendas ya firmadas se conservan.
- **Resuelve** las dos decisiones pendientes de la nota «apelación de una cuenta suspendida».
- **Entrada:** cuando `POST /api/v1/auth/firebase` responde `403 account_suspended`, la pantalla del código muestra «Apelar la suspensión». No hay otra entrada.
- **Pasos:** celular, código por SMS, consulta, y después estado o formulario. El `idToken` vive solo en memoria mientras la pantalla está abierta; la sesión de Firebase se cierra al obtenerlo y no se crea sesión de Knock.
- **Confirmado en backend** (`origin/develop`, spec 060): `GET` de una persona suspendida que aún no apeló responde `404 not_found`. Por eso un `404` en la consulta muestra el formulario con un texto neutro. Un `404` al enviar muestra «no hay una apelación disponible».
- `409 appeal_not_allowed`: no se puede presentar otra. `401`: volver a verificar el número. `422`, `429` y fallas de red: mensaje del catálogo y se conserva el texto.

| Clave ARB | Español | Inglés |
|---|---|---|
| `suspensionApelar` | Apelar la suspensión | Appeal the suspension |
| `suspensionTitulo` | Tu apelación | Your appeal |
| `suspensionDetalle` | Verifica tu número con un código por SMS. Esto no inicia sesión. | Verify your number with an SMS code. This doesn’t sign you in. |
| `suspensionEnviarCodigo` | Enviarme el código | Send me the code |
| `suspensionVerificar` | Verificar | Verify |
| `suspensionSinConsulta` | No hay una apelación disponible para consultar. Si quieres apelar, escribe tus motivos. | There’s no appeal available to check. If you want to appeal, write your reasons. |
| `suspensionTexto` | Tus motivos | Your reasons |
| `suspensionTextoAyuda` | Escribe entre 8 y 500 caracteres. | Write between 8 and 500 characters. |
| `suspensionPresentar` | Enviar apelación | Send appeal |
| `suspensionNoDisponible` | No hay una apelación disponible. | There’s no appeal available. |
| `suspensionNoPermitida` | No se puede presentar otra apelación. | You can’t send another appeal. |
| `suspensionVerificarOtraVez` | Verifica tu número otra vez con un código por SMS. | Verify your number again with an SMS code. |
| `suspensionVolver` | Volver | Back |
| `suspensionEstado` | Tu apelación está en revisión. / fue aceptada. / fue rechazada. | Your appeal is under review. / was accepted. / was rejected. |
| `suspensionPresentadaEl`, `suspensionResueltaEl` | Presentada el {fecha} · Resuelta el {fecha} | Sent on {fecha} · Resolved on {fecha} |

- **CA-A01:** Dado un `403 account_suspended` en la entrada, cuando se muestra el error, entonces aparece «Apelar la suspensión» y abre la pantalla sin sesión. · Verificación: prueba de widget.
- **CA-A02:** Dados los estados `pendiente`, `aceptada` y `rechazada`, y los casos `404` al consultar y al enviar, cuando llegan, entonces se muestra el texto de esta tabla que corresponde. · Verificación: prueba de widget por caso.

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-14
- [x] Sin conflicto con la constitución
- [x] Enmienda 2026-11-26 (rutas publicadas) — nombre: Julián Hernández fecha: 2026-11-26
- [x] Enmienda 2026-11-27 (pantalla de apelación) — nombre: Julián Hernández fecha: 2026-11-27
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
