# Tareas 035 — Pedir un oficio que no está y consultar un oficio (app) (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 045 y regenerar el cliente Dart | §4 | Backend 045 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-05 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/oficios/{clave}` (OFI-02) y mapeo de errores | §4 · CA-01 a CA-04 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `POST /api/v1/oficios-pedidos` (OFP-01) y mapeo de errores | §4 · CA-05 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Pantalla «Pedir cotización»: estados, textos es/en, 48 dp y semántica | §7 · CA-07 | T-02 y su repositorio | otras pantallas | pendiente |
| T-06 | Pantalla «Registro de técnico»: estados, textos es/en, 48 dp y semántica | §7 · CA-08 | T-02 y su repositorio | otras pantallas | pendiente |
| T-07 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-04, CA-06, CA-09 a CA-11 | T-02 | — | pendiente |
| T-08 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
