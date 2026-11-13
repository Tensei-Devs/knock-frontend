# Spec 017 — Elegir zona por ubicación o código postal (pantalla)

> **Jira:** KNOCK-47 («HU-009 · Indicar mi zona por ubicación o código postal (lista de espera fuera de la ciudad piloto)», verificada en Jira el 9 de noviembre de 2026) · **Épica:** EP-02 Zona y cobertura · **Módulo:** catalog · **Responsable:** Ángel Alexis Blas Castillo (la pantalla la implementa Erick Trejo Reséndiz) · **Sprint:** S4 (ola B) · **Puntos:** 3 · **Capas:** Mobile
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend (spec 023 «Zona por ubicación o código postal con lista de espera»)
> **Fuentes:** `docs/referencia/FUNCIONES_Y_FLUJOS.md` §3.3 y §7.2 · `docs/referencia/DECISIONES.md` #12 y #22 · `docs/backlog/HU-009.md`
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `GET /api/v1/colonias/en-punto` (KNOCK-141) ya está desplegado; `GET /api/v1/zonas/cp/{cp}` y `POST /api/v1/zonas/lista-espera` los fija backend 023, y el guardado en el perfil es `PUT /api/v1/me` de backend 017 (aprobada). Se vendorizan antes de implementar (spec 006).
> **Estado:** Aprobada

## 1. Objetivo

Que una persona elija su zona con la ubicación del teléfono o con su código postal, confirme o cambie la colonia, y quede en la lista de espera si está fuera de la ciudad piloto, sin guardar nunca sus coordenadas. Esta spec cubre la capa **Mobile**; la cobertura, el catálogo de colonias y la lista de espera son del backend (spec 023).

## 2. Historia y casos de prueba

**KNOCK-47** — Como persona que se registra, quiero indicar mi zona con mi ubicación o mi código postal, para ver expertos cerca de mí sin dar mi dirección.

