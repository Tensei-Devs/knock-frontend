# Spec 003 — Arquitectura del panel web

> **Estado:** Aprobada · **Jira:** KNOCK-217 · **Repositorio:** knock-frontend · **Rector:** `constitution.md`

## 1. Objetivo
Definir la arquitectura del panel interno Angular y su estructura de carpetas, sin implementar pantallas de negocio.

## 2. Alcance
**Dentro**
- Estructura `core`, `shared` y `features`.
- Componentes standalone, enrutamiento y carga diferida.
- Capa de servicios sobre el cliente generado.
- Angular Material y tokens de diseño.

**Fuera**
- Pantallas de verificación, reportes y métricas.
- Autenticación del panel.

## 3. Requisitos
- **R-01:** El panel compila y abre sin funciones de negocio.
- **R-02:** El panel se publica en Railway con HTTPS obligatorio, en un espacio que aporta un integrante del equipo.
- **R-03:** El panel no se indexa en buscadores y solo permite entrar al personal autenticado.
- **R-04:** Los componentes no usan `HttpClient`; lo hacen los servicios.
- **R-05:** Cada función se carga de forma diferida.
- **R-06:** TypeScript corre en modo estricto.
- **R-07:** No se usa `innerHTML` ni `bypassSecurityTrust*` sin revisión.

## 4. Criterios de aceptación
- **CA-01:** Dado el repositorio, cuando se ejecuta `npm run lint`, `npm test` y `npm run build`, entonces todo pasa.
- **CA-02:** Dado un componente que importa `HttpClient`, cuando corre el lint, entonces falla.
- **CA-03:** Dada la navegación a una función, cuando se abre, entonces se carga su módulo.

### Verificación por caso
| Caso | Verificación |
|---|---|
| CA-01 | `npm run lint`, `npm test` y `npm run build` en `panel/` (comando) |
| CA-02 | `panel/tests/lint-boundaries.spec.ts` (`CA-003-02`) |
| CA-03 | `panel/src/app/app.routes.spec.ts` (`CA-003-03`) |

## 5. Contrato
Consume el cliente TypeScript generado del contrato OpenAPI. Fija las rutas del panel y la regla de que los componentes no usan `HttpClient`.

## 6. Amenazas y controles
| Amenaza | Control |
|---|---|
| Acceso al panel de personas sin permiso | Entrada solo de personal autenticado con permisos por rol y doble factor |
| XSS por HTML insertado sin sanear | Prohibido `innerHTML` y `bypassSecurityTrust*` sin revisión; política de seguridad de contenido |
| El panel aparece en buscadores | `noindex` y encabezados de publicación |
| Datos sensibles en el navegador | No se guardan datos de verificación en almacenamiento del navegador |

## 7. Plan de pruebas
| Tipo | ¿Aplica? | Motivo |
|---|---|---|
| Unitarias | Sí | Servicios y modelos |
| Widget / componente | Sí | Componentes con servicios simulados |
| Seguridad negativa | Sí | Rutas sin sesión y entradas con HTML |
| Arquitectura | Sí | Componentes sin `HttpClient` |
| Humo / extremo a extremo | Sí | Recorrido básico con Playwright |
| Accesibilidad | Sí | Navegación por teclado y etiquetas |

## 8. Decisiones
- **Angular:** el panel es una aplicación web interna para el personal; tiene la prioridad más baja pero es necesaria para operar la verificación y la moderación.
- **Railway para el panel:** el espacio ya existe y lo aporta un integrante del equipo, así que no genera costo adicional al proyecto; si ese espacio deja de estar disponible, la aplicación estática se puede publicar en cualquier hosting estático.
- **Standalone y carga diferida:** menos código de arranque y mejor rendimiento inicial.

## 9. Riesgos y dudas abiertas
- Ninguna duda abierta por ahora; se agregan aquí las que surjan al revisar la spec.

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-04
- [x] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
