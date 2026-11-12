# Tareas 024 — Notificaciones de la cadena de solicitudes

> **Estado:** pendientes; las specs 015 y 016 están aprobadas y las demás en borrador. Las tareas de cada spec se activan cuando esa spec esté Aprobada. **Jira:** KNOCK-60 (HU-050, capa Mobile).
> Columna «Paralelo»: **P** = se puede tomar a la vez que otras P sin esperar; **B** = bloquea a las que la nombran en «Depende de».

| Tarea | Qué se hace | Cubre | Depende de | Paralelo | Dependencia de backend | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | `EventoAviso` con la tabla de §4.2, `CargaAviso.desde`, `IdRecurso` y ejemplos de carga en `test/fixtures/avisos/` (válidos e inválidos) | R-01, R-02, R-04 · CA-08 | — | B (bloquea T-03, T-04, T-05) | Ninguna (la carga la define esta spec) | Erick | pendiente |
| T-02 | Textos por evento en los ARB (es y en), `texto_aviso.dart` y prueba de palabras prohibidas | R-03, R-14 · CA-01, CA-02 | — | P | Ninguna | Erick | pendiente |
| T-03 | `destino_aviso.dart`: plantillas de ruta, rol requerido y respaldo a la regla de la spec 012; integrarlo en `abrirPantallaDesdeNotificaciones` | R-04, R-06 · CA-03, CA-04, CA-05, CA-06, CA-09 | T-01 | P (con T-04) | Rutas de 020, 021, 022, 028 y 030 ya fijadas (Borrador) | Erick | pendiente |
| T-04 | `presentador_avisos.dart`: sesión, preferencias, duplicados (`avisosVistos` en memoria), primer plano y conversación abierta | R-07, R-08, R-09, R-10 · CA-10, CA-12, CA-13, CA-14 | T-01 | P (con T-03) | Ninguna | Alexis | pendiente |
| T-05 | Aviso dentro de la app y `refresco_por_aviso.dart` (invalida Actividad, Trabajo, detalle y conversaciones) | R-07, R-15 · CA-11, CA-17 | T-04; componente de aviso de la spec 014 si existe | P | Ninguna | Erick | pendiente |
| T-06 | Estado «no disponible» (404) con su botón de regreso en los destinos donde falte, y estado sin conexión al llegar desde un aviso | R-05 · CA-07, CA-19 | T-03; pantallas de 015, 016, 019 y 020 | P | 020, 021, 022 (404 por recurso) | Erick | pendiente |
| T-07 | Sección de avisos de Configuración: nombres de los tipos, «Siempre activo» y franja de permiso negado con «Abrir ajustes» | R-11, R-14, R-15 · CA-15, CA-17 | T-02 | P | Ninguna | Alexis | pendiente |
| T-08 | Cierre de sesión: cancelar notificaciones mostradas y vaciar `avisosVistos`; registro solo de `evento` y `ResultadoAviso` (prueba global de la spec 009) | R-10, R-12 · CA-14, CA-16 | T-04 | P | Ninguna | Alexis | pendiente |
| T-09 | Evaluar y registrar en `Memoria.md` la dependencia de notificaciones locales (licencia, mantenimiento, OSV, permisos que agrega) | D-02 | — | P (no bloquea el dominio) | Ninguna | José (aprueba la dependencia) | pendiente |
| T-10 | Adaptador real: notificaciones locales con canal por tipo, etiqueta `evento:recurso`, visibilidad privada, `PendingIntent` inmutable; mensajes de datos de Firebase en primer y segundo plano; manifiesto sin enlaces nuevos | R-02, R-08, R-13 · CA-01, CA-10, CA-18 | T-04, T-09; adaptador de Firebase de la spec 012 | B (bloquea T-11) | Ninguna para compilar; la configuración de Firebase la entrega el líder | Erick | pendiente |
| T-11 | Integración (`integration_test/avisos_test.dart`) con dobles y E2E manual en emulador con un aviso de prueba por evento disponible | CA-03 a CA-07, CA-11, CA-19 | T-03, T-05, T-06, T-10 | B (cierre) | **Sí:** spec de envío de notificaciones (HU-050) con la carga v1; 028, 029 y 030 (eventos ya definidos, en Borrador) | Erick con Guillermo (backend) | pendiente |

**Orden sugerido para trabajar en paralelo:** T-01, T-02 y T-09 al mismo tiempo → T-03, T-04 y T-07 en paralelo → T-05, T-06 y T-08 en paralelo → T-10 → T-11. Solo T-10 y T-11 esperan a otros (spec 012 real y backend); el resto se revisa por pares sin esperar.

**Trazabilidad requisito → criterio**

| Requisito | Criterios |
|---|---|
| R-01 | CA-01 |
| R-02 | CA-02, CA-08 |
| R-03 | CA-01, CA-02 |
| R-04 | CA-03, CA-04, CA-05, CA-06, CA-08 |
| R-05 | CA-07, CA-19 |
| R-06 | CA-09 |
| R-07 | CA-11, CA-12 |
| R-08 | CA-10 |
| R-09 | CA-13 |
| R-10 | CA-14 |
| R-11 | CA-15 |
| R-12 | CA-16 |
| R-13 | CA-18 |
| R-14 | CA-01, CA-17 |
| R-15 | CA-17 |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde y `python3 scripts/sdd_lint.py --trace 024` no marca `FALTA`.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
