# Spec 016 — Visita con código y aviso de confianza (pantallas)

> **Jira:** KNOCK-83 («HU-036 · Ver mi visita con el código de 4 dígitos o la cita en el taller») y KNOCK-85 («HU-038 · Confirmar mi llegada con el código ("Ya llegué")», solo su capa Mobile); KNOCK-84 (HU-037) se especifica completa en la spec 022 y aquí solo se coloca su botón de entrada. Claves y resúmenes verificados en Jira el 9 de noviembre de 2026 · **Épica:** EP-06 Visita segura y trabajo · **Módulo:** requests · **Responsable:** Erick Trejo Reséndiz · **Sprint:** S4 (ola B) · **Puntos:** 3 de KNOCK-83 más la capa Mobile de KNOCK-85 (sus 3 puntos se reparten con backend 022); los 2 de KNOCK-84 se cuentan en la spec 022 · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend (spec 022 «Visita segura con código de 4 dígitos»)
> **Fuentes:** `docs/referencia/FUNCIONES_Y_FLUJOS.md` §3.6, §4.5 y §5 · `docs/backlog/HU-036.md`, `HU-037.md`, `HU-038.md`
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 022 y se vendoriza antes de implementar (spec 006).
> **Estado:** Aprobada

## 1. Objetivo

Que el cliente vea su visita a domicilio con el código de 4 dígitos (o su cita en el taller con «Cómo llegar») y tenga a la mano el botón para avisar a una persona de confianza (la hoja y los contactos son de la spec 022), y que el técnico confirme su llegada con ese código desde la app Android. Esta spec cubre la capa **Mobile**; el código, su vigencia, los intentos y la revelación de datos son del backend (spec 022).

## 2. Historia y casos de prueba

**KNOCK-83** — Como cliente, quiero ver mi visita con el código de 4 dígitos o mi cita en el taller, para saber quién viene y reconocerlo en la puerta.
**KNOCK-84** — (Se especifica en la spec 022; aquí solo el botón de entrada, CA-06.)
**KNOCK-85** — Como técnico, quiero capturar el código que me da el cliente en la puerta, para demostrar que soy la persona que eligió y empezar el trabajo.

