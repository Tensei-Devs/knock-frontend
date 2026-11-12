# Spec 021 — Buscar un experto por texto (app)

> **Jira:** KNOCK-66 («HU-012 · Buscar un experto por texto», verificada en Jira el 9 de noviembre de 2026; etiqueta `sprint-5`) · **Épica:** EP-03 Encontrar expertos · **Módulo:** catalog · **Responsable:** Erick Trejo Reséndiz (la ficha dice Ángel Alexis Blas Castillo por la capa de backend) · **Sprint:** S5 · **Puntos:** 3 · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend, spec 027 «Buscar un experto por texto» (`GET /api/v1/busqueda`)
> **Fuentes:** `docs/backlog/HU-012.md` · `docs/referencia/FUNCIONES_Y_FLUJOS.md` §3.3
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye la búsqueda; la fija backend 027 y se vendoriza antes de implementar (spec 006).
> **Estado:** Borrador

## 1. Objetivo

Que una persona que no sabe qué categoría elegir escriba con sus palabras («boiler», «frenos») en la barra de búsqueda de Inicio y llegue a los expertos correctos, con resultados, filtros, estados vacíos y sin conexión. Esta spec cubre la capa **Mobile**; los sinónimos, la tolerancia a errores de escritura y el índice son del backend.

## 2. Historia y casos de prueba

**KNOCK-66** — Como persona que no sabe qué categoría elegir, quiero buscar con mis palabras, para llegar a los expertos correctos.

- **CA-01:** Dada la pantalla Inicio, cuando la persona escribe «boiler» y busca, entonces ve expertos de plomería cercanos. · Verificación: `app/test/features/inicio/presentation/busqueda_resultados_test.dart` → `CA_021_01`
- **CA-02:** Dado «frenso» (con error), cuando busca y el servidor responde `interpretacion.estado = detectado` con `oficioDetectado`, entonces la app muestra «Buscamos: Mecánica» con el nombre recibido, sin corregir el texto en el teléfono. · Verificación: `app/test/features/inicio/presentation/busqueda_resultados_test.dart` → `CA_021_02`
- **CA-03:** Dada una respuesta con `interpretacion.estado = no_entendido`, cuando termina, entonces ve «No entendimos qué necesitas» y puede elegir la categoría con los oficios del catálogo; con `ambiguo` ve «¿Cuál de estos buscas?» con hasta 3 chips de `oficiosSugeridos`, y elegir uno repite la búsqueda con `oficio`. · Verificación: `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_03`
- **CA-04:** Dado el nombre de un negocio, cuando busca, entonces aparece ese experto si el servidor lo devuelve. · Verificación: `app/test/features/inicio/presentation/busqueda_resultados_test.dart` → `CA_021_04`
- **CA-05:** Dado un texto que, sin espacios al inicio y al final, mide menos de 2 caracteres, cuando la persona intenta buscar, entonces no se llama al servidor y se lee «Escribe al menos 2 letras»; si el servidor responde 422 con `errors.q`, se muestra «Prueba con otras palabras». · Verificación: `app/test/features/inicio/domain/consulta_busqueda_test.dart` → `CA_021_05`
- **CA-06:** Dado un texto de más de 80 caracteres, cuando la persona escribe, entonces el campo no acepta más y el contador lo indica. · Verificación: `app/test/features/inicio/domain/consulta_busqueda_test.dart` → `CA_021_06`
- **CA-07:** Dada una persona que escribe rápido, cuando teclea varias letras seguidas, entonces la app espera 400 ms de pausa antes de pedir, cancela la petición anterior y solo pinta la respuesta de la última consulta. · Verificación: `app/test/features/inicio/presentation/busqueda_controller_test.dart` → `CA_021_07`
- **CA-08:** Dados los filtros «Oficio» y «Solo verificados», cuando la persona los activa, entonces viajan al servidor como parámetros y la lista se pide de nuevo; la app no filtra en el teléfono. · Verificación: `app/test/features/inicio/presentation/busqueda_controller_test.dart` → `CA_021_08`
- **CA-09:** Dado un resultado, cuando se toca, entonces se abre «Pedir cotización» con el oficio ya elegido (`oficioClave` del oficio detectado o, si no hay, del primer oficio del resultado), saltando el paso 1 de la spec 015. · Verificación: `app/test/features/inicio/presentation/busqueda_resultados_test.dart` → `CA_021_09`
- **CA-10:** Dado un resultado, cuando se pinta, entonces muestra nombre, oficios, calificación con el número de reseñas, distancia aproximada («a unos 2 km»), insignia y nivel de verificación, colonia base y, si `atiendeTuColonia` es falso, «No atiende tu colonia»; **no** muestra teléfono, contacto ni dirección y el modelo no tiene esos campos. · Verificación: `app/test/features/inicio/data/busqueda_mapper_test.dart` → `CA_021_10`
- **CA-11:** Dada una búsqueda sin resultados pero con oficio detectado, cuando termina, entonces ve «Todavía no hay expertos de [oficio] en tu colonia» y la invitación a pedir cotización de todos modos. · Verificación: `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_11`
- **CA-12:** Dada una persona sin conexión, cuando busca, entonces ve «Sin conexión» con «Reintentar»; no hay resultados viejos presentados como actuales. · Verificación: `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_12`
- **CA-13:** Dado un 429 con `Retry-After`, un 5xx o un tiempo agotado, cuando se busca, entonces se muestra el aviso o el error del catálogo con «Reintentar» y no se reintenta en bucle. · Verificación: `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_13`
- **CA-14:** Dada una búsqueda, cuando se inspecciona el disco, la caché de respuestas y los registros, entonces el texto buscado no se guardó en ninguno; no hay historial de búsquedas. · Verificación: `app/test/features/inicio/data/busqueda_repository_api_test.dart` → `CA_021_14`
- **CA-15:** Dada una persona sin colonia guardada, cuando busca, entonces la app pide elegir la zona (spec 017) antes de mostrar distancias o resultados cercanos. · Verificación: `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_15`
- **CA-16:** Dados la barra, los chips y las tarjetas de resultado, cuando se recorren con lector de pantalla y texto al 200 %, entonces tienen etiqueta, miden al menos 48 dp y el resultado se lee completo («Plomería, 4.8 estrellas, 12 reseñas, a unos 2 km, verificado»). · Verificación: `app/test/features/inicio/presentation/accesibilidad_busqueda_test.dart` → `CA_021_16`
- **CA-17:** Dada una respuesta 400 `invalid_cursor`, 422 `colonia_not_found` o 503 `search_unavailable`, cuando llega, entonces la app reinicia la búsqueda desde la primera página, pide elegir la zona otra vez o muestra el error con «Reintentar», respectivamente, sin reintentar sola. · Verificación: `app/test/features/inicio/presentation/busqueda_controller_test.dart` → `CA_021_17`
- **CA-18:** Dada una búsqueda con más resultados, cuando la persona llega al final de la lista, entonces la app pide la siguiente página con `nextCursor` (20 por página) y, sin `nextCursor` después de 100 resultados, muestra «Mostramos los primeros 100. Agrega más palabras para afinar.» · Verificación: `app/test/features/inicio/data/busqueda_repository_api_test.dart` → `CA_021_18`