- **CA-01:** Dada una persona en el paso de la zona, cuando acepta el permiso de ubicación y su punto cae en la ciudad piloto, entonces se propone la colonia que lo contiene, puede confirmarla o cambiarla, y las coordenadas no se guardan ni se registran. · Verificación: `app/test/features/inicio/presentation/zona_controller_test.dart` → `CA_017_01`
- **CA-02:** Dada una persona que niega el permiso o tiene la ubicación apagada, cuando toca «Usar mi ubicación», entonces ve primero la explicación del permiso, al negarlo se le pide el código postal y la app sigue funcionando sin error. · Verificación: `app/test/features/inicio/presentation/zona_controller_test.dart` → `CA_017_02`
- **CA-03:** Dada una persona que escribe un código postal de la ciudad piloto, cuando toca «Buscar», entonces ve sus colonias y elige la suya. · Verificación: `app/test/features/inicio/presentation/selector_de_zona_test.dart` → `CA_017_03`
- **CA-04:** Dada una ubicación o un código postal fuera de cobertura (`enCobertura` falso), cuando busca, entonces ve «Por ahora solo atendemos {ciudadPiloto}» con el valor que manda el servidor y puede tocar «Avísame cuando lleguen». · Verificación: `app/test/features/inicio/presentation/selector_de_zona_test.dart` → `CA_017_04`
- **CA-05:** Dada la persona fuera de cobertura, cuando confirma «Avísame cuando lleguen», entonces se envía `{ cp, municipio? }` (el municipio es opcional, de 1 a 100 letras, espacios, punto, guion o apóstrofo), se le muestra «¡Listo! Te avisaremos cuando lleguemos a tu zona.» y no se envía ninguna coordenada. · Verificación: `app/test/features/inicio/presentation/lista_espera_controller_test.dart` → `CA_017_05`
- **CA-06:** Dada una persona que toca «Ahora no», cuando continúa, entonces el registro sigue sin guardar colonia, la tarjeta «Tu zona» dice «Elige tu zona para ver expertos cerca» y al pedir una cotización se le pide elegirla (spec 015, R-05). · Verificación: `app/test/features/inicio/presentation/zona_controller_test.dart` → `CA_017_06`
- **CA-07:** Dada una persona que confirma su colonia, cuando continúa, entonces la app envía `PUT /api/v1/me` con su `nombre` y `fotoUrl` actuales más `colonia` y `codigoPostal` (sin borrar los demás campos), y la tarjeta «Tu zona» muestra la colonia y el código postal. · Verificación: `app/test/features/inicio/data/zona_repository_api_test.dart` → `CA_017_07`
- **CA-08:** Dado el campo del código postal, cuando no tiene exactamente 5 dígitos ASCII o se piden coordenadas fuera de rango, entonces el campo muestra «Escribe los 5 números de tu código postal» y no se llama a la API; si el servidor responde 422 con `errors.cp`, se muestra el mismo texto. · Verificación: `app/test/features/inicio/domain/zona_test.dart` → `CA_017_08`
- **CA-09:** Dadas las consultas de zona, cuando se repiten, entonces la búsqueda por coordenadas **no** se guarda en caché y la de código postal se guarda bajo `catalogo/zonas/` (el servidor responde `private, no-cache` con `ETag`, así que la app la reutiliza en memoria hasta 10 minutos y después revalida con `If-None-Match`; no la guarda si responde `no-store`); la clave solo contiene el código postal, nunca `lat` ni `lon`, y el perfil no se cachea. · Verificación: `app/test/features/inicio/data/zona_repository_api_test.dart` → `CA_017_09`
- **CA-10:** Dado un 429 con `Retry-After`, un 5xx o una caída de red, cuando se busca la zona o se guarda, entonces se muestra el estado de error o el tiempo de espera, hay «Reintentar» cuando aplica y no se reintenta en bucle. · Verificación: `app/test/features/inicio/presentation/zona_controller_test.dart` → `CA_017_10`
- **CA-11:** Dada la lista de colonias, cuando se recorre con lector de pantalla y texto al 200 %, entonces cada colonia se anuncia con su nombre y su código postal, cada control mide al menos 48 dp y no se corta el contenido. · Verificación: `app/test/features/inicio/presentation/accesibilidad_zona_test.dart` → `CA_017_11`
- **CA-12:** Dado un código postal que empieza con 42 pero no está en el catálogo activo, cuando se busca, entonces la app **no** decide por su cuenta que hay cobertura: muestra lo que responde el servidor (lista de espera). · Verificación: `app/test/features/inicio/data/zona_mapper_test.dart` → `CA_017_12`
- **CA-13:** Dada una zona guardada, cuando se cierra sesión, entonces `knock.zona` y las claves de caché `catalogo/zonas/*` quedan vacías y la siguiente cuenta no ve la zona anterior. · Verificación: `app/test/features/inicio/data/zona_local_repository_test.dart` → `CA_017_13`
- **CA-14:** Dada una lista de espera ya registrada, cuando la persona vuelve a confirmar con el mismo código postal y el servidor responde 200 con `yaRegistrado: true`, entonces se muestra «Ya estabas en la lista. Te avisaremos.», no se trata como error y no se reintenta. · Verificación: `app/test/features/inicio/data/lista_espera_repository_api_test.dart` → `CA_017_14`
- **CA-15:** Dado un código postal confirmado, cuando se guarda la zona o se consulta, entonces el código postal no aparece en registros, en preferencias de diagnóstico ni en ninguna clave de caché fuera de `catalogo/zonas/`. · Verificación: `app/test/seguridad/zona_privada_test.dart` → `CA_017_15`

## 3. Alcance / No-alcance

**Dentro (este repositorio, capa Mobile)**
- Paso de zona dentro de «Completar perfil», después del nombre.
- «Usar mi ubicación» con la explicación previa del permiso y su alternativa por código postal.
- Búsqueda por código postal, lista de colonias y confirmación o cambio de colonia.
- «Ahora no» sin colonia, con la invitación a elegirla después.
- Lista de espera fuera de cobertura.
- Tarjeta «Tu zona» de Inicio con la colonia y el código postal guardados.
- Estados de carga, vacío, error, sin conexión y reintento.
- Textos en español e inglés, tema claro y oscuro, accesibilidad.
- Pruebas unitarias, de widget, de contrato, de seguridad negativa, de accesibilidad y de integración.

**Fuera**
- El catálogo de códigos postales y colonias, la cobertura, la geocodificación inversa y la lista de espera: backend 023 y la base de datos de catálogo.
- La dirección exacta de la casa (HU-010).
- El flujo completo para cambiar la zona después, con recálculo de cobertura (HU-049); aquí solo se reabre el mismo selector.
- El mapa de Inicio y la búsqueda de expertos (HU-012 y posteriores).
- El panel interno que revisa la lista de espera.
- La verificación de identidad (spec 018) y la visita (spec 016).

### Requisitos

