# Tareas 038 — Solicitudes y cotizaciones: ampliar, archivos, referencia de mercado y cotizaciones del técnico (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 048 y regenerar el cliente Dart | §4 | Backend 048 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-04, CA-08 | — | T-01 | pendiente |
| T-03 | Repositorio de `POST /api/v1/solicitudes/{id}/ampliar` (SOL-05) y mapeo de errores | §4 · CA-01 a CA-03 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `GET /api/v1/cotizaciones/referencia-mercado` (COT-03) y mapeo de errores | §4 · CA-04 a CA-07 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `GET /api/v1/tecnicos/me/cotizaciones` (COT-05) y mapeo de errores | §4 · CA-08 a CA-11 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Pantalla «Mensajes (técnico no responde)»: estados, textos es/en, 48 dp y semántica | §7 · CA-12 | T-02 y su repositorio | otras pantallas | pendiente |
| T-07 | Pantalla «Cotizar (Referencia del mercado)»: estados, textos es/en, 48 dp y semántica | §7 · CA-13 | T-02 y su repositorio | otras pantallas | pendiente |
| T-08 | Pantalla «Trabajo (Cotizaciones enviadas)»: estados, textos es/en, 48 dp y semántica | §7 · CA-14 | T-02 y su repositorio | otras pantallas | pendiente |
| T-09 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-07, CA-09, CA-15 a CA-17 | T-02 | — | pendiente |
| T-10 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
