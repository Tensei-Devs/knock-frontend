# Plan 040 — Visita: agenda, reprogramación, cancelación, cliente ausente, cierre y permiso de fotos (pantallas)

> Parte de `spec.md` (Borrador).

## Enfoque
1. Vendorizar el contrato de backend 050 y regenerar el cliente Dart.
2. Dominio y repositorio (real y simulado) por recurso.
3. Estado con Riverpod y mapeo de errores.
4. Pantallas, textos ARB es/en y rutas.
5. Pruebas, mapa de arquitectura y `Memoria.md`.

## Archivos que se crean o cambian
- `app/lib/features/visita/`
- `app/lib/l10n/app_es.arb`, `app_en.arb`
- `app/test/features/visita/`
- `Memoria.md`

## Dependencias y orden
Depende del contrato de backend 050; mientras tanto se avanza con el repositorio simulado.