- **R-01:** El paso de zona se pide después del nombre, en el mismo flujo de «Completar perfil», y se puede omitir con «Ahora no».
- **R-02:** «Usar mi ubicación» se ofrece solo después de la explicación previa del permiso (spec 012); se pide **solo ubicación aproximada** (`LocationAccuracy.low`), una vez por consulta, sin `ACCESS_FINE_LOCATION` ni ubicación en segundo plano. Si se niega o falla, se pide el código postal y no se muestra un error.
- **R-03:** La app lee la ubicación una sola vez por consulta, la envía solo en la petición de colonia y la descarta: no la guarda, no la cachea, no la registra y nunca escribe la URL con coordenadas en un registro.
- **R-04:** El código postal se valida en el teléfono con exactamente 5 dígitos antes de llamar a la API.
- **R-05:** La app no decide la cobertura por el prefijo del código postal ni por la colonia: muestra lo que responde el servidor.
- **R-06:** Se guardan solo la colonia y el código postal en el perfil con `PUT /api/v1/me` (backend 017), reenviando el `nombre` y la `fotoUrl` vigentes para no borrarlos; la dirección exacta no se pide en este flujo.
- **R-07:** «Ahora no» no guarda colonia: la tarjeta «Tu zona» invita a elegirla y la solicitud de cotización la exige antes de enviar (spec 015).
- **R-08:** Fuera de cobertura se ofrece la lista de espera; el registro lleva el código postal escrito por la persona y, si la persona quiere, el municipio (1 a 100 caracteres válidos), y **nunca** coordenadas.
- **R-09:** La búsqueda por coordenadas no se cachea; la de código postal se cachea bajo `catalogo/` con la infraestructura de la spec 010; la zona del perfil no se cachea.
- **R-10:** La zona guardada se conserva en el teléfono para que Inicio la muestre sin conexión y se borra al cerrar sesión; el borrado se hace con un método `borrarZonaLocal()` que se invoca desde el cierre de sesión, junto con las claves de caché `catalogo/zonas/*`.
- **R-11:** Todo error de la API se muestra con un texto del catálogo de traducciones; nunca con el código HTTP, la URL ni el cuerpo de la respuesta.
- **R-12:** Cada pantalla tiene estados de carga, con datos, vacío, error y sin conexión, y un botón de reintentar cuando aplica.
- **R-13:** Todos los textos visibles viven en los ARB de español e inglés y todos los colores y tipografías en el tema.
- **R-14:** Cada control interactivo tiene etiqueta semántica, mide al menos 48 dp y funciona con el texto del sistema al 200 %.
- **R-15:** La lista de espera no lleva `Idempotency-Key`: el servidor es idempotente por persona y código postal (201 la primera vez, 200 con `yaRegistrado: true` después); el botón se deshabilita mientras hay una petición en curso.
- **R-16:** `knock.zona` queda fuera de la copia de seguridad del sistema (`android:allowBackup="false"` o reglas que excluyan `knock.*`), comprobado con una prueba del manifiesto.

## 4. Contrato API y eventos

La app **consume**. `GET /api/v1/colonias/en-punto` ya está desplegado (KNOCK-141); `GET /zonas/cp/{cp}` y `POST /zonas/lista-espera` los fija backend 023 y `PUT /api/v1/me`, backend 017 (aprobada). Esta tabla se alineó el 9 de noviembre de 2026 con el borrador de backend 023; si al vendorizar cambia un nombre o un tipo, se corrige aquí antes de implementar.

| Método y ruta | Uso en la app | Cuerpo / parámetros | Respuesta | Errores que la app distingue |
|---|---|---|---|---|
| `GET /api/v1/colonias/en-punto` | Colonia de un punto (ya desplegado) | `lat`, `lon` (solo en la consulta) | `200` con la colonia que contiene el punto o sin colonia (forma del contrato desplegado, por validar al vendorizar) | `400` coordenadas inválidas, `401`, `429` |
| `GET /api/v1/zonas/cp/{cp}` | Colonias de un código postal | `cp` de exactamente 5 dígitos ASCII | `200` con `{ enCobertura, ciudadPiloto, colonias[{ id, nombre, cp, municipio }] }` (lista sin paginar, ordenada por nombre) | `401`, `422` con `errors.cp`, `429` |
| `PUT /api/v1/me` | Guardar colonia y código postal en el perfil | `{ nombre, fotoUrl?, colonia, codigoPostal }` (se reenvían `nombre` y `fotoUrl` vigentes) | `200` con el perfil | `400`, `401`, `409` (cuenta en eliminación programada), `422` colonia inválida, `503` |
| `POST /api/v1/zonas/lista-espera` | Registro fuera de cobertura | `{ cp, municipio? }` | `201` registro nuevo o `200` con `yaRegistrado: true`; cuerpo `{ id, cp, municipio?, creadoEn, yaRegistrado }` | `401`, `422` con `errors.cp` o `errors.municipio`, `429` |

