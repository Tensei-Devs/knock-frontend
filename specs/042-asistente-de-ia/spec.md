# Spec 042 — Asistente de IA: resumen de chat, borrador de cotización, rango de precio y bitácora (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints ASI-01, ASI-02, ASI-03, ASI-04, ASI-05, ASI-06.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 052). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 052 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 052 en la app móvil: Como persona, quiero que un asistente resuma el chat, sugiera un borrador de cotización y un rango de precio, para decidir más rápido.

## 2. Historia y casos de prueba
**Historia:** Como persona, quiero que un asistente resuma el chat, sugiera un borrador de cotización y un rango de precio, para decidir más rápido.

- **CA-01:** Dada una respuesta correcta de `POST /api/v1/asistente/conversaciones`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `POST /api/v1/asistente/conversaciones`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 422, 429 `ai_daily_limit_reached` de `POST /api/v1/asistente/conversaciones`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dada una respuesta correcta de `POST /api/v1/asistente/resumen-chat`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-05:** Dada una respuesta 401 de `POST /api/v1/asistente/resumen-chat`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-06:** Dadas las respuestas 403, 429 `ai_daily_limit_reached` de `POST /api/v1/asistente/resumen-chat`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-07:** Dada una respuesta correcta de `POST /api/v1/asistente/borrador-cotizacion`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-08:** Dada una respuesta 401 de `POST /api/v1/asistente/borrador-cotizacion`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-09:** Dadas las respuestas 403, 429 `ai_daily_limit_reached` de `POST /api/v1/asistente/borrador-cotizacion`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-10:** Dada una respuesta correcta de `GET /api/v1/asistente/rango-precio`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-11:** Dada una respuesta 401 de `GET /api/v1/asistente/rango-precio`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-12:** Dadas las respuestas 403 de `GET /api/v1/asistente/rango-precio`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-13:** Dada una consulta de `/api/v1/asistente/rango-precio` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-14:** Dada una respuesta correcta de `PUT /api/v1/asistente/bitacora/{solicitudId}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-15:** Dada una respuesta 401 de `PUT /api/v1/asistente/bitacora/{solicitudId}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-16:** Dadas las respuestas 403 de `PUT /api/v1/asistente/bitacora/{solicitudId}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-17:** Dada una respuesta correcta de `GET /api/v1/asistente/bitacora/{solicitudId}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-18:** Dada una respuesta 401 de `GET /api/v1/asistente/bitacora/{solicitudId}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-19:** Dadas las respuestas 403, 404 `log_not_found` de `GET /api/v1/asistente/bitacora/{solicitudId}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-20:** Dada la pantalla «Asistente Knock (No sé cuál)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-21:** Dada la pantalla «Mensajes del técnico (Resumir la conversación)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-22:** Dada la pantalla «Chat del técnico (Armar cotización con IA)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-23:** Dada la pantalla «Cotizar», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-24:** Dada la pantalla «Chat del técnico (Guardar en bitácora)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-25:** Dada la pantalla «Iniciar trabajo», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-26:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-27:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-28:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Asistente Knock (No sé cuál)» (endpoints ASI-01).
- Pantalla «Mensajes del técnico (Resumir la conversación)» (endpoints ASI-02).
- Pantalla «Chat del técnico (Armar cotización con IA)» (endpoints ASI-03).
- Pantalla «Cotizar» (endpoints ASI-04).
- Pantalla «Chat del técnico (Guardar en bitácora)» (endpoints ASI-05).
- Pantalla «Iniciar trabajo» (endpoints ASI-06).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 052.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 052 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/asistente/conversaciones` | Un turno con el asistente Knock: clasifica la categoría, pide la foto y arma la solicitud. Si detec… | Cuerpo: mensaje, foto opcional, contexto | 200 | 200; 400; 401; 422; 429 (límite de gasto) |
| `POST /api/v1/asistente/resumen-chat` | Resume la conversación: lo que se sabe, por confirmar y qué llevar | Cuerpo: conversacionId | 200 | 200; 401; 403; 429 |
| `POST /api/v1/asistente/borrador-cotizacion` | Borrador editable de cotización (precio, tiempo, día y nota) que explica qué tomó en cuenta | Cuerpo: conversacionId | 200 | 200; 401; 403; 429 |
| `GET /api/v1/asistente/rango-precio` | Rango de precio sugerido por aprendizaje automático | Query: oficio, tipoTrabajo | 200 | 200; 401; 403 |
| `PUT /api/v1/asistente/bitacora/{solicitudId}` | Guarda el resumen en la bitácora del técnico | Ruta: solicitudId. Cuerpo: sabe, porConfirmar, queLlevar | 200 | 200; 201; 400; 401; 403 |
| `GET /api/v1/asistente/bitacora/{solicitudId}` | Lee la bitácora guardada al iniciar el trabajo | Ruta: solicitudId | 200 | 200; 401; 403; 404 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-06, CA-09, CA-12, CA-16, CA-19 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-05, CA-08, CA-11, CA-15, CA-18 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-28 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-26 a CA-27 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Asistente Knock (No sé cuál) | carga, con datos, vacío, error, sin conexión | ASI-01 | claves `asistente*` en `app_es.arb` y `app_en.arb` |
| Mensajes del técnico (Resumir la conversación) | carga, con datos, vacío, error, sin conexión | ASI-02 | claves `asistente*` en `app_es.arb` y `app_en.arb` |
| Chat del técnico (Armar cotización con IA) | carga, con datos, vacío, error, sin conexión | ASI-03 | claves `asistente*` en `app_es.arb` y `app_en.arb` |
| Cotizar | carga, con datos, vacío, error, sin conexión | ASI-04 | claves `asistente*` en `app_es.arb` y `app_en.arb` |
| Chat del técnico (Guardar en bitácora) | carga, con datos, vacío, error, sin conexión | ASI-05 | claves `asistente*` en `app_es.arb` y `app_en.arb` |
| Iniciar trabajo | carga, con datos, vacío, error, sin conexión | ASI-06 | claves `asistente*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-28 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 042`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/asistente/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 052 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 024.
- Backend 030.
- Backend 031.
**Prerrequisitos que hoy no existen (trabajo pendiente, no capacidades implementadas):**
- Recurso de Azure OpenAI y cliente de la spec 024 (el recurso no está en Terraform; autorizado con límites)
- Filtro de datos personales y `uso_ia` de la spec 024 (hoy no implementados)
- Cálculo de la referencia de mercado de la spec 048 (hoy no implementado)

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 042` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** El asistente se muestra con la etiqueta «generado por IA» y un botón para editar antes de confirmar.
- **D-04:** Si el servicio responde 503 o 429, la pantalla del asistente se oculta o avisa y el flujo manual sigue disponible.
- **D-05:** Las correcciones de la revisión del 2026-11-13 están en la §14 de la spec de backend 052 y se reflejan en esta spec.

## 13. Riesgos y dudas abiertas
- Sin dudas abiertas: todas las decisiones de esta spec quedaron resueltas en el cierre del 2026-11-13.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
