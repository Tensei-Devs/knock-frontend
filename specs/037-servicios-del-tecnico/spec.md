# Spec 037 — Servicios y precios de cada técnico (pantallas)

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints SRV-01, SRV-02, SRV-03, SRV-04.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 047). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 047 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 047 en la app móvil: Como técnico, quiero definir los servicios que ofrezco y mis precios de referencia, para recibir solicitudes que sí puedo atender.

## 2. Historia y casos de prueba
**Historia:** Como técnico, quiero definir los servicios que ofrezco y mis precios de referencia, para recibir solicitudes que sí puedo atender.

- **CA-01:** Dada una respuesta correcta de `GET /api/v1/tecnicos/{id}/servicios`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `GET /api/v1/tecnicos/{id}/servicios`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 404 `technician_not_found` de `GET /api/v1/tecnicos/{id}/servicios`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dada una consulta de `/api/v1/tecnicos/{id}/servicios` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-05:** Dada una respuesta correcta de `POST /api/v1/tecnicos/me/servicios`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-06:** Dada una respuesta 401 de `POST /api/v1/tecnicos/me/servicios`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-07:** Dadas las respuestas 422 de `POST /api/v1/tecnicos/me/servicios`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-08:** Dada una respuesta correcta de `PUT /api/v1/tecnicos/me/servicios/{id}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-09:** Dada una respuesta 401 de `PUT /api/v1/tecnicos/me/servicios/{id}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-10:** Dadas las respuestas 403, 404 `service_not_found` de `PUT /api/v1/tecnicos/me/servicios/{id}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-11:** Dada una respuesta correcta de `DELETE /api/v1/tecnicos/me/servicios/{id}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-12:** Dada una respuesta 401 de `DELETE /api/v1/tecnicos/me/servicios/{id}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-13:** Dadas las respuestas 403, 404 `service_not_found` de `DELETE /api/v1/tecnicos/me/servicios/{id}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-14:** Dada la pantalla «Perfil del técnico», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-15:** Dada la pantalla «Mi perfil público», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-16:** Dada la pantalla «Registro de técnico», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-17:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-18:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-19:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Perfil del técnico» (endpoints SRV-01).
- Pantalla «Mi perfil público» (endpoints SRV-02, SRV-03, SRV-04).
- Pantalla «Registro de técnico» (endpoints SRV-02).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 047.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 047 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/tecnicos/{id}/servicios` | Servicios y precios de referencia de un técnico | Ruta: id | 200 | 200; 401; 404 |
| `POST /api/v1/tecnicos/me/servicios` | Agrega un servicio | Cuerpo: nombre, detalle, precioReferencia, oficio | 201 | 201; 400; 401; 422 |
| `PUT /api/v1/tecnicos/me/servicios/{id}` | Edita un servicio | Ruta: id. Cuerpo: campos | 200 | 200; 400; 401; 403; 404 |
| `DELETE /api/v1/tecnicos/me/servicios/{id}` | Quita un servicio | Ruta: id | 204 | 204; 401; 403; 404 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-07, CA-10, CA-13 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-06, CA-09, CA-12 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-19 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-17 a CA-18 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Perfil del técnico | carga, con datos, vacío, error, sin conexión | SRV-01 | claves `servicios*` en `app_es.arb` y `app_en.arb` |
| Mi perfil público | carga, con datos, vacío, error, sin conexión | SRV-02, SRV-03, SRV-04 | claves `servicios*` en `app_es.arb` y `app_en.arb` |
| Registro de técnico | carga, con datos, vacío, error, sin conexión | SRV-02 | claves `servicios*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-19 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 037`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/servicios/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 047 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 046.
- Backend 020.
**Prerrequisitos que hoy no existen (trabajo pendiente, no capacidades implementadas):**
- Perfil del técnico y catálogo de oficios activos (spec 046, hoy no implementada)

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 037` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** El técnico administra sus servicios desde su perfil (spec 019); el cliente los ve en el perfil del técnico.
- **D-04:** Las correcciones de la revisión del 2026-11-13 están en la §14 de la spec de backend 047 y se reflejan en esta spec.

## 13. Riesgos y dudas abiertas
- Sin dudas abiertas: todas las decisiones de esta spec quedaron resueltas en el cierre del 2026-11-13.

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-14
- [x] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
