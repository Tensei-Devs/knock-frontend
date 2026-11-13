# Spec 022 — Avisar a alguien de confianza

> **Jira:** KNOCK-84 («HU-037 · Avisar a alguien de confianza», verificada en Jira el 9 de noviembre de 2026; etiquetas `sprint-4` y `candidata-recorte`) · **Épica:** EP-06 Visita segura y trabajo · **Módulo:** requests · **Responsable:** Erick Trejo Reséndiz · **Sprint:** S4 (ola B, junto con la 016; si se recorta, pasa completa al S5) · **Puntos:** 2 (toda la historia se cuenta aquí; la 016 solo pone el botón) · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend, spec 022 «Visita segura con código de 4 dígitos» (`POST /api/v1/visitas/{id}/aviso`, que prepara el texto y registra el aviso)
> **Fuentes:** `docs/backlog/HU-037.md` · `docs/referencia/FUNCIONES_Y_FLUJOS.md` §4.5
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** no agrega rutas; usa `POST /api/v1/visitas/{id}/aviso` ya fijado por backend 022.
> **Estado:** Aprobada

## 1. Objetivo

Que el cliente administre a las personas de confianza (quiénes son, cómo avisarles y qué permisos del teléfono se usan) y les avise quién va a su casa, cuándo y con qué identidad verificada, por SMS, WhatsApp o la hoja de compartir del sistema, sin que esos contactos salgan del teléfono. Esta spec es **dueña completa** de HU-037: la spec 016 solo coloca el botón «Avisar a alguien de confianza» en la visita y abre la hoja de esta spec.

## 2. Historia y casos de prueba

**KNOCK-84** — Como cliente, quiero avisar a alguien de confianza quién viene y cuándo, para que otra persona sepa quién entra a mi casa.

