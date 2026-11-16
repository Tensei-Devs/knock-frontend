# Plan 044 — Panel web: catálogo de oficios, oficios pedidos y lista de espera

> Parte de `spec.md` (Borrador).

## Enfoque
1. Vendorizar el contrato de backend 045 y generar el cliente TypeScript.
2. Servicios, guardas por permiso y rutas.
3. Pantallas de lista, detalle y acción con confirmación.
4. Textos del catálogo de traducciones, accesibilidad y pruebas.
5. `Memoria.md` y humo en el panel.

## Archivos que se crean o cambian
- `panel/src/app/features/catalogo-de-oficios/`
- `panel/src/app/` (rutas y menú)
- `Memoria.md`

## Dependencias y orden
Depende del contrato de backend 045 y de la sesión del panel (spec 023).
