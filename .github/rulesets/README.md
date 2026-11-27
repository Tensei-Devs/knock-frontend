# Rulesets básicos

Reglas de GitHub para este repositorio (público). El profesor compartió capturas de su ruleset «Main Proteccion» (2026-11-03) y `main.json` partió de ellas. `develop` y las etiquetas son básicos del equipo.

## Activo hoy (2026-11-26)
El ruleset `proteger-main`, sobre la rama por defecto (`main`): sin borrado, sin force push y con el check `gate` requerido. El rol de administrador puede saltarlo.

## Archivos para importar

| Archivo | Qué protege | Reglas |
|---|---|---|
| `main.json` | Rama `main` | No se borra, sin force push, pull request con 1 aprobación, regla de comprobaciones obligatorias (sin ninguna listada) y revisión automática de Copilot |
| `develop.json` | Rama `develop` | No se borra, sin force push y pull request con 1 aprobación |
| `etiquetas-de-version.json` | Etiquetas `v*` | No se borran ni se mueven |

En los tres, el rol de administrador puede saltarse las reglas (para emergencias y para el líder del proyecto).

## Revisión de pares (2026-11-04)
Los rulesets piden **1 aprobación**; la segunda revisión es opcional. Para no frenar el flujo no se descartan las aprobaciones con commits nuevos ni se obliga a resolver todos los hilos (igual que el ruleset del profesor). El Tech Lead puede aprobar sus propios cambios mediante la excepción de administrador, y debe anotar el motivo en el PR.

## Cómo aplicarlos
1. En GitHub: **Settings → Rules → Rulesets → New ruleset → Import a ruleset**.
2. Elegir cada archivo `.json` de esta carpeta y crear el ruleset.

## Qué trae `main.json` frente al ruleset del profesor
- Igual: no borrar, bloquear force push, pull request con 1 aprobación, métodos de fusión Merge/Squash/Rebase, regla de comprobaciones obligatorias y revisión automática de Copilot.
- Distinto: el profesor deja la lista de excepciones vacía; aquí el rol de administrador puede saltarse las reglas (decisión del líder).
- Sin copiar (no está en el JSON): «Require an additional approval for unattributed Copilot pull requests»; se marca en la interfaz o al importar el JSON exportado por el profesor.

## Reglas del equipo
- El trabajo `pr-meta` del CI revisa el nombre de la rama, el formato de los commits y la plantilla del PR cuando la variable del repositorio `ENFORCE_BRANCH_RULES=true`.
- La revisión de otra persona (una, obligatoria) es regla del equipo.
- Cuando el Tech Lead aprueba su propio PR, anota el motivo en el PR (CA-06 de la spec 005).
- `.github/CODEOWNERS` solicita revisores por área.
