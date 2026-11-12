# Spec 019 — Pestaña Trabajo (lado del técnico)

> **Jira:** KNOCK-67 («HU-020 · Pestaña Trabajo (próximas visitas, solicitudes nuevas, enviadas y terminadas)», verificada en Jira el 9 de noviembre de 2026; etiqueta `sprint-5`) · **Épica:** EP-09 Lado del técnico · **Módulo:** requests · **Responsable:** Erick Trejo Reséndiz · **Sprint:** S5 (Jira ya la tiene en `sprint-5`) · **Puntos:** 5 · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend: 028 «Repartir la solicitud por oleadas» (bandeja de solicitudes nuevas y descarte), 020 (cotizaciones y sus estados) y 022 (vista de la visita del técnico); el resumen `GET /api/v1/tecnicos/me/trabajo` (visitas, enviadas, terminadas, nivel) lo fija la **spec 036** (Borrador, ver §13)
> **Fuentes:** `docs/backlog/HU-020.md` · `docs/referencia/FUNCIONES_Y_FLUJOS.md` §4 y §5 · `docs/referencia/DECISIONES.md` #4 y #6
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; la bandeja y el descarte los fija backend 028 y el resumen debe fijarlo una spec de backend que hoy no existe; se vendorizan antes de implementar (spec 006).
> **Estado:** Aprobada

## 1. Objetivo

Que una persona con rol de técnico vea en una sola pantalla de la app Android su día: próximas visitas, solicitudes nuevas, cotizaciones enviadas y trabajos terminados, con los estados de carga, vacío, error y sin conexión. Esta spec cubre la capa **Mobile**; qué solicitudes le llegan a cada técnico (reparto por oleadas), qué datos se le revelan y cuándo son del backend.

## 2. Historia y casos de prueba

**KNOCK-67** — Como técnico, quiero ver en una sola pantalla mis visitas, solicitudes nuevas, cotizaciones enviadas y trabajos terminados, para organizar mi día sin brincar entre pantallas.