Reglas del contrato que la app da por ciertas:
- **Autorización:** las cuatro rutas exigen sesión y deciden por el token; el cuerpo nunca lleva un identificador de persona (un `usuarioId` se ignoraría).
- **Privacidad:** ninguna ruta nueva recibe coordenadas; la ubicación solo viaja a `colonias/en-punto` y se descarta. El servidor no registra el código postal junto a la persona.
- **Cobertura:** la decide el servidor por la presencia del código postal en el catálogo; un `200` con `enCobertura = false` no es un error y no distingue «no existe» de «sin cobertura».
- **Idempotencia:** la lista de espera es idempotente por persona y código postal, sin `Idempotency-Key`.
- **Límites:** 5 registros por hora por persona en la lista de espera; municipio de 100 caracteres; el servidor cachea 24 h el código con colonias y 5 minutos el vacío.
- **Paginación:** no aplica; el listado por código postal está acotado por el catálogo (backend 023 R-10).
- **Caché:** `zonas/cp` se puede guardar en `catalogo/zonas/` con la clave del código postal; `colonias/en-punto`, el perfil y la lista de espera nunca.
- **Errores:** ProblemDetails con `errors` por campo; el valor enviado nunca se repite en la respuesta.
- **Eventos:** ninguno.

## 5. Modelo de datos

**Entidades de dominio** (`app/lib/features/inicio/domain/`, Dart puro, sin Flutter ni HTTP)

| Entidad | Campos | Reglas |
|---|---|---|
| `Zona` | `coloniaId`, `nombre`, `cp`, `municipio` | Inmutable; no lleva coordenadas |
| `ResultadoZona` | `enCobertura`, `ciudadPiloto`, `colonias` | `colonias` vacío cuando no hay cobertura; un CP inexistente y uno sin cobertura se ven igual (backend 023 R-15) |
| `Colonia` | `id`, `nombre`, `cp`, `municipio` | Se **reutiliza** `app/lib/features/inicio/domain/colonia.dart`; no se crea otra |
| `RegistroListaEspera` | `cp`, `municipio?`, `creadoEn`, `yaRegistrado` | Solo después de confirmar; sin coordenadas |

**Estado local**
- `knock.zona` se guarda a través de `app/lib/core/preferencias/almacen_zona.dart`, el único archivo que importa `shared_preferences` para la zona (regla vigente de `core/preferencias/` y `core/cache/`); el repositorio de la función solo lo inyecta. Lleva `coloniaId`, `nombre`, `cp`, `municipio`, no es una credencial, no lleva coordenadas ni dirección, queda fuera de la copia de seguridad del sistema y se borra al cerrar sesión.
- Caché de `zonas/cp` bajo `catalogo/` con la infraestructura de la spec 010 (reutilización en memoria de 10 min sin llamar al servidor y, pasado ese tiempo, revalidación con `If-None-Match` y `ETag`; backend 023 R-16, `private, no-cache`); la clave es solo el código postal. **Sin** caché de `colonias/en-punto` ni de la zona del perfil.
- Las coordenadas viven solo en la memoria de la consulta y se descartan al recibir la respuesta.

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Fuga de información:** la ubicación exacta de la persona | Se lee una vez, se envía solo en la consulta y se descarta; no se guarda, no se cachea, no se registra y el servidor no la escribe en su registro de acceso | CA-01, CA-09 |
| **Fuga de información:** el código postal o la colonia en un registro o en un reporte de errores | La app no registra la zona ni el CP; los errores se mapean a `Failure` y a un texto del catálogo | CA-15, CA-10 |
| **Fuga de información:** la zona de otra cuenta en el teléfono | La zona se borra al cerrar sesión con `borrarZonaLocal()` y el servidor autoriza por token | CA-13 |
| **Suplantación:** guardar una zona en el perfil de otra persona | `PUT /api/v1/me` se resuelve con el token; la app no manda identificadores de cuenta y un 401 cierra la sesión | CA-07 |
| **Abuso:** recorrer el catálogo de códigos postales o registrar la lista de espera en masa | Validación local del CP, botón deshabilitado durante la petición, sin reintento automático, 429 con `Retry-After` y la espera de la spec 009 (el servidor limita la lista de espera a 5 por hora por persona) | CA-14, CA-10 |
| **Alteración:** inventar cobertura por el prefijo «42» | La app muestra lo que responde el servidor; no filtra por prefijo | CA-12 |
| **Denegación:** pedir la ubicación sin explicación o dejar la app inutilizable sin permiso | Explicación previa y alternativa por código postal; un permiso negado no es un error | CA-02 |
| **Denegación:** martillear la API tras un 429 | `ClienteConEspera` obedece `Retry-After` y la pantalla no reintenta sola | CA-10 |
| **Elevación de privilegios:** usar el flujo sin sesión | El router exige sesión (spec 001) y el cliente pone el token; un 401 renueva una sola vez y, si falla, cierra la sesión (spec 002) | CA-07, CA-10 |
| **Dependencias:** un paquete de ubicación vulnerable | `geolocator` ya está evaluado en `Memoria.md`; esta spec no agrega dependencias | (comando) `flutter pub outdated` + revisión en el PR |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos nuevos (ARB `zona*`) |
|---|---|---|---|
| Completar perfil, paso 2 (`/completar-perfil`, se modifica) | carga, con datos, vacío, error, sin conexión | Título «¿Dónde buscas expertos?», «Usar mi ubicación», campo de código postal, lista de colonias, «Ahora no» y la lista de espera | `zonaTitulo`, `zonaDetalle`, `zonaUsarUbicacion` (existe), `zonaPideCodigoPostal` (existe), `zonaCodigoPostal` (existe), `zonaCodigoPostalInvalido` (existe), `zonaBuscar`, `zonaColonias`, `zonaConfirmar`, `zonaCambiar`, `zonaAhoraNo`, `zonaFueraCobertura`, `zonaCiudadPiloto`, `zonaListaEspera`, `zonaListaEsperaTitulo`, `zonaListaEsperaDetalle`, `zonaListaEsperaGracias`, `zonaError`, `zonaSinConexion` |
| Inicio, tarjeta «Tu zona» (`/inicio`, se modifica) | con datos, sin zona, sin conexión | Nombre de la colonia y su código postal; toca para reabrir el selector | `inicioTuZona`, `inicioTuZonaSinElegir`, `inicioTuZonaCambiar` |
| Selector de zona (hoja modal desde Inicio) | vacío, carga, error | El mismo componente del paso 2 | Reutiliza los textos de arriba |
| Común | — | Errores del catálogo y botón de reintentar | Reutiliza `errorSinConexion`, `errorServicio`, `errorSesion`, `errorDemasiadosIntentos` y `errorNoEncontrado` (spec 015) |

