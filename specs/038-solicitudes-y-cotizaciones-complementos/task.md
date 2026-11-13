# Tareas 038 — Solicitudes y cotizaciones: ampliar, archivos, referencia de mercado y cotizaciones del técnico (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 048 y regenerar el cliente Dart | §4 | Backend 048 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-04, CA-07, CA-11 | — | T-01 | pendiente |
| T-03 | Repositorio de `POST /api/v1/solicitudes/{id}/ampliar` (SOL-05) y mapeo de errores | §4 · CA-01 a CA-03 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `GET /api/v1/solicitudes/{id}/archivos` (SOL-08) y mapeo de errores | §4 · CA-04 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `GET /api/v1/cotizaciones/referencia-mercado` (COT-03) y mapeo de errores | §4 · CA-07 a CA-10 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `GET /api/v1/tecnicos/me/cotizaciones` (COT-05) y mapeo de errores | §4 · CA-11 a CA-14 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Pantalla «Mensajes (técnico no responde)»: estados, textos es/en, 48 dp y semántica | §7 · CA-15 | T-02 y su repositorio | otras pantallas | pendiente |
| T-08 | Pantalla «Trabajo»: estados, textos es/en, 48 dp y semántica | §7 · CA-16, CA-19 | T-02 y su repositorio | otras pantallas | pendiente |
| T-09 | Pantalla «Chat»: estados, textos es/en, 48 dp y semántica | §7 · CA-17 | T-02 y su repositorio | otras pantallas | pendiente |
| T-10 | Pantalla «Cotizar (Referencia del mercado)»: estados, textos es/en, 48 dp y semántica | §7 · CA-18 | T-02 y su repositorio | otras pantallas | pendiente |
| T-11 | Pantalla «Trabajo (Cotizaciones enviadas)»: estados, textos es/en, 48 dp y semántica | §7 · CA-19 | T-02 y su repositorio | otras pantallas | pendiente |
| T-12 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-08, CA-10, CA-12, CA-20 a CA-22 | T-02 | — | pendiente |
| T-13 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
