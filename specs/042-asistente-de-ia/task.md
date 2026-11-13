# Tareas 042 — Asistente de IA: resumen de chat, borrador de cotización, rango de precio y bitácora (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 052 y regenerar el cliente Dart | §4 | Backend 052 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-04, CA-07, CA-10, CA-14, CA-17 | — | T-01 | pendiente |
| T-03 | Repositorio de `POST /api/v1/asistente/conversaciones` (ASI-01) y mapeo de errores | §4 · CA-01 a CA-03 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `POST /api/v1/asistente/resumen-chat` (ASI-02) y mapeo de errores | §4 · CA-04 a CA-06 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/asistente/borrador-cotizacion` (ASI-03) y mapeo de errores | §4 · CA-07 a CA-09 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `GET /api/v1/asistente/rango-precio` (ASI-04) y mapeo de errores | §4 · CA-10 a CA-13 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `PUT /api/v1/asistente/bitacora/{solicitudId}` (ASI-05) y mapeo de errores | §4 · CA-14 a CA-19 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Repositorio de `GET /api/v1/asistente/bitacora/{solicitudId}` (ASI-06) y mapeo de errores | §4 · CA-14 a CA-19 | T-01, T-02 | otras rutas | pendiente |
| T-09 | Pantalla «Asistente Knock (No sé cuál)»: estados, textos es/en, 48 dp y semántica | §7 · CA-20 | T-02 y su repositorio | otras pantallas | pendiente |
| T-10 | Pantalla «Mensajes del técnico (Resumir la conversación)»: estados, textos es/en, 48 dp y semántica | §7 · CA-21 | T-02 y su repositorio | otras pantallas | pendiente |
| T-11 | Pantalla «Chat del técnico (Armar cotización con IA)»: estados, textos es/en, 48 dp y semántica | §7 · CA-22 | T-02 y su repositorio | otras pantallas | pendiente |
| T-12 | Pantalla «Cotizar»: estados, textos es/en, 48 dp y semántica | §7 · CA-23 | T-02 y su repositorio | otras pantallas | pendiente |
| T-13 | Pantalla «Chat del técnico (Guardar en bitácora)»: estados, textos es/en, 48 dp y semántica | §7 · CA-24 | T-02 y su repositorio | otras pantallas | pendiente |
| T-14 | Pantalla «Iniciar trabajo»: estados, textos es/en, 48 dp y semántica | §7 · CA-25 | T-02 y su repositorio | otras pantallas | pendiente |
| T-15 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-08, CA-11, CA-13, CA-15, CA-18, CA-26 a CA-28 | T-02 | — | pendiente |
| T-16 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
