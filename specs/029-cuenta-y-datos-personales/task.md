# Tareas 029 — Cuenta y datos personales: cambio de número, recuperación de acceso, exportación, consentimientos y eliminación (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 039 y regenerar el cliente Dart | §4 | Backend 039 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-04, CA-07, CA-10, CA-13, CA-15, CA-17, CA-19, CA-22 | — | T-01 | pendiente |
| T-03 | Repositorio de `POST /api/v1/me/cambio-numero` (USR-03) y mapeo de errores | §4 · CA-01 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `POST /api/v1/me/cambio-numero/confirmar` (USR-04) y mapeo de errores | §4 · CA-04 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/recuperacion-acceso` (USR-05) y mapeo de errores | §4 · CA-07 a CA-09 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `POST /api/v1/me/exportaciones` (USR-06) y mapeo de errores | §4 · CA-10 a CA-12 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `GET /api/v1/me/consentimientos` (USR-07) y mapeo de errores | §4 · CA-13 a CA-16 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Repositorio de `PUT /api/v1/me/consentimientos` (USR-08) y mapeo de errores | §4 · CA-13 a CA-16 | T-01, T-02 | otras rutas | pendiente |
| T-09 | Repositorio de `GET /api/v1/me/pendientes` (USR-09) y mapeo de errores | §4 · CA-17 a CA-18 | T-01, T-02 | otras rutas | pendiente |
| T-10 | Repositorio de `POST /api/v1/me/eliminacion` (USR-10) y mapeo de errores | §4 · CA-19 a CA-24 | T-01, T-02 | otras rutas | pendiente |
| T-11 | Repositorio de `POST /api/v1/me/eliminacion/cancelar` (USR-11) y mapeo de errores | §4 · CA-22 a CA-24 | T-01, T-02 | otras rutas | pendiente |
| T-12 | Pantalla «Mis datos»: estados, textos es/en, 48 dp y semántica | §7 · CA-25 | T-02 y su repositorio | otras pantallas | pendiente |
| T-13 | Pantalla «Inicio de sesión (¿Ya no tienes ese número?)»: estados, textos es/en, 48 dp y semántica | §7 · CA-26 | T-02 y su repositorio | otras pantallas | pendiente |
| T-14 | Pantalla «Privacidad y datos»: estados, textos es/en, 48 dp y semántica | §7 · CA-27 | T-02 y su repositorio | otras pantallas | pendiente |
| T-15 | Pantalla «Eliminar cuenta (paso 1)»: estados, textos es/en, 48 dp y semántica | §7 · CA-28 | T-02 y su repositorio | otras pantallas | pendiente |
| T-16 | Pantalla «Eliminar cuenta (paso 2)»: estados, textos es/en, 48 dp y semántica | §7 · CA-29 | T-02 y su repositorio | otras pantallas | pendiente |
| T-17 | Pantalla «Eliminada»: estados, textos es/en, 48 dp y semántica | §7 · CA-30 | T-02 y su repositorio | otras pantallas | pendiente |
| T-18 | Pantalla «Mi cuenta»: estados, textos es/en, 48 dp y semántica | §7 · CA-31 | T-02 y su repositorio | otras pantallas | pendiente |
| T-19 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-08, CA-11, CA-14, CA-16, CA-18, CA-20, CA-23, CA-32 a CA-34 | T-02 | — | pendiente |
| T-20 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
