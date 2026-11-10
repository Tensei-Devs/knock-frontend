# Spec 014 — Alinear la UI con la maqueta

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md` · **Jira:** KNOCK-242
> **Capas:** [Mobile] · **Otra parte en:** — · **Contrato consumido:** sin cambios
> **Skills:** flutter-clean-architecture, reuse-before-create, story-workflow, testing-strategy-frontend

## 1. Objetivo
Que la app móvil se vea y se sienta como la maqueta aprobada (`maqueta-knock`) en las pantallas ya construidas: entrada (login), inicio, explorar, actividad, oficios y mi cuenta. Es un cambio **solo visual**: tipografía, medidas, sombras, espaciado y componentes. No se agrega ninguna función, ruta ni llamada a la API.

**Fuente de verdad visual:** `maqueta-knock/css/knock.css` (valores), `maqueta-knock/js/knock.js` (qué lleva cada pantalla `S.*`) y las capturas de `Documentacion/04_Prototipo/Capturas_Maqueta` (P01, P06, P07, P11, P20).

## 2. Alcance
**Dentro**
- **Tipografía:** Nunito con los pesos que usa la maqueta (800 y 900 no están hoy) y la escala de textos de la maqueta (`.h1`, `.h2`, `.h3`, `.t`, `.s`).
- **Tokens** tomados de `knock.css`: radios, alturas, sombras y espaciado, en `core/tema/`.
- **Componentes base** en `core/widgets/` (y en los temas de botones, campos, tarjetas y barra inferior de `core/tema/tema.dart`) con las variantes de la maqueta.
- **Marca:** el logo `Knock.png` de la maqueta sustituye al ícono provisional (§9, decisión 3).
- **Migración, pantalla por pantalla:**

| Pantalla de la app | Referencia en la maqueta | Qué se alinea |
|---|---|---|
| Entrada: celular, código y completar perfil | `S.*` de `acceso.js` · P07 pasos 1 a 3 | Marca, título, campos, botón principal, enlaces, estados de error |
| Inicio | `S.inicioMapa` · P01 | Barra superior de marca, saludo, tarjeta «Tu zona», acceso a oficios; sin mapa (§9, decisión 4) |
| Explorar | `S.explorar` · P06 | Barra superior y la fila de acceso a Oficios |
| Actividad | `S.trabajos` (estado vacío) · P11 | Estado vacío con el estilo de la maqueta |
| Oficios | no existe en la maqueta (TT-PRU-02) | Se viste con los componentes base: lista, estados y aviso sin conexión |
| Mi cuenta | `S.cuenta` · P20 | Tarjeta de perfil, filas agrupadas y Cerrar sesión con su confirmación en hoja inferior (§9, decisión 8) |
| Barra inferior (`AppShell`) | `.tabs` · P01, P20 | Estilo de pestaña, solo visual |

**Fuera**
- Lo que la maqueta muestra y la app **aún no tiene**: mapa y pines, buscador, filtros por oficio, panel deslizable de expertos, tarjeta de cotizaciones listas, secciones de Explorar (servicios populares, trabajos reales, mejor calificados), globo de mensajes, insignias de avisos, Mi casa y mi auto, técnicos de confianza, Mis datos, Centro de ayuda y «Ofrece tus servicios». No se dibuja un control que no haga nada.
- Teléfono en la tarjeta de perfil (la app no lo guarda ni lo muestra).
- Trabajo (pestaña de técnicos), Configuración y las pantallas P02 a P05, P08 a P19 y P21 en adelante.
- Cambios de lógica, controladores, repositorios, rutas, `contracts/` y `app/packages/knock_api`.
- Dependencias nuevas.

## 3. Requisitos
- **R-01 Tipografía.** Nunito empaquetada, sin descarga en ejecución, con los pesos 400, 500, 600, 700, 800 y 900. Los textos usan la escala de la maqueta: h1 26/900, h2 20/900, h3 17/900, texto 16, secundario 14.
- **R-02 Tokens.** Los valores salen de `knock.css` y viven en un solo lugar de `core/tema/`; ninguna pantalla escribe medidas, radios ni sombras sueltas.

  | Token | Valor de la maqueta | Origen |
  |---|---|---|
  | Radios | grande 22 · medio 16 · pequeño 12 · botón 28 (chico 23) · chip 22 · hoja 26 · icono de fila 12 | `--r-lg`, `--r-md`, `--r-sm`, `.btn`, `.chip`, `.sheet`, `.li .ic` |
  | Alturas mínimas | botón 56 (chico 46, ghost 48) · campo 56 · fila 62 · chip 44 · barra superior 60 · pestaña 54 | `.btn`, `.inp`, `.li`, `.chip`, `.top`, `.tab` |
  | Sombra de tarjeta | `0 1 3 rgba(30,58,95,.06)` + `0 4 14 rgba(30,58,95,.05)` | `.card` |
  | Espaciado | cuerpo 20 · bloques 16 · bloques chicos 8 · fila 12 · icono de fila a texto 14 · tarjeta 16 | `.pad`, `.stack`, `.stack-s`, `.row`, `.li`, `.card` |

- **R-03 Componentes base.** Se reutiliza lo que ya existe (`PantallaTitulada`, `AvatarIniciales`, temas de `ThemeData`) y solo se crea lo que se use en dos o más pantallas, siguiendo `reuse-before-create`: barra de marca, fila y grupo de filas, estado vacío o de error, aviso, píldora. Botones, campos, tarjetas y barra inferior se resuelven en el **tema**, no con widgets nuevos.
- **R-04 Contraste.** Se conservan las reglas de `core/tema/colores.dart` y `contraste.dart`: el naranja nunca es texto ni lleva texto blanco; en claro el botón relleno conserva su borde de tinta (contorno ≥ 3:1); en oscuro, sobre `navybg` y `navy-soft` solo va `ink` o `ink2` (la maqueta pone `#fff` en `.chip.on` y `.btn.dark` en oscuro: **se usa `ink`**). Todo par texto/fondo nuevo cumple 4.5:1 (3:1 en bordes y componentes) en claro y oscuro.
- **R-05 Accesibilidad.** Áreas táctiles ≥ 48 dp aunque la maqueta dibuje 44 (chips, botones de icono, volver); `Semantics` en controles sin texto; texto al 200 % sin desbordes en 320 × 640, así que las alturas son **mínimas**, nunca fijas.
- **R-06 Sin cambio de comportamiento.** Mismos controladores, estados (cargando, vacío, error con reintentar, datos), rutas, redirecciones y llamadas. Los textos nuevos o cambiados van en los ARB `es` y `en`.
- **R-07 Orden.** Primero tipografía, luego tokens, luego componentes y por último las pantallas, cada etapa en su propio commit y con la suite en verde.

