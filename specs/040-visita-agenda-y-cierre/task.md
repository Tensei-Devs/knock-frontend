# Tareas 040 — Visita: agenda, reprogramación, cancelación, cliente ausente, cierre y permiso de fotos (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-00 | Prerrequisitos que hoy no existen y no son parte de esta spec: Ciclo de la visita de las specs 021 y 022 y tareas de la 054 (hoy no implementados); Moderación e imágenes de las specs 031 y 032 (hoy no implementadas) | §10 | — | T-01 | pendiente |
| T-01 | Vendorizar las rutas de backend 050 y regenerar el cliente Dart | §4 | Backend 050 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-05, CA-08, CA-11, CA-14, CA-17, CA-20, CA-23 | — | T-01 | pendiente |
| T-03 | Repositorio de `GET /api/v1/agenda` (VIS-02) y mapeo de errores | §4 · CA-01 a CA-04 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `POST /api/v1/visitas/{id}/reprogramar` (VIS-04) y mapeo de errores | §4 · CA-05 a CA-10 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `POST /api/v1/visitas/{id}/reprogramar/respuesta` (VIS-05) y mapeo de errores | §4 · CA-08 a CA-10 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `POST /api/v1/visitas/{id}/cancelar` (VIS-06) y mapeo de errores | §4 · CA-11 a CA-13 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `POST /api/v1/visitas/{id}/cliente-ausente` (VIS-07) y mapeo de errores | §4 · CA-14 a CA-16 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Repositorio de `POST /api/v1/visitas/{id}/terminar` (VIS-09) y mapeo de errores | §4 · CA-17 a CA-19 | T-01, T-02 | otras rutas | pendiente |
| T-09 | Repositorio de `POST /api/v1/visitas/{id}/no-terminado` (VIS-10) y mapeo de errores | §4 · CA-20 a CA-22 | T-01, T-02 | otras rutas | pendiente |
| T-10 | Repositorio de `PUT /api/v1/visitas/{id}/permiso-fotos` (VIS-11) y mapeo de errores | §4 · CA-23 a CA-25 | T-01, T-02 | otras rutas | pendiente |
| T-11 | Pantalla «Trabajo»: estados, textos es/en, 48 dp y semántica | §7 · CA-26, CA-30 a CA-31 | T-02 y su repositorio | otras pantallas | pendiente |
| T-12 | Pantalla «Inicio (Mi agenda)»: estados, textos es/en, 48 dp y semántica | §7 · CA-27 | T-02 y su repositorio | otras pantallas | pendiente |
| T-13 | Pantalla «Visita»: estados, textos es/en, 48 dp y semántica | §7 · CA-28 | T-02 y su repositorio | otras pantallas | pendiente |
| T-14 | Pantalla «Cita»: estados, textos es/en, 48 dp y semántica | §7 · CA-29 | T-02 y su repositorio | otras pantallas | pendiente |
| T-15 | Pantalla «Trabajo (Cancelar la visita)»: estados, textos es/en, 48 dp y semántica | §7 · CA-30 | T-02 y su repositorio | otras pantallas | pendiente |
| T-16 | Pantalla «Trabajo (El cliente no estaba)»: estados, textos es/en, 48 dp y semántica | §7 · CA-31 | T-02 y su repositorio | otras pantallas | pendiente |
| T-17 | Pantalla «Terminar servicio»: estados, textos es/en, 48 dp y semántica | §7 · CA-32 | T-02 y su repositorio | otras pantallas | pendiente |
| T-18 | Pantalla «Actividad (No se terminó)»: estados, textos es/en, 48 dp y semántica | §7 · CA-33 | T-02 y su repositorio | otras pantallas | pendiente |
| T-19 | Pantalla «Calificar»: estados, textos es/en, 48 dp y semántica | §7 · CA-34 | T-02 y su repositorio | otras pantallas | pendiente |
| T-20 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-06, CA-09, CA-12, CA-15, CA-18, CA-21, CA-24, CA-35 a CA-37 | T-02 | — | pendiente |
| T-21 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
