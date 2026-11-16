# Tareas 026 — Conectar la app con los endpoints reales (perfil, sesión y colonias)

> **Estado:** implementada en las PR #29 y #32 (KNOCK-248), salvo T-13 (humo manual con la evidencia en un PR), que sigue pendiente.

| Tarea | Qué se hace | Depende de | Cubre | Estado |
|---|---|---|---|---|
| T-01 | Dejar un solo almacén de tokens: el de `AlmacenSesion` (seguro) respalda a `SesionNotifier`; `main.dart` lee los tokens al arrancar y se quita el `almacenSesionProvider` duplicado | — | R-05 · CA-10 | hecho (#29 y #32) |
| T-02 | Que `ServicioEntradaReal` registre los tokens del canje en la sesión (sin reiniciar la app) | T-01 | R-05 · CA-12 | hecho (#29 y #32) |
| T-03 | Agregar `cerrar()` a `sesionIniciadaProvider`; cerrar sesión borra tokens, caché y deja la bandera en falso (el router lleva a `/entrar`) | T-01 | R-03, R-11 · CA-06, CA-26 | hecho (#29 y #32) |
| P-1 | Pruebas del grupo sesión: arranque con tokens, canje y primera llamada, cierre sin rastros en el almacén | T-01 a T-03 | CA-10, CA-12, CA-26 | hecho (#29 y #32) |
| T-04 | Crear `core/red/enviar_json.dart` (`POST`, `PUT`, `DELETE` con cuerpo JSON, mismo mapeo de errores que `obtener_json.dart`, sin cuerpos de respuesta en los errores) | — | R-08, R-11 · CA-18 | hecho (#29 y #32) |
| T-05 | `ClienteAutenticado`: Bearer solo hacia la URL de la API y solo en rutas protegidas; `auth/firebase`, `auth/refresh` y `oficios` sin `Authorization` | T-01 | R-04 · CA-09, CA-11 | hecho (#29 y #32) |
| T-06 | `RenovadorSesionApi` con `POST /auth/refresh` por el transporte público: guarda los tokens nuevos antes del reintento, single-flight, un reintento por petición; rechazo (400 o 401) o segundo 401 cierran la sesión; red, 429 y 5xx la conservan | T-04, T-05 | R-06, R-07, R-13 · CA-13 a CA-17 | hecho (#29 y #32) |
| P-2 | Pruebas del grupo transporte y renovación: Bearer, 401 con renovación, cinco llamadas simultáneas, segundo 401, rechazo y fallo transitorio del refresh, sin bucle | T-05, T-06 | CA-09, CA-11, CA-13 a CA-17, CA-25 | hecho (#29 y #32) |
| T-07 | Ampliar `Perfil` (foto, colonia, código postal, `esTecnico`, `estado`, `perfilCompleto`) y su mapper desde el JSON de `GET /me`, validando campos y tipos | — | R-01, R-02 · CA-01 | hecho (#29 y #32) |
| T-08 | `PerfilRepositoryApi`: `GET /me` con `If-None-Match` y 304, `PUT /me` que conserva los opcionales, sin sesión no sale petición | T-04, T-05, T-07 | R-01, R-02, R-13 · CA-01 a CA-05 | hecho (#29 y #32) |
| T-09 | Cierre de sesión real en `PerfilRepositoryApi.cerrarSesion`: `POST /auth/logout` sin renovación ni reintento y borrado local aunque falle; `PerfilController.cerrarSesion` reinicia colonia, oficios y modo técnico como hoy | T-03, T-08 | R-03 · CA-06 a CA-08 | hecho (#29 y #32) |
| P-3 | Pruebas del grupo perfil y cierre de sesión: repositorio con `MockClient`, 304, campos conservados, errores 400, 409, 413, 422, 429, 503 y sin red, cierre con red y sin red | T-08, T-09 | CA-01 a CA-08, CA-18 | hecho (#29 y #32) |
| T-10 | `ColoniasRepositoryHttp` por `transporteApiProvider` (con token); ajustar su comentario | T-05 | R-04 · CA-09 | hecho (#29 y #32) |
| P-4 | Pruebas del grupo colonias: lleva Bearer, 401 con renovación, regresión de oficios | T-10 | CA-09, CA-28 | hecho (#29 y #32) |
| T-11 | `SesionDispositivo`, `SesionesRepository` y `SesionesRepositoryApi` (`GET /me/sesiones`, `DELETE /me/sesiones/{id}`: 404 como ya cerrada, 409 como conflicto) con su proveedor, sin pantalla | T-04, T-05 | R-09 · CA-20, CA-21 | hecho (#29 y #32) |
| P-5 | Pruebas del grupo sesiones por dispositivo: lista, orden, `actual`, 204, 404, 409 y 401 | T-11 | CA-20, CA-21 | hecho (#29 y #32) |
| T-12 | Composición: `cuenta_providers.dart` e `inicio_providers.dart` eligen real o simulado; `main.dart` falla con `ApiNoConfiguradaFailure` en `release` sin URL válida; los simulados quedan marcados como solo para pruebas y desarrollo | T-08, T-10, T-11 | R-10, R-12 · CA-22, CA-23 | hecho (#29 y #32) |
| P-6 | Pruebas de composición y pantallas: `release` sin URL, desarrollo con y sin URL, widget de «Mi cuenta» y «Completar perfil» con cada error y reintentar, cierre de sesión hasta `/entrar` | T-12 | CA-19, CA-22, CA-23 | hecho (#29 y #32) |
| P-7 | Seguridad negativa e integración con servidor falso (`HttpServer`): token ausente de registros, `toString` y mensajes; 401 sin sesión; sesión cerrada tras fallo del refresh; flujo completo entrar, perfil, `PUT`, 401 con renovación, colonia y cierre | T-12 | CA-05, CA-15, CA-16, CA-24, CA-26, CA-27 | hecho (#29 y #32) |
| T-13 | Humo manual contra el backend desplegado con un teléfono real (perfil, cierre de sesión, colonia y lista de sesiones); la evidencia va al PR | P-7 | CA-29 | pendiente |
| T-14 | Puertas de CI y Memoria: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint` y `sdd_lint --trace 026`, regenerar el mapa de arquitectura con `scripts/codemap.py` y actualizar `Memoria.md` (decisión, pendiente de la spec 037 y del contrato vendorizado, qué evitar) | P-1 a P-7 | CA-28 · definición de terminado | hecho (#29; entrada en `Memoria.md` del 2026-11-10) |

## Paralelismo
- Se pueden empezar a la vez: T-01, T-04 y T-07.
- Después de T-05 corren en paralelo T-10 y T-11; T-06 y T-08 también, si T-04 y T-07 ya terminaron.
- Cada tarea de pruebas (P-n) se hace junto con su grupo, pero P-6 y P-7 esperan a T-12.
- T-13 y T-14 van al final y en serie.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (CA-29 con evidencia manual).
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
- No se tocaron `contracts/`, `app/packages/knock_api/` ni `.github/`.