- **CA-01:** Dada una visita con `puedeAvisar` verdadero, cuando toco «Avisar a alguien de confianza», entonces la app pide el texto con `POST /visitas/{id}/aviso`, se abre la hoja con mis contactos y, al elegir uno, la vista previa con el texto del servidor (nombre del técnico, verificación, día, hora y la recomendación de pedir el código) y los canales de envío; el código de la visita no se incluye en el aviso (*decisión automática, revisar*). · Verificación: `app/test/features/actividad/presentation/hoja_avisar_test.dart` → `CA_022_01`
- **CA-02:** Dado el mensaje armado, cuando se revisa, entonces no incluye la dirección del domicilio ni el teléfono del cliente; la dirección solo la agrega la persona a mano. · Verificación: `app/test/features/actividad/domain/mensaje_aviso_test.dart` → `CA_022_02`
- **CA-03:** Dado el mensaje que recibe el contacto, cuando lo abre sin tener Knock, entonces lo entiende: es texto plano, sin enlaces obligatorios ni datos que dependan de la app. · Verificación: `app/test/features/actividad/domain/mensaje_aviso_test.dart` → `CA_022_03`
- **CA-04:** Dado un contacto nuevo, cuando se guarda, entonces queda solo en el almacenamiento seguro del teléfono y no se envía al servidor (ninguna petición lo lleva). · Verificación: `app/test/features/actividad/data/contactos_confianza_repository_test.dart` → `CA_022_04`
- **CA-05:** Dado el formulario de contacto, cuando el nombre tiene menos de 2 o más de 40 caracteres, o el celular no tiene 10 dígitos, entonces se muestra el error junto al campo y no se guarda. · Verificación: `app/test/features/actividad/domain/contacto_confianza_test.dart` → `CA_022_05`
- **CA-06:** Dados 10 contactos guardados, cuando se intenta agregar el 11, entonces la app lo explica, no agrega nada y ofrece borrar uno. · Verificación: `app/test/features/actividad/data/contactos_confianza_repository_test.dart` → `CA_022_06`
- **CA-07:** Dado un celular que ya está en la lista, cuando se intenta guardar de nuevo, entonces no se duplica y se avisa. · Verificación: `app/test/features/actividad/domain/contacto_confianza_test.dart` → `CA_022_07`
- **CA-08:** Dado un contacto, cuando se edita o se borra uno por uno, entonces la lista se actualiza y el almacén no conserva el anterior. · Verificación: `app/test/features/actividad/data/contactos_confianza_repository_test.dart` → `CA_022_08`
- **CA-09:** Dado un contacto elegido, cuando la persona toca «Enviar por SMS», entonces se abre la aplicación de mensajes con el número y el texto ya escritos, sin que la app envíe nada por sí sola y sin pedir el permiso de enviar SMS. · Verificación: `app/test/features/actividad/domain/enlace_aviso_test.dart` → `CA_022_09`
- **CA-10:** Dado un contacto elegido, cuando toca «Enviar por WhatsApp», entonces se abre `https://wa.me/52<celular>?text=<texto codificado>`; si WhatsApp no está instalado, se ofrece la hoja de compartir del sistema. · Verificación: `app/test/features/actividad/domain/enlace_aviso_test.dart` → `CA_022_10`
- **CA-11:** Dada la manifestación de la app, cuando se revisa el manifiesto, entonces **no** declara `READ_CONTACTS`, `SEND_SMS` ni `CALL_PHONE`, y declara solo las consultas (`queries`) necesarias para `sms:`, `https:` y WhatsApp. · Verificación: `app/test/android/manifiesto_permisos_test.dart` → `CA_022_11`
- **CA-12:** Dada una persona que prefiere no guardar contactos, cuando toca «Compartir sin guardar», entonces se abre la hoja del sistema con el mismo texto y no se guarda nada. · Verificación: `app/test/features/actividad/presentation/hoja_avisar_test.dart` → `CA_022_12`
- **CA-13:** Dada la persona que cierra sesión, cuando termina, entonces la lista de contactos y cualquier borrador del mensaje quedan vacíos. · Verificación: `app/test/features/actividad/data/borrado_visita_test.dart` → `CA_022_13`
- **CA-14:** Dada la gestión de contactos desde Mi cuenta, cuando la persona la abre sin visita, entonces puede agregar, editar y borrar contactos y ve el texto de privacidad «Tus contactos se guardan solo en este teléfono». · Verificación: `app/test/features/cuenta/presentation/contactos_confianza_screen_test.dart` → `CA_022_14`
- **CA-15:** Dado el aviso, cuando la app llama a `POST /visitas/{id}/aviso`, entonces el cuerpo va vacío (sin canal, sin nombre ni celular del contacto) y sin `Idempotency-Key`; un doble toque produce una sola llamada porque el botón se deshabilita mientras responde, y una respuesta con `incluyeCodigo` o `incluyeDireccion` verdaderos se rechaza y el texto no se usa. · Verificación: `app/test/features/actividad/data/aviso_repository_api_test.dart` → `CA_022_15`
- **CA-16:** Dado un error del servidor o la falta de conexión al pedir el texto, cuando la persona quiere avisar, entonces la app arma el texto en `domain/` con `DatosAvisoLocal` (R-12), muestra «No pudimos registrar el aviso; puedes enviarlo de todos modos» y no bloquea el envío; con 409 `visit_not_notifiable` no se abre ningún canal y se lee «Esta visita ya no permite avisos». · Verificación: `app/test/features/actividad/presentation/hoja_avisar_test.dart` → `CA_022_16`
- **CA-17:** Dados la lista, el formulario y la hoja, cuando se recorren con lector de pantalla y texto al 200 %, entonces cada control tiene etiqueta, mide al menos 48 dp, el código se lee dígito por dígito y no se corta el contenido. · Verificación: `app/test/features/actividad/presentation/accesibilidad_aviso_test.dart` → `CA_022_17`
- **CA-18:** Dado el registro de la app, cuando se avisa, entonces ningún `print`, registro ni reporte de errores contiene el nombre ni el celular del contacto ni el código (prueba global de la spec 009). · Verificación: `app/test/seguridad/seguridad_cliente_test.dart` → `CA_022_18`
- **CA-19:** Dada una visita de prueba con código 4821 y una dirección, cuando se arman el texto del servidor y el de respaldo local, entonces ninguno contiene esos dígitos ni algún fragmento de la dirección, comparados carácter por carácter, y la plantilla local no recibe esos campos. · Verificación: `app/test/features/actividad/domain/mensaje_aviso_local_test.dart` → `CA_022_19`
- **CA-20:** Dado el cierre de sesión, cuando termina, entonces se borra la copia local del aviso; dada una copia vencida, cuando se necesita, entonces no se usa; y dado el manifiesto de Android, cuando se revisa, entonces `allowBackup` es `false` y las reglas de extracción excluyen el almacenamiento seguro. · Verificación: `app/test/seguridad/respaldo_local_test.dart` → `CA_022_20`

