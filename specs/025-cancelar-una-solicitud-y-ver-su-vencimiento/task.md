# Tareas 025 — Cancelar una solicitud y ver su vencimiento (app)

> **Estado:** pendientes; las specs 015 y 016 están aprobadas y las demás en borrador. Las tareas de cada spec se activan cuando esa spec esté Aprobada. **Jira:** KNOCK-70 (HU-027) y KNOCK-71 (HU-028), capa Mobile.
> Columna «Paralelo»: **P** = se puede tomar a la vez que otras P sin esperar; **B** = bloquea a las que la nombran en «Depende de».

| Tarea | Qué se hace | Cubre | Depende de | Paralelo | Dependencia de backend | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | `Vencimiento` y `PresentacionVencimiento` en zona `America/Mexico_City` (límites de 1 h y 24 h, «cerrando») | R-05, R-06 · CA-09, CA-10 | — | P | Ninguna (`venceEn` ya está en backend 020) | Alexis | pendiente |
| T-02 | `ReglaCancelacion`, `MotivoCancelacion`, `ResultadoCancelacion`, `PrellenadoSolicitud`; `Solicitud` con `canceladaEn`, `vencidaEn` y `puedeVolverAPedir` | R-01, R-07, R-08 | — | B (bloquea T-03, T-04, T-06) | Nombres de backend 029 (ya fijados) | Erick | pendiente |
| T-03 | Repositorio: `cancelar(id, motivo?)` y mapeo de 200, 200 repetido, 400, 404, 409 (`request_with_appointment`, `request_expired`), 429 y 5xx | R-02, R-03, R-04 · CA-04, CA-07 | T-02; contrato de 029 vendorizado | B (bloquea T-04) | **Sí:** 029 en el contrato de Mercado | Erick | pendiente |
| T-04 | Detalle: línea de vencimiento, «Cancelar solicitud», hoja con motivo opcional y controlador (errores, refresco del detalle) | R-01 a R-04, R-11, R-12 · CA-01, CA-02, CA-03, CA-05, CA-06, CA-08 | T-01, T-03; detalle de la spec 015 | B (bloquea T-08) | 029 | Erick | pendiente |
| T-05 | Estados «Cancelada» y «Vencida» en el detalle y franja de la comparación con «Volver a pedir» según `puedeVolverAPedir` | R-07 · CA-11, CA-14 | T-02; comparación de la spec 015 | P (con T-04) | 021 (`puedeElegir`, `motivo`) y 029 (`puedeVolverAPedir`) | Alexis | pendiente |
| T-06 | «Volver a pedir»: formulario de la spec 015 prellenado (oficio, descripción, franja; fotos si se aceptan) sin día ni dirección | R-08, R-10 · CA-12, CA-13 | T-02; formulario y borrador de la spec 015 | P (con T-04 y T-05) | 020 (creación); validar reutilización de fotos | Erick | pendiente |
| T-07 | Trabajo: «Solicitudes nuevas» sin las cerradas y etiqueta por `motivoRechazo` en cotizaciones enviadas | R-09 · CA-15 | T-02; pantalla de la spec 019 | P | 028 (`GET /tecnicos/me/solicitudes`); `GET /tecnicos/me/trabajo` (spec 036, Borrador) | Alexis | pendiente |
| T-08 | Textos ARB (es y en), accesibilidad (48 dp, texto al 200 %, acción destructiva anunciada) y prueba global de registros | R-11, R-12 · CA-16, CA-17 | T-04, T-05, T-06 | P | Ninguna | Erick | pendiente |
| T-09 | Integración con API simulada y E2E en emulador con semillas (KNOCK-246): cancelar, 409 por cita, vencida desde el aviso, volver a pedir | CA-03, CA-05, CA-06, CA-11, CA-12 | T-04 a T-08; spec 024 para el aviso | B (cierre) | **Sí:** 029 desplegada en el entorno de prueba | Erick con Guillermo (backend) | pendiente |

**Orden sugerido para trabajar en paralelo:** T-01 y T-02 a la vez → T-03, T-05, T-06 y T-07 en paralelo (T-03 espera el contrato vendorizado) → T-04 → T-08 → T-09. Solo T-03, T-04 y T-09 esperan a backend; el resto avanza con dobles y se revisa por pares.

**Trazabilidad requisito → criterio**

| Requisito | Criterios |
|---|---|
| R-01 | CA-01, CA-02 |
| R-02 | CA-04 |
| R-03 | CA-03, CA-08 |
| R-04 | CA-05, CA-06, CA-07, CA-08 |
| R-05 | CA-09 |
| R-06 | CA-10 |
| R-07 | CA-11, CA-14 |
| R-08 | CA-12, CA-13 |
| R-09 | CA-15 |
| R-10 | CA-12, CA-17 |
| R-11 | CA-16 |
| R-12 | CA-16 |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde y `python3 scripts/sdd_lint.py --trace 025` no marca `FALTA`.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
