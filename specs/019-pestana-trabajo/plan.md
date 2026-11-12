# Plan 019 — Pestaña Trabajo (lado del técnico)

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Erick Trejo Reséndiz · **Revisión de par:** Guillermo (contrato de backend 028) y José Julián Hernández Hernández · **Ola y sprint:** Sprint 5 (KNOCK-67, etiqueta `sprint-5`); la spec se deja lista en el Sprint 4

## 1. Enfoque
1. Vendorizar la bandeja y el descarte de backend 028; vendorizar la spec 036 (resumen `GET /tecnicos/me/trabajo`) cuando se apruebe.
2. Dominio: entidades de §5 sin campos de contacto del cliente y reglas de secciones.
3. Datos: dos repositorios (bandeja con cursor y descarte idempotente; resumen con «Terminadas» paginado), cada uno con su propio estado.
4. Pantalla Trabajo con seis secciones, estados por sección, confirmación de descarte y enlaces a la visita (spec 016) y a la verificación (spec 018).
5. Cierre: seguridad negativa, accesibilidad y recorrido con técnico de semilla.

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** `enlace_mapa` y la ruta `/trabajo/visita/:id` de la spec 016, `Modalidad`, `Franja` (spec 015), redirección por rol (spec 001) y los componentes base de la spec 014
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 028 «Repartir la solicitud por oleadas» | Bloqueante para la bandeja y el descarte | Solicitudes nuevas | Borrador, Sprint 5 |
| Spec de backend del resumen de Trabajo | Bloqueante para visitas, enviadas y terminadas | Cuatro secciones | **No existe**; hay que pedirla |
| Backend 020 y 022 | Estados y vista del técnico | Tarjetas de cotización y de visita | Borradores |
| Frontend 016 y 018 | Destinos de «Ya llegué» y del aviso de verificación | Navegación | Borradores |

## 4. Riesgos y efectos secundarios
- Sin la spec del resumen, cuatro de las seis secciones quedan sin datos; la pantalla debe funcionar con solo la bandeja (CA-17).
- Las fotos del cliente se muestran al técnico desde el contenedor público (backend 032); no se guardan en disco.
- El orden de implementación con la spec 016 importa: `trabajo_providers.dart` lo crea la 016.

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `app/test/features/trabajo/presentation/trabajo_screen_test.dart` → `CA_019_01` | Widget |
| CA-02 | `app/test/features/trabajo/data/trabajo_mapper_test.dart` → `CA_019_02` | Unitaria de datos con API simulada |
| CA-03 | `app/test/features/trabajo/presentation/trabajo_controller_test.dart` → `CA_019_03` | Widget |
| CA-04 | `app/test/features/trabajo/presentation/trabajo_controller_test.dart` → `CA_019_04` | Widget |
| CA-05 | `app/test/features/trabajo/presentation/tarjeta_visita_test.dart` → `CA_019_05` | Widget |
| CA-06 | `app/test/features/trabajo/domain/enlace_mapa_test.dart` → `CA_019_06` | Unitaria de dominio |
| CA-07 | `app/test/features/trabajo/presentation/tarjeta_visita_test.dart` → `CA_019_07` | Widget |
| CA-08 | `app/test/features/trabajo/presentation/trabajo_estados_test.dart` → `CA_019_08` | Widget |
| CA-09 | `app/test/features/trabajo/presentation/trabajo_estados_test.dart` → `CA_019_09` | Widget |
| CA-10 | `app/test/core/router/redireccion_trabajo_test.dart` → `CA_019_10` | Widget o unitaria de `core` |
| CA-11 | `app/test/features/trabajo/data/trabajo_repository_api_test.dart` → `CA_019_11` | Unitaria de datos con API simulada |
| CA-12 | `app/test/features/trabajo/presentation/trabajo_controller_test.dart` → `CA_019_12` | Widget |
| CA-13 | `app/test/features/trabajo/presentation/cabecera_trabajo_test.dart` → `CA_019_13` | Widget |
| CA-14 | `app/test/features/trabajo/presentation/accesibilidad_trabajo_test.dart` → `CA_019_14` | Widget de accesibilidad |
| CA-15 | `app/test/features/trabajo/data/trabajo_repository_api_test.dart` → `CA_019_15` | Unitaria de datos con API simulada |
| CA-16 | `app/test/seguridad/seguridad_cliente_test.dart` → `CA_019_16` | Seguridad negativa (`flutter test`) |
| CA-17 | `app/test/features/trabajo/presentation/trabajo_estados_test.dart` → `CA_019_17` | Widget |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 (contrato 028) y T-02 (dominio) arrancan juntas.
- T-03 (bandeja y descarte) espera a T-01; T-04 (resumen) espera al contrato del resumen y puede quedar para después.
- T-05 (pantalla) avanza con dobles desde T-02.
- T-06 y T-07 cierran.

## 7. Decisiones de la spec que este plan sigue
- D-01 bandeja de backend 028 y resumen propuesto
- D-02 sin «Chatear y cotizar»
- D-03 «Disponible hoy» de solo lectura
- D-04 nada en caché
- D-05 sin detalle aparte
- D-06 «Cómo llegar» reutilizado

## 8. Verificación (comandos exactos)
```bash
cd app && flutter pub get
flutter analyze --fatal-infos
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test   # en emulador, con API simulada
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 019
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
