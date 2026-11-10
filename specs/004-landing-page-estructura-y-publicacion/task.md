# Tareas 004 — Landing page: estructura y publicación

> **Estado:** en ejecución (KNOCK-218, 2026-11-04). La estructura base ya existía de TT-WEB-01; esta pasada la completó y dejó la publicación en Railway como paso manual del líder.

| Tarea | Qué se hace | Cubre | Estado |
|---|---|---|---|
| T-01 | Crear `landing/` con la estructura base | R-01 | hecha: `landing/` ya existía (TT-WEB-01); se agregó `eliminar-cuenta/` y se documentó en `landing/README.md` |
| T-02 | Configurar las cabeceras de seguridad y la política de contenido | R-03 · CA-02 | hecha en `landing/nginx.conf` y probada en local por archivo; CA-02 (HTTP a HTTPS) se comprueba con `curl` al publicar en Railway: pendiente |
| T-03 | Configurar la publicación automática en Railway con HTTPS | R-02 · CA-01, CA-02 | pendiente: `landing/railway.json`, `Dockerfile` y los pasos de José están en el repositorio, pero nadie ha publicado en Railway; CA-01 y CA-02 se verifican después de que José lo haga |
| T-04 | Agregar la revisión de enlaces rotos y de secretos al CI | R-04 · CA-03 | hecha: job `landing` de `ci-pr.yml` (pruebas, `landing/tests/check_links.py` y Gitleaks); aún no entra en `needs` de `gate` |
| T-05 | Definir la versión de la landing | R-05 | hecha: valor inicial `landing-v1.0.0` en el pie de `index.html`; la regla de puntos es de la spec 011 |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
