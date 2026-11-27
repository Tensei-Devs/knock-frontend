# Plan 046 — El técnico ve una solicitud y envía su cotización

> Parte de `spec.md` (estado Borrador; no habilita código). Redactado el 2026-11-26, después de que las rutas existen en el backend.

## Enfoque
1. Comprobar que el contrato vendorizado en `contracts/` incluye las dos rutas.
2. Dominio y validador del formulario, con sus pruebas primero.
3. Repositorio sobre el cliente generado y mapeo de errores.
4. Pantallas, textos es/en y accesibilidad.
5. Gates y `Memoria.md`.

## Archivos que se crean o cambian
- `app/lib/features/trabajo/`, `app/test/features/trabajo/`
- `app/lib/core/router/`, `app/lib/l10n/`, `Memoria.md`

## Dependencias y orden
Depende de la aprobación de esta spec, de la enmienda de la spec 019 y de las decisiones de §13.