**Mensajes exactos** (español; el inglés va en `app_en.arb`)

| Situación | Texto en pantalla |
|---|---|
| Explicación previa del permiso | «Usamos tu ubicación aproximada una sola vez para encontrar tu colonia. No la guardamos.» |
| Permiso negado o ubicación apagada | «Sin problema. Escribe tu código postal.» |
| CP inválido (local o 422 `errors.cp`) | «Escribe los 5 números de tu código postal» |
| Fuera de cobertura | «Por ahora solo atendemos {ciudadPiloto}» |
| Registro nuevo en la lista de espera | «¡Listo! Te avisaremos cuando lleguemos a tu zona.» |
| `yaRegistrado: true` | «Ya estabas en la lista. Te avisaremos.» |
| 422 `errors.municipio` | «Revisa el municipio: solo letras, espacios, punto, guion o apóstrofo» |
| Sin zona | «Elige tu zona para ver expertos cerca» |
| 429 | «Hiciste muchos intentos. Espera {segundos} segundos.» |
| Sin conexión | «Sin conexión. Intenta de nuevo cuando tengas señal.» |
| 5xx | «Algo salió mal de nuestro lado. Intenta de nuevo.» |

Reglas de pantalla:
- El paso de zona se puede omitir; «Ahora no» no bloquea el registro ni pide un permiso.
- La lista de colonias se agrupa por municipio cuando el CP devuelve más de uno.
- Después de elegir, se muestra un resumen («Colonia, C.P.») con «Confirmar» y «Cambiar» antes de guardar.
- Fuera de cobertura, el botón «Avísame cuando lleguen» pide el CP si la persona llegó por ubicación.
- Accesibilidad: la lista de colonias se anuncia con nombre y CP, el campo del CP tiene etiqueta y teclado numérico, y el estado de cobertura no depende solo del color.

## 8. Pruebas, gates y límites