- **CA-01:** Dada una visita a domicilio confirmada, cuando la abro, entonces veo el nombre y la foto del técnico, su insignia de verificado, el día, la hora y mi código de 4 dígitos con la regla «Pídele a [técnico] que te diga este código en la puerta. Si no lo sabe, no abras». · Verificación: `app/test/features/actividad/presentation/visita_screen_test.dart` → `CA_016_01`
- **CA-02:** Dada una visita ya abierta antes, cuando la abro sin conexión, entonces el código, el nombre, el día y la hora siguen visibles desde el almacenamiento seguro del teléfono. · Verificación: `app/test/features/actividad/data/visita_local_repository_test.dart` → `CA_016_02`
- **CA-03:** Dado el técnico de la visita, cuando su pantalla pide los datos, entonces la respuesta y el modelo de la app **no** tienen el campo del código y no se puede pintar. · Verificación: `app/test/features/actividad/data/visita_mapper_test.dart` → `CA_016_03`
- **CA-04:** Dada una cita en taller, cuando la abro, entonces veo día, hora, dirección y «Cómo llegar», y ese botón abre la app de mapas del teléfono con la dirección del taller codificada con `Uri.encodeComponent`, sin esquemas arbitrarios. · Verificación: `app/test/features/actividad/presentation/visita_taller_test.dart` → `CA_016_04`
- **CA-05:** Dada una visita de otra persona, cuando la app la pide, entonces recibe 404 y se muestra «Esta visita ya no está disponible», sin revelar que existe. · Verificación: `app/test/features/actividad/data/visita_repository_api_test.dart` → `CA_016_05`
- **CA-06:** Dada una visita con `puedeAvisar` verdadero, cuando toco «Avisar a alguien de confianza», entonces se abre la hoja de la spec 022 con los datos públicos de la visita; con `puedeAvisar` falso el botón no aparece. · Verificación: `app/test/features/actividad/presentation/visita_screen_test.dart` → `CA_016_06`
- **CA-07:** Dada una visita a domicilio cuya vista no trae `codigo` y trae `motivoCodigo` (`usado`, `vencido`, `bloqueada` o `no_aplica`), cuando la abro, entonces en lugar del código veo el mensaje exacto de ese motivo (§7), y la copia local del código se borra. · Verificación: `app/test/features/actividad/presentation/visita_controller_test.dart` → `CA_016_07`
- **CA-08:** Dada la pantalla de la visita, cuando toco «Ocultar código», entonces los cuatro recuadros se tapan sin borrar el código, el lector anuncia «Código oculto», un toque lo vuelve a mostrar y en Android 13 o superior la vista de tareas recientes no muestra la miniatura (R-18; esta última parte necesita código nativo y una prueba de integración o una verificación manual en el teléfono, no una prueba de widget). · Verificación: `app/test/features/actividad/presentation/codigo_visita_test.dart` → `CA_016_08`
- **CA-09:** Dado el código de la visita, cuando llega un aviso push o se abre la visita desde él, entonces el código **no** aparece en la notificación ni en su carga; solo se ve en la pantalla de la visita. · Verificación: `app/test/features/actividad/domain/contenido_visita_test.dart` → `CA_016_09`
- **CA-10:** Dado el técnico en su visita con `puedeLlegar` verdadero, cuando captura el código correcto, entonces el servidor responde 200, la visita pasa a **En curso** con la hora `llegadaEn` y el cliente ve «En curso» al refrescar o al abrir el aviso (la hora de llegada solo en la vista del técnico: la vista del cliente de backend 022 R-02 no trae `llegadaEn`, ver §13). · Verificación: `app/test/features/trabajo/presentation/llegada_controller_test.dart` → `CA_016_10`
- **CA-11:** Dado el técnico en su visita, cuando captura un código incorrecto y el servidor responde 422 `codigo_incorrecto`, entonces ve «El código no coincide. Confirma que estás en la dirección correcta.» y «Te quedan {n} intentos» con el `intentosRestantes` recibido. · Verificación: `app/test/features/trabajo/presentation/llegada_controller_test.dart` → `CA_016_11`
- **CA-12:** Dado el técnico que falla el tercer intento, cuando el servidor responde 409 `visita_bloqueada`, entonces el campo se deshabilita, ve «Esta visita quedó bloqueada por seguridad. El equipo de Knock la revisará.» y la app no reintenta sola; el aviso al cliente y el reporte de gravedad alta los crea el servidor. · Verificación: `app/test/features/trabajo/presentation/llegada_controller_test.dart` → `CA_016_12`
- **CA-13:** Dado un código ya usado, vencido, una visita cancelada, terminada o no presentada, una cita en taller, una confirmación antes del día de la cita, una visita ajena o un cliente que llama a la llegada, cuando el técnico confirma, entonces recibe 409 (`codigo_usado`, `codigo_vencido`, `visita_cancelada`, `visita_no_vigente`, `visita_sin_codigo`, `fuera_de_ventana`), 404 (ajena) o 403 (`no_es_tecnico`) y la app muestra el mensaje exacto de §7 sin revelar el estado de otra persona; un código que no tiene 4 dígitos se rechaza en el teléfono con «Escribe los 4 dígitos» y, si aun así llega un 422 con `errors.codigo` (formato), se muestra el mismo texto y no se descuenta ningún intento. · Verificación: `app/test/features/trabajo/presentation/llegada_controller_test.dart` → `CA_016_13`
- **CA-14:** Dadas las pantallas de visita y llegada, cuando se recorren con lector de pantalla y texto al 200 %, entonces el código se lee dígito por dígito, cada control tiene etiqueta, mide al menos 48 dp, el contraste cumple 4.5:1 y no se corta el contenido. · Verificación: `app/test/features/actividad/presentation/accesibilidad_visita_test.dart` → `CA_016_14`
- **CA-15:** Dado un 429 con `Retry-After`, un 5xx o una caída de red, cuando se abre la visita o se confirma la llegada, entonces se muestra el estado de error o el tiempo de espera, hay «Reintentar» cuando aplica y no se reintenta en bucle. · Verificación: `app/test/features/actividad/presentation/visita_controller_test.dart` → `CA_016_15`
- **CA-16:** Dada una visita abierta, cuando termina, se cancela o se cierra sesión, entonces el almacén seguro ya no contiene el código ni los datos de la visita. · Verificación: `app/test/features/actividad/data/borrado_visita_test.dart` → `CA_016_16`
- **CA-17:** Dado un reintento de «Ya llegué» cuya respuesta se perdió por un tiempo agotado, cuando el servidor responde 409 `codigo_usado`, entonces la app consulta la visita, la muestra en `en_curso` y no lo trata como error; si el primer intento fue un código incorrecto y se perdió la respuesta, el reintento **vuelve a contar como intento** (backend 022 R-10), por eso el reintento es siempre manual (R-08) y la pantalla avisa «Si el código era incorrecto, este reintento cuenta como intento». · Verificación: `app/test/features/trabajo/data/llegada_repository_api_test.dart` → `CA_016_17`
- **CA-18:** Dada una visita a domicilio, cuando se guarda la copia local, entonces **no** contiene la dirección del cliente; en una visita a taller sí guarda `direccionTaller`. · Verificación: `app/test/features/actividad/data/visita_local_repository_test.dart` → `CA_016_18`
- **CA-19:** Dado el código de una visita, cuando se revisan `shared_preferences`, el directorio de la app y los registros, entonces solo el almacén seguro lo contiene y no aparece en ningún registro ni archivo legible. · Verificación: `app/test/seguridad/codigo_visita_test.dart` → `CA_016_19`
- **CA-20:** Dada la vista del técnico con `puedeLlegar` falso (fuera de la ventana de la cita, en taller, ya en curso o bloqueada), cuando abre la visita, entonces «Ya llegué» está deshabilitado con la razón y la app no llama a `/llegada`. · Verificación: `app/test/features/trabajo/presentation/llegada_screen_test.dart` → `CA_016_20`
- **CA-21:** Dado el cliente con una visita confirmada, cuando la abre, entonces ve el contacto público del técnico (`telefono` o `whatsapp`) con las acciones de llamar o escribir por WhatsApp y, si el técnico no publicó ninguno, el texto «Este técnico no publicó un teléfono. Podrás escribirle por el chat cuando esté disponible»; la app elige el mapeador de la vista del cliente o del técnico por el campo `rol` de la respuesta, no por la ruta. · Verificación: `app/test/features/actividad/presentation/visita_screen_test.dart` → `CA_016_21`

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Pantalla de la visita a domicilio con el código de 4 dígitos y la regla de seguridad.
- Copia local segura del código y de los datos mínimos para verlo sin conexión.
- Pantalla de la cita en taller con dirección y «Cómo llegar».
- Botón «Avisar a alguien de confianza» que abre la hoja de la spec 022 (la hoja, el mensaje y los contactos son de esa spec).
- Pantalla del técnico para confirmar la llegada con el código, con intentos restantes y bloqueo.
- Estados de carga, con datos, vacío, error, sin conexión y reintento.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.
- Pruebas unitarias, de widget, de contrato, de seguridad negativa, de accesibilidad y de integración.

**Fuera**
- Generar, vencer y validar el código, contar los intentos, crear el reporte de gravedad alta y avisar al cliente: backend 022.
- La mensajería y WhatsApp después de elegir: dependen de backend 026 y de una spec propia.
- Terminar el trabajo, calificar y reportar un problema (HU-039 y HU-058): fuera del Sprint 4.
- El panel interno que revisa reportes de visita.
- La reprogramación de la cita (HU-034) y la cancelación (HU-028).
- El seguimiento en vivo de la visita y la ubicación del técnico en un mapa.
- La verificación de identidad del técnico (spec 018); aquí solo se muestra la insignia que devuelve el servidor.

