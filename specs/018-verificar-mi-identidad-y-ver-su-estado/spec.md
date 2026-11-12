# Spec 018 — Verificar mi identidad y ver su estado (pantallas)

> **Jira:** KNOCK-79 («HU-021 · Verificar mi identidad (opcional, consentimiento biométrico)») y KNOCK-80 («HU-022 · Ver mi estado de verificación y reintentar»), verificadas en Jira el 9 de noviembre de 2026 (ambas con la etiqueta `candidata-recorte`) · **Épica:** EP-09 Lado del técnico · **Módulo:** trust · **Responsable:** José Julián Hernández Hernández (la pantalla la implementa Erick Trejo Reséndiz) · **Sprint:** S4 (ola C, prioridad P3) · **Puntos:** 7 (5 + 2) · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend (spec 025 «Verificación de identidad con consentimiento»)
> **Fuentes:** `docs/referencia/FUNCIONES_Y_FLUJOS.md` §4.2 y §7.3 · `docs/referencia/DECISIONES.md` #4 · `docs/backlog/HU-021.md` y `HU-022.md`
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye estas rutas; las fija backend 025 y se vendoriza antes de implementar (spec 006).
> **Estado:** Borrador

## 1. Objetivo

Que un técnico pueda dar su consentimiento biométrico, tomar las fotos de su INE y su selfie, enviarlas cifradas y ver en qué va su verificación (Sin verificar, En revisión, Verificado o No se pudo verificar), con la opción de reintentar o subir de nivel. Esta spec cubre la capa **Mobile**; el cifrado, la llave por verificación, el OCR, el hash de la CURP, el borrado a 7 días y la decisión son del backend (spec 025).

## 2. Historia y casos de prueba

**KNOCK-79** — Como técnico, quiero verificar mi identidad con mi INE y una selfie, para mostrar la insignia de verificado y que los clientes confíen en mí.
**KNOCK-80** — Como técnico, quiero ver en qué va mi verificación y reintentar si no pasó, para saber qué sigue sin preguntar a nadie.