- **CA-01:** Dado un técnico con sesión, cuando abre Trabajo, entonces ve las secciones en este orden: cabecera con su disponibilidad y el aviso de verificación, próximas visitas, solicitudes nuevas, cotizaciones enviadas, terminadas (plegada) y resumen con su nivel. · Verificación: `app/test/features/trabajo/presentation/trabajo_screen_test.dart` → `CA_019_01`
- **CA-02:** Dada una solicitud nueva, cuando se pinta su tarjeta, entonces muestra descripción, número de fotos, colonia y cuándo la quiere, y **nunca** dirección, teléfono ni nombre completo; el modelo de la app ni siquiera tiene esos campos. · Verificación: `app/test/features/trabajo/data/trabajo_mapper_test.dart` → `CA_019_02`
- **CA-03:** Dada una solicitud nueva, cuando el técnico toca «Descartar» y confirma, entonces la app llama a `POST /solicitudes/{id}/descartar`, al recibir 204 la tarjeta desaparece y no vuelve a aparecer al refrescar; un 409 `request_not_dismissable` o un 404 la quitan con el mensaje de §7. · Verificación: `app/test/features/trabajo/presentation/trabajo_controller_test.dart` → `CA_019_03`
- **CA-04:** Dado que el técnico toca «Descartar» y se arrepiente, cuando cierra la hoja de confirmación, entonces la solicitud sigue en la lista y no se llama al servidor. · Verificación: `app/test/features/trabajo/presentation/trabajo_controller_test.dart` → `CA_019_04`
- **CA-05:** Dada una visita aceptada, cuando se pinta su tarjeta, entonces muestra día, hora, colonia del cliente, dirección exacta (`lugar.direccion`), precio, «Cómo llegar» y «Ya llegué»; no muestra el nombre ni el teléfono del cliente (backend 022 R-05 y backend 020, decisión 6), y la dirección solo existe en las visitas aceptadas. · Verificación: `app/test/features/trabajo/presentation/tarjeta_visita_test.dart` → `CA_019_05`
- **CA-06:** Dada una visita a domicilio, cuando el técnico toca «Cómo llegar», entonces se abre la app de mapas con la dirección codificada con `Uri.encodeComponent` en una URL `https`, sin esquemas arbitrarios; si no hay app de mapas se muestra la dirección en texto. · Verificación: `app/test/features/trabajo/domain/enlace_mapa_test.dart` → `CA_019_06`
- **CA-07:** Dada una visita a domicilio, cuando el técnico toca «Ya llegué», entonces va a `/trabajo/visita/:id` (spec 016) y no se confirma nada en esta pantalla. · Verificación: `app/test/features/trabajo/presentation/tarjeta_visita_test.dart` → `CA_019_07`
- **CA-08:** Dado un técnico sin visitas, solicitudes ni cotizaciones, cuando abre Trabajo, entonces cada sección vacía explica qué sigue («Cuando te elijan, tus visitas aparecerán aquí») y no hay botones sin destino. · Verificación: `app/test/features/trabajo/presentation/trabajo_estados_test.dart` → `CA_019_08`
- **CA-09:** Dada una respuesta lenta, un error del servidor o la falta de red, cuando se abre Trabajo, entonces se muestran carga, error con «Reintentar» o «Sin conexión» con los textos del catálogo, nunca el código HTTP. · Verificación: `app/test/features/trabajo/presentation/trabajo_estados_test.dart` → `CA_019_09`
- **CA-10:** Dada una persona que no es técnico, cuando intenta abrir `/trabajo`, entonces el router la lleva a Inicio (spec 001) y un `403 not_a_technician` del servidor se trata igual, sin mostrar el contenido. · Verificación: `app/test/core/router/redireccion_trabajo_test.dart` → `CA_019_10`
- **CA-11:** Dadas la bandeja de solicitudes nuevas o la sección «Terminadas» con más de 20 elementos, cuando el técnico llega al final, entonces la app pide la página siguiente con `nextCursor`, nunca más de 20 por página y sin duplicar. · Verificación: `app/test/features/trabajo/data/trabajo_repository_api_test.dart` → `CA_019_11`
- **CA-12:** Dado un `429` con `Retry-After`, cuando se abre o se refresca Trabajo, entonces la app espera el tiempo indicado, lo dice y no reintenta en bucle. · Verificación: `app/test/features/trabajo/presentation/trabajo_controller_test.dart` → `CA_019_12`
- **CA-13:** Dada una verificación pendiente o rechazada, cuando se pinta la cabecera, entonces aparece el aviso con un botón a la verificación (spec 018, `/trabajo/verificacion`) y el nivel del resumen no sube hasta que el servidor lo diga. · Verificación: `app/test/features/trabajo/presentation/cabecera_trabajo_test.dart` → `CA_019_13`
- **CA-14:** Dado Trabajo abierto, cuando se recorre con lector de pantalla y texto al 200 %, entonces cada tarjeta se lee completa («Solicitud de plomería en colonia X, para mañana por la tarde, 2 fotos»), los controles miden al menos 48 dp y no se corta el contenido. · Verificación: `app/test/features/trabajo/presentation/accesibilidad_trabajo_test.dart` → `CA_019_14`
- **CA-15:** Dado un técnico que cierra sesión o cambia de cuenta, cuando entra otra persona, entonces no queda en el teléfono nada de Trabajo (ni caché ni estado en memoria). · Verificación: `app/test/features/trabajo/data/trabajo_repository_api_test.dart` → `CA_019_15`
- **CA-16:** Dado el registro de la app, cuando se carga Trabajo, entonces ningún `print`, registro ni reporte de errores contiene descripciones, colonias, nombres ni direcciones (prueba global de la spec 009). · Verificación: `app/test/seguridad/seguridad_cliente_test.dart` → `CA_019_16`
- **CA-17:** Dada una falla solo en el resumen o solo en la bandeja, cuando se abre Trabajo, entonces la sección que sí respondió se muestra con datos y la otra muestra su propio error con «Reintentar»; dentro del resumen no hay respuesta parcial: si falla cualquiera de sus partes (503 `unavailable`), toda la sección del resumen queda en error con «Reintentar» (spec 036 R-07); una solicitud con `yaCotizo` verdadero se marca «Ya cotizaste» y no ofrece «Descartar». · Verificación: `app/test/features/trabajo/presentation/trabajo_estados_test.dart` → `CA_019_17`

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla Trabajo (`/trabajo`, ya existe como esqueleto en `features/trabajo/presentation/trabajo_screen.dart`) con sus seis secciones.
- Tarjetas de visita, solicitud nueva, cotización enviada y trabajo terminado.
- Descartar una solicitud nueva con confirmación.
- Estados de carga, vacío, error, sin conexión y reintento; refrescar al deslizar.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.
- Pruebas unitarias, de widget, de contrato, de seguridad negativa y de accesibilidad.