## 4. Criterios de aceptación
- **CA-01:** Dado el tema claro o el oscuro, cuando se leen sus estilos de texto, entonces usan Nunito y los títulos pesan 900, y los archivos de fuente declarados en `pubspec.yaml` existen.
- **CA-02:** Dados los tokens, cuando se comparan con la tabla de R-02, entonces coinciden y las pantallas migradas no contienen radios, alturas ni sombras literales.
- **CA-03:** Dado cada par de texto y fondo de los componentes base, cuando se calcula con `relacionDeContraste`, entonces cumple 4.5:1 (3:1 en bordes) en claro y en oscuro.
- **CA-04:** Dado cada componente base, cuando se pinta con textos al 200 % en 320 × 640, entonces no desborda y cada control mide al menos 48 × 48 dp.
- **CA-05:** Dada la pantalla de entrada (celular, código, completar perfil), cuando se comparan con P07, entonces tiene la marca, el título, los campos y el botón principal de la maqueta, y conserva sus mensajes de error y su cuenta regresiva.
- **CA-06:** Dadas Inicio, Explorar, Actividad, Oficios y Mi cuenta, cuando se comparan con P01, P06, P11 y P20, entonces usan los componentes base y conservan sus cuatro estados.
- **CA-07:** Dado el cambio completo, cuando se revisa el diff, entonces no toca `domain/`, `data/`, `*_controller.dart`, `core/router/`, `core/sesion/`, `core/red/`, `contracts/` ni `app/packages/knock_api`, y no cambia `dependencies` de `pubspec.yaml`.
- **CA-08:** Dada la suite existente, cuando se ejecuta, entonces pasa sin cambiar ninguna aserción de comportamiento (solo se admite cambiar un buscador de widgets si cambió el tipo del widget).
- **CA-09:** Dada cada pantalla en claro y en oscuro, cuando se revisa contra su captura, entonces las diferencias que queden están anotadas en el PR.