### Requisitos

- **R-01:** La visita se muestra distinta según la modalidad: a domicilio con el código y la regla de seguridad; en taller con la dirección del taller y «Cómo llegar».
- **R-02:** El código tiene 4 dígitos y se muestra solo al cliente, solo en su pantalla (y, por decisión de la persona, en el mensaje de la spec 022); nunca en la vista del técnico, en un aviso push ni en un registro.
- **R-03:** El código y los datos mínimos de la visita (técnico, día, hora, modalidad y, **solo en taller**, la dirección del taller) se guardan cifrados en el almacenamiento seguro del teléfono para verlos sin conexión, y se borran al terminar la visita, al cancelarla y al cerrar sesión. La copia local **nunca** guarda la dirección del domicilio del cliente ni el teléfono o el WhatsApp del técnico (*decisión automática, revisar*: igual que la spec 015, D-16, el contacto se vuelve a leer del servidor y no se deja en el teléfono).
- **R-04:** La app no guarda la visita ni el código en la caché de respuestas (spec 010, R-04); la copia local es del almacén seguro y solo de la visita abierta.
- **R-05:** «Cómo llegar» abre la app de mapas del teléfono con la dirección del taller en una URL `https://www.google.com/maps/search/?api=1&query=<dirección>` con la dirección codificada con `Uri.encodeComponent`; si no hay app de mapas, se muestra la dirección en texto y un aviso, sin bloquear la pantalla. En Android 11 o superior `canLaunchUrl` solo responde bien si el manifiesto declara en `<queries>` la intención `VIEW` para `https` (§9).
- **R-06:** El botón «Avisar a alguien de confianza» aparece solo cuando la vista del cliente trae `puedeAvisar` verdadero y abre la hoja de la spec 022; esta spec no arma el mensaje, no guarda contactos y no llama a `/aviso`.
- **R-07:** Si la vista del cliente no trae `codigo` y trae `motivoCodigo`, se muestra el mensaje de ese motivo en lugar del código y se borra la copia local del código.
- **R-08:** El técnico confirma la llegada con un campo de 4 dígitos; la app deshabilita el botón mientras hay una operación en curso y no reintenta sola.
- **R-09:** Los intentos restantes y el bloqueo los decide el servidor; la app solo muestra lo que recibe y nunca inventa un contador local.
- **R-10:** La app nunca registra en consola, en caché ni en un reporte de errores el código, el nombre del técnico ni la dirección.
- **R-11:** Todo error de la API se muestra con un texto del catálogo de traducciones; nunca con el código HTTP, la URL ni el cuerpo de la respuesta.
- **R-12:** Cada pantalla tiene estados de carga, con datos, vacío, error y sin conexión, y un botón de reintentar cuando aplica.
- **R-13:** Todos los textos visibles viven en los ARB de español e inglés y todos los colores y tipografías en el tema.
- **R-14:** Cada control interactivo tiene etiqueta semántica, mide al menos 48 dp y funciona con el texto del sistema al 200 %.
- **R-15:** La vista del técnico usa `puedeLlegar` del servidor para habilitar «Ya llegué»; la app no calcula la ventana de la cita ni el estado.
- **R-16:** La app no envía `Idempotency-Key` en `POST /visitas/{id}/llegada` (retirada por ahora; backend 022 ya no la exige): deshabilita el botón durante la operación y, si recibe 409 `codigo_usado` tras un reintento, consulta la visita.
- **R-17:** El borrado de R-03 se hace con una sola clave de visita abierta (o un índice de claves) y un método `borrarDatosDeVisita()` que se invoca desde el cierre de sesión, para que no queden códigos de una cuenta anterior.
- **R-18:** En Android 13 o superior, la pantalla de la visita desactiva la captura en la vista de tareas recientes (`setRecentsScreenshotEnabled(false)`); las capturas manuales siguen permitidas y el código se puede ocultar con «Ocultar código». `setRecentsScreenshotEnabled(false)` es un método de `Activity` (API 33): exige código Kotlin en `MainActivity` y un `MethodChannel` que lo active al entrar a la visita y lo desactive al salir (§9).

## 4. Contrato API y eventos

