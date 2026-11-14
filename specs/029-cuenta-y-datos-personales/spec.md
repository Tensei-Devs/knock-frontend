# Spec 029 — Cuenta y datos personales: cambio de número, recuperación de acceso, exportación, consentimientos y eliminación (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Origen:** `Documentacion/00_Profesores/Desarrollo_Movil/Entregables/Knock_Endpoints_CRUD.xlsx` (revisión 2026-11-02): endpoints USR-03, USR-04, USR-05, USR-06, USR-07, USR-08, USR-09, USR-10, USR-11.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas de las specs de los endpoints del Excel) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (spec 039). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 039 y se vendoriza antes de implementar (spec 006).

## 1. Objetivo
Definir las pantallas, los estados y el consumo del contrato de backend 039 en la app móvil: Como persona con cuenta, quiero cambiar mi número, recuperar mi acceso, exportar mis datos, revisar mis consentimientos y eliminar mi cuenta, para tener control de mis datos personales.

## 2. Historia y casos de prueba
**Historia:** Como persona con cuenta, quiero cambiar mi número, recuperar mi acceso, exportar mis datos, revisar mis consentimientos y eliminar mi cuenta, para tener control de mis datos personales.

- **CA-01:** Dada una respuesta correcta de `POST /api/v1/me/cambio-numero`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-02:** Dada una respuesta 401 de `POST /api/v1/me/cambio-numero`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-03:** Dadas las respuestas 409 `phone_already_registered`, 429 de `POST /api/v1/me/cambio-numero`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-04:** Dada una respuesta correcta de `POST /api/v1/me/cambio-numero/confirmar`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-05:** Dada una respuesta 401 de `POST /api/v1/me/cambio-numero/confirmar`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-06:** Dadas las respuestas 409, 429 de `POST /api/v1/me/cambio-numero/confirmar`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-07:** Dada una respuesta correcta de `POST /api/v1/recuperacion-acceso`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-08:** Dada una respuesta 401 de `POST /api/v1/recuperacion-acceso`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-09:** Dadas las respuestas 429 de `POST /api/v1/recuperacion-acceso`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-10:** Dada una respuesta correcta de `POST /api/v1/me/exportaciones`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-11:** Dada una respuesta 401 de `POST /api/v1/me/exportaciones`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-12:** Dadas las respuestas 409 `export_in_progress`, 429 de `POST /api/v1/me/exportaciones`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-13:** Dada una respuesta correcta de `GET /api/v1/me/consentimientos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-14:** Dada una respuesta 401 de `GET /api/v1/me/consentimientos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-15:** Dada una respuesta correcta de `PUT /api/v1/me/consentimientos`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-16:** Dada una respuesta 401 de `PUT /api/v1/me/consentimientos`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-17:** Dada una respuesta correcta de `GET /api/v1/me/pendientes`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-18:** Dada una respuesta 401 de `GET /api/v1/me/pendientes`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-19:** Dada una respuesta correcta de `POST /api/v1/me/eliminacion`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-20:** Dada una respuesta 401 de `POST /api/v1/me/eliminacion`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-21:** Dadas las respuestas 409 `deletion_not_allowed`, 429 de `POST /api/v1/me/eliminacion`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-22:** Dada una respuesta correcta de `POST /api/v1/me/eliminacion/cancelar`, cuando la app la recibe, entonces la pantalla muestra el resultado y el modelo de la app no incluye campos que el contrato no declara. · Verificación: prueba unitaria del repositorio con el cliente generado.
- **CA-23:** Dada una respuesta 401 de `POST /api/v1/me/eliminacion/cancelar`, cuando la app la recibe, entonces cierra la sesión local y manda a la entrada, sin mostrar datos. · Verificación: prueba unitaria.
- **CA-24:** Dadas las respuestas 409 `no_deletion_scheduled` de `POST /api/v1/me/eliminacion/cancelar`, cuando la app las recibe, entonces muestra el mensaje del catálogo de errores (en español e inglés) y conserva lo que la persona escribió. · Verificación: prueba de widget por código.
- **CA-25:** Dada la pantalla «Mis datos», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-26:** Dada la pantalla «Inicio de sesión (¿Ya no tienes ese número?)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-27:** Dada la pantalla «Privacidad y datos», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-28:** Dada la pantalla «Eliminar cuenta (paso 1)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-29:** Dada la pantalla «Eliminar cuenta (paso 2)», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-30:** Dada la pantalla «Eliminada», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-31:** Dada la pantalla «Mi cuenta», cuando carga, está vacía, falla o no hay conexión, entonces muestra cada estado con su texto y un botón de reintentar. · Verificación: prueba de widget por estado.
- **CA-32:** Dados el español y el inglés, cuando se muestran las pantallas de esta spec, entonces todos los textos salen del ARB del idioma activo, sin texto fijo en el código. · Verificación: prueba de widget por idioma.
- **CA-33:** Dadas las pantallas de esta spec, cuando se miden, entonces los controles tienen al menos 48 dp, descripción semántica y funcionan con texto al 200 %. · Verificación: guía de accesibilidad de Flutter.
- **CA-34:** Dada cualquier operación, cuando se inspeccionan los registros de la app, entonces no aparecen datos personales de la persona. · Verificación: prueba unitaria del registro.

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla «Mis datos» (endpoints USR-03, USR-04).
- Pantalla «Inicio de sesión (¿Ya no tienes ese número?)» (endpoints USR-05).
- Pantalla «Privacidad y datos» (endpoints USR-06, USR-07, USR-08).
- Pantalla «Eliminar cuenta (paso 1)» (endpoints USR-09).
- Pantalla «Eliminar cuenta (paso 2)» (endpoints USR-10).
- Pantalla «Eliminada» (endpoints USR-11).
- Pantalla «Mi cuenta» (endpoints USR-11).
- Repositorio, estado y mapeo de errores de cada ruta, con textos en español e inglés.