**Verificación por caso** (los nombres de las pruebas llevan `CA_014_NN`, como en el resto de las specs numeradas):

| Caso | Verificación |
|---|---|
| CA-01 | `test/core/tema/tema_maqueta_test.dart` · `CA_014_01` |
| CA-02 | `test/core/tema/tema_maqueta_test.dart` · `CA_014_02` |
| CA-03 | `test/core/tema/tema_maqueta_test.dart` · `CA_014_03` |
| CA-04 | `test/core/widgets/componentes_knock_test.dart` · `CA_014_04` |
| CA-05 | `test/features/entrada/ui_maqueta_entrada_test.dart` · `CA_014_05` (widget, claro y oscuro, 200 %) |
| CA-06 | `test/features/ui_maqueta_pantallas_test.dart` · `CA_014_06` (widget, claro y oscuro, 200 %) |
| CA-07 | `(git diff --name-only origin/sprint-03; git ls-files -o --exclude-standard) \| grep -E '(^\|/)(domain\|data)/\|_controller\.dart$\|app/lib/core/(router\|sesion\|red)/\|^contracts/\|app/packages/knock_api/'` debe listar solo `app/lib/core/router/app_shell.dart` (el estilo de la barra inferior, decisión 7; su lógica de navegación no cambia), y `git diff -U0 origin/sprint-03 -- app/pubspec.yaml` solo agrega las dos fuentes (comando) |
| CA-08 | `cd app && flutter test`, más `git diff -U0 origin/sprint-03 -- app/test \| grep -E '^-' \| grep -vE '^---'`, que solo debe mostrar los dos buscadores de ícono de `oficios_screen_test.dart` (comando) |
| CA-09 | Pendiente de decidir (ver el informe de implementación) |

Salida de los comandos de CA-07 y CA-08: va en el PR.

## 5. Contrato
Sin cambios. No se consumen endpoints nuevos ni se toca el cliente generado.

## 6. Amenazas y controles
Cambio de estilo: se confirma que no expone datos.

| Amenaza | Control | Caso |
|---|---|---|
| Se copia a la app un dato de la maqueta que la app no tiene (teléfono en la tarjeta de perfil) | Solo se muestran los campos de `Perfil`; el teléfono queda fuera | CA-06 |
| Datos reales en capturas del PR o en pruebas de imagen | Capturas con datos de prueba; sin nombres, teléfonos ni colonias reales | CA-09 |
| Fuente o imagen con licencia no permitida | Nunito es SIL OFL 1.1 (ya está `OFL.txt`); el logo `Knock.png` es propio del proyecto y fue aprobado en la revisión (§9, decisión 3) | CA-01 |
| Dependencia nueva sin evaluar | Ninguna: solo archivos de fuente y, quizá, un PNG | CA-07 |
| Un control dibujado sin acción engaña a la persona | No se dibujan controles de funciones que no existen | CA-06 |

## 7. Plan de pruebas
| Tipo | ¿Aplica? | Motivo |
|---|---|---|
| Unitarias | Sí | Tokens contra la tabla de R-02 y estilos de texto del tema |
| Widget / componente | Sí | Cada componente base y cada pantalla migrada: estados, tamaños y textos |
| Contraste | Sí | `relacionDeContraste` sobre todos los pares usados, en claro y oscuro |
| Accesibilidad | Sí | `expectAccesible` (48 dp y etiqueta), texto al 200 % en 320 × 640 |
| No regresión de lógica | Sí | Suite existente sin cambiar aserciones y revisión del diff (CA-07, CA-08) |
| Regresión visual (golden) | No | Las imágenes de referencia cambian entre sistemas y fuentes; se sustituye por la comparación manual con las capturas |
| Comparación con la maqueta | Sí, manual | Capturas de la app en claro y oscuro junto a su par P-NN, en el PR |
| Integración / E2E | No | No cambia ningún flujo |
| Seguridad negativa | No | No hay entradas, permisos ni datos nuevos |

