# Plan 018 — Verificar mi identidad y ver su estado (pantallas)

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández) · **Revisión de par:** José Julián Hernández Hernández (Guillermo revisa el contrato de backend 025) · **Ola y sprint:** ola C · Sprint 4, prioridad P3 (`candidata-recorte`)

## 1. Enfoque
1. Vendorizar las cinco rutas de backend 025 y regenerar el cliente Dart; confirmar los nombres de `tipo` de foto.
2. Dominio: `Verificacion` con los estados del contrato, `Consentimiento`, `Curp` (patrón oficial, sin `toString` con el valor) y `RevisionFoto`.
3. Datos: repositorio con crear, subir al enlace firmado, confirmar por foto, enviar y obtener; manejo de `code` de 409 y 422; fotos solo en memoria, sin EXIF y validadas antes de decodificar.
4. Pantallas: consentimiento con CURP, captura con cámara del sistema, revisión y envío, y estado con motivo, consejos y subida de nivel.
5. Cierre: seguridad negativa (CURP y fotos fuera de disco y registros), accesibilidad, imágenes sintéticas y recorrido real.

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** `image_picker` e `image` (evaluadas en la spec 015), `url_launcher` (spec 016), `AvisoNoAceptadoFailure` (spec 009), `ClienteConEspera` y apertura de avisos push (spec 012)
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 025 «Verificación de identidad con consentimiento» | Bloqueante para `data` | Todo el flujo | Borrador, ola C |
| Frontend 015 | Dependencias de imágenes evaluadas | Cámara y re-codificación | Borrador, ola A |
| Frontend 016 | `url_launcher` | Abrir el aviso de privacidad | Borrador, ola B |
| Landing (spec 004, aprobada) | URL fija del aviso de privacidad | Vista previa del aviso | Lista |

## 4. Riesgos y efectos secundarios
- Pedir la CURP agrega un dato sensible al teléfono; cualquier `print` o estado persistido lo filtraría (CA-23).
- Los umbrales de calidad pueden rechazar fotos válidas; se ajustan con imágenes sintéticas.
- El límite de 3 creaciones por hora puede bloquear pruebas manuales; usar cuentas de prueba distintas.
- Si la historia se recorta (etiqueta `candidata-recorte`), las tareas pasan completas al Sprint 5 sin cambios.

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `app/test/features/trabajo/presentation/consentimiento_controller_test.dart` → `CA_018_01` | Widget |
| CA-02 | `app/test/features/trabajo/data/verificacion_repository_api_test.dart` → `CA_018_02` | Unitaria de datos con API simulada |
| CA-03 | `app/test/features/trabajo/domain/revision_foto_test.dart` → `CA_018_03` | Unitaria de dominio |
| CA-04 | `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_04` | Widget |
| CA-05 | `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_05` | Widget |
| CA-06 | `app/test/features/trabajo/data/verificacion_repository_api_test.dart` → `CA_018_06` | Unitaria de datos con API simulada |
| CA-07 | `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_07` | Widget |
| CA-08 | `app/test/features/trabajo/presentation/estado_verificacion_screen_test.dart` → `CA_018_08` | Widget |
| CA-09 | `app/test/features/trabajo/presentation/estado_verificacion_screen_test.dart` → `CA_018_09` | Widget |
| CA-10 | `app/test/features/trabajo/presentation/estado_verificacion_screen_test.dart` → `CA_018_10` | Widget |
| CA-11 | `app/test/features/trabajo/domain/verificacion_test.dart` → `CA_018_11` | Unitaria de dominio |
| CA-12 | `app/test/features/trabajo/data/carga_verificacion_test.dart` → `CA_018_12` | Unitaria de datos con API simulada |
| CA-13 | `app/test/features/trabajo/domain/verificacion_publica_test.dart` → `CA_018_13` | Unitaria de dominio |
| CA-14 | `app/test/features/trabajo/presentation/accesibilidad_verificacion_test.dart` → `CA_018_14` | Widget de accesibilidad |
| CA-15 | `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_15` | Widget |
| CA-16 | `app/test/features/trabajo/data/foto_local_repository_test.dart` → `CA_018_16` | Unitaria de datos con API simulada |
| CA-17 | `app/test/features/trabajo/data/verificacion_repository_api_test.dart` → `CA_018_17` | Unitaria de datos con API simulada |
| CA-18 | `app/test/features/trabajo/data/foto_local_repository_test.dart` → `CA_018_18` | Unitaria de datos con API simulada |
| CA-19 | `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_19` | Widget |
| CA-20 | `app/test/features/trabajo/data/verificacion_repository_api_test.dart` → `CA_018_20` | Unitaria de datos con API simulada |
| CA-21 | `app/test/features/trabajo/data/foto_local_repository_test.dart` → `CA_018_21` | Unitaria de datos con API simulada |
| CA-22 | `app/test/features/trabajo/domain/curp_test.dart` → `CA_018_22` | Unitaria de dominio |
| CA-23 | `app/test/seguridad/curp_privada_test.dart` → `CA_018_23` | Seguridad negativa (`flutter test`) |
| CA-24 | `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_24` | Widget |
| CA-25 | `app/test/features/trabajo/presentation/verificacion_controller_test.dart` → `CA_018_25` | Widget |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 y T-02 arrancan juntas; T-03 (fotos locales) solo necesita T-02.
- T-04 (repositorio) espera a T-01 y T-02.
- T-05 y T-06 (pantallas) avanzan con dobles desde T-02.
- T-07 y T-08 cierran.

## 7. Decisiones de la spec que este plan sigue
- D-01 función en `features/trabajo/`
- D-02 consentimiento siempre sin marcar
- D-03 flujo de cuatro rutas de backend 025
- D-05 solo cámara, sin permiso `CAMERA`
- D-06 fotos en memoria, sin `FLAG_SECURE`
- D-11 creación sin `Idempotency-Key`
- D-14 consentimiento con versión y sin fecha
- D-15 CURP en memoria

## 8. Verificación (comandos exactos)
```bash
cd app && flutter pub get
flutter analyze --fatal-infos
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test   # en emulador, con API simulada
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 018
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
