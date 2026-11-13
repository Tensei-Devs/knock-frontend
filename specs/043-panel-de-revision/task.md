# Tareas 043 — Panel de revisión: verificaciones de identidad y reportes (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 053 y regenerar el cliente Dart | §4 | Backend 053 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-05, CA-08, CA-11, CA-15 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/admin/verificaciones` (VER-03) y mapeo de errores | §4 · CA-01 a CA-10 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `GET /api/v1/admin/verificaciones/{id}` (VER-04) y mapeo de errores | §4 · CA-05 a CA-10 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/admin/verificaciones/{id}/decision` (VER-05) y mapeo de errores | §4 · CA-08 a CA-10 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `GET /api/v1/admin/reportes` (REP-04) y mapeo de errores | §4 · CA-11 a CA-17 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `POST /api/v1/admin/reportes/{id}/decision` (REP-05) y mapeo de errores | §4 · CA-15 a CA-17 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Pantalla «Panel de administración»: estados, textos es/en, 48 dp y semántica | §7 · CA-18 | T-02 y su repositorio | otras pantallas | pendiente |
| T-09 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-06, CA-09, CA-12, CA-16, CA-19 a CA-21 | T-02 | — | pendiente |
| T-10 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
