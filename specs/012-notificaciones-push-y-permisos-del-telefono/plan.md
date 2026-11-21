# Plan 012 — Notificaciones push y permisos del teléfono

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Integrar el servicio de notificaciones y el registro del identificador.
2. Implementar la navegación desde una notificación.
3. Implementar la solicitud de permisos con aviso previo y alternativas.

## Archivos que se crean o cambian
- `app/lib/core/notificaciones/`
- `app/lib/core/permisos/`
- `app/test/core/permisos/`

## Dependencias
- Firebase Cloud Messaging
- Paquete de permisos

## Decisiones de la spec que este plan sigue
- **Pedir permisos al usarlos:** la persona entiende para qué sirve cada uno y la app no se rompe si lo niega.
- **Sin permiso de contactos:** se usa el selector del sistema, que no lo necesita.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
