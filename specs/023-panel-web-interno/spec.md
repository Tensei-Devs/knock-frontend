# Spec 023 — Panel web interno: entrada con permisos y doble factor

> **Jira:** KNOCK-75 («HU-066 · Entrar al panel interno con permisos y doble factor», verificada en Jira el 9 de noviembre de 2026; etiquetas `sprint-5`, `candidata-recorte` y `resp-libre`) · **Épica:** EP-12 Panel interno · **Módulo:** trust (panel) · **Responsable:** Ángel Alexis Blas Castillo (la ficha lo asigna; en Jira está libre y la capa Panel web puede repartirse) · **Sprint:** S5 · **Puntos:** 3 · **Capas:** Panel web
> **Repositorio:** knock-frontend · **Otra parte en:** knock-backend, spec 033 «Panel interno con permisos y doble factor» (sesión del panel, TOTP, permisos y auditoría)
> **Fuentes:** `docs/backlog/HU-066.md` · spec 003 «Arquitectura del panel web» · `docs/arquitectura-panel.md`
> **Skills:** `angular-panel`, `api-client-contract`, `testing-strategy-frontend`, `security-core`
> **Contrato:** `contracts/openapi.v1.json` todavía **no** incluye las rutas del panel; las fija backend 033 y se vendorizan antes de implementar (spec 006). El cliente TypeScript se genera, no se escribe a mano.
> **Estado:** Aprobada

## 1. Objetivo

Que una persona del equipo de Knock entre al panel web interno con su celular, el código SMS y un segundo factor (TOTP), y que cada pantalla y cada acción respeten sus permisos, sin dar acceso a más datos de los necesarios. Esta spec cubre el **inicio de sesión del panel**, la estructura de rutas protegidas, el menú por permisos, los estados y la accesibilidad; **no** construye las pantallas de negocio (verificación, reportes, reseñas, catálogos y métricas: HU-067, HU-069 y HU-070).

## 2. Historia y casos de prueba

**KNOCK-75** — Como persona del equipo de Knock, quiero entrar al panel interno con permisos y doble factor, para operar sin acceder a más datos de los necesarios.