- **CA-01:** Dado el técnico sin el consentimiento aceptado, cuando intenta tomar fotos, entonces no puede continuar y se le explica por qué, con la casilla propia y sin marcar. · Verificación: `app/test/features/trabajo/presentation/consentimiento_controller_test.dart` → `CA_018_01`
- **CA-02:** Dado el técnico que acepta el consentimiento, cuando continúa, entonces la app envía solo `aceptaBiometria: true` y `versionAviso`; el texto, la fecha y el dispositivo los guarda el servidor desde la sesión, y la app no los guarda por su cuenta. · Verificación: `app/test/features/trabajo/data/verificacion_repository_api_test.dart` → `CA_018_02`
- **CA-03:** Dada una foto borrosa, oscura, con reflejo o con el INE en vertical, cuando la toma, entonces se rechaza en el teléfono con un mensaje claro y puede repetirla; la captura solo se pide a la cámara y nunca a la galería. · Verificación: `app/test/features/trabajo/domain/revision_foto_test.dart` → `CA_018_03`
- **CA-04:** Dado el nivel básico (INE frente y selfie) o el completo (también el reverso), cuando termina, entonces la app sube cada foto a su enlace firmado, confirma cada una con `POST .../fotos/{tipo}/confirmar`, llama a `POST .../enviar`, el estado pasa a **En revisión** y ve «Revisamos en menos de 24 h»; el cifrado con la llave propia de la verificación lo hace el servidor al confirmar. · Verificación: `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_04`
- **CA-05:** Dado el técnico con una verificación **En revisión**, cuando intenta crear otra, entonces recibe 409 `verification_under_review`, ve «Ya tienes una verificación en revisión» y no se crea otra. · Verificación: `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_05`
- **CA-06:** Dado un enlace de subida vencido (el almacenamiento rechaza la subida) o un 409 `capture_expired`, cuando ocurre, entonces la app descarta la captura en memoria, muestra «Tu captura venció. Vuelve a tomar las fotos.» y una nueva creación hace que el servidor cancele la anterior, sin dejar dos capturas vivas. · Verificación: `app/test/features/trabajo/data/verificacion_repository_api_test.dart` → `CA_018_06`
- **CA-07:** Dada una CURP que coincide con la de otra cuenta, cuando el servidor responde 409 `curp_duplicate`, entonces la app muestra «No pudimos continuar con esta CURP. Escríbenos a soporte para revisarlo.», sin revelar la otra cuenta. · Verificación: `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_07`
- **CA-08:** Dado el técnico **En revisión**, cuando abre Verificación, entonces ve «Revisamos en menos de 24 h» y la fecha del envío. · Verificación: `app/test/features/trabajo/presentation/estado_verificacion_screen_test.dart` → `CA_018_08`
- **CA-09:** Dado el técnico rechazado, cuando abre Verificación, entonces ve el motivo, los consejos y el botón «Intentar de nuevo». · Verificación: `app/test/features/trabajo/presentation/estado_verificacion_screen_test.dart` → `CA_018_09`
- **CA-10:** Dado el técnico verificado con `nivelOtorgado = basica`, cuando abre Verificación, entonces ve la insignia y la opción «Subir a completa» con el reverso; con `completa` la opción no aparece y un 409 `already_fully_verified` se muestra como «Ya tienes la verificación completa»; un 409 `already_verified` (pedir `basica` cuando ya tiene `basica`) se muestra como «Ya tienes esta verificación». · Verificación: `app/test/features/trabajo/presentation/estado_verificacion_screen_test.dart` → `CA_018_10`
- **CA-11:** Dados 7 días sin revisión, cuando abre Verificación, entonces el servidor devuelve `sin_verificar` con `motivo = fotos_borradas` y `puedeReintentar`, y la app muestra «Tus fotos se borraron porque no se revisaron a tiempo. Puedes enviarlas de nuevo.» con el estado **Sin verificar** y no «No verificado». · Verificación: `app/test/features/trabajo/domain/verificacion_test.dart` → `CA_018_11`
- **CA-12:** Dado un cambio de estado, cuando llega el aviso push, entonces abre la pantalla de verificación y la carga del aviso no lleva el motivo, las fotos ni datos del INE. · Verificación: `app/test/features/trabajo/data/carga_verificacion_test.dart` → `CA_018_12`
- **CA-13:** Dada la vista pública del técnico, cuando un cliente la consulta, entonces solo ve «Verificado» o «Sin verificar», nunca el motivo, los consejos ni las fotos. · Verificación: `app/test/features/trabajo/domain/verificacion_publica_test.dart` → `CA_018_13`
- **CA-14:** Dadas las pantallas de consentimiento, captura y estado, cuando se recorren con lector de pantalla y texto al 200 %, entonces cada control tiene etiqueta, mide al menos 48 dp y no se corta el contenido. · Verificación: `app/test/features/trabajo/presentation/accesibilidad_verificacion_test.dart` → `CA_018_14`
- **CA-15:** Dado un 429 con `Retry-After`, un 5xx o una caída de red, cuando se envía o se consulta la verificación, entonces se muestra el estado de error o el tiempo de espera, hay «Reintentar» cuando aplica y no se reintenta en bucle. · Verificación: `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_15`
- **CA-16:** Dadas las fotos capturadas, cuando se procesan y se suben, entonces no se guardan en la galería, la copia temporal se borra al terminar y no se registra ni se cachea ninguna imagen ni dato del INE. · Verificación: `app/test/features/trabajo/data/foto_local_repository_test.dart` → `CA_018_16`
- **CA-17:** Dado el consentimiento sin aceptar, cuando el repositorio recibe la orden de crear la verificación, entonces lanza `AvisoNoAceptadoFailure` antes de llamar a la API, y un 422 `consent_required` del servidor (por ejemplo, versión del aviso desactualizada) se muestra como «Necesitamos que aceptes el aviso vigente» con la opción de volver a aceptarlo. · Verificación: `app/test/features/trabajo/data/verificacion_repository_api_test.dart` → `CA_018_17`
- **CA-18:** Dada una foto con metadatos EXIF (fecha, modelo del teléfono o coordenadas), cuando se prepara para subir, entonces se re-codifica y la imagen enviada no conserva ningún metadato, comprobado con el paquete `image`. · Verificación: `app/test/features/trabajo/data/foto_local_repository_test.dart` → `CA_018_18`
- **CA-19:** Dadas las fotos en memoria, cuando la persona abandona el flujo o se cierra la sesión, entonces la copia temporal se borra y una prueba comprueba que el directorio temporal y el estado del controlador quedan vacíos. · Verificación: `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_19`
- **CA-20:** Dado un fallo de red al crear la verificación, cuando la persona toca «Intentar de nuevo», entonces la app crea una nueva (el servidor cancela la captura anterior), no reintenta sola y, ante un 429 por el límite de 3 creaciones por hora, muestra el tiempo de espera. · Verificación: `app/test/features/trabajo/data/verificacion_repository_api_test.dart` → `CA_018_20`
- **CA-21:** Dada una foto de más de 8 MB o de un tipo que no es JPEG ni PNG, cuando se va a subir, entonces se rechaza antes de decodificarla, con un mensaje del catálogo y sin consumir memoria del teléfono; si aun así el servidor responde 422 `content_invalid` al confirmar, se pide repetir solo esa foto. · Verificación: `app/test/features/trabajo/data/foto_local_repository_test.dart` → `CA_018_21`
- **CA-22:** Dado el campo de la CURP, cuando no tiene 18 caracteres con el patrón oficial (cuatro letras, seis dígitos, `H` o `M`, dos letras de entidad, tres consonantes, un carácter alfanumérico y un dígito), entonces muestra «Revisa tu CURP: son 18 caracteres» y no llama a la API; un 422 `curp_invalid` muestra el mismo texto. · Verificación: `app/test/features/trabajo/domain/curp_test.dart` → `CA_018_22`
- **CA-23:** Dada la CURP capturada, cuando se crea la verificación o se abandona el flujo, entonces la CURP solo vivió en memoria: no está en el estado persistido, en `shared_preferences`, en el almacén seguro, en un registro ni en un reporte de errores, y el campo se vacía al recibir la respuesta. · Verificación: `app/test/seguridad/curp_privada_test.dart` → `CA_018_23`
- **CA-24:** Dado el paso de envío, cuando el servidor responde 409 `photos_missing`, `photo_not_uploaded` o `photo_already_confirmed`, entonces la app vuelve a la foto que falta, vuelve a subir la que no llegó o trata la ya confirmada como lista, sin crear otra verificación. · Verificación: `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_24`
- **CA-25:** Dada una cuenta con eliminación programada, cuando intenta verificarse, entonces el servidor responde 409 `deletion_scheduled` y la app muestra «Tu cuenta está por eliminarse; no puedes verificarla ahora.» · Verificación: `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_25`

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Explicación en lenguaje simple y vista previa del aviso de privacidad.
- Consentimiento biométrico con casilla propia, sin marcar y separada de los términos.
- Captura con la cámara del teléfono y revisión de calidad en el dispositivo (INE en vertical, muy pequeña, oscura, con reflejo o borrosa).
- Captura de la CURP (solo en memoria) y validación de su formato.
- Subida por los enlaces firmados que da el servidor, confirmación por foto y envío a revisión.
- Pantalla de estado: Sin verificar, En revisión, Verificado (básico o completo) y No se pudo verificar, con motivo y consejos.
- Reintento y subida de nivel (agregar el reverso).
- Aviso de las fotos borradas a los 7 días sin revisión.
- Aviso push al cambiar de estado y su apertura.
- Estados de carga, con datos, vacío, error, sin conexión y reintento.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.
- Pruebas unitarias, de widget, de contrato, de seguridad negativa, de accesibilidad y de integración.

**Fuera**
- El cifrado, la llave por verificación, el OCR, la comparación facial, el hash de la CURP, el borrado a 7 días y la decisión: backend 025.
- La revisión manual desde el panel interno y el registro de quién ve las fotos (HU-067): otra spec.
- El borrado programado de las fotos (HU-068) y su panel: otra spec.
- Un proveedor automático de KYC.
- La insignia y el filtro «solo verificados» del lado del cliente: ya los consume la spec 015 con el campo `verificado`.
- La verificación por SMS del celular (KNOCK-228) y la sesión.

