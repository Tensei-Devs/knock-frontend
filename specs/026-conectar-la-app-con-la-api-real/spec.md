# Spec 026 — Conectar la app con los endpoints reales (perfil, sesión y colonias)

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Jira:** KNOCK-243 (por verificar) · **Capas:** Mobile · **Otra parte en:** knock-backend (specs 015 a 018, ya desplegadas; la 037 queda fuera)
> **Relacionada con:** specs 002, 006, 009, 010 y 012 de este repositorio; KNOCK-228 y KNOCK-229 en `Memoria.md`.

## 1. Objetivo
La demo debe consumir todos los endpoints que el backend ya tiene desplegados. Hoy la app usa la API real en el canje de sesión (`POST /auth/firebase`), en `GET /oficios` y en `GET /colonias/en-punto`, pero:

- el perfil (`GET` y `PUT /me`) y el cierre de sesión (`POST /auth/logout`) siguen **simulados** en memoria (`PerfilRepositorySimulado`);
- `GET /colonias/en-punto` se llama **sin token** y la API responde 401;
- ninguna petición lleva el token: el canje guarda los tokens en el almacenamiento seguro (`AlmacenSesion`), pero el transporte (`ClienteAutenticado`) lee de otro almacén en memoria (`AlmacenTokensEnMemoria`) que nadie llena;
- la renovación (`POST /auth/refresh`) no está conectada (`RenovadorNoDisponible`);
- cerrar sesión no vuelve al login: `sesionIniciadaProvider` nunca pasa a falso;
- no hay capa de datos para las sesiones por dispositivo (`/me/sesiones`).

Esta spec conecta todo eso sin cambiar pantallas, rutas ni diseño. El registro real de dispositivos y las notificaciones push dependen de la spec 037 del backend y quedan para otra spec.

## 2. Alcance
**Dentro**
- Repositorio de perfil real contra `GET` y `PUT /api/v1/me`, con `ETag` y 304.
- Cierre de sesión real (`POST /api/v1/auth/logout`) con borrado local y regreso al login.
- Bearer en todas las llamadas protegidas, incluida `colonias/en-punto`, tomado del almacenamiento seguro.
- Renovación con `POST /api/v1/auth/refresh` ante 401 (una sola a la vez, un reintento por petición).
- Mapeo de errores a los mensajes de usuario que ya existen.
- Capa de datos y proveedor de `GET /me/sesiones` y `DELETE /me/sesiones/{id}`, sin pantalla.
- Reglas de composición: simulado solo en pruebas y sin `KNOCK_API_URL`; una compilación de tienda sin URL válida falla de forma explícita.

**Fuera**
- Pantallas nuevas (la de sesiones y dispositivos, foto de perfil, selector de colonia o código postal): otra spec.
- El registro real de dispositivos y las notificaciones push (spec 037 del backend); `alIniciarSesion` y `alCerrarSesion` de la spec 012 no cambian.
- Cualquier cambio de diseño, de rutas, de textos ARB o de dependencias.
- Cambios a `contracts/`, `app/packages/knock_api` y `.github/` (archivos protegidos; ver D-01).
- Cerrar todas las sesiones a la vez (no existe en el backend).

