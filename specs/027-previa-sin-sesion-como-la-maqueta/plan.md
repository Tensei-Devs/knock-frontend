# Plan 027 — Previa sin sesión (pantalla de inicio antes de entrar) según la maqueta

> Parte de `spec.md` (Aprobada; actualizada por la decisión D-12 del Tech Lead, 2026-11-10).

## Enfoque
De abajo hacia arriba: primero las reglas puras (rutas y vista del mapa), luego las piezas de pantalla y al final el flujo completo.

1. **Rutas y redirección.** `Rutas.previa` y `Rutas.previaOficios`; `redireccionPorSesion` manda a la previa lo protegido sin sesión y deja pasar lo público. No se toca la sesión de la spec 026.
2. **Datos de ejemplo y mapa.** Datos de ejemplo siempre visibles y rotulados (sin bandera), colores del mapa en los tokens del tema y la vista pura del mapa (`VistaMapa`: pan, zoom y límites).
3. **Regreso tras entrar.** Un solo `requerirCuenta` y un validador de destinos permitidos.
4. **Pantalla.** Barra de marca arriba; debajo, el mapa dibujado a pantalla completa con buscador y chips flotando encima, botones del mapa, hoja de invitación y un panel inferior plegable con «Explorar», las tarjetas de expertos y el catálogo.
5. **Textos y accesibilidad.** ARB es/en mínimos y revisión de 48 dp, contraste y texto al 200 %.
6. **Integración y puertas.** Flujo previa → login → app, seguridad negativa de la bandera, CI y Memoria.

## Dependencia de la spec 026
Esta spec **se implementa después de la 026 o apilada sobre su rama**. Necesita de ella: el almacén único de tokens y `sesionIniciadaProvider.cerrar()`, el Bearer solo en rutas protegidas (para que `GET /oficios` salga sin `Authorization`) y el cierre de sesión que borra todo. Si se apila, las tareas T-01 a T-03 pueden empezar, pero T-13 (integración con cierre de sesión) espera a que la 026 esté integrada. La spec 027 no cambia archivos de sesión de la 026.

## Archivos que se crean o cambian
- `app/lib/core/router/rutas.dart` y `app_router.dart` (cambian).
- `app/lib/core/tema/colores_mapa.dart` (nuevo): colores del mapa y de los pines.
- `app/lib/features/previa/` (nuevo): `domain/requerir_cuenta.dart`, `domain/destino_de_regreso.dart`, `domain/vista_mapa.dart`, `demo/datos_de_ejemplo.dart`, `presentation/` con la pantalla, el panel y `mapa/`.
- `app/lib/features/entrada/presentation/entrada_controller.dart` o el punto que hoy navega tras entrar (cambia solo para leer el destino de regreso).
- `app/lib/l10n/app_es.arb` y `app_en.arb` (textos nuevos) y su generado.
- Pruebas en `app/test/` y `app/integration_test/` con `CA-027-NN` en el nombre.
- `specs/README.md`, `Memoria.md` y el mapa de arquitectura.
- **No cambian:** `contracts/`, `app/packages/knock_api/`, `.github/`, ni los archivos de sesión de la spec 026.

## Dependencias
- Ninguna nueva. Se reutilizan `go_router`, `flutter_riverpod`, `http` (con `http/testing` en pruebas) y `flutter_test`.
- Backend: solo `GET /api/v1/oficios`, ya desplegado y público.
- La búsqueda de expertos (spec 027 del backend) **no** es dependencia: queda fuera.

## Orden y paralelismo
```
T-01 (rutas) -> T-02 (redirect) -> P-1
T-03 (colores y vista del mapa) -> T-04 (datos de ejemplo) -> P-2
T-05 (destino de regreso) -> T-06 (requerirCuenta) -> P-3
T-07 (textos) -> T-08 (barra) , T-09 (buscador+hoja) , T-10 (chips+catálogo) , T-11 (panel+mapa, también T-04)
T-08 a T-11 -> T-12 (ensamblar previa y ruta) -> P-4, P-5
T-12 + T-06 + 026 -> T-13 (regreso tras entrar) -> P-6
P-1 a P-6 -> T-15 (humo manual) -> T-16 (CI y Memoria)
```
- En paralelo desde el inicio: T-01, T-03, T-05 y T-07 (no comparten archivos).
- En paralelo después de T-07: T-08, T-09 y T-10; T-11 también espera a T-04.
- En serie: T-12 antes de las integraciones; T-15 y T-16 al final.
- Las pruebas P-n se escriben junto con su grupo; P-5, P-6 y P-7 esperan a T-12, T-13 y T-14.

## Decisiones de la spec que este plan sigue
- **D-01** «Registrarme» y «Entrar» abren el mismo flujo.
- **D-02** chips con los oficios reales.
- **D-03** cerrar sesión lleva a la previa.
- **D-05** reemplazada por D-12: no hay bandera de demostración.
- **D-06** mapa de ejemplo dibujado, sin SDK; con D-12 a pantalla completa y con pan y zoom.
- **D-08** lista corta de destinos de regreso permitidos.
- **D-09** obsoleta por D-12: ya no hay paso de CI para `release`.
- **D-12** mapa completo y ejemplos siempre visibles y rotulados (decisión del Tech Lead).

## Verificación
- Cada criterio de `spec.md` se comprueba con una prueba (nombre con `CA-027-NN`) o con el humo manual de T-15.
- Se ejecutan los comandos de `AGENTS.md`, `python scripts/sdd_lint.py` y `python scripts/sdd_lint.py --trace 027`, y se actualiza `Memoria.md`.
