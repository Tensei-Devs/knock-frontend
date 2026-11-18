# Plan 004 — Landing page: estructura y publicación

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Crear la carpeta `landing/` con una página vacía.
2. Configurar el contenedor o servidor estático con las cabeceras.
3. Configurar la publicación desde la rama principal.

## Archivos que se crean o cambian
- `landing/index.html`, `landing/css/`, `landing/privacidad/`
- `landing/Dockerfile` y configuración del servidor estático
- `landing/tests/`

## Dependencias
- Servidor estático sin privilegios de administrador
- Railway

## Decisiones de la spec que este plan sigue
- **Railway:** el líder ya tiene un espacio contratado, no genera costo adicional y usa HTTPS; se descartó Azure Static Web Apps porque sus regiones no coinciden con las que permite la suscripción.
- **Estática:** menos superficie de ataque y costo cero.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
