# Plantillas de configuración (copiar al crear los proyectos)

Los proyectos `app/` y `panel/` ya existen. En esta carpeta solo queda una plantilla:

| Archivo | Destino | Para qué |
|---|---|---|
| `app/analysis_options.yaml` | `app/analysis_options.yaml` | Lints estrictos y tipos (`flutter analyze --fatal-infos`) |

Cobertura del panel: configura el reporte `json-summary` (Istanbul) en `ng test`; el CI lee `panel/coverage/coverage-summary.json`.

Para agregar mutación o E2E, evaluar los paquetes y registrarlos en `Memoria.md`.
