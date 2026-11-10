# Tareas 011 — Versionamiento por puntos

> **Estado:** pendientes. En esta etapa **no se ejecutan**: se activan cuando la spec esté Aprobada y una persona lo indique.

| Tarea | Qué se hace | Cubre | Estado |
|---|---|---|---|
| T-01 | Escribir el cálculo de versión y de `versionCode` con los ejemplos de la descripción | R-02, R-05, R-06 · CA-01, CA-02 | hecha |
| T-02 | Agregar la comprobación de la etiqueta de puntos al CI | R-04 · CA-03 | hecha |
| T-03 | Integrar el cálculo y la etiqueta de Git en la publicación | R-07 · CA-04 | pendiente (depende de KNOCK-221) |
| T-04 | Crear el registro de versiones publicadas | R-07 | hecha (estructura en `docs/VERSIONES_PUBLICADAS.md`; se llena a mano hasta T-03) |
| T-05 | Documentar la tabla de puntos en `CONTRIBUTING.md` | R-01, R-03 | hecha |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