## 3. Alcance / No-alcance

**Dentro**
- Barra de búsqueda en Inicio y pantalla de resultados (`/inicio/buscar`).
- Consulta con pausa, cancelación de la anterior y mínimo de caracteres.
- Filtros por oficio y por verificados, pedidos al servidor.
- Estados de carga, resultados, vacío (con y sin oficio detectado), error, sin conexión y espera por 429.
- Paso a «Pedir cotización» con el oficio ya elegido.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.

**Fuera**
- Sinónimos, tolerancia a errores, trigramas y métricas de términos sin resultado (HU-012 §7 y §8): backend.
- El asistente conversacional con IA (HU-057).
- El perfil completo del experto: no existe todavía como spec.
- Historial de búsquedas y sugerencias al escribir.
- Búsqueda por voz.

### Requisitos

- **R-01:** La consulta se arma en `domain/` (recorte de espacios, mínimo 2 y máximo 80 caracteres) y solo entonces se pide al servidor.
- **R-02:** La app espera 400 ms desde la última tecla antes de pedir, cancela la petición anterior y descarta respuestas de consultas viejas.
- **R-03:** Los filtros viajan como parámetros; la app no reordena ni filtra resultados en el teléfono.
- **R-04:** La respuesta trae `interpretacion` (`detectado`, `ambiguo`, `no_entendido` o `elegido`); la app la muestra tal cual y no adivina el oficio.
- **R-05:** El texto buscado no se guarda en disco, en `shared_preferences`, en la caché de respuestas (spec 010) ni en registros; no hay historial.
- **R-06:** Si no hay zona guardada, se pide antes de buscar (spec 017); la búsqueda envía el `coloniaId` guardado.
- **R-07:** Un resultado no trae teléfono ni dirección; solo lo necesario para elegir a quién pedir cotización.
- **R-08:** Tocar un resultado abre la solicitud con el oficio elegido; no hay contacto directo con el experto.
- **R-09:** Todo error de la API se muestra con un texto del catálogo; nunca con el código HTTP, la URL ni el cuerpo.
- **R-10:** Todos los textos viven en los ARB de español e inglés y los colores y tipografías en el tema (spec 014).
- **R-11:** Cada control mide al menos 48 dp, tiene etiqueta y funciona con texto al 200 %.
- **R-12:** Cada resultado se identifica con un identificador opaco del servidor; la app no deriva nada de los nombres.

