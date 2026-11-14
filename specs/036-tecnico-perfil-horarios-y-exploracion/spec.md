# Spec 036 — Técnico: perfil, horarios, disponibilidad, mapa y explorar (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints TEC-01, TEC-02, TEC-03, TEC-04, TEC-05, TEC-06, TEC-07, TEC-08, TEC-09, TEC-10, TEC-11, TEC-13, TEC-14.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 046). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 046 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 046 en la app móvil: Como técnico, quiero crear mi perfil, definir mis horarios y mi disponibilidad, y como cliente quiero explorar técnicos en el mapa, para encontrar a la persona adecuada cerca de mí.

## 2. Historia y casos de prueba
**Historia:** Como técnico, quiero crear mi perfil, definir mis horarios y mi disponibilidad, y como cliente quiero explorar técnicos en el mapa, para encontrar a la persona adecuada cerca de mí.

- **CA-01:** Dada una respuesta correcta de `POST /api/v1/tecnicos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `POST /api/v1/tecnicos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 409 `already_a_technician`, 422 de `POST /api/v1/tecnicos`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dada una respuesta correcta de `GET /api/v1/tecnicos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-05:** Dada una respuesta 401 de `GET /api/v1/tecnicos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-06:** Dado un listado de `/api/v1/tecnicos`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-07:** Dada una consulta de `/api/v1/tecnicos` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-08:** Dada una respuesta correcta de `GET /api/v1/tecnicos/autocompletar`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-09:** Dada una respuesta 401 de `GET /api/v1/tecnicos/autocompletar`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-10:** Dada una consulta de `/api/v1/tecnicos/autocompletar` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-11:** Dada una respuesta correcta de `GET /api/v1/mapa/tecnicos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-12:** Dada una respuesta 401 de `GET /api/v1/mapa/tecnicos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-13:** Dada una consulta de `/api/v1/mapa/tecnicos` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-14:** Dada una respuesta correcta de `GET /api/v1/tecnicos/{id}`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-15:** Dada una respuesta 401 de `GET /api/v1/tecnicos/{id}`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-16:** Dadas las respuestas 404 `technician_not_found` de `GET /api/v1/tecnicos/{id}`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-17:** Dada una consulta de `/api/v1/tecnicos/{id}` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-18:** Dada una respuesta correcta de `GET /api/v1/tecnicos/{id}/llega-a-mi-colonia`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-19:** Dada una respuesta 401 de `GET /api/v1/tecnicos/{id}/llega-a-mi-colonia`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-20:** Dadas las respuestas 404 `technician_not_found` de `GET /api/v1/tecnicos/{id}/llega-a-mi-colonia`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-21:** Dada una consulta de `/api/v1/tecnicos/{id}/llega-a-mi-colonia` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-22:** Dada una respuesta correcta de `GET /api/v1/tecnicos/{id}/fotos-trabajos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-23:** Dada una respuesta 401 de `GET /api/v1/tecnicos/{id}/fotos-trabajos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-24:** Dadas las respuestas 404 `technician_not_found` de `GET /api/v1/tecnicos/{id}/fotos-trabajos`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-25:** Dado un listado de `/api/v1/tecnicos/{id}/fotos-trabajos`, cuando la persona llega al final, entonces pide la página siguiente con el cursor y no repite elementos. · Verificación: prueba de widget con repositorio falso.
- **CA-26:** Dada una consulta de `/api/v1/tecnicos/{id}/fotos-trabajos` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-27:** Dada una respuesta correcta de `PUT /api/v1/tecnicos/me`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-28:** Dada una respuesta 401 de `PUT /api/v1/tecnicos/me`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-29:** Dadas las respuestas 422 de `PUT /api/v1/tecnicos/me`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-30:** Dada una respuesta correcta de `PUT /api/v1/tecnicos/me/disponibilidad`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-31:** Dada una respuesta 401 de `PUT /api/v1/tecnicos/me/disponibilidad`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-32:** Dadas las respuestas 403 de `PUT /api/v1/tecnicos/me/disponibilidad`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-33:** Dada una respuesta correcta de `GET /api/v1/tecnicos/me/horarios`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-34:** Dada una respuesta 401 de `GET /api/v1/tecnicos/me/horarios`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-35:** Dada una respuesta correcta de `PUT /api/v1/tecnicos/me/horarios`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-36:** Dada una respuesta 401 de `PUT /api/v1/tecnicos/me/horarios`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-37:** Dada una respuesta correcta de `GET /api/v1/tecnicos/me/reputacion`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-38:** Dada una respuesta 401 de `GET /api/v1/tecnicos/me/reputacion`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-39:** Dada una consulta de `/api/v1/tecnicos/me/reputacion` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-40:** Dada una respuesta correcta de `GET /api/v1/explorar`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-41:** Dada una respuesta 401 de `GET /api/v1/explorar`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-42:** Dada una consulta de `/api/v1/explorar` ya hecha, cuando la persona vuelve a abrirla sin conexión, entonces ve la última copia con su fecha y un aviso de que puede estar desactualizada. · Verificación: prueba de widget.
- **CA-43:** Dada la pantalla «Registrarse como técnico», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-44:** Dada la pantalla «Inicio (lista)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-45:** Dada la pantalla «Buscar», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-46:** Dada la pantalla «Explorar», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-47:** Dada la pantalla «Inicio (barra de búsqueda)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-48:** Dada la pantalla «Inicio (mapa)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-49:** Dada la pantalla «Perfil del técnico», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-50:** Dada la pantalla «Explorar (Trabajos reales)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-51:** Dada la pantalla «Mi perfil público», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-52:** Dada la pantalla «Mi negocio», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-53:** Dada la pantalla «Trabajo», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-54:** Dada la pantalla «Mi reputación», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-55:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-56:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-57:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Registrarse como técnico» (endpoints TEC-01).
- Pantalla «Inicio (lista)» (endpoints TEC-02).
- Pantalla «Buscar» (endpoints TEC-02, TEC-03).
- Pantalla «Explorar» (endpoints TEC-02, TEC-14).
- Pantalla «Inicio (barra de búsqueda)» (endpoints TEC-03).
- Pantalla «Inicio (mapa)» (endpoints TEC-04).
- Pantalla «Perfil del técnico» (endpoints TEC-05, TEC-06, TEC-07).
- Pantalla «Explorar (Trabajos reales)» (endpoints TEC-07).
- Pantalla «Mi perfil público» (endpoints TEC-08, TEC-10, TEC-11).
- Pantalla «Mi negocio» (endpoints TEC-08).
- Pantalla «Trabajo» (endpoints TEC-09).
- Pantalla «Mi reputación» (endpoints TEC-13).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 046.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 046 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/tecnicos` | Registra a la persona como técnico (nombre y apellido, oficios, taller o domicilio, radio, perfil o… | Cuerpo: oficios, atencion, direccionTaller o radioKm, perfil opcional, aceptaTerminos | 201 | 201; 400; 401; 409 (ya es técnico); 422 |
| `GET /api/v1/tecnicos` | Busca técnicos por oficio, colonia, distancia o radio, Disponible hoy, solo verificados y texto lib… | Query: oficio, colonia, lat, lng, radioKm, disponibleHoy, soloVerificados, q, orden, curs… | 200 | 200; 400 |
| `GET /api/v1/tecnicos/autocompletar` | Sugerencias de oficios, servicios y negocios mientras se escribe (por ejemplo, boiler, frenos) | Query: q (mínimo 2 caracteres) | 200 | 200; 400 |
| `GET /api/v1/mapa/tecnicos` | Técnicos de la zona visible del mapa, ya agrupados, para no mandarlos todos | Query: norte, sur, este, oeste, oficio, zoom | 200 | 200; 400 |
| `GET /api/v1/tecnicos/{id}` | Perfil del técnico. Sin sesión devuelve solo el resumen (foto, verificación, calificación, experien… | Ruta: id | 200 | 200; 404 |
| `GET /api/v1/tecnicos/{id}/llega-a-mi-colonia` | Dice si el técnico atiende la colonia de la persona | Ruta: id. Query: colonia | 200 | 200; 401; 404 |
| `GET /api/v1/tecnicos/{id}/fotos-trabajos` | Fotos de trabajos terminados que el cliente permitió publicar | Ruta: id | 200 | 200; 401; 404 |
| `PUT /api/v1/tecnicos/me` | Edita el perfil público: negocio, años, oficios, forma de atención, radio, descripción, foto | Cuerpo: campos a cambiar | 200 | 200; 400; 401; 422 |
| `PUT /api/v1/tecnicos/me/disponibilidad` | Cambia el interruptor Disponible hoy | Cuerpo: disponibleHoy | 200 | 200; 401; 403 |
| `GET /api/v1/tecnicos/me/horarios` | Horarios del técnico | Ninguno | 200 | 200; 401 |
| `PUT /api/v1/tecnicos/me/horarios` | Cambia abierto o cerrado por día | Cuerpo: horarios | 200 | 200; 400; 401 |
| `GET /api/v1/tecnicos/me/reputacion` | Calificación promedio, distribución por estrellas y nivel | Ninguno | 200 | 200; 401 |
| `GET /api/v1/explorar` | Bloques de la pestaña Explorar: servicios populares, trabajos reales, cerca de ti, mejor calificado… | Query: filtro (todo/auto/agua/luz), colonia | 200 | 200 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-16, CA-20, CA-24, CA-29, CA-32 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-05, CA-09, CA-12, CA-15, CA-19, CA-23, CA-28, CA-31, CA-34, CA-36, CA-38, CA-41 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-57 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-55 a CA-56 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Registrarse como técnico | carga, con datos, vacío, error, sin conexión | TEC-01 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Inicio (lista) | carga, con datos, vacío, error, sin conexión | TEC-02 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Buscar | carga, con datos, vacío, error, sin conexión | TEC-02, TEC-03 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Explorar | carga, con datos, vacío, error, sin conexión | TEC-02, TEC-14 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Inicio (barra de búsqueda) | carga, con datos, vacío, error, sin conexión | TEC-03 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Inicio (mapa) | carga, con datos, vacío, error, sin conexión | TEC-04 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Perfil del técnico | carga, con datos, vacío, error, sin conexión | TEC-05, TEC-06, TEC-07 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Explorar (Trabajos reales) | carga, con datos, vacío, error, sin conexión | TEC-07 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Mi perfil público | carga, con datos, vacío, error, sin conexión | TEC-08, TEC-10, TEC-11 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Mi negocio | carga, con datos, vacío, error, sin conexión | TEC-08 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Trabajo | carga, con datos, vacío, error, sin conexión | TEC-09 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |
| Mi reputación | carga, con datos, vacío, error, sin conexión | TEC-13 | claves `tecnico*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-57 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 036`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/tecnico/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 046 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 023.
- Backend 025.
- Backend 027.
- Backend 036.

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 036` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** La búsqueda por texto vive en la spec 021 de la app; Explorar y el mapa usan `/explorar` y `/mapa/tecnicos`.
- **D-04:** El interruptor «Disponible hoy» muestra un aviso si el técnico aún no está verificado.

## 13. Riesgos y dudas abiertas
- Confirmar con diseño el mapa con grupos de técnicos (agrupación por zoom) contra la maqueta.
- Confirmar el flujo de registro como técnico y su conexión con la verificación (spec 018).

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