- **CA-01:** Dada una persona con rol de administrador y TOTP configurado, cuando captura su celular, el código SMS y el código TOTP, entonces accede al panel y ve solo el menú de los permisos que tiene. · Verificación: `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_01`
- **CA-02:** Dado el paso del segundo factor, cuando no se captura el código TOTP o el servidor responde 401 `invalid_code`, entonces no se accede, se lee «Código incorrecto. Revisa tu app de autenticación.» y la persona sigue en el paso del TOTP mientras el desafío esté vigente; el panel puede mostrar «Te quedan {n} intentos» con un contador solo visual (5 por cuenta), porque el bloqueo lo decide el servidor. · Verificación: `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_02`
- **CA-03:** Dada una cuenta sin rol de administrador, cuando intenta entrar, entonces recibe 403, ve «Esta cuenta no tiene acceso al panel» y no queda sesión. · Verificación: `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_03`
- **CA-04:** Dada una persona sin un permiso, cuando navega a una ruta que lo exige o dispara esa acción, entonces la guarda redirige a «Sin permiso»; si el servidor responde 403 `insufficient_permission`, se muestra el mismo aviso **sin** cerrar la sesión; el elemento de menú ni siquiera aparece. · Verificación: `panel/src/app/core/auth/permisos.guard.spec.ts` → `CA_023_04`
- **CA-05:** Dado un cambio de permisos o una sesión revocada mientras usa el panel, cuando el servidor responde 401 con `permissions_changed` o `invalid_session`, entonces se limpia la memoria, se vuelve a la pantalla de acceso y se lee «Tus permisos cambiaron. Entra de nuevo.» o «Tu sesión terminó. Entra de nuevo.». · Verificación: `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_05`
- **CA-06:** Dada una persona inactiva durante 15 minutos, cuando pasa el tiempo, entonces el panel cierra la sesión, avisa «Cerramos tu sesión por inactividad» y pide entrar de nuevo. · Verificación: `panel/src/app/core/auth/inactividad.service.spec.ts` → `CA_023_06`
- **CA-07:** Dados varios intentos fallidos (el servidor bloquea la cuenta con 5 fallos en 15 minutos, 429 `locked`, o la IP con 10, 429 `limit_exceeded`), cuando llega la respuesta 429 con `Retry-After`, entonces se muestra el tiempo de espera, se deshabilita el botón y no se reintenta solo. · Verificación: `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_07`
- **CA-08:** Dada una sesión iniciada, cuando se inspeccionan `localStorage`, `sessionStorage`, IndexedDB y las cookies accesibles, entonces no hay tokens, permisos ni datos de personas; los tokens viven solo en memoria. · Verificación: `panel/src/app/core/auth/almacen-sesion.spec.ts` → `CA_023_08`
- **CA-09:** Dado el cierre de sesión, cuando se toca «Salir», entonces el panel llama al servidor, vacía la memoria y no se puede volver con el botón de atrás. · Verificación: `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_09`
- **CA-10:** Dado un componente que importa `HttpClient`, cuando corre el lint, entonces falla; solo los servicios hacen peticiones (spec 003, R-04). · Verificación: (comando) `cd panel && npm run lint` y `npm run test:architecture`
- **CA-11:** Dado el panel desplegado, cuando se piden sus páginas, entonces responden con HTTPS, `X-Robots-Tag: noindex`, `Content-Security-Policy` sin `unsafe-inline` para scripts, `X-Frame-Options: DENY` y `Referrer-Policy: no-referrer`. · Verificación: `panel/src/app/architecture/encabezados-panel.spec.ts` → `CA_023_11`
- **CA-12:** Dadas las pantallas de acceso y «Sin permiso», cuando se recorren solo con teclado y lector de pantalla, entonces el foco es visible, el orden es lógico, los errores se anuncian con `aria-live` y el contraste cumple 4.5:1. · Verificación: `panel/src/app/features/acceso/pages/accesibilidad-acceso.spec.ts` → `CA_023_12`
- **CA-13:** Dada una pantalla sin conexión o con el servidor caído, cuando se intenta entrar, entonces se muestra «No pudimos conectar» con «Reintentar», sin el código HTTP ni el cuerpo. · Verificación: `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_13`
- **CA-14:** Dada una cuenta de la app móvil (cliente o técnico) sin permisos de panel, cuando intenta entrar, entonces no obtiene permisos por sí sola (HU-066 §8) y recibe el mismo 403 de CA-03. · Verificación: `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_14`
- **CA-15:** Dada la pantalla de acceso, cuando se carga, entonces no usa `innerHTML` ni `bypassSecurityTrust*`, y el texto del error viene del catálogo, nunca del cuerpo de la respuesta. · Verificación: (comando) `cd panel && npm run lint`
- **CA-16:** Dado el registro del navegador, cuando se entra o se falla, entonces `console` no contiene celular, códigos, tokens ni permisos. · Verificación: `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_16`
- **CA-17:** Dadas la renovación y el cierre, cuando el panel los llama, entonces van con `withCredentials`, el encabezado `X-Knock-Panel: 1` y sin cuerpo; un 403 `origin_not_allowed` limpia la memoria y vuelve al acceso. · Verificación: `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_17`
- **CA-18:** Dado un desafío de TOTP vencido (5 minutos) o ya usado, cuando la persona captura el código, entonces recibe 401 `challenge_expired`, ve «Tu código venció. Vuelve a empezar.» y el panel regresa al paso del celular. · Verificación: `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_18`
- **CA-19:** Dado un 503 `unavailable` o `audit_unavailable`, cuando se intenta entrar o actuar, entonces no se concede nada, se lee «El panel no está disponible en este momento. Intenta en unos minutos.» y «Reintentar» respeta `Retry-After`. · Verificación: `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_19`
- **CA-20:** Dadas dos pestañas del panel con la sesión abierta, cuando ambas necesitan renovar a la vez, entonces solo una llama a `renovar` a la vez con el cerrojo de Web Locks, la otra usa la cookie nueva, y un 401 `invalid_session` se reintenta una vez antes de cerrar la sesión local. · Verificación: `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_20`
- **CA-21:** Dado un enlace de activación abierto, cuando se carga `/activar`, entonces el token se borra de la URL, se llama una sola vez a `POST /api/v1/panel/activacion`, se muestra el QR y la clave, y ni el token ni el secreto quedan en el almacenamiento, los registros ni el `Referer`; un 410 muestra «Este enlace ya no sirve. Pide uno nuevo.». · Verificación: `panel/src/app/features/acceso/pages/activacion-page.spec.ts` → `CA_023_21`

