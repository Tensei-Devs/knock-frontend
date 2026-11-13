# Tareas 039 — Cotización final tras la visita y ajustes de precio (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 049 y regenerar el cliente Dart | §4 | Backend 049 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-04, CA-07, CA-10 | — | T-01 | pendiente |
| T-03 | Repositorio de `POST /api/v1/visitas/{id}/cotizacion-final` (COT-06) y mapeo de errores | §4 · CA-01 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `POST /api/v1/visitas/{id}/cotizacion-final/decision` (COT-07) y mapeo de errores | §4 · CA-04 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/cotizaciones/{id}/ajuste-precio` (AJU-01) y mapeo de errores | §4 · CA-07 a CA-09 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `POST /api/v1/ajustes/{id}/decision` (AJU-02) y mapeo de errores | §4 · CA-10 a CA-12 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Pantalla «Terminar servicio»: estados, textos es/en, 48 dp y semántica | §7 · CA-13, CA-17 | T-02 y su repositorio | otras pantallas | pendiente |
| T-08 | Pantalla «Chat»: estados, textos es/en, 48 dp y semántica | §7 · CA-14 | T-02 y su repositorio | otras pantallas | pendiente |
| T-09 | Pantalla «Mensajes»: estados, textos es/en, 48 dp y semántica | §7 · CA-15, CA-18 | T-02 y su repositorio | otras pantallas | pendiente |
| T-10 | Pantalla «Visita»: estados, textos es/en, 48 dp y semántica | §7 · CA-16 | T-02 y su repositorio | otras pantallas | pendiente |
| T-11 | Pantalla «Terminar servicio (Proponer otro precio)»: estados, textos es/en, 48 dp y semántica | §7 · CA-17 | T-02 y su repositorio | otras pantallas | pendiente |
| T-12 | Pantalla «Mensajes (Aprobar)»: estados, textos es/en, 48 dp y semántica | §7 · CA-18 | T-02 y su repositorio | otras pantallas | pendiente |
| T-13 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-08, CA-11, CA-19 a CA-21 | T-02 | — | pendiente |
| T-14 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