## 3. Alcance / No-alcance

**Dentro**
- Gestión de contactos de confianza (agregar, editar, borrar) desde la hoja de la visita y desde Mi cuenta (`/cuenta/contactos-de-confianza`).
- Envío del aviso por SMS, WhatsApp o la hoja de compartir del sistema, siempre con confirmación de la persona.
- Texto de privacidad y de permisos: qué se usa y qué no.
- Registro del evento del aviso en el servidor (backend 022), sin datos del contacto.
- Estados de vacío, con datos, error y sin conexión; textos en español e inglés; accesibilidad.

**Fuera**
- Seguimiento en vivo de la visita (HU-037 §5).
- Leer la agenda del teléfono: **no** se pide el permiso de contactos (spec 012, R-08).
- Enviar SMS desde la app sin que la persona lo confirme.
- El código y la visita: spec 016 y backend 022.
- Avisos push a la persona de confianza (no tiene Knock).

### Requisitos

- **R-01:** Los contactos de confianza (nombre y celular) viven **solo** en el almacenamiento seguro del teléfono (spec 009), máximo 10, y se borran al cerrar sesión; `ContactoConfianza` y `ContactosConfianzaRepository` se crean en esta spec (la 016 ya no los define).
- **R-02:** El nombre acepta de 2 a 40 caracteres y el celular exactamente 10 dígitos de México; no se duplican celulares.
- **R-03:** No se declara ni se pide `READ_CONTACTS`, `SEND_SMS` ni `CALL_PHONE`; el SMS y WhatsApp se abren por intención y los envía la persona.
- **R-04:** El mensaje es el `texto` que prepara el servidor, tal cual, sin código ni dirección (*decisión automática, revisar*: alineado con backend 022 R-12, `incluyeCodigo: false`); **no** incluye la dirección ni el teléfono del cliente. Antes de abrir cualquier canal se muestra la vista previa final.
- **R-05:** Los enlaces de SMS y WhatsApp se construyen con el celular validado y el texto codificado con `Uri.encodeComponent`; solo se abren los esquemas `sms:` y `https:` (`wa.me`), nunca esquemas arbitrarios.
- **R-06:** El código nunca aparece en el mensaje de aviso, ni en un aviso push, ni en un registro, ni en el evento del servidor.
- **R-07:** `POST /visitas/{id}/aviso` va con cuerpo vacío y sin `Idempotency-Key` (así lo define backend 022); no lleva el canal ni datos del contacto. El conteo de avisos del servidor es solo informativo: no hay límite de 10 por hora (decisión del 2026-11-12, backend 022). La app llama una sola vez al abrir la hoja y reutiliza el texto mientras siga abierta; una segunda apertura es una llamada nueva.
- **R-08:** Todo error de la API se muestra con un texto del catálogo; nunca con el código HTTP.
- **R-09:** Todos los textos viven en los ARB de español e inglés y los colores y tipografías en el tema (spec 014).
- **R-10:** Cada control mide al menos 48 dp, tiene etiqueta y funciona con texto al 200 %.
- **R-11:** La app nunca registra el nombre ni el celular de un contacto, ni el código, en consola, caché o reporte de errores.
- **R-12:** **Respaldo local sin conexión.** El texto de respaldo se arma en `domain/` con `DatosAvisoLocal` (nombre público del técnico, verificación, día y hora), un objeto que un mapeador construye copiando solo esos cuatro campos de la copia local de la visita; la plantilla local **nunca** recibe el código ni la dirección. La copia vive en el almacenamiento seguro (`knock.aviso.respaldo.{visitaId}`), vence 24 horas después de la hora de la cita, se borra al cerrar sesión y queda fuera de los respaldos del teléfono: el manifiesto de Android declara `android:allowBackup="false"` y las reglas `dataExtractionRules` y `fullBackupContent` excluyen los archivos del almacenamiento seguro y de las preferencias (hoy el manifiesto no declara ninguno de los tres).