### Requisitos

- **R-01:** Sin la casilla del consentimiento aceptada no se abre la cámara ni se llama a la API; la casilla es propia, está sin marcar y se explica en lenguaje simple qué se hace con las fotos.
- **R-02:** El consentimiento se registra en el servidor con el texto, la versión, la fecha y el dispositivo (este, tomado de la sesión); la app envía solo `aceptaBiometria: true` y la `versionAviso` que mostró, nunca datos personales.
- **R-03:** Se capturan INE frente y selfie para el nivel básico, y también INE reverso para el completo; no se aceptan fotos de la galería, solo de la cámara.
- **R-04:** Antes de subir, la app revisa la calidad en el teléfono (orientación del INE, tamaño mínimo, brillo, reflejo y nitidez) y rechaza con un mensaje claro y la opción de repetir.
- **R-05:** Las fotos se suben solo a los enlaces firmados que devuelve el servidor (vigencia de 5 minutos), se re-codifican sin metadatos y nunca se guardan en la galería, en la caché ni en un registro.
- **R-06:** La copia temporal que entrega la cámara se lee en memoria y se borra al terminar la subida, al salir del flujo y al cerrar sesión.
- **R-07:** El estado y el nivel los decide el servidor; la app solo los muestra y no inventa un estado local.
- **R-08:** El motivo y los consejos de un rechazo se muestran solo al técnico; la vista pública solo dice «Verificado» o «Sin verificar».
- **R-09:** Una captura vencida (enlace o `capture_expired`) obliga a tomar de nuevo las fotos; la nueva creación cancela la anterior en el servidor y nunca quedan dos capturas vivas.
- **R-10:** Si ya hay una verificación En revisión, la app no crea otra y muestra el estado.
- **R-11:** A los 7 días sin revisión el servidor borra las fotos y deja el estado en Sin verificar; la app muestra el aviso y permite reenviar.
- **R-12:** Todo error de la API se muestra con un texto del catálogo de traducciones; nunca con el código HTTP, la URL ni el cuerpo de la respuesta.
- **R-13:** Cada pantalla tiene estados de carga, con datos, vacío, error y sin conexión, y un botón de reintentar cuando aplica.
- **R-14:** Todos los textos visibles viven en los ARB de español e inglés y todos los colores y tipografías en el tema.
- **R-15:** Cada control interactivo tiene etiqueta semántica, mide al menos 48 dp y funciona con el texto del sistema al 200 %.
- **R-16:** La creación no lleva `Idempotency-Key` (backend 025 no la usa): la app deshabilita el botón durante la operación, no reintenta sola y se apoya en que el servidor mantiene una sola captura viva por persona.
- **R-18:** La CURP se pide en el paso 1, se valida con el patrón oficial en el teléfono, viaja solo en el cuerpo de la creación y vive solo en memoria; nunca se guarda, se registra ni se muestra después.
- **R-19:** Cada foto se confirma con su ruta después de subirla y la verificación se envía solo cuando todas las del nivel están confirmadas; la app sigue el estado de cada foto que devuelve el servidor (`pendiente`, `cifrada`, `borrada`).
- **R-17:** El tipo y el tamaño de la foto se validan antes de decodificarla (solo JPEG o PNG, máximo 8 MB), para no gastar memoria con un archivo que se va a rechazar.

## 4. Contrato API y eventos

La app **consume**; el contrato lo fija backend 025 («Verificación de identidad con consentimiento») y se vendoriza en `contracts/openapi.v1.json` para regenerar el cliente Dart (spec 006). Esta tabla se alineó el 9 de noviembre de 2026 con el borrador de backend 025; si al vendorizar cambia un nombre o un tipo, se corrige aquí antes de implementar.

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `POST /api/v1/me/verificacion` | Crear la verificación y recibir los enlaces de subida | `{ nivel (basica\|completa), aceptaBiometria: true, versionAviso, curp }` (cuerpo ≤ 8 KB) | `201` con `{ id, estado: "en_captura", nivel, fotos[{ tipo, urlSubida, venceEn }], capturaVenceEn }` | `401`, `409` (`verification_under_review`, `curp_duplicate`, `already_verified`, `already_fully_verified`, `deletion_scheduled`), `413`, `422` (`consent_required`, `curp_invalid`, `errors.nivel` si el `nivel` es inválido), `429` |
| `PUT` a cada `urlSubida` | Subir la foto al almacenamiento | Binario JPEG o PNG ≤ 8 MB. Un `PUT` a un SAS de Azure Blob exige el encabezado `x-ms-blob-type: BlockBlob` (y conviene `Content-Type`); backend 025 R-08 solo devuelve `{ tipo, urlSubida, venceEn }`, sin encabezados: **dependencia abierta con backend 025** (§13); no se inventa el contrato aquí | Respuesta del almacenamiento | Enlace vencido o rechazado (CA-06); sin ese encabezado Azure responde 400 |
| `POST /api/v1/me/verificacion/{id}/fotos/{tipo}/confirmar` | Confirmar cada foto subida | vacío | `200` con `{ tipo, estado }` | `400`, `401`, `404`, `409` (`photo_not_uploaded`, `photo_already_confirmed`, `capture_expired`), `422 content_invalid`, `429` |
| `POST /api/v1/me/verificacion/{id}/enviar` | Mandar a revisión | vacío | `200` con `{ id, estado: "en_revision", enviadoEn, expiraEn }` | `401`, `404`, `409 photos_missing`, `429` |
| `GET /api/v1/me/verificacion` | Ver el estado | — | `200` con `{ id?, nivel?, estado, motivo?, consejos[], nivelOtorgado?, fotos[{ tipo, estado }], creadoEn?, enviadoEn?, decididoEn?, expiraEn?, puedeReintentar }`; sin verificación previa, `{ estado: "sin_verificar", puedeReintentar: true }` | `401`, `429` |

