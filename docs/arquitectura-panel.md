# Arquitectura del panel web

> Spec 003 (KNOCK-217). Panel interno Angular para el personal; vive en `panel/`.

## Estructura
```
panel/src/app/
├─ core/       shell y piezas únicas de la aplicación (layout, interceptores, configuración)
├─ shared/     componentes, pipes y modelos reutilizables sin lógica de una función
├─ features/   una carpeta por función (home, verificación, moderación…), con pages/, components/ y <función>.routes.ts
├─ app.routes.ts   solo declara rutas diferidas (loadChildren)
└─ app.config.ts   proveedores globales
```
- Componentes **standalone** con `ChangeDetectionStrategy.OnPush`.
- **Carga diferida (R-05):** `app.routes.ts` no importa ninguna página; cada función expone `<función>.routes.ts` y se descarga al navegar. El build genera un `chunk-*.js` por función.
- **Servicios (R-04):** solo los archivos `*.service.ts`, `*.interceptor.ts` y `app.config.ts` pueden importar `@angular/common/http`. Los componentes inyectan el servicio. Cuando exista el cliente TypeScript generado del contrato OpenAPI, los servicios lo envuelven.
- **Angular Material** con tema Material 3 en `src/styles.scss`.

## Reglas que hace cumplir el lint (`panel/eslint.config.js`)
| Regla | Efecto | Prueba |
|---|---|---|
| `no-restricted-imports` | Un componente que importa `HttpClient` falla (CA-02) | `src/app/architecture/lint-boundaries.spec.ts` |
| `no-restricted-syntax` | `bypassSecurityTrust*` e `innerHTML` en código y `[innerHTML]` en plantillas fallan (R-07) | `src/app/architecture/lint-boundaries.spec.ts` |
| TypeScript `strict` y `strictTemplates` | Modo estricto (R-06) | `npm run build` |

## Publicación en Railway (R-02, R-03)
- `panel/Dockerfile` construye con Node y sirve el resultado con Caddy (`panel/Caddyfile`); `panel/railway.json` apunta a ese Dockerfile.
- Railway termina el HTTPS; el servidor además envía `Strict-Transport-Security`.
- **No indexable:** `<meta name="robots" content="noindex, nofollow">`, `public/robots.txt` con `Disallow: /` y el encabezado `X-Robots-Tag`.
- **Encabezados de seguridad:** `Content-Security-Policy` (sin scripts en línea; por eso el build desactiva `inlineCritical`), `X-Frame-Options: DENY`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`.
- Probar en local: `docker build -t knock-panel panel && docker run --rm -p 8080:8080 knock-panel` y `curl -i http://localhost:8080/`.
- Variable de Railway: `PORT` (la pone Railway).

## Lo que esta etapa no incluye
- **Acceso del personal autenticado (R-03, parte):** la spec deja fuera la autenticación del panel. Hoy el panel no tiene pantallas de negocio ni datos; antes de agregar la primera función con datos hace falta el inicio de sesión del panel y un guard que cierre por defecto.
- No se guardan datos de verificación en el almacenamiento del navegador.

## Comandos
```bash
cd panel && npm ci && npm run lint && npm test && npm run build
```
`npm test` corre las pruebas de Angular (Vitest) y las de las reglas de lint (`node --test`).
