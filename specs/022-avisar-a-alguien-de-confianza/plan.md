# Plan 022 — Avisar a alguien de confianza

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Erick Trejo Reséndiz · **Revisión de par:** José Julián Hernández Hernández · **Ola y sprint:** ola B · Sprint 4 (KNOCK-84, etiquetas `sprint-4` y `candidata-recorte`); si se recorta, pasa completa al Sprint 5

## 1. Enfoque
1. Vendorizar `POST /visitas/{id}/aviso` de backend 022 (cuerpo vacío, respuesta con `texto`).
2. Dominio: `ContactoConfianza` (validación y duplicados), `MensajeAviso` (texto del servidor tal cual, sin código ni dirección) y enlaces `sms:` y `wa.me`.
3. Datos: contactos en el almacén seguro con `borrarTodos()` y repositorio del aviso que rechaza respuestas con `incluyeCodigo` o `incluyeDireccion` verdaderos.
4. Pantallas: hoja del aviso (abierta desde la 016), contactos en Mi cuenta y formulario.
5. Cierre: manifiesto sin permisos de contactos, SMS ni llamadas, accesibilidad y recorrido con contactos ficticios.

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** `AlmacenSeguro` (spec 009), copia local de la visita y botón de entrada (spec 016), `url_launcher` (evaluada en la 016) y la «fila» de la spec 014
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 022 (`POST /visitas/{id}/aviso`) | Bloqueante para el texto del servidor | Aviso con texto del servidor | Borrador; sin conexión hay texto local de respaldo |
| Frontend 016 | Botón, `puedeAvisar` y copia local | Entrada a la hoja | Borrador, ola B |
| Frontend 012 (aprobada) | Regla de no pedir permisos de contactos | R-03 | Lista |

## 4. Riesgos y efectos secundarios
- El código no sale del servidor en el aviso, así que no hay secreto que compartir desde el teléfono; la vista previa final evita enviar texto no revisado (D-06, decisión de revisión, confirmar).
- `share_plus` es dependencia nueva: evaluar licencia, mantenimiento y OSV.
- En Android 11+, sin `queries` para `sms:` y `https:` los botones no encuentran aplicación.

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `app/test/features/actividad/presentation/hoja_avisar_test.dart` → `CA_022_01` | Widget |
| CA-02 | `app/test/features/actividad/domain/mensaje_aviso_test.dart` → `CA_022_02` | Unitaria de dominio |
| CA-03 | `app/test/features/actividad/domain/mensaje_aviso_test.dart` → `CA_022_03` | Unitaria de dominio |
| CA-04 | `app/test/features/actividad/data/contactos_confianza_repository_test.dart` → `CA_022_04` | Unitaria de datos con API simulada |
| CA-05 | `app/test/features/actividad/domain/contacto_confianza_test.dart` → `CA_022_05` | Unitaria de dominio |
| CA-06 | `app/test/features/actividad/data/contactos_confianza_repository_test.dart` → `CA_022_06` | Unitaria de datos con API simulada |
| CA-07 | `app/test/features/actividad/domain/contacto_confianza_test.dart` → `CA_022_07` | Unitaria de dominio |
| CA-08 | `app/test/features/actividad/data/contactos_confianza_repository_test.dart` → `CA_022_08` | Unitaria de datos con API simulada |
| CA-09 | `app/test/features/actividad/domain/enlace_aviso_test.dart` → `CA_022_09` | Unitaria de dominio |
| CA-10 | `app/test/features/actividad/domain/enlace_aviso_test.dart` → `CA_022_10` | Unitaria de dominio |
| CA-11 | `app/test/android/manifiesto_permisos_test.dart` → `CA_022_11` | Prueba del manifiesto |
| CA-12 | `app/test/features/actividad/presentation/hoja_avisar_test.dart` → `CA_022_12` | Widget |
| CA-13 | `app/test/features/actividad/data/borrado_visita_test.dart` → `CA_022_13` | Unitaria de datos con API simulada |
| CA-14 | `app/test/features/cuenta/presentation/contactos_confianza_screen_test.dart` → `CA_022_14` | Widget |
| CA-15 | `app/test/features/actividad/data/aviso_repository_api_test.dart` → `CA_022_15` | Unitaria de datos con API simulada |
| CA-16 | `app/test/features/actividad/presentation/hoja_avisar_test.dart` → `CA_022_16` | Widget |
| CA-17 | `app/test/features/actividad/presentation/accesibilidad_aviso_test.dart` → `CA_022_17` | Widget de accesibilidad |
| CA-18 | `app/test/seguridad/seguridad_cliente_test.dart` → `CA_022_18` | Seguridad negativa (`flutter test`) |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 y T-02 arrancan juntas; T-03 solo necesita T-02.
- T-04 espera a T-01 y T-02.
- T-05 y T-06 (pantallas) con dobles desde T-02.
- T-07 y T-08 cierran.

## 7. Decisiones de la spec que este plan sigue
- D-01 contactos también en Mi cuenta
- D-02 SMS y WhatsApp por intención
- D-03 dueña completa de HU-037
- D-04 celular de 10 dígitos de México
- D-05 evento sin cuerpo
- D-06 el código no viaja en el aviso (sin casilla); decisión de revisión, confirmar
- D-07 texto local sin conexión

## 8. Verificación (comandos exactos)
```bash
cd app && flutter pub get
flutter analyze --fatal-infos
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test   # en emulador, con API simulada
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 022
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
