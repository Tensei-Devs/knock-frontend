# Plan 017 — Elegir zona por ubicación o código postal (pantalla)

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Erick Trejo Reséndiz (contrato con Ángel Alexis Blas Castillo) · **Revisión de par:** Ángel Alexis Blas Castillo · **Ola y sprint:** ola B · Sprint 4 (KNOCK-47)

## 1. Enfoque
1. Vendorizar `GET /zonas/cp/{cp}` y `POST /zonas/lista-espera` (backend 023) y confirmar en el contrato desplegado la forma de `GET /colonias/en-punto` y de `PUT /api/v1/me` (backend 017).
2. Dominio: `Zona`, `ResultadoZona` con `ciudadPiloto`, `RegistroListaEspera` y validación del código postal y del municipio.
3. Datos: repositorio por ubicación (sin caché ni registros de coordenadas), por código postal (caché en `catalogo/zonas/`), guardado en el perfil reenviando `nombre` y `fotoUrl`, y lista de espera sin `Idempotency-Key`.
4. Pantallas: paso de zona en «Completar perfil», selector reutilizable, lista de espera y tarjeta «Tu zona» con estado sin zona.
5. Cierre: borrado al cerrar sesión, privacidad de coordenadas, accesibilidad y recorrido real.

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** `Colonia` (`features/inicio/domain/colonia.dart`), `colonia_controller.dart` y `selector_de_zona.dart` existentes, `geolocator` ya evaluado, explicación previa de permisos (spec 012) y caché de catálogos (spec 010)
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 023 «Zona por ubicación o código postal» | Bloqueante para `data` | Código postal y lista de espera | Borrador |
| Backend 017 «Perfil de la persona» (aprobada) | Contrato existente | Guardar colonia y código postal | Aprobada |
| KNOCK-141 `GET /colonias/en-punto` | Ya desplegado | Zona por ubicación | Desplegado; forma por validar al vendorizar |
| Frontend 012 (aprobada) | Permisos | Explicación previa del permiso de ubicación | Lista |
| Frontend 015 | Consume la zona | `coloniaId` en la solicitud | Borrador, ola A |

## 4. Riesgos y efectos secundarios
- `PUT /api/v1/me` borra los campos opcionales omitidos: un error al reenviar `fotoUrl` borraría la foto de perfil (CA-07 lo prueba).
- El registro de acceso del servidor podría escribir `lat` y `lon` de la consulta; lo cierra backend, la app prueba su parte.
- Cambiar «Completar perfil» a dos pasos toca una pantalla ya existente: correr la regresión de Entrada y Cuenta.
- La exclusión de `knock.zona` de la copia de seguridad se coordina con las specs 015, 016 y 022 en un solo cambio del manifiesto.

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `app/test/features/inicio/presentation/zona_controller_test.dart` → `CA_017_01` | Widget |
| CA-02 | `app/test/features/inicio/presentation/zona_controller_test.dart` → `CA_017_02` | Widget |
| CA-03 | `app/test/features/inicio/presentation/selector_de_zona_test.dart` → `CA_017_03` | Widget |
| CA-04 | `app/test/features/inicio/presentation/selector_de_zona_test.dart` → `CA_017_04` | Widget |
| CA-05 | `app/test/features/inicio/presentation/lista_espera_controller_test.dart` → `CA_017_05` | Widget |
| CA-06 | `app/test/features/inicio/presentation/zona_controller_test.dart` → `CA_017_06` | Widget |
| CA-07 | `app/test/features/inicio/data/zona_repository_api_test.dart` → `CA_017_07` | Unitaria de datos con API simulada |
| CA-08 | `app/test/features/inicio/domain/zona_test.dart` → `CA_017_08` | Unitaria de dominio |
| CA-09 | `app/test/features/inicio/data/zona_repository_api_test.dart` → `CA_017_09` | Unitaria de datos con API simulada |
| CA-10 | `app/test/features/inicio/presentation/zona_controller_test.dart` → `CA_017_10` | Widget |
| CA-11 | `app/test/features/inicio/presentation/accesibilidad_zona_test.dart` → `CA_017_11` | Widget de accesibilidad |
| CA-12 | `app/test/features/inicio/data/zona_mapper_test.dart` → `CA_017_12` | Unitaria de datos con API simulada |
| CA-13 | `app/test/features/inicio/data/zona_local_repository_test.dart` → `CA_017_13` | Unitaria de datos con API simulada |
| CA-14 | `app/test/features/inicio/data/lista_espera_repository_api_test.dart` → `CA_017_14` | Unitaria de datos con API simulada |
| CA-15 | `app/test/seguridad/zona_privada_test.dart` → `CA_017_15` | Seguridad negativa (`flutter test`) |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 (contrato) y T-02 (dominio) arrancan juntas.
- T-03 (ubicación y código postal), T-04 (perfil) y T-05 (lista de espera) esperan a T-01 y T-02 y van en paralelo.
- T-06 (pantallas) avanza con dobles desde T-02; T-07 y T-08 cierran.

## 7. Decisiones de la spec que este plan sigue
- D-01 reutilizar `colonias/en-punto`
- D-03 «Ahora no» sin colonia
- D-05 y D-12 caché solo por código postal
- D-07, D-10 y D-11 `knock.zona` en `core/preferencias/` y borrado al cerrar sesión
- D-13 guardado con `PUT /api/v1/me`
- D-14 lista de espera sin `Idempotency-Key`
- D-15 municipio opcional

## 8. Verificación (comandos exactos)
```bash
cd app && flutter pub get
flutter analyze --fatal-infos
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test   # en emulador, con API simulada
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 017
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
