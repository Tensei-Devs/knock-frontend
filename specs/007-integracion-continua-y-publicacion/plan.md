# Plan 007 — Integración continua y publicación

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Escribir el workflow con filtros por ruta.
2. Configurar la caché de Flutter y de npm.
3. Agregar los jobs de secretos y dependencias.
4. Escribir el workflow de publicación.

## Archivos que se crean o cambian
- `.github/workflows/ci-pr.yml` y `publish-android.yml`
- `scripts/ci/`

## Dependencias
- GitHub Actions
- API de publicación de Google Play

## Decisiones de la spec que este plan sigue
- **Jobs por carpeta:** el CI es rápido y barato.
- **Publicar desde GitHub:** se establece como requerimiento desplegar desde GitHub a Google Play, y las claves nunca se escriben en el código.
- **Etapas de publicación:** Google Play exige una prueba cerrada con testers antes de producción para cuentas nuevas.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