## 4. Contrato API y eventos

La app **consume** `GET /api/v1/busqueda` de backend 027 («Buscar un experto por texto»); alineado el 9 de noviembre de 2026 con su borrador. Si al vendorizar cambia un nombre o un tipo, se corrige aquí antes de implementar.

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/busqueda` | Buscar expertos | `q` (2–80 después de normalizar), `coloniaId` (de la zona guardada), `oficio?` (clave), `soloVerificados?` (`true`\|`false`), `cursor?`, `limit?` (1–20; la app pide 20) | `200` con `{ interpretacion{estado, oficioDetectado?, oficiosSugeridos?}, items[{ id, nombre, oficios[{clave, nombre}], calificacion, totalResenas, verificado, nivelVerificacion, coloniaBase, distanciaKm, atiendeTuColonia, fotoUrl }], nextCursor }` | `400` (`errors.q`, `invalid_cursor`), `401`, `422` (`colonia_not_found`, `trade_invalid`), `429` con `Retry-After`, `503 search_unavailable` |
| `GET /api/v1/oficios` | Chips de oficio y selector «No entendimos» | — | Catálogo cacheado (spec 010) | Ver spec 002 |

Reglas del contrato que la app da por ciertas:
- **Paginación:** cursor opaco ligado a la consulta; máximo 20 por página y 100 resultados por consulta. Cambiar el texto o un filtro empieza sin cursor.
- **Límites:** 30 búsquedas por minuto por persona, además de los del gateway; la pausa de 400 ms y la cancelación mantienen a la app lejos del límite.
- **Caché:** el servidor responde `Cache-Control: private, max-age=30`; la app no guarda la respuesta en disco ni en la caché de respuestas (R-05) y solo conserva en memoria la consulta abierta.
- **Privacidad:** el servidor no guarda el texto original; los términos sin resultado se guardan solo agregados y sin persona. La app no manda identificadores de persona en la consulta.
- **Autorización:** requiere sesión; ningún dato de contacto en la respuesta.
- **Eventos:** ninguno.

## 5. Modelo de datos

| Entidad | Campos | Reglas |
|---|---|---|
| `ConsultaBusqueda` | `texto`, `oficio?`, `soloVerificados` | Valida 2–80 caracteres y recorta espacios |
| `ResultadoBusqueda` | `interpretacion` (`estado`, `oficioDetectado?`, `oficiosSugeridos`), `expertos[]`, `nextCursor?` | Inmutable; el orden lo da el servidor |
| `ExpertoEncontrado` | `id`, `nombre`, `oficios` (`clave`, `nombre`), `calificacion`, `totalResenas`, `verificado`, `nivelVerificacion`, `coloniaBase`, `distanciaKm` (entero aproximado), `atiendeTuColonia`, `fotoUrl` | Sin teléfono, contacto ni dirección |

**Estado local**
- Solo en memoria; el texto vive en el controlador mientras la pantalla está abierta.
- Se reutiliza el catálogo de oficios con caché (spec 010).
- Nada en `shared_preferences` ni en disco (R-05).

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Fuga de información:** el texto buscado revela problemas de la persona (por ejemplo «detector de gas») | No se guarda, no se registra ni se cachea y no hay historial | CA-14 |
| **Fuga de información:** contacto o dirección del experto en la lista | El modelo no tiene esos campos | CA-10 |
| **Inyección:** consulta con caracteres especiales | Se envía como parámetro codificado; el servidor valida; la app limita a 80 caracteres y no interpreta el texto | CA-06 |
| **Denegación:** una consulta por tecla o reintentos tras un 429 | Pausa de 400 ms, cancelación y `Retry-After` | CA-07, CA-13 |
| **Suplantación:** buscar sin sesión | El cliente pone el token; 401 renueva una sola vez (spec 002) | CA-13 |
| **Elevación de privilegios:** ver resultados de otra colonia sin zona | La app envía solo la colonia guardada | CA-15 |
| **Datos obsoletos:** resultados viejos como actuales | Se descartan respuestas de consultas anteriores y no se cachean | CA-07, CA-12 |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos nuevos (ARB `busqueda*`) |
|---|---|---|---|
| Inicio (`/inicio`, se modifica) | inicial | Barra «¿Qué necesitas?» que abre la búsqueda | `busquedaPlaceholder`, `busquedaEtiqueta` |
| Búsqueda (`/inicio/buscar`) | inicial, mínimo de caracteres, carga, con resultados, sin resultados, «No entendimos», error, sin conexión, espera por 429, sin zona | Campo con contador `n/80`, chips «Oficio» y «Solo verificados», línea «Buscamos: …», tarjetas de expertos, selector de oficio | `busquedaTitulo`, `busquedaMinimo`, `busquedaContador`, `busquedaBuscamos`, `busquedaSoloVerificados`, `busquedaOficio`, `busquedaSinResultados`, `busquedaSinResultadosOficio`, `busquedaNoEntendimos`, `busquedaElegirCategoria`, `busquedaPedirCotizacion`, `busquedaSinZona`, `busquedaElegirZona`, `busquedaCargarMas` |
| Común | — | Errores del catálogo y «Reintentar» | Reutiliza `errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos` |

**Mensajes exactos** (español; el inglés va en `app_en.arb`)

| Situación | Texto en pantalla |
|---|---|
| Menos de 2 caracteres | «Escribe al menos 2 letras» |
| 422 `errors.q` | «Prueba con otras palabras» |
| `no_entendido` | «No entendimos qué necesitas» + «Elige una categoría» |
| `ambiguo` | «¿Cuál de estos buscas?» |
| Sin resultados con oficio | «Todavía no hay expertos de {oficio} en tu colonia» + «Pedir cotización de todos modos» |
| Tope de 100 | «Mostramos los primeros 100. Agrega más palabras para afinar.» |
| Sin zona o `colonia_not_found` | «Elige tu zona para buscar expertos cerca» |
| 429 | «Hiciste muchas búsquedas seguidas. Espera {segundos} segundos.» |
| Sin conexión | «Sin conexión» + «Reintentar» |
| 503 o 5xx | «La búsqueda no está disponible en este momento. Intenta de nuevo.» |

Reglas de pantalla:
- El campo recibe el foco al abrir la pantalla y muestra el teclado con `textInputAction: search`.
- Los chips muestran su estado en texto («Solo verificados, seleccionado»).
- Accesibilidad: contraste según la spec 014; la tarjeta es un solo nodo semántico; la lista anuncia cuántos resultados hay al terminar la carga.

## 8. Pruebas, gates y límites

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Consulta, pausa, descarte de respuestas viejas, mapper |
| Widget (W) | Sí | Barra, resultados, filtros y todos los estados |
| Aceptación (ACC) | Sí | CA-01 a CA-18 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` con la ruta de búsqueda de backend 027 |
| Integración (INT) | Sí | API simulada y humo contra el entorno desplegado |
| Seguridad negativa (NEG) | Sí | Consultas con símbolos, 401, 429, ausencia del texto en registros |
| Accesibilidad (A11Y) | Sí | `expectAccesible` y texto al 200 % |
| Mutación (MUT) | Sí | `domain/` con meta 70 % |
| E2E | Sí | Escribir «boiler» → resultados → tocar → solicitud con oficio |
| Regresión | Sí | Suite completa; Inicio y Oficios sin cambios de comportamiento |
| Análisis estático y vulnerabilidades | Sí | Los del CI |
| Rendimiento (PERF) | No | Volumen bajo; la pausa de 400 ms se prueba en unitarias |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | «boiler» → plomería y tarjetas con distancia |
| Positivo | Activar «Solo verificados» pide de nuevo con el filtro |
| Negativo | «xyzzy» → «No entendimos qué necesitas» y selector de oficio |
| Negativo | Solo espacios → no se llama al servidor |
| Error esperado | 401 → renueva una vez; 429 → espera; 5xx → error con «Reintentar» |
| Caso límite | 1, 2, 80 y 81 caracteres; acentos y mayúsculas; emojis |
| Caso límite | Escribir, borrar y escribir otra vez antes de que responda la primera |
| Caso límite | 0, 1 y 20 resultados, y la página 21 |
| Caso límite | Sin señal a media búsqueda |