**Fuera**
- El reparto por oleadas (HU-025), la disponibilidad «Disponible hoy» (HU-019: **solo se muestra**, el interruptor no se construye aquí) y las reglas de qué técnico recibe qué solicitud: backend.
- «Chatear y cotizar» y enviar la cotización (HU-029 y HU-031): el botón **no se muestra** hasta que existan (D-02). En la demo el técnico se simula con semillas (insumo N-4).
- Confirmar la llegada con el código: spec 016 (`/trabajo/visita/:id`).
- La verificación de identidad: spec 018.
- El globo de conversaciones (spec 020) y las notificaciones concretas (spec 024).

### Requisitos

- **R-01:** Trabajo solo se muestra al técnico: el router redirige a quien no tiene el rol (spec 001) y el servidor autoriza (`403 not_a_technician`).
- **R-02:** La pantalla pide dos fuentes: la bandeja de solicitudes nuevas (`GET /tecnicos/me/solicitudes`, backend 028) y el resumen con visitas, enviadas, terminadas y nivel (`GET /tecnicos/me/trabajo`, spec 036); cada sección tiene su propio estado y la app no combina ni reordena las listas.
- **R-03:** Una solicitud nueva nunca muestra dirección, teléfono ni nombre completo del cliente; solo descripción, fotos, colonia y cuándo la quiere.
- **R-04:** La dirección exacta y la colonia del cliente solo aparecen en las visitas aceptadas; el nombre y el teléfono del cliente no se muestran al técnico en esta etapa (backend 020, decisión 6).
- **R-05:** «Descartar» pide confirmación y quita la tarjeta al recibir 204; con 409 `request_not_dismissable` o 404 la quita y lo explica; con otro error la deja y explica el motivo. Una solicitud con `yaCotizo` no se puede descartar.
- **R-06:** Las fotos de las solicitudes se muestran solo desde direcciones `https` de los dominios permitidos de Knock (misma regla que la spec 015, CA-21) y no se guardan en la caché de respuestas ni en disco (spec 010).
- **R-07:** Trabajo **no** se guarda en la caché de respuestas (spec 010, R-04): contiene datos personales y cambia a cada solicitud.
- **R-08:** La bandeja y «Terminadas» paginan con cursor (`cursor`, `limit` ≤ 20, `nextCursor`); «Terminadas» llega plegada.
- **R-09:** Cada tarjeta se lee completa con el lector de pantalla y mide al menos 48 dp en sus acciones.
- **R-10:** Todo error de la API se muestra con un texto del catálogo; nunca con el código HTTP, la URL ni el cuerpo.
- **R-11:** Todos los textos viven en los ARB de español e inglés y todos los colores y tipografías en el tema (spec 014).
- **R-12:** La app nunca registra en consola, en caché ni en un reporte de errores el contenido de las tarjetas.

## 4. Contrato API y eventos