Reglas del contrato que la app da por ciertas:
- **Autorización:** todas las rutas son de la persona del token; una verificación ajena responde `404` uniforme.
- **Cifrado:** el servidor cifra cada foto con la llave propia de la verificación al confirmarla; la app sube por HTTPS al enlace firmado y nunca ve la llave.
- **Consentimiento:** `aceptaBiometria` debe ser `true` y `versionAviso` debe coincidir con la vigente; si no, `422 consent_required`.
- **Una captura viva:** crear de nuevo con una `en_captura` existente la cancela; con una `en_revision` responde `409`.
- **Límites:** 3 creaciones y 10 confirmaciones por hora por persona; enlaces de 5 minutos; 8 MB por foto; solo JPEG o PNG validados por contenido en el servidor.
- **Borrado:** a los 7 días sin decisión el servidor borra las fotos y deja `sin_verificar` con `motivo = fotos_borradas`.
- **Caché:** `Cache-Control: private, no-store`; la app no guarda nada de esta función.
- **Privacidad:** la respuesta nunca trae las fotos, sus direcciones, la CURP ni su huella; el aviso de privacidad completo se abre en una URL fija de la landing con `https://` y sin parámetros.
- **Eventos:** el aviso de cambio de estado llega por la spec 012 (contenido en la spec 024); su carga lleva tipo y destino, nunca el motivo, las fotos ni datos del INE.

## 5. Modelo de datos

**Entidades de dominio** (`app/lib/features/trabajo/domain/`, Dart puro, sin Flutter ni HTTP)

| Entidad | Campos | Reglas |
|---|---|---|
| `Verificacion` | `id?`, `nivel?` (`basica`, `completa`), `estado` (`sinVerificar`, `enCaptura`, `enRevision`, `verificada`, `noVerificada`, mapeados desde `sin_verificar`, `en_captura`, `en_revision`, `verificada`, `no_verificada`), `motivo?`, `consejos` (0 a 3), `nivelOtorgado?`, `fotos` (`tipo`, `estado`), `creadoEn?`, `enviadoEn?`, `decididoEn?`, `expiraEn?`, `puedeReintentar` | Inmutable; el motivo solo existe en `noVerificada` o en `sinVerificar` con `fotos_borradas` |
| `Consentimiento` | `aceptaBiometria`, `versionAviso` | Se envía al servidor; la fecha, el texto y el dispositivo los guarda el servidor y la app no los conserva |
| `Curp` | `valor` | Objeto de valor con la validación del patrón; vive en memoria y su `toString()` no imprime el valor |
| `FotoVerificacion` | `tipo` (`ine_frente`, `ine_reverso`, `selfie`; valores de backend 025 R-10), `bytes` | Vive en memoria; se borra al terminar la subida |
| `RevisionFoto` | `valida`, `codigo` (`vertical`, `muyPequena`, `muyOscura`, `reflejo`, `borrosa`, `ilegible`) | Reglas puras de R-04 |
| `Subida` | `tipo`, `urlSubida`, `venceEn` | Solo la entrega el servidor en la creación; no se guarda |

**Estado local**
- **Sin** almacenamiento de fotos, de motivos ni de datos del INE: el flujo vive en memoria y se descarta al salir.
- **Sin** caché de `GET /me/verificacion`: el estado es personal y se consulta cada vez; la pantalla muestra el estado de carga mientras responde.
- La captura en curso (`en_captura`) la guarda el servidor; el teléfono no guarda ni la CURP ni los enlaces.
- La etiqueta del dispositivo es solo «Android» o «iOS» (nunca el nombre del teléfono), como en la sesión (KNOCK-228).

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Fuga de información:** las fotos del INE en la galería, la caché, un registro, los metadatos EXIF o una copia de seguridad | Se leen en memoria, se re-codifican sin EXIF, se suben y se borran; no se guardan ni se cachean | CA-16, CA-18 |
| **Fuga de información:** la copia temporal que dejó la cámara en el teléfono | Se borra al terminar la subida, al abandonar el flujo y al cerrar sesión | CA-19 |
| **Fuga de información:** el motivo del rechazo o las fotos en la vista pública | Solo el técnico ve el motivo y los consejos; la vista pública muestra «Verificado» o «Sin verificar» | CA-13 |
| **Fuga de información:** el motivo o los datos del INE en un aviso push | La carga del aviso lleva tipo y destino; la pantalla consulta el estado | CA-12 |
| **Consentimiento inválido:** capturar o subir sin consentimiento | La casilla propia y sin marcar bloquea la cámara y la llamada; el repositorio lanza `AvisoNoAceptadoFailure` antes de llamar y el servidor rechaza con 422 | CA-01, CA-02, CA-17 |
| **Alteración:** subir una foto de la galería o un documento ajeno | Solo la cámara del sistema; sin selector de archivos | CA-03 |
| **Alteración:** dos verificaciones a la vez | El servidor responde 409 con `code` propio si ya hay una En revisión; la app no insiste, no reintenta sola y el servidor mantiene una sola captura viva | CA-05, CA-20 |
| **Suplantación:** usar el flujo sin sesión o para otra cuenta | El router exige sesión y rol de técnico; el servidor autoriza por token | CA-02, CA-13 |
| **Fuga de información:** la CURP en el teléfono, en registros o en reportes | Vive solo en memoria en un objeto que no se imprime; se vacía al recibir la respuesta | CA-23 |
| **Enumeración:** probar CURP de otras cuentas | El hash con clave es del servidor; la app solo muestra «contacta a soporte» y no revela la otra cuenta | CA-07 |
| **Denegación:** enlaces de subida vencidos o reutilizados | Vigencia de 5 minutos, renovación y un enlace por foto | CA-06 |
| **Denegación:** martillear la API tras un 429 | `ClienteConEspera` obedece `Retry-After` y la pantalla no reintenta sola | CA-15 |
| **Denegación:** decodificar un archivo enorme o de otro tipo y agotar la memoria del teléfono | El tipo y el tamaño se validan antes de decodificar (JPEG o PNG, máximo 8 MB) | CA-21 |
| **Captura de pantalla:** una foto del INE visible en la vista de tareas recientes | Se documenta como riesgo aceptado (D-06): no se usa `FLAG_SECURE`; las fotos viven en memoria y el flujo se cierra al salir | (decisión D-06; revisión en el PR) |
| **Dependencias:** cámara o procesamiento de imágenes vulnerable o con licencia no permitida | `image_picker` e `image` se evalúan en la spec 015 y se registran en `Memoria.md`; esta spec no agrega otras | (comando) `flutter pub outdated` + revisión en el PR |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos nuevos (ARB `verificacion*`, `consentimiento*`, `foto*`) |
|---|---|---|---|
| Verificación, estado (`/trabajo/verificacion`, fuera de la barra inferior) | carga, sin verificar, en revisión, verificado, no verificado, fotos borradas, error, sin conexión | Insignia o estado, explicación, fecha, motivo y consejos si lo rechazaron, «Intentar de nuevo», «Subir a completa», aviso de las fotos borradas | `verificacionTitulo`, `verificacionSinVerificar`, `verificacionSinVerificarDetalle`, `verificacionEnRevision`, `verificacionEnRevisionDetalle`, `verificacionVerificadoBasico`, `verificacionVerificadoCompleto`, `verificacionNoVerificado`, `verificacionMotivo`, `verificacionConsejos`, `verificacionIntentarDeNuevo`, `verificacionSubirNivel`, `verificacionFotosBorradas`, `verificacionInsignia`, `verificacionError`, `verificacionSinConexion` |
| Consentimiento (`/trabajo/verificacion/enviar`, paso 1) | vacío, error de validación | Explicación en lenguaje simple, vista previa del aviso de privacidad, casilla propia sin marcar y «Continuar» | `consentimientoTitulo`, `consentimientoDetalle`, `consentimientoAviso`, `consentimientoVerAviso`, `consentimientoCasilla`, `consentimientoFalta`, `consentimientoContinuar` |
| Captura (paso 2) | vacío, foto rechazada, con foto | Instrucciones por foto (frente, reverso, selfie), botón de cámara, vista previa, «Repetir» y el motivo del rechazo | `fotoIneFrente`, `fotoIneReverso`, `fotoSelfie`, `fotoInstruccionIne`, `fotoInstruccionSelfie`, `fotoTomar`, `fotoRepetir`, `fotoVertical`, `fotoMuyPequena`, `fotoMuyOscura`, `fotoReflejo`, `fotoBorrosa`, `fotoIlegible`, `fotoSinCamara` |
| Revisión y envío (paso 3) | carga, error, sin conexión, enlace vencido | Tres miniaturas, «Enviar», avance de la subida y el resultado | `verificacionRevisar`, `verificacionEnviar`, `verificacionSubiendo`, `verificacionEnlaceVencido`, `verificacionEnRevisionAviso` |
| Común | — | Errores del catálogo y botón de reintentar | Reutiliza `errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos` y `errorNoEncontrado` (spec 015); agrega `verificacionErrorEnRevision`, `verificacionErrorSoporte` |

