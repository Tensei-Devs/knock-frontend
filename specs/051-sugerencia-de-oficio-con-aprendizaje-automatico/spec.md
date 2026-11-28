# Spec 051 — Sugerencia de oficio en la búsqueda, con aprendizaje automático

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Claves de trabajo:** KNOCK-266 · **Sprint:** 5 · **Responsable:** por asignar
> **Otra parte en:** knock-backend, spec 067 (allí están el texto del profesor, las opciones comparadas y la decisión principal)
> **Fuentes:** specs 021 (buscar un experto por texto), 002, 009 y 014
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`

## 1. Objetivo
Que la función de aprendizaje automático de la spec 067 se pueda usar y demostrar en el teléfono: la persona describe su problema, pide una sugerencia de oficio y decide si la usa. Solo se implementa si se aprueba la 067 con su opción A.

## 2. Historia y casos de prueba
**Historia:** Como persona que no sabe qué oficio necesita, quiero describir mi problema y ver una sugerencia, para elegir más rápido.

- **CA-01:** Dado `KNOCK_SUGERENCIA_OFICIO` sin definir, entonces la búsqueda se ve y funciona como hoy y no llama a la ruta. · Verificación: prueba de widget.
- **CA-02:** Dada la función encendida, sesión y un texto de 8 a 500 caracteres, cuando la persona toca «Sugerir oficio», entonces sale una sola petición y el botón queda deshabilitado mientras responde. No se envía mientras escribe. · Verificación: prueba de widget.
- **CA-03:** Dado `estado = sugerido`, entonces muestra hasta 3 oficios en el orden recibido, con el rótulo de §7 siempre visible y sin mostrar el puntaje como porcentaje de acierto. · Verificación: prueba de widget.
- **CA-04:** Dada una sugerencia, cuando la persona toca un oficio, entonces la búsqueda se filtra por ese oficio; sin tocarlo, nada cambia. · Verificación: prueba de widget.
- **CA-05:** Dado `sin_confianza`, entonces muestra su texto y la forma de elegir el oficio a mano. · Verificación: prueba de widget.
- **CA-06:** Dados `422`, `429` (con `Retry-After`), `503 suggestion_unavailable` o falta de red, entonces conserva lo escrito, muestra el texto de §7, no reintenta sola y la búsqueda normal sigue funcionando. Nunca muestra un resultado local como si fuera del modelo. · Verificación: prueba de widget por código.
- **CA-07:** Dado un `401`, entonces aplica el manejo de sesión de la spec 002. · Verificación: prueba unitaria.
- **CA-08:** Dados registros, caché, almacenamiento y reportes de errores, entonces el texto escrito no aparece. · Verificación: prueba de seguridad del cliente.
- **CA-09:** Dados español e inglés, lector de pantalla y texto al 200 % en 320 × 640, entonces los textos salen del ARB, los controles miden 48 dp como mínimo y el rótulo se lee. · Verificación: prueba de accesibilidad.

## 3. Alcance / No-alcance
**Dentro:** la sugerencia en la pantalla de búsqueda que la app publicada muestra de verdad, sea la propia o la integrada en el diseño de la maqueta.

**Fuera:** modelo dentro del teléfono, fotos, voz, cambiar el orden «Recomendadas», crear la solicitud sola y el asistente generativo (spec 042).

## 4. Contrato API y eventos
| Método y ruta | Cuerpo | Respuesta | Errores que la app distingue |
|---|---|---|---|
| `POST /api/v1/asistente/sugerencia-oficio` | `{ texto }` | `200 { estado, sugerencias[{ oficioClave, nombre, puntaje }], modelo{ version, datosDeEntrenamiento } }` | `400`, `401`, `413`, `422`, `429`, `503 suggestion_unavailable` |

El contrato lo fija la spec 067 y se vendoriza antes de implementar (spec 006), o se escribe a mano bajo las condiciones de la excepción vigente del repositorio.

## 5. Modelo de datos local
Nada se guarda en el teléfono.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso |
|---|---|---|
| El texto queda en el teléfono o en registros | Solo memoria y sin caché | CA-08 |
| La persona cree que la sugerencia es segura | Rótulo y elección manual | CA-03 a CA-05 |
| Mostrar reglas como si fueran el modelo | Sin respaldo local | CA-06 |
| Envíos repetidos | Un envío a la vez y sin reintento | CA-02, CA-06 |

## 7. Pantallas, textos y accesibilidad
| Situación | Español | Inglés |
|---|---|---|
| Botón | Sugerir oficio | Suggest a trade |
| Rótulo | Sugerencia de un modelo de aprendizaje automático entrenado con datos de ejemplo. Puede equivocarse; tú eliges. | Suggestion from a machine learning model trained on sample data. It can be wrong; you choose. |
| `sin_confianza` | No estamos seguros. Elige el oficio. | We’re not sure. Choose the trade. |
| `422` | Describe tu problema con 8 a 500 caracteres. | Describe your problem in 8 to 500 characters. |
| `429` | Hiciste muchas consultas. Espera {segundos} segundos. | Too many requests. Wait {segundos} seconds. |
| `503` o sin red | La sugerencia no está disponible. Puedes elegir el oficio. | The suggestion isn’t available. You can choose the trade. |

La búsqueda por texto admite menos caracteres que la sugerencia: el botón se habilita solo con la longitud de CA-02.

## 8. Pruebas, gates y límites
Unitarias, widget, seguridad del cliente, accesibilidad y recorrido en teléfono contra el entorno desplegado. Puertas: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace 051`, `codemap.py --check`.

## 9. Arquitectura y componentes
Se amplía `app/lib/features/busqueda/` (dominio, datos y presentación). La ruta queda fuera de la caché de respuestas. Sin dependencia nueva.

## 10. Dependencias con otras specs
Backend 067; frontend 002, 006, 009, 014 y 021. Según la spec 011, una función completa vale 5 puntos de la app.

## 11. Definición de terminado
CA-01 a CA-09 con pruebas en verde, CI en verde, revisión de una persona, recorrido real en teléfono y `Memoria.md` al día.

## 12. Decisiones pendientes de quien aprueba
- **D-01:** Depende de las decisiones D-01 y D-02 de la spec 067.
- **D-02:** ¿La compilación publicada lleva el interruptor encendido? *Propuesta: solo cuando el servidor desplegado la tenga encendida y se haya probado.*

## 13. Decisiones tomadas sin consulta, riesgos y dudas
- **Con botón** y no mientras se escribe: menos envíos de texto y menos carga.
- **En la búsqueda** y no en el formulario de la solicitud. Alternativa: en los dos.
- **Riesgo:** si el servidor no está desplegado con la función encendida, no se puede demostrar.
- **Estimación sin medir:** 3 a 5 horas.

## Aprobación
- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
