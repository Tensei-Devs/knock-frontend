# Plan 008 — Calidad, pruebas y estándares

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Configurar `analysis_options.yaml` y ESLint.
2. Definir el esquema de nombres de pruebas.
3. Configurar la cobertura.

## Archivos que se crean o cambian
- `app/analysis_options.yaml`, `panel/eslint.config.js`, `.editorconfig`
- `app/test/` y `panel/src/**/*.spec.ts`

## Dependencias
- `flutter_lints`
- ESLint y Prettier
- Herramientas de cobertura de Flutter y de Angular

## Decisiones de la spec que este plan sigue
- **Lints estrictos desde el inicio:** es más barato que corregir después.
- **Accesibilidad desde la base:** cuesta menos que agregarla al final.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