## 4. Contrato API y eventos

La app **consume** una ruta de backend 022 («Visita segura con código de 4 dígitos»); alineado el 9 de noviembre de 2026 con su borrador.

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/visitas/{id}/aviso` | Pedir el texto del aviso y registrar que se avisó | vacío (sin `Idempotency-Key`) | `200` con `{ texto, incluyeCodigo: false, incluyeDireccion: false }` | `401`, `404` (ajena o inexistente), `409 visit_not_notifiable` (la visita no está en `confirmada` ni `en_curso`), `429` con `Retry-After` |

Reglas del contrato que la app da por ciertas:
- **Autorización:** solo el cliente dueño de la visita; el servidor decide por el token.
- **Contenido:** el texto incluye el nombre público del técnico, su verificación, el día, la hora y la recomendación de pedir el código en la puerta; nunca el código ni la dirección. La app rechaza una respuesta con `incluyeCodigo` o `incluyeDireccion` verdaderos.
- **Límites:** el aviso no tiene límite propio; rige el límite general por usuario del gateway (429 con `Retry-After`).
- **Privacidad:** el servidor no recibe ni guarda el contacto ni el canal; solo cuenta el aviso (`avisosEnviados`) y emite `AvisoConfianzaPreparado` sin teléfonos ni texto.
- **Caché:** la respuesta no se guarda.
- **Eventos:** ninguno consumido.

## 5. Modelo de datos

| Entidad | Campos | Reglas |
|---|---|---|
| `ContactoConfianza` | `id`, `nombre` (2–40), `celular` (10 dígitos) | Se define en esta spec; sin duplicados por celular normalizado |
| `MensajeAviso` | `texto`, `incluyeCodigo`, `enlaceSms`, `enlaceWhatsApp` | Se define en esta spec; sin dirección ni teléfono del cliente |
| `CanalDeAviso` | `sms`, `whatsapp`, `compartir` | Solo en el teléfono; no se envía al servidor (D-05) |

**Estado local**
- `knock.contactos.confianza` en el almacenamiento seguro (lista de hasta 10).
- `knock.aviso.respaldo.{visitaId}` en el almacenamiento seguro (`DatosAvisoLocal`, vence 24 horas después de la cita; R-12).
- Nada en `shared_preferences` ni en la caché de respuestas; todo se borra al cerrar sesión.
- Fuera de la copia de seguridad del sistema, comprobado con la prueba del manifiesto de la spec 015 (R-16).

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Fuga de información:** contactos o códigos en el servidor, registros o reportes de errores | Contactos solo en almacenamiento seguro; el evento no los lleva; sin `print` | CA-04, CA-15, CA-18 |
| **Fuga de información:** la dirección del domicilio en el mensaje | El texto no la incluye; la persona puede agregarla a mano | CA-02 |
| **Fuga de información:** código enviado sin querer | Vista previa y confirmación explícita antes de abrir cualquier canal | CA-01 |
| **Suplantación:** enlaces manipulados hacia otros esquemas o números | Solo `sms:` y `https://wa.me/`, celular validado y texto codificado | CA-09, CA-10 |
| **Elevación de privilegios:** pedir permisos de contactos o SMS | No se declaran (prueba del manifiesto) | CA-11 |
| **Alteración:** doble aviso por doble toque | Botón deshabilitado durante la llamada y sin reintento automático | CA-15 |
| **Denegación:** muchos avisos | El aviso no tiene límite propio (el conteo es solo informativo); rige el límite general del gateway y `Retry-After` | CA-16 |
| **Datos en el teléfono:** cuenta anterior con contactos | Borrado al cerrar sesión | CA-13 |
| **Dependencias:** `url_launcher` o `share_plus` vulnerables | `url_launcher` la evalúa la spec 016 (D-06); `share_plus` la evalúa esta spec antes de agregarla y la registra en `Memoria.md` | (comando) `flutter pub outdated` + revisión en el PR |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos nuevos (ARB `aviso*`, `contacto*`) |
|---|---|---|---|
| Hoja «Avisar a alguien» (`showModalBottomSheet`, se modifica) | vacío de contactos, con contactos, error al abrir, sin conexión al registrar | Lista de contactos, vista previa, «Enviar por SMS», «Enviar por WhatsApp», «Compartir sin guardar» | `avisoEnviarSms`, `avisoEnviarWhatsapp`, `avisoCompartirSinGuardar`, `avisoVistaPrevia`, `avisoNoRegistrado`, `avisoWhatsappNoInstalado` |
| Contactos de confianza (`/cuenta/contactos-de-confianza`) | vacío, con datos | Lista, «Agregar contacto», editar, borrar, texto de privacidad | `contactosTitulo`, `contactosVacio`, `contactosPrivacidad`, `contactosAgregar`, `contactosEditar`, `contactosBorrar`, `contactosBorrarConfirmar`, `contactosMaximo`, `contactoDuplicado` |
| Formulario de contacto (hoja) | vacío, error de validación | Nombre y celular | `contactoNombre`, `contactoCelular`, `contactoNombreError`, `contactoCelularError`, `contactoGuardar` |
| Mi cuenta (`/cuenta`, se modifica) | — | Fila «Contactos de confianza» | `cuentaContactosConfianza` |