## 3. Requisitos
- **R-01:** `PerfilRepository` tiene una implementación real que usa `GET /api/v1/me` y `PUT /api/v1/me` con el token de la sesión. La lectura manda `If-None-Match` con el `ETag` guardado y, ante un 304, entrega el perfil ya guardado.
- **R-02:** `PUT /me` manda `nombre` y conserva `fotoUrl`, `colonia` y `codigoPostal` del último perfil leído, porque el backend borra los opcionales que se omiten.
- **R-03:** Cerrar sesión llama a `POST /api/v1/auth/logout` con el token de acceso. Pase lo que pase con la red (sin conexión, 401, 5xx), los tokens, la caché y el estado de sesión se borran en el teléfono y la app vuelve al login.
- **R-04:** El cliente HTTP agrega `Authorization: Bearer` a toda llamada protegida (`/me`, `/me/sesiones`, `/auth/logout`, `/colonias/en-punto`) y no lo agrega a las públicas (`/auth/firebase`, `/auth/refresh`, `/oficios`).
- **R-05:** Los tokens que usa el transporte salen del almacenamiento seguro: al arrancar se leen, al canjear se registran en la sesión y al renovar se guardan antes de repetir la petición. Hay un solo almacén de tokens activo.
- **R-06:** Ante un 401 de una llamada protegida, la app renueva con `POST /api/v1/auth/refresh`. Varias peticiones con 401 a la vez comparten **una sola** renovación (single-flight). Cada petición se reintenta **una sola vez** con el token nuevo.
- **R-07:** Si la API rechaza la renovación (400 o 401), o la petición reintentada vuelve a dar 401, la sesión se cierra (como en R-03, sin llamar a logout) y la app vuelve al login. Si la renovación falla por red, 429 o 5xx, la sesión **no** se cierra y la persona ve el error de conexión.
- **R-08:** Los errores de estas llamadas llegan a la interfaz como `Failure` y se muestran con los mensajes que ya existen: 400, 413 y 422 con `errorDatosRechazados`; 401 con `errorSesionVencida`; 409 con `errorConflicto`; 429 con `errorDemasiadosIntentos` y el `Retry-After`; 503 y sin red con `errorSinConexion`.
- **R-09:** Existe la lista de sesiones (`GET /me/sesiones`) y el cierre de una sesión (`DELETE /me/sesiones/{id}`) como repositorio en `features/cuenta` con su proveedor, sin pantalla.
- **R-10:** `PerfilRepositorySimulado` y `ColoniasRepositorySimulado` se conservan solo para pruebas y para la compilación **sin** `KNOCK_API_URL` en modo de desarrollo. Una compilación de tienda (modo `release`) sin URL válida falla de forma explícita al arrancar y no cae al simulado.
- **R-11:** Los tokens viven solo en el almacenamiento seguro y en memoria durante la sesión. Nunca se escriben en registros, en `toString`, en mensajes de error, en la caché ni en preferencias.
- **R-12:** Sin cambios de diseño, de rutas ni de dependencias nuevas.
- **R-13:** Las escrituras no se reintentan solas: `PUT /me` se repite únicamente tras un 401 con renovación exitosa (el servidor no lo procesó) y nunca tras un error de red o 5xx.

