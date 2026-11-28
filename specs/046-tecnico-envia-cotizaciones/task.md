# Tareas 046 — El técnico ve una solicitud y envía su cotización

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** por asignar.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Dominio de la vista del técnico y validador de la cotización | §4 · CA-01, CA-03 | Aprobación | — | pendiente |
| T-02 | Repositorio de las dos rutas y mapeo de errores | §4 · CA-02, CA-04 a CA-07 | T-01 | — | pendiente |
| T-03 | Pantallas, envío único, textos es/en y accesibilidad | §7 · CA-02, CA-04 a CA-09 | T-02 | — | pendiente |
| T-04 | Sin datos en registros ni almacenamiento | §5, §6 · CA-10 | T-02 | T-03 | pendiente |
| T-05 | Gates: analyze, format, test, `sdd_lint --trace 046`, `codemap.py`, `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, una persona revisó el cambio y `Memoria.md` está al día.