La app **consume**. La bandeja y el descarte los fija backend 028 («Repartir la solicitud por oleadas»); el resumen lo fija el borrador de la spec 036 de backend (R-02 a R-09; antes era una propuesta de HU-020 §7) y se confirma al vendorizar. Alineado con los borradores de backend 028 y 036.

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/tecnicos/me/solicitudes` (backend 028) | Solicitudes nuevas | `cursor?`, `limit?` (1–20; la app pide 20) | `200` `CursorPage<SolicitudRecibida>` (`items[]`, `nextCursor`); cada elemento `{ solicitudId, oficio{clave, nombre}, colonia{nombre, cp}, descripcion, fotos[], dia, franja, modalidad, venceEn, oleada, recibidaEn, yaCotizo }` | `400`, `401`, `403 not_a_technician`, `429` con `Retry-After` |
| `POST /api/v1/solicitudes/{id}/descartar` (backend 028) | Descartar una solicitud nueva | vacío | `204` (también al repetir) | `401`, `403`, `404` (sin envío o ajena), `409 request_not_dismissable`, `429` |
| `GET /api/v1/tecnicos/me/trabajo` (spec 036, Borrador) | Visitas próximas, cotizaciones enviadas, terminadas y resumen | `cursorTerminadas?`, `limit?` (1–20) | `200` con `disponibleHoy`, `verificacion{estado}`, `nivel{clave, nombre}`, `proximasVisitas[]`, `cotizacionesEnviadas[]`, `terminadas{items[], nextCursor}`, `resumen{trabajosTerminados, calificacion}` | `400 invalid_cursor`, `401`, `403 not_a_technician`, `422` (`limit` fuera de rango), `429`, `503 unavailable` (si falla cualquier parte, falla todo el resumen; nunca llega una respuesta parcial, spec 036 R-07) |
| `GET /api/v1/visitas/{id}` (backend 022) | Abrir la visita (spec 016) | — | vista del técnico | ver spec 016 |

**Elementos del resumen** (spec 036)
- Visita próxima: `visitaId`, `solicitudId`, `dia`, `hora`, `modalidad`, `cliente{colonia}`, `lugar{direccion}`, `precio`, `tope`, `estado` (`confirmada`\|`en_curso`), `puedeLlegar` (mismos nombres que la vista del técnico de backend 022).
- Cotización enviada: `cotizacionId`, `solicitudId`, `oficioNombre`, `tipoPrecio`, `precio`, `precioMin?`, `precioMax?`, `tope`, `estado` (`enviada`, `aceptada`, `rechazada`, `retirada`, como en backend 020), `motivoRechazo?` (presente cuando el estado es `rechazada` o `retirada`, spec 036 R-04), `enviadaEn`.
- Terminada: `solicitudId`, `oficioNombre`, `terminadaEn`, `precio`, `calificacion?`.

Reglas del contrato que la app da por ciertas:
- **Autorización por recurso:** un `404` es la respuesta para una solicitud o visita ajena o que ya no existe; la app lo trata como «ya no está disponible».
- **Idempotencia:** repetir `descartar` responde `204` sin cambios (idempotente por estado).
- **Paginación:** cursor con `cursor`, `limit` y `nextCursor` (backend 002), máximo 20 por página.
- **Límites:** 30 descartes por hora por técnico; la app obedece `Retry-After`.
- **Errores y caché:** ProblemDetails con `code`; `Cache-Control: private, no-store` en la bandeja y en el resumen.
- **Eventos:** la app no consume eventos en esta spec; «solicitud nueva» (`SolicitudEnviadaATecnico`) y «te eligieron» llegan por las notificaciones de la spec 024.

## 5. Modelo de datos

**Entidades de dominio** (`app/lib/features/trabajo/domain/`, Dart puro)

| Entidad | Campos | Reglas |
|---|---|---|
| `ResumenDeTrabajo` | `disponibleHoy`, `estadoVerificacion`, `nivel`, `proximasVisitas`, `solicitudesNuevas`, `cotizacionesEnviadas`, `terminadas`, `trabajosTerminados`, `calificacion` | Inmutable; lo arma el mapper |
| `VisitaProxima` | `visitaId`, `solicitudId`, `dia`, `hora`, `modalidad`, `coloniaCliente`, `direccion`, `precio`, `tope`, `estado` (`confirmada`, `enCurso`), `puedeLlegar` | La dirección solo existe aquí; sin nombre ni teléfono del cliente |
| `SolicitudNueva` | `solicitudId`, `oficio` (`clave`, `nombre`), `colonia` (`nombre`, `cp`), `descripcion`, `fotos`, `dia`, `franja`, `modalidad`, `venceEn`, `oleada`, `recibidaEn`, `yaCotizo` (forma `SolicitudRecibida` de backend 028) | **Sin** campos de dirección, teléfono ni nombre |
| `CotizacionEnviada` | `cotizacionId`, `solicitudId`, `oficio`, `tipoPrecio`, `precio`, `precioMin?`, `precioMax?`, `tope`, `estado` (`enviada`, `aceptada`, `rechazada`, `retirada`, los de backend 020), `enviadaEn` | El estado lo decide el servidor |
| `TrabajoTerminado` | `solicitudId`, `oficio`, `terminadaEn`, `precio`, `calificacion` | — |

**Estado local**
- Solo en memoria (Riverpod); **nada** en `shared_preferences`, caché de respuestas ni disco (R-07).
- Se reutiliza `Modalidad` de `app/lib/features/oficios/domain/modalidad.dart` y `Franja` de la spec 015; no se crean copias.
- El estado se descarta al cerrar sesión (los providers se invalidan en el cierre).

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Fuga de información:** el técnico ve dirección o teléfono del cliente antes de ser elegido | El modelo `SolicitudNueva` no tiene esos campos; el servidor solo los incluye en visitas aceptadas | CA-02, CA-05 |
| **Fuga de información:** ver visitas o solicitudes de otro técnico | El servidor decide por recurso y responde 404; la app no distingue ajena de inexistente | CA-03 |
| **Fuga de información:** datos del cliente en registros, cachés o reportes | Sin caché de Trabajo, sin `print` con contenido y prueba global de la spec 009 | CA-15, CA-16 |
| **Fuga de información:** fotos de la casa del cliente en el teléfono del técnico | URL firmada de vida corta, sin caché de respuestas, sin copia a la galería | CA-02 |
| **Elevación de privilegios:** una persona sin rol entra a Trabajo | Redirección del router y `403` del servidor | CA-10 |
| **Alteración:** descartar dos veces o descartar una solicitud ya cotizada | El `409` del servidor y el refresco de la app | CA-03 |
| **Denegación:** refrescar sin parar tras un `429` | `ClienteConEspera` de la spec 009 y sin reintentos automáticos | CA-12 |
| **Suplantación:** sesión ajena en un teléfono compartido | Estado en memoria que se invalida al cerrar sesión | CA-15 |
| **Repudio:** «yo no descarté eso» | El servidor audita el descarte; la app no guarda historial local | CA-03 |
| **Enlaces:** «Cómo llegar» abre un esquema arbitrario | Solo `https://www.google.com/maps/search/?api=1&query=...` con la dirección codificada | CA-06 |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos nuevos (ARB `trabajo*`) |
|---|---|---|---|
| Trabajo (`/trabajo`, se modifica) | carga, con datos, vacío por sección, error, sin conexión, espera por 429 | Cabecera con «Disponible hoy» (solo lectura) y aviso de verificación; secciones | `trabajoTitulo`, `trabajoDisponibleHoy`, `trabajoNoDisponible`, `trabajoVerificacionAviso`, `trabajoVerificarAhora`, `trabajoReintentar`, `trabajoSinConexion`, `trabajoEspera` |
| Próximas visitas | vacío, con datos | Tarjeta con día, hora, colonia, dirección, precio, «Cómo llegar» y «Ya llegué» | `trabajoVisitasTitulo`, `trabajoVisitasVacio`, `trabajoComoLlegar`, `trabajoYaLlegue`, `trabajoSinMapas` |
| Solicitudes nuevas | vacío, con datos | Descripción, fotos, colonia, cuándo, «Descartar» | `trabajoNuevasTitulo`, `trabajoNuevasVacio`, `trabajoDescartar`, `trabajoDescartarTitulo`, `trabajoDescartarDetalle`, `trabajoDescartarConfirmar`, `trabajoSolicitudNoDisponible` |
| Cotizaciones enviadas | vacío, con datos | Oficio, precio (fijo, rango o visita) y estado | `trabajoEnviadasTitulo`, `trabajoEnviadasVacio`, `trabajoEstadoEnviada`, `trabajoEstadoAceptada`, `trabajoEstadoRechazada`, `trabajoEstadoRetirada` |
| Terminadas | plegada, vacío, con datos, cargar más | Lista paginada | `trabajoTerminadasTitulo`, `trabajoTerminadasVacio`, `trabajoCargarMas` |
| Resumen | con datos | Nivel, trabajos terminados y calificación | `trabajoResumenTitulo`, `trabajoNivel`, `trabajoTrabajosTerminados`, `trabajoCalificacion` |

