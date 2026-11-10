# Tareas 027 — Previa sin sesión (pantalla de inicio antes de entrar) según la maqueta

> **Estado:** implementadas (PR apilado sobre la 026) salvo T-15, el humo manual en teléfono, que hace el Tech Lead. Las tareas T-03, T-04, T-11, P-2, P-4, P-5 y T-14 se replantearon con la decisión D-12 (mapa completo y ejemplos siempre visibles; sin bandera ni script de `release`).

| Tarea | Qué se hace | Depende de | Cubre | Estado |
|---|---|---|---|---|
| T-01 | Agregar `Rutas.previa` y `Rutas.previaOficios`, y la lista de destinos de regreso permitidos | — | R-01, R-08 · CA-01 | hecha |
| T-02 | `redireccionPorSesion`: sin sesión lo protegido va a la previa; lo público pasa; con sesión la previa y `/entrar` van a Inicio. Registrar la ruta fuera del shell y `initialLocation` | T-01 | R-01, R-02 · CA-01 a CA-05 | hecha |
| P-1 | Pruebas de la tabla de rutas por sesión (incluye subruta `/entrar/codigo` sin celular y sin bucles) | T-02 | CA-01 a CA-05 | hecha |
| T-03 | Crear `core/tema/colores_mapa.dart` (paleta clara y oscura del mundo dibujado y colores de pines) y `domain/vista_mapa.dart` (vista pura: zoom, arrastre, límites, volver a mi ubicación) | — | R-18 · CA-27 | hecha |
| T-04 | Crear `features/previa/demo/datos_de_ejemplo.dart` (seis expertos ficticios con oficio, calificación, distancia y punto del dibujo; colonia de ejemplo; sin celular, dirección ni coordenadas reales) | T-03 | R-11, R-12, R-17 · CA-25, CA-28, CA-33 | hecha |
| P-2 | Pruebas de `VistaMapa` (centro inicial, zoom con límites, zoom que conserva el punto, arrastre acotado, volver a mi ubicación) y de que los datos de ejemplo no traen campos personales | T-03, T-04 | CA-27, CA-33 | hecha |
| T-05 | Crear `domain/destino_de_regreso.dart`: valida el destino contra la lista permitida; todo lo demás da Inicio | T-01 | R-08, R-09 · CA-22 | hecha |
| T-06 | Crear `domain/requerir_cuenta.dart`: lleva a `/entrar` con el destino al que volver | T-05 | R-08 · CA-20 | hecha |
| P-3 | Pruebas del grupo regreso: destinos válidos, `https://otro.sitio`, `//otro`, vacío y mal formado | T-05, T-06 | CA-20 a CA-22 | hecha |
| T-07 | Textos ARB es/en mínimos con descripción (barra, buscador, hoja, chips, panel, «Datos de ejemplo», «Tú estás aquí», botones del mapa, «Ver lista» y «Ver mapa», distancia, tarjeta de Explorar) y regenerar | — | R-15 · CA-32 | hecha |
| T-08 | Barra de marca con logo, «Entrar» y «Registrarme» (48 dp, etiquetas) | T-02, T-07 | R-03, R-16 · CA-06, CA-07 | hecha |
| T-09 | Buscador visible y hoja de invitación con «Entrar», «Registrarme» y «Ahora no» | T-06, T-07 | R-04 · CA-08 a CA-10 | hecha |
| T-10 | Chips en una fila flotante (Todos, oficios reales, No sé cuál) que filtran catálogo, pines y tarjetas; catálogo con estados cargando, vacío, error y sin conexión; tarjeta «Explorar servicios y trabajos» hacia `/previa/oficios` | T-07 | R-05 a R-07 · CA-11 a CA-19, CA-35 | hecha |
| T-11 | Mapa a pantalla completa (`lienzo_mapa`, `mapa_previa`, `pin_experto`, `controlador_mapa`) con pan, pellizco, botones y punto «Tú estás aquí»; panel inferior plegable con «Ver lista» y «Ver mapa»; rótulo «Datos de ejemplo»; sin permisos ni SDK de mapas | T-03, T-04, T-07 | R-10 a R-13, R-17 a R-19 · CA-25 a CA-30, CA-36 | hecha |
| T-12 | Ensamblar `PreviaScreen` (barra, mapa, capa superior, botones y panel), registrar la ruta y revisar texto al 200 % | T-08 a T-11 | R-01, R-16, R-19 · CA-31 | hecha |
| P-4 | Pruebas de widget por estado: barra, buscador, hoja, chips, catálogo (cargando, vacío, error, sin conexión, con datos), mapa y pines por oficio, panel plegable, gestos y botones del mapa, chips que filtran, es y en | T-12 | CA-06 a CA-13, CA-15 a CA-19, CA-25 a CA-27, CA-32, CA-35, CA-36 | hecha |
| P-5 | Pruebas de accesibilidad y seguridad negativa: 48 dp (incluidos pines y botones del mapa), contraste, etiquetas, «Datos de ejemplo» en lectura de pantalla, texto al 200 %, sin `Authorization` en `GET /oficios`, sin permisos ni SDK de mapas, sin bandera que apague los ejemplos, sin datos personales ni tokens | T-12 | CA-14, CA-25, CA-28 a CA-31, CA-33 | hecha |
| T-13 | Tras entrar o registrarse, ir al destino de regreso válido (o a Inicio) respetando completar perfil; cerrar sesión termina en la previa | T-12, T-06, spec 026 | R-09 · CA-05, CA-21, CA-23, CA-24 | hecha |
| P-6 | Integración del flujo previa → Entrar → celular → código → app; acción protegida → login → regreso; cuenta nueva → perfil → destino; cerrar sesión → previa; regresión de HU-001 | T-13 | CA-05, CA-20, CA-21, CA-23, CA-24, CA-34 | hecha |
| T-14 | (Retirada por D-12) Ya no hay script de verificación de `release`: los ejemplos siempre se muestran con su rótulo | — | — | retirada |
| P-7 | (Retirada por D-12) Una prueba de código revisa que ningún archivo de `lib/` lea la bandera `KNOCK_DEMO_DATOS` ni la previa use `kReleaseMode` (queda en P-5) | — | — | retirada |
| T-15 | Humo manual en teléfono, claro y oscuro: mapa, pan y zoom, panel plegable, chips, pines y «Datos de ejemplo»; capturas al PR | P-4 a P-6 | CA-25, CA-26, CA-30 | pendiente (Tech Lead) |
| T-16 | Puertas de CI y Memoria: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint` y `sdd_lint --trace 027`, regenerar el mapa con `scripts/codemap.py` y actualizar `Memoria.md` | T-15 | Definición de terminado | hecha salvo T-15 |

## Paralelismo
- Se pueden empezar a la vez: T-01, T-03, T-05 y T-07.
- Después de T-07 corren en paralelo T-08, T-09 y T-10; T-11 también espera a T-03 y T-04.
- Cada tarea de pruebas (P-n) se hace junto con su grupo, pero P-5 y P-6 esperan a T-12 y T-13.
- T-13 espera a que la spec 026 esté integrada (o a trabajar apilado sobre su rama). T-15 y T-16 van al final y en serie.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (la prueba en teléfono, con evidencia manual).
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
- No se tocaron `contracts/`, `app/packages/knock_api/` ni `.github/`.
