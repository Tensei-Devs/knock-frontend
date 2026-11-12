# Tareas 028 — Abrir el aviso de privacidad desde la entrada con celular

> **Estado:** pendientes (la spec está en borrador).

| Tarea | Qué se hace | Depende de | Cubre | Estado |
|---|---|---|---|---|
| T-01 | Evaluar `url_launcher` (licencia, vulnerabilidades, tamaño) y agregarlo a `pubspec.yaml`; registrarlo en `Memoria.md` | — | R-08 · CA-09 | pendiente |
| T-02 | Constante de la dirección del aviso con valor por defecto, `KNOCK_PRIVACY_URL` y validación `https` | — | R-02, R-04 · CA-03, CA-05 | pendiente |
| P-1 | Pruebas de la constante, de la validación y de que la dirección no lleva datos | T-02 | CA-03, CA-05 | pendiente |
| T-03 | `AbridorDeEnlaces` sobre `url_launcher` y su proveedor, con abridor falso para pruebas | T-01 | R-04, R-08 · CA-01 | pendiente |
| T-04 | Textos ARB es/en del mensaje de error | — | R-06 · CA-08 | pendiente |
| T-05 | Toque en el aviso: abre el enlace y no cambia la casilla; mensaje si falla sin cerrar ni borrar; 48 dp y semántica de enlace | T-02, T-03, T-04 | R-01, R-03, R-05 · CA-01, CA-02, CA-04, CA-06, CA-07 | pendiente |
| P-2 | Pruebas de widget: toque, casilla, fallo, accesibilidad, texto al 200 % e idiomas | T-05 | CA-01, CA-02, CA-04, CA-06 a CA-08 | pendiente |
| T-06 | Declarar la consulta de `https` en el AndroidManifest, sin permisos nuevos | — | R-07 · CA-09 | pendiente |
| P-3 | Prueba de archivo del AndroidManifest | T-06 | CA-09 | pendiente |
| T-07 | Humo manual en teléfono con la app instalada y captura al PR | T-05, T-06 | CA-10 | pendiente |
| T-08 | Puertas de CI y Memoria: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace 028`, `codemap.py`, `Memoria.md` | T-07 | Definición de terminado | pendiente |

## Paralelismo
- Se pueden empezar a la vez: T-01, T-02, T-04 y T-06.
- T-05 espera a T-02, T-03 y T-04; P-2 se hace junto con T-05.
- T-07 y T-08 van al final y en serie.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (CA-10 con evidencia manual).
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
- No se tocaron `contracts/`, `app/packages/knock_api/` ni `.github/`.