La app **consume**; el contrato lo fija backend 022 («Visita segura con código de 4 dígitos») y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006). Esta tabla se alineó el 9 de noviembre de 2026 con el borrador de backend 022; si al vendorizar cambia un nombre o un tipo, se corrige aquí antes de implementar.

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/visitas/{id}` | Ver la visita (cliente) y la visita del técnico (sin código) | — | Cliente: `200` con `{ id, rol: "cliente", estado, modalidad, dia, hora, precio, tope, tecnico{nombre, fotoUrl, verificado, nivelVerificacion, telefono?, whatsapp?}, lugar{tipo, direccion}, codigo?, codigoVenceEn?, reglaSeguridad?, motivoCodigo?, puedeAvisar, puedeLlegar: false }` · Técnico: `200` con `{ id, rol: "tecnico", estado, modalidad, dia, hora, precio, tope, cliente{colonia}, lugar{tipo, direccion}, puedeLlegar }` | `400` id mal formado, `401`, `404` (también cuando es de otra persona), `429` |
| `POST /api/v1/visitas/{id}/llegada` | Confirmar la llegada (técnico) | `{ codigo }` de exactamente 4 dígitos | `200` con la visita en `en_curso` y `llegadaEn` | `400` (formato), `401`, `403 no_es_tecnico`, `404` ajena, `409` (`visita_bloqueada`, `codigo_usado`, `codigo_vencido`, `visita_cancelada`, `visita_no_vigente`, `visita_sin_codigo`, `fuera_de_ventana`), `422` (`codigo_incorrecto` con `intentosRestantes`; `errors.codigo` por formato, que no cuenta como intento), `429` con `Retry-After` |
| `POST /api/v1/visitas/{id}/aviso` | Lo consume la spec 022 | — | — | — |

Reglas del contrato que la app da por ciertas:
- **Autorización por recurso:** un `404` es la respuesta para una visita de otra persona o inexistente; la app lo trata como «ya no está disponible».
- **Código:** 4 dígitos, de un solo uso, guardado cifrado en el servidor; vence a las 23:59:59 del día de la cita más 24 h; solo en la vista del cliente, en domicilio, en `confirmada` o `en_curso`, sin usar, sin vencer y sin bloqueo.
- **Intentos:** 3 por visita; al tercer fallo el servidor bloquea (`409 visita_bloqueada`), emite el evento y crea el reporte; el contador no se reinicia al reconectar.
- **Idempotencia:** repetir una llegada ya exitosa responde `409 codigo_usado` y no consume otro intento; un intento fallido repetido vuelve a contar como intento (backend 022 R-10).
- **Límites:** 5 peticiones de llegada por minuto por técnico.
- **Caché:** respuestas con `Cache-Control: private, no-store`; la app no las pone en la caché de respuestas y solo guarda la copia mínima del almacén seguro (R-03).
- **Taller:** sin código, `puedeLlegar` falso y «Cómo llegar» lo arma la app; el servidor no genera rutas.
- **Eventos:** la app no consume eventos en este sprint; el aviso de «tu técnico llegó» llega por la spec 012 (contenido en la spec 024) y abre la visita. La carga nunca lleva el código.

## 5. Modelo de datos

**Entidades de dominio** (`app/lib/features/actividad/domain/`, Dart puro, sin Flutter ni HTTP)

| Entidad | Campos | Reglas |
|---|---|---|
| `Visita` | `id`, `estado` (`confirmada`, `enCurso`, `terminada`, `cancelada`, `noPresentado`, mapeados desde `confirmada`, `en_curso`, `terminada`, `cancelada`, `no_presentado`), `rol` (`cliente` o `tecnico`, elige el mapeador), `modalidad`, `dia`, `hora`, `precio`, `tope`, `tecnico` (`TecnicoVisita`: `nombre`, `fotoUrl`, `verificado`, `nivelVerificacion`, `telefono?`, `whatsapp?`; solo en memoria), `clienteColonia` (solo vista del técnico), `lugarTipo` (de `lugar.tipo`), `direccion` (de `lugar.direccion`), `codigo?`, `codigoVenceEn?`, `reglaSeguridad?`, `motivoCodigo?`, `puedeAvisar`, `puedeLlegar`, `llegadaEn?` | Inmutable; `codigo` es `null` en la vista del técnico y cuando llega `motivoCodigo`; un estado desconocido se muestra como «En proceso» |
| `ResultadoLlegada` | `estado`, `llegadaEn` | Solo después de un código correcto |
| `ErrorLlegada` | `codigo` (`codigoIncorrecto`, `codigoFormatoInvalido`, `visitaBloqueada`, `codigoUsado`, `codigoVencido`, `visitaCancelada`, `visitaNoVigente`, `visitaSinCodigo`, `fueraDeVentana`, `noEsTecnico`), `intentosRestantes?` | Lo construye el mapeador desde ProblemDetails |

**Estado local**
- `knock.visita.abierta` en el almacenamiento seguro (spec 009, `AlmacenSeguro`): `id`, `estado`, `dia`, `hora`, `modalidad`, `tecnicoNombre`, `tecnicoVerificado`, `direccionTaller`, `codigo`, `guardadoEn`, más un índice `knock.visita.claves` con los identificadores guardados. Se conserva mientras la visita esté confirmada o en curso y se borra al terminar, cancelar o cerrar sesión; una visita terminada se borra a las 24 h.
- **Sin caché** de visitas en la caché de respuestas (R-04); la copia local es solo la de la visita abierta.
- El código **no** se guarda en `shared_preferences`, ni en un archivo legible, ni en la copia de seguridad del sistema; `direccionTaller` es `null` en una visita a domicilio y el directorio de documentos no recibe ninguna copia.

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Suplantación:** un falso técnico pide el código en la puerta | El código se genera en el servidor, solo lo ve el cliente y el técnico lo valida contra el servidor; la pantalla repite la regla «si no lo sabe, no abras» | CA-01, CA-03, CA-10 |
| **Fuga de información:** el código en un aviso push, en un registro o en la vista del técnico | El código no viaja en la carga del aviso (spec 012), no se registra y el modelo del técnico no tiene el campo | CA-03, CA-09 |
| **Fuga de información:** la dirección del cliente fuera de la visita | La copia local nunca guarda la dirección del domicilio; el aviso a terceros es de la spec 022 | CA-18 |
| **Fuerza bruta:** probar códigos hasta acertar | Máximo 3 intentos en el servidor, bloqueo y reporte de gravedad alta; la app no reintenta sola y muestra los intentos que quedan | CA-11, CA-12 |
| **Alteración:** reutilizar un código ya usado o confirmar en taller | El servidor responde 409; la app muestra el mensaje y no crea un estado local «en curso» | CA-13 |
| **Fuga de información:** abrir una visita ajena con un identificador adivinado | El servidor autoriza por recurso y responde 404; la app no guarda visitas de otra cuenta y las limpia al cerrar sesión | CA-05 |
| **Denegación:** martillear la API tras un 429 | `ClienteConEspera` de la spec 009 obedece `Retry-After` y la pantalla no reintenta sola | CA-15 |
| **Suplantación:** usar el flujo sin sesión válida | El router exige sesión (spec 001) y el cliente pone el token; un 401 renueva una sola vez y, si falla, cierra la sesión (spec 002) | CA-05, CA-13 |
| **Elevación de privilegios:** un cliente confirma la llegada o un técnico ve el código | Las rutas de llegada cuelgan de Trabajo y el rol lo decide el servidor; la vista del técnico no trae el código | CA-03, CA-13 |
| **Repudio:** «el técnico nunca llegó» | El servidor registra la hora real de llegada y el código usado; la app muestra la hora que devuelve el servidor | CA-10 |
| **Datos sensibles en el teléfono:** el código queda en el almacenamiento después de terminar, cancelar o cerrar sesión | Una sola clave de visita abierta con índice, `borrarDatosDeVisita()` llamado desde el cierre de sesión y prueba de que no queda nada en el almacén seguro, en `shared_preferences` ni en archivos legibles | CA-16, CA-19 |
| **Fuerza bruta:** adivinar el código por su espacio pequeño | 4 dígitos son 10 000 combinaciones; el bloqueo es por visita y por técnico en el servidor a los 3 intentos y no se reinicia al reinstalar; la app no reintenta sola | CA-11, CA-12 |
| **Captura de pantalla:** el código visible en una captura o en la vista de tareas recientes | Se documenta como riesgo aceptado (D-05): no se usa `FLAG_SECURE` para no romper capturas de soporte; en Android 13+ se desactiva la captura en la vista de tareas (R-18), el código se puede ocultar y caduca al terminar la visita | (revisión manual en el PR; R-18) |
| **Dependencias:** hoja de compartir o apertura de mapas vulnerable o con licencia no permitida | Se evalúa licencia, mantenimiento y avisos (OSV) antes de agregarlas y se registra en `Memoria.md` (D-06) | (comando) `flutter pub outdated` + revisión en el PR |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos nuevos (ARB `visita*`, `aviso*`, `llegada*`) |
|---|---|---|---|
| Visita a domicilio (`/actividad/visita/:id`, fuera de la barra inferior) | carga, con datos, error, sin conexión, terminada, cancelada | Técnico con foto e insignia, día, hora, código en 4 recuadros y la regla de seguridad; contacto público del técnico (llamar o WhatsApp; si no lo publicó, el texto de la spec 015); «Avisar a alguien de confianza»; «Ver conversación» solo cuando exista mensajería | `visitaTitulo`, `visitaDomicilio`, `visitaTecnico`, `visitaVerificado`, `visitaSinVerificar`, `visitaDia`, `visitaHora`, `visitaCodigoTitulo`, `visitaCodigoRegla`, `visitaCodigoOcultar`, `visitaAvisar`, `visitaEnCurso`, `visitaLlego`, `visitaTerminada`, `visitaCancelada`, `visitaNoDisponible`, `visitaSinConexion` |
| Cita en taller (misma ruta, modalidad taller) | carga, con datos, error, sin conexión | Día, hora, dirección del taller, «Cómo llegar» y el nombre del técnico | `visitaTaller`, `visitaDireccionTaller`, `visitaComoLlegar`, `visitaSinMapas` |
| Botón «Avisar a alguien de confianza» | visible u oculto según `puedeAvisar` | Abre la hoja de la spec 022 | `visitaAvisar` |
| Llegada del técnico (`/trabajo/visita/:id`, fuera de la barra inferior) | carga, con datos, error, sin conexión, bloqueada | Datos de la visita sin código, campo de 4 dígitos, «Ya llegué», intentos restantes y aviso de bloqueo | `llegadaTitulo`, `llegadaInstruccion`, `llegadaCodigo`, `llegadaConfirmar`, `llegadaConfirmando`, `llegadaIncorrecto`, `llegadaIntentos`, `llegadaBloqueada`, `llegadaTaller`, `llegadaYaUsado`, `llegadaNoDisponible`, `llegadaCuatroDigitos`, `llegadaReintentoCuenta`, `visitaContactoTecnico`, `visitaLlamar`, `visitaWhatsApp`, `visitaSinTelefono` |
| Común | — | Errores del catálogo y botón de reintentar | Reutiliza `errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos` y `errorNoEncontrado` (spec 015); agrega `visitaErrorCodigo` |

**Mensajes exactos** (español; el inglés va en `app_en.arb`)

| Situación | Texto en pantalla |
|---|---|
| Regla de seguridad (domicilio) | El `reglaSeguridad` del servidor: «Pídele a {técnico} que te diga este código en la puerta. Si no lo sabe, no abras.» |
| `motivoCodigo = usado` | «El técnico ya confirmó su llegada con este código.» |
| `motivoCodigo = vencido` | «Este código ya venció.» |
| `motivoCodigo = bloqueada` | «Esta visita quedó bloqueada por seguridad. El equipo de Knock la revisará.» |
| `motivoCodigo = no_aplica` | «Esta cita no necesita código.» |
| `codigo_incorrecto` (422) | «El código no coincide. Confirma que estás en la dirección correcta.» + «Te quedan {n} intentos» |
| `visita_bloqueada` (409) | «Esta visita quedó bloqueada por seguridad. El equipo de Knock la revisará.» |
| `codigo_usado` (409) | «Este código ya se usó.» |
| `codigo_vencido` (409) | «El código de esta visita ya venció.» |
| `fuera_de_ventana` (409) | ES: «Podrás confirmar la llegada el día de la cita, desde las 00:00.» · EN: «You can confirm arrival on the day of the appointment, from 00:00.» (claves ARB: `errorFueraDeVentana`) |
| `visita_no_vigente` (409) | ES: «Esta visita ya no está vigente.» · EN: «This visit is no longer active.» (claves ARB: `errorVisitaNoVigente`) |
| `visita_cancelada` (409) | «Esta visita se canceló.» |
| 422 con `errors.codigo` (formato) o menos de 4 dígitos en el campo | «Escribe los 4 dígitos.» (no cuenta como intento) |
| Reintento manual tras un tiempo agotado | «Si el código era incorrecto, este reintento cuenta como intento.» |
| `visita_sin_codigo` (409) | «Esta cita es en el taller y no necesita código.» |
| `no_es_tecnico` (403) | «Solo el técnico de la visita puede confirmar la llegada.» |
| 404 | «Esta visita ya no está disponible.» |
| `puedeLlegar` falso | «Podrás confirmar tu llegada el día de la cita.» |
| Sin conexión (con copia local) | «Sin conexión. Te mostramos los datos guardados de tu visita.» |
| 429 | «Hiciste muchos intentos. Espera {segundos} segundos.» |
| 5xx | «Algo salió mal de nuestro lado. Intenta de nuevo.» |

Reglas de pantalla:
- El código se muestra en cuatro recuadros y se puede ocultar con «Ocultar código»; al ocultarlo se tapa, no se borra, y se vuelve a mostrar con un toque.
- El botón «Avisar a alguien de confianza» solo aparece con `puedeAvisar` verdadero (el servidor lo da en `confirmada` o `en_curso`).
- La pantalla del técnico nunca pinta un campo de código de la visita; solo el campo donde él lo escribe.
- La visita se refresca al abrirla y al volver a la app (`AppLifecycleState.resumed`), no por sondeo continuo.
- Accesibilidad: el código se anuncia dígito por dígito («cuatro, siete, uno, dos»), los recuadros no dependen solo del color y el campo del técnico acepta pegado y teclado numérico.

## 8. Pruebas, gates y límites

**Plan de pruebas** (Sí/No con motivo; meta de mutación del módulo: 70 % en `domain/`)

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Mapeo de la vista por rol, máquina de estados de la visita y de la llegada, mapeo de errores, borrado local |
| Widget (W) | Sí | Visita a domicilio, taller, código oculto, motivos sin código y llegada del técnico |
| Aceptación (ACC) | Sí | CA-01 a CA-21 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` y `flutter test test/api/cliente_generado_test.dart` (spec 006) |
| Integración (INT) | Sí | Recorrido elegir → visita → avisar → llegada con API simulada en `integration_test/` y humo contra el entorno desplegado |
| Seguridad negativa (NEG) | Sí | Visita ajena (404), código usado (409), intentos agotados (422), 429, código fuera de registros y de la vista del técnico |
| Accesibilidad (A11Y) | Sí | `expectAccesible` de la spec 008, lector de pantalla y texto al 200 % |
| Mutación (MUT) | Sí | Reglas de `domain/` con `mutation_test`, meta 70 % |
| E2E | Sí | Un recorrido: elegir cotización → visita con código → avisar → el técnico confirma la llegada |
| Regresión | Sí | `flutter test` completo; no se rompen Inicio, Explorar, Oficios, Entrada, Cuenta ni Trabajo |
| Análisis estático y vulnerabilidades | Sí | `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed`, Semgrep y CodeQL del CI, `flutter pub outdated` y OSV para las dependencias nuevas |
| Rendimiento (PERF) | No | Volumen bajo del piloto; no hay consultas pesadas en la app |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Visita a domicilio con código, regla y técnico verificado |
| Positivo | Cita en taller con «Cómo llegar» |
| Positivo | «Avisar a alguien de confianza» abre la hoja de la spec 022 |
| Positivo | El técnico captura el código correcto y la visita pasa a En curso |
| Negativo | Visita ajena → 404 y «ya no está disponible» |
| Negativo | Código incorrecto → mensaje e intentos restantes |
| Negativo | 3 intentos agotados → bloqueo y sin reintento automático |
| Negativo | Código ya usado o cita en taller → 409 con mensaje claro |
| Error esperado | 401 → renueva una vez; si falla, cierra sesión y pide entrar |
| Error esperado | 429 → espera el `Retry-After` y lo dice |
| Error esperado | 5xx o tiempo agotado → estado de error con reintentar |
| Caso límite | Sin conexión al abrir la visita: código y datos mínimos visibles |
| Caso límite | Sin app de mapas: dirección en texto y aviso |
| Caso límite | Código que vence (`motivoCodigo = vencido`) con la pantalla abierta y visita bloqueada tras el tercer intento |
| Caso límite | Visita que termina o se cancela mientras la pantalla está abierta |
| Error esperado | Tiempo agotado tras un código incorrecto → reintento manual con aviso de que cuenta como intento |
| Caso límite | Técnico sin teléfono ni WhatsApp publicados → texto de la spec 015 |
| Caso límite | Código que deja de estar disponible al terminar la visita |

