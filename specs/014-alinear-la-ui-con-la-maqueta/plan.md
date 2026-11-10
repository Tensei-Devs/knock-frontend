# Plan 014 — Alinear la UI con la maqueta

> Parte de `spec.md` (estado Aprobada, KNOCK-242). Rama: `feature/KNOCK-242-align-ui-with-mockup`.

## Enfoque
Cuatro etapas, cada una verificable sola y con la suite en verde (R-07):
1. **Tipografía:** agregar `Nunito-ExtraBold.ttf` (800) y `Nunito-Black.ttf` (900), declararlas en `pubspec.yaml` y fijar la escala de textos de la maqueta en `core/tema/tipografia.dart`.
2. **Tokens:** `core/tema/tokens.dart` (radios, alturas, espaciado, sombras) y `ColoresKnock` (`ThemeExtension` con los colores de la maqueta que no caben en un `ColorScheme`, cada fondo con su texto ya validado).
3. **Componentes base:** botones, campos, barra superior, barra inferior, hoja inferior y tarjeta en `ThemeData`; widgets solo donde se usan en dos o más pantallas (`TarjetaKnock`, `GrupoDeFilas` y `FilaKnock`, `EstadoKnock`).
4. **Pantallas:** entrada (celular, código, completar perfil), Inicio, Explorar, Actividad, Oficios y Mi cuenta, más el estilo de la barra inferior.

## Archivos que se crean o cambian
- `app/pubspec.yaml`, `app/assets/fonts/nunito/` (2 TTF nuevos)
- `app/lib/core/tema/` (`tokens.dart`, `tipografia.dart`, `colores.dart`, `tema.dart`)
- `app/lib/core/widgets/` (`tarjeta_knock.dart`, `fila_knock.dart`, `estado_knock.dart`)
- `app/lib/core/router/app_shell.dart` (solo el estilo de la barra inferior)
- `app/lib/features/{entrada,cuenta,inicio,explorar,actividad,oficios}/presentation/`
- `app/lib/l10n/app_es.arb` y `app_en.arb` (estado vacío de Actividad) y `generado/`
- `app/test/` (pruebas nuevas `CA_014_NN` y dos buscadores de ícono en `oficios_screen_test.dart`)

## Dependencias
Ninguna nueva. Los dos TTF son archivos de la familia Nunito ya empaquetada (SIL OFL 1.1).

## Decisiones de la spec que este plan sigue
- Tema antes que widgets; alturas mínimas, no fijas; íconos Material; contraste manda sobre la maqueta; comparación con capturas y no con golden.
- Logo: `Knock.png` de la maqueta es RGB sin canal alfa (fondo opaco), así que se deja el ícono provisional (decisión 3).

## Verificación
- Cada criterio con su prueba `CA_014_NN` o su comando (tabla de la spec §4).
- `cd app && flutter pub get && flutter analyze --fatal-infos --fatal-warnings && flutter test`, `python scripts/sdd_lint.py --trace 014` y `python scripts/codemap.py --check`.
- Se actualiza `Memoria.md`.
