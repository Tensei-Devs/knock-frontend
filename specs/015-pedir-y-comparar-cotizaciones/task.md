# Tareas 015 — Pedir y comparar cotizaciones (pantallas)

> **Estado (2026-11-25):** en curso. Pantallas, dominio, borrador y fotos hechos (#45). Crear, leer, comparar, elegir y recuperar la cita ya usan la API según el contrato (#97, #98, #106, #107), con pruebas y CI en verde, **sin probar contra el backend desplegado**. La subida de fotos queda apagada hasta comprobarla con Azure. Faltan T-05, T-10 y alinear T-04 con la spec 062 del backend.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz. «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar el contrato de backend 020 y 021 y el del flujo de archivos privados de la spec 013 y regenerar el cliente Dart | §4 · CA-23 | Backend 020 y 021 y el módulo de archivos de la spec 013 (PR #63) publicados en OpenAPI | T-03, T-04, T-05 | T-02 | José Julián Hernández Hernández (contrato) y Erick | parcial: el contrato vendorizado ya trae `/solicitudes`; faltan las rutas de `/imagenes/subidas`, que se llaman a mano según el contrato del backend |
| T-02 | Dominio: entidades, `Franja`, validaciones de R-02 a R-05 y mapeo de `code` a `Failure` | R-01–R-05, R-17 · CA-02, CA-04, CA-17 | — | T-03, T-04, T-06, T-07, T-08 | T-01, T-06 | Erick Trejo Reséndiz | hecha (#45, KNOCK-244) |
| T-03 | Datos: mapeador y `SolicitudRepositoryApi` (crear, obtener, cotizaciones, elegir) | R-06, R-08, R-11 · CA-06, CA-13, CA-20, CA-23 | T-01, T-02 | T-09, T-10 | T-04, T-05 | Erick Trejo Reséndiz | hecha contra el contrato (#97, #98, #106; CI en verde). Sin probar contra el backend desplegado |
| T-04 | Datos: `foto_preparada.dart` (tipo, 5 MB, píxeles, reducción solo si el lado mayor pasa de 1600 px, sin EXIF) y subida por el flujo privado de la spec 013 (`POST /archivos/subidas`, `PUT` y `POST /archivos/{id}/confirmar`) | R-03 · CA-03, CA-18 | T-01, T-02 | T-10 | T-03, T-05 | Erick Trejo Reséndiz | parcial: `foto_preparada.dart` hecha (#45); la subida usa el flujo privado de la spec 062 del backend (no las rutas `/archivos` que nombra esta tarea) y queda **apagada** (`SUBIDA_DE_FOTOS`, #97): depende del almacenamiento y la moderación de Azure |
| T-05 | Datos: fotos remotas solo de dominios permitidos y sin caché en disco | CA-21 | T-01 | T-10 | T-03, T-04 | Erick Trejo Reséndiz | en curso: regla de dominios permitidos hecha (`fotos_permitidas.dart`, CA-21); falta el dominio real de los enlaces firmados |
| T-06 | Borrador: `almacen_borrador_solicitud.dart`, directorio privado de fotos y borrado al enviar, descartar y cerrar sesión | R-07, R-16 · CA-14, CA-19 | T-02 | T-10 | T-03, T-04, T-07 | Erick Trejo Reséndiz | hecha (#45, KNOCK-244) |
| T-07 | Pantallas del formulario (tres pasos), detalle y tarjeta de Actividad con sus estados y mensajes de §7 | R-01, R-12–R-15 · CA-01, CA-05, CA-15, CA-22, CA-24 | T-02 | T-09 | T-06, T-08 | Erick Trejo Reséndiz | hecha (#45, KNOCK-244) |
| T-08 | Comparación, tarjeta de cotización, motivo sin elegir y hoja de confirmación con revelación del contacto | R-08, R-09, R-18 · CA-07–CA-12 | T-02 | T-09 | T-07 | Erick Trejo Reséndiz | hecha contra el contrato (#49, #98, #106, #107; CI en verde). Sin probar contra el backend desplegado |
| T-09 | Rutas en `app_router.dart`, accesibilidad (48 dp, 200 %, lector), seguridad negativa y prueba del manifiesto | R-10, R-15, R-16 · CA-10, CA-16, CA-19 | T-03, T-07, T-08 | T-10 | — | Erick Trejo Reséndiz | hecha, en revisión (#45, #49 y #53) |
| T-10 | Integración con API simulada, recorrido real con semillas, ARB completos, `Memoria.md` y PR | §11 | T-03, T-04, T-05, T-06, T-09 | — | — | Erick Trejo Reséndiz | pendiente: ARB y `Memoria.md` hechos; falta la integración con API simulada, el recorrido con semillas (KNOCK-246) y las capturas |

## Dependencias con backend y con otras specs
- **Backend 020 y 021** deben publicar sus rutas en OpenAPI antes de T-01; mientras tanto se avanza con la interfaz y dobles de pruebas.
- **El módulo de archivos privados de la spec 013** (PR #63 de backend, KNOCK-208) debe publicar `POST /archivos/subidas` y su confirmación en el Sprint 4, o la demo usa fotos de semilla (hallazgo abierto).
- **KNOCK-246** (semillas de solicitudes y cotizaciones) es necesaria para T-10.
- **Spec 017** aporta la zona; si no está lista, T-07 muestra «Elige tu zona» y no envía.

## Ruta crítica y trabajo en paralelo
- Ruta crítica: backend 020, 021 y archivos privados de la 013 publicados → T-01 → T-03 → T-09 → T-10.
- En paralelo desde el primer día: T-02, después T-06, T-07 y T-08 con dobles de pruebas.
- Dos personas pueden repartirse: una en `data` (T-03 a T-05) y otra en pantallas (T-07 y T-08).

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 015` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
