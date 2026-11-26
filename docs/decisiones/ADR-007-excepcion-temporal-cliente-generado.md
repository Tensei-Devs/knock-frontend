# ADR-007 — Excepción temporal al cliente generado de la API

- **Estado:** Propuesta, con 1 de 2 firmas
- **Fecha de redacción:** 2026-11-26
- **Vence:** 2026-12-15
- **Afecta a:** constitución §3 y §4 (el cliente se genera desde OpenAPI) y spec 006 (nadie escribe llamadas HTTP a mano)

## Contexto
El contrato vendorizado en `sprint-05` no incluye todas las operaciones que la app necesita. El contrato nuevo (PR #110) está detenido por el control de cambios incompatibles. Parte de las integraciones ya fusionadas se escribió a mano, **antes** de redactar esta excepción: hay llamadas de ese tipo en `core/` y en las funciones `actividad`, `bandeja_avisos`, `busqueda`, `cuenta`, `direcciones`, `explorar`, `inicio`, `mi`, `oficios`, `opiniones`, `reportes`, `tecnico`, `tecnicos_confianza` y `visita`.

## Decisión propuesta
Hasta la fecha de vencimiento se permiten repositorios escritos a mano, solo si:
1. la ruta, el método y los campos salen del OpenAPI de la rama `contract/api-89d9be3`;
2. viven en `features/<función>/data` y usan `core/red` (transporte autenticado y lectura del contrato);
3. tienen pruebas con la API simulada;
4. la spec de la función está Aprobada.

No cambia ningún otro control: contrato, CI, seguridad y cobertura siguen igual.

## Consecuencias
- Un cambio del contrato no rompe la compilación en esas funciones: puede fallar al ejecutarse.
- Pendiente antes del vencimiento: vendorizar el contrato, regenerar el cliente y sustituir los repositorios escritos a mano.

## Firma
La constitución (§11) pide la aprobación de al menos dos integrantes.

- [x] Aprobado por: Julián Hernández · Fecha: 2026-11-26
- [x] Aprobado por: Angel Alexis Blas Castillo· Fecha: 2026-11-26
