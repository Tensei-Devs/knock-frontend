# Tareas 022 — Avisar a alguien de confianza

> **Estado:** pendientes; las specs 015 y 016 están aprobadas y las demás en borrador. Las tareas de cada spec se activan cuando esa spec esté Aprobada.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz. «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar `POST /visitas/{id}/aviso` y regenerar el cliente | §4 | Backend 022 publicado en OpenAPI | T-04 | T-02 | Erick Trejo Reséndiz | pendiente |
| T-02 | Dominio: `ContactoConfianza`, `MensajeAviso`, `CanalDeAviso` y enlaces codificados | R-02, R-04–R-06 · CA-02, CA-03, CA-05, CA-07, CA-09, CA-10 | — | T-03, T-04, T-05 | T-01, T-03 | Erick Trejo Reséndiz | pendiente |
| T-03 | Datos: contactos en el almacén seguro (máximo 10, editar, borrar, `borrarTodos()` al cerrar sesión) | R-01 · CA-04, CA-06, CA-08, CA-13 | T-02 | T-06 | T-01, T-04 | Erick Trejo Reséndiz | pendiente |
| T-04 | Datos: `aviso_repository_api.dart` (cuerpo vacío, validación de la respuesta, 409 y 429) | R-07, R-08 · CA-15, CA-16 | T-01, T-02 | T-07 | T-03 | Erick Trejo Reséndiz | pendiente |
| T-05 | Hoja del aviso: contactos, vista previa (sin código ni dirección), canales y «Compartir sin guardar» | R-04, R-05 · CA-01, CA-12 | T-02 | T-07 | T-06 | Erick Trejo Reséndiz | pendiente |
| T-06 | Pantalla de contactos en Mi cuenta, formulario y ruta `/cuenta/contactos-de-confianza` | R-01, R-02 · CA-14 | T-03 | T-07 | T-05 | Erick Trejo Reséndiz | pendiente |
| T-07 | Manifiesto (`queries` y sin permisos), accesibilidad y seguridad negativa | R-03, R-10, R-11 · CA-11, CA-17, CA-18 | T-04, T-05, T-06 | T-08 | — | Erick Trejo Reséndiz | pendiente |
| T-08 | Integración con API simulada, recorrido en emulador con contactos ficticios, ARB es/en y colores y tipografías del tema, `Memoria.md` y PR | R-09 · §11 | T-07 | — | — | Erick Trejo Reséndiz | pendiente |

## Dependencias con backend y con otras specs
- **Backend 022** fija el aviso; si no está, la hoja usa el texto local (CA-16) y el registro queda pendiente.
- **Frontend 016** se implementa antes (botón y copia local de la visita).

## Ruta crítica y trabajo en paralelo
- Ruta crítica: frontend 016 (botón) y backend 022 → T-01 → T-04 → T-07 → T-08.
- En paralelo: T-02, T-03, T-05 y T-06.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 022` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
