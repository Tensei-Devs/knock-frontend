# Evaluación de la app, el panel y la landing: respuestas verificadas

Fecha: 2026-11-17. Base: rama `sprint-05`. Cada respuesta indica dónde se comprueba en el repositorio. Las cifras de pruebas son declaraciones de prueba contadas en el código (`test` y `testWidgets` en la app; archivos `*.spec.ts` en el panel); no son una corrida de ejecución.

## Seguridad y flujo de trabajo

| Pregunta | Respuesta | Dónde se comprueba |
|---|---|---|
| Herramientas en CI | Gitleaks (secretos), Semgrep (SAST de Dart y TypeScript), OSV-Scanner y `npm audit` (dependencias), CodeQL, `flutter analyze` con avisos como error, verificación de cobertura mínima (`scripts/check_coverage.py`), verificación del contrato y de los clientes generados, y pruebas de la landing y del panel. | `.github/workflows/ci-pr.yml` |
| Herramientas en CD | `publish-android.yml` compila el AAB firmado y lo sube a Google Play en la pista interna. | `.github/workflows/publish-android.yml` |
| Excepciones de seguridad | Registradas con vencimiento en `security/exceptions.yaml`. | `security/exceptions.yaml` |
| Vulnerabilidades críticas | Las excepciones de los escáneres (5 vigentes) están registradas con fecha de vencimiento; el CI las revisa con `scripts/ci/check_exceptions.py`. | `security/exceptions.yaml` |
| MCP | Atlassian (Jira, lectura, OAuth por persona) y GitHub CLI. Configurado en `.mcp.json`. | `docs/mcp.md` |
| Agentes de IA | 10 definiciones: constitution-reviewer, docs-keeper, flutter-builder, implementer, panel-builder, plan-writer, security-reviewer, spec-writer, task-writer y traceability-clerk. | `.opencode/agents/` |
| Skills | 10: angular-panel, api-client-contract, devsecops-audit, flutter-clean-architecture, reuse-before-create, security-core, spec-first-writing, story-workflow, testing-strategy-frontend y traceability. | `.agents/skills/` |
| Aprendizaje del proyecto | `Memoria.md` con una entrada por decisión, su porqué y qué evitar. | `Memoria.md` |
| Versionamiento | Versionamiento por puntos: `scripts/ci/version.py` calcula la versión y el `versionCode` de Android; las etiquetas de Git llevan el componente. | `docs/VERSIONAMIENTO.md` |

## Endpoints que consume la app

La app consume estas rutas de la API real: `POST auth/firebase`, `POST auth/refresh`, `POST auth/logout`, `GET` y `PUT me`, `GET me/sesiones`, `GET oficios`, `GET colonias/en-punto`, `GET zonas/cp/{cp}`, `POST zonas/lista-espera` y `solicitudes`. Los clientes se generan desde el contrato OpenAPI publicado por el backend. La maqueta (`MODO_MAQUETA=true`, apagado por defecto) usa datos de ejemplo en lugar de la API.

| Pregunta | Respuesta | Dónde se comprueba |
|---|---|---|
| ¿Logout consumiendo el endpoint? | Sí. Con la API real, `PerfilRepositoryApi.cerrarSesion` llama a `POST /api/v1/auth/logout`. El repositorio simulado solo se usa si la app se compila con `MODO_MAQUETA=true`. | `app/lib/features/cuenta/data/perfil_repository_api.dart`, `app/lib/core/config/modo_maqueta.dart` |
| Módulo para eliminar la cuenta | La landing publica la página `/eliminar-cuenta/` con el plazo de eliminación. En la app el flujo «Eliminar mi cuenta» existe en la maqueta; la spec 029 de este repositorio define la pantalla y consume el contrato de la spec 039 del backend, cuyo endpoint aún no está implementado. | `landing/eliminar-cuenta/`, `specs/029-cuenta-y-datos-personales` |
| Permisos de la app | En el manifiesto principal de Android: `INTERNET` y `ACCESS_COARSE_LOCATION` (ubicación aproximada). Los avisos push y su permiso quedan para la spec de notificaciones. | `app/android/app/src/main/AndroidManifest.xml` |
| ¿La app se mantiene viva al cerrar? | No declara servicios en segundo plano: el manifiesto no tiene ningún `<service>` y no usa paquetes de trabajo en segundo plano. | `app/android/app/src/main/AndroidManifest.xml`, `app/pubspec.yaml` |
| Machine learning | No hay funciones de ML en la app. | `app/pubspec.yaml` |
| IA generativa | No hay funciones de IA generativa en la app. El cliente de Azure OpenAI y el asistente son del backend (specs 024 y 052) y aún no tienen código. | `specs/`, repositorio `knock-backend` |
| Validación de imágenes | La app elige fotos con el selector del sistema (`image_picker`). El tamaño, el formato y la moderación de imágenes los valida el backend antes de guardarlas (specs 013 y 031); la app muestra el rechazo con un mensaje tipado. | `app/lib/core/errores/failure.dart`, `specs/` |
| Validación de texto | El backend modera el texto antes de guardarlo y responde `422 content_rejected`, o `503 moderation_unavailable` si el servicio no responde; la app los convierte en errores tipados. | `app/lib/core/errores/failure.dart` |

## Caché, límite de peticiones y serialización

| Mecanismo | Respuesta | Dónde se comprueba |
|---|---|---|
| Caché | Sí, la spec 010: `AlmacenCache` en memoria o `shared_preferences`, claves `knock.cache.*`, revalidación con `ETag`. Quedan pendientes la cola local y la caché de imágenes. | `specs/010` |
| Límite de peticiones | Lo aplica el backend; la app maneja el `429` con `Retry-After` como error tipado. | `app/lib/core/errores/failure.dart` |
| Paginación | Según el contrato del backend (`cursor` y `nextCursor`). | `specs/` |
| Serialización JSON | Clientes Dart generados desde el contrato OpenAPI; errores tipados por código de respuesta. | `contracts/`, `app/lib/core/errores/` |
| Versionamiento | Igual que en la sección de seguridad. | `docs/VERSIONAMIENTO.md` |

## Pruebas

| Tipo | Cantidad | Dónde |
|---|---|---|
| Unitarias, de widget y de accesibilidad de la app | 789 declaraciones en 121 archivos | `app/test/` |
| Seguridad | `app/test/seguridad/` (2 archivos) más las pruebas de sesión y de red en `app/test/core/` | `app/test/seguridad/` |
| Integración (`integration_test`) | 3 archivos | `app/integration_test/` |
| Panel (Angular) | 5 archivos `*.spec.ts` | `panel/` |

Otras pruebas: arquitectura de capas (el dominio no depende de Flutter ni de la capa de datos), contrato contra el OpenAPI del backend y verificación de cobertura mínima en el CI.

## Pantallas que consumen endpoints todavía sin implementar en el backend

El flujo de eliminar cuenta y los datos personales (spec 029 y backend 039), direcciones, «Mi casa y mi auto», técnicos de confianza y la mensajería en tiempo real tienen spec aprobada, pero el backend aún no implementa sus endpoints. Mientras no existan, esas pantallas no pueden tener pruebas de integración contra la API real.
