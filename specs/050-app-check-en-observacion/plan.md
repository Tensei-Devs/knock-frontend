# Plan 050 — App Check en la app

> Parte de `spec.md` (estado Borrador; no habilita código). Redactado el 2026-11-28.

## Enfoque
1. Revisar la dependencia y la excepción de licencias, si hace falta.
2. Puerto, transporte y tiempos, con pruebas primero y el interruptor apagado.
3. Configuración manual en Firebase y Google Play, sin activar «Aplicar» en ningún producto.
4. Recorrido en el teléfono con microG, gates y `Memoria.md`.

## Reversión
Compilar sin `KNOCK_APP_CHECK` deja las peticiones como antes.

## Archivos que se crearían o cambiarían
`app/lib/core/`, `app/pubspec.yaml` y su bloqueo, `app/test/` y `Memoria.md`. `security/exceptions.yaml` y el flujo de CI son archivos protegidos.

## Estimación sin medir
3 a 5 horas de app y pruebas, más 1 a 2 horas de configuración y recorrido.