**Mensajes exactos** (español; el inglés va en `app_en.arb`)

| Situación | Texto en pantalla |
|---|---|
| Sin consentimiento | «Para tomar las fotos necesitamos tu permiso. Marca la casilla para continuar.» |
| `consent_required` (422) | «Necesitamos que aceptes el aviso vigente» |
| CURP inválida (local o `curp_invalid`) | «Revisa tu CURP: son 18 caracteres» |
| `curp_duplicate` (409) | «No pudimos continuar con esta CURP. Escríbenos a soporte para revisarlo.» |
| `verification_under_review` (409) | «Ya tienes una verificación en revisión» |
| `already_verified` (409) | «Ya tienes esta verificación» |
| `already_fully_verified` (409) | «Ya tienes la verificación completa» |
| `capture_expired` (409) o enlace vencido | «Tu captura venció. Vuelve a tomar las fotos.» |
| `content_invalid` (422) | «Esa foto no se pudo usar. Tómala de nuevo.» |
| `photos_missing` (409) | «Falta una foto. Tómala para enviar.» |
| `deletion_scheduled` (409) | «Tu cuenta está por eliminarse; no puedes verificarla ahora.» |
| En revisión | «Revisamos en menos de 24 h» |
| `motivo = fotos_borradas` | «Tus fotos se borraron porque no se revisaron a tiempo. Puedes enviarlas de nuevo.» |
| 429 | «Hiciste muchos intentos. Espera {segundos} segundos.» |
| Sin conexión | «Sin conexión. Intenta de nuevo cuando tengas señal.» |
| 5xx | «Algo salió mal de nuestro lado. Intenta de nuevo.» |

Reglas de pantalla:
- La casilla del consentimiento nunca viene marcada y el botón «Continuar» está deshabilitado hasta marcarla.
- La vista previa del aviso de privacidad abre el texto completo en la landing con el navegador del teléfono, en una URL fija con `https://` y sin parámetros; si no hay navegador, se muestra el resumen local.
- La cámara se abre solo con `ImageSource.camera`; no hay botón ni opción de galería, y una prueba lo comprueba.
- Cada foto se revisa al tomarla; si se rechaza, se explica y se queda en la misma foto, sin borrar las anteriores.
- El flujo se puede abandonar en cualquier paso; al salir se borran las fotos en memoria, la copia temporal y el servidor descarta el borrador a los 30 minutos.
- La pantalla de estado se refresca al abrirla y al volver a la app (`AppLifecycleState.resumed`), no por sondeo continuo.
- Accesibilidad: las miniaturas se anuncian («INE frente, lista»), el aviso de privacidad es texto seleccionable y los pasos no dependen solo del color.

## 8. Pruebas, gates y límites

