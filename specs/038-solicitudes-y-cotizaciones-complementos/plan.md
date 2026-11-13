# Plan 038 — Solicitudes y cotizaciones: ampliar, archivos, referencia de mercado, cotizaciones del técnico y cierre por elección (pantallas)

> Parte de `spec.md` (Borrador).

## Enfoque
1. Vendorizar el contrato de backend 048 y regenerar el cliente Dart.
2. Dominio y repositorio (real y simulado) por recurso.
3. Estado con Riverpod y mapeo de errores.
4. Pantallas, textos ARB es/en y rutas.
5. Pruebas, mapa de arquitectura y `Memoria.md`.

## Archivos que se crean o cambian
- `app/lib/features/solicitudes/`
- `app/lib/l10n/app_es.arb`, `app_en.arb`
- `app/test/features/solicitudes/`
- `Memoria.md`

## Dependencias y orden
Depende del contrato de backend 048; mientras tanto se avanza con el repositorio simulado.
