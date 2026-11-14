# Tareas 043 — Panel web: revisión de verificaciones de identidad y reportes (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** por asignar.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-00 | Prerrequisitos que hoy no existen y no son parte de esta spec: Panel con doble factor, permisos y auditoría de la spec 033 (hoy no implementados); Cuenta de almacenamiento privada y cifrado de fotos de la spec 025 (hoy no existen en Terraform); Moderación de la spec 031 (hoy no implementada) | §10 | — | T-01 | pendiente |
| T-01 | Vendorizar el contrato de backend y generar el cliente de 053 y TypeScript | §4 | Backend 053 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Servicios y modelos sobre el cliente TypeScript generado | §4 · CA-01, CA-05, CA-09, CA-14, CA-18 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/admin/verificaciones` (VER-03) y mapeo de errores | §4 · CA-01 a CA-13 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `GET /api/v1/admin/verificaciones/{id}` (VER-04) y mapeo de errores | §4 · CA-05 a CA-13 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/admin/verificaciones/{id}/decision` (VER-05) y mapeo de errores | §4 · CA-09 a CA-13 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `GET /api/v1/admin/reportes` (REP-04) y mapeo de errores | §4 · CA-14 a CA-22 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `POST /api/v1/admin/reportes/{id}/decision` (REP-05) y mapeo de errores | §4 · CA-18 a CA-22 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Pantalla «Panel de administración»: estados, textos es/en, 48 dp y semántica | §7 · CA-23 | T-02 y su repositorio | otras pantallas | pendiente |
| T-09 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-03, CA-07, CA-11, CA-16, CA-20, CA-24 a CA-26 | T-02 | — | pendiente |
| T-10 | Gates: lint, tipos, pruebas del panel, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
