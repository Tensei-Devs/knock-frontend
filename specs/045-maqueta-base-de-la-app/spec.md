# Spec 045 — Maqueta base de la app (reconstrucción visual simulada)

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Jira:** KNOCK-273 (tarea) con las subtareas KNOCK-274 (base común), KNOCK-275 (pantallas del cliente), KNOCK-276 (pantallas del técnico) y KNOCK-277 (mapa real, cobertura y animaciones) · **Capas:** Mobile · **Otra parte en:** — (no agrega ni cambia endpoints)
> **Relacionada con:** specs 014 (UI con la maqueta, solo visual), 027 (previa sin sesión, datos de ejemplo rotulados), 026 (sesión y perfil reales) y las de pantallas 015 a 022 y 025 a 044.
> **Skills:** flutter-clean-architecture, reuse-before-create, testing-strategy-frontend, security-core

## 1. Objetivo
Subir a la rama del sprint la reconstrucción visual de las 52 pantallas de `maqueta-knock` dentro de la app móvil, con datos simulados, para mostrar el producto completo y para que cada spec de pantallas la valide y la conecte a su API real, sin rehacer el diseño.

## 2. Alcance
**Dentro**
- Capa `app/lib/features/maqueta/` con estado simulado, componentes de la maqueta (`ui.dart`), animaciones (`anim_k.dart`, `carga_k.dart`), mapa de Google con cobertura y rutas `/m/...`.
- Las pantallas del cliente y del técnico según `docs/demo-maqueta/ESTADO.md`.
- Lo que ya es real se queda real: login por SMS (Firebase y canje de sesión), oficios y colonias, ubicación del teléfono, perfil y cierre de sesión.
- Una bandera de compilación que activa o desactiva la capa simulada.
- Dependencias nuevas: `flutter_svg` y `lottie` (evaluadas en `Memoria.md`).

**Fuera**
- Llamar a endpoints que aún no existen; contratos y OpenAPI.
- Cambiar el diseño de la maqueta o los textos de `maqueta-knock/`.
- El dominio, los repositorios, las pruebas y los ARB de cada pantalla: son de cada spec. Desde la enmienda 1 (§13), las pantallas de la maqueta consumen esos repositorios directamente.

## 3. Requisitos
- **R-01** Todo el código simulado vive en `features/maqueta/`. Fuera de esa carpeta solo se importa `fachada_maqueta.dart`, y solo desde `core/router/app_router.dart` y `app.dart` (excepción acotada autorizada el 2026-11-16: el router registra las rutas de la maqueta exclusivamente con `MODO_MAQUETA` activo). `app_shell.dart` y `tema.dart` no la conocen.
- **R-02** La capa simulada se activa con una bandera de compilación (`MODO_MAQUETA`). Sin ella, la app usa solo lo real. Con ella, todo dato de ejemplo se rotula como tal (spec 027). La bandera es `modoMaquetaProvider` (por defecto, `bool.fromEnvironment`), que las pruebas sustituyen para verificar los dos modos por separado. El rótulo reutiliza `RotuloDeEjemplo` (spec 027), fijo en toda pantalla.
- **R-03** Lo real no se simula: sesión, perfil, oficios, colonias y ubicación siguen usando sus repositorios.
- **R-04** Sin secretos en el repositorio (la clave del mapa no se versiona) ni datos personales reales en las semillas.
- **R-05** (enmendada, §13) Cada spec de pantallas que conecte una pantalla de la maqueta a su API real quita su dependencia del estado simulado y borra el estado que ya no use; se lleva una tabla pantalla → spec → estado (simulada / conectada).
- **R-06** El CI queda en verde: análisis, formato, pruebas, cobertura, `sdd_lint`, escáneres y licencias.
- **R-07** Las animaciones respetan «reducir movimiento» y no bloquean la lectura de pantalla.

