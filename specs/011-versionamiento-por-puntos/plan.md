# Plan 011 — Versionamiento por puntos

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Escribir el cálculo de versión y de `versionCode` con pruebas.
2. Agregar la comprobación de la etiqueta de puntos al CI.
3. Integrar el cálculo en la publicación.
4. Crear el registro de versiones publicadas.

## Archivos que se crean o cambian
- `scripts/ci/version.*`
- `docs/VERSIONES_PUBLICADAS.md`
- `.github/workflows/publish-android.yml`

## Dependencias
- Ninguna adicional

## Decisiones de la spec que este plan sigue
- **Versión por componente:** un cambio en la landing no cambia el número de la app.
- **`versionCode` derivado de la versión:** siempre crece y no hay que llevarlo a mano.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
