# Memoria — knock-frontend

> Registro del proyecto: estado, decisiones con su fecha y su porqué, y errores a evitar. Los agentes la leen al empezar y agregan una entrada al terminar cada cambio. Sin datos sensibles.

## Estado actual
- Constitución `1.0.0` en borrador, `AGENTS.md`, subagentes y skills creados.
- 12 specs de la base (arquitectura, estructura del repositorio, infraestructura, rendimiento, observabilidad, versionamiento y seguridad) redactadas en **Borrador**; sus tareas **no se han ejecutado**.
- Sin código de producto todavía.

## 2026-11-11 — El CI de la app fija la versión de Flutter (KNOCK-263)
- **Decisión:** `ci-pr.yml` (job de la app) y `publish-android.yml` fijan `flutter-version: 3.47.9` junto a `channel: stable` en `subosito/flutter-action`. 3.47.9 es la última 3.47 y la que resolvía `stable` mientras el CI estaba en verde.
- **Porqué:** el 2026-11-11 a las 19:05 UTC salió Flutter 3.50.0 (Dart 3.14) y, con `channel: stable` sin versión, `flutter pub get --enforce-lockfile` empezó a fallar (código 65) en `sprint-04` y en todo PR que corre el job de la app, sin que cambiara ningún `pubspec`. Con 3.47.7 pasa en local. Causa probable: no se pudo confirmar con el log del job (GitHub devolvió 502).
- **Cuándo migrar a 3.50.0:** en una tarea aparte, regenerando `pubspec.lock`, corrigiendo lo que cambie con Dart 3.14 y actualizando la versión de `README.md` y `app/README.md` (hoy dicen 3.47.7).
- **A evitar:** dejar `channel: stable` sin versión en un workflow que usa `--enforce-lockfile`; migrar de versión de Flutter dentro de un PR de otra tarea.

## 2026-11-11 — `sprint-04` recibe de `develop` el arreglo de publicación a Play (KNOCK-221)
- **Decisión:** se trae `develop` a `sprint-04` con un merge normal. Lo único que faltaba era el PR #26 (KNOCK-221): `publish-android.yml` pasa `API_URL` (`vars.KNOCK_API_URL`) y la configuración de Firebase (secreto `GOOGLE_SERVICES_JSON`) al build de release de Android, con su nota en `docs/PUBLICACION_ANDROID.md`. Los otros tres commits de `develop` son merges de promoción sin cambios de archivos propios.
- **Porqué:** `sprint-04` salió antes de que el #26 entrara por `sprint-03`, así que su workflow de publicación estaba desactualizado respecto de `main` y `develop`.
- **A evitar:** publicar una versión desde `sprint-04` sin este arreglo; tocar `publish-android.yml` sin revisión del Tech Lead (archivo protegido).

## 2026-10-27 — Aclaración de «Uso de IA»
- **Decisión:** la sección «Uso de IA» es del **pull request** (plantilla de PR), no de cada spec.
- **Porqué:** `@constitution-reviewer` marcó FAIL a la spec 001 por leer «todo cambio» de forma literal; la redacción era ambigua.
- **A evitar:** copiar «Uso de IA» dentro de las specs para que pase una revisión.

## 2026-10-27 — Definición de la base
- **Decisión:** el repositorio se construye con SDD; la primera etapa solo define la base y no incluye funcionalidad.
- **Porqué:** así la arquitectura y la infraestructura quedan decididas y revisadas antes de escribir la primera línea de negocio.
- **A evitar:** empezar a codificar funciones antes de que la base esté aprobada.

## 2026-10-27 — Arquitectura
- **Decisión:** **Un repositorio con tres partes independientes:** `app/` (Flutter), `panel/` (Angular) y `landing/` (sitio estático), más `contracts/` con el OpenAPI del backend.
- **Porqué:** ver `specs/001-*/spec.md` (sección Decisiones) y `docs/descripcion-del-proyecto.md`.

## 2026-10-27 — Infraestructura y escalabilidad
- **Decisión:** **La infraestructura de la nube vive en `knock-backend`;** este repositorio consume la API por su contrato OpenAPI y no crea recursos de Azure.
- **Porqué:** ver las specs de infraestructura y escalabilidad y `docs/descripcion-del-proyecto.md`.

## 2026-11-03 — Alcance de ML e IA en la app
- **Decisión:** el aprendizaje automático (ML) no es prioridad. La IA generativa será una sola función sencilla en la app, solo si Azure ya da acceso al servicio; no se invierte más en ella. No hay base de grafos: MongoDB y Redis cumplen el requisito de NoSQL.
- **Porqué:** costo cero, tiempo hasta diciembre y la cuota de Azure OpenAI de la suscripción.
- **A evitar:** escribir que el ML «se quita»: es no prioritario, no eliminado.

## 2026-11-03 — Rulesets básicos
- **Decisión:** se definieron rulesets básicos de GitHub en `.github/rulesets/` (ramas `main` y `develop` y etiquetas de versión). El profesor dijo que compartiría los suyos en una imagen; no llegó.
- **Porqué:** que ambos repositorios queden protegidos igual desde el primer día. Las comprobaciones obligatorias del CI se agregan con el spec de CI/CD.
- **A evitar:** afirmar que se aplican: en una organización gratuita no se hacen cumplir en repositorios privados.

## 2026-11-03 — Ruleset de `main` alineado con las capturas del profesor
- **Decisión:** `main.json` copia las reglas de su ruleset «Main Proteccion»: no borrar, sin force push, pull request con 1 aprobación, métodos Merge/Squash/Rebase, regla de comprobaciones obligatorias (lista vacía hasta que exista el spec de CI/CD) y revisión automática de Copilot. Se conservan dos reglas más estrictas (aprobaciones descartadas con commits nuevos e hilos resueltos) y el rol de administrador como excepción, que en el ruleset del profesor no existe.
- **Porqué:** el profesor pidió cumplir a la letra; la imagen ya llegó y reemplaza los básicos provisionales de la entrada anterior.
- **Pendiente:** «Additional approval for unattributed Copilot pull requests» no está en el JSON (parámetro sin confirmar); `copilot_code_review` y la lista vacía de comprobaciones se escribieron sin validar la importación en GitHub.
- **A evitar:** afirmar que se aplican: en una organización gratuita no se hacen cumplir en repositorios privados.

## 2026-11-04 — Spec 013: MCP del proyecto
- **Decisión:** se escribe, en Borrador, la spec de MCP que pidió el profesor al final de la secuencia (RP-72 y RP-16). Jira con el MCP oficial de Atlassian (OAuth por persona, sin tokens en el repositorio), GitHub con la CLI `gh`, y solo lectura por defecto.
- **Porqué:** hoy el repositorio no tiene MCP configurado y el uso en el equipo es personal; sin spec no hay reglas de permisos ni de secretos.
- **Pendiente:** confirmar la dirección oficial y las herramientas del servidor de Atlassian al implementar; decidir si se usa MongoDB o el MCP de Dart; Figma queda descartado porque el equipo no lo usa.
- **A evitar:** guardar tokens en la configuración o permitir escritura en Jira desde un agente sin aprobación.

## 2026-11-04 — Revisión de todas las specs antes de la firma
- **Decisión:** se revisaron las specs de arquitectura y de endpoints con comprobaciones automáticas (cada requisito y criterio tiene tarea; valores como 15 minutos, 30 días, 10 sesiones y 5 minutos coinciden entre specs) y se corrigieron las diferencias: la región West US ahora está en la spec 005, el frontend define `deviceId` y la aceptación del aviso (spec 009), y las specs de MCP cubren todos sus requisitos con tareas.
- **Porqué:** el frontend y el backend se contradecían en el contrato de inicio de sesión, y una spec afirmaba una región que la otra no fijaba.
- **Pendiente (decide una persona):** `Idempotency-Key` (el frontend lo consume y el backend no lo define), el comportamiento ante 429 y `Retry-After`, y cancelar por `jti` o `sid`. Las specs siguen en Borrador: las firma una persona.
- **A evitar:** darlas por aprobadas sin leer las dudas abiertas de la sección 9.

## 2026-11-04 — Dudas de las specs resueltas
- **Decisión:** se resolvieron las dudas abiertas para poder aprobar: cancelar sesiones por `sid` (no `jti`), una sola colección `sesiones` (no `refresh_tokens`), 429 con `Retry-After`, `Idempotency-Key` fuera de esta etapa, colonia validada siempre contra Mercado (503 si no responde), 409 en eliminación programada, 404 para sesión ajena, y MCP de MongoDB y de Dart sin activar.
- **Porqué:** las dudas bloqueaban la aprobación de las specs de sesión y de seguridad; cada decisión quedó en la sección 9 de su spec con el motivo.
- **Pendiente:** actualizar la hoja de endpoints del Excel (sesión ajena: 404) y la constitución al fusionarlas (`sid` en lugar de `jti`); avisar a Guillermo del cambio de HU-001.
- **A evitar:** dar estas decisiones por firmadas: las aprueba una persona al aprobar cada spec.

## 2026-11-04 — Una revisión de pares obligatoria
- **Decisión:** cada PR necesita una revisión de otra persona y la segunda es opcional; el Tech Lead puede aprobar sus propios PR, y su revisión es opcional si es urgente o no hay nadie disponible (anota el motivo). Los rulesets dejan de descartar aprobaciones por commits nuevos y de exigir hilos resueltos.
- **Porqué:** dos revisiones frenaban el flujo con cuatro personas; el profesor tampoco las exige en su ruleset.
- **A evitar:** que un agente apruebe o fusione: sigue prohibido.

