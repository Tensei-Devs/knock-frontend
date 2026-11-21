# Plan 003 — Arquitectura del panel web

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Crear el proyecto con Angular CLI en modo estricto.
2. Crear `core`, `shared` y la primera función vacía.
3. Configurar las reglas de lint de frontera.
4. Configurar Angular Material y los tokens.
5. Configurar la publicación en Railway y el bloqueo de indexación.

## Archivos que se crean o cambian
- `panel/angular.json`, `panel/tsconfig.json`, `panel/eslint.config.js`
- `panel/src/app/{core,shared,features,api}`
- `panel/railway.json` o equivalente

## Dependencias
- Angular y Angular Material
- ESLint y Playwright
- Generador de cliente TypeScript

## Decisiones de la spec que este plan sigue
- **Angular:** el panel es una aplicación web interna para el personal; tiene la prioridad más baja pero es necesaria para operar la verificación y la moderación.
- **Railway para el panel:** el espacio ya existe y lo aporta un integrante del equipo, así que no genera costo adicional al proyecto; si ese espacio deja de estar disponible, la aplicación estática se puede publicar en cualquier hosting estático.
- **Standalone y carga diferida:** menos código de arranque y mejor rendimiento inicial.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