## 4. Criterios de aceptación
- **CA-01:** Dada una sesión con token, cuando se pide el perfil, entonces la app hace `GET /me` con `Authorization: Bearer` y entrega el `Perfil` con nombre, foto, colonia, código postal y `perfilCompleto` del servidor.
- **CA-02:** Dado un perfil ya leído con `ETag`, cuando se vuelve a pedir y el servidor responde 304, entonces la app manda `If-None-Match` y entrega el mismo perfil sin error.
- **CA-03:** Dado un perfil leído con colonia y código postal, cuando se guarda un nombre nuevo, entonces el `PUT /me` incluye `nombre`, `fotoUrl`, `colonia` y `codigoPostal` anteriores y el perfil devuelto reemplaza al guardado.
- **CA-04:** Dado un `PUT /me` rechazado con 400, 413, 422 (colonia inválida), 409 o 503, cuando la app lo recibe, entonces falla con el `Failure` de R-08 y el perfil que se muestra no cambia.
- **CA-05:** Dado que no hay sesión, cuando se pide el perfil, entonces no sale ninguna petición y falla con `NoAutorizadoFailure`.
- **CA-06:** Dada una sesión abierta, cuando se confirma «Cerrar sesión» y el servidor responde 204, entonces se hizo un `POST /auth/logout` con Bearer, el almacenamiento seguro queda sin tokens, la caché queda vacía y el router lleva a `/entrar`.
- **CA-07:** Dado un cierre de sesión cuando no hay red o el servidor responde 401 o 5xx, entonces igual se borran tokens y caché, se vuelve al login y no se muestra error.
- **CA-08:** Dado un cierre de sesión que recibe 401, cuando termina, entonces no se intentó renovar ni repetir el `logout` (una sola petición).
- **CA-09:** Dada una sesión, cuando se consulta `colonias/en-punto`, entonces la petición lleva `Authorization: Bearer` y la colonia se muestra en «Tu zona».
- **CA-10:** Dada una app que arranca con tokens guardados, cuando hace su primera llamada protegida, entonces lleva el Bearer del almacenamiento seguro.
- **CA-11:** Dadas las llamadas a `/auth/firebase`, `/auth/refresh` y `/oficios`, cuando salen, entonces no llevan `Authorization`.
- **CA-12:** Dada una persona que acaba de canjear su código SMS, cuando hace su primera llamada protegida, entonces lleva el token del canje sin reiniciar la app.
- **CA-13:** Dada una llamada protegida que recibe 401 y una renovación exitosa, cuando termina, entonces los tokens nuevos ya estaban en el almacenamiento seguro **antes** del reintento, la petición se repite una vez con el token nuevo y se entrega su resultado.
- **CA-14:** Dadas cinco llamadas simultáneas que reciben 401, cuando se renueva, entonces el servidor recibe **un** `POST /auth/refresh` y las cinco se repiten con el mismo token nuevo.
- **CA-15:** Dada una petición reintentada que vuelve a dar 401 tras renovar, cuando termina, entonces no hay una segunda renovación, la sesión se cierra y se vuelve al login.
- **CA-16:** Dado un `POST /auth/refresh` que responde 400 o 401, cuando la app lo recibe, entonces los tokens se borran, la caché se vacía, se vuelve al login y el token vencido no se vuelve a enviar.
- **CA-17:** Dado un `POST /auth/refresh` que falla por falta de red, 429 o 5xx, cuando la app lo recibe, entonces la sesión sigue abierta, los tokens no cambian y la pantalla muestra el mensaje de conexión o de espera.
- **CA-18:** Dado cada código de error de R-08 (400, 401, 409, 413, 422, 429 con `Retry-After: 30`, 503 y sin red), cuando llega, entonces el mensaje en español es el esperado y no contiene URL, cuerpo ni token.
- **CA-19:** Dado un error al cargar el perfil o al guardar el nombre, cuando se dibuja «Mi cuenta» o «Completar perfil», entonces se ve el mensaje del error, el botón de reintentar funciona y el estado de cada pantalla sigue siendo uno de cargando, datos, vacío o error.
- **CA-20:** Dada una sesión, cuando se pide la lista de sesiones, entonces se hace `GET /me/sesiones` con Bearer y se obtiene una lista de `SesionDispositivo` (`id`, `dispositivo`, `ultimaActividad`, `actual`) en el orden del servidor.
- **CA-21:** Dado el cierre de otra sesión, cuando el servidor responde 204 entonces termina bien; con 404 se trata como ya cerrada; con 409 (es la sesión actual) falla con `ConflictoFailure`; con 401 sigue el flujo de renovación.
- **CA-22:** Dada una compilación de tienda sin `KNOCK_API_URL` válida, cuando arranca, entonces falla con `ApiNoConfiguradaFailure` antes de mostrar pantallas y no usa ningún repositorio simulado.
- **CA-23:** Dada una compilación de desarrollo sin `KNOCK_API_URL`, cuando arranca, entonces usa los repositorios simulados y la app se puede recorrer; con una URL válida usa los reales.
- **CA-24:** Dado cualquier flujo de las llamadas anteriores, cuando se capturan los registros, el `toString` de los errores y los mensajes de la interfaz, entonces no aparece ni el token de acceso ni el de renovación.
- **CA-25:** Dado un `PUT /me` que falla por red o 5xx, cuando termina, entonces se hizo una sola petición (no se reintentó sola).
- **CA-26:** Dada una sesión cerrada o vencida, cuando se revisan el almacenamiento seguro, las preferencias y la caché, entonces no queda ningún token ni dato del perfil anterior.
- **CA-27:** Dado un servidor falso de la API, cuando se recorre entrar, leer perfil, guardar nombre, 401 con renovación, consultar colonia y cerrar sesión, entonces el flujo termina en el login con las llamadas esperadas en orden.
- **CA-28:** Dados el login, los oficios y la colonia, cuando se corren sus pruebas existentes, entonces siguen en verde, y `flutter analyze` no reporta nada.
- **CA-29:** Dado el backend desplegado, cuando una persona del equipo recorre la demo con un teléfono real, entonces el perfil, el cierre de sesión, la colonia y la lista de sesiones funcionan (humo manual, evidencia en el PR).