## 3. Alcance / No-alcance

**Dentro (capa Panel web)**
- Pantalla de acceso en tres pasos: celular, código SMS y código TOTP.
- Servicio de sesión del panel con tokens en memoria, renovación y cierre.
- Guarda de rutas por permiso, menú por permisos y página «Sin permiso».
- Cierre por inactividad y por cambio de permisos.
- Estados de carga, error, sin conexión y espera por límite de intentos.
- Encabezados de seguridad del despliegue en Railway y accesibilidad.
- Pruebas unitarias, de componente y de arquitectura con Vitest.

**Fuera**
- Las pantallas de negocio (verificación de identidad, reportes, reseñas, catálogos y métricas: HU-067, HU-069, HU-070).
- Alta de cuentas del panel y del TOTP: se crean con semilla o herramienta interna (HU-066 §3).
- Recuperación de TOTP perdido (proceso interno).
- Los permisos, el TOTP y las tablas: backend.
- Inicio de sesión de la app móvil (specs 015 a 018 de backend y KNOCK-228).

### Requisitos

- **R-01:** El acceso pide celular, código SMS y TOTP en ese orden; el segundo factor es obligatorio para toda cuenta del panel.
- **R-02:** Los permisos son `verification:review`, `reports:resolve`, `reviews:moderate`, `catalog:manage` y `metrics:read`; vienen del servidor en la respuesta de la sesión y la app no los infiere.
- **R-03:** Los tokens y los permisos viven solo en memoria del navegador (no en `localStorage`, `sessionStorage`, IndexedDB ni cookies accesibles por script).
- **R-04:** Cada ruta de negocio declara el permiso que exige en sus datos de ruta; la guarda lo verifica y el servidor vuelve a verificarlo en cada acción.
- **R-05:** El menú solo muestra lo que la persona puede usar.
- **R-06:** Un 401 con `permissions_changed` o `invalid_session` revoca la sesión local y vuelve al acceso; un 403 `insufficient_permission` solo muestra «Sin permiso» y conserva la sesión.
- **R-07:** La sesión se cierra tras 15 minutos de inactividad y se avisa; además, el servidor la termina a las 8 horas del acceso y la renovación responde 401 `invalid_session`.
- **R-08:** Los errores no revelan si fue el celular, el SMS o el TOTP lo que falló.
- **R-09:** Ante un 429 `limit_exceeded` o `locked` el panel respeta `Retry-After` y no reintenta solo. El servidor decide el bloqueo: cuenta los fallos por cuenta (5 en 15 minutos, de forma persistente) y por IP (10); el contador que muestra el panel es solo visual y nunca decide nada.
- **R-10:** Los componentes no usan `HttpClient` (spec 003, R-04); los servicios usan el cliente TypeScript generado (spec 006).
- **R-11:** El panel no usa `innerHTML` ni `bypassSecurityTrust*` sin revisión (spec 003, R-07).
- **R-12:** Cada pantalla tiene estados de carga, error, sin conexión y espera; los textos viven en el catálogo de traducciones del panel y los colores en el tema de Angular Material.
- **R-13:** Cumple el nivel AA de contraste y es operable solo con teclado.
- **R-14:** El panel se despliega en Railway con HTTPS obligatorio, `noindex` y los encabezados de CA-11.
- **R-15:** Nada del acceso se registra en consola ni en reportes de errores.
- **R-16:** **Dos pestañas.** La renovación se serializa entre pestañas con Web Locks (`navigator.locks`); la pestaña que espera renueva con la cookie vigente y un 401 `invalid_session` de `renovar` se reintenta una vez antes de cerrar la sesión local. La misma decisión está en backend 033 R-17 (gracia de 10 segundos, 401 sin revocar). Si el servidor rota y la respuesta se pierde, hay que repetir el acceso de dos pasos (riesgo residual documentado allí).
- **R-17:** **Activación del TOTP.** La ruta `/activar` lee el token del fragmento `#` de la URL, lo borra de inmediato (`history.replaceState`), lo envía en el cuerpo de `POST /api/v1/panel/activacion` y muestra el código QR y la clave solo por TLS, sin guardarlos ni registrarlos; el panel envía `Referrer-Policy: no-referrer`. Un 410 `activation_invalid` se lee «Este enlace ya no sirve. Pide uno nuevo.».

