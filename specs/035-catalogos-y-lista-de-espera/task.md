# Tareas 035 — Catálogo de oficios, oficios pedidos y lista de espera (consulta interna) (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 045 y regenerar el cliente Dart | §4 | Backend 045 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-05, CA-08, CA-11, CA-14, CA-16, CA-20 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/oficios/{clave}` (OFI-02) y mapeo de errores | §4 · CA-01 a CA-04 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `GET /api/v1/admin/oficios` (OFI-03) y mapeo de errores | §4 · CA-05 a CA-13, CA-16 a CA-19 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/admin/oficios` (OFI-04) y mapeo de errores | §4 · CA-05 a CA-13, CA-16 a CA-19 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `PUT /api/v1/admin/oficios/{clave}` (OFI-05) y mapeo de errores | §4 · CA-11 a CA-13 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `POST /api/v1/oficios-pedidos` (OFP-01) y mapeo de errores | §4 · CA-14 a CA-15 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Repositorio de `GET /api/v1/admin/oficios-pedidos` (OFP-02) y mapeo de errores | §4 · CA-16 a CA-19 | T-01, T-02 | otras rutas | pendiente |
| T-09 | Repositorio de `GET /api/v1/admin/lista-espera` (LIS-02) y mapeo de errores | §4 · CA-20 a CA-23 | T-01, T-02 | otras rutas | pendiente |
| T-10 | Pantalla «Pedir cotización»: estados, textos es/en, 48 dp y semántica | §7 · CA-24 | T-02 y su repositorio | otras pantallas | pendiente |
| T-11 | Pantalla «Panel de administración»: estados, textos es/en, 48 dp y semántica | §7 · CA-25 | T-02 y su repositorio | otras pantallas | pendiente |
| T-12 | Pantalla «Registro de técnico»: estados, textos es/en, 48 dp y semántica | §7 · CA-26 | T-02 y su repositorio | otras pantallas | pendiente |
| T-13 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-04, CA-06, CA-09, CA-12, CA-15, CA-17, CA-21, CA-27 a CA-29 | T-02 | — | pendiente |
| T-14 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
