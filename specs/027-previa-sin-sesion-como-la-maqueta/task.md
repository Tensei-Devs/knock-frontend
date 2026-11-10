# Tareas 027 — Previa sin sesión (pantalla de inicio antes de entrar) según la maqueta

> **Estado:** pendientes. En esta etapa **no se ejecutan**: se activan cuando la spec esté Aprobada y una persona lo indique. **Depende de la spec 026** (se implementa después o apilada).

| Tarea | Qué se hace | Depende de | Cubre | Estado |
|---|---|---|---|---|
| T-01 | Agregar `Rutas.previa` y `Rutas.previaOficios`, y la lista de destinos de regreso permitidos | — | R-01, R-08 · CA-01 | pendiente |
| T-02 | `redireccionPorSesion`: sin sesión lo protegido va a la previa; lo público pasa; con sesión la previa y `/entrar` van a Inicio. Registrar la ruta fuera del shell y `initialLocation` | T-01 | R-01, R-02 · CA-01 a CA-05 | pendiente |
| P-1 | Pruebas de la tabla de rutas por sesión (incluye subruta `/entrar/codigo` sin celular y sin bucles) | T-02 | CA-01 a CA-05 | pendiente |
| T-03 | Crear `core/config/modo_demostracion.dart`: `demoActivo(bandera, esRelease)` y `demoDatosActivo` con `bool.fromEnvironment('KNOCK_DEMO_DATOS')` y `kReleaseMode` | — | R-11 · CA-25, CA-27 | pendiente |
| T-04 | Crear `features/previa/demo/datos_de_ejemplo.dart` (expertos ficticios, pines, colonia de ejemplo; sin celular, dirección ni coordenadas reales) | T-03 | R-12, R-17 · CA-26, CA-28 | pendiente |
| P-2 | Pruebas del grupo demostración: `demoActivo` en todas las combinaciones, datos sin campos personales | T-03, T-04 | CA-25, CA-27, CA-28 | pendiente |
| T-05 | Crear `domain/destino_de_regreso.dart`: valida el destino contra la lista permitida; todo lo demás da Inicio | T-01 | R-08, R-09 · CA-22 | pendiente |
| T-06 | Crear `domain/requerir_cuenta.dart`: lleva a `/entrar` con el destino al que volver | T-05 | R-08 · CA-20 | pendiente |
| P-3 | Pruebas del grupo regreso: destinos válidos, `https://otro.sitio`, `//otro`, vacío y mal formado | T-05, T-06 | CA-20 a CA-22 | pendiente |
| T-07 | Textos ARB es/en mínimos con descripción (barra, buscador, hoja, chips, panel, «Datos de ejemplo», tarjeta de Explorar) y regenerar | — | R-15 · CA-32 | pendiente |
| T-08 | Barra de marca con logo, «Entrar» y «Registrarme» (48 dp, etiquetas) | T-02, T-07 | R-03, R-16 · CA-06, CA-07 | pendiente |
| T-09 | Buscador visible y hoja de invitación con «Entrar», «Registrarme» y «Ahora no» | T-06, T-07 | R-04 · CA-08 a CA-10 | pendiente |
| T-10 | Chips (Todos, oficios reales, No sé cuál) y catálogo con estados cargando, vacío, error y sin conexión; tarjeta «Explorar servicios y trabajos» hacia `/previa/oficios` | T-07 | R-05 a R-07 · CA-11 a CA-19 | pendiente |
| T-11 | Panel «expertos cerca de ti» y mapa de ejemplo: vacío honesto en tienda; con datos de ejemplo y rótulo fijo en demostración; sin permisos | T-04, T-07 | R-10, R-12, R-13, R-17 · CA-25 a CA-30 | pendiente |
| T-12 | Ensamblar `PreviaScreen`, registrar la ruta y revisar texto al 200 % | T-08 a T-11 | R-01, R-16 · CA-31 | pendiente |
| P-4 | Pruebas de widget por estado: barra, buscador, hoja, chips, catálogo (cargando, vacío, error, sin conexión, con datos), panel en tienda y en demostración, es y en | T-12 | CA-06 a CA-13, CA-15 a CA-19, CA-25, CA-26, CA-32 | pendiente |
| P-5 | Pruebas de accesibilidad y seguridad negativa: 48 dp, contraste, etiquetas, «Datos de ejemplo» en lectura de pantalla, texto al 200 %, sin `Authorization` en `GET /oficios`, sin permisos, sin datos personales ni tokens | T-12 | CA-14, CA-29 a CA-31, CA-33 | pendiente |
| T-13 | Tras entrar o registrarse, ir al destino de regreso válido (o a Inicio) respetando completar perfil; cerrar sesión termina en la previa | T-12, T-06, spec 026 | R-09 · CA-05, CA-21, CA-23, CA-24 | pendiente |
| P-6 | Integración del flujo previa → Entrar → celular → código → app; acción protegida → login → regreso; cuenta nueva → perfil → destino; cerrar sesión → previa; regresión de HU-001 | T-13 | CA-05, CA-20, CA-21, CA-23, CA-24, CA-34 | pendiente |
| T-14 | Crear `scripts/verificar_release_sin_demo.py`: compila (o recibe) el binario `release` hecho con `KNOCK_DEMO_DATOS=true` y falla si encuentra el rótulo o los nombres de ejemplo | T-03, T-04 | R-11 · CA-27 | pendiente |
| P-7 | Seguridad negativa de la bandera en `release`: compilar con la bandera y pasar el script; prueba de que el modo `profile` sí la respeta | T-14 | CA-25, CA-27 | pendiente |
| T-15 | Humo manual en teléfono: compilación de tienda (vacío honesto) y de demostración (maqueta); capturas al PR | P-4 a P-7 | CA-25, CA-26, CA-30 | pendiente |
| T-16 | Puertas de CI y Memoria: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint` y `sdd_lint --trace 027`, regenerar el mapa con `scripts/codemap.py`, actualizar `Memoria.md` y pedir a quien tenga permiso el paso de CI en `.github/` que compile `release` con la bandera y corra el script | T-15 | Definición de terminado | pendiente |

## Paralelismo
- Se pueden empezar a la vez: T-01, T-03, T-05 y T-07.
- Después de T-07 corren en paralelo T-08, T-09 y T-10; T-11 también espera a T-04.
- Cada tarea de pruebas (P-n) se hace junto con su grupo, pero P-5, P-6 y P-7 esperan a T-12, T-13 y T-14.
- T-13 espera a que la spec 026 esté integrada (o a trabajar apilado sobre su rama). T-15 y T-16 van al final y en serie.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (la prueba en teléfono, con evidencia manual).
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
- No se tocaron `contracts/`, `app/packages/knock_api/` ni `.github/`.