## 4. Contrato API y eventos

El panel **consume** las cuatro rutas de sesión de backend 033 («Panel interno con permisos y doble factor»); alineado el 9 de noviembre de 2026 con su borrador.

| Método y ruta | Uso en el panel | Cuerpo / parámetros | Respuesta | Errores que el panel distingue |
|---|---|---|---|---|
| `POST /api/v1/panel/sesion/celular` | Paso 1: verificar el celular con el ID token de Firebase | `{ idToken }` (1 a 4 096 caracteres) | `200` con `{ desafioId, requiereTotp: true, venceEn }` | `400`, `401 invalid_credentials`, `403 no_panel_access`, `429 limit_exceeded` o `locked` con `Retry-After`, `503 unavailable` |
| `POST /api/v1/panel/sesion/totp` | Paso 3: segundo factor | `{ desafioId, codigo }` (`codigo` de exactamente 6 dígitos) | `200` con `{ accessToken, expiraEn, permisos[], nombre }` y la cookie de renovación | `400`, `401 invalid_code` o `challenge_expired`, `403 no_panel_access`, `429 limit_exceeded` o `locked`, `503` (`unavailable`, `audit_unavailable`) |
| `POST /api/v1/panel/sesion/renovar` | Renovar sin pedir todo de nuevo | sin cuerpo · cookie `HttpOnly` · `X-Knock-Panel: 1` · `withCredentials` | `200` como `totp` y cookie nueva | `401` (`invalid_session`, `permissions_changed`), `403 origin_not_allowed`, `429`, `503` |
| `POST /api/v1/panel/activacion` | Activar el TOTP con el enlace de un solo uso | `{ token }` (del fragmento `#` de la URL) | `200` con `{ otpauthUri, qrSvg }` (`Cache-Control: no-store`) | `410 activation_invalid`, `429`, `503` |
| `POST /api/v1/panel/sesion/cerrar` | Salir | sin cuerpo · token del panel · `X-Knock-Panel: 1` | `204` (borra la cookie) | `401`, `403 origin_not_allowed` |
| Cualquier ruta futura del panel | Acciones de negocio | según su spec | según su spec | además: `401 permissions_changed`, `403 insufficient_permission`, `503 audit_unavailable` |

