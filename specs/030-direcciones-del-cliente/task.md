# Tareas 030 — Direcciones del cliente (pantallas)

> **Estado:** implementadas en la rama `feature/KNOCK-266-client-addresses-screens`; falta el CI del PR y el humo en teléfono (sin fusionar).
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-00 | Prerrequisitos que hoy no existen y no son parte de esta spec: Llaves de cifrado de campo en Key Vault (spec 025) y la copia de la dirección en la visita de la spec 022 (hoy no implementadas) | §10 | — | T-01 | pendiente |
| T-01 | Vendorizar las rutas de backend 040 y regenerar el cliente Dart | §4 | Backend 040 publicado en OpenAPI | T-02 | hecha (contrato `contracts/openapi.v1.json` con `me/direcciones`) |
| T-02 | Dominio: entidades, reglas y errores | §4 · CA-01, CA-03, CA-06, CA-09 | — | T-01 | hecha (`domain/direccion.dart`) |
| T-03 | Repositorio de `GET /api/v1/me/direcciones` (DIR-01) y mapeo de errores | §4 · CA-01 a CA-11 | T-01, T-02 | otras rutas | hecha (repositorio sobre el transporte con sesión; KNOCK-288) |
| T-04 | Repositorio de `POST /api/v1/me/direcciones` (DIR-02) y mapeo de errores | §4 · CA-01 a CA-11 | T-01, T-02 | otras rutas | hecha (repositorio sobre el transporte con sesión; KNOCK-288) |
| T-05 | Repositorio de `PUT /api/v1/me/direcciones/{id}` (DIR-03) y mapeo de errores | §4 · CA-06 a CA-11 | T-01, T-02 | otras rutas | hecha (repositorio sobre el transporte con sesión; KNOCK-288) |
| T-06 | Repositorio de `DELETE /api/v1/me/direcciones/{id}` (DIR-04) y mapeo de errores | §4 · CA-06 a CA-11 | T-01, T-02 | otras rutas | hecha (repositorio sobre el transporte con sesión; KNOCK-288) |
| T-07 | Pantalla «Mis datos»: estados, textos es/en, 48 dp y semántica | §7 · CA-12 | T-02 y su repositorio | otras pantallas | hecha (`maqueta/direcciones_reales.dart`, `DireccionesReales`) |
| T-08 | Pantalla «Pedir cotización (paso 3)»: estados, textos es/en, 48 dp y semántica | §7 · CA-13 | T-02 y su repositorio | otras pantallas | hecha (`DireccionAlPedirReal` y la solicitud usa la dirección elegida) |
| T-09 | Registros sin datos personales y borrado local al cerrar sesión | §5, §6 · CA-02, CA-04, CA-07, CA-10, CA-14 a CA-16 | T-02 | — | hecha (`me/direcciones` fuera de la caché; el estado se rehace al cambiar la sesión) |
| T-10 | Gates: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace`, `codemap.py` y `Memoria.md` | §11 | todas | — | parcial (local en verde; falta el CI del PR y el humo en teléfono) |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
