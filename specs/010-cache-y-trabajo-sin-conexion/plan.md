# Plan 010 — Caché y trabajo sin conexión

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Definir la interfaz de caché y su implementación local.
2. Implementar la revalidación con `ETag` en el cliente.
3. Implementar los borradores.
4. Implementar la base local y la cola de envío.

## Archivos que se crean o cambian
- `app/lib/core/cache/`
- `app/lib/core/cola_envio/`
- `app/test/core/cache/`

## Dependencias
- Paquete de base local (SQLite)
- Paquete de caché de imágenes

## Decisiones de la spec que este plan sigue
- **Caché con `ETag`:** gasta menos datos y responde rápido aunque la señal sea mala.
- **Base local en alcance mínimo:** refuerza la caché sin sincronizar lo que siempre debe consultarse en línea.
- **No cachear lo personal que cambia al crear algo:** evita mostrar datos viejos.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
