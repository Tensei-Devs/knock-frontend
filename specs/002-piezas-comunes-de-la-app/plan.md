# Plan 002 — Piezas comunes de la app

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Configurar la generación del cliente.
2. Implementar el componente de sesión.
3. Configurar `l10n.yaml` y los archivos de traducción.
4. Definir los tokens del tema.
5. Implementar la caché local.

## Archivos que se crean o cambian
- `app/lib/core/red/`, `core/sesion/`, `core/errores/`, `core/tema/`
- `app/lib/l10n/app_es.arb` y `app_en.arb`
- `app/packages/knock_api/`

## Dependencias
- Generador de cliente Dart de OpenAPI
- `flutter_localizations` e `intl`
- Paquete de almacenamiento seguro
- Paquete de caché local

## Decisiones de la spec que este plan sigue
- **Cliente generado:** si el backend cambia, la app deja de compilar en lugar de fallar en producción.
- **Textos fuera de las pantallas:** facilita agregar idiomas y revisar el lenguaje.
- **Caché con ETag:** gasta menos datos y responde rápido con señal irregular.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