Reglas del contrato que el panel da por ciertas:
- **Sesión:** token de acceso de 15 minutos con destinatario propio del panel (no sirve en la API de la app); cookie de renovación de 20 minutos que el panel nunca lee; sesión máxima de 8 horas; 3 sesiones por cuenta.
- **Permisos:** `permisos[]` con los cinco valores de R-02, sin repetidos; un cambio en el servidor invalida la sesión con `401 permissions_changed`.
- **Errores:** `invalid_credentials` no distingue celular ni SMS; en el segundo paso `invalid_code`, `challenge_expired` y `locked` dicen solo lo que la persona necesita para seguir; ProblemDetails con `code`; el panel nunca muestra el cuerpo.
- **Límites:** desafío de 5 minutos y 5 códigos; 5 fallos por cuenta y 10 por IP en 15 minutos; 10 peticiones por minuto por IP en las rutas de sesión; `Retry-After` en 429 y 503.
- **Idempotencia:** el paso de TOTP no se repite (desafío de un solo uso), la renovación rota el token y el cierre repetido responde 401; el panel no reintenta solo después de un 2xx.
- **Caché:** `Cache-Control: no-store` en todo.
- **Eventos:** ninguno consumido.

## 5. Modelo de datos

| Entidad | Campos | Reglas |
|---|---|---|
| `SesionPanel` | `nombre`, `permisos` (conjunto de cinco valores), `expiraEn` | Solo en memoria; nunca se serializa |
| `Permiso` | `verification:review`, `reports:resolve`, `reviews:moderate`, `catalog:manage`, `metrics:read` | Lista cerrada; un valor desconocido se ignora |
| `PasoDeAcceso` | `celular`, `codigoSms`, `totp`, `bloqueado` | Máquina de estados del formulario |

**Estado local**
- Memoria de un servicio de Angular (`SesionPanelService`) con señales; **nada** en almacenamiento del navegador (R-03).
- Se limpia al cerrar sesión, por inactividad, por 401 de permisos y al cerrar la pestaña.
- Una recarga de página obliga a renovar (con la cookie `HttpOnly`) o a entrar de nuevo.

## 6. Seguridad, privacidad y amenazas

| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| **Suplantación:** robo de la cuenta con el SMS | Segundo factor TOTP obligatorio | CA-01, CA-02 |
| **Suplantación:** robo del token por XSS | Tokens solo en memoria, sin `innerHTML`, CSP sin `unsafe-inline` para scripts | CA-08, CA-11, CA-15 |
| **Elevación de privilegios:** una cuenta de la app obtiene permisos del panel | El servidor autoriza por permiso; el panel muestra 403 | CA-03, CA-14 |
| **Elevación de privilegios:** usar una acción sin permiso | Guarda, menú por permisos y verificación del servidor en cada acción | CA-04 |
| **Elevación de privilegios:** permisos revocados pero sesión viva | 401 `permissions_changed` revoca la sesión | CA-05 |
| **Fuga de información:** mensajes de error que revelan qué falló | Un solo mensaje para credenciales inválidas | CA-02 |
| **Fuga de información:** datos de sesión en el navegador o consola | Memoria únicamente y sin registros | CA-08, CA-16 |
| **Denegación:** fuerza bruta de TOTP o SMS | Bloqueo por cuenta decidido por el servidor (`locked`), espera obedecida y botón deshabilitado; el contador del panel es solo visual | CA-07 |
| **Clickjacking y rastreo:** incrustar el panel o indexarlo | `X-Frame-Options: DENY`, `noindex`, `Referrer-Policy` | CA-11 |
| **Sesión olvidada en un equipo compartido:** | Cierre por inactividad y botón «Salir» | CA-06, CA-09 |
| **Repudio:** «yo no hice esa acción» | El servidor audita cada acción con el sujeto; el panel muestra el nombre de la persona en la barra | CA-01 |
| **Dependencias:** librería de TOTP o QR vulnerable | El panel no genera TOTP (solo lo captura); si se agrega una librería, se evalúa con OSV y se registra en `Memoria.md` | (comando) `npm audit` y revisión en el PR |

## 7. Pantallas, textos y accesibilidad

