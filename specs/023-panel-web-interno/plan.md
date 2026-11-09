# Plan 023 — Panel web interno: entrada con permisos y doble factor

> Parte de `spec.md` (Estado: Borrador). Este plan se confirma cuando la spec esté **Aprobada**; mientras tanto **no se ejecuta**.
> **Responsable sugerido:** Ángel Alexis Blas Castillo (la capa Panel web puede repartirse) · **Revisión de par:** José Julián Hernández Hernández · **Ola y sprint:** Sprint 5 (KNOCK-75, etiquetas `sprint-5` y `candidata-recorte`); la spec se deja lista en el Sprint 4

## 1. Enfoque
1. Vendorizar las cuatro rutas de sesión de backend 033 y regenerar el cliente TypeScript.
2. Servicio de sesión del panel en `core/auth/`: tokens en memoria, renovación con `withCredentials` y `X-Knock-Panel: 1`, cierre, inactividad y mapeo de `code`.
3. Guarda por permiso, menú por permisos y páginas «Sin permiso» y «Sin acceso».
4. Pantalla de acceso en tres pasos con Firebase (celular y SMS) y TOTP, con sus estados y mensajes.
5. Cierre: encabezados de seguridad del despliegue, accesibilidad AA y pruebas de arquitectura.

## 2. Mapeo de archivos
- **Reutilizar (buscar antes con `python scripts/codemap.py --query`, skill `reuse-before-create`):** estructura `core/shared/features` y reglas de la spec 003, cliente TypeScript generado (spec 006), Angular Material y su tema
- **Crear y modificar:** los archivos de la tabla de §9 de `spec.md`, sin agregar otros sin anotarlo en el PR.
- **No tocar:** `app/packages/knock_api/` y `panel/src/app/api/` (generados), `contracts/`, `scripts/`, `.github/`, `.agents/`, `constitution.md`, `security/exceptions.yaml` y las specs aprobadas 001 a 013 (y la 014, reservada).

## 3. Dependencias

| Dependencia | Tipo | Qué desbloquea | Estado al 9 de noviembre de 2026 |
|---|---|---|---|
| Backend 033 «Panel interno con permisos y doble factor» | Bloqueante para el servicio de sesión | Acceso al panel | Borrador, Sprint 5 |
| Frontend 003 (aprobada) | Estructura del panel | Reglas de capas y lint | Lista |
| Firebase Phone Auth en web | Externo | Paso del celular | Riesgo de cuota y reCAPTCHA (KNOCK-146) |
| Cuenta de semilla con TOTP (backend 033, `--secreto-de-prueba`) | Para E2E | Prueba de punta a punta | Por crear |

## 4. Riesgos y efectos secundarios
- La cookie `Partitioned` y `SameSite=None` depende del soporte del navegador; se prueba en Chrome y Firefox actuales.
- Firebase Phone Auth en web consume cuota; se usan números de prueba en desarrollo.
- Agregar Playwright al panel es dependencia nueva de desarrollo: evaluarla y registrarla.

## 5. Pruebas por criterio

| Caso | Prueba | Suite |
|---|---|---|
| CA-01 | `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_01` | Vitest (componente o servicio) |
| CA-02 | `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_02` | Vitest (componente o servicio) |
| CA-03 | `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_03` | Vitest (componente o servicio) |
| CA-04 | `panel/src/app/core/auth/permisos.guard.spec.ts` → `CA_023_04` | Vitest (componente o servicio) |
| CA-05 | `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_05` | Vitest (componente o servicio) |
| CA-06 | `panel/src/app/core/auth/inactividad.service.spec.ts` → `CA_023_06` | Vitest (componente o servicio) |
| CA-07 | `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_07` | Vitest (componente o servicio) |
| CA-08 | `panel/src/app/core/auth/almacen-sesion.spec.ts` → `CA_023_08` | Vitest (componente o servicio) |
| CA-09 | `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_09` | Vitest (componente o servicio) |
| CA-10 | (comando) `cd panel && npm run lint` y `npm run test:architecture` | Comando en el CI (evidencia en el PR) |
| CA-11 | `panel/src/app/architecture/encabezados-panel.spec.ts` → `CA_023_11` | Vitest (componente o servicio) |
| CA-12 | `panel/src/app/features/acceso/pages/accesibilidad-acceso.spec.ts` → `CA_023_12` | Vitest (componente o servicio) |
| CA-13 | `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_13` | Vitest (componente o servicio) |
| CA-14 | `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_14` | Vitest (componente o servicio) |
| CA-15 | (comando) `cd panel && npm run lint` | Comando en el CI (evidencia en el PR) |
| CA-16 | `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_16` | Vitest (componente o servicio) |
| CA-17 | `panel/src/app/core/auth/sesion-panel.service.spec.ts` → `CA_023_17` | Vitest (componente o servicio) |
| CA-18 | `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_18` | Vitest (componente o servicio) |
| CA-19 | `panel/src/app/features/acceso/pages/acceso-page.spec.ts` → `CA_023_19` | Vitest (componente o servicio) |

Además: prueba de contrato del cliente generado (spec 006), prueba global de registros sin datos personales (spec 009), prueba de traducciones completas y análisis estático y de vulnerabilidades del CI (Semgrep, CodeQL, detección de secretos y OSV para dependencias nuevas).

## 6. Secuencia y paralelismo
- T-01 y T-02 (servicio con dobles) arrancan juntas.
- T-03 (guardas y menú) y T-04 (acceso) dependen de T-02 y van en paralelo.
- T-05 (encabezados) es independiente.
- T-06 y T-07 cierran.

## 7. Decisiones de la spec que este plan sigue
- D-01 tokens en memoria y cookie `HttpOnly`
- D-02 inactividad de 15 minutos
- D-03 un solo mensaje de error
- D-04 sin alta de TOTP en el panel
- D-05 celular con Firebase
- D-06 cinco permisos
- D-07 rutas de backend 033
- D-08 `403 permiso_insuficiente` no cierra la sesión

## 8. Verificación (comandos exactos)
```bash
cd panel && npm ci
npm run lint
npm test        # incluye npm run test:architecture
npm run build
# E2E con Playwright: el panel aún no tiene script; se agrega con la tarea de E2E de esta spec
cd .. && python scripts/sdd_lint.py && python scripts/sdd_lint.py --trace 023
```
- Cada criterio de §5 se comprueba con su prueba o comando antes de dar el cambio por terminado; lo que no se pudo ejecutar se dice en el PR.
- Se actualiza `Memoria.md` (decisiones, dependencias nuevas y pendientes) y el PR lleva la plantilla completa y la etiqueta de puntos.
