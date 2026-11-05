# Memoria — knock-frontend

> Registro del proyecto: estado, decisiones con su fecha y su porqué, y errores a evitar. Los agentes la leen al empezar y agregan una entrada al terminar cada cambio. Sin datos sensibles.

## Estado actual
- Constitución `1.0.0` en borrador, `AGENTS.md`, subagentes y skills creados.
- 12 specs de la base (arquitectura, estructura del repositorio, infraestructura, rendimiento, observabilidad, versionamiento y seguridad) redactadas en **Borrador**; sus tareas **no se han ejecutado**.
- Sin código de producto todavía.

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

## 2026-11-05 — Integración continua y publicación en Google Play (spec 007, KNOCK-221)
- **Decisión:** la detección de cambios por carpeta y el resultado del `gate` pasaron del YAML a `scripts/ci/detect_changes.py` y `scripts/ci/gate.py`, con pruebas `CA_007_01` y `CA_007_02`; el job `landing` entra en `needs` del `gate`; `.github/workflows/publish-android.yml` construye el AAB firmado y lo sube a la pista **interna** solo desde `main` y con `ci-pr` en verde; `scripts/ci/publish_info.py` calcula `versionCode` y número de subida `n` a partir de las etiquetas `app-vX.Y.Z-nN`; `app/android/app/build.gradle.kts` firma con la llave de subida si llegan `KNOCK_KEYSTORE_*` y con la de depuración si no; `_governance.yml` corre ahora las pruebas de `scripts/ci/`. Pasos y secretos en `docs/PUBLICACION_ANDROID.md`.
- **Porqué:** la spec pide los checks por carpeta, el paquete firmado y la publicación por etapas; sin extraer la lógica no había nada que probar con CA-01 y CA-02, y `scripts/ci/test_*.py` no corría en ningún job. ACR Tasks no está permitido en la suscripción, así que nada del flujo usa `az acr build`.
- **Pendiente:** CA-03 solo se comprueba ejecutando el workflow con los secretos y la cuenta de Google Play (`ANDROID_KEYSTORE_*`, `PLAY_SERVICE_ACCOUNT_JSON`, `MAPS_API_KEY`; cuenta y ficha son de KNOCK-52 y KNOCK-230); la prueba cerrada y producción se promueven a mano en Play Console (R-06); sumar los puntos de los PR para subir `X.Y.Z` automáticamente (T-03 de la spec 011) sigue manual: hoy la versión sale de `app/pubspec.yaml`; `sdd_lint --trace 007` marca FALTA mientras `test_globs` de `.agents/knock.json` no incluya `scripts/ci/test_*.py`; el estado de la spec y las tareas de `task.md` los actualiza José; si la app sigue en borrador en Play Console, la subida puede pedir `status: draft`.
- **A evitar:** publicar con la llave de depuración, escribir un secreto dentro de un `run:`, repetir un `versionCode` y dar una acción de terceros sin fijar por SHA.
