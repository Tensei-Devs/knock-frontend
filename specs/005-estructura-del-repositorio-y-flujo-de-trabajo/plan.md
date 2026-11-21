# Plan 005 — Estructura del repositorio y flujo de trabajo

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Crear la estructura de carpetas.
2. Escribir `CONTRIBUTING.md` con el flujo.
3. Crear las plantillas de PR y de issue.
4. Definir CODEOWNERS por carpeta.
5. Agregar los hooks de Git que validan commits.

## Archivos que se crean o cambian
- `README.md`, `CONTRIBUTING.md`, `SECURITY.md`
- `.github/PULL_REQUEST_TEMPLATE.md` y `.github/CODEOWNERS`
- `.githooks/`

## Dependencias
- Git y GitHub

## Decisiones de la spec que este plan sigue
- **Un repositorio de frontend:** contiene la app, el panel y la landing, que comparten reglas, versión del contrato y revisión.
- **Flujo con `develop`:** integra y prueba antes de tocar `main`.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