**Gates:** los de la spec 015 (§8).

## 9. Arquitectura y componentes

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/inicio/domain/consulta_busqueda.dart` | Crear | Validación y recorte |
| `app/lib/features/inicio/domain/resultado_busqueda.dart` | Crear | Entidades de §5 |
| `app/lib/features/inicio/domain/busqueda_repository.dart` | Crear | Interfaz `buscar` |
| `app/lib/features/inicio/data/busqueda_mapper.dart` | Crear | Contrato → dominio |
| `app/lib/features/inicio/data/busqueda_repository_api.dart` | Crear | Sobre el cliente generado, sin caché |
| `app/lib/features/inicio/presentation/inicio_screen.dart` | Modificar | Barra de búsqueda |
| `app/lib/features/inicio/presentation/busqueda_screen.dart` | Crear | Pantalla de resultados |
| `app/lib/features/inicio/presentation/busqueda_controller.dart` | Crear | Pausa, cancelación, filtros y estados |
| `app/lib/features/inicio/presentation/widgets/tarjeta_experto.dart` | Crear | Tarjeta de resultado (con la tarjeta del tema (spec 014)) |
| `app/lib/core/router/rutas.dart`, `app_router.dart` | Modificar | Ruta `/inicio/buscar` |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 |

La función vive en `features/inicio/` (D-01). **No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/`.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| Backend 027 Buscar un experto por texto (otro repositorio) | Ruta, esquemas, interpretación, filtros y paginación | Sin contrato vendorizado no se implementa `data` |
| 015 Pedir y comparar cotizaciones | Parámetro `oficioClave` que salta el paso 1 | El resultado no tiene a dónde ir |
| 017 Elegir zona | `coloniaId` guardado | Sin zona no hay búsqueda cercana |
| 010 Caché | Catálogo de oficios cacheado y política de no cachear lo personal | Se cachearía el texto buscado |
| 014 Alinear la UI | Componentes y contraste | Estilos duplicados |
| 002, 009 | Errores y espera por 429 | Manejo incompleto |