| Pantalla (ruta) | Estados | Contenido | Textos (catálogo del panel) |
|---|---|---|---|
| Acceso (`/acceso`) | inicial, enviando, error, bloqueado por espera, sin conexión | Tres pasos con indicador de avance | `acceso.titulo`, `acceso.celular`, `acceso.enviarSms`, `acceso.codigoSms`, `acceso.codigoTotp`, `acceso.entrar`, `acceso.errorGenerico`, `acceso.espera`, `acceso.sinConexion`, `acceso.reintentar` |
| Sin permiso (`/sin-permiso`) | única | Mensaje y botón «Volver al inicio» | `sinPermiso.titulo`, `sinPermiso.detalle`, `sinPermiso.volver` |
| Sin acceso al panel (`/sin-acceso`) | única | «Esta cuenta no tiene acceso al panel» | `sinAcceso.titulo`, `sinAcceso.detalle` |
| Inicio del panel (`/`, se modifica) | con datos | Menú por permisos, nombre y «Salir» | `panel.salir`, `panel.inactividad`, `panel.menu.*` |

**Mensajes exactos** (catálogo del panel, español)

| Situación | Texto en pantalla |
|---|---|
| `invalid_credentials` (401) | «No pudimos verificar tus datos. Vuelve a empezar.» |
| `invalid_code` (401) | «Código incorrecto. Revisa tu app de autenticación.» |
| `challenge_expired` (401) | «Tu código venció. Vuelve a empezar.» |
| `locked` (429) | «Cuenta bloqueada temporalmente. Espera {minutos} minutos.» |
| `activation_invalid` (410) | «Este enlace ya no sirve. Pide uno nuevo.» |
| `no_panel_access` (403) | «Esta cuenta no tiene acceso al panel» |
| `insufficient_permission` (403) | «No tienes permiso para esta sección» |
| `permissions_changed` (401) | «Tus permisos cambiaron. Entra de nuevo.» |
| `invalid_session` (401) u `origin_not_allowed` (403) | «Tu sesión terminó. Entra de nuevo.» |
| Inactividad | «Cerramos tu sesión por inactividad» |
| `limit_exceeded` (429) | «Demasiados intentos. Espera {minutos} minutos.» |
| `unavailable` o `audit_unavailable` (503) | «El panel no está disponible en este momento. Intenta en unos minutos.» |
| Sin conexión | «No pudimos conectar» + «Reintentar» |

Reglas de pantalla:
- Cada paso muestra el avance («Paso 2 de 3») y mueve el foco al primer campo del paso siguiente.
- El campo TOTP acepta solo 6 dígitos y autocompleta con `autocomplete="one-time-code"`.
- Accesibilidad: foco visible, errores en `aria-live="polite"`, etiquetas `label` asociadas, contraste 4.5:1, sin depender solo del color.

## 8. Pruebas, gates y límites

| Tipo | ¿Aplica? | Motivo / herramienta |
|---|---|---|
| Unitarias (UM) | Sí | Servicio de sesión, inactividad, guarda y almacenamiento (Vitest) |
| Componente (W) | Sí | Acceso, sin permiso, menú |
| Aceptación (ACC) | Sí | CA-01 a CA-21 |
| Contrato (CON) | Sí | Cliente TypeScript generado contra `contracts/openapi.v1.json` con las cuatro rutas de backend 033 (panel) |
| Integración (INT) | Sí | API simulada con los tres pasos |
| Seguridad negativa (NEG) | Sí | 403, 401 de permisos, 429, tokens fuera del almacenamiento, encabezados |
| Accesibilidad (A11Y) | Sí | Verificación con axe en las pantallas y recorrido por teclado |
| Mutación (MUT) | Sí | Reglas de permisos y de inactividad con StrykerJS, meta 70 % |
| E2E | Sí | Recorrido en navegador con API simulada: acceso completo y salida |
| Regresión | Sí | `npm run lint`, `npm test` y `npm run build` de la spec 003 |
| Análisis estático y vulnerabilidades | Sí | ESLint, CodeQL, `npm audit` y OSV |
| Rendimiento (PERF) | No | Herramienta interna |

