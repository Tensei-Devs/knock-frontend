# Plan 045 — Maqueta base de la app (reconstrucción visual simulada)

> Parte de `spec.md` (Aprobada).

## Enfoque
Subir lo que ya existe en la rama local de la maqueta, ordenado en una rama y un PR con un commit por subtarea de Jira. Los archivos de `features/maqueta/` se importan entre sí, así que solo el estado final de la rama compila; el CI corre sobre ese estado.

1. **KNOCK-274 · Base común:** `ui.dart`, `datos.dart`, `estado.dart`, `tecnico_estado.dart`, `en_dict.dart`, `nav.dart`, logo SVG, rutas `/m/...`, transiciones y dependencias (`flutter_svg`, `lottie`), con su registro en `Memoria.md`.
2. **KNOCK-275 · Pantallas del cliente:** entrada, inicio, explorar, buscar, solicitud, actividad y cuenta.
3. **KNOCK-276 · Pantallas del técnico:** registro, verificación, Trabajo, chat, cotización, perfil y reputación.
4. **KNOCK-277 · Mapa real, cobertura y animaciones:** `mapa_google.dart`, `cobertura.dart`, `anim_k.dart`, `carga_k.dart`, Lotties y su generador.
5. **Cierre:** bandera `MODO_MAQUETA`, pruebas (R-06), mapa de arquitectura y `Memoria.md`.

## Archivos que se tocan
- Crear: todo `app/lib/features/maqueta/`, `app/assets/img/`, `app/assets/lottie/`, `app/tool/lottie_gen/`, `docs/demo-maqueta/ESTADO.md`.
- Editar: `app.dart`, `core/router/` (`app_router.dart`, `app_shell.dart`, `rutas.dart`), `core/tema/tema.dart`, `previa/.../mapa_previa.dart`, `pubspec.yaml`, `pubspec.lock`, `test/core/tema/tema_oscuro_test.dart`, `Memoria.md`.
- No tocar: `contracts/`, `app/packages/knock_api/`, `.github/` (salvo autorización expresa por la cobertura), `constitution.md`, `maqueta-knock/`.

## Dependencias y orden
Las dos dependencias nuevas se evalúan antes (licencia, vulnerabilidades, tamaño). La retirada progresiva de la capa simulada la hace cada spec de pantallas (R-05).
