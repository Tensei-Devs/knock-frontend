# Plan 020 — Mi actividad y mis conversaciones

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Erick Trejo Reséndiz · **Revisión de par:** Guillermo (contratos de backend 026 y 030) y José Julián Hernández Hernández · **Ola y sprint:** Sprint 5 (KNOCK-69 y KNOCK-73, etiqueta `sprint-5`); la spec se deja lista en el Sprint 4

## 1. Enfoque
1. Vendorizar `GET /api/v1/solicitudes` (backend 020) y, cuando exista, el contrato de conversaciones de backend 030; documentar el hub de backend 026 (no está en OpenAPI).
2. Dominio: `ServicioDeActividad`, `AccionPrincipal` por estado (incluye `calificada`), `Conversacion` y `ContadorDeNoLeidos`.
3. Datos: lista de Actividad con cursor; conversaciones detrás de una interfaz (D-03) y canal en vivo con reconexión acotada.
4. Pantallas: Actividad con secciones y tarjetas, globo en el `AppShell` y lista de conversaciones.
5. Cierre: limpieza al cerrar sesión, privacidad del último mensaje, accesibilidad y recorrido.

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** `Solicitud` y estados de la spec 015, tarjeta de la última solicitud (se retira), `AppShell` (spec 001), componentes base de la spec 014 y `ClienteConEspera` (spec 009)
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 020 (`GET /solicitudes`) | Bloqueante para la lista | Actividad | Borrador |
| Backend 030 «Chatear antes de elegir y mis conversaciones» | Bloqueante para el globo | Conversaciones, no leídos y marca de lectura | En elaboración; pendiente de validar |
| Backend 026 (hub) | Canal en vivo | Contador en vivo | Borrador |
| Backend 029 y frontend 025 | Estados `cancelada` y `vencida` | Acción «Volver a pedir» | En elaboración |
| Frontend 015 | Detalle y comparación | Destinos de las tarjetas | Borrador |

## 4. Riesgos y efectos secundarios
- Backend 026 no guarda mensajes; si backend 030 tampoco guarda un resumen, CA-04 y CA-09 a CA-11 no se pueden cumplir.
- El globo puede tapar controles con texto al 200 %; se prueba en 320 × 640.
- Agregar un cliente de SignalR es dependencia nueva (D-04): evaluarla antes.

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `app/test/features/actividad/domain/orden_actividad_test.dart` → `CA_020_01` | Unitaria de dominio |
| CA-02 | `app/test/features/actividad/presentation/tarjeta_actividad_test.dart` → `CA_020_02` | Widget |
| CA-03 | `app/test/features/actividad/presentation/tarjeta_actividad_test.dart` → `CA_020_03` | Widget |
| CA-04 | `app/test/features/actividad/presentation/tarjeta_actividad_test.dart` → `CA_020_04` | Widget |
| CA-05 | `app/test/features/actividad/presentation/actividad_screen_test.dart` → `CA_020_05` | Widget |
| CA-06 | `app/test/features/actividad/data/actividad_repository_api_test.dart` → `CA_020_06` | Unitaria de datos con API simulada |
| CA-07 | `app/test/features/actividad/data/actividad_repository_api_test.dart` → `CA_020_07` | Unitaria de datos con API simulada |
| CA-08 | `app/test/core/widgets/globo_conversaciones_test.dart` → `CA_020_08` | Widget o unitaria de `core` |
| CA-09 | `app/test/features/mensajes/presentation/conversaciones_screen_test.dart` → `CA_020_09` | Widget |
| CA-10 | `app/test/features/mensajes/presentation/conversaciones_controller_test.dart` → `CA_020_10` | Widget |
| CA-11 | `app/test/features/mensajes/presentation/conversaciones_screen_test.dart` → `CA_020_11` | Widget |
| CA-12 | `app/test/core/widgets/globo_conversaciones_test.dart` → `CA_020_12` | Widget o unitaria de `core` |
| CA-13 | `app/test/features/mensajes/data/canal_mensajes_test.dart` → `CA_020_13` | Unitaria de datos con API simulada |
| CA-14 | `app/test/features/mensajes/presentation/conversaciones_estados_test.dart` → `CA_020_14` | Widget |
| CA-15 | `app/test/features/actividad/presentation/actividad_estados_test.dart` → `CA_020_15` | Widget |
| CA-16 | `app/test/features/mensajes/data/limpieza_mensajes_test.dart` → `CA_020_16` | Unitaria de datos con API simulada |
| CA-17 | `app/test/features/actividad/presentation/accesibilidad_actividad_test.dart` → `CA_020_17` | Widget de accesibilidad |
| CA-18 | `app/test/seguridad/seguridad_cliente_test.dart` → `CA_020_18` | Seguridad negativa (`flutter test`) |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 (contrato de la lista) y T-02 (dominio) arrancan juntas.
- T-03 (lista) espera a T-01; T-04 (conversaciones) y T-05 (canal) esperan a backend 030 y 026.
- T-06 (Actividad) avanza con T-03; T-07 (globo y conversaciones) con dobles desde T-02.
- T-08 y T-09 cierran.

## 7. Decisiones de la spec que este plan sigue
- D-01 Actividad con `GET /solicitudes`
- D-02 20 por página
- D-03 conversaciones detrás de una interfaz
- D-04 cliente de SignalR evaluado
- D-05 globo en el `AppShell`
- D-06 contador del servidor

## 8. Verificación (comandos exactos)
```bash
cd app && flutter pub get
flutter analyze --fatal-infos
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test   # en emulador, con API simulada
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 020
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
