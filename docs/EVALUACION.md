# Evaluación de la app, el panel y la landing: respuestas verificadas

Fecha: 2026-11-26. Base: rama `sprint-05`, commit `73a0f7a` (incluye hasta el PR #130). Cubre la parte móvil de la rúbrica y la sección 3 (suite en dispositivo físico). La parte de backend corresponde al repositorio `knock-backend`.

Estados: **Cumple**, **Parcial**, **No cumple** y **No verificado**. «No verificado» marca lo que no se puede comprobar con el código y las corridas de este repositorio. **Pendiente** marca trabajo sin resultado que citar.

Corrida citada: `ci-pr` `45889666320` (sobre `73a0f7a`, en verde; el job del panel se omitió en esa corrida).

## 1. Móvil

### Seguridad

**Controles de seguridad móvil: 64 % (9 de 14).** Es una lista interna, no una certificación. Fórmula: controles presentes / 14.

| # | Control | ¿Presente? | Evidencia |
|---|---|---|---|
| 1 | SAST | Sí | Semgrep en `.github/workflows/ci-pr.yml` |
| 2 | Análisis de dependencias (SCA) | Sí | OSV-Scanner y dependency-review en `ci-pr.yml` |
| 3 | Búsqueda de secretos en CI | Sí | Gitleaks en `ci-pr.yml` |
| 4 | Tokens en almacén seguro | Sí | `app/lib/core/sesion/almacen_seguro.dart` (`flutter_secure_storage`) |
| 5 | Solo HTTPS hacia la API | Sí | `app/lib/core/red/configuracion_api.dart` (`http` solo hacia la propia máquina o el emulador) |
| 6 | Permisos mínimos | Sí | `app/android/app/src/main/AndroidManifest.xml` |
| 7 | `allowBackup=false` | Sí | Mismo manifiesto |
| 8 | Pruebas de seguridad en CI | Sí | `flutter test` incluye `app/test/seguridad/` |
| 9 | Umbral de cobertura | Sí | `scripts/check_coverage.py`, mínimo 50 % en la app |
| 10 | Secret scanning de GitHub | No | Desactivado en los ajustes del repositorio (consulta del 26-nov) |
| 11 | Análisis del binario o DAST móvil | No | No hay un paso en los workflows |
| 12 | Ofuscación en la publicación | No | `publish-android.yml` compila sin `--obfuscate` |
| 13 | Fijación de certificado | No | No se encontró en `app/lib` ni en `app/android` |
| 14 | Detección de root o manipulación | No | No se encontró en `app/lib` ni en `app/android` |

| Pregunta | Respuesta | Evidencia | Estado |
|---|---|---|---|
| ¿Nivel bancario? | No. Faltan los controles 11 a 14; tampoco se identificó biometría local ni un pentest. La app apaga la miniatura de la pantalla de la visita en la vista de recientes (Android 13 o posterior) | Tabla anterior; `app/lib/core/plataforma/captura_en_recientes.dart` | No cumple |
| ¿Vulnerabilidades críticas? | Sin hallazgos en la corrida citada: OSV-Scanner (154 paquetes de pub y 521 del panel), Semgrep (140 reglas, 0 hallazgos) y dependency-review (nada de severidad alta o mayor). No se analizó el binario. La excepción EXC-005 (dependencia del panel) vence el 17-dic | Corrida `45889666320`; `security/exceptions.yaml` | Parcial |
| Excepciones de seguridad | Registradas con vencimiento (EXC-001 a EXC-005) y revisadas en CI | `security/exceptions.yaml`, `scripts/ci/check_exceptions.py` | Cumple |
| Herramientas en CI | Gitleaks, Semgrep, OSV-Scanner, dependency-review, formato, `flutter analyze` con avisos como error, pruebas con cobertura (75.9 % de líneas, mínimo 50 %), contrato y clientes generados, oasdiff, compilación del APK de depuración, gobierno SDD, pruebas de la landing y, cuando aplica al panel, lint, tipos, pruebas, compilación y `npm audit`. No hay análisis de CodeQL en estos workflows (solo su acción para subir el informe de Semgrep) | `.github/workflows/ci-pr.yml`, `_governance.yml` | Cumple |
| Herramientas en CD | Compila el AAB firmado, lo sube a la pista interna de Google Play y etiqueta la versión. La última corrida exitosa es del 21-nov (`44951470631`, commit `a7f3351`): no incluye lo integrado después | `.github/workflows/publish-android.yml` | Parcial |

### OWASP Mobile Top 10 (2024)

| Riesgo | Situación | Estado |
|---|---|---|
| M1 Credenciales | Gitleaks en CI; la URL de la API y la clave de Maps llegan por variables al compilar | Cumple |
| M2 Cadena de suministro | OSV-Scanner, dependency-review, `flutter pub get --enforce-lockfile` y acciones fijadas por SHA | Cumple |
| M3 Autenticación y autorización | Celular verificado con Firebase, sesión de la API con renovación y cierre; la autorización la decide el backend | Cumple |
| M4 Validación de entrada y salida | Errores tipados y validación de las respuestas contra el contrato; no se identificó una prueba transversal de inyección | Parcial |
| M5 Comunicación | Solo HTTPS; sin fijación de certificado | Parcial |
| M6 Privacidad | Ubicación aproximada, familias de caché limitadas y consentimientos. La descarga de datos va apagada (`EXPORTACION_DE_DATOS`) | Parcial |
| M7 Protecciones del binario | Sin ofuscación en el comando de publicación ni detección de manipulación | No cumple |
| M8 Configuración | `allowBackup=false`; la revisión de la configuración no fue exhaustiva | Parcial |
| M9 Almacenamiento | Tokens en almacén seguro | Cumple |
| M10 Criptografía | No se identificó criptografía propia para el transporte o los tokens; la revisión no fue exhaustiva | No verificado |

El OWASP Top 10 web del panel y la landing no se evaluó por separado: **No verificado**.

### Endpoints que consume la app

**78 operaciones** (método y ruta, prefijo `/api/v1`) tienen código de llamada a la API en `app/lib`. Estado: **Parcial**, porque este documento no acredita pruebas contra el backend desplegado y no todas se usan en la compilación por omisión:

- 71 tienen quien las llame fuera de la capa de datos y ningún interruptor apagado (no se recorrió cada una desde su pantalla).
- 5 dependen de interruptores apagados por omisión: `POST solicitudes` y las 2 de `imagenes/subidas` (`SUBIDA_DE_FOTOS`), y las 2 de `me/exportaciones` (`EXPORTACION_DE_DATOS`).
- 2 tienen repositorio, pero nada fuera de la capa de datos las llama: `POST opiniones/{id}/respuesta` y `PUT tecnicos/me/disponibilidad`.

| Operaciones | Nº |
|---|---|
| `POST auth/firebase`, `auth/refresh`, `auth/logout` | 3 |
| `GET` y `PUT me`; `GET me/sesiones`; `DELETE me/sesiones/{id}` | 4 |
| `GET me/pendientes`; `POST me/eliminacion` y `me/eliminacion/cancelar` | 3 |
| `GET` y `PUT me/consentimientos`; `POST me/exportaciones`; `GET me/exportaciones/ultima` | 4 |
| `GET` y `POST me/direcciones`; `PUT` y `DELETE me/direcciones/{id}` | 4 |
| `GET` y `POST me/casa-y-auto`; `PUT` y `DELETE .../{id}`; `GET .../{id}/historial` | 5 |
| `GET me/tecnicos-confianza`; `PUT` y `DELETE .../{id}` | 3 |
| `GET oficios`, `oficios/{clave}`, `colonias/en-punto`, `zonas/cp/{cp}`; `POST oficios-pedidos`, `zonas/lista-espera` | 6 |
| `GET explorar`, `busqueda`, `tecnicos/autocompletar` | 3 |
| `POST tecnicos`; `GET tecnicos/{id}` y sus `/servicios`, `/fotos-trabajos`, `/llega-a-mi-colonia` | 5 |
| `POST tecnicos/me/servicios`; `PUT` y `DELETE .../{id}` | 3 |
| `GET` y `PUT tecnicos/me/horarios`; `PUT tecnicos/me/disponibilidad` | 3 |
| `GET` y `POST solicitudes`; `GET solicitudes/{id}` y `.../{id}/cotizaciones`; `POST .../{id}/elegir` y `.../{id}/ampliar` | 6 |
| `POST imagenes/subidas` y `.../{id}/confirmar` | 2 |
| `GET visitas/{id}`; `POST` sus `/aviso`, `/cancelar`, `/reprogramar`, `/no-terminado` | 5 |
| `GET visitas/{id}/cotizacion-final` y `visitas/{id}/ajustes-pendientes`; `POST visitas/{id}/cotizacion-final/decision` y `ajustes/{id}/decision` | 4 |
| `GET tecnicos/{id}/opiniones`; `POST visitas/{id}/opinion` y `opiniones/{id}/respuesta` | 3 |
| `POST reportes`; `GET reportes/me`; `POST reportes/{id}/apelacion` | 3 |
| `POST` y `DELETE usuarios/{id}/bloqueo`; `GET me/bloqueos` | 3 |
| `GET avisos` y `avisos/no-leidos/contador`; `POST avisos/{id}/leido` y `avisos/leidos`; `GET` y `PUT me/preferencias-avisos` | 6 |
| **Total** | **78** |

No se cuenta la subida directa de la foto al almacenamiento con el enlace temporal. Las llamadas están en `app/lib/features/*/data/` y `app/lib/core/sesion/`.

### Funciones de la app

| Pregunta | Respuesta | Evidencia | Estado |
|---|---|---|---|
| Modo maqueta | `MODO_MAQUETA` está **encendido por omisión** y `publish-android.yml` no lo apaga: una publicación con este código usa la interfaz de la maqueta. Lo conectado usa la API; lo que no, datos de ejemplo | `app/lib/core/config/modo_maqueta.dart`, `publish-android.yml` | Parcial |
| ¿Logout consumiendo el endpoint? | Sí, `POST auth/logout` | `app/lib/core/sesion/sesion.dart`, `perfil_repository_api.dart` | Cumple |
| Persistencia de sesión | Tokens en almacén seguro, renovación y cierre si la renovación se rechaza | `app/lib/core/sesion/`, `app/test/integracion_api/` | Cumple |
| Eliminar la cuenta | La app consulta los pendientes, programa la eliminación y la cancela contra la API (spec 029); la landing tiene la página `/eliminar-cuenta/`. Sin prueba contra el backend desplegado; la versión publicada el 21-nov no se comprobó | `eliminacion_repository_api.dart`, `app/lib/features/maqueta/eliminar_real.dart`, `landing/eliminar-cuenta/` | Parcial |
| Permisos de la app | En el manifiesto principal: `INTERNET` y `ACCESS_COARSE_LOCATION`. Las fotos usan `image_picker`, sin declarar `CAMERA` | `AndroidManifest.xml` | Cumple |
| ¿Se mantiene viva al cerrar? | El manifiesto principal no declara ningún `<service>` | `AndroidManifest.xml` | Cumple |
| Moderación de imágenes | La app no modera. La decisión es del backend; su activación no se verifica desde este repositorio | `app/lib/core/errores/failure.dart` | No verificado |
| Moderación de texto | La app maneja `content_rejected` y `moderation_unavailable` como errores tipados. La activación en el backend no se verifica desde este repositorio | `app/lib/core/errores/` | No verificado |
| Notificaciones push | No hay push en ningún flujo: sin `firebase_messaging`, y el registro del dispositivo es `RegistroDispositivosSimulado`. La app tiene bandeja de avisos propia | `app/lib/core/notificaciones/registro_dispositivos.dart`, `app/pubspec.yaml` | No cumple |
| Machine learning | No hay funciones de ML en la app | `app/pubspec.yaml` | No cumple |
| IA generativa | No hay llamadas a `asistente/*`; la ruta `/m/asistente` es de la maqueta | `app/lib/features/maqueta/fachada_maqueta.dart` | No cumple |
| Caché | Caché local con revalidación por `ETag` y familias de clave limitadas (spec 010) | `app/lib/core/cache/` | Cumple |
| Límite de peticiones | Lo aplica el backend; la app respeta `Retry-After` ante un 429 | `app/lib/core/red/espera_por_limite.dart` | Cumple |
| Paginación | Por cursor (`cursor`, `nextCursor`) | `app/lib/core/red/paginas_por_cursor.dart` | Cumple |
| Serialización JSON | Cliente Dart generado desde el contrato OpenAPI (usado, entre otros, en el canje de sesión y las cotizaciones) y lectura validada en los demás repositorios | `app/packages/knock_api/`, `app/lib/core/red/contrato_json.dart` | Cumple |
| Versionamiento | Por puntos: `scripts/ci/version.py` calcula la versión y el `versionCode` | `docs/VERSIONAMIENTO.md` | Cumple |

### Agentes, skills, MCP y memoria

| Pregunta | Respuesta | Evidencia | Estado |
|---|---|---|---|
| Agentes de IA (desarrollo) | 10 definiciones en `.opencode/agents/` y 6 en `.agents/agents/` | Esas carpetas | Cumple |
| Skills | 16 en `.opencode/skills/` y 10 en `.agents/skills/` | Esas carpetas | Cumple |
| Memoria del proyecto | `Memoria.md`, con las decisiones, su porqué y qué evitar | `Memoria.md` | Cumple |
| MCP | `.mcp.json` declara solo Atlassian (Jira en lectura, OAuth por persona). GitHub se usa por línea de comandos | `.mcp.json`, `docs/mcp.md` | Cumple |

### Pruebas

La corrida citada ejecutó **1301 pruebas de la app, todas correctas**; no las separa por tipo. Las demás cifras de la app son declaraciones `test` y `testWidgets` contadas en el código, distintas de las ejecuciones.

| Tipo | Respuesta | Evidencia | Estado |
|---|---|---|---|
| Total ejecutado | 1301 correctas | Corrida `45889666320` | Cumple |
| Unitarias, de widget y demás de `app/test` | 1122 declaraciones en 163 archivos: `core` 240, `features` 827 y el resto 55 (incluye seguridad, servidor falso y las de la fila «Otras») | `app/test/` | Cumple |
| Seguridad | 16 declaraciones en 2 archivos, más pruebas de sesión y red en `app/test/core/`; no hay pruebas de seguridad dedicadas por repositorio de API | `app/test/seguridad/` | Parcial |
| Integración | 7 declaraciones contra un **servidor falso** y 4 en `integration_test`, que el CI no ejecuta. No se identificó ninguna contra el backend real | `app/test/integracion_api/`, `app/integration_test/`, `ci-pr.yml` | No cumple |
| Otras | Arquitectura 8, calidad 12, API y contrato 6, localización 4 y Android 2; las pruebas de la landing pasaron en la corrida citada | `app/test/`, `landing/tests/` | Cumple |
| Panel (Angular) | 5 archivos `*.spec.ts`; no se ejecutaron en la corrida citada | `panel/src/` | No verificado |

### Flujos de pantalla y pruebas

«Unitarias o widget» indica que hay pruebas en `app/test` del flujo o de su repositorio; no garantiza que cubran cada operación. Ningún flujo tiene en la base una prueba contra el backend real. «Seguridad dedicada» se refiere a `app/test/seguridad/` y a las pruebas de sesión.

| Flujo | Unitarias o widget | Seguridad dedicada | Integración (servidor falso) | Estado |
|---|---|---|---|---|
| Entrada, renovación y salida | Sí | Pruebas de sesión | Sí | Parcial |
| Perfil | Sí | No | Sí | Parcial |
| Inicio, zona y colonia | Sí | No | Solo colonia | Parcial |
| Explorar y búsqueda | Sí | No | No | Parcial |
| Perfil del técnico, opiniones y confianza | Sí | No | No | Parcial |
| Solicitud, fotos y ampliar | Sí | No | No | Parcial |
| Comparar y elegir cotización | Sí | No | No | Parcial |
| Visita, aviso y precio de la visita | Sí | No | No | Parcial |
| Cancelar, reprogramar y no terminado | Sí | No | No | Parcial |
| Reportes y bloqueos | Sí | No | No | Parcial |
| Avisos y preferencias | Sí | No | No | Parcial |
| Cuenta: sesiones, privacidad y eliminación | Sí | No | No | Parcial |
| Direcciones, Mi casa y mi auto | Sí | No | No | Parcial |
| Oficios: detalle y pedido de oficio nuevo | Sí | No | No | Parcial |
| Técnico: alta, horarios y servicios | Sí | No | No | Parcial |

## 3. Suite en dispositivo físico

| Pregunta | Respuesta | Evidencia | Estado |
|---|---|---|---|
| ¿Qué hay en la base? | 4 pruebas `integration_test`: recorrido de la maqueta, pestañas, configuración y rendimiento del mapa (esta última pensada para un Android físico en modo `profile`) | `app/integration_test/` | Parcial |
| ¿Corre en CI? | No: `ci-pr.yml` no ejecuta `integration_test` | `.github/workflows/ci-pr.yml` | No cumple |
| ¿Corrida en teléfono físico con evidencia? | Pendiente: este documento no cita ninguna corrida | Sin evidencia que citar | No verificado |
| ¿Suite contra el backend real? | En la base no se identificó ninguna; cualquier ampliación de la suite está pendiente de integrarse | `app/integration_test/` | No cumple |
