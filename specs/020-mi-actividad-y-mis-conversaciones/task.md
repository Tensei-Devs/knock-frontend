# Tareas 020 — Mi actividad y mis conversaciones

> **Estado:** pendientes; las specs 015 y 016 están aprobadas y las demás en borrador. Las tareas de cada spec se activan cuando esa spec esté Aprobada.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz. «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar `GET /solicitudes` y regenerar el cliente | §4 | Backend 020 publicado en OpenAPI | T-03 | T-02 | Erick Trejo Reséndiz | pendiente |
| T-02 | Dominio: `ServicioDeActividad`, `AccionPrincipal`, `Conversacion` y `ContadorDeNoLeidos` | R-02, R-04 · CA-01, CA-03 | — | T-03, T-04, T-05, T-07 | T-01 | Erick Trejo Reséndiz | pendiente |
| T-03 | Datos: lista con cursor (`limit=20`) y `visitaId` por la comparación | R-01, R-08 · CA-06, CA-07 | T-01, T-02 | T-06 | T-07 | Erick Trejo Reséndiz | pendiente |
| T-04 | Datos: conversaciones y marca de lectura sobre el contrato de backend 030 | R-04, R-05 · CA-09, CA-10 | T-02 y backend 030 publicado | T-08 | T-05 | Erick Trejo Reséndiz | pendiente |
| T-05 | Canal en vivo (hub de backend 026) con reconexión acotada | R-03, R-07 · CA-13, CA-14 | T-02 y backend 026 | T-08 | T-04 | Erick Trejo Reséndiz | pendiente |
| T-06 | Pantalla Actividad con secciones, tarjetas, último mensaje y mensajes de §7 | R-01, R-02, R-09–R-11 · CA-02, CA-04, CA-05, CA-15 | T-03 | T-08 | T-07 | Erick Trejo Reséndiz | pendiente |
| T-07 | Globo en el `AppShell` y lista de conversaciones con sus estados | R-03, R-12 · CA-08, CA-11, CA-12 | T-02 | T-08 | T-03, T-06 | Erick Trejo Reséndiz | pendiente |
| T-08 | Limpieza al cerrar sesión, privacidad del texto y accesibilidad | R-06 · CA-16–CA-18 | T-04, T-05, T-06, T-07 | T-09 | — | Erick Trejo Reséndiz | pendiente |
| T-09 | Integración con API y hub simulados, recorrido, ARB, `Memoria.md` y PR | §11 | T-08 | — | — | Erick Trejo Reséndiz | pendiente |

## Dependencias con backend y con otras specs
- **Backend 020** ya define la lista (T-01).
- **Backend 030** (en elaboración) debe definir conversaciones, último mensaje, no leídos y marca de lectura; sin él, T-04 queda bloqueada y el globo no se publica.
- **Backend 026** define el hub; su contrato vive en `docs/endpoints.md` del backend, no en OpenAPI.

## Ruta crítica y trabajo en paralelo
- Ruta crítica de Actividad: backend 020 → T-01 → T-03 → T-06 → T-08 → T-09.
- Ruta del globo: backend 030 → T-04 → T-08; puede entregarse en un segundo PR si backend 030 se retrasa.
- En paralelo: T-02, T-05 y T-07.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 020` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