**Plan de pruebas** (Sí/No con motivo; meta de mutación del módulo: 70 % en `domain/`)

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Revisión de calidad de la foto, máquina de estados, consentimiento y mapeo del contrato |
| Widget (W) | Sí | Consentimiento, captura, revisión, envío y los cuatro estados de la verificación |
| Aceptación (ACC) | Sí | CA-01 a CA-25 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` y `flutter test test/api/cliente_generado_test.dart` (spec 006) |
| Integración (INT) | Sí | Flujo completo con API y cámara simuladas en `integration_test/` y humo contra el entorno desplegado con imágenes sintéticas |
| Seguridad negativa (NEG) | Sí | Sin consentimiento (`AvisoNoAceptadoFailure` y 422), 409 en revisión, enlace vencido, CURP duplicada, 429, foto de más de 8 MB o de otro tipo, fotos fuera de galería, caché y registros, y copia temporal borrada al abandonar |
| Accesibilidad (A11Y) | Sí | `expectAccesible` de la spec 008, lector de pantalla y texto al 200 % |
| Mutación (MUT) | Sí | Reglas de `domain/` con `mutation_test`, meta 70 % |
| E2E | Sí | Un recorrido: consentimiento → tres fotos → en revisión → estado aprobado |
| Regresión | Sí | `flutter test` completo; no se rompen Inicio, Explorar, Oficios, Entrada, Cuenta ni Trabajo |
| Análisis estático y vulnerabilidades | Sí | `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed`, Semgrep y CodeQL del CI, `flutter pub outdated` y OSV |
| Rendimiento (PERF) | No | Volumen bajo del piloto; la revisión de la foto se mide en la prueba unitaria |
| Datos de prueba | Sí | **Solo imágenes sintéticas** (INE de ejemplo generado y selfie ficticia); nunca un documento real (HU-021 §8) |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Consentimiento, INE frente y selfie → En revisión |
| Positivo | Nivel completo con el reverso → En revisión |
| Positivo | Aprobado básico → insignia y opción de subir a completa |
| Positivo | Rechazado → motivo, consejos y reintento |
| Negativo | Sin consentimiento no se abre la cámara ni se llama a la API |
| Negativo | Consentimiento vencido → 422 y se vuelve a pedir la aceptación |
| Negativo | Foto vertical, oscura, con reflejo o borrosa → rechazo local con mensaje |
| Negativo | Intento de abrir la galería → no existe esa opción |
| Negativo | Ya En revisión → 409 sin duplicar |
| Negativo | Enlace vencido → se renueva y no queda a medias |
| Negativo | CURP duplicada → «contacta a soporte» sin revelar la otra cuenta |
| Negativo | Reintento tras fallo de red → nueva creación, el servidor cancela la captura anterior y queda una sola |
| Negativo | Foto de 8 MB + 1 byte o de tipo distinto de JPEG/PNG → rechazo antes de decodificar |
| Error esperado | 401 → renueva una vez; si falla, cierra sesión y pide entrar |
| Error esperado | 429 → espera el `Retry-After` y lo dice |
| Error esperado | 5xx o tiempo agotado → estado de error con reintentar |
| Caso límite | 7 días sin revisión → fotos borradas y Sin verificar |
| Caso límite | Salir del flujo a media captura → nada queda en el teléfono |
| Caso límite | Cerrar sesión con fotos en memoria → se borran y la siguiente cuenta no las ve |
| Caso límite | Foto con EXIF → se sube sin metadatos |
| Caso límite | Sin cámara disponible (emulador sin cámara) → mensaje claro, sin bloqueo |
| Caso límite | Foto de exactamente 8 MB y de 8 MB + 1 byte |
| Caso límite | CURP de 17, 18 y 19 caracteres; CURP en minúsculas (se normaliza a mayúsculas) |
| Error esperado | 409 `curp_duplicate`, `verification_under_review`, `photos_missing` y 422 `content_invalid` → mensaje exacto de §7 |
| Caso límite | Cuarta creación en la misma hora → 429 y espera |

**Gates:** `flutter analyze --fatal-infos`, `dart format`, `flutter test` con cobertura ≥ 50 % (spec 008), revisión de la constitución, revisión de seguridad y PR con CI en verde (spec 007).
**Límites y dudas abiertas:** ver §13.

## 9. Arquitectura y componentes

Se respeta la arquitectura de la spec 001: `domain` en Dart puro, `presentation` sin `data/`, un archivo `<funcion>_providers.dart` como raíz de composición y el cliente generado como única puerta a la API (spec 006).

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/trabajo/domain/verificacion.dart` | Crear | `Verificacion`, `EstadoVerificacion`, `NivelVerificacion` y las reglas de la vista pública |
| `app/lib/features/trabajo/domain/consentimiento.dart` | Crear | `Consentimiento` y su validación |
| `app/lib/features/trabajo/domain/revision_foto.dart` | Crear | Reglas puras de calidad (R-04) y sus códigos |
| `app/lib/features/trabajo/domain/verificacion_repository.dart` | Crear | Interfaz: `crear`, `subir`, `confirmarFoto`, `enviar`, `obtener` |
| `app/lib/features/trabajo/domain/curp.dart` | Crear | `Curp` y su patrón (R-18) |
| `app/lib/features/trabajo/data/verificacion_mapper.dart` | Crear | Contrato → dominio, con validación de campos |
| `app/lib/features/trabajo/data/verificacion_repository_api.dart` | Crear | Implementación sobre el cliente generado y el transporte de la app |
| `app/lib/features/trabajo/data/foto_local_repository.dart` | Crear | Lectura de la cámara, validación de tipo y tamaño antes de decodificar, re-codificación sin EXIF, borrado de la copia temporal y `borrarTodas()` |
| `app/lib/features/trabajo/trabajo_providers.dart` | Modificar | Raíz de composición de la verificación; escucha el cierre de sesión y borra las fotos en memoria |
| `app/lib/features/trabajo/presentation/verificacion_screen.dart` | Crear | Estado de la verificación |
| `app/lib/features/trabajo/presentation/verificacion_controller.dart` | Crear | Carga, envío, errores y refresco |
| `app/lib/features/trabajo/presentation/enviar_verificacion_screen.dart` | Crear | Los tres pasos del envío |
| `app/lib/features/trabajo/presentation/consentimiento_controller.dart` | Crear | Casilla, versión y bloqueo de la cámara |
| `app/lib/features/trabajo/presentation/widgets/paso_consentimiento.dart` | Crear | Explicación, aviso y casilla |
| `app/lib/features/trabajo/presentation/widgets/captura_foto.dart` | Crear | Cámara, vista previa y «Repetir» |
| `app/lib/features/trabajo/presentation/trabajo_screen.dart` | Modificar | Aviso de verificación con acceso a la pantalla |
| `app/lib/core/router/rutas.dart` | Modificar | `verificacion` y `verificacionEnviar` |
| `app/lib/core/router/app_router.dart` | Modificar | Rama de Trabajo (rol de técnico) |
| `app/lib/core/errores/failure.dart` | Modificar | `VerificacionEnRevisionFailure`, `CapturaVencidaFailure`, `CurpDuplicadaFailure`, `CurpInvalidaFailure` y `YaVerificadoCompletoFailure`; reutiliza `AvisoNoAceptadoFailure` de la spec 009 |
| `app/lib/core/red/errores_api.dart` | Modificar | 409 y 422 con `code` de verificación (§4) |
| `app/lib/core/errores/mensaje_failure.dart` | Modificar | Traducción de los errores nuevos |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 en ambos idiomas |
| `app/pubspec.yaml` | Sin cambios propios | `image_picker` e `image` vienen de la spec 015; `url_launcher`, de la 016 |