**Mensajes exactos** (español; el inglés va en `app_en.arb`)

| Situación | Texto en pantalla |
|---|---|
| Sin contactos | «Agrega a alguien de confianza para avisarle cuando tengas una visita» |
| Privacidad | «Tus contactos se guardan solo en este teléfono» |
| Nombre inválido | «Escribe un nombre de 2 a 40 caracteres» |
| Celular inválido | «Escribe los 10 números del celular» |
| Celular repetido | «Ese celular ya está en tu lista» |
| Máximo de 10 | «Ya tienes 10 contactos. Borra uno para agregar otro.» |
| Sin app de mensajes o WhatsApp | «No encontramos una app para enviar. Usa «Compartir».» |
| `visit_not_notifiable` (409) | «Esta visita ya no permite avisos» |
| Error o sin conexión al registrar | «No pudimos registrar el aviso; puedes enviarlo de todos modos» |
| 429 | «Ya enviaste muchos avisos. Espera {minutos} minutos.» |

Reglas de pantalla:
- La fila de Mi cuenta usa la «fila» de la spec 014.
- Borrar un contacto pide confirmación.
- Accesibilidad: contraste según la spec 014; el código se lee dígito por dígito; la lista anuncia «3 de 10 contactos».

## 8. Pruebas, gates y límites

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Validación, mensaje, enlaces, repositorio |
| Widget (W) | Sí | Hoja, lista, formulario, estados |
| Aceptación (ACC) | Sí | CA-01 a CA-20 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` con la ruta de aviso de backend 022 (cuerpo vacío y respuesta `{ texto, incluyeCodigo, incluyeDireccion }`) |
| Integración (INT) | Sí | Recorrido con API simulada en `integration_test/` y humo contra el entorno desplegado con una visita de semilla |
| Seguridad negativa (NEG) | Sí | Manifiesto sin permisos, enlaces con caracteres raros, ausencia de datos en registros |
| Accesibilidad (A11Y) | Sí | `expectAccesible` y texto al 200 % |
| Mutación (MUT) | Sí | `domain/` del aviso (contacto, mensaje y enlaces codificados) con `mutation_test`, meta 70 % |
| E2E | Sí | Recorrido en emulador: visita confirmada → contacto → vista previa → SMS |
| Regresión | Sí | Suite completa; la hoja de la spec 016 sigue funcionando |
| Análisis estático y vulnerabilidades | Sí | Los del CI |
| Rendimiento (PERF) | No | Volumen bajo |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Contacto guardado, vista previa confirmada, SMS abierto con texto |
| Positivo | «Compartir sin guardar» abre la hoja del sistema |
| Negativo | Celular de 9 dígitos o nombre de 1 letra: no se guarda |
| Negativo | Persona que cierra la vista previa sin enviar: no se abre nada |
| Error esperado | 409 `visit_not_notifiable` (visita cancelada): mensaje y sin canal |
| Error esperado | 429 → `Retry-After`; sin conexión → el aviso al contacto no se bloquea |
| Caso límite | 10 y 11 contactos; mismo celular con espacios o guiones; nombre con acentos y emojis |
| Caso límite | Teléfono sin app de mensajes ni de WhatsApp |
| Caso límite | Texto de 1 000 caracteres en la aplicación de mensajes |

**Gates:** los de la spec 015 (§8).

## 9. Arquitectura y componentes

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/actividad/domain/contacto_confianza.dart` | Crear | `ContactoConfianza`, validaciones, edición y duplicados |
| `app/lib/features/actividad/domain/mensaje_aviso.dart` | Crear | Texto del servidor tal cual; texto local de respaldo sin conexión |
| `app/lib/features/actividad/domain/enlace_aviso.dart` | Crear | Construcción de los enlaces con codificación |
| `app/lib/features/actividad/data/contactos_confianza_repository.dart` | Crear | Contactos en el almacenamiento seguro, máximo 10, editar y borrar uno por uno, `borrarTodos()` desde el cierre de sesión |
| `app/lib/features/actividad/data/aviso_repository_api.dart` | Crear | `POST /visitas/{id}/aviso` sobre el cliente generado y validación de `incluyeCodigo`/`incluyeDireccion` |
| `app/lib/features/actividad/presentation/widgets/hoja_avisar.dart` | Crear | Contactos, vista previa (sin código ni dirección), canales y «Compartir sin guardar» |
| `app/lib/features/cuenta/presentation/contactos_confianza_screen.dart` | Crear | Lista y formulario |
| `app/lib/features/cuenta/presentation/cuenta_screen.dart` | Modificar | Fila «Contactos de confianza» |
| `app/lib/core/router/rutas.dart`, `app_router.dart` | Modificar | Ruta `/cuenta/contactos-de-confianza` |
| `app/android/app/src/main/AndroidManifest.xml` | Modificar | Solo `queries` para `sms:` y `https:` |
| `app/test/android/manifiesto_permisos_test.dart` | Crear | Prueba del manifiesto |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 |

