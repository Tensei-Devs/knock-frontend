# Plan 001 — Arquitectura de la app móvil

> Parte de `spec.md` (estado Aprobada). Este plan se confirmó con la aprobación de la spec.

## Enfoque
1. Crear el proyecto con `flutter create` y fijar la versión de Flutter.
2. Crear `core/` con navegación y estructura común.
3. Crear las cinco funciones vacías con sus tres capas.
4. Escribir las pruebas de capas.

## Archivos que se crean o cambian
- `app/pubspec.yaml`, `app/analysis_options.yaml`
- `app/lib/core/` y `app/lib/features/<funcion>/{presentation,domain,data}`
- `app/test/arquitectura/`

## Dependencias
- Flutter y Dart
- Riverpod
- go_router

## Decisiones de la spec que este plan sigue
- **Flutter:** con un solo código se obtiene una interfaz consistente, hay buenos paquetes para mapas, cámara, notificaciones y almacenamiento seguro, y encaja con los requerimientos de aplicaciones móviles.
- **Tres capas por función:** las reglas de negocio se prueban sin abrir la app y se pueden cambiar sin tocar las pantallas.
- **Riverpod:** inyección de dependencias y estado con pruebas sencillas.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba o un comando antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
