# Tareas 016 — Visita con código y aviso de confianza (pantallas)

> **Estado:** en curso: la vista del cliente (T-02, T-04 y la mayor parte de T-06) está hecha en la PR #54 (KNOCK-83); faltan el contrato y el repositorio API, la llegada del técnico (KNOCK-85) y el aviso de confianza (KNOCK-84).
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz. «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 022 y regenerar el cliente Dart | §4 | Backend 022 publicado en OpenAPI | T-03, T-05 | T-02 | Guillermo (contrato) y Erick | pendiente |
| T-02 | Dominio: `Visita`, estados, `ResultadoLlegada`, `ErrorLlegada` y contenido sin código para avisos | R-01, R-02, R-09 · CA-09 | — | T-03, T-04, T-05, T-06, T-07 | T-01 | Erick Trejo Reséndiz | hecho (#54) |
| T-03 | Datos: `visita_mapper.dart` por rol y `visita_repository_api.dart` | R-04, R-07 · CA-03, CA-05, CA-07 | T-01, T-02 | T-08 | T-04, T-05 | Erick Trejo Reséndiz | pendiente |
| T-04 | Copia local en el almacén seguro, sin dirección del domicilio, y `borrarDatosDeVisita()` desde el cierre de sesión | R-03, R-17 · CA-02, CA-16, CA-18, CA-19 | T-02 | T-09 | T-03, T-05 | Erick Trejo Reséndiz | hecho (#54) |
| T-05 | Llegada: `llegada_repository_api.dart` con mapeo de 422 y 409 | R-08, R-09, R-16 · CA-10–CA-13, CA-17 | T-01, T-02 | T-08 | T-03, T-04 | Erick Trejo Reséndiz | pendiente |
| T-06 | Pantalla de la visita (domicilio y taller), código oculto, «Cómo llegar», motivos sin código y botón «Avisar» | R-01, R-05, R-06, R-18 · CA-01, CA-04, CA-06–CA-08, CA-21 | T-02 | T-08 | T-07 | Erick Trejo Reséndiz | parcial (#54): vista del cliente hecha; CA-05 espera el repositorio API |
| T-07 | Pantalla de llegada del técnico con `puedeLlegar`, intentos y bloqueo | R-08, R-15 · CA-11, CA-12, CA-20 | T-02 | T-08 | T-06 | Erick Trejo Reséndiz | pendiente |
| T-08 | Rutas, estados de error y espera por 429, accesibilidad (lectura dígito por dígito, 48 dp, 200 %) y ARB. **Tarea explícita de claves ARB:** agregar `errorFueraDeVentana` y `errorVisitaNoVigente` en `app_es.arb` y `app_en.arb` con los textos del catálogo de §7 (la spec no edita `.arb` por sí misma; esta tarea es el único lugar donde se hace) | R-11–R-14 · CA-14, CA-15 | T-03, T-05, T-06, T-07 | T-09 | — | Erick Trejo Reséndiz | parcial (#54): accesibilidad, 200 % y claves de la vista del cliente; faltan las de la llegada |
| T-09 | Integración con API simulada, recorrido real con semillas y código enmascarado en capturas, `Memoria.md` y PR | §11 | T-04, T-08 | — | — | Erick Trejo Reséndiz | pendiente |

## Dependencias con backend y con otras specs
- **Backend 022** debe publicar `GET /visitas/{id}` y `POST /visitas/{id}/llegada` antes de T-01.
- **Backend 021** crea la visita al elegir; sin ella el recorrido real de T-09 usa visitas de semilla.
- **Spec 022 (frontend)** aporta la hoja del aviso; T-06 solo coloca el botón.

## Ruta crítica y trabajo en paralelo
- Ruta crítica: backend 022 publicado → T-01 → T-03 y T-05 → T-08 → T-09.
- En paralelo: T-02, T-04, T-06 y T-07 con dobles de pruebas; una persona puede tomar la vista del cliente (T-03, T-04, T-06) y otra la del técnico (T-05, T-07).

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 016` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
