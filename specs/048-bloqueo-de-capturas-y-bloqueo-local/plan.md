# Plan 048 — Capturas y bloqueo local

> Parte de `spec.md` (estado Borrador; no habilita código). Redactado el 2026-11-28.

## Enfoque
1. Resolver D-01 a D-03 y, si procede, la enmienda de la spec 016.
2. Parte A: puerto, contador, canal nativo y pantallas, con pruebas primero.
3. Parte B: revisar la dependencia, puerto de autenticación, controlador del bloqueo, pantalla y ajuste.
4. Textos, accesibilidad, recorrido en teléfono, gates y `Memoria.md`.

## Archivos que se crearían o cambiarían
`app/lib/core/plataforma/`, `app/lib/core/router/`, `app/lib/core/sesion/`, la pantalla de ajustes y las pantallas de §7, `app/lib/l10n/`, `app/android/`, `app/pubspec.yaml` y su bloqueo, `app/test/`. Si el CI pide excepciones de licencia, `security/exceptions.yaml` y el flujo de CI son archivos protegidos: necesitan autorización.

## Estimación sin medir
Parte A: 2 a 3 horas. Parte B: 4 a 6 horas.
