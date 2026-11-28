# Plan 049 — Certificado y dispositivo en observación

> Parte de `spec.md` (estado Borrador; no habilita código). Redactado el 2026-11-28.

## Enfoque
1. Confirmar el supuesto sobre Dart y Android, anotar la cadena del día y armar el juego de raíces con fuente y huellas.
2. Parte A: comprobación aparte con pruebas primero, incluida la que demuestra que no toca el tráfico real.
3. Parte B: señales nativas detrás de un puerto.
4. Diagnóstico, recorrido en teléfono, gates y `Memoria.md`.

## Reversión
Los dos interruptores están apagados por omisión: compilar sin ellos deja la app como antes. Ningún dato guardado cambia el comportamiento.

## Archivos que se crearían o cambiarían
`app/lib/core/red/`, `app/lib/core/plataforma/`, `app/lib/core/router/`, un archivo de certificados raíz públicos en la app, `app/android/`, `app/test/` y `Memoria.md`.

## Estimación sin medir
7 a 9 horas en total.