## 4. Criterios de aceptación (casos)
| Caso | Criterio | Verificación |
|---|---|---|
| CA-01 | Con `MODO_MAQUETA` las 52 pantallas de `ESTADO.md` abren y se corresponden con su captura | recorrido en emulador con evidencia |
| CA-02 | Sin `MODO_MAQUETA` no aparece ningún experto, cotización ni visita de ejemplo | prueba de widget |
| CA-03 | Con la bandera, todo dato de ejemplo lleva su rótulo | prueba de widget |
| CA-04 | Ningún archivo fuera de `features/maqueta/` importa el estado simulado | prueba de arquitectura |
| CA-05 | Login por SMS, oficios, colonias y perfil usan sus repositorios reales | pruebas existentes en verde |
| CA-06 | Tema oscuro e inglés según las capturas 50 a 52 | recorrido en emulador |
| CA-07 | Con «reducir movimiento» se muestran fotogramas fijos | prueba de widget |
| CA-08 | Ningún secreto en el diff | gitleaks (comando) |
| CA-09 | `flutter analyze`, formato, pruebas y cobertura en verde | CI (comando) |

## 5. Contrato consumido
Sin cambios: solo los endpoints ya desplegados de las specs 026 y 027.

## 6. Modelo de datos local
Estado en memoria; nada se guarda en disco salvo lo que ya guardan las specs 015, 016 y 022.

## 7. Arquitectura
`features/maqueta/` aislada, con `datos.dart`, `estado.dart`, `tecnico_estado.dart`, `ui.dart`, pantallas y rutas `/m/...` en `app_router.dart`. (Enmendada, §13) Las pantallas de la maqueta son la interfaz de la app: la conexión progresiva (R-05) hace que cada pantalla lea el repositorio real del módulo de su spec en lugar del estado simulado; no se reemplazan por otras pantallas.

## 8. Amenazas y controles
- Datos de ejemplo confundidos con reales → bandera y rótulo (R-02).
- Clave del mapa y tokens en el repositorio → no se versionan (R-04).
- Dependencias nuevas con licencia o vulnerabilidad → evaluación en `Memoria.md` y exención solo en `security/exceptions.yaml` si hace falta.
- Capa simulada permanente → tabla y regla de retirada (R-05).

## 9. Plan de pruebas
Reescribir o retirar con justificación las 90 pruebas del diseño anterior; pruebas de la bandera, del rótulo, de la arquitectura (R-01) y de «reducir movimiento». Recorrido en emulador con evidencia.

## 10. Definición de terminado
Los casos CA-01 a CA-09 cubiertos, CI en verde, `Memoria.md` al día, `ESTADO.md` convertido en la tabla de R-05, y PR con la plantilla completa.

## 11. Decisiones tomadas sin consulta
Ninguna. Las de §12 las toma la persona que aprueba.

## 12. Riesgos y dudas abiertas
1. **Textos:** `tr()` con diccionario (como está) o claves ARB (como piden los specs). Mientras la capa sea simulada se propone `tr()`, y cada spec migra a ARB al conectar su pantalla.
2. **Cobertura (resuelto 2026-11-16):** no hace falta excluir `features/maqueta` ni tocar el CI. Con las pruebas por ruta del modo maqueta, la suite completa llega a 67,3 % (mínimo 50 %), medido también en un checkout limpio.
3. **Pruebas en rojo (resuelto 2026-11-16):** eran 95 regresiones nuevas (la línea base de `sprint-04` tiene 742 pruebas en verde). Con la bandera apagada por defecto vuelven a pasar sin tocarlas; 2 solo fallan en equipos con `google-services.json` local (ignorado por git).
4. **Número de spec y de subtareas:** confirmar contra la rama de KNOCK-266.
5. **Revisión de pares:** el reglamento pide comentario de otra persona; si no hay disponible, registrarlo en el PR como excepción.
6. **Rótulo fijo (resuelto 2026-11-16):** el chip flotante cubría texto o acciones de la esquina en 11 de 45 rutas. Ahora es una franja fija superior con su propio alto (barra de estado incluida) y la app se dibuja debajo, con el margen superior ya consumido; en las 45 rutas y 5 escenarios de pantalla no cubre ningún texto ni elemento tocable. Cuesta el alto de la franja (unos 28 dp más la barra de estado).
7. **Licencias (resuelto 2026-11-16, pendiente de confirmar en el CI):** el SCA del PR #66 marcó `cli_util` 0.6.0, `flutter_svg` 2.4.0, `lottie` 3.8.2, `vector_graphics` 1.3.1, `vector_graphics_codec` 1.2.0 y `vector_graphics_compiler` 1.3.6 (MIT o BSD-3 según el LICENSE publicado, pub.dev y el repositorio de origen; sin vulnerabilidades altas). El Tech Lead autorizó ampliar `allow-dependencies-licenses` y EXC-002 como en KNOCK-262, solo con esos 6 (57 a 63) y sin cambiar `creada` ni `vence`. `path_parsing` 1.1.0, también nueva, no se marcó y no se agregó. Matiz: el LICENSE de `lottie` conserva «[year] [fullname]» sin rellenar; se acepta con constancia en EXC-002 y `Memoria.md`, y la alternativa sería reemplazar `lottie`.
8. **Desbordamientos a 320 y 360 dp (abierta, 2026-11-16):** con la tipografía de la app cargada, siete filas de la maqueta desbordan a 320 y 360 dp de ancho (inicio, explorar, código de la visita, cotización y verificación del técnico, y campos con etiqueta). Con 412 dp o más no hay desbordamientos. No los causa el rótulo ni se corrigieron: decide si se arreglan en este PR o en otro.