**Fuera**
- El servidor: lo define backend 039.
- Notificaciones push y permisos del teléfono (spec 012) y el cliente generado (spec 006).
- Cambios de diseño fuera de la maqueta (spec 014).

## 4. Contrato API y eventos
La app **consume**; el contrato lo fija backend 039 y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006).

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/me/cambio-numero` | Comprueba que el número nuevo no pertenece a otra cuenta, antes de que la app gaste un SMS de Fireb… | Cuerpo: celularNuevo (E.164 de México) | 204 | 204; 400; 401; 409 (el número ya pertenece a otra cuenta); 429 |
| `POST /api/v1/me/cambio-numero/confirmar` | Confirma el cambio con el token de Firebase del número nuevo, cambia el celular, cierra las demás s… | Cuerpo: firebaseIdToken (del número nuevo) | 200 | 200; 400; 401; 409 (el número ya pertenece a otra cuenta); 429 |
| `POST /api/v1/recuperacion-acceso` | Inicia la recuperación de acceso con el número nuevo verificado por Firebase; crea un caso para la… | Cuerpo: firebaseIdToken (del número nuevo), celularAnterior, tipo (tecnico/cliente) | 202 | 202; 400; 429 |
| `POST /api/v1/me/exportaciones` | Pide la descarga de todos los datos propios; se entrega en 48 horas | Ninguno | 202 | 202; 401; 409 (ya hay una en curso); 429 |
| `GET /api/v1/me/consentimientos` | Lista los consentimientos con su versión y fecha | Ninguno | 200 | 200; 401 |
| `PUT /api/v1/me/consentimientos` | Activa o retira consentimientos opcionales (promociones, encuestas, recomendaciones) | Cuerpo: tipo, vigente | 200 | 200; 400; 401 |
| `GET /api/v1/me/pendientes` | Lista lo que hay pendiente antes de eliminar la cuenta: citas y cotizaciones abiertas | Ninguno | 200 | 200; 401 |
| `POST /api/v1/me/eliminacion` | Programa la eliminación de la cuenta con 7 días de gracia; cancela de inmediato las solicitudes abi… | Cuerpo: confirmacion (el texto ELIMINAR), firebaseIdToken si la sesión tiene más de 24 ho… | 202 | 202; 400; 401; 409 (ya está programada o hay una visita en curso); 429 |
| `POST /api/v1/me/eliminacion/cancelar` | Cancela la eliminación durante los 7 días de gracia | Ninguno | 200 | 200; 401; 409 |

## 5. Modelo de datos local
No se guarda nada en el teléfono salvo lo marcado como «caché» en §4: la última copia de lo que el Excel declara cacheable, en el almacén de la app, sin direcciones exactas, teléfonos ni coordenadas, y se borra al cerrar la sesión.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Datos de otra persona en pantalla | La app pide solo lo suyo y trata 403 y 404 como «no disponible» | CA-03, CA-06, CA-09, CA-12, CA-21, CA-24 |
| Sesión vencida con datos visibles | 401 cierra la sesión y borra la copia local | CA-02, CA-05, CA-08, CA-11, CA-14, CA-16, CA-18, CA-20, CA-23 |
| Datos personales en registros | El registro no incluye teléfono, dirección ni textos escritos | CA-34 |
| Texto fijo o inaccesible | Textos en ARB; 48 dp y semántica | CA-32 a CA-33 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Endpoints | Textos nuevos (ARB) |
|---|---|---|---|
| Mis datos | carga, con datos, vacío, error, sin conexión | USR-03, USR-04 | claves `cuenta*` en `app_es.arb` y `app_en.arb` |
| Inicio de sesión (¿Ya no tienes ese número?) | carga, con datos, vacío, error, sin conexión | USR-05 | claves `cuenta*` en `app_es.arb` y `app_en.arb` |
| Privacidad y datos | carga, con datos, vacío, error, sin conexión | USR-06, USR-07, USR-08 | claves `cuenta*` en `app_es.arb` y `app_en.arb` |
| Eliminar cuenta (paso 1) | carga, con datos, vacío, error, sin conexión | USR-09 | claves `cuenta*` en `app_es.arb` y `app_en.arb` |
| Eliminar cuenta (paso 2) | carga, con datos, vacío, error, sin conexión | USR-10 | claves `cuenta*` en `app_es.arb` y `app_en.arb` |
| Eliminada | carga, con datos, vacío, error, sin conexión | USR-11 | claves `cuenta*` en `app_es.arb` y `app_en.arb` |
| Mi cuenta | carga, con datos, vacío, error, sin conexión | USR-11 | claves `cuenta*` en `app_es.arb` y `app_en.arb` |

**Mensajes por código:** cada código distinguido en §4 usa el texto del catálogo de errores de la spec 015 (`errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos`, `errorNoEncontrado`) y agrega los propios de esta spec en ambos idiomas.

## 8. Pruebas, gates y límites
| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Dominio, mapeo de respuestas y errores, borrado local |
| Widget (W) | Sí | Cada pantalla y estado, idiomas, accesibilidad |
| Aceptación (ACC) | Sí | CA-01 a CA-34 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) |
| Integración / E2E | No aplica | Se cubre con el humo manual en teléfono al integrar con el backend |

Puertas de CI: `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 029`, mapa de arquitectura y análisis de dependencias.

## 9. Arquitectura y componentes
- `features/cuenta/` con `domain/` (entidades y reglas), `data/` (repositorio sobre el cliente generado y su versión simulada) y `presentation/` (pantallas y estado con Riverpod).
- Rutas con go_router bajo la sección que corresponda; sin cambios en `contracts/` salvo la vendorización.

## 10. Dependencias con otras specs
- Backend 039 (contrato) y las specs 006, 009, 010, 014 y 026 de este repositorio.
- Backend 015.
- Backend 016.
- Backend 017.
- Backend 018.
- Backend 025.
**Prerrequisitos que hoy no existen (trabajo pendiente, no capacidades implementadas):**
- Rutas internas con el token de la spec 037: sus claves `avisos-key-*` y el secreto nuevo `interno-key-identity` (Identidad firma, Mercado verifica) en Key Vault y Terraform (hoy no implementados ni creados)
- Contenedor privado `exportaciones` en la cuenta de almacenamiento privada de la spec 025 (hoy no existe en Terraform)
- Ejecutor de tareas y bandeja de salida de la spec 054 (hoy no implementados)
- Cola del panel de la spec 053 y panel de la spec 033 (hoy no implementados)

## 11. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde y `sdd_lint --trace 029` sin faltantes.
- CI en verde, un par revisó el cambio y `Memoria.md` al día.
- Humo manual en teléfono con el backend desplegado.

## 12. Decisiones tomadas sin consulta
- **D-01:** Mientras el backend no publique el contrato se usa un repositorio simulado con las mismas reglas.
- **D-02:** Una pantalla por cada nombre de «Pantallas que lo usan» del Excel; los nombres exactos se afinan con la maqueta.
- **D-03:** Cambio de número: la app verifica el número nuevo con Firebase, comprueba disponibilidad primero y confirma con el token; la eliminación pide el texto `ELIMINAR` y muestra los pendientes antes.
- **D-04:** La recuperación de acceso se inicia desde la entrada con celular («¿Ya no tienes ese número?») y muestra un mensaje de «recibimos tu solicitud».
- **D-05:** Las correcciones de la revisión del 2026-11-13 están en la §14 de la spec de backend 039 y se reflejan en esta spec.

## 13. Riesgos y dudas abiertas
- Sin dudas abiertas: todas las decisiones de esta spec quedaron resueltas en el cierre del 2026-11-13.
- Dependencia: la app necesita Firebase para verificar el número nuevo (spec 012 y 015) y las pantallas del panel de la spec 043.

## Aprobación
- [ ] Revisor 1 — nombre: _____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
