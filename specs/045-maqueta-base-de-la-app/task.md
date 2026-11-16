# Tareas 045 — Maqueta base de la app (reconstrucción visual simulada)

> **Estado:** en curso. La capa existe y está verificada pantalla por pantalla en emulador (`docs/demo-maqueta/ESTADO.md`); faltan la bandera `MODO_MAQUETA`, las pruebas y la evidencia de CI.
> **Responsable por omisión:** José Julián Hernández Hernández.

| Tarea | Qué se hace | Depende de | Cubre | Estado |
|---|---|---|---|---|
| T-01 | Base común: componentes, estado simulado, textos `tr()`, rutas `/m/...`, transiciones y dependencias (KNOCK-274) | — | R-01, R-03 | hecha en la rama; falta CI |
| T-02 | Pantallas del cliente (KNOCK-275) | T-01 | R-01, R-03 · CA-01 | hecha en la rama; falta CI |
| T-03 | Pantallas del técnico (KNOCK-276) | T-01 | R-01, R-03 · CA-01 | hecha en la rama; falta CI |
| T-04 | Mapa real, cobertura y animaciones (KNOCK-277) | T-01 | R-02, R-07 · CA-07 | hecha en la rama; falta CI |
| T-05 | Bandera `MODO_MAQUETA` y rótulo de datos de ejemplo | T-01 a T-04 | R-02 · CA-02, CA-03 | pendiente |
| P-1 | Reescribir o retirar con justificación las pruebas del diseño anterior | T-01 a T-04 | R-06 · CA-09 | pendiente |
| P-2 | Prueba de arquitectura: nada fuera de `features/maqueta/` importa el estado simulado | T-05 | R-01 · CA-04 | pendiente |
| T-06 | Evidencia: recorrido de las 52 pantallas, gitleaks y CI en verde | P-1, P-2 | CA-01, CA-08, CA-09 | pendiente |
| T-07 | `Memoria.md`, mapa de arquitectura y tabla pantalla → spec → estado (R-05) | T-06 | R-05 | pendiente |

## Definición de terminado
- Casos CA-01 a CA-09 cubiertos y CI en verde con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
