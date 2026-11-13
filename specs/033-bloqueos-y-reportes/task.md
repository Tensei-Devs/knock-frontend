# Tareas 033 — Bloqueos entre personas y reportes con apelación (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 043 y regenerar el cliente Dart | §4 | Backend 043 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-04, CA-07, CA-10, CA-13, CA-16 | — | T-01 | pendiente |
| T-03 | Repositorio de `POST /api/v1/usuarios/{id}/bloqueo` (BLO-01) y mapeo de errores | §4 · CA-01 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `DELETE /api/v1/usuarios/{id}/bloqueo` (BLO-02) y mapeo de errores | §4 · CA-01 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `GET /api/v1/me/bloqueos` (BLO-03) y mapeo de errores | §4 · CA-07 a CA-09 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `POST /api/v1/reportes` (REP-01) y mapeo de errores | §4 · CA-10 a CA-18 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `GET /api/v1/reportes/me` (REP-02) y mapeo de errores | §4 · CA-13 a CA-15 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Repositorio de `POST /api/v1/reportes/{id}/apelacion` (REP-03) y mapeo de errores | §4 · CA-16 a CA-18 | T-01, T-02 | otras rutas | pendiente |
| T-09 | Pantalla «Chat (menú Bloquear)»: estados, textos es/en, 48 dp y semántica | §7 · CA-19 | T-02 y su repositorio | otras pantallas | pendiente |
| T-10 | Pantalla «Chat (Desbloquear)»: estados, textos es/en, 48 dp y semántica | §7 · CA-20 | T-02 y su repositorio | otras pantallas | pendiente |
| T-11 | Pantalla «Chat»: estados, textos es/en, 48 dp y semántica | §7 · CA-19 a CA-21 | T-02 y su repositorio | otras pantallas | pendiente |
| T-12 | Pantalla «Reportar un problema»: estados, textos es/en, 48 dp y semántica | §7 · CA-22 | T-02 y su repositorio | otras pantallas | pendiente |
| T-13 | Pantalla «Reportar»: estados, textos es/en, 48 dp y semántica | §7 · CA-22 a CA-23 | T-02 y su repositorio | otras pantallas | pendiente |
| T-14 | Pantalla «Centro de ayuda»: estados, textos es/en, 48 dp y semántica | §7 · CA-24 | T-02 y su repositorio | otras pantallas | pendiente |
| T-15 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-08, CA-11, CA-14, CA-17, CA-25 a CA-27 | T-02 | — | pendiente |
| T-16 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
