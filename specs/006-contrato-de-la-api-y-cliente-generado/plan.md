# Plan 006 — Contrato de la API y cliente generado

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Elegir los generadores de Dart y de TypeScript y fijar sus versiones.
2. Crear los scripts de generación.
3. Agregar la verificación al CI.

## Archivos que se crean o cambian
- `contracts/openapi.v1.json`
- `app/packages/knock_api/` y `panel/src/app/api/`
- `scripts/generar-clientes.*`

## Dependencias
- Generadores de OpenAPI para Dart y TypeScript

## Decisiones de la spec que este plan sigue
- **Contrato primero:** el backend define la API y el frontend la consume sin interpretarla.
- **Clientes generados:** evitan errores de tipos y rutas escritas a mano.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
