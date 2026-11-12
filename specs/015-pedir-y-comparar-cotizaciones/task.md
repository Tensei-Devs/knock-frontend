# Tareas 015 — Pedir y comparar cotizaciones (pantallas)

> **Estado:** pendientes; las specs 015 y 016 están aprobadas y las demás en borrador. Las tareas de cada spec se activan cuando esa spec esté Aprobada.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz. «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar el contrato de backend 020 y 021 y el del flujo de archivos privados de la spec 013 y regenerar el cliente Dart | §4 · CA-23 | Backend 020 y 021 y el módulo de archivos de la spec 013 (PR #63) publicados en OpenAPI | T-03, T-04, T-05 | T-02 | José Julián Hernández Hernández (contrato) y Erick | pendiente |
| T-02 | Dominio: entidades, `Franja`, validaciones de R-02 a R-05 y mapeo de `code` a `Failure` | R-01–R-05, R-17 · CA-02, CA-04, CA-17 | — | T-03, T-04, T-06, T-07, T-08 | T-01, T-06 | Erick Trejo Reséndiz | pendiente |
| T-03 | Datos: mapeador y `SolicitudRepositoryApi` (crear, obtener, cotizaciones, elegir) | R-06, R-08, R-11 · CA-06, CA-13, CA-20, CA-23 | T-01, T-02 | T-09, T-10 | T-04, T-05 | Erick Trejo Reséndiz | pendiente |
| T-04 | Datos: `foto_preparada.dart` (tipo, 5 MB, píxeles, reducción solo si el lado mayor pasa de 1600 px, sin EXIF) y subida por el flujo privado de la spec 013 (`POST /archivos/subidas`, `PUT` y `POST /archivos/{id}/confirmar`) | R-03 · CA-03, CA-18 | T-01, T-02 | T-10 | T-03, T-05 | Erick Trejo Reséndiz | pendiente |
| T-05 | Datos: fotos remotas solo de dominios permitidos y sin caché en disco | CA-21 | T-01 | T-10 | T-03, T-04 | Erick Trejo Reséndiz | pendiente |
| T-06 | Borrador: `almacen_borrador_solicitud.dart`, directorio privado de fotos y borrado al enviar, descartar y cerrar sesión | R-07, R-16 · CA-14, CA-19 | T-02 | T-10 | T-03, T-04, T-07 | Erick Trejo Reséndiz | pendiente |
| T-07 | Pantallas del formulario (tres pasos), detalle y tarjeta de Actividad con sus estados y mensajes de §7 | R-01, R-12–R-15 · CA-01, CA-05, CA-15, CA-22, CA-24 | T-02 | T-09 | T-06, T-08 | Erick Trejo Reséndiz | pendiente |
| T-08 | Comparación, tarjeta de cotización, motivo sin elegir y hoja de confirmación con revelación del contacto | R-08, R-09, R-18 · CA-07–CA-12 | T-02 | T-09 | T-07 | Erick Trejo Reséndiz | pendiente |
| T-09 | Rutas en `app_router.dart`, accesibilidad (48 dp, 200 %, lector), seguridad negativa y prueba del manifiesto | R-10, R-15, R-16 · CA-10, CA-16, CA-19 | T-03, T-07, T-08 | T-10 | — | Erick Trejo Reséndiz | pendiente |
| T-10 | Integración con API simulada, recorrido real con semillas, ARB completos, `Memoria.md` y PR | §11 | T-03, T-04, T-05, T-06, T-09 | — | — | Erick Trejo Reséndiz | pendiente |

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
