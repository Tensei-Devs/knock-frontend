# Spec 035 — Catálogo de oficios, oficios pedidos y lista de espera (consulta interna) (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints OFI-02, OFI-03, OFI-04, OFI-05, OFP-01, OFP-02, LIS-02.
> **Claves de trabajo:** por asignar (se crea la tarea de Jira cuando se decida el alcance) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 045). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 045 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 045 en la app móvil: Como persona, quiero pedir un oficio que no existe y, como personal interno, administrar el catálogo y ver la lista de espera, para ampliar la cobertura con datos reales.

## 2. Historia y casos de prueba
**Historia:** Como persona, quiero pedir un oficio que no existe y, como personal interno, administrar el catálogo y ver la lista de espera, para ampliar la cobertura con datos reales.

- **CA-01:** Dada una respuesta correcta de `GET /api/v1/oficios/{clave}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `GET /api/v1/oficios/{clave}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 404 de `GET /api/v1/oficios/{clave}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dada una consulta de `/api/v1/oficios/{clave}` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-05:** Dada una respuesta correcta de `GET /api/v1/admin/oficios`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-06:** Dada una respuesta 401 de `GET /api/v1/admin/oficios`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-07:** Dadas las respuestas 403 de `GET /api/v1/admin/oficios`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-08:** Dada una respuesta correcta de `POST /api/v1/admin/oficios`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-09:** Dada una respuesta 401 de `POST /api/v1/admin/oficios`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-10:** Dadas las respuestas 403, 409 de `POST /api/v1/admin/oficios`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-11:** Dada una respuesta correcta de `PUT /api/v1/admin/oficios/{clave}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-12:** Dada una respuesta 401 de `PUT /api/v1/admin/oficios/{clave}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-13:** Dadas las respuestas 403, 404 de `PUT /api/v1/admin/oficios/{clave}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-14:** Dada una respuesta correcta de `POST /api/v1/oficios-pedidos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-15:** Dada una respuesta 401 de `POST /api/v1/oficios-pedidos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-16:** Dada una respuesta correcta de `GET /api/v1/admin/oficios-pedidos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-17:** Dada una respuesta 401 de `GET /api/v1/admin/oficios-pedidos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-18:** Dadas las respuestas 403 de `GET /api/v1/admin/oficios-pedidos`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-19:** Dado un listado de `/api/v1/admin/oficios-pedidos`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-20:** Dada una respuesta correcta de `GET /api/v1/admin/lista-espera`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-21:** Dada una respuesta 401 de `GET /api/v1/admin/lista-espera`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-22:** Dadas las respuestas 403 de `GET /api/v1/admin/lista-espera`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-23:** Dado un listado de `/api/v1/admin/lista-espera`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-24:** Dada la pantalla «Pedir cotización», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-25:** Dada la pantalla «Panel de administración», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-26:** Dada la pantalla «Registro de técnico», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-27:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-28:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-29:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Pedir cotización» (endpoints OFI-02).
- Pantalla «Panel de administración» (endpoints OFI-03, OFI-04, OFI-05, OFP-02, LIS-02).
- Pantalla «Registro de técnico» (endpoints OFP-01).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 045.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 045 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/oficios/{clave}` | Detalle de un oficio | Ruta: clave | 200 | 200; 404 |
| `GET /api/v1/admin/oficios` | Lista todos los oficios, incluidos los inactivos | Ninguno | 200 | 200; 401; 403 |
| `POST /api/v1/admin/oficios` | Crea un oficio nuevo | Cuerpo: clave, nombre, modalidad, parámetros | 201 | 201; 400; 401; 403; 409 |
| `PUT /api/v1/admin/oficios/{clave}` | Edita un oficio y sus parámetros de precio. Invalida la caché | Ruta: clave. Cuerpo: campos | 200 | 200; 400; 401; 403; 404 |
| `POST /api/v1/oficios-pedidos` | Guarda el oficio escrito en Otro oficio | Cuerpo: texto | 201 | 201; 400; 401 |
| `GET /api/v1/admin/oficios-pedidos` | Oficios más pedidos, agrupados y contados | Ninguno | 200 | 200; 401; 403 |
| `GET /api/v1/admin/lista-espera` | Cuántas personas esperan por zona | Ninguno | 200 | 200; 401; 403 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-07, CA-10, CA-13, CA-18, CA-22 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-06, CA-09, CA-12, CA-15, CA-17, CA-21 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-29 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-27 a CA-28 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Pedir cotización | carga, con datos, vacío, error, sin conexión | OFI-02 | claves `catalogos*` en `app_es.arb` y `app_en.arb` |
| Panel de administración | carga, con datos, vacío, error, sin conexión | OFI-03, OFI-04, OFI-05, OFP-02, LIS-02 | claves `catalogos*` en `app_es.arb` y `app_en.arb` |
| Registro de técnico | carga, con datos, vacío, error, sin conexión | OFP-01 | claves `catalogos*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-29 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 035`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/catalogos/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 045 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 023.
- Backend 033.

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 035` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.

## 13. Riesgos y dudas abiertas
- Las rutas de administración exigen el panel con doble factor (spec 033): confirmar los roles que pueden crear y editar oficios.
- La lista de espera ya se escribe con la spec 023; aquí solo se agrega su lectura interna.
- Esta spec se generó a partir del Excel; antes de aprobarla hay que revisar textos y diseño contra la maqueta.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