**Gates:** `flutter analyze --fatal-infos`, `dart format`, `flutter test` con cobertura ≥ 50 % (spec 008), revisión de la constitución, revisión de seguridad y PR con CI en verde (spec 007).
**Límites y dudas abiertas:** ver §13.

## 9. Arquitectura y componentes

Se respeta la arquitectura de la spec 001: `domain` en Dart puro, `presentation` sin `data/`, un archivo `<funcion>_providers.dart` como raíz de composición y el cliente generado como única puerta a la API (spec 006).

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/actividad/domain/visita.dart` | Crear | `Visita`, `EstadoVisita`, `ModalidadVisita`, `TecnicoVisita`, `ResultadoLlegada` |
| `app/lib/features/actividad/domain/visita_repository.dart` | Crear | Interfaz: `obtener` (cliente) y, en `trabajo/domain/llegada_repository.dart`, `confirmarLlegada` |
| `app/lib/features/actividad/data/visita_mapper.dart` | Crear | Contrato → dominio; en la vista del técnico rechaza un `codigo` presente |
| `app/lib/features/actividad/data/visita_repository_api.dart` | Crear | Implementación sobre el cliente generado y el transporte de la app |
| `app/lib/features/actividad/data/visita_local_repository.dart` | Crear | Copia cifrada de la visita abierta y su borrado |
| `app/lib/features/actividad/actividad_providers.dart` | Modificar | Raíz de composición: repositorios y controladores de visita |
| `app/lib/features/actividad/presentation/visita_screen.dart` | Crear | Visita a domicilio y cita en taller |
| `app/lib/features/actividad/presentation/visita_controller.dart` | Crear | Carga, refresco, error y sin conexión |
| `app/lib/features/actividad/presentation/widgets/codigo_visita.dart` | Crear | Cuatro recuadros, ocultar y mostrar, semántica por dígito |
| `app/lib/features/trabajo/domain/llegada.dart` | Crear | Estado de la llegada y reglas de los intentos |
| `app/lib/features/trabajo/data/llegada_repository_api.dart` | Crear | `POST /visitas/{id}/llegada` sobre el cliente generado |
| `app/lib/features/trabajo/trabajo_providers.dart` | Crear | Raíz de composición de la función |
| `app/lib/features/trabajo/presentation/llegada_screen.dart` | Crear | Pantalla del técnico con el campo del código |
| `app/lib/features/trabajo/presentation/llegada_controller.dart` | Crear | Envío, intentos, bloqueo y errores |
| `app/lib/features/trabajo/presentation/trabajo_screen.dart` | Modificar | Acceso a la próxima visita |
| `app/lib/core/router/rutas.dart` | Modificar | `visitaCliente` y `visitaTecnico` |
| `app/lib/core/router/app_router.dart` | Modificar | Rama de Actividad y rama de Trabajo |
| `app/lib/core/errores/failure.dart` | Modificar | `CodigoIncorrectoFailure` (422 `codigo_incorrecto`, con `intentosRestantes`) e `IntentosAgotadosFailure` (409 `visita_bloqueada`); el 404 reutiliza `NoEncontradoFailure` de la spec 015 |
| `app/lib/core/red/errores_api.dart` | Modificar | 422 `codigo_incorrecto` → `CodigoIncorrectoFailure` y 409 `visita_bloqueada` → `IntentosAgotadosFailure`; 422 con `errors.codigo` y 409 `fuera_de_ventana` o `visita_no_vigente` a sus propios errores; el 404 ya se mapea a `NoEncontradoFailure` (spec 015) |
| `app/lib/core/errores/mensaje_failure.dart` | Modificar | Traducción de los errores nuevos |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 en ambos idiomas |
| `app/android/app/src/main/kotlin/app/knock/mobile/MainActivity.kt` | Modificar | `MethodChannel` que llama a `setRecentsScreenshotEnabled` (API 33) al entrar y salir de la visita (R-18) |
| `app/lib/features/actividad/presentation/widgets/proteccion_recientes.dart` | Crear | Puente Dart del `MethodChannel`; activa la protección al abrir la visita y la quita al salir |
| `app/android/app/src/main/AndroidManifest.xml` | Modificar | Agregar al `<queries>` existente la intención `VIEW` para `https` (que `canLaunchUrl` funcione en Android 11 o superior); el manifiesto es de la spec 009 y su prueba debe actualizarse |
| `app/pubspec.yaml` | Modificar | `url_launcher` evaluada (D-06); `share_plus` la agrega la spec 022 |

**No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/` y las specs aprobadas.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| Backend 022 (otro repositorio) | Rutas, esquemas, código, intentos y reporte | Sin contrato vendorizado no se implementa la capa `data` |
| 006 Contrato y cliente generado | Cliente Dart y verificación en CI | No hay forma permitida de llamar a la API |
| 002 Piezas comunes | Sesión, renovación, `Failure` y mensajes | Sin token ni manejo de errores común |
| 009 Seguridad del cliente | Almacenamiento seguro, espera por 429, reglas de privacidad y el manifiesto (hay que agregar el `<queries>` de `https` para «Cómo llegar») | El código y los contactos quedarían en claro y «Cómo llegar» caería siempre en el texto |
| 010 Caché y sin conexión | Política de caché y de datos personales | Se guardarían visitas que no deben guardarse |
| 012 Notificaciones y permisos | Aviso previo, apertura de la visita desde un aviso y contenido sin datos | El aviso de «llegó» no abriría la visita |
| 008 Calidad y pruebas | Reglas del analizador, accesibilidad y cobertura | Los gates no existirían |
| 015 Pedir y comparar cotizaciones | Elección de la cotización y paso a la visita | No hay visita que abrir |
| 014 Alinear la UI con la maqueta (reservada) | Tokens, tipografía y contraste | La comparación visual queda pendiente |
| 022 Avisar a alguien de confianza | Hoja del aviso, mensaje y contactos | El botón no abre nada (se oculta) |
| 024 Notificaciones de la cadena | Contenido del aviso «tu técnico llegó» | El aviso no abre la visita |
| 018 Verificación de identidad | Origen de la insignia de verificado | La insignia se muestra igual con lo que devuelve el servidor |

