# Tareas 047 — Pantalla del chat

> **Estado:** pendientes; se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** por asignar.

| Tarea | Qué se hace | Cubre | Depende de | Paralelo con | Estado |
|---|---|---|---|---|---|
| T-01 | Dominio y repositorio de abrir, leer, listar mensajes, enviar y marcar leído | §4 · CA-01, CA-04 a CA-06, CA-13 | Aprobación | T-02 | pendiente |
| T-02 | Canal en vivo: unirse, salir, evento y reconexión | §4 · CA-11, CA-12 | Aprobación | T-01 | pendiente |
| T-03 | Controlador: historial, envío único, relectura y leído | CA-04 a CA-07, CA-09, CA-10 | T-01, T-02 | — | pendiente |
| T-04 | Pantalla, estados, respuestas rápidas, menú, textos es/en y accesibilidad | §7 · CA-03, CA-08, CA-09, CA-14, CA-15, CA-17 | T-03 | — | pendiente |
| T-05 | Entradas desde la lista, la comparación y «Solicitudes nuevas» | CA-01, CA-02 | T-04 | — | pendiente |
| T-06 | Sin datos en registros ni almacenamiento; limpieza al cerrar sesión | §5, §6 · CA-16 | T-03 | T-04 | pendiente |
| T-07 | Gates: analyze, format, test, `sdd_lint --trace 047`, `codemap.py`, `Memoria.md` | §11 | todas | — | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, una persona revisó el cambio y `Memoria.md` está al día.