**Mensajes exactos** (español; el inglés va en `app_en.arb`)

| Situación | Texto en pantalla |
|---|---|
| Sin visitas | «Cuando te elijan, tus visitas aparecerán aquí» |
| Sin solicitudes nuevas | «Te avisaremos cuando llegue una solicitud de tu oficio» |
| Sin cotizaciones enviadas | «Aquí verás las cotizaciones que envíes» |
| Sin terminadas | «Aquí verás tus trabajos terminados» |
| Confirmar descarte | «¿Descartar esta solicitud? Ya no la verás en tu lista.» |
| 404 al descartar | «Esta solicitud ya no está disponible.» |
| `request_not_dismissable` (409) | «Esta solicitud ya no se puede descartar» |
| `not_a_technician` (403) | Se redirige a Inicio sin mensaje |
| 429 | «Hiciste muchos intentos. Espera {segundos} segundos.» |
| Sin conexión | «Sin conexión. Desliza hacia abajo para intentar de nuevo.» |
| 5xx | «Algo salió mal de nuestro lado. Intenta de nuevo.» |

Reglas de pantalla:
- Las secciones vacías no desaparecen: explican qué sigue (CA-08).
- Las acciones destructivas («Descartar») piden confirmación en una hoja inferior (patrón de la spec 014).
- Accesibilidad: contraste según la spec 014; cada tarjeta es un solo nodo semántico con sus acciones; los estados no dependen solo del color; la sección plegada anuncia «expandida» o «contraída».

