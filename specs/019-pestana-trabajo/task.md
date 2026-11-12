# Tareas 019 — Pestaña Trabajo (lado del técnico)

> **Estado:** pendientes. En esta etapa **no se ejecutan**: se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz. «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar la bandeja y el descarte de backend 028 y regenerar el cliente | §4 | Backend 028 publicado en OpenAPI | T-03 | T-02 | Guillermo (contrato) y Erick | pendiente |
| T-02 | Dominio: `ResumenDeTrabajo`, `VisitaProxima`, `SolicitudNueva`, `CotizacionEnviada`, `TrabajoTerminado` | R-03, R-04 · CA-02 | — | T-03, T-04, T-05 | T-01 | Erick Trejo Reséndiz | pendiente |
| T-03 | Datos: bandeja con cursor y descarte (204, 404, 409) | R-05, R-08 · CA-03, CA-04, CA-11 | T-01, T-02 | T-06, T-07 | T-05 | Erick Trejo Reséndiz | pendiente |
| T-04 | Datos: resumen `GET /tecnicos/me/trabajo` con «Terminadas» paginado | R-02, R-08 · CA-05, CA-11, CA-13 | T-02 y la spec de backend del resumen | — | T-03, T-05 | Erick Trejo Reséndiz | pendiente |
| T-05 | Pantalla Trabajo: secciones, estados por sección, mensajes de §7, confirmación de descarte, «Cómo llegar» y «Ya llegué» | R-01, R-02, R-09–R-11 · CA-01, CA-05–CA-10, CA-12, CA-17 | T-02 | T-06 | T-03, T-04 | Erick Trejo Reséndiz | pendiente |
| T-06 | Seguridad negativa, accesibilidad y limpieza al cerrar sesión | R-06, R-07, R-12 · CA-14–CA-16 | T-03, T-05 | T-07 | T-04 | Erick Trejo Reséndiz | pendiente |
| T-07 | Integración con API simulada, recorrido con técnico de semilla, ARB, `Memoria.md` y PR | §11 | T-03, T-06 | — | — | Erick Trejo Reséndiz | pendiente |

## Dependencias con backend y con otras specs
- **Backend 028** fija la bandeja y el descarte (T-01 y T-03).
- **Spec de backend:** `GET /tecnicos/me/trabajo` es la spec 036 (Borrador). Hasta que se apruebe, T-04 sigue bloqueada y la pantalla sale solo con la bandeja.
- **Frontend 016** debe existir antes (crea `trabajo_providers.dart` y la ruta de la llegada).

## Ruta crítica y trabajo en paralelo
- Ruta crítica: backend 028 publicado → T-01 → T-03 → T-06 → T-07; T-04 corre aparte cuando exista su contrato.
- En paralelo: T-02 y T-05 con dobles de pruebas.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 019` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
