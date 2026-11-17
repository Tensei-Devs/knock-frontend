# Tareas 045 — Maqueta base de la app (reconstrucción visual simulada)

> **Estado:** en curso. La capa existe y está verificada pantalla por pantalla en emulador (`docs/demo-maqueta/ESTADO.md`); faltan la bandera `MODO_MAQUETA`, las pruebas y la evidencia de CI.
> **Responsable por omisión:** José Julián Hernández Hernández.

| Tarea | Qué se hace | Depende de | Cubre | Estado |
|---|---|---|---|---|
| T-01 | Base común: componentes, estado simulado, textos `tr()`, rutas `/m/...`, transiciones y dependencias (KNOCK-274) | — | R-01, R-03 | hecha en la rama; falta CI |
| T-02 | Pantallas del cliente (KNOCK-275) | T-01 | R-01, R-03 · CA-01 | hecha en la rama; falta CI |
| T-03 | Pantallas del técnico (KNOCK-276) | T-01 | R-01, R-03 · CA-01 | hecha en la rama; falta CI |
| T-04 | Mapa real, cobertura y animaciones (KNOCK-277) | T-01 | R-02, R-07 · CA-07 | hecha en la rama; falta CI |
| T-05 | Bandera `MODO_MAQUETA` (apagada por defecto), router condicionado y rótulo fijo de datos de ejemplo | T-01 a T-04 | R-02 · CA-02, CA-03 | hecha (commit de la bandera y pruebas `CA_045_02`) |
| P-1 | Pruebas del diseño anterior: con la bandera apagada pasan sin tocarlas (95 regresiones, 0 preexistentes) | T-01 a T-04 | R-06 · CA-09 | hecha: 796 de 796 en checkout limpio |
| P-2 | Prueba de arquitectura: fuera de `features/maqueta/` solo se importa la fachada, y solo el router y la raíz | T-05 | R-01 · CA-04 | hecha (`maqueta_aislada_test.dart`) |
| P-3 | Pruebas de CA-06 (oscuro e inglés en 12 rutas, una por función) y CA-07 («reducir movimiento»: espera con fotograma fijo, mensajes sin fundido, app en modo maqueta) | T-04 | R-07 · CA-06, CA-07 | hecha (`maqueta_a11y_test.dart`; se comprobó que 3 de las 4 de CA-07 fallan si el código ignora el ajuste) |
| P-4 | Prueba de que el rótulo no tapa ningún texto ni elemento tocable (45 rutas × 5 escenarios de pantalla) | T-08 | CA-03 | hecha (`rotulo_no_tapa_test.dart`; falla si el rótulo vuelve a flotar sobre la pantalla) |
| T-06 | Evidencia: recorrido de las 52 pantallas, gitleaks y CI en verde | P-1, P-2, P-3 | CA-01, CA-08, CA-09 | parcial (2026-11-16): 45 rutas montadas por prueba; builds debug con y sin la bandera compilan; gitleaks 8.30.1 sin hallazgos en `sprint-04..HEAD`; CI del PR #66 en `aab92ac`: App (formato, análisis, 830 pruebas, cobertura 67,7 % y build), gobernanza, contrato, SAST, Semgrep, Gitleaks y landing en verde; fallan solo puntos y SCA. **CA-01 sigue pendiente del recorrido físico en teléfono** |
| T-07 | `Memoria.md`, mapa de arquitectura y tabla pantalla → spec → estado (R-05) | T-06 | R-05 | pendiente |
| T-08 | Rótulo «Datos de ejemplo» sin tapar cabeceras ni acciones | T-05 | R-02 · CA-03 | hecha (2026-11-16): franja fija superior con su propio alto (`fachada_maqueta.dart`); `rotulo_no_tapa_test.dart` la comprueba en 45 rutas y 5 tamaños, con y sin barra de estado |
| T-09 | Licencias de las dependencias nuevas en la lista del CI | T-01 | R-06 · CA-09 | aplicada (2026-11-16, autorizada por el Tech Lead): 6 paquetes añadidos a `allow-dependencies-licenses` y al alcance de EXC-002 (57 a 63), sin cambiar `creada` ni `vence`; falta confirmar el SCA en el CI |
| T-10 | Enmienda 1: conectar las pantallas de la maqueta a los endpoints reales, por fases (oficios y colonias, zona, sesiones; solicitudes; cotizaciones, elegir y visita) y mantener `ESTADO.md` como tabla pantalla → spec → estado | T-05 | R-05 · CA-10 a CA-12 | pendiente de aprobar la enmienda |

## Definición de terminado
- Casos CA-01 a CA-09 cubiertos y CI en verde con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
