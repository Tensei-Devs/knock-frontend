# Spec 043 — Panel web: revisión de verificaciones de identidad y reportes

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints VER-03, VER-04, VER-05, REP-04, REP-05.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 053) y spec 033 (sesión del panel y permisos). **Skills:** `angular-panel`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 053 y se vendorizan antes de implementar (spec 006). El cliente TypeScript se genera, no se escribe a mano.
> **Permiso del panel:** `verification:review y reports:resolve` (spec 023).

## 1. Objetivo
Definir las pantallas del **panel web interno** (Angular, carpeta `panel/`) que consumen el contrato de backend 053 con los permisos y el doble factor de la spec 023: Como personal de verificación o moderación, quiero revisar las verificaciones de identidad y resolver reportes con apelación, para mantener la confianza en la plataforma.

## 2. Historia y casos de prueba
**Historia:** Como personal de verificación o moderación, quiero revisar las verificaciones de identidad y resolver reportes con apelación, para mantener la confianza en la plataforma.

- **CA-01:** Dada una respuesta correcta de `GET /api/v1/admin/verificaciones`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-02:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/verificaciones`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-03:** Dado un 401 de `GET /api/v1/admin/verificaciones`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-04:** Dado un listado de `/api/v1/admin/verificaciones`, cuando la persona avanza, entonces el panel pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de componente.
- **CA-05:** Dada una respuesta correcta de `GET /api/v1/admin/verificaciones/{id}`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-06:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/verificaciones/{id}`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-07:** Dado un 401 de `GET /api/v1/admin/verificaciones/{id}`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-08:** Dadas las respuestas 404, 410 de `GET /api/v1/admin/verificaciones/{id}`, cuando el panel las recibe, entonces muestra el mensaje del catálogo de traducciones y conserva lo escrito; en 429 respeta `Retry-After` y no reintenta solo. · Verificación: prueba de componente por código.
- **CA-09:** Dada una respuesta correcta de `POST /api/v1/admin/verificaciones/{id}/decision`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-10:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/verificaciones/{id}/decision`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-11:** Dado un 401 de `POST /api/v1/admin/verificaciones/{id}/decision`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-12:** Dadas las respuestas 404, 409 de `POST /api/v1/admin/verificaciones/{id}/decision`, cuando el panel las recibe, entonces muestra el mensaje del catálogo de traducciones y conserva lo escrito; en 429 respeta `Retry-After` y no reintenta solo. · Verificación: prueba de componente por código.
- **CA-13:** Dada una acción `POST /api/v1/admin/verificaciones/{id}/decision`, cuando la persona la confirma, entonces el panel pide confirmación antes de enviarla, bloquea el botón mientras responde y muestra el resultado; el servidor registra la auditoría. · Verificación: prueba de componente.
- **CA-14:** Dada una respuesta correcta de `GET /api/v1/admin/reportes`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-15:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/reportes`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-16:** Dado un 401 de `GET /api/v1/admin/reportes`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-17:** Dado un listado de `/api/v1/admin/reportes`, cuando la persona avanza, entonces el panel pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de componente.
- **CA-18:** Dada una respuesta correcta de `POST /api/v1/admin/reportes/{id}/decision`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-19:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/reportes/{id}/decision`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-20:** Dado un 401 de `POST /api/v1/admin/reportes/{id}/decision`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-21:** Dadas las respuestas 404 de `POST /api/v1/admin/reportes/{id}/decision`, cuando el panel las recibe, entonces muestra el mensaje del catálogo de traducciones y conserva lo escrito; en 429 respeta `Retry-After` y no reintenta solo. · Verificación: prueba de componente por código.
- **CA-22:** Dada una acción `POST /api/v1/admin/reportes/{id}/decision`, cuando la persona la confirma, entonces el panel pide confirmación antes de enviarla, bloquea el botón mientras responde y muestra el resultado; el servidor registra la auditoría. · Verificación: prueba de componente.
- **CA-23:** Dada la pantalla «Panel de administración», cuando carga, está vacía, falla, no hay conexión o espera, entonces muestra cada estado con su texto. · Verificación: prueba de componente por estado.
- **CA-24:** Dados los datos de las personas y los enlaces de fotos, cuando se inspeccionan el almacenamiento del navegador, la consola y los reportes de errores, entonces no aparece ningún dato personal, token ni enlace firmado. · Verificación: prueba de componente y revisión de registros.
- **CA-25:** Dadas las pantallas de esta spec, cuando se evalúan, entonces cumplen contraste AA y se operan solo con teclado, con foco visible y etiquetas. · Verificación: prueba de accesibilidad del panel.
- **CA-26:** Dados los textos de esta spec, cuando se muestran, entonces salen del catálogo de traducciones del panel y los colores del tema, sin texto fijo. · Verificación: prueba de componente.

## 3. Alcance / No-alcance

**Dentro (panel web)**
- Pantalla «Panel de administración» (endpoints VER-03, VER-04, VER-05, REP-04, REP-05).
- Guardas por permiso, estados, confirmaciones y mensajes de error de cada ruta.

**Fuera**
- La app móvil: sus pantallas son de otras specs.
- La sesión del panel, el TOTP y los permisos: spec 023 y backend 033.
- La lógica del servidor y la auditoría: backend 053 y 033.

## 4. Contrato API y eventos
El panel **consume**; el contrato lo fija backend 053.

| Método y ruta | Uso en el panel | Cuerpo / parámetros | Respuesta | Errores que el panel distingue |
|---|---|---|---|---|
| `GET /api/v1/admin/verificaciones` | Cola de revisión del panel | Query: estado, desde, hasta | 200 | 200; 401; 403 |
| `GET /api/v1/admin/verificaciones/{id}` | Abre una verificación; entrega enlaces de 5 minutos a las fotos y registra quién las abrió | Ruta: id | 200 | 200; 401; 403; 404; 410 (fotos ya destruidas) |
| `POST /api/v1/admin/verificaciones/{id}/decision` | Aprueba o rechaza con motivo; destruye la llave de las fotos | Cuerpo: decision (aprobada/rechazada), motivo | 200 | 200; 400; 401; 403; 404; 409 |
| `GET /api/v1/admin/reportes` | Cola de moderación | Query: gravedad, estado, desde, hasta | 200 | 200; 401; 403 |
| `POST /api/v1/admin/reportes/{id}/decision` | Asigna gravedad y sanción; avisa a las dos partes sin revelar datos de la otra | Cuerpo: gravedad, sancion, motivo | 200 | 200; 400; 401; 403; 404 |

## 5. Modelo de datos local
No se guarda nada en el navegador: los tokens y los permisos viven solo en memoria (spec 023, R-03). Los datos de las personas y los enlaces firmados no se guardan ni se cachean; se descartan al cambiar de pantalla.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Acceder sin el permiso | Guarda por permiso en la ruta y el servidor lo vuelve a verificar | CA-02, CA-06, CA-10, CA-15, CA-19 |
| Sesión revocada con datos en pantalla | 401 revoca la sesión local | CA-03, CA-07, CA-11, CA-16, CA-20 |
| Datos personales o enlaces firmados filtrados | Nada en almacenamiento, consola ni reportes de errores | CA-24 |
| Acción destructiva por error | Confirmación previa y botón bloqueado mientras responde | CA-13, CA-22 |
| Pantalla inaccesible | Contraste AA y teclado | CA-25 a CA-26 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Permiso |
|---|---|---|---|
| Panel de administración | carga, con datos, vacío, error, sin conexión, espera | VER-03, VER-04, VER-05, REP-04, REP-05 | verification:review y reports:resolve |

**Mensajes:** los códigos `insufficient_permission`, `permissions_changed` e `invalid_session` usan los textos de la spec 023; los propios de esta spec van en el catálogo de traducciones del panel.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias | Sí | Servicios con el cliente generado, guardas e interceptor |
| Componente | Sí | Cada pantalla y estado, teclado y contraste |
| Aceptación | Sí | CA-01 a CA-26 |
| Contrato | Sí | Cliente TypeScript generado contra `contracts/openapi.v1.json` (spec 006) |
| E2E de humo | Sí | Entrada al panel y apertura de la pantalla con el backend de pruebas |

Puertas de CI: lint, tipos, pruebas, build y E2E de humo del panel, `sdd_lint --trace 043` y análisis de dependencias.

## 9. Arquitectura y componentes
- `panel/src/app/features/revision-de-verificaciones-y-reportes/` con servicios sobre el cliente TypeScript generado, componentes de lista, detalle y acción, y rutas con el permiso en sus datos de ruta.
- Los componentes no usan `HttpClient` ni `innerHTML` (spec 003).

## 10. Dependencias con otras specs
- Backend 053 (contrato), backend 033 (sesión y permisos) y las specs 003, 006 y 023 del panel.
- Backend 025.
- Backend 031.
- Backend 033.

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 043` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en el panel desplegado con una cuenta con el permiso.

## 12. Decisiones tomadas sin consulta
- **D-01:** Una pantalla de lista y detalle por recurso, con la acción en el detalle.
- **D-02:** Las acciones que cambian el estado piden confirmación; el servidor audita (spec 033).

## 13. Riesgos y dudas abiertas
- Las fotos de verificación se ven solo con enlaces firmados de vida corta (spec 025); confirmar auditoría de cada vista y que el panel no las guarde ni las cachee.
- Confirmar qué permiso exige ver reportes de opiniones (`reviews:moderate`) frente a `reports:resolve`.
- Confirmar los motivos de rechazo permitidos y si la decisión pide nota obligatoria.
- Esta spec se generó a partir del Excel y se afinó para el panel; antes de aprobarla hay que revisarla con quien opere el panel.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
