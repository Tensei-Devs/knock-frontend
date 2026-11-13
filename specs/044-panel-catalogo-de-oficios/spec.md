# Spec 044 — Panel web: catálogo de oficios, oficios pedidos y lista de espera

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints OFI-03, OFI-04, OFI-05, OFP-02, LIS-02.
> **Claves de trabajo:** por asignar (se crea la tarea de Jira cuando se decida el alcance) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 045) y spec 033 (sesión del panel y permisos). **Skills:** `angular-panel`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 045 y se vendorizan antes de implementar (spec 006). El cliente TypeScript se genera, no se escribe a mano.
> **Permiso del panel:** `catalog:manage` (spec 023).

## 1. Objetivo
Definir las pantallas del **panel web interno** (Angular, carpeta `panel/`) que consumen el contrato de backend 045 con los permisos y el doble factor de la spec 023: Como personal interno con permiso `catalog:manage`, quiero administrar los oficios, ver los oficios pedidos y la lista de espera, para ampliar la cobertura con datos reales.

## 2. Historia y casos de prueba
**Historia:** Como personal interno con permiso `catalog:manage`, quiero administrar los oficios, ver los oficios pedidos y la lista de espera, para ampliar la cobertura con datos reales.

- **CA-01:** Dada una respuesta correcta de `GET /api/v1/admin/oficios`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-02:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/oficios`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-03:** Dado un 401 de `GET /api/v1/admin/oficios`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-04:** Dada una respuesta correcta de `POST /api/v1/admin/oficios`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-05:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/oficios`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-06:** Dado un 401 de `POST /api/v1/admin/oficios`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-07:** Dadas las respuestas 409 de `POST /api/v1/admin/oficios`, cuando el panel las recibe, entonces muestra el mensaje del catálogo de traducciones y conserva lo escrito; en 429 respeta `Retry-After` y no reintenta solo. · Verificación: prueba de componente por código.
- **CA-08:** Dada una acción `POST /api/v1/admin/oficios`, cuando la persona la confirma, entonces el panel pide confirmación antes de enviarla, bloquea el botón mientras responde y muestra el resultado; el servidor registra la auditoría. · Verificación: prueba de componente.
- **CA-09:** Dada una respuesta correcta de `PUT /api/v1/admin/oficios/{clave}`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-10:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/oficios/{clave}`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-11:** Dado un 401 de `PUT /api/v1/admin/oficios/{clave}`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-12:** Dadas las respuestas 404 de `PUT /api/v1/admin/oficios/{clave}`, cuando el panel las recibe, entonces muestra el mensaje del catálogo de traducciones y conserva lo escrito; en 429 respeta `Retry-After` y no reintenta solo. · Verificación: prueba de componente por código.
- **CA-13:** Dada una acción `PUT /api/v1/admin/oficios/{clave}`, cuando la persona la confirma, entonces el panel pide confirmación antes de enviarla, bloquea el botón mientras responde y muestra el resultado; el servidor registra la auditoría. · Verificación: prueba de componente.
- **CA-14:** Dada una respuesta correcta de `GET /api/v1/admin/oficios-pedidos`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-15:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/oficios-pedidos`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-16:** Dado un 401 de `GET /api/v1/admin/oficios-pedidos`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-17:** Dado un listado de `/api/v1/admin/oficios-pedidos`, cuando la persona avanza, entonces el panel pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de componente.
- **CA-18:** Dada una respuesta correcta de `GET /api/v1/admin/lista-espera`, cuando el panel la recibe, entonces muestra el resultado con los campos del contrato y ninguno que el contrato no declara. · Verificación: prueba del servicio con el cliente TypeScript generado.
- **CA-19:** Dada una persona sin el permiso de la ruta, cuando intenta abrir la pantalla de `/api/v1/admin/lista-espera`, entonces la guarda la bloquea, el menú no la muestra y, si el servidor responde 403 `insufficient_permission`, aparece «Sin permiso» sin revocar la sesión. · Verificación: prueba de guarda y de componente.
- **CA-20:** Dado un 401 de `GET /api/v1/admin/lista-espera`, cuando el panel lo recibe, entonces revoca la sesión local y vuelve al acceso. · Verificación: prueba del interceptor.
- **CA-21:** Dado un listado de `/api/v1/admin/lista-espera`, cuando la persona avanza, entonces el panel pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de componente.
- **CA-22:** Dada la pantalla «Panel de administración», cuando carga, está vacía, falla, no hay conexión o espera, entonces muestra cada estado con su texto. · Verificación: prueba de componente por estado.
- **CA-23:** Dados los datos de las personas y los enlaces de fotos, cuando se inspeccionan el almacenamiento del navegador, la consola y los reportes de errores, entonces no aparece ningún dato personal, token ni enlace firmado. · Verificación: prueba de componente y revisión de registros.
- **CA-24:** Dadas las pantallas de esta spec, cuando se evalúan, entonces cumplen contraste AA y se operan solo con teclado, con foco visible y etiquetas. · Verificación: prueba de accesibilidad del panel.
- **CA-25:** Dados los textos de esta spec, cuando se muestran, entonces salen del catálogo de traducciones del panel y los colores del tema, sin texto fijo. · Verificación: prueba de componente.

