# Tareas 032 — Contactos de confianza y técnicos de confianza (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 042 y regenerar el cliente Dart | §4 | Backend 042 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-03, CA-06, CA-09, CA-12, CA-15 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/me/contactos-confianza` (CON-01) y mapeo de errores | §4 · CA-01 a CA-08 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `POST /api/v1/me/contactos-confianza` (CON-02) y mapeo de errores | §4 · CA-01 a CA-08 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `DELETE /api/v1/me/contactos-confianza/{id}` (CON-03) y mapeo de errores | §4 · CA-06 a CA-08 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `GET /api/v1/me/tecnicos-confianza` (TCO-01) y mapeo de errores | §4 · CA-09 a CA-17 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `PUT /api/v1/me/tecnicos-confianza/{tecnicoId}` (TCO-02) y mapeo de errores | §4 · CA-12 a CA-17 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Repositorio de `DELETE /api/v1/me/tecnicos-confianza/{tecnicoId}` (TCO-03) y mapeo de errores | §4 · CA-12 a CA-17 | T-01, T-02 | otras rutas | pendiente |
| T-09 | Pantalla «Avisar a alguien de confianza»: estados, textos es/en, 48 dp y semántica | §7 · CA-18 a CA-19 | T-02 y su repositorio | otras pantallas | pendiente |
| T-10 | Pantalla «Avisar a alguien de confianza (Agregar contacto)»: estados, textos es/en, 48 dp y semántica | §7 · CA-19 | T-02 y su repositorio | otras pantallas | pendiente |
| T-11 | Pantalla «Mis técnicos de confianza»: estados, textos es/en, 48 dp y semántica | §7 · CA-20 | T-02 y su repositorio | otras pantallas | pendiente |
| T-12 | Pantalla «Perfil del técnico»: estados, textos es/en, 48 dp y semántica | §7 · CA-21 | T-02 y su repositorio | otras pantallas | pendiente |
| T-13 | Pantalla «Calificar»: estados, textos es/en, 48 dp y semántica | §7 · CA-22 | T-02 y su repositorio | otras pantallas | pendiente |
| T-14 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-04, CA-07, CA-10, CA-13, CA-16, CA-23 a CA-25 | T-02 | — | pendiente |
| T-15 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
