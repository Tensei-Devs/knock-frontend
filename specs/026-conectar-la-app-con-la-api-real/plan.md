# Plan 026 — Conectar la app con los endpoints reales (perfil, sesión y colonias)

> Parte de `spec.md` (estado Borrador). Este plan se confirma cuando la spec esté Aprobada.

## Enfoque
Se va de abajo hacia arriba, para que cada capa se pruebe con la de abajo ya firme.

1. **Sesión única.** Un solo almacén de tokens (el seguro) que alimenta al transporte: se leen al arrancar, se registran al canjear y se borran al cerrar. `sesionIniciadaProvider` aprende a cerrarse.
2. **Transporte.** El Bearer solo en rutas protegidas de la API; renovación real con single-flight y un reintento; el `refresh` por el transporte público para no hacer bucle; el `logout` sin renovación.
3. **Llamadas sin cliente generado.** Se amplía el patrón de `obtener_json.dart` a `POST`, `PUT` y `DELETE` con el mismo mapeo de errores (spec 006 y decisión D-01).
4. **Perfil y cierre de sesión reales** (`PerfilRepositoryApi`), con los campos opcionales conservados en el `PUT`.
5. **Colonias con token** y **sesiones por dispositivo** como capa de datos, sin pantalla.
6. **Composición.** `cuenta_providers.dart` e `inicio_providers.dart` eligen real o simulado; `main.dart` falla en `release` sin URL válida.
7. **Pruebas por grupo de criterios** y cierre con las puertas de CI y `Memoria.md`.

## Archivos que se crean o cambian
Crean:
- `app/lib/core/sesion/renovador_sesion_api.dart`
- `app/lib/core/red/enviar_json.dart`
- `app/lib/features/cuenta/data/perfil_repository_api.dart`, `perfil_mapper.dart`
- `app/lib/features/cuenta/domain/sesion_dispositivo.dart`, `sesiones_repository.dart`
- `app/lib/features/cuenta/data/sesiones_repository_api.dart`
- `app/test/core/sesion/`, `app/test/core/red/`, `app/test/features/cuenta/`, `app/test/features/inicio/` (pruebas nuevas), `app/test/integracion_api/`

Cambian:
- `app/lib/core/sesion/sesion.dart`, `sesion_provider.dart`, `almacen_sesion.dart` (se quita el proveedor duplicado), `cliente_autenticado.dart`, `servicio_entrada.dart`
- `app/lib/core/red/cliente_api_provider.dart`, `obtener_json.dart`
- `app/lib/features/cuenta/cuenta_providers.dart`, `domain/perfil.dart`, `domain/perfil_repository.dart` (comentarios), `presentation/perfil_controller.dart`
- `app/lib/features/inicio/inicio_providers.dart`, `data/colonias_repository_http.dart` (comentario)
- `app/lib/main.dart`, `app/lib/core/sesion/arranque_sesion.dart`
- `Memoria.md` y el mapa de arquitectura (`scripts/codemap.py`)

No se tocan: `contracts/`, `app/packages/knock_api/`, `.github/`, ARB, pantallas, rutas y `pubspec.yaml`.

## Dependencias
- Ninguna nueva. Se reutilizan `http` (con `http/testing` en pruebas), `flutter_riverpod` y `flutter_secure_storage`, ya presentes.
- Backend: specs 015 a 018 desplegadas y la URL del gateway por `--dart-define=KNOCK_API_URL`.

## Orden y paralelismo
```
T-01 -> T-02, T-03                 (sesión)
T-04 (enviar_json)  y  T-01 -> T-05 (Bearer) -> T-06 (refresh)
T-07 (Perfil) + T-04 + T-05 -> T-08 (PerfilRepositoryApi) -> T-09 (cierre de sesión, también tras T-03)
T-05 -> T-10 (colonias)
T-04 + T-05 -> T-11 (sesiones)
T-08 + T-10 + T-11 -> T-12 (composición) -> P-6, P-7 -> T-13 (humo) -> T-14 (CI y Memoria)
```
- En paralelo desde el inicio: T-01 (sesión), T-04 (llamadas) y T-07 (modelo de `Perfil`), que no comparten archivos.
- En paralelo después de T-05: T-06, T-10 y T-11 (T-06 también espera a T-04).
- En serie: T-06 y T-08 antes de T-09 si se quiere probar el cierre con renovación; todo antes de T-12; T-13 y T-14 al final.
- Las pruebas P-1 a P-5 se escriben junto con su grupo; P-6 y P-7 esperan a T-12.

## Decisiones de la spec que este plan sigue
- **D-01** llamadas sin cliente generado hasta vendorizar el contrato.
- **D-02** un solo almacén de tokens, el seguro.
- **D-03 y D-04** solo el rechazo del refresh o un segundo 401 cierran la sesión.
- **D-05** el `logout` no se renueva ni se reintenta.
- **D-06** el `PUT` reenvía los opcionales del último `GET`.
- **D-08** sin mensajes ni textos nuevos.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con una prueba (nombre con `CA-026-NN`) o con el humo manual de CA-29 antes de dar el cambio por terminado.
- Se ejecutan los comandos de `AGENTS.md`, `python scripts/sdd_lint.py` y `python scripts/sdd_lint.py --trace 026`, y se actualiza `Memoria.md`.