## 8. Pruebas, gates y límites

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Mapper, reglas de secciones, enlace de mapa, controlador |
| Widget (W) | Sí | Secciones, tarjetas, estados vacío/carga/error/sin conexión, confirmación de descarte |
| Aceptación (ACC) | Sí | CA-01 a CA-17 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` (spec 006) con las rutas de backend 036 (resumen de trabajo) y 028 (bandeja y descarte) |
| Integración (INT) | Sí | Recorrido con API simulada en `integration_test/` y humo contra el entorno desplegado con semillas |
| Seguridad negativa (NEG) | Sí | 403 sin rol, 404 ajeno, 409 al descartar, 429, ausencia de datos en registros |
| Accesibilidad (A11Y) | Sí | `expectAccesible` de la spec 008, lector de pantalla y texto al 200 % |
| Mutación (MUT) | Sí | `domain/` con `mutation_test`, meta 70 % |
| E2E | Sí | Un recorrido: entrar como técnico de semilla → ver visita → descartar una solicitud → «Ya llegué» |
| Regresión | Sí | `flutter test` completo; no se rompen Inicio, Actividad, Cuenta ni la redirección por rol |
| Análisis estático y vulnerabilidades | Sí | `flutter analyze --fatal-infos`, `dart format`, Semgrep y CodeQL del CI, OSV si hay dependencias nuevas |
| Rendimiento (PERF) | No | Volumen bajo del piloto |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Técnico con una visita, dos solicitudes nuevas y una cotización enviada ve las cuatro secciones llenas |
| Positivo | Descartar una solicitud la quita y no vuelve al refrescar |
| Negativo | Una persona cliente que abre `/trabajo` vuelve a Inicio |
| Negativo | El servidor responde 404 al descartar una solicitud que otra persona ya cotizó: mensaje claro y refresco |
| Error esperado | 401 → renueva una vez; si falla, cierra sesión (spec 002) |
| Error esperado | 429 → espera `Retry-After` y lo dice |
| Error esperado | 409 `request_not_dismissable` → «Esta solicitud ya no se puede descartar» y refresco |
| Error esperado | 5xx o tiempo agotado → error con «Reintentar» |
| Caso límite | 0 elementos en las cuatro listas; 1 elemento; 20 y 21 terminadas |
| Caso límite | Solicitud que vence mientras la pantalla está abierta: desaparece al refrescar |
| Caso límite | Sin señal al descartar: la tarjeta se queda y se avisa; el reintento repite la llamada (el descarte es idempotente por estado) |
| Caso límite | Texto de descripción de 500 caracteres y nombre de colonia largo con texto al 200 % |

**Gates:** `flutter analyze --fatal-infos`, `dart format`, `flutter test` con cobertura ≥ 50 % (spec 008), revisión de la constitución y de seguridad, PR con CI en verde (spec 007).

## 9. Arquitectura y componentes

Se respeta la spec 001: `domain` en Dart puro, `presentation` sin `data/`, un `trabajo_providers.dart` como raíz de composición y el cliente generado como única puerta a la API (spec 006). La spec 016 ya crea `trabajo_providers.dart` y `llegada_*`; esta spec **extiende** esos archivos.

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/trabajo/domain/resumen_de_trabajo.dart` | Crear | Entidades de §5 |
| `app/lib/features/trabajo/domain/enlace_mapa.dart` | Crear | URL de «Cómo llegar» (comparte la regla de la spec 016, R-05; si 016 la crea primero, se reutiliza y no se duplica) |
| `app/lib/features/trabajo/domain/trabajo_repository.dart` | Crear | Interfaz: `resumen`, `masTerminadas`, `bandeja`, `masBandeja`, `descartar` |
| `app/lib/features/trabajo/data/trabajo_mapper.dart` | Crear | Contrato → dominio, descarta campos de más |
| `app/lib/features/trabajo/data/trabajo_repository_api.dart` | Crear | Implementación sobre el cliente generado |
| `app/lib/features/trabajo/trabajo_providers.dart` | Modificar | Registrar repositorio y controlador |
| `app/lib/features/trabajo/presentation/trabajo_screen.dart` | Modificar | Secciones y estados |
| `app/lib/features/trabajo/presentation/trabajo_controller.dart` | Crear | Carga, descarte, paginación y espera por 429 |
| `app/lib/features/trabajo/presentation/widgets/cabecera_trabajo.dart` | Crear | Disponibilidad y aviso de verificación |
| `app/lib/features/trabajo/presentation/widgets/tarjeta_visita.dart` | Crear | Visita próxima |
| `app/lib/features/trabajo/presentation/widgets/tarjeta_solicitud_nueva.dart` | Crear | Solicitud nueva y descarte |
| `app/lib/features/trabajo/presentation/widgets/seccion_trabajo.dart` | Crear | Encabezado, estado vacío y plegado de cada sección (reutiliza el componente «estado vacío o de error» de la spec 014) |
| `app/lib/core/router/rutas.dart`, `app_router.dart` | Modificar | Ruta `/trabajo/visita/:id` (de la spec 016) si aún no existe |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 |

