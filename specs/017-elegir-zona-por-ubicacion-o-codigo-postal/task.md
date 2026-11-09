# Tareas 017 — Elegir zona por ubicación o código postal (pantalla)

> **Estado:** pendientes. En esta etapa **no se ejecutan**: se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo). «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar backend 023 y confirmar las formas de `colonias/en-punto` y `PUT /me` | §4 | Backend 023 publicado en OpenAPI | T-03, T-04, T-05 | T-02 | Ángel Alexis Blas Castillo (contrato) y Erick | pendiente |
| T-02 | Dominio: `Zona`, `ResultadoZona`, `RegistroListaEspera`, validación del CP y del municipio | R-04, R-05, R-08 · CA-08, CA-12 | — | T-03, T-04, T-05, T-06 | T-01 | Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo) | pendiente |
| T-03 | Datos: ubicación sin caché ni registros y código postal con caché en `catalogo/zonas/` | R-02, R-03, R-09 · CA-01, CA-09 | T-01, T-02 | T-07 | T-04, T-05 | Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo) | pendiente |
| T-04 | Datos: guardado en el perfil con `PUT /api/v1/me` reenviando `nombre` y `fotoUrl`; `almacen_zona.dart` y `borrarZonaLocal()` | R-06, R-10, R-16 · CA-07, CA-13 | T-01, T-02 | T-07 | T-03, T-05 | Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo) | pendiente |
| T-05 | Datos: lista de espera (201 y 200 con `yaRegistrado`) y errores 422 | R-08, R-15 · CA-05, CA-14 | T-01, T-02 | T-08 | T-03, T-04 | Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo) | pendiente |
| T-06 | Pantallas: paso de zona, selector, lista de espera, «Ahora no» y tarjeta «Tu zona» con mensajes de §7 | R-01, R-07, R-11–R-14 · CA-02–CA-04, CA-06, CA-10 | T-02 | T-07 | T-03, T-04, T-05 | Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo) | pendiente |
| T-07 | Seguridad negativa (coordenadas y CP fuera de registros y caché), accesibilidad y prueba del manifiesto | R-03, R-14, R-16 · CA-11, CA-15 | T-03, T-04, T-06 | T-08 | — | Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo) | pendiente |
| T-08 | Integración con API simulada, recorrido real (CP y ubicación) con datos ficticios, ARB, `Memoria.md` y PR | §11 | T-05, T-07 | — | — | Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo) | pendiente |

## Dependencias con backend y con otras specs
- **Backend 023** debe publicar sus dos rutas antes de T-01.
- **Backend 017** ya está aprobada; su `PUT /api/v1/me` se usa tal cual.
- **Backend 023, riesgo abierto:** que el registro de acceso no escriba la consulta con coordenadas de `colonias/en-punto`.

## Ruta crítica y trabajo en paralelo
- Ruta crítica: backend 023 publicado → T-01 → T-03/T-04/T-05 → T-07 → T-08.
- En paralelo: T-02 y T-06 con dobles de pruebas desde el primer día.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 017` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