**Plan de pruebas** (Sí/No con motivo; meta de mutación del módulo: 70 % en `domain/`)

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Validación del CP, mapeo del contrato, máquina de estados de la zona y de la lista de espera |
| Widget (W) | Sí | Paso de zona, lista de colonias, «Ahora no», lista de espera y tarjeta «Tu zona» |
| Aceptación (ACC) | Sí | CA-01 a CA-15 |
| Contrato (CON) | Sí | Cliente generado contra `contracts/openapi.v1.json` y `flutter test test/api/cliente_generado_test.dart` (spec 006) |
| Integración (INT) | Sí | Registro con CP y con ubicación simulada en `integration_test/` y humo contra el entorno desplegado |
| Seguridad negativa (NEG) | Sí | Coordenadas fuera de rango, CP inválido (local y 422), 401, repetición de la lista de espera (`yaRegistrado`), 429 y coordenadas ausentes de registros y caché |
| Accesibilidad (A11Y) | Sí | `expectAccesible` de la spec 008, lector de pantalla y texto al 200 % |
| Mutación (MUT) | Sí | Reglas de `domain/` con `mutation_test`, meta 70 % |
| E2E | Sí | Un recorrido: completar perfil → zona por CP → Inicio con la colonia |
| Regresión | Sí | `flutter test` completo; no se rompen Inicio, Explorar, Oficios, Entrada, Cuenta ni Trabajo |
| Análisis estático y vulnerabilidades | Sí | `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed`, Semgrep y CodeQL del CI, `flutter pub outdated` |
| Rendimiento (PERF) | No | El backend mide la consulta < 100 ms con índice GiST; la app solo muestra el resultado |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Ubicación aceptada dentro de la ciudad → colonia propuesta y confirmada |
| Positivo | CP de la ciudad → lista de colonias y elección |
| Positivo | «Ahora no» → sin colonia y el registro continúa |
| Positivo | Fuera de cobertura → lista de espera con el CP |
| Negativo | Permiso negado → se pide el CP y no hay error |
| Negativo | CP de 4 o 6 dígitos → error en línea sin llamada |
| Negativo | CP con prefijo 42 fuera del catálogo → lista de espera, no cobertura inventada |
| Error esperado | 401 → renueva una vez; si falla, cierra sesión y pide entrar |
| Error esperado | 200 con `yaRegistrado: true` en la lista de espera → «Ya estabas en la lista» sin duplicar |
| Error esperado | 422 con `errors.municipio` → «Revisa el municipio: solo letras, espacios, punto, guion o apóstrofo» |
| Error esperado | 429 → espera el `Retry-After` y lo dice |
| Error esperado | 5xx o tiempo agotado → estado de error con reintentar |
| Caso límite | Un CP con una sola colonia y otro con varias |
| Caso límite | Cambiar la colonia antes de confirmar y volver atrás |
| Caso límite | Sin conexión al abrir Inicio: la zona guardada se ve |
| Caso límite | Coordenadas en el borde de la cobertura |

**Gates:** `flutter analyze --fatal-infos`, `dart format`, `flutter test` con cobertura ≥ 50 % (spec 008), revisión de la constitución, revisión de seguridad y PR con CI en verde (spec 007).
**Límites y dudas abiertas:** ver §13.

## 9. Arquitectura y componentes

Se respeta la arquitectura de la spec 001: `domain` en Dart puro, `presentation` sin `data/`, un archivo `<funcion>_providers.dart` como raíz de composición y el cliente generado como única puerta a la API (spec 006).

| Archivo | Acción | Contenido |
|---|---|---|
| `app/lib/features/inicio/domain/zona.dart` | Crear | `Zona`, `ResultadoZona` y la validación del CP |
| `app/lib/features/inicio/domain/zona_repository.dart` | Crear | Interfaz: `porUbicacion`, `porCodigoPostal`, `guardarEnPerfil`, `listaEspera` |
| `app/lib/features/inicio/data/zona_mapper.dart` | Crear | Contrato → dominio, con validación de campos |
| `app/lib/features/inicio/data/zona_repository_api.dart` | Crear | Implementación sobre el cliente generado y el transporte de la app |
| `app/lib/features/inicio/data/zona_local_repository.dart` | Crear | Zona guardada en el teléfono: lee y escribe por el almacén de `core/preferencias/` y expone `borrarZonaLocal()` |
| `app/lib/core/preferencias/almacen_zona.dart` | Crear | Único archivo que importa `shared_preferences` para `knock.zona`; guarda y borra la zona |
| `app/lib/features/inicio/inicio_providers.dart` | Modificar | Raíz de composición de la zona |
| `app/lib/features/inicio/zona_providers.dart` | Modificar | Estados de la zona, «Ahora no» y guardado |
| `app/lib/features/inicio/presentation/colonia_controller.dart` | Modificar | Colonia por coordenadas y por CP, sin caché de coordenadas |
| `app/lib/features/inicio/presentation/lista_espera_controller.dart` | Crear | Registro en la lista de espera y sus errores |
| `app/lib/features/inicio/presentation/zona/selector_de_zona.dart` | Modificar | Lista de colonias, confirmación, «Ahora no» y lista de espera |
| `app/lib/features/inicio/presentation/zona/paso_de_zona.dart` | Crear | Paso 2 de «Completar perfil» |
| `app/lib/features/inicio/presentation/inicio_screen.dart` | Modificar | Tarjeta «Tu zona» con la colonia y el CP |
| `app/lib/features/cuenta/presentation/completar_perfil_screen.dart` | Modificar | Dos pasos: nombre y zona |
| `app/lib/core/router/rutas.dart` | Sin cambios | El paso vive en `/completar-perfil` |
| `app/lib/core/errores/failure.dart` | Sin cambios | Reutiliza `NoEncontradoFailure` de la spec 015 |
| `app/lib/l10n/app_es.arb`, `app_en.arb` | Modificar | Textos de §7 en ambos idiomas |
| `app/pubspec.yaml` | Sin cambios | `geolocator` ya está evaluado; no se agregan dependencias |

