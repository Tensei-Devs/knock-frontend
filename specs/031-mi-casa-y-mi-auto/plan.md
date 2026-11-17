# Plan 031 — Mi casa y mi auto (pantallas)

> Parte de `spec.md` (Borrador).

## Enfoque
1. Vendorizar el contrato de backend 041 y regenerar el cliente Dart.
2. Dominio y repositorio (real y simulado) por recurso.
3. Estado con Riverpod y mapeo de errores.
4. Pantallas, textos ARB es/en y rutas.
5. Pruebas, mapa de arquitectura y `Memoria.md`.

## Archivos que se crean o cambian
- `app/lib/features/mi/`
- `app/lib/l10n/app_es.arb`, `app_en.arb`
- `app/test/features/mi/`
- `Memoria.md`

## Dependencias y orden
Depende del contrato de backend 041; mientras tanto se avanza con el repositorio simulado.
