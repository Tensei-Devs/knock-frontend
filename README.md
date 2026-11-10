# Knock · Frontend

Knock conecta a personas con técnicos de confianza (mecánica, plomería, electricidad) de su colonia, empezando por una ciudad piloto. Este repositorio es el **frontend**: la app móvil Android, el panel web interno y la landing page. La descripción completa del proyecto está en `docs/descripcion-del-proyecto.md`.

Este repositorio se construye con **Spec Driven Development (SDD)**: cada cambio parte de una spec aprobada. Contiene la app Flutter (`app/`), el panel Angular (`panel/`), la landing (`landing/`) y las specs (`specs/`). Cómo contribuir: [`CONTRIBUTING.md`](CONTRIBUTING.md); vulnerabilidades: [`SECURITY.md`](SECURITY.md).

## Cómo compilar y probar
Requisitos: Flutter 3.47.7 (stable) para la app, Node con npm 10 para el panel y Python 3.11 o superior para los scripts de `scripts/`.
```bash
# App móvil (Flutter): ejecutar en un emulador Android encendido y probar
cd app && flutter pub get && flutter run
cd app && flutter analyze --fatal-infos && flutter test

# Panel web (Angular): ejecutar en http://localhost:4200 y probar
cd panel && npm ci && npm start
cd panel && npm run lint && npm test && npm run build

# Scripts de gobierno y sus pruebas
python scripts/sdd_lint.py
python scripts/ci/test_branch_rules.py
```
Más detalle en `app/README.md`, `panel/README.md` y `landing/README.md`.

## Contenido
- `constitution.md`: reglas no negociables del proyecto.
- `AGENTS.md`: manual para agentes de IA y personas.
- `Memoria.md`: memoria del proyecto.
- `.opencode/`: subagentes y skills para opencode; `opencode.json` carga la constitución y la memoria como contexto.
- `docs/descripcion-del-proyecto.md`: descripción del proyecto en palabras comunes; es la fuente de la que salen la constitución y las specs.
- `specs/`: una carpeta por spec con `spec.md`, `plan.md` y `task.md`.

## Specs de la base
| Spec | Tema | Estado |
|---|---|---|
| [001-arquitectura-de-la-app-movil](specs/001-arquitectura-de-la-app-movil/spec.md) | Arquitectura de la app móvil | Borrador |
| [002-piezas-comunes-de-la-app](specs/002-piezas-comunes-de-la-app/spec.md) | Piezas comunes de la app | Borrador |
| [003-arquitectura-del-panel-web](specs/003-arquitectura-del-panel-web/spec.md) | Arquitectura del panel web | Borrador |
| [004-landing-page-estructura-y-publicacion](specs/004-landing-page-estructura-y-publicacion/spec.md) | Landing page: estructura y publicación | Borrador |
| [005-estructura-del-repositorio-y-flujo-de-trabajo](specs/005-estructura-del-repositorio-y-flujo-de-trabajo/spec.md) | Estructura del repositorio y flujo de trabajo | Borrador |
| [006-contrato-de-la-api-y-cliente-generado](specs/006-contrato-de-la-api-y-cliente-generado/spec.md) | Contrato de la API y cliente generado | Borrador |
| [007-integracion-continua-y-publicacion](specs/007-integracion-continua-y-publicacion/spec.md) | Integración continua y publicación | Borrador |
| [008-calidad-pruebas-y-estandares](specs/008-calidad-pruebas-y-estandares/spec.md) | Calidad, pruebas y estándares | Borrador |
| [009-seguridad-y-configuracion-del-cliente](specs/009-seguridad-y-configuracion-del-cliente/spec.md) | Seguridad y configuración del cliente | Borrador |
| [010-cache-y-trabajo-sin-conexion](specs/010-cache-y-trabajo-sin-conexion/spec.md) | Caché y trabajo sin conexión | Borrador |
| [011-versionamiento-por-puntos](specs/011-versionamiento-por-puntos/spec.md) | Versionamiento por puntos | Borrador |
| [012-notificaciones-push-y-permisos-del-telefono](specs/012-notificaciones-push-y-permisos-del-telefono/spec.md) | Notificaciones push y permisos del teléfono | Borrador |

## Cómo usarlo con opencode
```bash
opencode            # en la raíz del repositorio; lee AGENTS.md y opencode.json
```
Ejemplos: `@spec-writer refina la spec 001`, `@plan-writer escribe el plan de la spec 001`, `@constitution-reviewer revisa la carpeta specs/`.