**No se toca:** `app/packages/knock_api/`, `contracts/`, `scripts/`, `.github/`, `.agents/` y las specs aprobadas.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| Backend 023 (otro repositorio) | Catálogo por CP, guardado de zona y lista de espera | Sin contrato vendorizado no se implementa la capa `data` |
| 006 Contrato y cliente generado | Cliente Dart y verificación en CI | No hay forma permitida de llamar a la API |
| 002 Piezas comunes | Sesión, renovación, `Failure` y mensajes | Sin token ni manejo de errores común |
| 009 Seguridad del cliente | Permisos, espera por 429 y reglas de privacidad | Se incumpliría la privacidad de la ubicación |
| 010 Caché y sin conexión | Caché de catálogos con `ETag` | Se cachearían coordenadas o se duplicaría la caché |
| 012 Notificaciones y permisos | Explicación previa del permiso de ubicación | Se pediría el permiso sin explicar |
| 008 Calidad y pruebas | Reglas del analizador, accesibilidad y cobertura | Los gates no existirían |
| 015 Pedir y comparar cotizaciones | Colonia de la solicitud | Sin colonia no se envía a domicilio |
| 014 Alinear la UI con la maqueta (reservada) | Tokens, tipografía y contraste | La comparación visual queda pendiente |

## 11. Definición de terminado

- CA-01 a CA-15 con prueba que falla si la lógica está mal; `python scripts/sdd_lint.py --trace 017` sin `FALTA`.
- `flutter analyze --fatal-infos`, `dart format --set-exit-if-changed` y `flutter test` en verde, con cobertura ≥ 50 %.
- Los ARB de español e inglés completos y la prueba de traducciones en verde; ningún texto escrito en la pantalla.
- El contrato vendorizado incluye las rutas de §4 y el cliente generado compila; el manifiesto del cliente coincide (spec 006).
- Recorrido real contra el entorno desplegado: elegir la zona por CP y por ubicación, y la lista de espera, con capturas en el PR tomadas con datos de prueba (nunca con un código postal o una colonia reales de una persona).
- Pruebas de accesibilidad y de seguridad negativa en verde; comprobado que no se guardan coordenadas ni aparecen en registros.
- `Memoria.md` con las decisiones y lo que quedó pendiente (sin dependencias nuevas).
- PR con la plantilla completa, la etiqueta `puntos-app-N` y CI en verde.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | Se reutiliza `GET /api/v1/colonias/en-punto` (ya desplegado) para la ubicación y se agrega `GET /api/v1/zonas/cp/{cp}` para el código postal | La ficha de HU-009 propone `/zonas/colonia?lat&lng`, pero esa ruta no existe y la desplegada ya resuelve la colonia de un punto | Crear otra ruta para lo mismo y duplicar el contrato |
| D-02 | El paso de zona es la segunda página de «Completar perfil», no una ruta nueva | HU-009 pide la zona después del nombre y el flujo ya existe | Una ruta `/completar-perfil/zona` que agrega un paso de navegación |
| D-03 | «Ahora no» no guarda colonia y la app no asigna una por defecto | Backend 023 y backend 017 no definen una colonia por defecto; inventarla en el teléfono se rompe si cambia el catálogo | Pedir a backend un `porDefecto` que hoy no existe |
| D-04 | La app no filtra por el prefijo «42»: muestra lo que responde el servidor | La cobertura depende de las colonias activas, no del prefijo | Replicar la regla del prefijo en la app, que daría cobertura falsa |
| D-05 | La búsqueda por coordenadas no se cachea; la de CP sí, bajo `catalogo/` | Las coordenadas son un dato personal y el catálogo por CP no | Cachear la respuesta de `en-punto`, que guardaría la ubicación de la persona |
| D-06 | La lista de espera siempre lleva el código postal escrito por la persona, aunque haya llegado por ubicación | El registro pide CP (HU-009 CA5) y no se debe mandar la ubicación | Enviar coordenadas a la lista de espera, que contradice la privacidad |
| D-07 | La zona se guarda en `shared_preferences` y se borra al cerrar sesión | Es una preferencia de búsqueda (colonia y CP), no una credencial; Inicio la necesita sin conexión | Guardarla en el almacenamiento seguro, que es para tokens y el `deviceId` |
| D-08 | No se agregan dependencias: se usa `geolocator` y la infraestructura de red existentes | La app ya lee la ubicación y habla con la API | Un paquete nuevo de geocodificación en el teléfono, que duplicaría la del servidor |
| D-09 | Cambiar la zona después reabre el mismo selector desde la tarjeta «Tu zona» | HU-009 CA6 lo pide y el componente ya existe | Un flujo nuevo de cambio de zona (HU-049), que no es de este sprint |
| D-10 | El almacén de `knock.zona` vive en `core/preferencias/almacen_zona.dart` y la función `inicio` solo lo inyecta desde su repositorio | La prueba de arquitectura de preferencias solo admite `shared_preferences` en `core/preferencias/` y `core/cache/` | Importar `shared_preferences` dentro de `features/inicio/data/`, que rompe esa prueba |
| D-11 | `borrarZonaLocal()` borra `knock.zona` y las claves `catalogo/zonas/*`, y lo llama el cierre de sesión | La zona y su catálogo son de la cuenta que la eligió; otra cuenta no debe verlos | Dejar la zona y esperar a que la nueva cuenta la sobrescriba, que muestra la colonia de otra persona |
| D-13 | El guardado usa `PUT /api/v1/me` (backend 017) y no una ruta propia de zona | Backend 023 deja el guardado en el perfil de Identidad y no define `PUT /me/zona` | Pedir una ruta nueva a backend |
| D-14 | La lista de espera no envía `Idempotency-Key` | Backend 023 la hace idempotente por índice único y no lee el encabezado | Mandarla de todos modos, que no hace nada y confunde |
| D-15 | La app ofrece el municipio como campo opcional | Backend 023 lo acepta y ayuda a medir la demanda | No pedirlo nunca |
| D-12 | La clave de caché del CP es el código postal solo, sin coordenadas ni identificador de cuenta | El catálogo por CP no es un dato personal y se puede compartir entre cuentas | Incluir la cuenta en la clave, que duplica el catálogo y crece sin límite |