## 13. Enmienda 1 (2026-11-17): la maqueta es la interfaz de la app

**Por qué.** El Tech Lead decidió que la maqueta es la base y la interfaz de la app, y que se va llenando poco a poco con los endpoints reales. No se mantienen dos aplicaciones (una «real» y otra de maqueta). La versión original de esta spec preveía lo contrario: capa simulada aparte, apagada por defecto, y retirada reemplazándola por las pantallas de cada spec.

**Cambios**
- **E-01** (sustituye la intención de R-05) La maqueta es la interfaz de la app. Cada pantalla se conecta a su endpoint real reutilizando los repositorios, mapeadores y el cliente generado (`app/packages/knock_api`) de la spec que la gobierna, sin reescribir su diseño. Al conectarla, la pantalla deja de leer el estado simulado y se borra el estado que quede sin uso.
- **E-02** Lo que no tiene backend se queda simulado y rotulado como ejemplo (spec 027, R-02) hasta que exista. La tabla `docs/demo-maqueta/ESTADO.md` pasa a ser la tabla pantalla → spec → estado (simulada / conectada).
- **E-03** No se crean pantallas paralelas «reales» para lo que la maqueta ya cubre. Las pantallas de `features/actividad`, `features/cuenta` y similares que dupliquen una de la maqueta se retiran cuando esta quede conectada; sus controladores, repositorios y mapeadores se conservan.
- **E-04** R-01 y CA-04 siguen igual: fuera de `features/maqueta/` solo se importa la fachada. La maqueta sí puede importar el dominio y los repositorios de las demás funciones.
- **E-05** El envío de una solicitud (`POST /solicitudes` y las cotizaciones del técnico) sigue simulado y rotulado mientras el backend no tenga el módulo de archivos (spec 013) ni el moderador: hoy responde 503. Un interruptor lo activa cuando exista.
- **E-06** Orden de conexión: oficios y colonias, zona por código postal y lista de espera, mis sesiones; luego lectura de solicitudes; luego comparar cotizaciones, elegir, visita con código, «Ya llegué» y aviso de confianza.

**Casos nuevos**
| Caso | Criterio | Verificación |
|---|---|---|
| CA-10 | Una pantalla conectada no importa el estado simulado y llama a su repositorio | prueba de widget con repositorio sustituido y prueba de arquitectura |
| CA-11 | `ESTADO.md` refleja el estado real de cada pantalla (simulada / conectada) | revisión en cada PR de conexión |
| CA-12 | Una pantalla conectada muestra los estados de error del backend (401, 404, 409, 422, 503) sin datos de ejemplo | prueba de widget |

**Dudas abiertas**
1. **La bandera `MODO_MAQUETA`:** hoy, apagada, deja la app sin la maqueta. Mientras la maqueta sea la interfaz, hay que decidir si pasa a estar encendida por defecto y cuándo se retira. No se cambia el valor por defecto en esta enmienda.
2. **Qué compilación va a Play:** depende de lo anterior y del parche del flujo de publicación (toca `.github/` y necesita autorización expresa).
3. **Pantallas duplicadas (E-03):** hay que listar cuáles de `features/*` se retiran y en qué PR, para no dejar código muerto.

**Aprobación de la enmienda**
- [ ] Revisor 1 — nombre: fecha:
- [ ] Sin conflicto con la constitución

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-16
- [x] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
