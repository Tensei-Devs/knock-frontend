# Plan 015 — Pedir y comparar cotizaciones (pantallas)

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Erick Trejo Reséndiz · **Revisión de par:** José Julián Hernández Hernández · **Ola y sprint:** ola A · Sprint 4 (KNOCK-244 y KNOCK-245)

## 1. Enfoque
1. Vendorizar el contrato de backend 020, 021 y 032 en `contracts/openapi.v1.json` y regenerar el cliente Dart (spec 006); mientras no exista, trabajar `domain/` y `presentation/` contra la interfaz `SolicitudRepository` con un doble de pruebas.
2. Escribir el dominio en Dart puro: entidades, validación de los tres pasos y mapeo de `code` a `Failure`.
3. Escribir la capa `data`: mapeador del contrato, repositorio sobre el cliente generado, preparación y subida de fotos (backend 032) y borrador en `core/preferencias/`.
4. Construir las pantallas del formulario, el detalle, la comparación y la hoja de confirmación con sus estados (cargando, con datos, vacío, error y sin conexión).
5. Cerrar con seguridad negativa, accesibilidad, textos ARB, prueba del manifiesto y recorrido real contra el entorno desplegado con datos de semilla (KNOCK-246).

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** `Modalidad` (`features/oficios/domain/modalidad.dart`), catálogo de oficios con caché (spec 010), `ClienteConEspera` (spec 009), `Failure` y `mensaje_failure.dart` (spec 002), `expectAccesible` (spec 008) y el almacén de `core/preferencias/` (spec 012)
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 020 «Solicitudes y cotizaciones» | Bloqueante para `data` | Crear y ver la solicitud | Borrador; sin contrato publicado |
| Backend 021 «Comparar y elegir cotización» | Bloqueante para `data` | Comparar y elegir | Borrador |
| Backend 032 «CDN de imágenes» | Bloqueante para las fotos | Subir fotos (HU-024 exige al menos una) | Borrador, propuesta para el Sprint 5: hay que adelantar sus dos endpoints |
| Frontend 006 (cliente generado) | Aprobada | Única puerta a la API | Lista |
| Frontend 017 (zona) | Necesaria para enviar | `coloniaId` de la solicitud | Borrador, ola B |
| Frontend 016 (visita) | Destino después de elegir | «Ver mi visita» | Borrador, ola B |
| KNOCK-246 (semillas de demo) | Para el recorrido real | Cotizaciones sin app del técnico | Por hacer |

## 4. Riesgos y efectos secundarios
- Cambios de nombres al vendorizar el contrato obligan a corregir mapeadores y esta spec antes de implementar.
- Agregar `image_picker`, `image` y `path_provider` exige evaluarlas y registrarlas en `Memoria.md` (D-10).
- El manifiesto (`allowBackup` o reglas de extracción) es compartido con las specs 009, 016, 017 y 022: un solo cambio coordinado.
- Modificar `errores_api.dart` para el 404 afecta a todas las pantallas: correr la regresión completa.
- Sin backend 032 en el Sprint 4 no hay fotos; la demo usaría solicitudes de semilla.

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `app/test/features/actividad/presentation/solicitud_controller_test.dart` → `CA_015_01` | Widget |
| CA-02 | `app/test/features/actividad/domain/validacion_solicitud_test.dart` → `CA_015_02` | Unitaria de dominio |
| CA-03 | `app/test/features/actividad/presentation/selector_fotos_test.dart` → `CA_015_03` | Widget |
| CA-04 | `app/test/features/actividad/domain/validacion_solicitud_test.dart` → `CA_015_04` | Unitaria de dominio |
| CA-05 | `app/test/features/actividad/presentation/paso_cuando_donde_test.dart` → `CA_015_05` | Widget |
| CA-06 | `app/test/features/actividad/data/solicitud_repository_api_test.dart` → `CA_015_06` | Unitaria de datos con API simulada |
| CA-07 | `app/test/features/actividad/presentation/cotizaciones_screen_test.dart` → `CA_015_07` | Widget |
| CA-08 | `app/test/features/actividad/presentation/cotizaciones_controller_test.dart` → `CA_015_08` | Widget |
| CA-09 | `app/test/features/actividad/presentation/cotizaciones_controller_test.dart` → `CA_015_09` | Widget |
| CA-10 | `app/test/features/actividad/presentation/tarjeta_cotizacion_test.dart` → `CA_015_10` | Widget |
| CA-11 | `app/test/features/actividad/presentation/hoja_confirmar_eleccion_test.dart` → `CA_015_11` | Widget |
| CA-12 | `app/test/features/actividad/presentation/cotizaciones_controller_test.dart` → `CA_015_12` | Widget |
| CA-13 | `app/test/features/actividad/data/solicitud_repository_api_test.dart` → `CA_015_13` | Unitaria de datos con API simulada |
| CA-14 | `app/test/features/actividad/data/borrador_repository_test.dart` → `CA_015_14` | Unitaria de datos con API simulada |
| CA-15 | `app/test/features/actividad/presentation/solicitud_controller_test.dart` → `CA_015_15` | Widget |
| CA-16 | `app/test/features/actividad/presentation/accesibilidad_solicitud_test.dart` → `CA_015_16` | Widget de accesibilidad |
| CA-17 | `app/test/features/actividad/domain/validacion_solicitud_test.dart` → `CA_015_17` | Unitaria de dominio |
| CA-18 | `app/test/features/actividad/data/foto_preparada_test.dart` → `CA_015_18` | Unitaria de datos con API simulada |
| CA-19 | `app/test/features/actividad/data/borrador_repository_test.dart` → `CA_015_19` | Unitaria de datos con API simulada |
| CA-20 | `app/test/features/actividad/data/solicitud_repository_api_test.dart` → `CA_015_20` | Unitaria de datos con API simulada |
| CA-21 | `app/test/features/actividad/data/fotos_privadas_test.dart` → `CA_015_21` | Unitaria de datos con API simulada |
| CA-22 | `app/test/features/actividad/presentation/solicitud_controller_test.dart` → `CA_015_22` | Widget |
| CA-23 | `app/test/features/actividad/data/solicitud_repository_api_test.dart` → `CA_015_23` | Unitaria de datos con API simulada |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 (contrato) y T-02 (dominio) arrancan el mismo día: T-02 no necesita el contrato.
- T-03, T-04 y T-05 (datos) esperan a T-01; T-06 (borrador) solo necesita T-02.
- T-07 y T-08 (pantallas) pueden empezar con dobles de pruebas en cuanto exista T-02 y se conectan a `data` al final.
- T-09 (seguridad y accesibilidad) y T-10 (cierre) van al final y bloquean el PR.

## 7. Decisiones de la spec que este plan sigue
- D-01 función en `features/actividad/`
- D-02 sin `Idempotency-Key` y D-15 mensajes por `code`
- D-04 y D-16 nada de solicitudes, cotizaciones ni de la cita en caché o disco
- D-10 dependencias evaluadas antes de agregarlas
- D-11 `shared_preferences` solo en `core/preferencias/`
- D-12 sin permiso `CAMERA`
- D-13 sin filtro «Solo verificados» y D-14 sin distancia

## 8. Verificación (comandos exactos)
```bash
cd app && flutter pub get
flutter analyze --fatal-infos
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test   # en emulador, con API simulada
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 015
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
