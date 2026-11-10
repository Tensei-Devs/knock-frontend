# Tareas 006 — Contrato de la API y cliente generado

> **Estado:** pendientes. En esta etapa **no se ejecutan**: se activan cuando la spec esté Aprobada y una persona lo indique.

| Tarea | Qué se hace | Cubre | Estado |
|---|---|---|---|
| T-01 | Vendorizar el primer contrato en `contracts/` | R-01 | hecha (KNOCK-220: contrato de Identity) |
| T-02 | Crear el script de generación del cliente Dart | R-02, R-03 · CA-01 | hecha (KNOCK-220: `app/tool/generar_cliente_api.py`, porque `scripts/` es protegido) |
| T-03 | Crear el script de generación del cliente TypeScript | R-02, R-03 · CA-01 | pendiente |
| T-04 | Agregar la verificación de coherencia al CI | R-04 · CA-02 | parcial (KNOCK-220: prueba en `flutter test`; falta que el líder agregue `--check` al workflow) |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
