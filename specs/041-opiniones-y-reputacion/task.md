# Tareas 041 — Opiniones y reputación del técnico (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 051 y regenerar el cliente Dart | §4 | Backend 051 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-06, CA-09 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/tecnicos/{id}/opiniones` (OPI-01) y mapeo de errores | §4 · CA-01 a CA-05 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `POST /api/v1/visitas/{id}/opinion` (OPI-02) y mapeo de errores | §4 · CA-06 a CA-08 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/opiniones/{id}/respuesta` (OPI-03) y mapeo de errores | §4 · CA-09 a CA-11 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Pantalla «Perfil del técnico»: estados, textos es/en, 48 dp y semántica | §7 · CA-12 | T-02 y su repositorio | otras pantallas | pendiente |
| T-07 | Pantalla «Opiniones»: estados, textos es/en, 48 dp y semántica | §7 · CA-13 | T-02 y su repositorio | otras pantallas | pendiente |
| T-08 | Pantalla «Calificar»: estados, textos es/en, 48 dp y semántica | §7 · CA-14 | T-02 y su repositorio | otras pantallas | pendiente |
| T-09 | Pantalla «Mi reputación (Responder)»: estados, textos es/en, 48 dp y semántica | §7 · CA-15 | T-02 y su repositorio | otras pantallas | pendiente |
| T-10 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-07, CA-10, CA-16 a CA-18 | T-02 | — | pendiente |
| T-11 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