## 11. Definición de terminado

- CA-01 a CA-21 con prueba que falla si la lógica está mal; `python scripts/sdd_lint.py --trace 016` sin `FALTA`.
- `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 %.
- Los ARB de español e inglés completos y la prueba de traducciones en verde; ningún texto escrito en la pantalla.
- El contrato vendorizado incluye las rutas de §4 y el cliente generado compila; el manifiesto del cliente coincide (spec 006).
- Recorrido real contra el entorno desplegado: ver la visita, avisar y confirmar la llegada, con capturas en el PR tomadas con una visita de datos de prueba y el código enmascarado; **nunca** se sube una captura con el código de una visita real.
- Pruebas de accesibilidad y de seguridad negativa en verde; comprobado que el código no aparece en notificaciones ni en registros.
- `Memoria.md` con las decisiones, las dependencias nuevas y lo que quedó pendiente.
- PR con la plantilla completa, la etiqueta `puntos-app-N` y CI en verde.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | Las rutas son `/api/v1/visitas/{id}` y `/visitas/{id}/llegada`, como propone el insumo | Es la ruta que fija backend 022 en el plan del Sprint 4 | Usar `/api/v1/citas/{id}` como dice la ficha de HU-036; queda anotado como conflicto para que backend decida una sola |
| D-02 | La capa Mobile de KNOCK-85 (pantalla «Ya llegué») se cubre en esta spec | Es la única spec de frontend del Sprint 4 y la historia tiene capa Mobile; dejarla fuera deja criterios sin spec | Dejarla para una spec nueva del Sprint 5 |
| D-03 | La visita del cliente cuelga de Actividad (`/actividad/visita/:id`) y la del técnico de Trabajo (`/trabajo/visita/:id`) | Respeta la barra inferior y el `redirect` por rol de la spec 001 | Una sola ruta `/visita/:id` que tendría que decidir el rol dentro de la pantalla |
| D-04 | El código se guarda cifrado en el almacenamiento seguro y se borra al terminar o cancelar la visita y al cerrar sesión | HU-036 CA2 pide verlo sin conexión y la spec 009 ya tiene `AlmacenSeguro` | Guardarlo en `shared_preferences`, que no está cifrado |
| D-05 | No se usa `FLAG_SECURE`; la captura de pantalla del código se acepta como riesgo | Romper capturas y la vista de tareas complica el soporte y la demo; el código caduca con la visita | `FLAG_SECURE` en la pantalla de visita |
| D-06 | Se propone `url_launcher` como dependencia nueva para «Cómo llegar»; se evalúa y registra en `Memoria.md` antes de agregarla | El mapa es del sistema y no se escribe a mano | Construir intenciones nativas a mano |
| D-07 | HU-037 (KNOCK-84) se mueve completa a la spec 022; esta spec solo pone el botón | Las specs 016 y 022 cubrían lo mismo y contaban dos veces los puntos | Mantener la hoja en las dos specs |
| D-08 | Los mensajes de llegada se eligen por `code` del ProblemDetails (tabla de §7) | El 409 de llegada tiene cinco causas con acciones distintas | Un mensaje por código HTTP |
| D-09 | «Ya llegué» se habilita solo con `puedeLlegar` del servidor | El servidor conoce la ventana de la cita y el bloqueo | Calcular la ventana en el teléfono |
| D-10 | El contador de intentos se toma del servidor y nunca se calcula en el teléfono | El servidor es la autoridad y el reporte de gravedad alta depende de sus intentos | Llevar la cuenta en la app, que se reinicia al reinstalar |
| D-11 | La app no envía `Idempotency-Key` en `/llegada` (retirada por ahora, decisión del 2026-11-10) | Backend 022 la quitó; una visita ya `en_curso` responde 409 `codigo_usado` y no consume otro intento | Enviarla de todos modos, que el servidor no lee |
| D-12 | La copia local usa una sola clave de visita abierta con índice y un método `borrarDatosDeVisita()` desde el cierre de sesión | `AlmacenSeguro` no borra por prefijo y el cierre de sesión solo borra los tokens; sin esto el código sobrevive a la cuenta | Una clave por visita sin índice, que no se puede enumerar al cerrar sesión |
| D-13 | En Android 13+ se desactiva la captura en la vista de tareas, sin `FLAG_SECURE` | Evita que el código quede en la miniatura del sistema sin romper las capturas manuales de soporte | `FLAG_SECURE`, que además impide capturas de soporte |

## 13. Riesgos y dudas abiertas

- **Bloqueante:** las rutas de §4 no están en `contracts/openapi.v1.json`; hasta que backend 022 las publique y se vendorice, la capa `data` no se puede implementar ni probar contra el contrato.
- **Resuelto en la revisión (actualizar las fichas):** backend 022 fijó `/api/v1/visitas`; la ficha de HU-036 y la de HU-038 dicen `/api/v1/citas/{id}` y `/api/v1/citas/{id}/llegada`; el insumo y esta spec usan `/visitas`. Una persona debe fijar la ruta definitiva y actualizar la ficha o el insumo (D-01).
- **Riesgo:** `intentosRestantes` solo llega en el 422 `codigo_incorrecto` (backend 022 R-08), no en la vista del técnico; antes del primer intento la pantalla dice «Tienes 3 intentos» como texto fijo de la regla, no como contador.
- **Conflicto con backend 022 (llevado a la spec 022):** backend prepara el texto del aviso **sin** código (`incluyeCodigo: false`) y HU-037 CA1 pide incluirlo; se resuelve en la spec 022.
- **Riesgo:** sin `FLAG_SECURE`, una captura de pantalla con el código puede circular; el código de un solo uso y el bloqueo a los 3 intentos acotan el daño (D-05).
- **Duda abierta (para José):** ¿la capa Mobile de KNOCK-85 se queda en esta spec o se separa? Esta spec la incluye (D-02).
- **Resuelto en la revisión:** el aviso y su `POST /visitas/{id}/aviso` pasan a la spec 022.
- **Duda abierta (para el equipo):** ¿la visita se comparte también por correo o solo por la hoja del sistema? Esta spec usa solo la hoja del sistema.
- **Conflicto detectado:** la spec 010 §5 dice que la app no usa `Idempotency-Key` en esta etapa; esta spec la usa en `/llegada` porque backend 022 la exige y un reintento de red consumiría un intento (D-11). Se anota para que una persona decida si se actualiza la spec 010.
- **Duda abierta (backend 022):** la vista del cliente no trae `llegadaEn`; o se pide el campo en backend 022 o el cliente solo ve «En curso» sin la hora (CA-10). Se comenta también en el PR de backend.
- **Duda abierta (entre specs):** el aviso «tu técnico llegó» se atribuye a la spec 024, pero esa spec lista 8 eventos y ninguno es de llegada (backend 022 ya emite `VisitaEnCurso`). O la spec 024 agrega un evento como `visita_en_curso` (cliente → `/actividad/visita/{recurso}`) o se quita ese aviso de esta spec; hasta decidirlo, el aviso no es criterio verificable de esta spec.
- **Duda abierta (backend 022):** el formato de `telefono` y `whatsapp` (número o enlace) se confirma al vendorizar; la app solo los abre con el sistema y no los guarda.
- **Riesgo aceptado:** el código de 4 dígitos tiene 10 000 combinaciones; el bloqueo a los 3 intentos es del servidor, por visita y por técnico, y no se reinicia al reinstalar (D-10).

## Aprobación

- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-10
- [x] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
