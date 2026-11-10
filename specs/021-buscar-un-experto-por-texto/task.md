# Tareas 021 — Buscar un experto por texto (app)

> **Estado:** pendientes. En esta etapa **no se ejecutan**: se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz. «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar backend 027 y regenerar el cliente | §4 | Backend 027 publicado en OpenAPI | T-03 | T-02 | Ángel Alexis Blas Castillo (contrato) y Erick | pendiente |
| T-02 | Dominio: consulta, resultado con `interpretacion` y experto sin contacto | R-01, R-04, R-07, R-12 · CA-05, CA-06 | — | T-03, T-04 | T-01 | Erick Trejo Reséndiz | pendiente |
| T-03 | Datos: repositorio con cursor, `invalid_cursor`, 422 y 503, sin caché en disco | R-03, R-05 · CA-10, CA-14, CA-17, CA-18 | T-01, T-02 | T-05 | T-04 | Erick Trejo Reséndiz | pendiente |
| T-04 | Pantallas: barra, resultados, filtros, interpretación, estados y mensajes de §7; paso a «Pedir cotización» | R-02, R-06, R-08–R-11 · CA-01–CA-04, CA-07–CA-09, CA-11–CA-13, CA-15 | T-02 | T-05 | T-03 | Erick Trejo Reséndiz | pendiente |
| T-05 | Accesibilidad y seguridad negativa (texto fuera de disco y registros) | R-05, R-11 · CA-14, CA-16 | T-03, T-04 | T-06 | — | Erick Trejo Reséndiz | pendiente |
| T-06 | Integración con API simulada, recorrido con técnicos de semilla, ARB, `Memoria.md` y PR | §11 | T-05 | — | — | Erick Trejo Reséndiz | pendiente |

## Dependencias con backend y con otras specs
- **Backend 027** fija la ruta, la interpretación, los filtros, la paginación y el límite de 30 por minuto.
- **Frontend 017** debe estar implementada para tener `coloniaId`.

## Ruta crítica y trabajo en paralelo
- Ruta crítica: backend 027 → T-01 → T-03 → T-05 → T-06.
- En paralelo: T-02 y T-04 con dobles de pruebas.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 021` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