**No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/` y las specs aprobadas.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| Backend 025 (otro repositorio) | Rutas, esquemas, cifrado, llave, OCR, hash de la CURP y borrado a 7 días; además, los encabezados del `PUT` al SAS (`x-ms-blob-type: BlockBlob`, `Content-Type`), que hoy no devuelve | Sin contrato vendorizado no se implementa la capa `data`; sin los encabezados, Azure responde 400 y ninguna foto llega |
| 006 Contrato y cliente generado | Cliente Dart y verificación en CI | No hay forma permitida de llamar a la API |
| 002 Piezas comunes | Sesión, renovación, `Failure` y mensajes | Sin token ni manejo de errores común |
| 009 Seguridad del cliente | Almacenamiento seguro, espera por 429 y reglas de privacidad | Se incumpliría el manejo de datos sensibles |
| 010 Caché y sin conexión | Política de caché | Se cachearían datos personales que no deben guardarse |
| 012 Notificaciones y permisos | Aviso push al cambiar de estado y su apertura | El técnico no sabría del cambio sin abrir la app |
| 015 Pedir y comparar cotizaciones | `image_picker` e `image` evaluadas | Habría que evaluarlas aquí antes de usarlas |
| 016 Visita con código | `url_launcher` para abrir el aviso de privacidad | Se mostraría solo el resumen local |
| 008 Calidad y pruebas | Reglas del analizador, accesibilidad y cobertura | Los gates no existirían |
| 014 Alinear la UI con la maqueta (reservada) | Tokens, tipografía y contraste | La comparación visual queda pendiente |

## 11. Definición de terminado

- CA-01 a CA-25 con prueba que falla si la lógica está mal; `python scripts/sdd_lint.py --trace 018` sin `FALTA`.
- `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 %.
- Los ARB de español e inglés completos y la prueba de traducciones en verde; ningún texto escrito en la pantalla.
- El contrato vendorizado incluye las rutas de §4 y el cliente generado compila; el manifiesto del cliente coincide (spec 006).
- Recorrido real contra el entorno desplegado con **imágenes sintéticas**: consentimiento, tres fotos, En revisión y estado aprobado, con capturas en el PR.
- Pruebas de accesibilidad y de seguridad negativa en verde; comprobado que las fotos no quedan en la galería, en la caché ni en registros.
- `Memoria.md` con las decisiones, las dependencias y lo que quedó pendiente.
- PR con la plantilla completa, la etiqueta `puntos-app-N` y CI en verde.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | La función vive en `features/trabajo/` y sus rutas cuelgan de `/trabajo/verificacion` | La verificación es del técnico y la pestaña Trabajo ya existe con el `redirect` por rol de la spec 001 | Crear `features/verificacion/`, que rompe la lista de cinco funciones |
| D-02 | El consentimiento se muestra siempre con la casilla sin marcar, también al reintentar o subir de nivel | HU-021 CA1 exige una casilla propia y sin marcar; repetirla es más seguro que reutilizar una aceptación vieja | Reutilizar el consentimiento anterior sin mostrarlo |
| D-03 | El flujo sigue las cuatro rutas de backend 025: crear, subir y confirmar cada foto, y enviar | Backend 025 fijó la confirmación por foto y el envío explícito | Pasar a En revisión al subir la última foto |
| D-04 | La revisión de calidad se hace en el teléfono con umbrales documentados (orientación, 640 × 480, brillo, reflejo y nitidez) y el servidor es el juez final | HU-021 CA3 lo pide en el dispositivo y así se evita subir fotos que se van a rechazar | Subir todo y dejar que el servidor rechace, que gasta datos y sube documentos inservibles |
| D-05 | Solo se usa la cámara del sistema; no hay selector de galería y no se declara el permiso `CAMERA` | Evita subir capturas o fotos de otro documento; el intento de cámara del sistema no necesita el permiso | Galería habilitada, que abre la puerta a documentos ajenos |
| D-06 | Las fotos viven en memoria, la copia temporal se borra y no se usa `FLAG_SECURE` | No dejar rastro en el teléfono es más fuerte que bloquear capturas; `FLAG_SECURE` complica el soporte y la demo | Guardar las fotos en el directorio privado y usar `FLAG_SECURE` |
| D-07 | Se reutilizan `image_picker` e `image` (spec 015) y `url_launcher` (spec 016); esta spec no agrega dependencias | Evita evaluar y duplicar paquetes que ya propone el mismo sprint | Un paquete de cámara propio, que duplica trabajo y riesgo |
| D-08 | El motivo y los consejos solo se muestran al técnico; la vista pública solo dice «Verificado» o «Sin verificar» | HU-022 §8 lo exige y el cliente no debe ver datos de la revisión | Mostrar el motivo en el perfil público |
| D-09 | El borrado a 7 días lo decide el servidor y la app solo muestra el `motivo = fotos_borradas` | El teléfono no puede saber si las fotos siguen en el servidor | Un temporizador local que podría mentir |
| D-10 | La pantalla de estado es la única que consulta la verificación; la pestaña Trabajo solo muestra un aviso con acceso | Evita consultas repetidas y un estado duplicado | Consultar en cada pestaña y en el perfil |
| D-11 | La creación no envía `Idempotency-Key` | Backend 025 no la lee y ya garantiza una sola captura viva por persona | Mandarla sin efecto |
| D-12 | El tipo y el tamaño se validan antes de decodificar la imagen | Un archivo enorme o de otro tipo agota la memoria del teléfono antes de que la revisión de calidad lo rechace | Decodificar primero y validar después, que gasta memoria y tiempo |
| D-13 | Las fotos y la copia temporal se borran al abandonar el flujo y al cerrar sesión, con un gancho en `trabajo_providers.dart` | La sesión de la spec 002 no conoce la verificación; escuchar el cambio de sesión evita tocar el cierre de sesión de otra spec | Un método nuevo en `core/sesion/` que duplique el cierre de sesión |
| D-14 | El consentimiento se envía con `aceptaBiometria` y `versionAviso`; la fecha, el texto y el dispositivo los pone el servidor | Evita que un teléfono con la hora mal ponga una fecha falsa en un consentimiento biométrico | Mandar `aceptadoEn` desde el teléfono |
| D-15 | La CURP se pide en la app, en el paso del consentimiento, y vive solo en memoria | Backend 025 la exige en la creación para detectar cuentas duplicadas | Pedirla después o leerla del INE en el teléfono (OCR local) |

