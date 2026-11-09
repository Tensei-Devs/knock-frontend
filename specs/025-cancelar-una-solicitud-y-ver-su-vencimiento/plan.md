# Plan 025 — Cancelar una solicitud y ver su vencimiento (app)

> Parte de `spec.md` (estado Borrador). Este plan se confirma cuando la spec esté Aprobada. **Jira:** KNOCK-70 (HU-027) y KNOCK-71 (HU-028), capa Mobile.

## Enfoque
1. **Dominio puro primero:** `Vencimiento` (presentación absoluta, relativa, menos de una hora y «cerrando»), `ReglaCancelacion`, `MotivoCancelacion`, `ResultadoCancelacion` y `PrellenadoSolicitud`, con pruebas y mutación. No depende de backend.
2. **Datos:** `cancelar(id, idempotencyKey, motivo?)` en el repositorio de la spec 015 sobre el cliente generado; mapeo de `409` por `code` (`solicitud_con_cita`, `solicitud_vencida`), `400`, `404`, `429`; campos `canceladaEn` y `puedeVolverAPedir` en el mapeador.
3. **Presentación:** línea de vencimiento y botón en el detalle; hoja de confirmación con motivo opcional; estados «Cancelada» y «Vencida»; franja en la comparación; formulario prellenado de «Volver a pedir».
4. **Trabajo (spec 019):** etiqueta por `motivoRechazo` en las cotizaciones enviadas.
5. **Integración y E2E** con API simulada y con semillas de demo (KNOCK-246).

## Archivos que se crean o cambian
- `app/lib/features/actividad/domain/` (`vencimiento.dart`, `regla_cancelacion.dart`; se modifican `solicitud.dart` y `solicitud_repository.dart`).
- `app/lib/features/actividad/data/` (`solicitud_repository_api.dart`, `solicitud_mapper.dart`).
- `app/lib/features/actividad/presentation/` (`solicitud_detalle_screen.dart`, `cotizaciones_screen.dart`, `solicitud_nueva_screen.dart`, `cancelar_solicitud_controller.dart`, `widgets/hoja_cancelar_solicitud.dart`).
- `app/lib/features/trabajo/presentation/` (etiqueta del técnico).
- `app/lib/l10n/app_es.arb`, `app_en.arb`.
- `app/test/features/actividad/`, `app/test/features/trabajo/`, `app/integration_test/cancelar_y_vencer_test.dart`.

## Dependencias
- **Specs de esta app:** 015 (detalle, comparación, formulario y borrador) es requisito; 019 para la etiqueta del técnico; 020 para la tarjeta de Actividad; 024 para llegar desde el aviso.
- **Backend:** 029 (ruta y campos; bloquea la llamada real), 020, 021 y 028. Antes de implementar, el contrato de Mercado con la ruta de 029 se vendoriza en `contracts/` (lo hace el líder; spec 006).
- **Sin dependencias externas nuevas.**

## Decisiones de la spec que este plan sigue
- Motivo opcional con los valores de backend 029 (D-01); «No, mantener» primero (D-02).
- La app nunca vence por su cuenta (D-03); sin cola sin conexión (D-04).
- «Volver a pedir» crea una solicitud nueva prellenada (D-05) y se muestra solo con `puedeVolverAPedir` (D-09).
- Tras cancelar se vuelve a pedir el detalle (D-08).

## Riesgos del plan
- Si la spec 015 no está implementada, esta spec no tiene detalle ni formulario donde montarse: se toma después de las tareas de la 015.
- `GET /tecnicos/me/trabajo` lo fija la spec 036 (Borrador); la etiqueta del técnico se prueba con dobles.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con la prueba indicada (`python3 scripts/sdd_lint.py --trace 025`).
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
