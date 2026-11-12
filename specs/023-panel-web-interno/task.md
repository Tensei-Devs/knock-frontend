# Tareas 023 — Panel web interno: entrada con permisos y doble factor

> **Estado:** pendientes; las specs 015 y 016 están aprobadas y las demás en borrador. Las tareas de cada spec se activan cuando esa spec esté Aprobada.
> **Responsable sugerido por omisión:** Ángel Alexis Blas Castillo (la capa Panel web puede repartirse). «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar backend 033 y regenerar el cliente TypeScript | §4 | Backend 033 publicado en OpenAPI | T-07 | T-02, T-05 | Ángel Alexis Blas Castillo (la capa Panel web puede repartirse) | pendiente |
| T-02 | Servicio de sesión: memoria, renovación, cierre, inactividad, 8 horas y mapeo de `code` | R-03, R-06, R-07, R-15 · CA-05, CA-06, CA-08, CA-09, CA-16, CA-17 | — | T-03, T-04 | T-01, T-05 | Ángel Alexis Blas Castillo (la capa Panel web puede repartirse) | pendiente |
| T-03 | Guarda por permiso, menú y páginas «Sin permiso» y «Sin acceso» | R-02, R-04, R-05 · CA-03, CA-04, CA-14 | T-02 | T-06 | T-04 | Ángel Alexis Blas Castillo (la capa Panel web puede repartirse) | pendiente |
| T-04 | Pantalla de acceso en tres pasos con mensajes de §7, espera por 429 y 503 | R-01, R-08, R-09, R-12 · CA-01, CA-02, CA-07, CA-13, CA-18, CA-19 | T-02 | T-06 | T-03 | Ángel Alexis Blas Castillo (la capa Panel web puede repartirse) | pendiente |
| T-05 | Encabezados de seguridad en Railway (`noindex`, CSP, `X-Frame-Options`, `Referrer-Policy`) | R-14 · CA-11 | — | T-07 | T-01–T-04 | Ángel Alexis Blas Castillo (la capa Panel web puede repartirse) | pendiente |
| T-06 | Arquitectura (sin `HttpClient` en componentes, sin `innerHTML`), accesibilidad AA y teclado | R-10, R-11, R-13 · CA-10, CA-12, CA-15 | T-03, T-04 | T-07 | — | Ángel Alexis Blas Castillo (la capa Panel web puede repartirse) | pendiente |
| T-07 | E2E con cuenta de semilla y TOTP de prueba, `docs/arquitectura-panel.md`, `Memoria.md` y PR | §11 | T-01, T-05, T-06 | — | — | Ángel Alexis Blas Castillo (la capa Panel web puede repartirse) | pendiente |

## Dependencias con backend y con otras specs
- **Backend 033** fija rutas, cookie, límites y auditoría; la cuenta de semilla con TOTP la crea su herramienta interna.
- Decidir el dominio del panel en Railway y registrarlo en el CORS del gateway (backend 033 R-27).

## Ruta crítica y trabajo en paralelo
- Ruta crítica: backend 033 → T-01 → T-02 conectado al cliente → T-06 → T-07.
- En paralelo: T-03, T-04 y T-05 desde el primer día con dobles.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 023` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