## 11. Definición de terminado

- CA-01 a CA-18 con prueba que falla si la lógica está mal; `python scripts/sdd_lint.py --trace 021` sin `FALTA`.
- `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 %.
- ARB completos; contrato vendorizado y cliente generado compilando.
- Recorrido real con datos de prueba y capturas sin datos reales.
- `Memoria.md` al día; PR con la plantilla completa, etiqueta `puntos-app-N` y CI en verde.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | La búsqueda vive en `features/inicio/` | La barra está en Inicio y la constitución §4 fija cinco funciones | Crear `features/busqueda/` |
| D-02 | Mínimo 2 y máximo 80 caracteres, pausa de 400 ms | Evita consultas por tecla y texto largo con datos personales; HU-012 no fija valores | Sin límites |
| D-03 | Filtros de oficio y verificados | Backend 027 los acepta (`oficio` y `soloVerificados`) | Sin filtros |
| D-04 | Sin historial ni sugerencias | El texto puede revelar un problema de la persona | Guardar las últimas 5 búsquedas |
| D-05 | Tocar un resultado abre «Pedir cotización» con el oficio | No existe perfil del experto y la regla es no revelar contacto antes de elegir | Un perfil nuevo, fuera de alcance |
| D-06 | La app no corrige el texto ni infiere el oficio | Lo hace el servidor; evita dos criterios | Un diccionario local de sinónimos |

## 13. Riesgos y dudas abiertas

- **Resuelto en la revisión:** backend 027 fija la ruta, los filtros, `interpretacion` y la paginación; falta vendorizarlo.
- **Riesgo:** sin perfil de experto, la persona no ve más que la tarjeta antes de pedir cotización.
- **Riesgo:** el reparto es por oleadas (DECISIONES #6); mostrar «expertos cercanos» puede dar la idea de elegir a uno, cuando la solicitud llega a hasta 5. Se explica con un texto en la pantalla.
- **Resuelto en la revisión:** backend 027 acepta los dos filtros.
- **Resuelto en la revisión:** backend 027 busca también por el nombre del negocio, pero el resultado solo trae `nombre` (público); la tarjeta muestra ese nombre.
- **Duda abierta (para el equipo):** la ficha pone a Alexis como responsable por backend; esta spec asigna la capa Mobile a Erick.

## Aprobación

- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