**Mutación:** no aplica; no hay lógica nueva.
**Comandos:** `cd app && flutter pub get && flutter analyze --fatal-infos --fatal-warnings && flutter test`; `python scripts/sdd_lint.py --trace 014`; `python scripts/codemap.py --check`.

## 8. Decisiones
- **Plan en cuatro etapas** (tipografía → tokens → componentes → pantallas), cada una verificable sola: si una falla, se revierte sin perder las anteriores.
- **Tema antes que widgets:** botones, campos, tarjetas y barra inferior se configuran en `ThemeData`; así toda pantalla futura los hereda y no se multiplican clases.
- **Alturas mínimas, no fijas:** respeta el texto al 200 % y los 48 dp.
- **Íconos Material:** la maqueta usa trazos propios en SVG; usarlos exige una dependencia (`flutter_svg`) o convertirlos, y eso queda fuera de este cambio.
- **Contraste manda sobre la maqueta:** donde `knock.css` rompe las reglas de `colores.dart` (blanco sobre `navybg` en oscuro, borde del botón en claro), gana la regla de la app y la diferencia se anota en el PR.
- **Se compara con capturas, no con golden:** ver §7.

## 9. Decisiones de la revisión y riesgos
Las dudas abiertas del borrador se resolvieron en la revisión del 2026-11-09 (responsable: José Julián Hernández). Quedan como decisiones de esta spec:

1. **Jira y rama.** KNOCK-242. Rama: `feature/KNOCK-242-align-ui-with-mockup`, creada desde `sprint-03`.
2. **Pesos 800 y 900 de Nunito.** Se agregan `Nunito-ExtraBold.ttf` y `Nunito-Black.ttf` tomados de la distribución oficial (carpeta `static` de Google Fonts, licencia SIL OFL 1.1, ya está `OFL.txt`) y se declaran en `pubspec.yaml`. Si no se pueden conseguir y verificar, los títulos se quedan en 700 y se informa en el PR. Si el CI de licencias lo marca, se agrega a la lista permitida con su identificador de excepción.
3. **Logo.** Se incorpora `Knock.png` de la maqueta (sin dependencia nueva). Si el archivo no tiene fondo transparente o resolución suficiente, se deja el ícono provisional y se informa en el PR.
4. **Inicio.** Se acepta que quede como saludo y tarjetas con el estilo de la maqueta, **sin mapa, buscador ni panel de expertos**. No se dibuja un mapa que no funcione.
5. **Actividad.** Solo el estado vacío, sin el botón «Pedir una cotización» (no tiene a dónde ir).
6. **Oficios.** No está en la maqueta (es la pantalla temporal de TT-PRU-02); se viste con los componentes base.
7. **Bordes del alcance.** La barra inferior entra (es solo estilo). Configuración no entra.
8. **Cerrar sesión.** Pasa a una hoja inferior, como en la maqueta, con los mismos textos y el mismo resultado. Solo cambia el buscador de widget en las pruebas existentes (CA-08), no ninguna aserción de comportamiento.
9. **Comparación visual.** Se hace con capturas de la app en un teléfono físico con depuración, en claro y en oscuro, junto a su par P-NN, y se adjuntan al PR con datos de prueba. Si algún estado no se puede capturar, el PR lo anota.
10. **Archivos generados y puntos.** `docs/architecture/*` se regenera con `scripts/codemap.py` justo antes de abrir el PR y de nuevo tras cualquier fusión que lo toque. El PR lleva la etiqueta `puntos-app-N`.

**Riesgos que se aceptan**
- El sprint 3 cierra el 9 de noviembre. Si no alcanza, se entregan las etapas 1 a 3 (tipografía, tokens y componentes) y las pantallas de entrada e Inicio; las demás pasan al sprint 4 junto con KNOCK-175 (contraste). Cada etapa va en su propio commit para poder entregarse o revertirse sola.
- Sin los TTF de peso 800 y 900 el resultado se acerca pero no iguala la maqueta (decisión 2).

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-09
- [x] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
