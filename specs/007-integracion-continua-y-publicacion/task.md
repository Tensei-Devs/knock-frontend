# Tareas 007 — Integración continua y publicación

> **Estado (2026-11-13):** T-01 a T-04 hechas; T-05 parcial. Los workflows están en `.github/workflows/` y corrieron en verde; la spec sigue en espera de la revisión de pares que pide su definición de terminado.

| Tarea | Qué se hace | Cubre | Estado |
|---|---|---|---|
| T-01 | Crear `.github/workflows/ci-pr.yml` | R-01, R-02 · CA-01, CA-02 | hecha |
| T-02 | Agregar el job de la app y el del panel | R-01, R-02 · CA-02 | hecha |
| T-03 | Agregar los jobs de secretos y dependencias | R-03, R-04 · CA-03 | hecha |
| T-04 | Crear el workflow de publicación en Google Play | R-05, R-06 | hecha |
| T-05 | Registrar los checks obligatorios | R-01 | parcial: `.github/rulesets/*.json` existen; su aplicación en GitHub no se verificó |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