**Escenarios**

| Escenario | Resultado esperado |
|---|---|
| Positivo | Administrador con TOTP entra y ve todo el menú |
| Positivo | Moderadora con solo `reviews:moderate` ve solo ese elemento |
| Negativo | TOTP incorrecto o vacío: no entra y el mensaje no dice qué falló |
| Negativo | Cuenta de cliente de la app: 403 |
| Error esperado | 401 al renovar → vuelve al acceso; 429 → espera; sin conexión → reintentar |
| Caso límite | Código TOTP justo al cambiar de ventana |
| Caso límite | Permisos que cambian con la ruta abierta |
| Caso límite | Dos pestañas: la renovación se serializa con `navigator.locks.request('knock-panel-renovar', …)`; la pestaña que espera, al obtener el cerrojo, renueva con la cookie vigente (el navegador la comparte); un 401 `invalid_session` de `renovar` se reintenta una vez antes de cerrar la sesión local (backend 033 R-17: gracia de 10 segundos sin revocar); cerrar sesión en una cierra la otra (se detecta con el 401 siguiente) |
| Caso límite | Recarga de la página con la sesión viva |

**Gates:** `npm run lint`, `npm test` (incluye `test:architecture`), `npm run build`, revisión de la constitución y de seguridad, y PR con CI en verde (spec 007).

## 9. Arquitectura y componentes

Se respeta la spec 003: `core`, `shared` y `features`, carga diferida por función, TypeScript estricto y cliente generado.

| Archivo | Acción | Contenido |
|---|---|---|
| `panel/src/app/core/auth/sesion-panel.service.ts` | Crear | Estado de sesión con señales, entrada, renovación y salida |
| `panel/src/app/core/auth/almacen-sesion.ts` | Crear | Memoria únicamente; sin almacenamiento del navegador |
| `panel/src/app/core/auth/permisos.guard.ts` | Crear | Guarda por permiso |
| `panel/src/app/core/auth/permiso.ts` | Crear | Lista cerrada de permisos |
| `panel/src/app/core/auth/auth.interceptor.ts` | Crear | Pone el token y maneja 401 y 403 (usa el cliente generado) |
| `panel/src/app/core/auth/inactividad.service.ts` | Crear | Cierre a los 15 minutos |
| `panel/src/app/features/acceso/acceso.routes.ts` | Crear | Rutas diferidas |
| `panel/src/app/features/acceso/pages/acceso-page.ts` | Crear | Los tres pasos |
| `panel/src/app/features/acceso/pages/sin-permiso-page.ts` | Crear | Aviso |
| `panel/src/app/core/layout/app-shell.component.*` | Modificar | Menú por permisos y «Salir» |
| `panel/src/app/app.routes.ts` | Modificar | Rutas y guardas |
| `panel/Caddyfile` | Modificar | Encabezados de seguridad (CA-11) |
| `panel/src/app/architecture/encabezados-panel.spec.ts` | Crear | Prueba de encabezados |
| `panel/src/locale/` o catálogo del panel | Modificar | Textos de §7 |

**No se toca:** `contracts/`, `scripts/`, `.github/`, `.agents/` ni el cliente TypeScript generado.

## 10. Dependencias con otras specs

| Spec | Qué aporta | Efecto si falta |
|---|---|---|
| 003 Arquitectura del panel | Estructura, lint de fronteras, Railway, `noindex` | Sin base |
| 006 Contrato y cliente generado | Cliente TypeScript | No hay forma permitida de llamar a la API |
| Backend 033 Panel interno con permisos y doble factor (otro repositorio) | Rutas, errores, límites, cookie y auditoría | Sin contrato vendorizado no se implementa el servicio de sesión |
| Backend 016 y 018 | Renovación y cierre de sesión, sesiones por dispositivo | Reutilizar su modelo de tokens |
| 007 CI y publicación | Despliegue en Railway | Sin entorno donde probar encabezados |
| 008 Calidad y pruebas | Reglas de pruebas, mutación y accesibilidad | Sin gates |
| 009 Seguridad del cliente | Regla de no registrar datos | — |