## 5. Contrato consumido
Versión de la API: `v1`. La URL base llega por `--dart-define=KNOCK_API_URL` (gateway de producción), nunca fija en el código. Fuente: specs 015 a 018 del backend.

| Endpoint | Auth | Cuerpo / consulta | Respuestas | Notas para la app |
|---|---|---|---|---|
| `POST /auth/firebase` | No | `{firebaseIdToken, deviceId, aceptaAviso, dispositivo}` | 200, 201, 400, 401, 403, 409, 422, 429 | Ya conectado; no cambia (cliente generado). |
| `POST /auth/refresh` | No | `{refreshToken}` | 200 `{accessToken, expiresIn, refreshToken}`, 400, 401, 429 | Rota el token: el anterior ya no sirve. Reusarlo cierra todas las sesiones de la cuenta. `Cache-Control: no-store`. |
| `POST /auth/logout` | Sí | Sin cuerpo | 204, 401 | Revoca la sesión del token. Sin reintentos. |
| `GET /me` | Sí | — | 200 `{id, nombre, fotoUrl, colonia, codigoPostal, esTecnico, estado, perfilCompleto, creadoEn}`, 304, 401 | `ETag` débil, `Cache-Control: private, no-cache`. Nunca trae el celular. |
| `PUT /me` | Sí | `{nombre, fotoUrl?, colonia?, codigoPostal?}` | 200 (perfil), 400, 401, 409, 413, 422, 429, 503 | Los opcionales omitidos se borran. 409 si la cuenta está en eliminación programada. 422 colonia inexistente. 503 si Mercado no responde. |
| `GET /me/sesiones` | Sí | — | 200 `[{id, dispositivo, ultimaActividad, actual}]`, 401 | Sin paginación (máximo 10). `Cache-Control: private, no-store`. |
| `DELETE /me/sesiones/{id}` | Sí | — | 204, 400, 401, 404, 409 | 404 también para sesión ajena. 409 si es la sesión actual. |
| `GET /colonias/en-punto` | Sí | `lat`, `lon` | 200, 400, 401, 429 | Hoy se llama sin token. |
| `GET /oficios` | No | — | 200, 304 | Ya conectado con caché y `ETag` (spec 010); no cambia. |

**Cliente.** El contrato vendorizado en `contracts/openapi.v1.json` y `knock_api` solo incluyen `POST /auth/firebase` (Memoria, 2026-11-05) y están protegidos. Mientras no se vendorice el contrato nuevo, las llamadas de esta tabla que no están en el cliente generado se hacen con el mismo patrón de `core/red/obtener_json.dart` (transporte común, `mapearErrorApi`, sin cuerpos de respuesta en los errores), concentradas en `core/red/` y `features/*/data/`. Ver D-01.

## 6. Modelo de datos local
Todo es de dominio o de memoria; no se agrega base de datos.

| Entidad / estado | Campos | Dónde vive |
|---|---|---|
| `Perfil` (se amplía) | `nombre`, `fotoUrl?`, `colonia?`, `codigoPostal?`, `esTecnico`, `estado`, `perfilCompleto`; `completo` se calcula como hoy | Dominio de `features/cuenta`; el estado en `PerfilController` |
| `SesionDispositivo` (nueva) | `id`, `dispositivo`, `ultimaActividad`, `actual` | Dominio de `features/cuenta` |
| `TokensSesion` | `accessToken`, `refreshToken` (su `toString` ya los oculta) | Memoria durante la sesión; persisten solo en `AlmacenSeguro` |
| `ETag` y cuerpo de `GET /me` | Texto del `ETag` y respuesta | `CacheRespuestas` en memoria (spec 002); se vacía al cerrar e iniciar sesión |
| Bandera de interfaz | `sesionIniciadaProvider` (bool) | Memoria; pasa a falso al cerrar sesión |

