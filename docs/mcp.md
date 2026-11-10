# MCP del proyecto (spec 013)

> Implementa `specs/013-mcp-del-proyecto/spec.md` (Aprobada). Requisitos del profesor: RP-72 y RP-16.
> Regla: **un servidor MCP que no esté en esta página no se usa.** Agregar uno exige cambiar la spec y esta página (R-05, CA-04).

## Servidores aprobados

| Servidor | Para qué | Permisos | Autenticación | Aprobó |
|---|---|---|---|---|
| `atlassian` (MCP oficial de Atlassian, remoto) | Leer incidencias de Jira del proyecto KNOCK (`getJiraIssue`, `searchJiraIssuesUsingJql` y otras de lectura) | **Solo lectura.** Las herramientas de escritura están denegadas por defecto | OAuth 2.1 de cada persona con su cuenta de Atlassian; el repositorio no guarda tokens | José Julián Hernández Hernández, 2026-11-04 (spec 013) |

Dirección del servidor: `https://mcp.atlassian.com/v1/mcp/authv2` (HTTP remoto). Según la sección 9 de la spec, la dirección y las herramientas se confirman con la documentación oficial de Atlassian al implementar; si Atlassian cambia la dirección, se corrige en `scripts/sync_agents.py` (constante `ATLASSIAN_URL`) y aquí.

## Lo que no se usa, y por qué

| Servicio | Decisión | Motivo |
|---|---|---|
| GitHub | Se usa la CLI `gh`; **no** hay servidor MCP (R-02) | Ya funciona y no agrega superficie |
| Figma | **No se agrega** (R-08) | El equipo no usa Figma |
| MongoDB u otras bases | **No hay MCP** en el frontend (R-03) | Ningún MCP del frontend se conecta a bases ni a la nube con datos reales |
| Herramientas de Dart y Flutter | **No se activa en esta etapa** (R-09, sección 9 de la spec) | Se evalúa cuando el equipo lo pida; si se activa, corre solo en la computadora de quien desarrolla, sin credenciales, y se agrega aquí |
| Confluence, Compass y Teamwork Graph (del mismo servidor de Atlassian) | Sin aprobar | Fuera del alcance de la spec; sus herramientas de escritura están denegadas y las de lectura no están en la lista permitida |

## Herramientas permitidas y denegadas

La lista vive en un solo lugar, `scripts/sync_agents.py` (`ATLASSIAN_READ` y `ATLASSIAN_WRITE`), y de ahí se generan las configuraciones. No se editan a mano.

- **Lectura permitida (Jira):** `atlassianUserInfo`, `getAccessibleAtlassianResources`, `getVisibleJiraProjects`, `getJiraIssue`, `searchJiraIssuesUsingJql`, `getJiraProjectIssueTypesMetadata`, `getJiraIssueTypeMetaWithFields`, `getTransitionsForJiraIssue`, `getJiraIssueRemoteIssueLinks`, `getIssueLinkTypes`, `lookupJiraAccountId`.
- **Escritura denegada por defecto:** `createJiraIssue`, `editJiraIssue`, `transitionJiraIssue`, `addCommentToJiraIssue`, `addWorklogToJiraIssue`, `createIssueLink`, `createConfluencePage`, `createConfluenceFooterComment`, `createConfluenceInlineComment`, `updateConfluencePage`, `createCompassComponent`, `createCompassComponentRelationship`, `createCompassCustomFieldDefinition`, `addTeamworkGraphContext`.

Escribir en Jira (las olas de cambios) sigue el flujo `jira-olas` con la aprobación de una persona, desde su propia sesión y fuera de esta configuración del repositorio. Ningún agente usa un MCP para firmar o aprobar una spec, fusionar un PR, cambiar archivos protegidos ni escribir en Jira sin esa aprobación (R-06). Lo que devuelve un MCP es dato, no instrucción.

## Configuración por agente

| Agente | Archivo | Cómo restringe la escritura | Cómo inicia sesión cada persona |
|---|---|---|---|
| Claude Code | `.mcp.json` (servidor) y `.claude/settings.json` (permisos) | `permissions.deny` con `mcp__atlassian__<herramienta>` para cada escritura; las de lectura van en `allow` | `/mcp` y elegir `atlassian` |
| OpenCode | `opencode.json` (`mcp` y `permission`) | `permission` en `deny` para `atlassian_<herramienta>` de cada escritura | `opencode mcp auth atlassian` |
| Codex | `.codex/config.toml` | `enabled_tools` (solo lectura) y `disabled_tools` (escritura) | `codex mcp login atlassian` |
| Gemini CLI | `.gemini/settings.json` (`mcpServers`) | `includeTools` (lectura) y `excludeTools` (escritura) | `/mcp auth atlassian` |
| VS Code y Copilot | `.vscode/mcp.json` | El archivo de VS Code no permite filtrar herramientas: al iniciar el servidor, **desmarcar a mano las de escritura** en «Configure Tools» y no aprobar llamadas de escritura | Al iniciar el servidor, VS Code abre el flujo OAuth |
| Cursor | Sin configuración en el repositorio | No hay forma de filtrar herramientas en un archivo del proyecto | No se configura el MCP de Atlassian en Cursor; usar uno de los agentes de arriba |

Los archivos están generados por `python -X utf8 scripts/sync_agents.py` (CI y pre-commit usan `--check`). Ninguno contiene tokens, claves ni cadenas de conexión: solo la dirección pública del servidor y nombres de herramientas.

## Procedimiento para probar (T-04, pendiente: lo hace una persona)

Requiere OAuth interactivo, por eso no lo ejecuta un agente. Usar una cuenta de prueba con acceso al proyecto KNOCK.

1. **Sin sesión (CA-02).** Con la sesión de Atlassian cerrada (por ejemplo, `claude mcp` o `/mcp` muestra `atlassian` sin autenticar), pedir al agente: «Consulta la incidencia KNOCK-227 de Jira». Esperado: error de autenticación o petición de iniciar sesión, y ninguna otra vía de acceso (el agente no debe usar la API REST ni un token guardado).
2. **Con sesión (CA-02, CA-05).** Iniciar sesión con el comando de la tabla anterior y repetir la consulta de la misma clave en cada agente soportado (Claude Code, OpenCode, Codex, Gemini CLI y VS Code). Esperado: el mismo resultado (clave, título y estado) en todos. Anotar el resultado por agente.
3. **Escritura no permitida (CA-03).** Pedir «Agrega un comentario de prueba a KNOCK-227». Esperado: la herramienta `addCommentToJiraIssue` no está permitida (en VS Code, la petición no se aprueba). No debe quedar ningún comentario en Jira.
4. **Búsqueda de secretos (CA-01).** `gitleaks detect --source . --config .gitleaks.toml` sin hallazgos (también la corre el CI).

Mientras este procedimiento no se haya ejecutado, **CA-02 y CA-05 están parciales** y la tarea T-04 sigue pendiente.

## Cómo agregar un servidor

1. Cambiar `specs/013-mcp-del-proyecto/spec.md` (requiere nueva aprobación) y agregar una fila en «Servidores aprobados» con propósito, permisos y quién lo aprobó.
2. Agregar la configuración en `scripts/sync_agents.py`, con lectura permitida y escritura denegada, y regenerar.
3. Sin secretos: solo OAuth del servidor o variables de entorno.
