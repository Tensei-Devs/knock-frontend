# Tareas 036 — Técnico: perfil, horarios, disponibilidad, mapa y explorar (pantallas)

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-00 | Prerrequisitos que hoy no existen y no son parte de esta spec: Almacén de búsqueda de la spec 027 y elegibilidad de la 028 (hoy no implementados); `disponibleHasta` (HU-019): hoy solo existe en las semillas | §10 | — | T-01 | pendiente |
| T-01 | Vendorizar las rutas de backend 046 y regenerar el cliente Dart | §4 | Backend 046 publicado en OpenAPI | T-02 | pendiente |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-04, CA-09, CA-13, CA-17, CA-21, CA-25, CA-30, CA-33, CA-36, CA-38, CA-40, CA-43 | — | T-01 | pendiente |
| T-03 | Repositorio de `POST /api/v1/tecnicos` (TEC-01) y mapeo de errores | §4 · CA-01 a CA-12, CA-17 a CA-42 | T-01, T-02 | otras rutas | pendiente |
| T-04 | Repositorio de `GET /api/v1/tecnicos` (TEC-02) y mapeo de errores | §4 · CA-01 a CA-12, CA-17 a CA-42 | T-01, T-02 | otras rutas | pendiente |
| T-05 | Repositorio de `GET /api/v1/tecnicos/autocompletar` (TEC-03) y mapeo de errores | §4 · CA-09 a CA-12 | T-01, T-02 | otras rutas | pendiente |
| T-06 | Repositorio de `GET /api/v1/mapa/tecnicos` (TEC-04) y mapeo de errores | §4 · CA-13 a CA-16 | T-01, T-02 | otras rutas | pendiente |
| T-07 | Repositorio de `GET /api/v1/tecnicos/{id}` (TEC-05) y mapeo de errores | §4 · CA-17 a CA-29 | T-01, T-02 | otras rutas | pendiente |
| T-08 | Repositorio de `GET /api/v1/tecnicos/{id}/llega-a-mi-colonia` (TEC-06) y mapeo de errores | §4 · CA-21 a CA-24 | T-01, T-02 | otras rutas | pendiente |
| T-09 | Repositorio de `GET /api/v1/tecnicos/{id}/fotos-trabajos` (TEC-07) y mapeo de errores | §4 · CA-25 a CA-29 | T-01, T-02 | otras rutas | pendiente |
| T-10 | Repositorio de `PUT /api/v1/tecnicos/me` (TEC-08) y mapeo de errores | §4 · CA-30 a CA-42 | T-01, T-02 | otras rutas | pendiente |
| T-11 | Repositorio de `PUT /api/v1/tecnicos/me/disponibilidad` (TEC-09) y mapeo de errores | §4 · CA-33 a CA-35 | T-01, T-02 | otras rutas | pendiente |
| T-12 | Repositorio de `GET /api/v1/tecnicos/me/horarios` (TEC-10) y mapeo de errores | §4 · CA-36 a CA-39 | T-01, T-02 | otras rutas | pendiente |
| T-13 | Repositorio de `PUT /api/v1/tecnicos/me/horarios` (TEC-11) y mapeo de errores | §4 · CA-36 a CA-39 | T-01, T-02 | otras rutas | pendiente |
| T-14 | Repositorio de `GET /api/v1/tecnicos/me/reputacion` (TEC-13) y mapeo de errores | §4 · CA-40 a CA-42 | T-01, T-02 | otras rutas | pendiente |
| T-15 | Repositorio de `GET /api/v1/explorar` (TEC-14) y mapeo de errores | §4 · CA-43 a CA-45 | T-01, T-02 | otras rutas | pendiente |
| T-16 | Pantalla «Registrarse como técnico»: estados, textos es/en, 48 dp y semántica | §7 · CA-46 | T-02 y su repositorio | otras pantallas | pendiente |
| T-17 | Pantalla «Inicio (lista)»: estados, textos es/en, 48 dp y semántica | §7 · CA-47 | T-02 y su repositorio | otras pantallas | pendiente |
| T-18 | Pantalla «Buscar»: estados, textos es/en, 48 dp y semántica | §7 · CA-48 | T-02 y su repositorio | otras pantallas | pendiente |
| T-19 | Pantalla «Explorar»: estados, textos es/en, 48 dp y semántica | §7 · CA-49, CA-53 | T-02 y su repositorio | otras pantallas | pendiente |
| T-20 | Pantalla «Inicio (barra de búsqueda)»: estados, textos es/en, 48 dp y semántica | §7 · CA-50 | T-02 y su repositorio | otras pantallas | pendiente |
| T-21 | Pantalla «Inicio (mapa)»: estados, textos es/en, 48 dp y semántica | §7 · CA-51 | T-02 y su repositorio | otras pantallas | pendiente |
| T-22 | Pantalla «Perfil del técnico»: estados, textos es/en, 48 dp y semántica | §7 · CA-52 | T-02 y su repositorio | otras pantallas | pendiente |
| T-23 | Pantalla «Explorar (Trabajos reales)»: estados, textos es/en, 48 dp y semántica | §7 · CA-53 | T-02 y su repositorio | otras pantallas | pendiente |
| T-24 | Pantalla «Mi perfil público»: estados, textos es/en, 48 dp y semántica | §7 · CA-54 | T-02 y su repositorio | otras pantallas | pendiente |
| T-25 | Pantalla «Mi negocio»: estados, textos es/en, 48 dp y semántica | §7 · CA-55 | T-02 y su repositorio | otras pantallas | pendiente |
| T-26 | Pantalla «Trabajo»: estados, textos es/en, 48 dp y semántica | §7 · CA-53, CA-56 | T-02 y su repositorio | otras pantallas | pendiente |
| T-27 | Pantalla «Mi reputación»: estados, textos es/en, 48 dp y semántica | §7 · CA-57 | T-02 y su repositorio | otras pantallas | pendiente |
| T-28 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-05, CA-08, CA-10, CA-12, CA-14, CA-16, CA-18, CA-20, CA-22, CA-24, CA-26, CA-29, CA-31, CA-34, CA-37, CA-39, CA-41 a CA-42, CA-44 a CA-45, CA-58 a CA-60 | T-02 | — | pendiente |
| T-29 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
