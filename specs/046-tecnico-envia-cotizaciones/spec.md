# Spec 046 — El técnico ve una solicitud y envía su cotización (pantallas)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Redacción:** 2026-11-26, **después** de que las rutas existen en el backend (contrato `docs/openapi.publico.v1.json` de `origin/develop` de knock-backend). En `sprint-05` la app no llama a `POST /api/v1/solicitudes/{id}/cotizaciones`; solo existe la pantalla simulada `CotizarScreen` de la maqueta (`features/maqueta/`, spec 045), que es anterior a este documento y no es implementación de esta spec.
> **Claves de trabajo:** KNOCK-266 (tarea paraguas) · **Sprint:** por definir · **Prioridad:** por definir
> **Otra parte en:** knock-backend (specs 020 y 028). **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`

## 1. Objetivo
Que una persona con perfil de técnico abra una solicitud que puede cotizar, vea lo necesario para ponerle precio y envíe una cotización.

## 2. Historia y casos de prueba
**Historia:** Como técnico, quiero ver el detalle de una solicitud y enviar mi cotización, para que el cliente pueda elegirme.

- **CA-01:** Dado un técnico que abre una solicitud, cuando `GET /api/v1/solicitudes/{id}` responde `200`, entonces ve oficio, colonia, descripción, fotos, día y franja, y el modelo de la vista del técnico no tiene campos de dirección, nombre ni teléfono del cliente. · Verificación: prueba unitaria del mapeo.
- **CA-02:** Dado un `404` en el detalle (inexistente, ajena o ya no cotizable), cuando llega, entonces la app muestra «ya no está disponible» sin distinguir la causa. · Verificación: prueba de widget.
- **CA-03:** Dado el formulario, cuando el técnico elige `fijo`, `rango` o `visita`, entonces pide solo los montos de ese tipo (`rango`: mínimo menor que máximo; todos enteros de 1 a 200 000), un día entre la fecha de la solicitud y 7 días después, y una hora `HH:mm`. · Verificación: pruebas unitarias del validador y de widget.
- **CA-04:** Dada una cotización válida, cuando `POST /api/v1/solicitudes/{id}/cotizaciones` responde `201`, entonces la app muestra el `tope` y el `requiereAprobacion` que devuelve el servidor, sin calcularlos, y vuelve a leer Trabajo. · Verificación: prueba de widget con repositorio falso.
- **CA-05:** Dados `409 request_not_quotable`, `quote_duplicate` o `quote_quota_full`, cuando llegan, entonces la app explica cada caso y ya no ofrece enviar. · Verificación: prueba de widget por código.
- **CA-06:** Dados `400`, `413`, `422` (por campo o `content_rejected`), `429` con `Retry-After` o `503`, cuando llegan, entonces la app muestra el mensaje del catálogo y conserva lo escrito. · Verificación: prueba de widget por código.
- **CA-07:** Dado `403 not_a_technician`, cuando llega, entonces la app trata a la persona como sin perfil de técnico y no muestra el formulario (spec 019, CA-10). Dado `401`, aplica el manejo de sesión de la spec 002. · Verificación: pruebas de widget y unitaria.
- **CA-08:** Dado un envío en curso o sin respuesta, cuando la persona vuelve a tocar «Enviar», entonces no sale una segunda petición mientras la primera sigue; si no hubo respuesta, la app no reintenta sola. · Verificación: prueba de widget.
- **CA-09:** Dadas las pantallas, cuando se usan en español e inglés, con lector de pantalla y texto al 200 %, entonces los textos salen del ARB y los controles miden al menos 48 dp. · Verificación: pruebas de widget y accesibilidad.
- **CA-10:** Dados los registros, la caché y el almacenamiento, cuando se revisan, entonces no contienen descripción, nota, colonia ni enlaces de fotos. · Verificación: prueba de seguridad del cliente.

## 3. Alcance / No-alcance
**Dentro:** detalle de la solicitud para el técnico, formulario de cotización, envío y sus errores.

**Fuera (ya cubierto o de otra spec):**
- Bandeja de solicitudes nuevas (`GET /api/v1/tecnicos/me/solicitudes`) y descarte: spec 019.
- Lista de cotizaciones enviadas (`GET /api/v1/tecnicos/me/cotizaciones`): spec 038 (CA-08 a CA-11 y CA-14).
- Comparar y elegir (`GET` de cotizaciones, lado del cliente): spec 015.
- Referencia de mercado: spec 038. Borrador con IA: spec 042. Cotización final y ajustes: spec 039.
- Chat: spec 020. Retirar o editar una cotización.

## 4. Contrato API y eventos

| Método y ruta | Cuerpo | Respuesta | Errores que la app distingue |
|---|---|---|---|
| `GET /api/v1/solicitudes/{id}` (backend 020, R-08) | — | `200`, vista del técnico: `{ id, estado, modalidad, oficio{clave, nombre}, colonia{id, nombre, cp}, descripcion, fotos[{ id, url, venceEn }], dia, franja, venceEn, creadoEn }` (sin `direccion` ni `totalCotizaciones`) | `400`, `401`, `404`, `429` |
| `POST /api/v1/solicitudes/{id}/cotizaciones` (backend 020, R-10) | `{ tipoPrecio, precio?, precioMin?, precioMax?, dia, hora, nota? }` (hasta 8 KB; `nota` hasta 300) | `201` `{ id, solicitudId, estado, tipoPrecio, precio, precioMin?, precioMax?, tope, requiereAprobacion, dia, hora, nota?, creadoEn }` | `400`, `401`, `403 not_a_technician`, `404`, `409 request_not_quotable`, `quote_duplicate` o `quote_quota_full`, `413`, `422` (por campo o `content_rejected`), `429`, `503 moderation_unavailable` |

- `fijo` y `visita` usan `precio`; `rango` usa `precioMin` y `precioMax`.
- La elegibilidad, el `tope`, el cupo de 5 cotizaciones y la moderación los decide el servidor. Límite: 3 cotizaciones por minuto por técnico.
- La ruta no usa clave de idempotencia; una segunda cotización del mismo técnico responde `409 quote_duplicate`.
- Se usa el cliente generado desde `contracts/` (spec 006).

## 5. Modelo de datos local
Nada se guarda en el teléfono ni en la caché de respuestas (`Cache-Control: private, no-store`). El formulario vive en memoria.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso |
|---|---|---|
| El técnico ve datos del cliente antes o después de ser elegido | El modelo no tiene esos campos | CA-01 |
| Cotizar sin perfil o fuera de su oficio y zona | Lo decide el servidor (`403`, `404`) | CA-02, CA-07 |
| Doble envío | Botón desactivado y `409 quote_duplicate` | CA-05, CA-08 |
| Datos en registros o en disco | Sin caché ni registros de contenido | CA-10 |

## 7. Pantallas, textos y accesibilidad
| Pantalla | Estados | Textos (ARB) |
|---|---|---|
| Detalle de solicitud para el técnico | carga, con datos, no disponible, error, sin conexión | claves `cotizar*` en `app_es.arb` y `app_en.arb` |
| Cotizar | edición, enviando, enviada, error | claves `cotizar*` |

## 8. Pruebas, gates y límites
Unitarias (validador, mapeo, errores), widget (estados, idiomas, accesibilidad), contrato con el cliente generado y seguridad del cliente. Puertas: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace 046`, `codemap.py --check`.