**No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/` y las specs aprobadas.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| Backend sin número (agregado de Trabajo y descarte) | Rutas, esquemas y reglas | **Bloqueante:** sin contrato no se implementa `data`; hay que pedir la spec a backend (no está en la cola 027–035) |
| Backend 028 Repartir por oleadas (en elaboración) | Qué solicitudes le llegan al técnico | «Solicitudes nuevas» solo se llena con semillas |
| Backend 020 | Estados y 404 del técnico no cotizante | Se desalinean estados y errores |
| Backend 022 y frontend 016 | Visita y «Ya llegué» | El botón no tiene destino |
| 018 Verificar mi identidad | Pantalla a la que lleva el aviso de verificación | El aviso no puede enlazar |
| 014 Alinear la UI con la maqueta | Componentes base (la «fila», el «estado vacío o de error» y la tarjeta del tema de la spec 014) y contraste | Se duplicarían componentes |
| 002, 009, 010 | Sesión, errores, espera por 429, política de caché | Se incumplirían manejo de errores y de datos |
| 024 Notificaciones | Aviso de solicitud nueva y de elección | Hay que refrescar a mano |

## 11. Definición de terminado

- CA-01 a CA-17 con prueba que falla si la lógica está mal; `python scripts/sdd_lint.py --trace 019` sin `FALTA`.
- `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 %.
- ARB de español e inglés completos y prueba de traducciones en verde.
- El contrato vendorizado incluye las rutas de §4 y el cliente generado compila.
- Recorrido con técnico de semilla contra el entorno desplegado, con capturas de datos ficticios.
- `Memoria.md` al día; PR con la plantilla completa, etiqueta `puntos-app-N` y CI en verde.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | Solicitudes nuevas y descarte usan la bandeja de backend 028; visitas, enviadas, terminadas y nivel quedan en un resumen propuesto `GET /tecnicos/me/trabajo` | Backend 028 ya fija la bandeja y no hay listados de visitas ni de cotizaciones del técnico | Esperar un solo agregado que hoy no existe |
| D-02 | «Chatear y cotizar» no se muestra hasta que existan HU-029 y HU-031 | Un botón que no hace nada confunde y el técnico de la demo se simula con semillas | Un botón deshabilitado con «Próximamente» |
| D-03 | «Disponible hoy» es solo lectura | El interruptor es HU-019 (otra historia y otra spec) | Construir el interruptor aquí |
| D-04 | No se cachea nada de Trabajo | Datos personales que cambian a cada solicitud (spec 010, R-04) | Caché con ETag, que mostraría solicitudes ya cotizadas por otro |
| D-05 | El detalle de una solicitud nueva no se pide aparte | La tarjeta de la bandeja ya trae todo lo que se puede mostrar; backend 028 R-15 permite el detalle, pero no agrega datos | Un `GET /solicitudes/{id}` por tarjeta |
| D-06 | «Cómo llegar» reutiliza la regla de la spec 016 | Una sola regla de enlaces de mapa | Un segundo constructor de URLs |

