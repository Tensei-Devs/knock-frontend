# Plan 043 — Panel web: revisión de verificaciones de identidad y reportes

> Parte de `spec.md` (Borrador).

## Enfoque
1. Vendorizar el contrato de backend 053 y generar el cliente TypeScript.
2. Servicios, guardas por permiso y rutas.
3. Pantallas de lista, detalle y acción con confirmación.
4. Textos del catálogo de traducciones, accesibilidad y pruebas.
5. `Memoria.md` y humo en el panel.

## Archivos que se crean o cambian
- `panel/src/app/features/revision-de-verificaciones-y-reportes/`
- `panel/src/app/` (rutas y menú)
- `Memoria.md`

## Dependencias y orden
Depende del contrato de backend 053 y de la sesión del panel (spec 023).