## 13. Riesgos y dudas abiertas

- **Bloqueante:** las rutas de §4 no están en `contracts/openapi.v1.json`; hasta que backend 025 las publique y se vendorice, la capa `data` no se puede implementar ni probar contra el contrato.
- **Resuelto en la revisión:** backend 025 fija `GET /api/v1/me/verificacion`; la ficha de HU-022 (`/tecnicos/me/verificacion`) queda desactualizada.
- **Resuelto en la revisión cruzada (decisión automática, revisar):** los valores de `tipo` de foto son `ine_frente`, `ine_reverso` y `selfie` (backend 025 R-10).
- **Bloqueante (coordinar con backend 025):** subir con `PUT` a un SAS de Azure Blob exige `x-ms-blob-type: BlockBlob` (y conviene `Content-Type`); backend 025 R-08 devuelve solo `{ tipo, urlSubida, venceEn }`, a diferencia de la spec 032, que sí devuelve `encabezados`. Opciones: que backend 025 devuelva `encabezados` o fijar aquí los que manda la app, con una prueba de contrato. **Propuesta por defecto:** que backend 025 devuelva `encabezados` como la spec 032 y la app los envíe tal cual. Hasta resolverlo no se implementa la subida.
- **Duda abierta (CA-03 y estimación):** la revisión de calidad en el teléfono (borrosa, oscura, con reflejo) se puede hacer con el paquete `image`, pero la spec no fija los umbrales ni el criterio de «INE en vertical» (¿proporción del recuadro u orientación EXIF?). Hace falta fijar los tres umbrales (varianza del laplaciano, brillo medio, porcentaje de píxeles saturados) y el criterio de orientación, con imágenes sintéticas de prueba, antes de aprobar; sin eso CA-03 no tiene un resultado esperable que se pueda comprobar y la estimación de 5 puntos queda en duda. **Propuesta por defecto (valores iniciales, a calibrar con las imágenes sintéticas):** varianza del laplaciano de 100 como mínimo, brillo medio entre 40 y 220, no más de 5 % de píxeles saturados y «INE en vertical» por la proporción del recuadro y no por la orientación EXIF.
- **Duda abierta (entre specs):** CA-12 dice que el aviso del cambio de estado de la verificación lo define la spec 024, pero esa spec lista 8 eventos y ninguno es de verificación (backend 025 emite `VerificacionDecidida` «para el aviso»). O la spec 024 agrega un evento de verificación (técnico → `/trabajo/verificacion`) o se quita CA-12 de esta spec. **Propuesta por defecto:** la spec 024 agrega ese evento (`verificacion_decidida`), alineado con `VerificacionDecidida` de backend 025.
- **Riesgo:** los umbrales de calidad (brillo, reflejo, nitidez) pueden rechazar fotos válidas con cámaras malas; se ajustan con imágenes sintéticas y se documentan en el código.
- **Riesgo:** sin `FLAG_SECURE`, una captura de pantalla con el INE puede quedar en la galería del técnico; las fotos no se guardan en la app y el flujo se cierra al salir (D-06).
- **Riesgo:** la app no puede comprobar el OCR ni el hash de la CURP; todo lo que muestra viene del servidor.
- **Riesgo:** la re-codificación sin EXIF puede bajar la calidad de la foto y afectar el OCR del servidor; los parámetros se ajustan con imágenes sintéticas y se documentan en el código.
- **Riesgo:** la versión del aviso de privacidad se fija en la app; si el texto cambia y la versión no sube, el consentimiento guardado apuntaría al texto equivocado. Dueño de la versión: quien publique el aviso; se revisa en cada PR que toque ese texto.
- **Duda abierta (para José):** ¿la versión del aviso la entrega el servidor en `GET /me/verificacion` o la fija la app? **Propuesta por defecto:** la fija la app (D-14), porque `GET /me/verificacion` no trae ese campo; si se prefiere que la entregue el servidor, backend 025 debe agregarlo antes de implementar.
- **Duda abierta (para José):** ¿el aviso de privacidad completo se abre en la landing o se embebe en la app? **Propuesta por defecto:** se abre en el navegador, con el mismo mecanismo de la spec 028, y se deja un resumen local.
- **Resuelto en la revisión:** sin verificación previa el servidor responde `200` con `estado = sin_verificar` y `puedeReintentar = true` (backend 025 R-14).
- **Riesgo:** pedir la CURP en la app agrega un dato personal sensible al flujo; se mitiga con R-18 y CA-23. Si el equipo prefiere no pedirla, backend 025 debe cambiar primero. **Propuesta por defecto:** pedirla como define backend 025.
- **Duda abierta (para el equipo):** ¿la verificación se ofrece al enviar la primera cotización, al empezar un trabajo o al ponerse disponible, como dice HU-021? Esos avisos dependen de pantallas que no existen en este sprint; esta spec solo la ofrece desde Trabajo y desde Mi negocio cuando exista.

## Aprobación

- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
