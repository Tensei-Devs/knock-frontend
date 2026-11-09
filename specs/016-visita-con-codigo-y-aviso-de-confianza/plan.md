# Plan 016 — Visita con código y aviso de confianza (pantallas)

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Erick Trejo Reséndiz · **Revisión de par:** José Julián Hernández Hernández (Guillermo revisa el contrato de backend 022) · **Ola y sprint:** ola B · Sprint 4 (KNOCK-83 y capa Mobile de KNOCK-85)

## 1. Enfoque
1. Vendorizar las rutas de backend 022 y regenerar el cliente Dart (spec 006).
2. Dominio de la visita y de la llegada: entidades, estados en minúsculas del contrato, `motivoCodigo`, `puedeAvisar`, `puedeLlegar` y `ErrorLlegada`.
3. Datos: mapeador por rol que rechaza un `codigo` en la vista del técnico, repositorio de la visita, repositorio de la llegada con `Idempotency-Key` y copia local en el almacén seguro con `borrarDatosDeVisita()`.
4. Pantallas: visita a domicilio (código en cuatro recuadros, ocultar, regla), cita en taller («Cómo llegar») y llegada del técnico con intentos y bloqueo; botón de entrada a la hoja de la spec 022.
5. Cierre: accesibilidad, seguridad negativa (código fuera de registros, notificaciones y `shared_preferences`), captura en recientes desactivada en Android 13+ y recorrido real.

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** `AlmacenSeguro` (spec 009), `NoEncontradoFailure` (spec 015), `ClienteConEspera` (spec 009), `Modalidad` (`features/oficios/domain/`), apertura de avisos push (spec 012) y `expectAccesible` (spec 008)
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 022 «Visita segura con código» | Bloqueante para `data` | Ver la visita y confirmar la llegada | Borrador |
| Backend 021 (elección) | Origen de la visita | Que exista una visita que abrir | Borrador |
| Frontend 015 | Llega a la visita con `visitaId` | Recorrido completo | Borrador, ola A |
| Frontend 022 | Hoja del aviso | Que el botón «Avisar» abra algo | Borrador, ola B; si no está, el botón se oculta |
| Frontend 009 y 012 (aprobadas) | Almacén seguro y avisos | Copia local y apertura desde el aviso | Listas |

## 4. Riesgos y efectos secundarios
- La copia local del código es dato sensible: si el borrado al cerrar sesión falla, otra cuenta podría verlo (CA-16 y CA-19 lo prueban).
- `setRecentsScreenshotEnabled(false)` requiere código de plataforma en Android 13+; se aísla en `core/` y se prueba a mano en el PR.
- `url_launcher` es dependencia nueva (D-06): evaluar licencia, mantenimiento y OSV.
- Cambiar `errores_api.dart` para 422 y 409 de llegada afecta el mapeo común: correr la regresión completa.

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `app/test/features/actividad/presentation/visita_screen_test.dart` → `CA_016_01` | Widget |
| CA-02 | `app/test/features/actividad/data/visita_local_repository_test.dart` → `CA_016_02` | Unitaria de datos con API simulada |
| CA-03 | `app/test/features/actividad/data/visita_mapper_test.dart` → `CA_016_03` | Unitaria de datos con API simulada |
| CA-04 | `app/test/features/actividad/presentation/visita_taller_test.dart` → `CA_016_04` | Widget |
| CA-05 | `app/test/features/actividad/data/visita_repository_api_test.dart` → `CA_016_05` | Unitaria de datos con API simulada |
| CA-06 | `app/test/features/actividad/presentation/visita_screen_test.dart` → `CA_016_06` | Widget |
| CA-07 | `app/test/features/actividad/presentation/visita_controller_test.dart` → `CA_016_07` | Widget |
| CA-08 | `app/test/features/actividad/presentation/codigo_visita_test.dart` → `CA_016_08` | Widget |
| CA-09 | `app/test/features/actividad/domain/contenido_visita_test.dart` → `CA_016_09` | Unitaria de dominio |
| CA-10 | `app/test/features/trabajo/presentation/llegada_controller_test.dart` → `CA_016_10` | Widget |
| CA-11 | `app/test/features/trabajo/presentation/llegada_controller_test.dart` → `CA_016_11` | Widget |
| CA-12 | `app/test/features/trabajo/presentation/llegada_controller_test.dart` → `CA_016_12` | Widget |
| CA-13 | `app/test/features/trabajo/presentation/llegada_controller_test.dart` → `CA_016_13` | Widget |
| CA-14 | `app/test/features/actividad/presentation/accesibilidad_visita_test.dart` → `CA_016_14` | Widget de accesibilidad |
| CA-15 | `app/test/features/actividad/presentation/visita_controller_test.dart` → `CA_016_15` | Widget |
| CA-16 | `app/test/features/actividad/data/borrado_visita_test.dart` → `CA_016_16` | Unitaria de datos con API simulada |
| CA-17 | `app/test/features/trabajo/data/llegada_repository_api_test.dart` → `CA_016_17` | Unitaria de datos con API simulada |
| CA-18 | `app/test/features/actividad/data/visita_local_repository_test.dart` → `CA_016_18` | Unitaria de datos con API simulada |
| CA-19 | `app/test/seguridad/codigo_visita_test.dart` → `CA_016_19` | Seguridad negativa (`flutter test`) |
| CA-20 | `app/test/features/trabajo/presentation/llegada_screen_test.dart` → `CA_016_20` | Widget |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 (contrato) y T-02 (dominio) arrancan juntas.
- T-03 (datos de la visita), T-04 (copia local) y T-05 (llegada) esperan a T-01 y T-02 y pueden ir en paralelo entre sí.
- T-06 y T-07 (pantallas) avanzan con dobles de pruebas desde T-02.
- T-08 y T-09 cierran y bloquean el PR.

## 7. Decisiones de la spec que este plan sigue
- D-01 rutas `/visitas`
- D-03 rutas de la app por rol
- D-04 y D-12 copia en almacén seguro con una sola clave e índice
- D-05 y D-13 sin `FLAG_SECURE`, captura en recientes desactivada
- D-07 HU-037 completa en la spec 022
- D-08 mensajes por `code`
- D-09 «Ya llegué» con `puedeLlegar`
- D-10 intentos del servidor
- D-11 `Idempotency-Key` en la llegada

## 8. Verificación (comandos exactos)
```bash
cd app && flutter pub get
flutter analyze --fatal-infos
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test   # en emulador, con API simulada
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 016
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