El `deviceId` y su almacenamiento no cambian (spec 009).

## 7. Arquitectura
Capas de la constitución: `presentation` no importa `data`; los repositorios se componen en `*_providers.dart`.

**Cambian**
- `core/sesion/`: un almacén de tokens respaldado por `AlmacenSesion` (seguro), con lectura al arrancar (`main.dart` fija los tokens iniciales); `SesionNotifier` de tokens (`sesion.dart`) recibe los tokens del canje (`ServicioEntradaReal`) y expone cerrar; `sesionIniciadaProvider` gana `cerrar()`; un `RenovadorSesion` real (`RenovadorSesionApi`) llama a `POST /auth/refresh` por el transporte **público** (sin `ClienteAutenticado`, para no entrar en bucle) y distingue «rechazada» (cierra) de «fallo transitorio» (no cierra). Se elimina el `almacenSesionProvider` duplicado y `RenovadorNoDisponible` queda solo como doble de pruebas.
- `core/sesion/cliente_autenticado.dart`: agrega el Bearer solo a rutas protegidas de la API, renueva con single-flight y reintenta una vez; el `logout` va por un camino sin renovación.
- `core/red/`: `obtener_json.dart` se amplía (o se agrega un `enviar_json.dart` hermano) para `PUT`, `POST` y `DELETE` con el mismo mapeo de errores.
- `features/cuenta/`: `PerfilRepositoryApi` (nueva, en `data/`) implementa `PerfilRepository`; `Perfil` se amplía; `SesionesRepository` y `SesionesRepositoryApi` nuevas; `cuenta_providers.dart` elige real o simulado según R-10; `PerfilController.cerrarSesion` además pone la bandera de sesión en falso.
- `features/inicio/inicio_providers.dart`: `ColoniasRepositoryHttp` recibe el transporte con sesión (`transporteApiProvider`) en vez del público.
- `main.dart`: lee los tokens guardados y valida la URL en modo `release` (CA-22).

**No cambian:** pantallas, rutas, ARB, tema, `oficios`, `entrada` (salvo registrar los tokens), `contracts/`, `knock_api`.

## 8. Amenazas y controles
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Token de acceso o de renovación en registros, `toString` o mensajes | `TokensSesion.toString` oculto, errores como `Failure` sin cuerpo, sin `print` ni `debugPrint` en esta capa | CA-24 |
| Tokens en lugar inseguro (preferencias, caché) | Solo `AlmacenSeguro`; la caché guarda respuestas, no cabeceras de autorización | CA-26 |
| Reintentos que dupliquen escrituras | Un solo reintento, solo tras 401; `PUT` es idempotente; sin reintentos por red o 5xx; `logout` y `refresh` sin reintento | CA-13, CA-25, CA-08 |
| Doble renovación que dispare el reuso del token y cierre todas las sesiones de la cuenta | Single-flight y token nuevo guardado antes de reintentar | CA-13, CA-14 |
| Bucle de renovación | El refresh no pasa por el cliente con sesión; una renovación por petición | CA-15 |
| Sesión que queda abierta tras fallo del refresh o logout sin red | Cierre local siempre, aunque el servidor no responda | CA-07, CA-16 |
| Datos de otra cuenta en la siguiente sesión | Caché y estado de perfil, colonia y oficios se vacían al cerrar; iniciar sesión también vacía | CA-06, CA-26 |
| Enviar el token a un destino que no es la API | El Bearer se agrega solo a URLs de `KNOCK_API_URL`; la URL base solo `https` (o local en desarrollo) | CA-11 |
| Compilación de tienda con simulado (perfil «Persona Demo» sin sesión real) | Falla al arrancar sin URL válida | CA-22 |
| Enumeración de sesiones ajenas | La app solo ofrece las sesiones que el servidor lista; 404 no revela nada y se trata como ya cerrada | CA-21 |
| Expiración del token de acceso (15 min) | Renovación transparente; si no es posible, vuelve al login | CA-13, CA-16 |
| Coordenadas en la caché de colonias | Caché solo en memoria, vaciada al cerrar; las coordenadas no se registran | CA-24, CA-26 |
| XSS | No aplica: la app no renderiza HTML del servidor | — |

