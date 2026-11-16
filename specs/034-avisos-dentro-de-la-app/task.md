# Tareas 034 — Avisos dentro de la app y preferencias de avisos (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-00 | Prerrequisitos que hoy no existen y no son parte de esta spec: Despachador de avisos de la spec 037, único que crea avisos (hoy no implementado) | §10 | — | T-01 | pendiente |
| T-01 | Vendorizar las rutas de backend 044 y regenerar el cliente Dart | §4 | Backend 044 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-04, CA-06, CA-09, CA-11 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/avisos` (AVI-01) y mapeo de errores | §4 · CA-01 a CA-10 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `GET /api/v1/avisos/no-leidos/contador` (AVI-02) y mapeo de errores | §4 · CA-04 a CA-05 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/avisos/{id}/leido` (AVI-03) y mapeo de errores | §4 · CA-06 a CA-08 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `POST /api/v1/avisos/leidos` (AVI-04) y mapeo de errores | §4 · CA-09 a CA-10 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `GET /api/v1/me/preferencias-avisos` (PRE-01) y mapeo de errores | §4 · CA-11 a CA-12 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Pantalla «Avisos»: estados, textos es/en, 48 dp y semántica | §7 · CA-13 | T-02 y su repositorio | otras pantallas | pendiente |
| T-09 | Pantalla «Mi cuenta»: estados, textos es/en, 48 dp y semántica | §7 · CA-14 | T-02 y su repositorio | otras pantallas | pendiente |
| T-10 | Pantalla «Inicio»: estados, textos es/en, 48 dp y semántica | §7 · CA-15 | T-02 y su repositorio | otras pantallas | pendiente |
| T-11 | Pantalla «Configuración»: estados, textos es/en, 48 dp y semántica | §7 · CA-16 | T-02 y su repositorio | otras pantallas | pendiente |
| T-12 | Pantalla «Qué avisos recibir»: estados, textos es/en, 48 dp y semántica | §7 · CA-17 | T-02 y su repositorio | otras pantallas | pendiente |
| T-13 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-07, CA-10, CA-12, CA-18 a CA-20 | T-02 | — | pendiente |
| T-14 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