Los contactos viven en `features/actividad/` (spec 016) y su pantalla en `features/cuenta/` (D-01). **No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/`.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| 016 Visita con código | Botón de entrada, `puedeAvisar` y copia local de la visita para el texto de respaldo | La hoja no tiene desde dónde abrirse: **se implementa después de la 016** |
| Backend 022 | `POST /visitas/{id}/aviso` (sin límite propio) | No se registra el aviso |
| 012 Notificaciones y permisos | Regla de no pedir permisos de contactos | Se contradiría R-03 |
| 009 Seguridad del cliente | Almacenamiento seguro y prueba global de registros | Contactos en claro |
| 014 Alinear la UI | la «fila» y el «estado vacío o de error» de la spec 014 | Estilos duplicados |
| 002, 010 | Errores y política de caché | Manejo incompleto |

## 11. Definición de terminado

- CA-01 a CA-20 con prueba que falla si la lógica está mal; `python scripts/sdd_lint.py --trace 022` sin `FALTA`.
- `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed` y `flutter test` en verde.
- Manifiesto sin permisos de contactos, SMS ni llamadas, comprobado con prueba.
- ARB completos; PR con la plantilla completa, etiqueta `puntos-app-N`, CI en verde y `Memoria.md` al día.
- Capturas del recorrido con contactos ficticios, **nunca** con números reales.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | Se agrega una pantalla de contactos en Mi cuenta | HU-037 pide contactos «guardados en el dispositivo» y administrarlos solo desde la visita obliga a tener una visita | Dejarlos solo en la hoja de la visita |
| D-02 | El envío directo usa intención `sms:` y `wa.me` | No requiere permisos y deja la decisión de enviar a la persona | `SEND_SMS`, que permite enviar sin confirmación |
| D-03 | Esta spec es dueña completa de HU-037 y crea contactos, mensaje y hoja; la 016 solo pone el botón | Evita dos implementaciones y contar dos veces los 2 puntos | Repartir la historia entre 016 y 022 |
| D-04 | El celular es de 10 dígitos de México | La app opera en la ciudad piloto y WhatsApp requiere código de país (`52`) | Aceptar cualquier país |
| D-05 | El evento del aviso va sin cuerpo y sin canal | Backend 022 define el cuerpo vacío y no necesita saber a quién ni por dónde se avisó | Enviar el canal, que el servidor no lee |
| D-06 | El código de la visita no viaja en el aviso (se quitó la casilla) | Backend 022 R-12 prepara el texto con `incluyeCodigo: false` y HU-036 dice que el código nunca se dicta ni se comparte por mensaje | Incluir la casilla del código (HU-037 CA1), que haría viajar el código en un mensaje reenviable. *Decisión de revisión, confirmar.* |
| D-07 | Sin conexión, el texto se arma con la copia local de la visita | El aviso a una persona de confianza no debe depender de la señal | Bloquear el aviso sin conexión |

## 13. Riesgos y dudas abiertas

- **Resuelto en la revisión:** KNOCK-84 se quitó de la 016; esta spec la cubre completa (D-03).
- **Conflicto con backend 022 (decisión de revisión, confirmar; fijada en la revisión del 9 de noviembre, falta que José la confirme):** HU-036 dice que el código «nunca se dicta por teléfono ni por mensaje» y backend 022 prepara el texto sin código, mientras HU-037 CA1 pide incluirlo. Se aplica la recomendación de backend 022 (R-12): el código no viaja en el aviso y se quitó la casilla. Si José decide lo contrario, hay que volver a agregar la casilla en CA-01 y R-04 y coordinarlo con backend 022.
- **Riesgo:** en Android 11 o superior, abrir `sms:` y `wa.me` requiere `queries` en el manifiesto; si faltan, el botón no encuentra aplicación.
- **Riesgo:** el mensaje de WhatsApp o SMS queda en el teléfono de la persona de confianza; no se puede borrar desde Knock.
- **Duda abierta (para José):** ¿se quiere que el aviso incluya la placa o el vehículo del técnico en mecánica? No está en HU-037.
- **Duda abierta (para el equipo):** el límite de 10 contactos es decisión de estas specs; HU-037 no lo fija.

## Aprobación

- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-12
- [x] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