## 9. Plan de pruebas
Las pruebas citan el caso como `CA-026-NN` en el nombre (para `python scripts/sdd_lint.py --trace 026`).

| Tipo | ¿Aplica? | Qué se prueba / herramienta |
|---|---|---|
| Unitarias | Sí | `PerfilRepositoryApi` (200, 304, `PUT` con campos conservados, errores), `RenovadorSesionApi`, `SesionesRepositoryApi` y `ClienteAutenticado` con `MockClient` de `http/testing`: CA-01 a CA-05, CA-08, CA-10, CA-11, CA-13 a CA-18, CA-20, CA-21, CA-25 |
| Widget / componente | Sí | «Mi cuenta» y «Completar perfil» con cada error y el reintento; cerrar sesión lleva a `/entrar`: CA-06, CA-19 |
| Integración con servidor falso | Sí | `HttpServer` local como en `cliente_api_servidor_simulado_test.dart`: flujo completo (CA-27), single-flight real (CA-14) y orden de llamadas |
| Seguridad negativa | Sí | Token ausente de registros, `toString` y mensajes (CA-24); 401 sin sesión sin petición (CA-05); sesión cerrada tras fallo del refresh (CA-16) y tras reintento 401 (CA-15); sin rastros en almacenamiento (CA-26); Bearer solo hacia la API (CA-11) |
| Arquitectura | Sí | Las pruebas de capas existentes siguen pasando: `presentation` sin `data` ni `knock_api` |
| Accesibilidad | No cambia | No hay pantallas ni textos nuevos; se corren las pruebas existentes |
| Regresión | Sí | Login, oficios y colonias: CA-12, CA-23, CA-28 |
| Estático | Sí | `flutter analyze` y `dart format` sin hallazgos (CA-28) |
| Humo manual | Sí | Recorrido en teléfono contra el backend desplegado; evidencia en el PR: CA-29 |
| Mutación | No | Sin meta propia; se respeta el umbral vigente de la spec 008 |

**Gates:** `cd app && flutter pub get && flutter analyze && flutter test`, `python scripts/sdd_lint.py` y `python scripts/sdd_lint.py --trace 026`.

## 10. Escenarios
**Positivos**
- La persona entra con su SMS, abre «Mi cuenta» y ve su nombre real; lo cambia y se guarda.
- Pasan 15 minutos: la primera llamada recibe 401, la app renueva sin que la persona lo note y la llamada termina bien.
- Abre Inicio con ubicación: la colonia llega con el token.
- Cierra sesión: vuelve a `/entrar`, y al entrar con otra cuenta no ve nada de la anterior.

**Negativos y errores esperados**
- Nombre rechazado (400): mensaje de datos rechazados; el nombre mostrado no cambia.
- Colonia que no existe (422): el mismo mensaje; no se guarda nada.
- Cuenta en eliminación programada (409): mensaje de conflicto.
- Mercado caído (503) o sin red: mensaje de sin conexión y botón de reintentar; el `PUT` no se repite solo.
- 429: mensaje con el tiempo de espera de `Retry-After`; no se llama otra vez hasta que pase.
- Refresh rechazado (token usado, sesión revocada desde otro teléfono): vuelve al login.
- Sin URL en una compilación de tienda: no abre.

**Casos límite**
- Cinco pantallas piden datos a la vez cuando vence el token: una sola renovación.
- El cierre de sesión llega con la red caída: se cierra en el teléfono; la sesión del servidor sigue hasta que la cierre la persona desde otro dispositivo o venza a los 30 días.
- La renovación llega al servidor pero la respuesta se pierde: el siguiente intento cuenta como reuso y cierra las sesiones (riesgo aceptado por el backend, spec 016 §9); la app vuelve al login.
- Respuesta 200 con JSON inválido o tokens vacíos: `DatosInvalidosFailure`.
- `GET /me/sesiones` vacío o con una sola sesión: lista válida.
- Se cierra sesión mientras hay una renovación en curso: la renovación termina y no reabre la sesión.
- 304 sin `ETag` guardado: se trata como error de datos, no como perfil vacío.

