# Spec 032 — Técnicos de confianza (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints TCO-01, TCO-02, TCO-03.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 042). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 042 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 042 en la app móvil: Como cliente, quiero guardar a los técnicos que me atendieron bien, para volver a llamarlos.

## 2. Historia y casos de prueba
**Historia:** Como cliente, quiero guardar a los técnicos que me atendieron bien, para volver a llamarlos.

- **CA-01:** Dada una respuesta correcta de `GET /api/v1/me/tecnicos-confianza`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `GET /api/v1/me/tecnicos-confianza`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dado un listado de `/api/v1/me/tecnicos-confianza`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-04:** Dada una respuesta correcta de `PUT /api/v1/me/tecnicos-confianza/{tecnicoId}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-05:** Dada una respuesta 401 de `PUT /api/v1/me/tecnicos-confianza/{tecnicoId}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-06:** Dadas las respuestas 404 `technician_not_found` de `PUT /api/v1/me/tecnicos-confianza/{tecnicoId}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-07:** Dada una respuesta correcta de `DELETE /api/v1/me/tecnicos-confianza/{tecnicoId}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-08:** Dada una respuesta 401 de `DELETE /api/v1/me/tecnicos-confianza/{tecnicoId}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-09:** Dadas las respuestas 404 `trusted_technician_not_found` de `DELETE /api/v1/me/tecnicos-confianza/{tecnicoId}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-10:** Dada la pantalla «Mis técnicos de confianza», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-11:** Dada la pantalla «Perfil del técnico», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-12:** Dada la pantalla «Calificar», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-13:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-14:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-15:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Mis técnicos de confianza» (endpoints TCO-01, TCO-03).
- Pantalla «Perfil del técnico» (endpoints TCO-02).
- Pantalla «Calificar» (endpoints TCO-02).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 042.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 042 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/me/tecnicos-confianza` | Lista los técnicos guardados | Ninguno | 200 | 200; 401 |
| `PUT /api/v1/me/tecnicos-confianza/{tecnicoId}` | Guarda a un técnico de confianza (requiere cuenta) | Ruta: tecnicoId | 200 | 200; 201; 401; 404 |
| `DELETE /api/v1/me/tecnicos-confianza/{tecnicoId}` | Quita un técnico de la lista | Ruta: tecnicoId | 204 | 204; 401; 404 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-06, CA-09 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-05, CA-08 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-15 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-13 a CA-14 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Mis técnicos de confianza | carga, con datos, vacío, error, sin conexión | TCO-01, TCO-03 | claves `tecnicos*` en `app_es.arb` y `app_en.arb` |
| Perfil del técnico | carga, con datos, vacío, error, sin conexión | TCO-02 | claves `tecnicos*` en `app_es.arb` y `app_en.arb` |
| Calificar | carga, con datos, vacío, error, sin conexión | TCO-02 | claves `tecnicos*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-15 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 032`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/tecnicos/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 042 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 022.
- Backend 037.
**Prerrequisitos que hoy no existen (trabajo pendiente, no capacidades implementadas):**
- Almacén de técnicos y su visibilidad de las specs 027 y 028 (hoy no implementados)

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 032` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** Los técnicos de confianza se ven en Perfil y como atajo al terminar una visita («Guardar como de confianza»).
- **D-04:** Las correcciones de la revisión del 2026-11-13 están en la §14 de la spec de backend 042 y se reflejan en esta spec.

## 13. Riesgos y dudas abiertas
- Sin dudas abiertas: todas las decisiones de esta spec quedaron resueltas en el cierre del 2026-11-13.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