## 2026-11-04 — El guardián y el linter reconocen las specs numeradas (KNOCK-219)
- **Decisión:** `knock-guard` y `sdd_lint` aceptan las carpetas de spec numeradas (`001-tema`) además de las `HU-`, `TT-` y `BUG-`; `sdd_lint --trace NNN` busca los criterios `CA-NN` de la spec en las pruebas por nombre (`CA_006_01`, `'CA-006-01'` o `CA_01`).
- **Porqué:** el guardián no encontraba ninguna de las 13 specs y bloqueaba todo cambio en `app/` y `panel/`; el mismo arreglo ya se hizo en el backend (PR #7).
- **Pendiente:** la cabecera `> **Jira:** KNOCK-N` en las specs (hasta entonces, `KNOCK_SPEC=<número>`), y que `ci-pr.yml` y `branch_rules.py` acepten también las specs numeradas.
- **A evitar:** pasar `KNOCK_SPEC` con un prefijo corto (`00`): resuelve en silencio la primera spec que coincida.

## 2026-11-04 — Spec 005: validador de ramas y commits al día, pruebas y flujo documentado (KNOCK-219)
- **Decisión:** `scripts/ci/branch_rules.py` acepta los ámbitos que el equipo ya usa (landing, deploy y scripts, además de app, panel, ci, docs…; fuente única `.agents/knock.json`) y un título de PR con ID opcional (`KNOCK-N · <título>`, o con HU-, TT-, BUG-, B-NNN o F-NNN); los hooks de `.githooks/` quedan ejecutables; se agrega `scripts/ci/test_branch_rules.py` (CA-01, CA-04); el README explica cómo compilar y probar; CONTRIBUTING, la plantilla de PR y `.github/rulesets/README.md` documentan la revisión de par, la aprobación del líder y el motivo (CA-06).
- **Porqué:** con `ENFORCE_BRANCH_RULES=true` los títulos de PR sin ID de spec o con B-/F-NNN y los ámbitos reales habrían fallado; los hooks sin permiso de ejecución no corrían en Linux/macOS. Mismo arreglo que el backend (PR #9).
- **Pendiente:** CA-02 (sin revisión no se fusiona) no se puede hacer cumplir mientras la organización sea gratuita y los repositorios privados; la spec 005 (R-02) dice que las ramas salen de `develop`, pero el flujo real sale de `sprint-XX` (la edita José); activar `ENFORCE_BRANCH_RULES=true` solo cuando los commits abiertos cumplan el encabezado de 100 caracteres; las pruebas del validador aún no corren en el CI.
- **A evitar:** relajar la clave KNOCK-N o la prohibición de atribución a IA; activar `ENFORCE_BRANCH_RULES` antes de revisar las ramas abiertas.

## 2026-11-04 — MCP del proyecto implementado (spec 013, KNOCK-227)
- **Decisión:** se configura un solo servidor MCP, el oficial de Atlassian (`https://mcp.atlassian.com/v1/mcp/authv2`, remoto, OAuth por persona), para leer Jira. Los archivos de Claude Code (`.mcp.json`), OpenCode (`opencode.json`), Codex (`.codex/config.toml`), Gemini (`.gemini/settings.json`) y VS Code (`.vscode/mcp.json`) se generan con `scripts/sync_agents.py`; las herramientas de escritura (Jira, Confluence, Compass) quedan denegadas y solo las de lectura de Jira permitidas. La lista aprobada está en `docs/mcp.md`. Sin Figma, sin MCP de GitHub (se usa `gh`), sin MCP de bases de datos ni de Dart.
- **Porqué:** RP-72 y RP-16; una escritura equivocada en Jira es difícil de revertir y los tokens no deben llegar al repositorio.
- **Pendiente:** T-04 (probar la consulta a Jira con y sin sesión) la hace una persona con OAuth; hasta entonces CA-02 y CA-05 son parciales. VS Code no filtra herramientas por archivo: se desmarcan a mano. La dirección y las herramientas se confirman con la documentación oficial de Atlassian. Búsqueda de secretos: `gitleaks` no estaba instalado; se usó el patrón de `.gitleaks.toml` con grep y no hubo hallazgos (el CI corre gitleaks).
- **A evitar:** editar a mano los archivos generados, guardar tokens en la configuración o permitir herramientas de escritura sin aprobación de una persona.

## 2026-11-04 — Landing: estructura, enlaces en el CI y textos legales en borrador (spec 004, KNOCK-218)
- **Decisión:** `landing/` ya existía de TT-WEB-01 (nginx sin root, cabeceras, `railway.json`, versión `landing-v1.0.0`); se completó con la ruta reservada `/eliminar-cuenta/`, un borrador de `/privacidad/` (versión 0.1, `noindex`, aviso visible de «Borrador por revisar») que solo afirma lo que dicen las specs aprobadas, `landing/tests/check_links.py` y el job `landing` del CI (pruebas, enlaces rotos y Gitleaks sobre `landing/`). Todo dato que ninguna spec fija quedó como `[POR COMPLETAR POR JOSÉ: ...]`. José autorizó `.github/**` solo para esta tarea.
- **Porqué:** la spec 004 pide rutas reservadas y que el proceso revise enlaces y claves; el texto legal queda fuera de su alcance, pero Google Play necesita una URL de política de privacidad.
- **Pendiente:** publicar en Railway (pasos de José en `landing/README.md`) y verificar CA-01 y CA-02; completar los marcadores y pasar a «vigente» antes de dar la URL a Google Play; decidir si el job `landing` entra en `needs` de `gate` (no se tocó para no chocar con KNOCK-225); la spec dice rama principal y el README sigue en `develop` por la excepción de la constitución §9; la spec 004 no menciona `/privacidad/simplificado/` ni los términos.
- **A evitar:** dar el borrador como política vigente, inventar correo, razón social o plazos, y declarar `add_header` dentro de un `location` de nginx.

## 2026-11-04 — Versionamiento por puntos: cálculo, etiqueta y tabla (KNOCK-225)
- **Decisión:** `scripts/ci/version.py` calcula la versión `X.Y.Z` y el `versionCode` (`X × 1 000 000 + Y × 10 000 + Z × 100 + n`) de `app`, `panel` y `landing`, con pruebas `CA_011_NN` en `scripts/ci/test_version.py`; el job `pr-points` de `ci-pr.yml` exige una etiqueta `puntos-<componente>-N` (exentas `release-please--*` y `dependabot/*`) y entra en las dependencias del `gate`; la tabla de puntos está en `CONTRIBUTING.md` §9 y el registro, en `docs/VERSIONES_PUBLICADAS.md` (a mano).
- **Porqué:** la spec 011 manda un cálculo reproducible y que un PR sin puntos no pase; es la misma lógica del backend (KNOCK-207), con otros componentes y con `versionCode`. El acarreo es a 10 (como en el backend) porque la spec no da otro umbral.
- **Pendiente:** T-03 (integrar versión, `versionCode` y etiqueta de Git en la publicación; depende de KNOCK-221), así que CA-04 solo queda probado en el script. Reconciliar `docs/VERSIONAMIENTO.md` (primera versión `0.1.0`, `versionCode` = número de ejecución) con la spec 011 (`1.0.0`, `versionCode` derivado). Las etiquetas `puntos-*` no existen en el repositorio y las crea una persona con permiso. `sdd_lint.py --trace 011` marca FALTA hasta que `test_globs` de `.agents/knock.json` incluya `scripts/ci/test_*.py`.
- **A evitar:** llevar el `versionCode` a mano o repetirlo (Google Play rechaza la subida); declarar puntos de menos para no subir de versión.

## 2026-11-09 — La publicación a Google Play lleva la API y Firebase (KNOCK-221)
- **Decisión:** `publish-android` pasa `--dart-define=KNOCK_API_URL` desde la variable `KNOCK_API_URL` y escribe `google-services.json` desde el secreto `GOOGLE_SERVICES_JSON`; ambos son obligatorios y el archivo se borra al terminar.
- **Porqué:** sin ellos el AAB de la tienda compilaba sin URL de la API y sin Firebase: abría, pero no se podía entrar ni llamar al backend.
- **A evitar:** subir `google-services.json` al repositorio o dejarlo en la máquina de CI; escribir la URL fija en el código.

## 2026-11-05 — Contrato vendorizado y cliente Dart generado (spec 006, KNOCK-220)
- **Decisión:** se vendoriza en `contracts/openapi.v1.json` el contrato de **Identity** (`docs/openapi.identity.v1.json` de knock-backend, rama `sprint-03`, commit de la rama `d39bc18`, último commit del archivo `b6ddcf5`, SHA-256 `5767eb9d…`), no `docs/openapi.v1.json` del backend: ese archivo **no es la unión** de los servicios, es solo `Knock.Market.Api` (colonias y oficios). La app necesita hoy `POST /api/v1/auth/firebase`. Cuando el backend publique la unión (o el gateway), se reemplaza por ella.
- **Decisión:** el cliente Dart se genera con **openapi-generator-cli 7.27.0, generador `dart`** (serialización nativa y `package:http`, sin build_runner) en `app/packages/knock_api/`, con `python app/tool/generar_cliente_api.py` (`--check` para comprobar). El jar se descarga de Maven Central a `~/.cache/knock/` (o `KNOCK_TOOL_CACHE`) y se ejecuta solo si su SHA-256 coincide con el fijado en el script.
- **Porqué:** el generador no acepta OpenAPI 3.2 («attribute openapi is unexpected»); el script normaliza en memoria a 3.1.0 con dos reglas mecánicas (versión y uniones `[null, integer, string]` de ASP.NET → `[null, integer]` sin `pattern`; cualquier otra unión detiene la generación). Sin esa regla `ProblemDetailsStatus` salía vacío y no compilaba. `dart` se prefirió a `dart-dio` porque no exige build_runner ni código `.g.dart` y deja un resultado determinista. El script también quita los `// ignore:` que escribe el generador, porque `scripts/ci/check_exceptions.py` solo exime `app/lib/l10n/generado/` (el paquete está excluido del analizador).
- **R-04 sin tocar `.github/`:** el script escribe `app/packages/knock_api/.knock-manifest.json` (SHA-256 del contrato y de cada archivo); `app/test/api/cliente_generado_test.dart` lo compara en cada `flutter test`, que el CI ya corre. Para la regeneración completa, el líder debe agregar al workflow `python app/tool/generar_cliente_api.py --check` (necesita Java 11+) y `python -m unittest app/tool/test_generar_cliente_api.py`.
- **Red de la app:** `lib/core/red/` (`clienteApiProvider`, `authApiProvider`, `transporteHttpProvider`, `urlApiProvider`, `llamarApi`/`mapearErrorApi`). URL base por `--dart-define=KNOCK_API_URL=...` (solo `https`, o `http` a `localhost`/`127.0.0.1`/`10.0.2.2`). Errores → `Failure` tipados en `core/errores/failure.dart` (401, 403 `account_suspended`, 409, 400/413/422, 429, red y 5xx).
- **Dependencias evaluadas (versión fija):**
  - `http 1.6.0` (dart.dev, BSD-3-Clause; mantenido por el equipo de Dart; sin avisos en OSV): transporte del cliente generado.
  - `crypto 3.0.8` (dev; dart.dev, BSD-3-Clause; sin avisos en OSV): SHA-256 del manifiesto en la prueba.
  - `openapi-generator-cli 7.27.0` (herramienta, no entra a la app; Apache-2.0; OpenAPITools, publicaciones mensuales; jar de Maven Central verificado por SHA-256/SHA-1). El código generado depende de `collection`, `intl` y `meta` (dart.dev, BSD-3), ya presentes por Flutter.
- **Pendiente:** cliente TypeScript del panel (T-03); cablear el `--check` en el CI (lo hace el líder); los nombres de operación salen feos (`apiVversionAuthFirebasePost`) porque el contrato no trae `operationId`: pedirlo al backend.
- **A evitar:** editar `contracts/` o `app/packages/knock_api/` a mano; vendorizar `docs/openapi.v1.json` creyendo que es la unión; subir el generador sin cambiar su SHA-256 fijado.

## 2026-11-05 — Registro e inicio de sesión conectados (KNOCK-228)
- **Decisión:** se reutiliza el diseño aprobado en persona de la rama de KNOCK-43 (pantallas «Escribe tu celular» y «Escribe el código», validación de 10 y 6 dígitos, cuenta regresiva y redirect a `/entrar`) y se conecta: Firebase Phone Auth envía y verifica el SMS, el ID token se canjea con el cliente generado en `POST /api/v1/auth/firebase` y los tokens van a `flutter_secure_storage`. La lógica vive en `lib/core/sesion/` (sesión compartida por toda la app) y la feature `entrada` solo tiene validación, controlador y pantallas, así `arquitectura_entrada_test.dart` (sin `knock_api` ni almacenamiento en la feature) sigue igual.
- **Porqué:** el líder pidió que la app consuma la API desplegada el 2026-11-05; el canje es el contrato de la spec 015 del backend.
- **Spec:** KNOCK-228 no tiene spec propia en este repositorio; se trabajó con `KNOCK_SPEC=006` por autorización del líder. Se relaciona con las specs 001 y 006 y con B-015/B-016 del backend. **El líder debe decidir la spec de la tarjeta.**
- **Firebase sin configuración:** `google-services.json` no existe todavía (lo entrega el líder; está en `.gitignore`). Gradle aplica `com.google.gms.google-services` 4.5.0 solo si el archivo existe; `iniciarFirebase()` devuelve `false` si falla y la entrada muestra un mensaje claro. Fuera de un teléfono (escritorio, `flutter test`) no se inicia Firebase ni se lee el almacenamiento seguro. Se declara `INTERNET` en el manifiesto principal (release).
- **Privacidad:** `dispositivo` es solo «Android» o «iOS» (el nombre del teléfono puede llevar el nombre de la persona); `deviceId` es un UUID v4 en almacenamiento seguro; `SesionEmitida.toString()` y `SolicitudCodigo.toString()` no muestran tokens ni celular; nada se registra.
- **Dependencias evaluadas (versión fija; OSV sin avisos el 2026-11-05):**
  - `firebase_core 5.1.0` y `firebase_auth 7.0.1` (FlutterFire, Google; BSD-3-Clause; publicaciones frecuentes): SMS y verificación del celular. Traen `_flutterfire_internals` y los paquetes de plataforma de FlutterFire (BSD-3).
  - `flutter_secure_storage 11.2.0` (BSD-3-Clause; mantenido, millones de descargas): tokens en Keystore/Keychain. Trae `path_provider`, `jni_flutter` y `objective_c` (dart.dev/flutter.dev, BSD-3).
  - `uuid 4.5.3` (MIT; ya estaba en el lockfile como transitiva): `deviceId`.
  - Plugin de Gradle `com.google.gms.google-services 4.5.0` (Google, Apache-2.0): solo se aplica con el archivo de configuración.
- **Pendiente:** el archivo de Firebase y el SHA-1 en la consola; renovar el token y cerrar sesión (spec 016, B-016) e interceptor de 401; completar el perfil cuando `perfilCompleto = false` (spec 017); probar el recorrido real en el emulador con un número de prueba de Firebase; compilar el APK de depuración (no se compiló aquí por espacio en disco); los E2E de `integration_test/` usan una entrada ficticia.
- **A evitar:** guardar tokens en `shared_preferences` o en registros; mandar el nombre del teléfono en `dispositivo`; crear un `google-services.json` inventado; pedir el SMS sin el aviso aceptado.
## 2026-11-05 — Integración continua y publicación en Google Play (spec 007, KNOCK-221)
- **Decisión:** la detección de cambios por carpeta y el resultado del `gate` pasaron del YAML a `scripts/ci/detect_changes.py` y `scripts/ci/gate.py`, con pruebas `CA_007_01` y `CA_007_02`; el job `landing` entra en `needs` del `gate`; `.github/workflows/publish-android.yml` construye el AAB firmado y lo sube a la pista **interna** solo desde `main` y con `ci-pr` en verde; `scripts/ci/publish_info.py` calcula `versionCode` y número de subida `n` a partir de las etiquetas `app-vX.Y.Z-nN`; `app/android/app/build.gradle.kts` firma con la llave de subida si llegan `KNOCK_KEYSTORE_*` y con la de depuración si no; `_governance.yml` corre ahora las pruebas de `scripts/ci/`. Pasos y secretos en `docs/PUBLICACION_ANDROID.md`.
- **Porqué:** la spec pide los checks por carpeta, el paquete firmado y la publicación por etapas; sin extraer la lógica no había nada que probar con CA-01 y CA-02, y `scripts/ci/test_*.py` no corría en ningún job. ACR Tasks no está permitido en la suscripción, así que nada del flujo usa `az acr build`.
- **Pendiente:** CA-03 solo se comprueba ejecutando el workflow con los secretos y la cuenta de Google Play (`ANDROID_KEYSTORE_*`, `PLAY_SERVICE_ACCOUNT_JSON`, `MAPS_API_KEY`; cuenta y ficha son de KNOCK-52 y KNOCK-230); la prueba cerrada y producción se promueven a mano en Play Console (R-06); sumar los puntos de los PR para subir `X.Y.Z` automáticamente (T-03 de la spec 011) sigue manual: hoy la versión sale de `app/pubspec.yaml`; `sdd_lint --trace 007` marca FALTA mientras `test_globs` de `.agents/knock.json` no incluya `scripts/ci/test_*.py`; el estado de la spec y las tareas de `task.md` los actualiza José; si la app sigue en borrador en Play Console, la subida puede pedir `status: draft`.
- **A evitar:** publicar con la llave de depuración, escribir un secreto dentro de un `run:`, repetir un `versionCode` y dar una acción de terceros sin fijar por SHA.

## 2026-11-05 — Arquitectura del panel web (KNOCK-217, spec 003)
- **Estado:** el panel ya compila en modo estricto, con rutas diferidas (un `chunk` por función), reglas de lint de frontera (sin `HttpClient` en componentes, sin `innerHTML` ni `bypassSecurityTrust*`), `noindex` y publicación en Railway con Dockerfile y Caddy (CSP y demás encabezados verificados con `curl` sobre la imagen). Documentado en `docs/arquitectura-panel.md`.
- **Decisión:** el build desactiva `inlineCritical` de los estilos porque el script en línea que genera Angular lo bloquearía la CSP (`script-src 'self'`) y la página quedaría sin estilos.
- **Pendiente:** el acceso del personal autenticado (R-03) y el doble factor dependen de un inicio de sesión del panel que la spec deja fuera; sin él no se debe agregar ninguna función con datos. La prueba de humo con Playwright (spec §7) no se hizo. Falta la publicación real en Railway (la hace quien aporta el espacio).
- **A evitar:** servir el panel sin los encabezados de `Caddyfile`; importar `HttpClient` fuera de un servicio.

## 2026-11-05 — Propuesta de textos legales de la landing (KNOCK-218)
- **Decisión:** `/privacidad/` y `/eliminar-cuenta/` pasan de 15 huecos a un texto propuesto con valores típicos de un proyecto escolar mexicano: derechos ARCO con respuesta en 20 días hábiles, registros técnicos de 30 días, edad mínima de 18 años, eliminación con 7 días de plazo y copias de seguridad de hasta 30 días; el nombre legal, el domicilio y el correo de contacto no se inventan y quedan como `[... POR CONFIRMAR]`. Siguen en borrador, versión 0.1 y `noindex`.
- **Porqué:** Google Play pide una URL de privacidad y una de eliminación de cuenta, y los datos legales los decide el responsable del proyecto; el texto sale del diseño del proyecto (descripción, decisión técnica, HU-006 y HU-055), no solo de specs aprobadas.
- **Pendiente:** José confirma cada decisión legal, el nombre legal, el domicilio y el correo, y que la aplicación haga lo que el texto dice (eliminación con SMS y 7 días, descarga de datos en 48 horas, borrado de fotos de verificación a los 7 días; la descripción de funciones habla de 30 días y la decisión técnica de 7); después pasa el estado a `vigente`, sube la versión y quita el aviso y el `noindex`. Un abogado debe revisar los textos antes de un lanzamiento real.
- **A evitar:** publicar la URL en Google Play mientras el estado siga en `borrador`, o poner un correo o una razón social que nadie haya confirmado.

## 2026-11-05 — Textos legales vigentes de la landing (KNOCK-218)
- **Decisión:** `/privacidad/` y `/eliminar-cuenta/` pasan de borrador 0.1 a vigente 1.0: responsable José Julián Hernández Hernández (Alonso de Borja 92, colonia Aviación, C.P. 42506, Actopan, Hidalgo) y correo de contacto `soporte@tdevs.com.mx`, en texto y no como `mailto:` porque las pruebas cuentan cualquier esquema como enlace externo; se quitan el aviso de borrador y el `noindex`, y `test_legal_y_enlaces.py` ahora exige el estado vigente.
- **Porqué:** José dio los datos que faltaban y pidió publicar y cerrar KNOCK-218 antes de la clase; la URL de privacidad es lo que pide Google Play (KNOCK-230).
- **Pendiente:** confirmar el domicilio (el estado «Hidalgo» se dedujo del C.P. 42506), la revisión legal antes de dar la URL a Google Play, que la aplicación cumpla lo que el texto promete (eliminar con «ELIMINAR» o SMS en 7 días, descarga de datos en 48 horas y fotos de verificación destruidas a los 7 días), publicar en Railway y la revisión de par de Erick.
- **A evitar:** dar por vigente un texto legal que describe funciones que la app todavía no tiene, o dejar un domicilio personal en un sitio público sin que su dueño lo haya confirmado.

## 2026-11-05 — Pruebas de arquitectura de la app móvil (KNOCK-215, spec 001)
- **Decisión:** `app/test/arquitectura/capas_test.dart` verifica en todas las funciones de `lib/features/` que `domain/` no importe Flutter, Riverpod, dio, http, `knock_api` ni `dart:ui`/`dart:io`, y que `presentation/` no importe `data/`; también prueba que la regla detecta un caso malo (CA_001_02). `navegacion_test.dart` cubre CA_001_03. Se corrigió la única violación real: `ubicacionRepositoryProvider` pasó de `inicio/data/` a `inicio/inicio_providers.dart` (raíz de composición, igual que `oficios_providers.dart`) y `mi_ubicacion_controller.dart` ya no importa `data/`.
- **Porqué:** R-03 y R-06 exigían pruebas de capas en todo el código y solo `oficios` las tenía; Inicio se saltaba la regla.
- **Pendiente:** el estado de pantalla de cuatro tipos (R-05) sigue sin un tipo común (oficios usa `AsyncValue`); falta `docs/arquitectura-app.md` (T-06); reiniciar controladores al cerrar sesión depende de la sesión real.
- **A evitar:** declarar el `Provider` de un repositorio dentro de `data/` y leerlo desde `presentation/`; los providers van en `<funcion>_providers.dart`.

## 2026-11-05 — Gitleaks en los PR de Erick: huella del token ficticio (EXC-004, KNOCK-223)
- **Decisión:** `.gitleaksignore` en la raíz con una sola huella, `8735cb22dc6095acc63cccea48ad253f6688f589:app/test/core/sesion/sesion_segura_test.dart:generic-api-key:20`, y una segunda, `1d73fc5454410e9de7ebf0faea441ea3a43d8d81:security/exceptions.yaml:generic-api-key:69`, porque el primer texto de EXC-004 copió el literal del token y Gitleaks lo detectó en ese commit ya publicado; el texto vigente no lo copia. Excepción EXC-004 en `security/exceptions.yaml` (vence 2027-02-03).
- **Porqué:** la constante ficticia de una prueba de sesión es ficticio, pero Gitleaks recorre el historial de todas las ramas (`fetch-depth: 0`), así que cambiarlo en un commit nuevo no quita el hallazgo del commit 8735cb2 y ese único check mantenía en rojo los PR #14 al #21. No se reescribe el historial ni se hace force-push. Comprobado con gitleaks v8.30.1 (imagen oficial) sobre un clon con esa rama: 1 hallazgo sin el archivo, 0 con él.
- **A evitar:** ampliar `.gitleaksignore` con comodines o con más huellas sin su propia excepción, o poner tokens con aspecto de llave en las pruebas; usar valores cortos o claramente no secretos.

## 2026-11-05 — Piezas comunes de la app: sesión, errores, tema y caché (spec 002, KNOCK-216)
- **Decisión:** ya existían el cliente generado (spec 006), el tema claro y oscuro, los ARB es/en y las preferencias; se agregó lo que faltaba: `core/sesion/` (`SesionNotifier`, `ClienteAutenticado`: pone el token, ante 401 renueva una sola vez para todas las peticiones simultáneas y repite; si la renovación falla cierra la sesión), `core/red/cache_respuestas.dart` (`CacheRespuestas` y `ClienteConCache`: GET con `If-None-Match`, 304 entrega lo guardado, vigencia de 5 minutos, solo en memoria, se vacía al cerrar e iniciar sesión) y `core/errores/mensaje_failure.dart` (`mensajeDeError` traduce cada `Failure` con 10 textos nuevos `error*` en los ARB; un error que no es `Failure` cae en el mensaje genérico). `transporteApiProvider` encadena caché, sesión y `transporteHttpProvider`, y es el que usa `clienteApiProvider`. Pruebas `CA-002-01` a `CA-002-04`; `sdd_lint --trace 002` en OK.
- **Porqué:** la spec pide token en cada petición, renovación, mensajes comprensibles, tokens del tema oscuro y caché vacía tras el cierre de sesión; nada de eso tenía código ni prueba (solo el mapeo de errores a `Failure`).
- **Pendiente:** el endpoint de renovación no existe en el contrato: `renovadorSesionProvider` usa `RenovadorNoDisponible` (toda renovación falla y cierra la sesión) y las pruebas usan un doble; hay que conectar el renovador real cuando el backend lo publique. Los tokens están en memoria (`AlmacenTokensEnMemoria`); el almacenamiento seguro del sistema es de la spec 009 y la caché en disco no se hizo. Falta quien llame a `SesionNotifier.iniciar` tras el canje de Firebase (pantalla de acceso, otra spec) y las pantallas que usen `mensajeDeError`. No se cubre el registro del detalle sin datos personales de la §6. `docs/architecture/*` se regeneró con `scripts/codemap.py` y puede chocar con otros PR: volver a correrlo tras fusionar.
- **A evitar:** guardar tokens en `shared_preferences`, reintentar un 401 más de una vez, conservar la caché al cambiar de cuenta y mostrar `toString()` o el cuerpo de una respuesta a la persona.

## 2026-11-05 — Calidad, pruebas y estándares de la app (spec 008, KNOCK-222)
- **Decisión:** `app/analysis_options.yaml` suma 14 reglas estrictas (`discarded_futures`, `avoid_slow_async_io`, `avoid_type_to_string`, `prefer_final_fields`, `use_super_parameters`, `use_key_in_widget_constructors`, `unnecessary_statements`, etc.) sin hallazgos nuevos. Se agrega `test/soporte/accesibilidad.dart` (`expectAccesible`: etiqueta semántica y 48 dp) y `test/calidad/` con pruebas `CA_008_01..03`: guardas de la configuración del analizador y del CI, el script `check_coverage.py` rechaza menos del 50 % y acepta el 50 %, y la prueba de accesibilidad falla ante un botón sin etiqueta o menor a 48 dp. Convención: archivos `*_test.dart`, y el nombre de una prueba de criterio empieza con `CA_NNN_KK`.
- **Porqué:** CA-01 y CA-03 los hace cumplir el CI (`flutter analyze --fatal-infos --fatal-warnings` y `check_coverage.py --min 50`); sin pruebas que vigilen esa configuración, bajar el umbral o quitar una regla pasaría sin que nada fallara (amenaza §6 de la spec). Los `unnecessary_await_in_return` y `avoid_returning_null_for_future` están obsoletos o eliminados en Dart 3.13, por eso no se activan.
- **Pendiente:** ESLint/Prettier y cobertura del 60 % del panel; `directives_ordering`, `require_trailing_commas` y `prefer_single_quotes` (tocan decenas de archivos); estados cargando/datos/vacío/error solo existen en oficios; cada pantalla nueva debe llamar a `expectAccesible`; la prueba de integración con un PR de prueba (spec §7); T-06 (definición de terminado en docs).
- **A evitar:** bajar el umbral del 50 % o apagar una regla para que pase el CI; dar por cubierto un criterio con una prueba que no falla cuando la lógica está mal.

## 2026-11-05 — Seguridad y configuración del cliente (spec 009, KNOCK-223)
- **Decisión:** `core/sesion/` gana `AlmacenSeguro` (interfaz + doble en memoria), `AlmacenSesion` (guarda y borra solo los tokens al cerrar sesión), `IdentificadorDispositivo` (UUID v4 con `Random.secure`, validado al leer, conservado al cerrar sesión) y `PrepararCanje` (lanza `AvisoNoAceptadoFailure` antes de generar nada o llamar). `core/red/espera_por_limite.dart` es un `http.BaseClient` que, ante un 429, guarda el `Retry-After` (segundos o fecha, tope 1 h, 30 s por omisión), lanza `DemasiadosIntentosFailure(espera)` y no deja salir peticiones mientras dure; `mapearErrorApi` conserva un `Failure` envuelto en `innerException`. El manifiesto principal declara ahora `INTERNET`. Pruebas `CA_009_01` a `CA_009_06` en `test/seguridad/`, `test/core/sesion/` y `test/core/red/`.
- **Porqué:** la spec exige token fuera de preferencias legibles, `deviceId` aleatorio estable, no llamar sin aviso aceptado y obedecer `Retry-After`; el cliente generado no expone cabeceras, así que la espera se aplica en el transporte. Sin `INTERNET` en `main` el AAB firmado no abre conexiones.
- **Pendiente:** el adaptador sobre `flutter_secure_storage` y su cableado en `main.dart` llegan con KNOCK-228 (hasta entonces `almacenSeguroProvider` es memoria); pantalla del aviso y textos ARB (aviso no aceptado, tiempo de espera); el job de secretos del CI sigue siendo la comprobación real de CA-01 (la prueba local solo busca patrones); decidir `allowBackup`.
- **A evitar:** guardar tokens o el `deviceId` en `shared_preferences`, usar IMEI/ANDROID_ID como `deviceId`, reintentar en bucle tras un 429, `print`/`debugPrint` en `app/lib`, `badCertificateCallback` o URL `http://` fijas.

## 2026-11-05 — Caché de oficios con ETag y aviso sin conexión (spec 010, KNOCK-224)
- **Decisión:** nuevo `core/cache/`: `AlmacenCache` (memoria o `AlmacenCacheShared` sobre shared_preferences, claves `knock.cache.*`), `RevalidadorEtag` (vigencia; al vencer pide con `If-None-Match`; 304 renueva sin descargar; sin red o 5xx usa lo guardado) y lista blanca de claves cacheables (`catalogo/`, `perfil/`, `reciente/`, `imagen/`) que rechaza las listas personales (R-04). `GET /api/v1/oficios` se consume con `OficiosRepositoryApi` (vigencia 10 min) cuando hay `KNOCK_API_URL`; sin ella siguen los datos de prueba. La pantalla muestra primero lo guardado, luego lo nuevo, y una franja «Sin conexión» con Reintentar.
- **Porqué:** el contrato vendorizado no trae `/oficios`, así que se usa `package:http` con el transporte de la app y `OficioMapper`. SQLite y la cola de envío exigen una dependencia nueva y un endpoint de envío que no existe; se dejaron fuera en vez de simularlos. Se usó shared_preferences (ya presente) como mínimo verificable; por eso la regla de arquitectura admite `core/cache/` además de `core/preferencias/`.
- **Pendiente:** cola de envío con identificador único (CA-02, CA-04, R-07, R-08) con SQLite; borradores (R-06); imágenes en caché; cablear `AlmacenCacheShared` en `main.dart`; llamar `borrarCacheLocalProvider` al cerrar sesión (CA-03) y borrar también la base local; comprobar que el gateway emite ETag/304; mover la llamada al cliente generado cuando el contrato incluya oficios. `sdd_lint --trace 010` da CA-04 FALTA y CA-02 como falso positivo.
- **A evitar:** guardar en caché listas personales o tokens; dejar `AlmacenCache` en memoria en producción creyendo que persiste; dar por probado el 304 contra la API real (solo se probó con servidor simulado).

## 2026-11-05 — Notificaciones push y permisos del teléfono (spec 012, KNOCK-226)
- **Decisión:** la parte verificable sin Firebase queda detrás de puertos. `core/notificaciones/` tiene `ServicioNotificaciones` (identificador, borrado y toques; por defecto `ServicioNotificacionesNoDisponible`), `RegistroDispositivosRepository` (SIMULADO en memoria: el endpoint no existe), `RegistroDispositivoController` (registra solo con el permiso concedido; al cerrar sesión desregistra y siempre invalida el identificador en el teléfono, aunque el servidor falle), `CargaNotificacion` (`tipo`, `destino` por nombre y `conversacion`; una ruta o un tipo inventados se ignoran y un destino ausente cae en la pantalla natural del tipo), `abrirPantallaDesdeNotificaciones` (una línea en `app_router.dart`; respeta el `redirect` por rol), `revisarTextoDeNotificacion` (R-03, heurística de códigos y direcciones) y los avisos elegidos (`avisosProvider`, `debeMostrarNotificacionProvider` con el modo chat en vivo). `core/permisos/` tiene `PermisoApp` (solo notificaciones y ubicación; sin contactos), `GestorPermisos` (por defecto nunca concede) y `explicarPermiso` (aviso previo con «Continuar» y «Ahora no»). Las preferencias de avisos viven en `core/preferencias/almacen_avisos.dart` (`AlmacenAvisos`, implementado por los dos almacenes existentes: `main.dart` no cambia y `shared_preferences` sigue solo en `core/preferencias/`). `SeccionAvisos` va en Configuración y `SelectorDeZona` (ubicación o código postal de 5 dígitos) en `features/inicio`.
- **Porqué:** `firebase_messaging` y el paquete de permisos exigen `google-services.json`, el plugin de Gradle y `POST_NOTIFICATIONS` en el manifiesto, que comparte archivo con el inicio de sesión (KNOCK-228). Detrás de interfaces, la lógica de la spec (CA-01 a CA-05) se prueba con dobles y el adaptador real es un cambio aislado. Configuración pasó de `ListView` a `SingleChildScrollView` con `Column` porque, con la sección nueva, un `ListView` perezoso no construía las opciones fuera de pantalla y rompía las pruebas de HU-052.
- **Pendiente:** adaptadores reales de FCM y de permisos (con `POST_NOTIFICATIONS`; actualizar la prueba de manifiesto de KNOCK-223, que solo admite `ACCESS_COARSE_LOCATION` e `INTERNET`); endpoint de registro de dispositivos y su cliente generado; que el inicio y el cierre de sesión llamen a `alIniciarSesion` y `alCerrarSesion` (KNOCK-228) y que el chat fije `conversacionAbiertaProvider`; enviar al backend los avisos apagados; montar `SelectorDeZona` cuando exista la búsqueda por zona; textos genéricos de respaldo cuando se rechaza un texto; reintento al renovarse el identificador; prueba con una notificación real en dispositivo.
- **A evitar:** poner texto, códigos, direcciones o rutas en la carga de la notificación (lleva nombres de destino, no rutas); dejar el identificador registrado al cambiar de cuenta; pedir un permiso sin la explicación previa; añadir un permiso de contactos; imprimir el identificador (el estado `Registrado` no lo muestra).

## 2026-11-05 — Pantallas posteriores al primer ingreso (KNOCK-229)
- **Decisión:** se arman completar perfil (`/completar-perfil`, fuera de la barra), Inicio (saludo, tarjeta «Tu zona» con la colonia y acceso a oficios), Explorar → Oficios y Mi cuenta (perfil con iniciales, Configuración, Cerrar sesión con confirmación). El perfil y el cierre de sesión son **simulados** en memoria (`PerfilRepositorySimulado`, `GET/PUT /me` y `logout` no existen); oficios y colonia llaman a la API real con `--dart-define=KNOCK_API_URL` (`core/red/obtener_json.dart`) y, sin URL, usan datos de prueba. Con el perfil sin nombre el router manda a completar perfil; cerrar sesión deja la cuenta como nueva y reinicia colonia, oficios y modo técnico.
- **Porqué:** el contrato vendorizado es solo Identity y `contracts/` y `knock_api` están protegidos, así que oficios y colonias no están en el cliente generado; se reutilizan el transporte y `mapearErrorApi`. Para la demo hacía falta recorrer el flujo sin esperar a la API ni al login de KNOCK-228.
- **Pendiente:** cambiar `perfilRepositoryProvider` cuando existan `GET/PUT /me` y `logout`; mandar el token (`colonias/en-punto` da 401 sin sesión); apuntar el redirect de perfil pendiente y Cerrar sesión a la pantalla de login de KNOCK-228; foto de perfil y zona por código postal; pasar a ARB los textos de completar perfil y oficios; definir la spec de estas pantallas.
- **A evitar:** dejar `PerfilRepositorySimulado` en una compilación de tienda sin sesión real; guardar o registrar las coordenadas de la consulta de colonia.

## 2026-11-09 — Specs del Sprint 4 en borrador (KNOCK-243)
- **Decisión:** se proponen las specs 015 a 025 (pedir y comparar cotizaciones, visita con código, zona por ubicación, verificación de identidad, pestaña Trabajo, mi actividad y conversaciones, búsqueda de expertos, avisar a alguien de confianza, panel web interno, notificaciones de la cadena de solicitudes y cancelar o ver el vencimiento). La 014 sigue reservada para alinear la UI con la maqueta. Todas quedan en Borrador hasta que una persona las apruebe. Decisiones de revisión por confirmar: el aviso a un contacto de confianza no incluye el código de la visita; las fotos de una solicitud son privadas y se envían como identificadores de archivo.
- **Porqué:** cada pantalla queda atada a endpoints de las specs de backend, con sus estados, mensajes, accesibilidad y pruebas previstas.
- **A evitar:** implementar una pantalla cuyo endpoint no tiene spec aprobada; copiar a la app reglas de negocio que deben vivir en el servidor.

## 2026-11-10 — Spec 021 de la app: 422 para el texto inválido y códigos en inglés (KNOCK-243)
- **Decisión:** la búsqueda trata el texto `q` inválido como 422 con `errors.q` (antes 400) y usa los códigos `invalid_cursor` (400), `colonia_not_found`, `trade_invalid` (422) y `search_unavailable` (503), según la convención de errores propuesta para la spec 002 (422 para validación de campos, 400 para lo ilegible, códigos en inglés).
- **Por qué:** backend 027 responde 422 para `q` y la app esperaba 400; con la convención nueva coinciden. Los códigos de backend 027 siguen en español en el borrador y deben renombrarse igual antes de aprobarse.
- **A evitar:** aprobar la 021 de la app mientras la 027 de backend use otros nombres de código.
## 2026-11-09 — Alinear la UI con la maqueta (spec 014, KNOCK-242)
- **Decisión:** el cambio es solo visual. Tipografía: se agregan `Nunito-ExtraBold.ttf` (800) y `Nunito-Black.ttf` (900); salen de la fuente variable oficial `Nunito[wght].ttf` de google/fonts (versión 3.602, la misma de los cuatro TTF que ya había) instanciada con `fonttools varLib.instancer`, no de la carpeta `static` de la descarga; la prueba `CA_014_01` lee el `usWeightClass` de cada TTF. Tokens en `core/tema/tokens.dart` (radios, alturas, espaciado, sombras de `knock.css`) y `ColoresKnock` (`ThemeExtension` con navy-soft, amber-soft, navybg y línea, cada fondo con su texto ya validado; `context.colores` cae a los valores por brillo si el tema no es el de Knock). Botones, campos, barras, hoja y tarjeta se configuran en `ThemeData`; widgets nuevos solo `TarjetaKnock`, `GrupoDeFilas`/`FilaKnock` (sobre `ListTile`) y `EstadoKnock`. Migradas: celular, código, completar perfil, Inicio, Explorar, Actividad (estado vacío), Oficios y Mi cuenta (Cerrar sesión pasa a hoja inferior con los mismos textos); la barra inferior solo cambia de estilo.
- **Porqué:** la maqueta usa 800 y 900 en casi todo y la app tenía hasta 700; `flutter` no carga `woff2`. Donde `knock.css` choca con las reglas de contraste gana la app: el contorno de los campos usa `outline` (≥ 3:1, no la línea de 1.2:1), los botones sin relleno siguen en `amber-ink` en claro (lo fija `contraste_test.dart`, la maqueta los pone azules), el botón relleno conserva su borde de tinta en claro y en oscuro sobre `navybg` va `ink`, no blanco. El logo `Knock.png` es RGB sin canal alfa y pesa 827 KB, así que se dejó el ícono provisional (spec §9, decisión 3). Los íconos siguen siendo Material.
- **Pendiente:** CA-09 (comparación con capturas P01, P06, P07, P11 y P20 en un teléfono físico, en claro y en oscuro) no tiene verificación automática y falta decidir cómo se comprueba; el logo real exige un PNG con transparencia o `flutter_svg`; la barra inferior no tiene la píldora exacta de 56 × 30 (Material 3 fija 64 × 32); `app_shell.dart` está en `core/router/` y CA-07 lo excluye por nombre porque la decisión 7 lo incluye. Dos pruebas de `seguridad_cliente_test.dart` fallan en esta máquina por un `android/app/google-services.json` local que no está en el repositorio; no se tocó.
- **A evitar:** poner `Color(0x…)` o `Colors.x` fuera de `core/tema/` (lo vigila `tema_oscuro_test.dart`), un fondo con color sobre un `ListTile` (oculta su tinta: por eso `TarjetaKnock` separa la sombra del fondo), alturas fijas en lugar de mínimas (rompen el texto al 200 %) y dar por cubierto un caso porque `sdd_lint --trace` dice OK: con la spec 014 sin código ya marcaba OK CA-01 a CA-04 porque busca `CA_01` como subcadena en cualquier prueba.

## 2026-11-10 — Conectar la app con la API real (spec 026, KNOCK-248)
- **Decisión:** perfil, cierre de sesión, colonias y sesiones por dispositivo usan la API real. Un solo almacén de tokens: el seguro (`AlmacenSesion`), leído en `main.dart` (`tokensInicialesProvider`) y registrado por `ServicioEntradaReal` al canjear (`SesionNotifier.iniciar`); `SesionNotifier.cerrar` borra tokens y caché y pone `sesionIniciadaProvider` en falso (el router lleva a `/entrar`). `ClienteAutenticado` pone el Bearer solo hacia la URL de la API y solo en `me`, `auth/logout` y `colonias/…` (sin sesión no sale la petición: `NoAutorizadoFailure`), renueva con `RenovadorSesionApi` (`POST /auth/refresh` por el transporte público) en un solo vuelo y repite una vez; solo 400 y 401 del refresh o un segundo 401 cierran la sesión, red, 429 y 5xx la conservan; el `logout` no se renueva ni se repite. `core/red/enviar_json.dart` (POST, PUT y DELETE) comparte el mapeo de errores con `obtenerJson` y deja pasar los `Failure` del transporte (429 con `Retry-After`). `PerfilRepositoryApi` usa `ClienteConCache` para el ETag y reenvía foto, colonia y código postal del último perfil en el `PUT`; `SesionesRepositoryApi` es solo capa de datos (404 = ya cerrada, 409 = `ConflictoFailure`). `usaApiReal` elige real o simulado: una compilación `release` sin `KNOCK_API_URL` válida falla en `arrancar()` con `ApiNoConfiguradaFailure`.
- **Porqué:** la demo debía consumir el backend ya desplegado; hasta aquí ninguna petición llevaba token (dos almacenes distintos), `colonias/en-punto` daba 401 y cerrar sesión no regresaba al login. El refresh rota el token y reusarlo cierra todas las sesiones de la cuenta, de ahí el vuelo único y guardar los tokens antes de reintentar.
- **Decisiones de implementación (a revisar):** `colonias/en-punto` no pasa por la caché (`ClienteConCache.sinCache`), así que sus coordenadas no quedan en ninguna llave (precisión de José). Riverpod conserva el valor anterior al reconstruir: el perfil solo se muestra con `perfilCargado` (nunca durante la carga ni tras un error) y `PerfilController.guardarNombre` devuelve el error sin tocar el estado. «Mi cuenta» y «Completar perfil» ahora muestran el mensaje (`mensajeDeError`) y Reintentar con textos que ya existían (`inicioReintentar`); antes ocultaban el error. `redireccionPorPerfil` no aplica sin sesión (si no, el perfil «nuevo» del simulado sacaba de `/entrar`). Los errores que no son `Exception` del renovador cuentan como fallo transitorio. Sin ARB, rutas, tema ni dependencias nuevas.
- **Pendiente:** CA-29 (humo manual con teléfono y backend desplegado, evidencia en el PR); pantalla de sesiones y dispositivos, foto, colonia y código postal (otra spec); registro de dispositivos y push (spec 037 del backend); vendorizar el contrato y mover `/me`, `refresh`, `logout`, `/me/sesiones` y `colonias` al cliente generado (D-01); verificar la falla en `release` también en el flujo de publicación de `.github/` (D-09); el rol `esTecnico` del perfil aún no alimenta `esTecnicoProvider`; la validación del nombre (2 a 60 letras) sigue distinta de la del backend (D-10).
- **A evitar:** un segundo almacén de tokens, reintentar un `PUT` por red o 5xx, renovar desde el cliente con sesión (bucle), `print` o `debugPrint` en `core/sesion`, `core/red` o las `data/` de cuenta e inicio, guardar `colonias/en-punto` en la caché, leer `perfilControllerProvider.value` directo en una pantalla (usa `perfilCargado`) y dejar un repositorio simulado en `release`.

## 2026-11-10 — Coordenadas de colonias/en-punto con seis decimales (KNOCK-248)
- **Decisión:** `ColoniasRepositoryHttp` envía `lat` y `lon` con seis decimales (`toStringAsFixed(6)`).
- **Porqué:** el backend responde 422 si una coordenada trae más de 10 decimales o 16 caracteres, y el GPS del teléfono devuelve 15 o más; la persona veía «intentar de nuevo» en Tu zona. Seis decimales (~1 m) bastan y no envían más precisión de la necesaria.
- **A evitar:** concatenar un `double` en una consulta sin acotar sus decimales.

## 2026-11-10 — Previa sin sesión como la maqueta (spec 027, KNOCK-248; actualizada con D-12)
- **Decisión:** sin sesión la app abre en `/previa` (fuera del shell, sin barra inferior). Arriba la barra de marca con «Entrar» y «Registrarme» (ambos a `/entrar`); debajo, un **mapa a pantalla completa dibujado por la app** (`lienzo_mapa.dart`: barrios, parques, río y avenidas de la maqueta, claro y oscuro; sin SDK de mapas) con pan, pellizco y botones acercar, alejar y volver a mi ubicación (`VistaMapa` pura y `ControladorMapa`), el punto «Tú estás aquí» y **pines de ejemplo con calificación y color por oficio** (`pin_experto.dart`). El buscador (solo invita a entrar) y los chips (oficios reales más «Todos» y «No sé cuál», filtran pines, tarjetas y catálogo) flotan encima. Un panel inferior plegable (`DraggableScrollableSheet`: asomado, mitad, completo; «Ver lista» / «Ver mapa») trae «N expertos cerca de ti», la colonia de ejemplo, «Explorar servicios y trabajos», las tarjetas y el catálogo con sus cuatro estados (mismo `OficiosController`, sin `Authorization`). Los expertos de ejemplo se muestran **siempre**, también en tienda, con el rótulo fijo «Datos de ejemplo». Cerrar sesión termina en la previa. El destino de regreso (`/entrar?volver=…`) se valida contra una lista, vive en memoria (`destinoDeRegresoProvider`) y sobrevive a «completar perfil».
- **Porqué:** la demo debía verse como la maqueta antes de entrar y el primer intento (lista con un recuadro 4:3 y «Muy pronto» en tienda) no se parecía. D-12, decisión del Tech Lead: ejemplos siempre visibles y rotulados; el endpoint de expertos cercanos no existe y el SDK de mapas pide facturación.
- **Decisiones de implementación (a revisar):** se eliminaron la bandera `KNOCK_DEMO_DATOS`, `core/config/modo_demostracion.dart`, el panel «Muy pronto» y `scripts/verificar_release_sin_demo.py`; los colores del mapa viven en `core/tema/colores_mapa.dart` (regla: ningún widget con colores sueltos) y `VistaMapa` usa `dart:math` (regla: `domain` sin Flutter); `oficios/oficios.dart` exporta solo `Oficio` para que la previa no importe `oficios/domain/`; las pruebas de HU-001 y de cerrar sesión esperan la previa y `montarApp` pasa a `/entrar` por defecto (`abrirEnEntrada`).
- **Pendiente:** humo en teléfono, claro y oscuro, con capturas (T-15); revisar la política de la tienda sobre contenido de ejemplo antes de publicar fuera de la prueba interna; búsqueda y expertos reales (spec 027 del backend); mapa real y facturación del SDK de mapas; confirmar con el backend si «Mi auto», «Agua y tuberías» y «Luz y contactos» deben existir.
- **A evitar:** reintroducir una bandera que apague los ejemplos sin quitar el rótulo, escribir colores sueltos en widgets, pedir ubicación o permisos en la previa, un destino de regreso sin validar, y hacer `context.push` a un destino con parámetros desde la previa.

## 2026-11-10 — Ícono de lanzador de la app con el logo de Knock (KNOCK-242)
- **Decisión:** el ícono de Android es el logo de la ficha de Play: adaptativo (fondo crema `#FEF9F0` y primer plano con el logo dentro de la zona segura, con capa monocromática para el ícono temático) más los PNG heredados cuadrado y redondo en las cinco densidades; el manifiesto declara `roundIcon`. iOS no se tocó.
- **Porqué:** la app instalada seguía mostrando el ícono de Flutter; en Play y en el teléfono debe verse la marca.
- **A evitar:** volver a generar los PNG a mano sin cuidar la zona segura del 66 %, agregar un paquete de íconos al `pubspec.yaml` solo para esto, o cambiar el `applicationId` o el nombre de la app al tocar los recursos.

## 2026-11-10 — Versión 1.0.1 y registro de las dos primeras subidas a Play (KNOCK-230)
- **Decisión:** `app/pubspec.yaml` sube a `1.0.1+1` (1.0.0 + 1 punto de #37 tras corregir su etiqueta a `puntos-app-1`) y `docs/VERSIONES_PUBLICADAS.md` registra las subidas `app-v1.0.0-n0` (versionCode 1000000) y `app-v1.0.0-n1` (1000001). La próxima subida será `1.0.1` con n=0, versionCode 1000100.
- **Porqué:** `publish_info.py` toma el nombre de versión de `app/pubspec.yaml` y solo calcula `n` y el `versionCode` desde las etiquetas de Git; no suma puntos ni lee el registro. La segunda subida salió como 1.0.0 porque nadie subió la versión a mano. El `versionCode` nunca se repitió.
- **A evitar:** publicar sin aplicar antes `python scripts/ci/version.py bump --current <versión> --points <N>` a `app/pubspec.yaml`, suponer que el registro de versiones cambia el nombre de versión, o etiquetar un cambio de estilo (ícono, color) con más de 1 punto.
## 2026-11-10 — Correcciones a las specs 015 a 025 tras la revisión del PR #27 (KNOCK-243)
- **Decisión:** la spec 015 sube las fotos por el flujo de archivos privados de la spec 013 (`POST /api/v1/archivos/subidas`, `PUT` al SAS y `POST /api/v1/archivos/{id}/confirmar`, `uso: solicitud`) y envía `archivoId`, no el flujo de backend 032; los valores de `motivo` son los de backend 021 (`solicitud_sin_cotizaciones`, `solicitud_vencida`, `solicitud_cancelada`, `solicitud_ya_elegida`); la spec 016 agrega a la vista del cliente `rol`, el contacto público del técnico (`telefono?`, `whatsapp?`) y `lugar.tipo`, con un criterio nuevo (CA-21), y la 018 anota el 422 `errors.nivel` y el 409 `ya_verificado`. También se alinearon 015, 016, 019 y 020 con las specs de backend 020, 021, 022, 030 y 036.
- **Porqué:** con el flujo de la 032 la capa `data` se armaría contra rutas que no son (las fotos de una solicitud son privadas, backend 020 R-04); con otros nombres de `motivo` dos de cuatro caerían en «desconocido»; sin el contacto en la visita el cliente lo pierde al cerrar la hoja de confirmación (HU-033).
- **Reparto de la 015:** un PR por tarjeta (KNOCK-244, luego KNOCK-81 y luego KNOCK-245), con los CA repartidos en la spec (D-17) y los puntos de Jira (3, 3 y 2); decisión tomada sin consulta, ajustable por quien estima.
- **Pendiente:** el `PUT` a un SAS de Azure Blob exige `x-ms-blob-type: BlockBlob` y backend 025 (y la spec 013) no devuelve encabezados: queda como dependencia abierta en las specs 015 y 018, sin inventar el contrato; los avisos «tu técnico llegó» (016) y «cambió tu verificación» (018) no tienen evento en la spec 024; backend 022 no trae `llegadaEn` en la vista del cliente; los umbrales de calidad de foto de la 018 y el reparto de puntos por tarjeta de la 015 siguen sin decidir; los comentarios de Alexis sobre las specs 017, 021, 022 y 023 no se atendieron en esta pasada.
- **A evitar:** copiar rutas, códigos o nombres de campo de una spec de backend sin abrirla; dar por válido un `PUT` a un SAS sin los encabezados que exige Azure; guardar en el teléfono el contacto del técnico; inventar eventos en la spec 024 sin una decisión.

## 2026-11-10 — Versión final de la landing: una pantalla y animaciones CSS (KNOCK-258)
- **Decisión:** la página principal de la landing se rediseña en una sola pantalla sin scroll, con una ilustración en SVG incrustado y animaciones solo de CSS que se apagan con `prefers-reduced-motion`. El logo oficial de la maqueta (icono y letras) va incrustado solo en el encabezado; la ilustración es una casa dibujada aparte (techo de tejas, chimenea de ladrillo, ventanas con repisa y puerta de tablones), con insignias de oficios y ondas de «toc». Se conservan los enlaces (aviso de privacidad y eliminar mi cuenta y mis datos), el texto de «Próximamente en Google Play», las notas de seguridad, la versión del pie y las páginas legales. No se usa Lottie: necesita JavaScript y la política de contenido no lo permite. La spec 004 agrega R-06, R-07, CA-04 y CA-05.
- **Por qué:** el profesor pidió una landing sin scroll y la versión de entonces hacía scroll en pantallas bajas (320×568, 360×520 y celular horizontal); además se quería un diseño más cuidado para la entrega final.
- **Selector de tema:** enlaces «Claro» y «Oscuro» con `:target` (R-08), sin JavaScript ni `<input>`, porque la spec prohíbe formularios. Contacto e idioma quedan pendientes de decisión.
- **jscpd:** la barra de las dos páginas legales era un clon de 18 líneas; se separó con `data-pagina` en cada página en vez de excluirlas en `.jscpd.json` (archivo protegido, no se baja ningún control).
- **Pendiente de firma:** la nueva aprobación de la spec 004 la edita una persona a mano.
- **A evitar:** `<script>`, `style=""`, fuentes o imágenes de otro origen y archivos nuevos que obliguen a ampliar la CSP o el Dockerfile; colores fuera de los tokens `--color-*`; animaciones que sigan activas con movimiento reducido.

## 2026-11-10 — Contraste de los rótulos del mapa de la previa (KNOCK-175)
- **Decisión:** los rótulos del mapa dibujado (`PaletaMapa`, spec 027) se ajustan para cumplir 4.5:1 contra el halo que llevan detrás: en claro colonia `#585349`, avenida `#726440`, parque `#496B37` y río `#305B68`; en oscuro el río pasa a `#9CCBDB`. Se conserva el matiz de la maqueta. `colores_mapa_test.dart` (CA_014_03) revisa cada rótulo contra su halo (la colonia con su opacidad de 0.85) y el texto blanco de los pines.
- **Porqué:** spec 014 R-04 y KNOCK-175: todo par de texto del tema cumple 4.5:1. Los colores de `worldSvg` de la maqueta daban entre 2.27:1 y 4.18:1 en claro, y el río en oscuro repetía el par prohibido navy/navybg (4.25:1).
- **A evitar:** copiar de nuevo los colores de rótulos de la maqueta sin pasar la prueba, o medir el contraste contra el fondo del mapa en lugar del halo con el que se pinta cada rótulo.

## 2026-11-10 — El aviso de privacidad abre la página de la landing; dependencia `url_launcher` (KNOCK-260)
- **Decisión:** el texto «aviso de privacidad» de «Entra con tu celular» abre `https://knock-frontend-production.up.railway.app/privacidad/` en el navegador externo (spec 028). La dirección vive en `core/config/aviso_de_privacidad.dart` (valor por defecto, sustituible con `KNOCK_PRIVACY_URL`; solo `https`, sin credenciales). `AbridorDeEnlaces` en `core/enlaces/` envuelve `url_launcher`, que solo importa esa carpeta. El manifiesto declara la consulta de `https` en `<queries>` (Android 11 o posterior) sin permisos nuevos. Si no se puede abrir, sale un mensaje breve y la pantalla no cambia.
- **Dependencia evaluada:** `url_launcher` 6.3.3 (paquete oficial de flutter.dev, licencia BSD de 3 cláusulas, repositorio `flutter/packages`), con `url_launcher_android` 6.3.33, `url_launcher_ios` 6.4.2, `url_launcher_platform_interface` 2.3.2 y las implementaciones de Linux, macOS, web y Windows, todas del mismo repositorio y licencia. Versión exacta en `pubspec.yaml`. Se descartó una vista web embebida (`webview_flutter`): da a la página un lugar dentro de la app y obliga a mantener otro paquete.
- **Porqué:** el aviso solo tenía aspecto de enlace («aún no abre nada», pendiente de KNOCK-169) y las personas que instalaron la app desde la tienda no podían leerlo antes de aceptarlo; la tienda espera la política de privacidad accesible desde la app.
- **Pendiente:** humo en teléfono con la app instalada (CA-10), que hace el Tech Lead; los permisos del teléfono siguen en KNOCK-169.
- **A evitar:** importar `url_launcher` fuera de `core/enlaces`, abrir el aviso dentro de la app, escribir la dirección en otro archivo, poner celular o identificadores en la dirección, o hacer que tocar el aviso marque la casilla.
## 2026-11-10 — Se retira Idempotency-Key de las specs del Sprint 4 de la app (KNOCK-243)
- **Decisión:** la app no envía `Idempotency-Key` en la creación de solicitud, la elección, la llegada, el descarte, la cancelación ni la marca de leído (specs 015, 016, 019, 020 y 025). Backend 020, 021, 022, 028, 029 y 030 la quitaron. Una segunda elección responde 409 `solicitud_ya_elegida` y una segunda llegada, 409 `codigo_usado`: la app consulta el estado antes de mostrar un error. Quedó anotado el riesgo en cada spec.
- **Porqué:** decisión de José del 2026-11-10: no hay tiempo de implementarla en el Sprint 4 y la spec 010 ya la dejaba fuera.
- **A evitar:** reintroducir la clave en un repositorio de la app sin una spec propia de backend y de la app; dar por duplicada una solicitud sin consultar su estado. HU-024 CA4 y HU-033 CA3, que la exigían, se relajaron en `docs/backlog/`.

## 2026-11-10 — Códigos de error de las specs 015 a 025 de la app en inglés y snake_case (KNOCK-253)
- **Decisión:** las specs 015, 016, 018, 019, 020, 022, 023 y 025 de la app usan los mismos códigos de error en inglés que backend 020 a 037 (por ejemplo `request_already_chosen`, `code_used`, `request_not_dismissable`, `invalid_credentials`), y los valores de `motivo` coinciden con los del backend (`request_expired`, `request_cancelled`, `other_quote_chosen`). En la 015, `address_not_applicable` se lista como 422 junto con el resto de la validación de campos.
- **Por qué:** convención de errores de la spec 002 (KNOCK-253): un solo nombre por error entre API y app. Alexis pidió el mismo renombrado en la app en la revisión del PR de backend.
- **No se tocó:** la spec 021 (ya renombrada en su propio PR) ni los tipos de aviso de la spec 024 (`solicitud_cancelada`, `solicitud_vencida`), que son eventos de notificación y no códigos de error.
- **A evitar:** aprobar una spec de la app mientras su código de error difiera del de backend.

## 2026-11-10 — Dependencias de las fotos de la solicitud (KNOCK-244, spec 015 D-10)
- **Decisión:** se agregan `image_picker` 1.2.4, `path_provider` 2.1.6 e `image` 4.12.0, con la versión exacta en el `pubspec.yaml`.
  - `image_picker` y `path_provider` son del equipo de Flutter (flutter.dev, BSD-3-Clause).
  - `image` es de Brendan Duncan (MIT), mantenida y en Dart puro.
  - En OSV (`api.osv.dev`, ecosistema Pub) no hay avisos para esas versiones (consulta del 2026-11-10).
  - Paquetes que entran como transitivos: `archive`, `cross_file`, `mime`, `posix`, las implementaciones de plataforma de `image_picker` y `file_selector_*`.
  - `image_picker` usa la cámara y el selector del sistema por intención: el manifiesto no declara `CAMERA` (D-12).
- **Porqué:** HU-024 pide de 1 a 5 fotos. La app reduce cada foto a 1600 px de lado mayor y le quita el EXIF, incluida la ubicación, antes de subirla (CA-18). El borrador guarda las copias en un directorio privado de la app (R-07).
- **A evitar:** pedir el permiso `CAMERA` o de almacenamiento, guardar fotos en la galería, decodificar una foto antes de revisar su tamaño y su tipo por contenido, o hacerlo en el isolate principal (`prepararFotoEnSegundoPlano` usa `Isolate.run`).

## 2026-11-10 — Formulario «Pedir cotización» sin contrato todavía (KNOCK-244, spec 015)
- **Decisión:** se construyeron el dominio, el borrador, la preparación de fotos, el controlador y las tres pantallas, más el detalle. Los datos vienen de `SolicitudRepositoryDePrueba`, en memoria, porque el contrato todavía no tiene `/solicitudes` ni `/archivos` (backend 020 en Borrador; PR #63 de backend sin fusionar). Acuerdo con Julián: un solo PR de KNOCK-244 en borrador, que pasa a «listo» cuando llegue el contrato y se conecte el cliente generado en `solicitudRepositoryProvider`.
  - «Pide tu primera cotización» solo aparece fuera de release (`pedirCotizacionDisponibleProvider`), para que una versión publicada no cree solicitudes falsas.
  - La zona (`coloniaId`) es de la spec 017, que aún no está en la app. En release es `null` y el formulario avisa «Elige tu zona» sin enviar. Fuera de release se usa una colonia ficticia para la demo.
  - Las fotos remotas solo se pintan desde `dominiosDeFotosProvider`, que está vacío hasta que backend 020 y la spec 013 fijen el dominio de los enlaces firmados (CA-21).
  - La app sale de la copia de seguridad de Android (`android:allowBackup="false"` y `fullBackupContent="false"`, R-16). Así se cierra la duda de `allowBackup` que la spec 009 tenía abierta.
  - Al cerrar sesión se borran el borrador y la carpeta `fotos_solicitud` (`borrarBorradorDeSolicitud`, desde `SesionNotifier.cerrar`).
- **Porqué:** Julián aprobó avanzar con dominio, pantallas, repositorio falso, borrador y pruebas mientras no haya contrato (2026-11-10). El reparto de la spec 015 deja en KNOCK-244 los CA-01 a CA-06, CA-13 a CA-15, CA-17 a CA-19 y CA-21 a CA-24.
- **Pendiente:** CA-06, CA-13 y CA-23 en `solicitud_repository_api_test.dart` (capa `data` con el cliente generado); el dominio real de las fotos (CA-21); la zona de la spec 017.
- **A evitar:** publicar una versión con `SolicitudRepositoryDePrueba` o guardar la dirección en el borrador.
- **Actualización (2026-11-11):** se alineó con el retiro de `Idempotency-Key` (PR #33, decisión de Julián del 2026-11-10) y con los códigos de error en inglés (PR #39). La app ya no genera ni envía la clave. El doble envío se evita con el botón deshabilitado mientras se envía (CA-06), y el reintento tras un fallo de red es manual y no vuelve a subir las fotos.

## 2026-11-11 — Comparar cotizaciones sin contrato todavía (KNOCK-81, spec 015)
- **Decisión:** «Ver y elegir» (`/actividad/solicitud/:id/cotizaciones`) muestra hasta 5 tarjetas en el orden que manda el servidor. Cada chip de orden vuelve a pedir la comparación con `orden` (R-08): la app no reordena ni filtra. Mientras no exista el contrato, `SolicitudRepositoryDePrueba` simula a backend 021: diez segundos después de crear la solicitud llegan cuatro cotizaciones ficticias, ordenadas y etiquetadas con sus reglas (R-04 a R-07).
  - Los `motivo` usan los códigos en inglés (`request_without_quotes`, `request_expired`, `request_cancelled`, `request_already_chosen`).
  - Montos y calificaciones salen con formato de México (`es_MX`: «$1,100», «4.5») aunque la app esté en inglés (spec 015 §7, pesos mexicanos).
  - «Ver mi visita» depende de `visitaDisponibleProvider`, falso hasta que KNOCK-83 registre la ruta de la visita, para no dejar un botón sin destino.
  - «Elegir» no aparece todavía: lo agrega KNOCK-245 con la hoja de confirmación.
- **Porqué:** Julián pidió seguir con repositorio falso, un PR por tarjeta (244 → 81 → 245). El PR de 81 se apila sobre el de 244 porque necesita su detalle.
- **A evitar:** ordenar o filtrar las cotizaciones en el teléfono, o agregar teléfono o dirección al modelo `TecnicoResumen` (CA-10).

## 2026-11-11 — Ícono de Instagram en la landing (KNOCK-258)
- **Decisión:** el pie de la página principal lleva un ícono de Instagram dibujado en SVG, enlazado a `https://www.instagram.com/knock.mx/` con `rel="noopener noreferrer"` y `aria-label="Instagram de Knock"`; las pruebas y `check_links.py` permiten esa URL además de la de Google Play (spec 004 R-09 y CA-06, sin red al revisar).
- **Por qué:** el profesor pidió los íconos de las redes del proyecto y la primera cuenta ya existe; las demás se agregan cuando tengan URL oficial, y Google Analytics queda fuera porque la spec y la CSP prohíben scripts de terceros.
- **A evitar:** inventar enlaces de otras redes o apuntar a portadas genéricas, descargar el logo oficial, bajar el objetivo táctil de 44 px y ampliar la lista de URL externas sin tocar la spec.
## 2026-11-11 — El SCA de licencias deja pasar 15 paquetes de pub más (EXC-002, KNOCK-262)
- **Decisión** (Tech Lead): se agregan a `allow-dependencies-licenses` de `ci-pr.yml` y al alcance de EXC-002 (sin cambiar `creada` ni `vence`, 2027-01-30) archive@4.6.0, cross_file@0.3.5+5, file_selector_linux@0.9.4+1, file_selector_macos@0.9.5+2, file_selector_windows@0.9.3+6, image@4.12.0, image_picker_ios@0.8.13+15, image_picker_platform_interface@2.11.2, mime@2.1.0, posix@6.5.4, url_launcher_android@6.3.33, url_launcher_ios@6.4.2, url_launcher_linux@3.2.3, url_launcher_macos@3.2.6 y url_launcher_windows@3.1.6. Se mantiene `deny-licenses` y el job de SCA. La lista queda en 57 paquetes.
- **Porqué:** el CI de los PR #45 (KNOCK-244) y #46 (KNOCK-260) falla solo porque `dependency-review-action` recibe de pub las licencias en minúsculas y no las reconoce como SPDX (a url_launcher_windows no le detecta ninguna); no hay vulnerabilidades. Se leyó el LICENSE de cada versión en pub.dev: MIT (archive, image, posix), BSD-3-Clause (los otros 11) y BSD-3-Clause con un aviso de Apache-2.0 de un tercero (image_picker_ios). Todas están en la lista permitida de CONTRIBUTING.md.
- **A evitar:** agregar paquetes a la lista sin leer su LICENSE; olvidar que el action ignora la versión (una versión nueva sigue exenta y su licencia se revisa a mano); bajar `deny-licenses`; renovar EXC-002 sin volver a evaluar si el action ya normaliza las licencias de pub. Tras fusionar este PR, #45 y #46 deben traer `sprint-04` para ver el SCA en verde.

## 2026-11-11 — Imagen con personas reales en la landing (KNOCK-258)
- **Decisión:** la casa animada se reemplaza por `landing/img/hero.webp` (foto de personas reales sonriendo, generada con IA por el Tech Lead, sin texto ni logotipos, 800×800, menos de 80 KB) con la leyenda «Tu técnico de confianza, a tu puerta» en HTML y `alt` útil; el Dockerfile copia `img/` y las pruebas permiten solo ese archivo (spec 004 R-09 y CA-06).
- **Por qué:** el profesor pidió una landing emocional con una imagen grande de gente sonriendo y una leyenda sencilla; la CSP ya permite `img-src 'self'`, así que no hay recursos de terceros.
- **A evitar:** subir una imagen de más de 80 KB, poner texto dentro de la imagen, quitar el `alt`, cargarla de otro origen o con `loading="lazy"`, y usar rostros reales de terceros o de famosos.

## 2026-11-11 — Moodboard de fotos y cuatro redes en la landing (KNOCK-258)
- **Decisión:** la foto única se reemplaza por un mosaico de 22 WebP propios en `landing/img/` (cada uno de 24 KB como máximo, 215 KB en conjunto; solo 4 con `alt` descriptivo y el resto `alt=""`) armado solo con CSS: recortes densos con tamaño, giro y capa distintos que sobresalen de los bordes del panel y una capa de respaldo con fotos veladas para que nunca quede un hueco, borde de impresión o papel rasgado (`clip-path`), cinta adhesiva y adornos SVG con `aria-hidden`, dentro de un panel que ocupa la mitad derecha de la pantalla de arriba a abajo (en celular, una franja inferior con 9 fotos), medido con `container-type: size` y `cqw`/`cqh` para que escale sin deformar y recorte lo que sobresale; el encabezado, el texto, el lema y el pie quedan a la izquierda. El interruptor de tema pasa a ser uno solo (pista y perilla con sol y luna en SVG) hecho con dos enlaces de ancla y `:target`, sin `<input>` ni JavaScript (spec 004 R-08). El tope de peso de la página sube de 150 KB a 300 KB. El pie lleva Instagram, TikTok, X y Facebook con íconos propios y las URL exactas, sin parámetros de seguimiento (`_r`, `_t`, `s`, `mibextid`); `test_landing.py` y `check_links.py` las permiten (spec 004 R-09 y CA-06).
- **Por qué:** el profesor pidió una landing emocional con varias fotos de gente y los íconos de las redes del proyecto; la CSP ya permite `img-src 'self'` y no hay recursos de terceros. Todo queda en una pantalla sin scroll y el movimiento sigue apagado con `prefers-reduced-motion`.
- **A evitar:** pasar de 24 KB por foto o de 215 KB en conjunto, poner dos fotos de la misma escena una junto a otra, poner texto dentro de las imágenes, `loading="lazy"`, `style=""`, colores fuera de los tokens `--color-*`, copiar logos oficiales de las redes, volver a agregar parámetros de seguimiento a los enlaces y sacar fotos del panel sin `overflow:hidden` (generaría scroll), usar `<input>`, `<button>` o `role="switch"` en el interruptor (un enlace no responde a la barra espaciadora) y mostrar el panel en pantallas de menos de 36rem de alto.

## 2026-11-12 — Elegir una cotización sin contrato todavía (KNOCK-245, spec 015)
- **Decisión:** «Elegir» abre una hoja modal (D-08) que solo se cierra con sus botones mientras se confirma (R-18). Al confirmar muestra la cita: técnico, día y hora, precio y máximo, modalidad, contacto público (teléfono o WhatsApp, o «no publicó un teléfono») y lugar.
  - La cita vive en `EleccionController` y se olvida al cerrar la hoja (D-16): no se guarda en disco.
  - Un 409 (`EleccionRechazadaFailure`, con los cinco motivos de backend 021) muestra su texto, no ofrece reintentar y vuelve a pedir la comparación.
  - Un 503 dice «No pudimos confirmar tu elección» y deja reintentar a mano.
  - El repositorio de prueba permite una sola elección por solicitud, como backend 021 R-10 y R-11. Los teléfonos de prueba son ficticios (`5500000001`).
- **Pendiente:**
  - CA-20 completo (tras un 409 `request_already_chosen` por reintento, consultar la visita y mostrar la cita) necesita `GET /visitas/{id}` (spec 016, KNOCK-83) y el contrato.
  - Llamar o abrir WhatsApp desde la cita espera `url_launcher` (spec 016, D-06). Por ahora el número se puede seleccionar y copiar.
- **A evitar:** guardar la cita o el contacto en disco, o reintentar una elección sin que la persona lo pida.

## 2026-11-12 — Ver mi visita con el código, sin contrato todavía (KNOCK-83, spec 016)
- **Decisión:** `/actividad/visita/:id` muestra la visita del cliente. Según la modalidad, aparece una de dos cosas:
  - **A domicilio:** el técnico, su insignia, el día y la hora, el código en cuatro recuadros con «Ocultar código» y la regla de seguridad.
  - **En taller:** la dirección y «Cómo llegar».
- **Cómo funciona:**
  - La copia mínima de la visita (sin dirección del domicilio ni contacto, R-03) se guarda en el almacén seguro con un índice (`core/sesion/datos_de_visita.dart`). `SesionNotifier.cerrar` la borra con `borrarDatosDeVisita`.
  - Sin conexión se muestra esa copia (CA-02).
  - Un `motivoCodigo` borra el código de la copia (R-07). Una visita terminada o cancelada borra la copia completa.
  - La pantalla se refresca al volver a la app, sin sondeo.
  - `visitaDisponibleProvider` queda en verdadero, así que «Ver mi visita» ya lleva aquí desde la comparación y la cita.
- **`url_launcher` 6.3.3, el mismo que ya trajo la spec 028 (KNOCK-260); se reutiliza su `AbridorDeEnlaces` de `core/enlaces/`:**
  - Se usa para «Cómo llegar» (`https://www.google.com/maps/search/?api=1&query=` con `Uri.encodeComponent`), llamar (`tel:`) y WhatsApp (`https://wa.me/52…`), siempre con enlaces armados en `core/enlaces/enlaces.dart`, nunca con uno que llegue del servidor.
  - El manifiesto declara en `<queries>` VIEW `https` y DIAL `tel` (Android 11+).
  - Sus paquetes de plataforma pueden necesitar entrar a EXC-002 para el SCA, como pasó con `image`.
- **R-18:** `MainActivity` expone el canal `knock/pantalla` con `capturaEnRecientes`. La visita lo apaga al entrar y lo prende al salir (`setRecentsScreenshotEnabled`, Android 13+). Se verifica a mano en el teléfono.
- **A evitar:**
  - Guardar el código en `shared_preferences` o en un archivo.
  - Guardar la dirección del domicilio o el contacto en la copia local.
  - Abrir un enlace que no salga de `Enlaces`, o crear un segundo abridor en lugar de usar `core/enlaces/abridor_de_enlaces.dart`.
  - Borrar el índice de visitas cuando no existe: la prueba de un solo cierre de sesión cuenta los borrados.

## 2026-11-12 — Avisar a alguien de confianza (KNOCK-84, spec 022)
- **Decisión:** «Avisar a alguien de confianza» (en la visita, `puedeAvisar`) abre una hoja que hace esto:
  - Pide el texto **una vez** con `POST /visitas/{id}/aviso`, con cuerpo vacío y sin `Idempotency-Key`.
  - Muestra la vista previa y la lista de contactos.
  - Ofrece «Enviar por SMS» (`sms:` con `body`), «Enviar por WhatsApp» (`https://wa.me/52…?text=`, o la hoja de compartir si no hay WhatsApp) y «Compartir sin guardar» (`share_plus`).
  - La app no envía nada por sí sola.
- **Respaldo y casos especiales:**
  - Un texto que dice traer código o dirección se descarta.
  - Sin conexión o con error, el texto se arma con `DatosAvisoLocal`: solo nombre, verificación, día y hora, copiados de la visita guardada en `knock.aviso.respaldo.{id}`, que vence 24 h después del día de la cita.
  - Con 409 `visit_not_notifiable` no se ofrece ningún canal.
- **Contactos:**
  - Máximo 10, nombre de 2 a 40 caracteres y celular de 10 dígitos, sin repetir.
  - Viven solo en el almacén seguro (`knock.contactos.confianza`) y se administran también desde Mi cuenta (`/cuenta/contactos`, D-01).
  - El cierre de sesión borra contactos y respaldos (`borrarDatosDeVisita`, solo lo que existe).
- **Manifiesto:**
  - Agrega la consulta SENDTO `sms` y `dataExtractionRules`, que excluye todo de la copia en la nube y de la transferencia entre teléfonos (Android 12+).
  - Sin `READ_CONTACTS`, `SEND_SMS` ni `CALL_PHONE`.
- **`share_plus` 13.3.1** (Flutter Community, BSD-3-Clause; sin avisos en OSV el 2026-11-12; no pide permisos). Puede necesitar EXC-002 para el SCA.
- **A evitar:** pasarle a la plantilla local el código o la dirección, enviar el canal o el contacto al servidor, o pedir permisos de contactos o SMS.

## 2026-11-11 — Los agentes implementan las tareas de las specs aprobadas (KNOCK-243)
- **Decisión:** `AGENTS.md` y `.opencode/agents/implementer.md` dejan de decir «esta primera etapa es solo de especificación: no ejecutes las tareas». Ahora dicen que, si la spec está **Aprobada**, el agente implementa solo las tareas de su `task.md`, de una en una y con sus pruebas escritas primero. Una persona decide qué spec o grupo de tareas se activa; el agente no aprueba, no firma y no fusiona.
- **Porqué:** las specs 020 a 037 de backend y 015 a 028 de la app quedaron aprobadas el 11 de noviembre y el plazo del proyecto exige implementarlas; la regla anterior hacía que los agentes se negaran a programar aunque la spec estuviera aprobada. La autorización del cambio es del Tech Lead.
- **A evitar:** implementar una spec en Borrador o lo que no esté en sus tareas, activar todas las specs a la vez (son más de 250 tareas y no caben en el plazo: se activan por grupos), o que un agente apruebe, firme o fusione.
## 2026-11-12 — Códigos de TOTP, Web Locks, activación, aviso sin límite y respaldo local seguro en las specs de la app (KNOCK-243)
- **Decisión:** la 023 del panel usa los códigos `invalid_code`, `challenge_expired` y `locked` (el bloqueo lo decide el servidor; el contador del panel es solo visual), serializa la renovación entre pestañas con Web Locks y agrega la pantalla `/activar` con el token en el fragmento `#`. La 022 deja el conteo de avisos como solo informativo (sin límite de 10 por hora) y arma el respaldo sin conexión con `DatosAvisoLocal` en el almacenamiento seguro, con caducidad, borrado al cerrar sesión y fuera de los respaldos del teléfono. La 017 reutiliza la consulta por código postal 10 minutos en memoria y revalida con `ETag` (backend 023 R-16, `private, no-cache`). Las specs 024 y 012 llevan solo una nota que remite a backend 037.
- **Por qué:** backend 033 y 037 cambiaron sus contratos; hoy el `<application>` de `AndroidManifest.xml` no declara `allowBackup`, `dataExtractionRules` ni `fullBackupContent`, y el registro de dispositivos sigue contra `RegistroDispositivosSimulado` porque backend aún no publica el endpoint.
- **Pendiente de firma:** las specs 017, 022 y 023 de la app cambiaron de fondo y las firma una persona a mano; este cambio no toca ninguna sección «Aprobación». Los renombres de #39 y #35 no piden firma nueva.
- **A evitar:** mostrar un contador de intentos del panel como si decidiera algo; guardar el token de activación o el secreto TOTP en el navegador; guardar datos de la visita fuera del almacenamiento seguro o dejarlos en los respaldos del teléfono.

## 2026-11-12 — Memoria.md se fusiona sin conflictos al agregar entradas (KNOCK-265)
- **Decisión:** `.gitattributes` marca `Memoria.md` con `merge=union`. Cuando dos ramas agregan entradas distintas al final, `git merge` en local conserva las dos y ya no marca conflicto.
- **Por qué:** casi todos los conflictos de los PR de las últimas semanas eran de `Memoria.md`, porque cada PR agrega su entrada en el mismo lugar. Se probó en un repositorio de prueba: dos ramas con entradas distintas se fusionaron sin conflicto y quedaron las dos.
- **Límite (sin verificar en GitHub):** `merge=union` lo aplica Git en la máquina de quien hace `git merge origin/sprint-04`. No se verificó si el botón «Merge» de GitHub también lo aplica; si no, la ficha del PR puede seguir mostrando conflicto hasta que se traiga `sprint-04` a la rama con `git merge`. Se mide con el primer PR que lo necesite.
- **A evitar:** editar una entrada ya existente de `Memoria.md` en dos ramas a la vez (el driver duplica o mezcla líneas); fusionar sin revisar que la entrada nueva quedó entera y separada de la anterior por una línea en blanco.

## 2026-11-13 — Rutas de las pruebas de la spec 015 distintas a las de la spec (KNOCK-244 y KNOCK-81)
- **Decisión:** algunas pruebas de la spec 015 viven en archivos que agrupan una pantalla, no en el archivo exacto que dice la columna «Verificación». `sdd_lint --trace 015` las encuentra igual, porque busca por el nombre del caso.

  | Casos | Archivo en la spec | Archivo real |
  |---|---|---|
  | CA_015_07 a CA_015_10 | `cotizaciones_screen_test.dart`, `cotizaciones_controller_test.dart`, `tarjeta_cotizacion_test.dart` | `test/features/actividad/presentation/cotizaciones_test.dart` |
  | CA_015_03, CA_015_05, CA_015_16 y CA_015_17 (pantalla) | `selector_fotos_test.dart`, `paso_cuando_donde_test.dart`, `accesibilidad_solicitud_test.dart` | `test/features/actividad/presentation/pantallas_solicitud_test.dart` |

- **CA_015_10:** ya no es una lista literal. Lee los campos de `TecnicoResumen` y `Cotizacion` en `domain/cotizacion.dart` y falla si alguno se llama `telefono`, `whatsapp`, `direccion` o `celular`.
- **A evitar:** pruebas de aceptación que no fallen aunque cambie el modelo, como contar los elementos de una lista escrita en la misma prueba.

## 2026-11-13 — Ajustes de la revisión de Julián a KNOCK-245 y KNOCK-83 (specs 015 y 016)
- **CA-20 cerrado (spec 015):** si al reintentar la elección el servidor responde 409 `request_already_chosen`, `EleccionController` pide la comparación, toma su `visitaId`, consulta la visita (`VisitaRepository`, spec 016) y muestra esa cita como hecha. Si no hay visita que consultar, queda el mensaje de CA-12. Prueba: `CA_015_20` en `cotizaciones_controller_test.dart`. La parte contra el contrato sigue esperando el OpenAPI de backend 021.
- **Índice de visitas:** `VisitaLocalRepositorySeguro.guardar` escribe **primero el índice** y después los datos; `borrar` hace lo contrario. Si la app se cierra entre las dos escrituras, queda un id sin datos (inofensivo) y nunca un código que el cierre de sesión no encuentre. Prueba: corte en la segunda escritura dentro de `visita_test.dart`.
- **Fuera de la lista de archivos de la spec 016 (§9):** `android/app/src/main/kotlin/app/knock/mobile/MainActivity.kt` (canal `knock/pantalla`) y `lib/core/plataforma/captura_en_recientes.dart`, que implementan R-18.
- **Pendiente:**
  - Comprobar a mano, en un teléfono con Android 13 o superior, que la miniatura de recientes no muestra el código.
  - Subir las capturas del emulador. Las dos cosas las hace Erick con un dispositivo.

## 2026-11-13 — Ajustes de la revisión de Julián a KNOCK-84 (spec 022)
- **CA_022_18:** prueba con ese nombre en `test/seguridad/seguridad_cliente_test.dart`. Revisa que los archivos del aviso y de la visita no escriban en consola, registros ni reportes (`print`, `log`, `FlutterError.report`, Crashlytics, Sentry). También revisa que `ContactoConfianza`, `MensajeAviso` y `ContactoNoGuardado` no muestren nombre, celular ni texto en su `toString()`. `sdd_lint --trace 022` ya no marca ningún caso faltante.
- **409:**
  - Solo `visit_not_notifiable` bloquea el aviso; tiene su propio error, `AvisoNoPermitidoFailure`.
  - Cualquier otro `ConflictoFailure` cae en el respaldo con la advertencia de CA-16.
  - El adaptador de la API debe mapear ese código a ese error.
- **Defensa extra (R-06):**
  - El texto del servidor se revisa contra el código de la copia local de la visita, junto o separado por espacios, puntos o guiones. Si lo trae, no se usa, aunque diga `incluyeCodigo: false`.
  - Los ids de contacto usan `relojSolicitudProvider` y no `DateTime.now()`.
  - El respaldo del aviso escribe primero el índice, igual que la copia de la visita.

## 2026-11-13 — Dos bugs de la revisión de Julián al #55 (KNOCK-84, spec 022)
- **Contactos de otra cuenta tras cerrar sesión (CA-13):**
  - `contactosProvider` no era `autoDispose` y nunca se volvía a leer, así que la lista de la cuenta anterior seguía en Mi cuenta y en la hoja.
  - Ahora es `autoDispose` y observa `cierresDeSesionProvider` (`core/sesion/sesion.dart`), un contador que `SesionNotifier.cerrar` sube **después** de borrar los datos locales.
  - Observar `sesionProvider` no bastaba: cambia antes del borrado, así que podía volver a leer contactos que aún existían.
  - Prueba: `borrado_visita_test.dart` revisa la lista que ve la persona.
- **Respaldo del aviso huérfano (CA-20):** `VisitaLocalRepositorySeguro.borrar` quitaba la visita del índice sin borrar `knock.aviso.respaldo.<id>`. Ahora lo borra con la visita. Prueba: abrir una visita guarda el respaldo solo; cuando la visita termina no queda nada en el almacén.
- **Ruta:** los contactos viven en `/cuenta/contactos-de-confianza`, como dice la T-06 de la spec 022.
- **A evitar:** que un proveedor que muestra datos locales de la cuenta dependa del cambio de sesión en vez del fin del borrado, o borrar una visita sin sus datos asociados.