## 9. Arquitectura y componentes
En `app/lib/features/trabajo/` con `domain/`, `data/` y `presentation/` (spec 001). No se crean modelos que dupliquen los del cliente generado ni los de la spec 015 que sirvan (`Modalidad`, `Franja`).

## 10. Dependencias con otras specs
Backend 020 y 028; frontend 001, 002, 006, 015, 019 (y su enmienda del 2026-11-26), 038 y 042.

## 11. Definición de terminado
CA-01 a CA-10 con pruebas en verde, CI en verde, revisión de una persona y `Memoria.md` al día.

## 12. Decisiones tomadas sin consulta
- Spec separada: 019 deja fuera el envío y 038 solo lista lo ya enviado.
- El lugar del código es `features/trabajo/`.

## 13. Riesgos y dudas abiertas
Decisiones pendientes antes de firmar:
1. **Nota:** `docs/endpoints.md` del backend dice que la nota necesita moderación «actualmente no disponible». Confirmar si hoy funciona en el entorno desplegado y, si no, si el campo `nota` se oculta.
2. **Entrada y ruta:** desde la tarjeta de «Solicitudes nuevas» (spec 019) y qué ruta de go_router usa.
3. **Claves:** si basta KNOCK-266 o se enlaza la historia de enviar cotización (019 cita HU-029 y HU-031) y quién responde.
4. **Ya cotizada** (`yaCotizo`): si el detalle muestra la cotización propia; el detalle no la devuelve y habría que tomarla de la spec 038.

## Aprobación
- [ ] Revisor 1 — nombre: ______ fecha: ______
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