## 3. Alcance / No-alcance

**Dentro (panel web)**
- Pantalla «Panel de administración» (endpoints OFI-03, OFI-04, OFI-05, OFP-02, LIS-02).
- Guardas por permiso, estados, confirmaciones y mensajes de error de cada ruta.

**Fuera**
- La app móvil: sus pantallas son de otras specs.
- La sesión del panel, el TOTP y los permisos: spec 023 y backend 033.
- La lógica del servidor y la auditoría: backend 045 y 033.

## 4. Contrato API y eventos
El panel **consume**; el contrato lo fija backend 045.

| Método y ruta | Uso en el panel | Cuerpo / parámetros | Respuesta | Errores que el panel distingue |
|---|---|---|---|---|
| `GET /api/v1/admin/oficios` | Lista todos los oficios, incluidos los inactivos | Ninguno | 200 | 200; 401; 403 |
| `POST /api/v1/admin/oficios` | Crea un oficio nuevo | Cuerpo: clave, nombre, modalidad, parámetros | 201 | 201; 400; 401; 403; 409 |
| `PUT /api/v1/admin/oficios/{clave}` | Edita un oficio y sus parámetros de precio. Invalida la caché | Ruta: clave. Cuerpo: campos | 200 | 200; 400; 401; 403; 404 |
| `GET /api/v1/admin/oficios-pedidos` | Oficios más pedidos, agrupados y contados | Ninguno | 200 | 200; 401; 403 |
| `GET /api/v1/admin/lista-espera` | Cuántas personas esperan por zona | Ninguno | 200 | 200; 401; 403 |

## 5. Modelo de datos local
No se guarda nada en el navegador: los tokens y los permisos viven solo en memoria (spec 023, R-03). Los datos de las personas y los enlaces firmados no se guardan ni se cachean; se descartan al cambiar de pantalla.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Acceder sin el permiso | Guarda por permiso en la ruta y el servidor lo vuelve a verificar | CA-02, CA-05, CA-10, CA-15, CA-19 |
| Sesión revocada con datos en pantalla | 401 revoca la sesión local | CA-03, CA-06, CA-11, CA-16, CA-20 |
| Datos personales o enlaces firmados filtrados | Nada en almacenamiento, consola ni reportes de errores | CA-23 |
| Acción destructiva por error | Confirmación previa y botón bloqueado mientras responde | CA-08, CA-13 |
| Pantalla inaccesible | Contraste AA y teclado | CA-24 a CA-25 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Permiso |
|---|---|---|---|
| Panel de administración | carga, con datos, vacío, error, sin conexión, espera | OFI-03, OFI-04, OFI-05, OFP-02, LIS-02 | catalog:manage |

**Mensajes:** los códigos `insufficient_permission`, `permissions_changed` e `invalid_session` usan los textos de la spec 023; los propios de esta spec van en el catálogo de traducciones del panel.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias | Sí | Servicios con el cliente generado, guardas e interceptor |
| Componente | Sí | Cada pantalla y estado, teclado y contraste |
| Aceptación | Sí | CA-01 a CA-25 |
| Contrato | Sí | Cliente TypeScript generado contra `contracts/openapi.v1.json` (spec 006) |
| E2E de humo | Sí | Entrada al panel y apertura de la pantalla con el backend de pruebas |

Puertas de CI: lint, tipos, pruebas, build y E2E de humo del panel, `sdd_lint --trace 044` y análisis de dependencias.

## 9. Arquitectura y componentes
- `panel/src/app/features/catalogo-de-oficios/` con servicios sobre el cliente TypeScript generado, componentes de lista, detalle y acción, y rutas con el permiso en sus datos de ruta.
- Los componentes no usan `HttpClient` ni `innerHTML` (spec 003).

## 10. Dependencias con otras specs
- Backend 045 (contrato), backend 033 (sesión y permisos) y las specs 003, 006 y 023 del panel.
- Backend 023.
- Backend 033.

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 044` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en el panel desplegado con una cuenta con el permiso.

## 12. Decisiones tomadas sin consulta
- **D-01:** Una pantalla de lista y detalle por recurso, con la acción en el detalle.
- **D-02:** Las acciones que cambian el estado piden confirmación; el servidor audita (spec 033).

## 13. Riesgos y dudas abiertas
- El permiso `catalog:manage` viene de la spec 023 del panel; confirmar si ver la lista de espera exige otro permiso (`metrics:read`).
- Confirmar si crear o editar un oficio pide confirmación en un cuadro de diálogo y se audita (spec 033).
- La lista de espera contiene datos personales (código postal ligado a una persona): confirmar qué campos se muestran y cuáles se enmascaran.
- Esta spec se generó a partir del Excel y se afinó para el panel; antes de aprobarla hay que revisarla con quien opere el panel.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
