# Spec 045 — Maqueta base de la app (reconstrucción visual simulada)

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Jira:** KNOCK-273 (tarea) con las subtareas KNOCK-274 (base común), KNOCK-275 (pantallas del cliente), KNOCK-276 (pantallas del técnico) y KNOCK-277 (mapa real, cobertura y animaciones) · **Capas:** Mobile · **Otra parte en:** — (no agrega ni cambia endpoints)
> **Relacionada con:** specs 014 (UI con la maqueta, solo visual), 027 (previa sin sesión, datos de ejemplo rotulados), 026 (sesión y perfil reales) y las de pantallas 015 a 022 y 025 a 044.
> **Skills:** flutter-clean-architecture, reuse-before-create, testing-strategy-frontend, security-core

## 1. Objetivo
Subir a la rama del sprint la reconstrucción visual de las 52 pantallas de `maqueta-knock` dentro de la app móvil, con datos simulados, para mostrar el producto completo y para que cada spec de pantallas la valide y la conecte a su API real, sin rehacer el diseño.

## 2. Alcance
**Dentro**
- Capa `app/lib/features/maqueta/` con estado simulado, componentes de la maqueta (`ui.dart`), animaciones (`anim_k.dart`, `carga_k.dart`), mapa de Google con cobertura y rutas `/m/...`.
- Las pantallas del cliente y del técnico según `docs/demo-maqueta/ESTADO.md`.
- Lo que ya es real se queda real: login por SMS (Firebase y canje de sesión), oficios y colonias, ubicación del teléfono, perfil y cierre de sesión.
- Una bandera de compilación que activa o desactiva la capa simulada.
- Dependencias nuevas: `flutter_svg` y `lottie` (evaluadas en `Memoria.md`).

**Fuera**
- Llamar a endpoints que aún no existen; contratos y OpenAPI.
- Cambiar el diseño de la maqueta o los textos de `maqueta-knock/`.
- El dominio, los repositorios, las pruebas y los ARB de cada pantalla: son de cada spec.

## 3. Requisitos
- **R-01** Todo el código simulado vive en `features/maqueta/`; ningún otro módulo importa `maq` ni `maq.pv`.
- **R-02** La capa simulada se activa con una bandera de compilación (`MODO_MAQUETA`). Sin ella, la app usa solo lo real. Con ella, todo dato de ejemplo se rotula como tal (spec 027).
- **R-03** Lo real no se simula: sesión, perfil, oficios, colonias y ubicación siguen usando sus repositorios.
- **R-04** Sin secretos en el repositorio (la clave del mapa no se versiona) ni datos personales reales en las semillas.
- **R-05** Cada spec de pantallas que valide una pantalla quita su dependencia de la capa simulada y borra el estado simulado que ya no use; se lleva una tabla pantalla → spec → estado (simulada / conectada).
- **R-06** El CI queda en verde: análisis, formato, pruebas, cobertura, `sdd_lint`, escáneres y licencias.
- **R-07** Las animaciones respetan «reducir movimiento» y no bloquean la lectura de pantalla.

## 4. Criterios de aceptación (casos)
| Caso | Criterio | Verificación |
|---|---|---|
| CA-01 | Con `MODO_MAQUETA` las 52 pantallas de `ESTADO.md` abren y se corresponden con su captura | recorrido en emulador con evidencia |
| CA-02 | Sin `MODO_MAQUETA` no aparece ningún experto, cotización ni visita de ejemplo | prueba de widget |
| CA-03 | Con la bandera, todo dato de ejemplo lleva su rótulo | prueba de widget |
| CA-04 | Ningún archivo fuera de `features/maqueta/` importa el estado simulado | prueba de arquitectura |
| CA-05 | Login por SMS, oficios, colonias y perfil usan sus repositorios reales | pruebas existentes en verde |
| CA-06 | Tema oscuro e inglés según las capturas 50 a 52 | recorrido en emulador |
| CA-07 | Con «reducir movimiento» se muestran fotogramas fijos | prueba de widget |
| CA-08 | Ningún secreto en el diff | gitleaks (comando) |
| CA-09 | `flutter analyze`, formato, pruebas y cobertura en verde | CI (comando) |

## 5. Contrato consumido
Sin cambios: solo los endpoints ya desplegados de las specs 026 y 027.

## 6. Modelo de datos local
Estado en memoria; nada se guarda en disco salvo lo que ya guardan las specs 015, 016 y 022.

## 7. Arquitectura
`features/maqueta/` aislada, con `datos.dart`, `estado.dart`, `tecnico_estado.dart`, `ui.dart`, pantallas y rutas `/m/...` en `app_router.dart`. La retirada progresiva (R-05) reemplaza cada pantalla por su versión con controlador y repositorio dentro del módulo de su spec.

## 8. Amenazas y controles
- Datos de ejemplo confundidos con reales → bandera y rótulo (R-02).
- Clave del mapa y tokens en el repositorio → no se versionan (R-04).
- Dependencias nuevas con licencia o vulnerabilidad → evaluación en `Memoria.md` y exención solo en `security/exceptions.yaml` si hace falta.
- Capa simulada permanente → tabla y regla de retirada (R-05).

## 9. Plan de pruebas
Reescribir o retirar con justificación las 90 pruebas del diseño anterior; pruebas de la bandera, del rótulo, de la arquitectura (R-01) y de «reducir movimiento». Recorrido en emulador con evidencia.

## 10. Definición de terminado
Los casos CA-01 a CA-09 cubiertos, CI en verde, `Memoria.md` al día, `ESTADO.md` convertido en la tabla de R-05, y PR con la plantilla completa.

## 11. Decisiones tomadas sin consulta
Ninguna. Las de §12 las toma la persona que aprueba.

## 12. Riesgos y dudas abiertas
1. **Textos:** `tr()` con diccionario (como está) o claves ARB (como piden los specs). Mientras la capa sea simulada se propone `tr()`, y cada spec migra a ARB al conectar su pantalla.
2. **Cobertura:** si las pruebas de la capa simulada no alcanzan el 50 %, hay que excluir `features/maqueta` en el CI. Eso toca `.github/` (archivo protegido) y necesita autorización expresa; la alternativa es escribir las pruebas.
3. **Pruebas en rojo:** 90 pruebas del diseño anterior; verificar la cifra actual antes de decidir cuáles se reescriben y cuáles se retiran.
4. **Número de spec y de subtareas:** confirmar contra la rama de KNOCK-266.
5. **Revisión de pares:** el reglamento pide comentario de otra persona; si no hay disponible, registrarlo en el PR como excepción.

## Aprobación
- [ ] Revisor 1 — nombre: ____________________ fecha: __________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