## 11. Definición de terminado
- Los 29 criterios de aceptación tienen prueba (o evidencia manual en CA-29) y `sdd_lint --trace 026` no reporta drift.
- `flutter analyze` y `flutter test` en verde; el CI en verde.
- Ningún simulado se usa en una compilación `release`; se probó la compilación de tienda sin URL.
- Un par revisó el cambio y la sección «Uso de IA» está en el PR.
- `Memoria.md` registra la decisión, lo pendiente (spec 037, contrato vendorizado) y qué evitar; el mapa de arquitectura se regeneró con `scripts/codemap.py`.
- No se tocaron `contracts/`, `knock_api` ni `.github/`.

## 12. Decisiones tomadas sin consulta
Quien aprueba la spec las acepta o las cambia aquí antes de aprobar.

- **D-01 Llamadas HTTP sin cliente generado.** `/me`, `refresh`, `logout`, `/me/sesiones` y `colonias` no están en `contracts/` ni en `knock_api`, que están protegidos. Se usa el patrón ya existente de `obtener_json.dart` y se retira cuando el contrato se vendorice. La constitución pide clientes generados; esta es una excepción temporal igual a la de KNOCK-229.
- **D-02 Un solo almacén de tokens.** Hoy hay dos (memoria y seguro). Queda el seguro, leído al arrancar; el canje registra los tokens en la sesión.
- **D-03 Fallo del refresh.** Solo 400 o 401 cierran la sesión; red, 429 y 5xx la conservan, porque cerrarla por una señal mala sacaría a la persona sin motivo. Es una lectura más fina de «si falla la renovación se cierra la sesión».
- **D-04 Reintento tras renovar.** Si la petición reintentada vuelve a dar 401, la sesión se cierra (el token recién emitido fue rechazado, así que la sesión ya no sirve).
- **D-05 `logout` sin renovación ni reintento.** Si el servidor dice 401, la sesión ya no existía; se borra local y listo.
- **D-06 `PUT` conserva los opcionales.** Para no borrar colonia, código postal y foto por omisión, se reenvían los del último `GET`.
- **D-07 404 al cerrar una sesión = ya cerrada.** No se agrega un `Failure` ni un texto nuevo.
- **D-08 Sin mensajes nuevos.** Todos los errores usan los `error*` existentes; el 422 de colonia usa el texto de datos rechazados.
- **D-09 Falla en `release` al arrancar** y no con una pantalla nueva, para no agregar diseño. Verificarlo también en el flujo de publicación (`.github/`) lo pide quien tenga permiso.
- **D-10 La validación del nombre de la app (2 a 60, solo letras) no cambia,** aunque el backend admite 2 a 80 con guion y apóstrofo.
- **D-11 `GET /me` usa la caché con ETag que ya existe** (`ClienteConCache`) en lugar de otra nueva.
- **D-12 Clave de Jira** `KNOCK-243 (por verificar)`: no hubo acceso a Jira.

## 13. Riesgos y dudas abiertas
- **Contrato desactualizado:** si el backend cambia un campo de `/me` o de `refresh`, la app no lo detecta al compilar hasta que se vendorice el contrato (D-01). Mitigación: pruebas que fijan los campos esperados.
- **Reuso del token de renovación:** una renovación perdida por la señal cierra todas las sesiones de la cuenta; el backend lo aceptó. Se mide en la demo.
- **Caché de `colonias/en-punto`:** pasa por `ClienteConCache`; si el servidor manda `ETag` guarda la respuesta (con coordenadas en la URL) en memoria hasta cerrar sesión. Confirmar si debe excluirse.
- **Duda:** la lista de sesiones queda sin pantalla; ¿entra en la demo?
- **Dependencia:** el registro de dispositivos (spec 037 del backend) y las notificaciones siguen simulados.
- No se verificó la clave de Jira ni el contrato OpenAPI desplegado del gateway en esta etapa; se tomó de las specs del backend.

## Aprobación
- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