## 13. Riesgos y dudas abiertas
- **`Idempotency-Key` retirada por ahora (decisión del 2026-11-10).** El descarte no la envía y backend 028 la quitó; ya es idempotente por estado (repetirlo responde 204). Si alguna historia la exigía como criterio, una persona debe decidir si se relaja.

- **Resuelto en la revisión cruzada (decisión automática, revisar):** la spec de backend de `GET /api/v1/tecnicos/me/trabajo` (visitas próximas, cotizaciones enviadas, terminadas y nivel del técnico) es la **036** (Borrador; Sprint 5). La bandeja y el descarte ya los fija backend 028.
- **Riesgo:** HU-020 depende de HU-019 (disponibilidad) y HU-025 (oleadas), que no tienen spec; sin ellas la sección «Solicitudes nuevas» queda vacía en la demo salvo con semillas.
- **Riesgo:** sin «Chatear y cotizar» el técnico real no puede responder desde la app; la demo lo resuelve con semillas (insumo, pregunta 3).
- **Resuelto en la revisión:** Jira ya tiene KNOCK-67 con la etiqueta `sprint-5`.
- **Duda abierta (para backend):** ¿«Terminadas» incluye canceladas? Esta spec asume que no.
- **Resuelto en la revisión:** el técnico no ve el nombre del cliente; ve su colonia y, en visitas aceptadas, la dirección (backend 022 R-05).

## Aprobación

- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-11
- [x] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
