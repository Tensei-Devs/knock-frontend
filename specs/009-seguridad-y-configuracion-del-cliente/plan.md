# Plan 009 — Seguridad y configuración del cliente

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Definir la configuración por entorno y la lectura de claves locales.
2. Elegir y evaluar el paquete de almacenamiento seguro.
3. Definir la política de seguridad de contenido del panel.

## Archivos que se crean o cambian
- `app/android/local.properties` (ignorado por Git)
- `app/lib/core/sesion/`
- `panel/src/index.html` (política de contenido)

## Dependencias
- Paquete de almacenamiento seguro

## Decisiones de la spec que este plan sigue
- **Almacenamiento seguro del sistema:** el token no queda en preferencias legibles.
- **Claves fuera del código:** protege al repositorio aunque se haga público.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
