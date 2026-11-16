# Plan 028 — Abrir el aviso de privacidad desde la entrada con celular

> Parte de `spec.md` (Borrador; la aprueba el Tech Lead).

## Enfoque
Un cambio pequeño y vertical: configuración, abridor de enlaces, pantalla y pruebas.

1. **Configuración.** Constante de la dirección del aviso con valor por defecto, sustituible con `KNOCK_PRIVACY_URL`, que acepta solo `https`.
2. **Abridor de enlaces.** `AbridorDeEnlaces` en `core/` que envuelve `url_launcher` y se sustituye en las pruebas; proveedor de Riverpod.
3. **Pantalla.** En `celular_screen.dart` el texto del aviso reconoce el toque, llama al abridor y, si falla, muestra el mensaje sin cerrar ni borrar. Tocar el aviso no cambia la casilla.
4. **Textos y accesibilidad.** Mensaje de error en los ARB es/en, área táctil de 48 dp, semántica de enlace y texto al 200 %.
5. **Android.** Declarar la consulta de `https` en el AndroidManifest; sin permisos nuevos.
6. **Cierre.** Mapa de arquitectura, `Memoria.md` con la dependencia y su motivo, y humo en teléfono.

## Archivos que se tocan
- Crear: `core/config/aviso_de_privacidad.dart`, `core/enlaces/abridor_de_enlaces.dart` y sus pruebas.
- Editar: `features/entrada/presentation/celular_screen.dart`, `l10n/app_es.arb`, `l10n/app_en.arb`, `app/pubspec.yaml`, `app/android/app/src/main/AndroidManifest.xml`, `Memoria.md`.
- No tocar: `contracts/`, `app/packages/knock_api/`, `.github/`, `constitution.md`.

## Dependencias y orden
La dependencia nueva (`url_launcher`) se evalúa primero (licencia, vulnerabilidades, tamaño). Las pruebas de widget usan un abridor falso, así que no dependen de la red.
