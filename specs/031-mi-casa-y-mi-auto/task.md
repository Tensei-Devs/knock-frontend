# Tareas 031 — Mi casa y mi auto (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-00 | Prerrequisitos que hoy no existen y no son parte de esta spec: El campo opcional `elementoId` en `POST /solicitudes` (se agrega en una tarea de esta spec; la fundación de la 020 ya está en `sprint-04`); Ruta interna de historial con el secreto nuevo `interno-key-identity` (hoy no implementada ni creada) | §10 | — | T-01 | pendiente |
| T-01 | Vendorizar las rutas de backend 041 y regenerar el cliente Dart | §4 | Backend 041 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-03, CA-06, CA-09, CA-12 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/me/casa-y-auto` (CAS-01) y mapeo de errores | §4 · CA-01 a CA-15 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `POST /api/v1/me/casa-y-auto` (CAS-02) y mapeo de errores | §4 · CA-01 a CA-15 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `PUT /api/v1/me/casa-y-auto/{id}` (CAS-03) y mapeo de errores | §4 · CA-06 a CA-15 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `DELETE /api/v1/me/casa-y-auto/{id}` (CAS-04) y mapeo de errores | §4 · CA-06 a CA-15 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `GET /api/v1/me/casa-y-auto/{id}/historial` (CAS-05) y mapeo de errores | §4 · CA-12 a CA-15 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Pantalla «Mi casa y mi auto»: estados, textos es/en, 48 dp y semántica | §7 · CA-16 | T-02 y su repositorio | otras pantallas | pendiente |
| T-09 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-04, CA-07, CA-10, CA-13, CA-17 a CA-19 | T-02 | — | pendiente |
| T-10 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
