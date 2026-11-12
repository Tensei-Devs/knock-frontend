# Plan 021 — Buscar un experto por texto (app)

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Erick Trejo Reséndiz · **Revisión de par:** Ángel Alexis Blas Castillo (contrato de backend 027) · **Ola y sprint:** Sprint 5 (KNOCK-66, etiqueta `sprint-5`); la spec se deja lista en el Sprint 4

## 1. Enfoque
1. Vendorizar `GET /api/v1/busqueda` de backend 027 y regenerar el cliente.
2. Dominio: `ConsultaBusqueda` (2 a 80 caracteres), `ResultadoBusqueda` con `interpretacion` y `ExpertoEncontrado` sin contacto.
3. Datos: repositorio con cursor, cancelación de la petición anterior y sin caché en disco.
4. Pantallas: barra en Inicio y `/inicio/buscar` con pausa de 400 ms, filtros, interpretación, estados y paso a «Pedir cotización» con `oficioClave`.
5. Cierre: privacidad del texto buscado, accesibilidad y recorrido.

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** catálogo de oficios con caché (spec 010), zona guardada (spec 017), formulario de la spec 015 con `oficioClave` y componentes base de la spec 014
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 027 «Buscar un experto por texto» | Bloqueante para `data` | Búsqueda | Borrador, Sprint 5 |
| Frontend 017 | Zona guardada (`coloniaId`) | Buscar cerca | Borrador, ola B |
| Frontend 015 | Formulario con `oficioClave` | Destino del resultado | Borrador, ola A |

## 4. Riesgos y efectos secundarios
- Una consulta por tecla agotaría el límite de 30 por minuto: la pausa y la cancelación son obligatorias (CA-07).
- Mostrar «expertos cercanos» puede hacer pensar que se elige a uno; el texto de la pantalla lo aclara (reparto por oleadas).

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `app/test/features/inicio/presentation/busqueda_resultados_test.dart` → `CA_021_01` | Widget |
| CA-02 | `app/test/features/inicio/presentation/busqueda_resultados_test.dart` → `CA_021_02` | Widget |
| CA-03 | `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_03` | Widget |
| CA-04 | `app/test/features/inicio/presentation/busqueda_resultados_test.dart` → `CA_021_04` | Widget |
| CA-05 | `app/test/features/inicio/domain/consulta_busqueda_test.dart` → `CA_021_05` | Unitaria de dominio |
| CA-06 | `app/test/features/inicio/domain/consulta_busqueda_test.dart` → `CA_021_06` | Unitaria de dominio |
| CA-07 | `app/test/features/inicio/presentation/busqueda_controller_test.dart` → `CA_021_07` | Widget |
| CA-08 | `app/test/features/inicio/presentation/busqueda_controller_test.dart` → `CA_021_08` | Widget |
| CA-09 | `app/test/features/inicio/presentation/busqueda_resultados_test.dart` → `CA_021_09` | Widget |
| CA-10 | `app/test/features/inicio/data/busqueda_mapper_test.dart` → `CA_021_10` | Unitaria de datos con API simulada |
| CA-11 | `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_11` | Widget |
| CA-12 | `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_12` | Widget |
| CA-13 | `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_13` | Widget |
| CA-14 | `app/test/features/inicio/data/busqueda_repository_api_test.dart` → `CA_021_14` | Unitaria de datos con API simulada |
| CA-15 | `app/test/features/inicio/presentation/busqueda_estados_test.dart` → `CA_021_15` | Widget |
| CA-16 | `app/test/features/inicio/presentation/accesibilidad_busqueda_test.dart` → `CA_021_16` | Widget de accesibilidad |
| CA-17 | `app/test/features/inicio/presentation/busqueda_controller_test.dart` → `CA_021_17` | Widget |
| CA-18 | `app/test/features/inicio/data/busqueda_repository_api_test.dart` → `CA_021_18` | Unitaria de datos con API simulada |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 y T-02 arrancan juntas; T-03 espera a T-01.
- T-04 avanza con dobles desde T-02.
- T-05 y T-06 cierran.

## 7. Decisiones de la spec que este plan sigue
- D-01 búsqueda en `features/inicio/`
- D-02 2 a 80 caracteres y pausa de 400 ms
- D-03 filtros de backend 027
- D-04 sin historial
- D-05 el resultado abre «Pedir cotización»
- D-06 sin diccionario local

## 8. Verificación (comandos exactos)
```bash
cd app && flutter pub get
flutter analyze --fatal-infos
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test   # en emulador, con API simulada
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 021
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
