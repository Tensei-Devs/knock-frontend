# Tareas 013 — MCP del proyecto (móvil y panel)

> **Estado:** spec Aprobada; T-01, T-02, T-03, T-05 y T-06 hechas (KNOCK-227). **T-04 pendiente** (la hace una persona con OAuth); por eso CA-02 y CA-05 quedan parciales.

| Tarea | Qué se hace | Cubre | Estado |
|---|---|---|---|
| T-01 | Escribir `docs/mcp.md` con la lista de servidores aprobados (Jira con Atlassian, GitHub con `gh`, sin Figma, y el MCP de Dart si se evalúa) | R-02, R-03, R-05, R-08, R-09 · CA-04 | hecha |
| T-02 | Agregar la configuración de MCP de cada agente, sin secretos | R-01, R-04 · CA-01 | hecha |
| T-03 | Dejar las herramientas de escritura fuera de lo permitido por defecto | R-06, R-07 · CA-03 | hecha |
| T-04 | Probar la consulta a Jira con y sin sesión | R-01 · CA-02, CA-05 | pendiente (manual de José: requiere OAuth interactivo) |
| T-05 | Correr la búsqueda de secretos sobre la configuración | R-04 · CA-01 | hecha (sin gitleaks instalado; ver Memoria) |
| T-06 | Registrar la decisión en `Memoria.md` | — | hecha |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas o comandos en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
