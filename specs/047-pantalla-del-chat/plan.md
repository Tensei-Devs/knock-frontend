# Plan 047 — Pantalla del chat

> Parte de `spec.md` (estado Borrador; no habilita código). Redactado el 2026-11-27.

## Enfoque
1. Dominio y repositorio de las cinco rutas, con pruebas primero (ADR-007 mientras el contrato no se vendorice).
2. Ampliar el canal en vivo: unirse, salir y evento `mensajeConversacion`, sin abrir una segunda conexión.
3. Controlador: historial, envío único, leído y reconexión.
4. Pantalla, textos es/en, accesibilidad y entradas (lista, cotización, solicitud nueva).
5. Gates, `Memoria.md` y recorrido con dos cuentas.

## Archivos que se crean o cambian
- `app/lib/features/mensajes/`, `app/test/features/mensajes/`
- `app/lib/features/maqueta/` (archivo nuevo de la conversación y enganches), `app/lib/core/router/`, `app/lib/l10n/`, `Memoria.md`

## Dependencias y orden
Aprobación de esta spec. Los enganches en la comparación y en Trabajo van al final porque otras tareas tocan esos archivos.