## 11. Definición de terminado

- CA-01 a CA-21 con prueba o comando; `python scripts/sdd_lint.py --trace 023` sin `FALTA`.
- `npm run lint`, `npm test`, `npm run build` y `npm audit` sin hallazgos nuevos.
- Encabezados de seguridad comprobados en el entorno desplegado.
- Cuenta de semilla con TOTP probada de extremo a extremo con datos ficticios.
- `Memoria.md` al día; PR con la plantilla completa, etiqueta `puntos-app-N` y CI en verde.

## 12. Decisiones tomadas sin consulta

| # | Decisión | Porqué | Alternativa descartada |
|---|---|---|---|
| D-01 | Tokens solo en memoria; renovación con cookie `HttpOnly` | Reduce el robo por XSS en un panel con datos sensibles | `localStorage`, que cualquier script lee |
| D-02 | Cierre por inactividad a los 15 minutos | Equipos compartidos y alineado con la vida del token | Sin límite |
| D-03 | Un solo mensaje de error en el acceso | No ayudar a adivinar celular o TOTP | Mensajes por paso |
| D-04 | El panel no genera ni muestra códigos QR de TOTP | Las cuentas y el TOTP se crean con herramienta interna (HU-066 §3) | Alta de TOTP en el panel |
| D-05 | Verificar el celular con Firebase y enviar el ID token | Reutiliza el mecanismo de la app y evita otro proveedor de SMS | Un SMS propio |
| D-06 | Lista cerrada de cinco permisos | La ficha los enumera | Permisos libres por cadena |
| D-07 | Las rutas del panel son las de backend 033 | Backend 033 ya las fija con los mismos nombres que propuso esta spec | Esperar para escribir |
| D-08 | `403 insufficient_permission` no cierra la sesión | Backend 033 distingue «sin permiso para esta acción» de «permisos cambiaron» (401) | Cerrar la sesión ante cualquier 403 |

## 13. Riesgos y dudas abiertas

- **Resuelto en la revisión:** backend 033 fija la sesión del panel, el TOTP, los permisos y la auditoría; falta vendorizarlo.
- **Resuelto en la revisión:** backend 033 usa la cookie `__Secure-knock-panel-rt` con `SameSite=None` y `Partitioned`, CORS con credenciales solo para el origen del panel y `X-Knock-Panel: 1` contra CSRF; el panel solo debe llamar con `withCredentials` (CA-17).
- **Riesgo:** Firebase Phone Auth en web requiere reCAPTCHA y tiene cuotas y costo (KNOCK-146); puede chocar con el presupuesto.
- **Riesgo:** la spec 003 dice que el acceso del personal «autenticado» queda fuera; esta spec lo completa y debe actualizar `docs/arquitectura-panel.md`.
- **Duda abierta (para José):** ¿el panel usará Firebase o un SMS propio? **Propuesta por defecto:** Firebase Phone Auth, el mismo proveedor de la app; un SMS propio exigiría cambiar backend 033 antes.
- **Resuelto en la revisión:** los permisos vienen en la respuesta (`permisos[]`, en el orden de la lista cerrada).
- **Duda abierta (para el equipo):** ¿hay una cuenta de semilla con TOTP para el ambiente de pruebas? Hace falta para el E2E. **Propuesta por defecto:** sembrar una cuenta de prueba con TOTP fijo solo en desarrollo y en el CI, nunca en producción.

## Aprobación

- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-12
- [x] Sin conflicto con la constitución
- **Estados:** Borrador (agente) → Aprobada (persona; habilita el código) → Implementada (tras el merge)
