# Plan 024 — Notificaciones de la cadena de solicitudes

> Parte de `spec.md` (estado Borrador). Este plan se confirma cuando la spec esté Aprobada. **Jira:** KNOCK-60 (HU-050, capa Mobile).

## Enfoque
1. **Dominio puro primero** (sin Firebase): `EventoAviso`, `CargaAviso`, `IdRecurso`, `DestinoAviso` y `ResultadoAviso`, con sus pruebas y mutación. Se puede hacer hoy, porque no depende de backend.
2. **Presentador**: decide qué se hace con cada carga (sesión, preferencia, duplicado, primer plano, conversación abierta) detrás de puertos (`ServicioNotificaciones`, `NotificacionesLocales`, sesión y preferencias); se prueba con dobles.
3. **Textos y Configuración**: ARB por evento, canales y la franja de permiso negado en la sección de avisos de la spec 012.
4. **Navegación**: `abrirPantallaDesdeNotificaciones` (spec 012) pasa a resolver el destino con `destino_aviso.dart`; las pantallas destino agregan el estado «no disponible» donde falte.
5. **Adaptador real**: notificaciones locales sobre la dependencia evaluada (D-02) y mensajes de datos de Firebase; llega cuando el adaptador de la spec 012 exista (`google-services.json` y `firebase_messaging`).
6. **Integración y E2E**: dobles en `integration_test/` y, cuando backend envíe la carga v1, prueba manual en emulador.

## Archivos que se crean o cambian
- `app/lib/core/notificaciones/` (`evento_aviso.dart`, `carga_aviso.dart`, `destino_aviso.dart`, `presentador_avisos.dart`, `texto_aviso.dart`, `notificaciones_locales.dart`, `refresco_por_aviso.dart`; se modifican `navegacion_notificaciones.dart` y `servicio_notificaciones.dart`).
- `app/lib/core/widgets/aviso_en_app.dart` (o el componente de aviso de la spec 014, si ya existe).
- `app/lib/features/cuenta/presentation/seccion_avisos.dart`.
- `app/lib/core/sesion/` (cierre de sesión: cancelar notificaciones y vaciar `avisosVistos`).
- `app/lib/l10n/app_es.arb`, `app_en.arb`.
- `app/pubspec.yaml`, `Memoria.md` (dependencia de D-02).
- `app/test/core/notificaciones/`, `app/test/fixtures/avisos/`, `app/test/seguridad/`, `app/integration_test/avisos_test.dart`.

## Dependencias
- **Internas (bloquean el adaptador real, no el dominio):** spec 012 con el adaptador de Firebase y el permiso; KNOCK-228 (sesión real).
- **Pantallas destino:** specs 015, 016, 019, 020 y 025; mientras no existan, el destino cae en la pestaña natural del tipo.
- **Backend:** spec de envío de notificaciones (HU-050, sin número), 020, 021, 022, 028, 029 y 030. La app no espera a backend para el dominio ni para las pruebas con dobles.
- **Dependencia externa nueva:** paquete de notificaciones locales (D-02), evaluado antes de agregarlo.

## Decisiones de la spec que este plan sigue
- Carga v1 con `evento`, `recurso` y `aviso`, compatible con la de la spec 012 (D-01).
- Mensajes solo de datos y texto desde los ARB (D-02).
- Identificador `ObjectId` validado y plantillas de ruta cerradas (D-03).
- Sin sesión se descarta el destino (D-04); en primer plano, aviso dentro de la app (D-05).
- `mensaje_nuevo` abre `/conversaciones` mientras no haya chat (D-06).

## Riesgos del plan
- El adaptador real depende de archivos de configuración que entrega el líder; el dominio y el presentador no.
- Si backend 028, 029 o 030 cambian el nombre de sus eventos, solo cambia la tabla de origen; la carga es la de esta spec.

## Verificación
- Cada criterio de aceptación de `spec.md` se comprueba con la prueba indicada antes de dar el cambio por terminado (`python3 scripts/sdd_lint.py --trace 024`).
- Se ejecutan los comandos de `AGENTS.md` y se actualiza `Memoria.md`.
