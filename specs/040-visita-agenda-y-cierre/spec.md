# Spec 040 — Visita: agenda, reprogramación, cancelación, cliente ausente, cierre y permiso de fotos (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints VIS-02, VIS-04, VIS-05, VIS-06, VIS-07, VIS-09, VIS-10, VIS-11.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 050). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 050 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 050 en la app móvil: Como cliente o técnico, quiero ver mi agenda y poder reprogramar, cancelar, marcar ausencia, terminar o dejar el trabajo sin terminar, para cerrar cada visita con claridad.

## 2. Historia y casos de prueba
**Historia:** Como cliente o técnico, quiero ver mi agenda y poder reprogramar, cancelar, marcar ausencia, terminar o dejar el trabajo sin terminar, para cerrar cada visita con claridad.

- **CA-01:** Dada una respuesta correcta de `GET /api/v1/agenda`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `GET /api/v1/agenda`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 403 de `GET /api/v1/agenda`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dado un listado de `/api/v1/agenda`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-05:** Dada una respuesta correcta de `POST /api/v1/visitas/{id}/reprogramar`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-06:** Dada una respuesta 401 de `POST /api/v1/visitas/{id}/reprogramar`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-07:** Dadas las respuestas 403, 409 `visit_not_reschedulable` de `POST /api/v1/visitas/{id}/reprogramar`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-08:** Dada una respuesta correcta de `POST /api/v1/visitas/{id}/reprogramar/respuesta`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-09:** Dada una respuesta 401 de `POST /api/v1/visitas/{id}/reprogramar/respuesta`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-10:** Dadas las respuestas 403, 409 `no_pending_proposal` de `POST /api/v1/visitas/{id}/reprogramar/respuesta`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-11:** Dada una respuesta correcta de `POST /api/v1/visitas/{id}/cancelar`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-12:** Dada una respuesta 401 de `POST /api/v1/visitas/{id}/cancelar`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-13:** Dadas las respuestas 403, 409 `visit_already_closed` de `POST /api/v1/visitas/{id}/cancelar`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-14:** Dada una respuesta correcta de `POST /api/v1/visitas/{id}/cliente-ausente`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-15:** Dada una respuesta 401 de `POST /api/v1/visitas/{id}/cliente-ausente`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-16:** Dadas las respuestas 403, 409 `outside_arrival_window` de `POST /api/v1/visitas/{id}/cliente-ausente`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-17:** Dada una respuesta correcta de `POST /api/v1/visitas/{id}/terminar`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-18:** Dada una respuesta 401 de `POST /api/v1/visitas/{id}/terminar`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-19:** Dadas las respuestas 403, 409 `visit_not_in_progress`, 422 de `POST /api/v1/visitas/{id}/terminar`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-20:** Dada una respuesta correcta de `POST /api/v1/visitas/{id}/no-terminado`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-21:** Dada una respuesta 401 de `POST /api/v1/visitas/{id}/no-terminado`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-22:** Dadas las respuestas 403, 409 `report_window_closed` de `POST /api/v1/visitas/{id}/no-terminado`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-23:** Dada una respuesta correcta de `PUT /api/v1/visitas/{id}/permiso-fotos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-24:** Dada una respuesta 401 de `PUT /api/v1/visitas/{id}/permiso-fotos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-25:** Dadas las respuestas 403 de `PUT /api/v1/visitas/{id}/permiso-fotos`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-26:** Dada la pantalla «Trabajo», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-27:** Dada la pantalla «Inicio (Mi agenda)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-28:** Dada la pantalla «Visita», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-29:** Dada la pantalla «Cita», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-30:** Dada la pantalla «Trabajo (Cancelar la visita)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-31:** Dada la pantalla «Trabajo (El cliente no estaba)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-32:** Dada la pantalla «Terminar servicio», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-33:** Dada la pantalla «Actividad (No se terminó)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-34:** Dada la pantalla «Calificar», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-35:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-36:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-37:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Trabajo» (endpoints VIS-02, VIS-04, VIS-05).
- Pantalla «Inicio (Mi agenda)» (endpoints VIS-02).
- Pantalla «Visita» (endpoints VIS-04, VIS-05, VIS-06).
- Pantalla «Cita» (endpoints VIS-04, VIS-05, VIS-06).
- Pantalla «Trabajo (Cancelar la visita)» (endpoints VIS-06).
- Pantalla «Trabajo (El cliente no estaba)» (endpoints VIS-07).
- Pantalla «Terminar servicio» (endpoints VIS-09).
- Pantalla «Actividad (No se terminó)» (endpoints VIS-10).
- Pantalla «Calificar» (endpoints VIS-11).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 050.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 050 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/agenda` | Agenda del técnico: próximas visitas y solicitudes nuevas (Mi agenda) | Query: desde, hasta | 200 | 200; 401; 403 |
| `POST /api/v1/visitas/{id}/reprogramar` | Una parte propone otra fecha | Ruta: id. Cuerpo: fechaHora | 200 | 200; 400; 401; 403; 409 |
| `POST /api/v1/visitas/{id}/reprogramar/respuesta` | La otra parte confirma o rechaza | Ruta: id. Cuerpo: acepta | 200 | 200; 400; 401; 403; 409 |
| `POST /api/v1/visitas/{id}/cancelar` | Cancela con motivo obligatorio. Gratis con más de 24 h; menos queda como cancelación tardía y se av… | Ruta: id. Cuerpo: motivo | 200 | 200; 400; 401; 403; 409 |
| `POST /api/v1/visitas/{id}/cliente-ausente` | El técnico registra que el cliente no estaba, sin penalizar. Solo dentro de la ventana de la cita | Ruta: id | 200 | 200; 401; 403; 409 |
| `POST /api/v1/visitas/{id}/terminar` | El técnico termina con fotos (mínimo 1) y qué hizo. No hay confirmación del cliente | Ruta: id. Cuerpo: descripcion, recomendacion, fotos | 200 | 200; 400; 401; 403; 409; 422 |
| `POST /api/v1/visitas/{id}/no-terminado` | El cliente reporta que no se terminó (hasta 7 días después) | Ruta: id. Cuerpo: texto | 201 | 201; 400; 401; 403; 409 |
| `PUT /api/v1/visitas/{id}/permiso-fotos` | El cliente autoriza o no publicar las fotos del trabajo | Ruta: id. Cuerpo: permiso | 200 | 200; 401; 403 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-07, CA-10, CA-13, CA-16, CA-19, CA-22, CA-25 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-06, CA-09, CA-12, CA-15, CA-18, CA-21, CA-24 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-37 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-35 a CA-36 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Trabajo | carga, con datos, vacío, error, sin conexión | VIS-02, VIS-04, VIS-05 | claves `visita*` en `app_es.arb` y `app_en.arb` |
| Inicio (Mi agenda) | carga, con datos, vacío, error, sin conexión | VIS-02 | claves `visita*` en `app_es.arb` y `app_en.arb` |
| Visita | carga, con datos, vacío, error, sin conexión | VIS-04, VIS-05, VIS-06 | claves `visita*` en `app_es.arb` y `app_en.arb` |
| Cita | carga, con datos, vacío, error, sin conexión | VIS-04, VIS-05, VIS-06 | claves `visita*` en `app_es.arb` y `app_en.arb` |
| Trabajo (Cancelar la visita) | carga, con datos, vacío, error, sin conexión | VIS-06 | claves `visita*` en `app_es.arb` y `app_en.arb` |
| Trabajo (El cliente no estaba) | carga, con datos, vacío, error, sin conexión | VIS-07 | claves `visita*` en `app_es.arb` y `app_en.arb` |
| Terminar servicio | carga, con datos, vacío, error, sin conexión | VIS-09 | claves `visita*` en `app_es.arb` y `app_en.arb` |
| Actividad (No se terminó) | carga, con datos, vacío, error, sin conexión | VIS-10 | claves `visita*` en `app_es.arb` y `app_en.arb` |
| Calificar | carga, con datos, vacío, error, sin conexión | VIS-11 | claves `visita*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-37 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 040`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/visita/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 050 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 022.
- Backend 031.
- Backend 032.

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 040` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** El permiso de fotos se pregunta al cliente al terminar la visita, con el texto de consentimiento de la spec 012.
- **D-04:** La agenda del técnico y sus acciones (reprogramar, cancelar, ausente, terminar) viven en la pestaña Trabajo (spec 019).

## 13. Riesgos y dudas abiertas
- Confirmar con diseño el flujo de reprogramación (propuesta y respuesta) contra la maqueta.
- Los estados nuevos de la visita deben reflejarse en la spec 016 al aprobarse.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
