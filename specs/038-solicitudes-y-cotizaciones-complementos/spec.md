# Spec 038 — Solicitudes y cotizaciones: ampliar, archivos, referencia de mercado y cotizaciones del técnico (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints SOL-05, SOL-08, COT-03, COT-05.
> **Claves de trabajo:** por asignar (se crea la tarea de Jira cuando se decida el alcance) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 048). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 048 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 048 en la app móvil: Como cliente quiero ampliar mi solicitud y ver sus archivos, y como técnico ver mis cotizaciones y una referencia de mercado, para negociar con información clara.

## 2. Historia y casos de prueba
**Historia:** Como cliente quiero ampliar mi solicitud y ver sus archivos, y como técnico ver mis cotizaciones y una referencia de mercado, para negociar con información clara.

- **CA-01:** Dada una respuesta correcta de `POST /api/v1/solicitudes/{id}/ampliar`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `POST /api/v1/solicitudes/{id}/ampliar`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 403, 404, 409 `request_not_extendable` de `POST /api/v1/solicitudes/{id}/ampliar`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dada una respuesta correcta de `GET /api/v1/solicitudes/{id}/archivos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-05:** Dada una respuesta 401 de `GET /api/v1/solicitudes/{id}/archivos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-06:** Dadas las respuestas 403, 404 de `GET /api/v1/solicitudes/{id}/archivos`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-07:** Dada una respuesta correcta de `GET /api/v1/cotizaciones/referencia-mercado`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-08:** Dada una respuesta 401 de `GET /api/v1/cotizaciones/referencia-mercado`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-09:** Dadas las respuestas 403 de `GET /api/v1/cotizaciones/referencia-mercado`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-10:** Dada una consulta de `/api/v1/cotizaciones/referencia-mercado` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-11:** Dada una respuesta correcta de `GET /api/v1/tecnicos/me/cotizaciones`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-12:** Dada una respuesta 401 de `GET /api/v1/tecnicos/me/cotizaciones`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-13:** Dadas las respuestas 403 de `GET /api/v1/tecnicos/me/cotizaciones`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-14:** Dado un listado de `/api/v1/tecnicos/me/cotizaciones`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-15:** Dada la pantalla «Mensajes (técnico no responde)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-16:** Dada la pantalla «Trabajo», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-17:** Dada la pantalla «Chat», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-18:** Dada la pantalla «Cotizar (Referencia del mercado)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-19:** Dada la pantalla «Trabajo (Cotizaciones enviadas)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-20:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-21:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-22:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Mensajes (técnico no responde)» (endpoints SOL-05).
- Pantalla «Trabajo» (endpoints SOL-08).
- Pantalla «Chat» (endpoints SOL-08).
- Pantalla «Cotizar (Referencia del mercado)» (endpoints COT-03).
- Pantalla «Trabajo (Cotizaciones enviadas)» (endpoints COT-05).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 048.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 048 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/solicitudes/{id}/ampliar` | Pide también a más técnicos (Pedir también a otros) | Ruta: id | 200 | 200; 401; 403; 404; 409 |
| `GET /api/v1/solicitudes/{id}/archivos` | Enlaces temporales de las fotos de la solicitud (para el técnico incluido) | Ruta: id | 200 | 200; 401; 403; 404 |
| `GET /api/v1/cotizaciones/referencia-mercado` | Rango de lo que cobran otros técnicos por trabajos parecidos (cotizaciones aceptadas en 90 días, pe… | Query: oficio, tipoTrabajo | 200 | 200; 401; 403 |
| `GET /api/v1/tecnicos/me/cotizaciones` | Cotizaciones enviadas por el técnico con su estado (esperando respuesta, aceptada) | Query: estado, cursor, limite | 200 | 200; 401; 403 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-06, CA-09, CA-13 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-05, CA-08, CA-12 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-22 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-20 a CA-21 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Mensajes (técnico no responde) | carga, con datos, vacío, error, sin conexión | SOL-05 | claves `solicitudes*` en `app_es.arb` y `app_en.arb` |
| Trabajo | carga, con datos, vacío, error, sin conexión | SOL-08 | claves `solicitudes*` en `app_es.arb` y `app_en.arb` |
| Chat | carga, con datos, vacío, error, sin conexión | SOL-08 | claves `solicitudes*` en `app_es.arb` y `app_en.arb` |
| Cotizar (Referencia del mercado) | carga, con datos, vacío, error, sin conexión | COT-03 | claves `solicitudes*` en `app_es.arb` y `app_en.arb` |
| Trabajo (Cotizaciones enviadas) | carga, con datos, vacío, error, sin conexión | COT-05 | claves `solicitudes*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-22 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 038`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/solicitudes/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 048 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 020.
- Backend 021.
- Backend 030.
- Backend 032.

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 038` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** La referencia de mercado es una tarjeta dentro del formulario de cotizar, no una pantalla aparte.
- **D-04:** Las fotos de la solicitud se piden al abrir el detalle y no se guardan en el teléfono.

## 13. Riesgos y dudas abiertas
- Confirmar si ampliar tiene un límite diario por persona o algún costo.
- Confirmar con la spec 032 que 5 minutos es una vigencia válida para los enlaces (la spec permite un rango).
- Si faltan cotizaciones aceptadas en la categoría, se propone mostrar el rango general; confirmar que no se debe ocultar la tarjeta.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
