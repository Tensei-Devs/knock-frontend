# Spec 039 — Cotización final tras la visita y ajustes de precio (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints COT-06, COT-07, AJU-01, AJU-02.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 049). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 049 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 049 en la app móvil: Como técnico, quiero enviar la cotización final tras ver el trabajo o pedir un ajuste de precio, y como cliente quiero aceptarlo o rechazarlo, para acordar el costo real sin sorpresas.

## 2. Historia y casos de prueba
**Historia:** Como técnico, quiero enviar la cotización final tras ver el trabajo o pedir un ajuste de precio, y como cliente quiero aceptarlo o rechazarlo, para acordar el costo real sin sorpresas.

- **CA-01:** Dada una respuesta correcta de `POST /api/v1/visitas/{id}/cotizacion-final`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `POST /api/v1/visitas/{id}/cotizacion-final`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 403, 409 `final_quote_not_allowed` de `POST /api/v1/visitas/{id}/cotizacion-final`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dada una respuesta correcta de `POST /api/v1/visitas/{id}/cotizacion-final/decision`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-05:** Dada una respuesta 401 de `POST /api/v1/visitas/{id}/cotizacion-final/decision`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-06:** Dadas las respuestas 403, 409 `final_quote_already_decided` de `POST /api/v1/visitas/{id}/cotizacion-final/decision`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-07:** Dada una respuesta correcta de `POST /api/v1/cotizaciones/{id}/ajuste-precio`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-08:** Dada una respuesta 401 de `POST /api/v1/cotizaciones/{id}/ajuste-precio`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-09:** Dadas las respuestas 403, 409 `adjustment_not_allowed`, 422 de `POST /api/v1/cotizaciones/{id}/ajuste-precio`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-10:** Dada una respuesta correcta de `POST /api/v1/ajustes/{id}/decision`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-11:** Dada una respuesta 401 de `POST /api/v1/ajustes/{id}/decision`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-12:** Dadas las respuestas 403, 404, 409 `adjustment_already_decided` de `POST /api/v1/ajustes/{id}/decision`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-13:** Dada la pantalla «Terminar servicio», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-14:** Dada la pantalla «Chat», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-15:** Dada la pantalla «Mensajes», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-16:** Dada la pantalla «Visita», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-17:** Dada la pantalla «Terminar servicio (Proponer otro precio)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-18:** Dada la pantalla «Mensajes (Aprobar)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-19:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-20:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-21:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Terminar servicio» (endpoints COT-06).
- Pantalla «Chat» (endpoints COT-06).
- Pantalla «Mensajes» (endpoints COT-07).
- Pantalla «Visita» (endpoints COT-07, AJU-02).
- Pantalla «Terminar servicio (Proponer otro precio)» (endpoints AJU-01).
- Pantalla «Mensajes (Aprobar)» (endpoints AJU-02).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 049.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 049 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/visitas/{id}/cotizacion-final` | Después de la visita previa, el técnico envía la cotización final | Ruta: id. Cuerpo: precio, descripcion | 201 | 201; 400; 401; 403; 409 |
| `POST /api/v1/visitas/{id}/cotizacion-final/decision` | El cliente aprueba o rechaza la cotización final. Si rechaza, paga solo la visita | Ruta: id. Cuerpo: decision | 200 | 200; 400; 401; 403; 409 |
| `POST /api/v1/cotizaciones/{id}/ajuste-precio` | El técnico propone un cambio sobre el tope, con motivo | Ruta: id. Cuerpo: montoNuevo, motivo | 201 | 201; 400; 401; 403; 409; 422 |
| `POST /api/v1/ajustes/{id}/decision` | El cliente aprueba o rechaza | Ruta: id. Cuerpo: decision | 200 | 200; 400; 401; 403; 404; 409 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-06, CA-09, CA-12 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-05, CA-08, CA-11 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-21 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-19 a CA-20 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Terminar servicio | carga, con datos, vacío, error, sin conexión | COT-06 | claves `cotizacion*` en `app_es.arb` y `app_en.arb` |
| Chat | carga, con datos, vacío, error, sin conexión | COT-06 | claves `cotizacion*` en `app_es.arb` y `app_en.arb` |
| Mensajes | carga, con datos, vacío, error, sin conexión | COT-07 | claves `cotizacion*` en `app_es.arb` y `app_en.arb` |
| Visita | carga, con datos, vacío, error, sin conexión | COT-07, AJU-02 | claves `cotizacion*` en `app_es.arb` y `app_en.arb` |
| Terminar servicio (Proponer otro precio) | carga, con datos, vacío, error, sin conexión | AJU-01 | claves `cotizacion*` en `app_es.arb` y `app_en.arb` |
| Mensajes (Aprobar) | carga, con datos, vacío, error, sin conexión | AJU-02 | claves `cotizacion*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-21 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 039`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/cotizacion/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 049 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 020.
- Backend 021.
- Backend 022.
**Prerrequisitos que hoy no existen (trabajo pendiente, no capacidades implementadas):**
- Tareas de vencimiento del ejecutor de la spec 054 (hoy no implementado)
- Topes de la spec 020 (su dominio ya está en `sprint-04`)

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 039` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** El técnico ve el estado de su cotización final y su ajuste con la cuenta regresiva de la vigencia; el cliente decide desde el aviso o desde la visita.
- **D-04:** Las correcciones de la revisión del 2026-11-13 están en la §14 de la spec de backend 049 y se reflejan en esta spec.

## 13. Riesgos y dudas abiertas
- Sin dudas abiertas: todas las decisiones de esta spec quedaron resueltas en el cierre del 2026-11-13.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