## 13. Riesgos y dudas abiertas

- **Bloqueante:** `GET /api/v1/zonas/cp/{cp}` y `POST /api/v1/zonas/lista-espera` no están en `contracts/openapi.v1.json`; hasta que backend 023 los publique y se vendorice, la capa `data` no se puede implementar ni probar contra el contrato.
- **Conflicto detectado:** la ficha de HU-009 propone `/api/v1/zonas/colonia?lat&lng` y el backend ya expone `/api/v1/colonias/en-punto?lat&lon`; esta spec usa la desplegada (D-01) y pide a backend 023 confirmar la ruta definitiva.
- **Riesgo:** `colonias/en-punto` exige sesión (responde 401 sin token); la zona se pide en «Completar perfil», cuando la sesión ya existe, pero la prueba debe cubrir el 401.
- **Riesgo:** el registro de acceso del servidor puede escribir la URL con `lat` y `lon` en la consulta de colonia; la app no puede evitarlo desde el teléfono. Dueño de cerrarlo: backend 023, que debe registrar la ruta sin la cadena de consulta. La app comprueba su parte con CA-01, CA-09 y CA-15.
- **Riesgo:** `android:allowBackup` sigue sin decidir en `Memoria.md`; esta spec exige que `knock.zona` quede fuera de la copia de seguridad (R-16) y la prueba del manifiesto de CA-15 lo comprueba, pero el valor final del manifiesto lo confirma una persona.
- **Riesgo:** el catálogo de códigos postales y colonias puede no coincidir con SEPOMEX; la app no valida contra una lista local, así que un CP mal capturado solo se detecta por la respuesta del servidor.
- **Pendiente de validar:** backend 017 (aprobada) dice que `PUT /api/v1/me` borra los campos opcionales omitidos; la app debe reenviar `fotoUrl` y no hay `ETag`/`If-Match` para evitar pisar un cambio hecho desde otro dispositivo. Se acepta como riesgo bajo (un solo dispositivo por persona en el piloto).
- **Resuelto en la revisión:** la lista de espera recibe `cp` y `municipio` opcional; la fecha la pone el servidor (backend 023 R-05 y R-06).
- **Pendiente de validar:** la forma de la respuesta de `GET /colonias/en-punto` (KNOCK-141) no está en ninguna spec de backend del Sprint 4; se toma la del contrato desplegado al vendorizar.
- **Duda abierta (para José):** ¿la zona se pide también a los técnicos o solo a los clientes? Esta spec la pide a cualquier cuenta que complete su perfil.

## Aprobación

- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-12
- [x] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
