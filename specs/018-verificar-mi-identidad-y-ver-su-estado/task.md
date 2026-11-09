# Tareas 018 — Verificar mi identidad y ver su estado (pantallas)

> **Estado:** pendientes. En esta etapa **no se ejecutan**: se activan cuando la spec esté Aprobada y una persona lo indique.
> **Responsable sugerido por omisión:** Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández). «Paralelo» indica con qué tareas puede avanzar a la vez; «Bloquea» qué tareas esperan a esta.

| Tarea | Qué se hace | Cubre | Depende de | Bloquea | Paralelo con | Responsable sugerido | Estado |
|---|---|---|---|---|---|---|---|
| T-01 | Vendorizar las rutas de backend 025 y regenerar el cliente Dart | §4 | Backend 025 publicado en OpenAPI | T-04 | T-02 | Guillermo (contrato) y Erick | pendiente |
| T-02 | Dominio: `Verificacion`, `Consentimiento`, `Curp`, `RevisionFoto` y vista pública | R-01, R-04, R-07, R-08, R-18 · CA-01, CA-03, CA-11, CA-13, CA-22 | — | T-03, T-04, T-05, T-06 | T-01, T-03 | Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández) | pendiente |
| T-03 | Fotos locales: validación previa (JPEG o PNG, 8 MB), re-codificación sin EXIF y borrado de la copia temporal | R-05, R-06, R-17 · CA-16, CA-18, CA-19, CA-21 | T-02 | T-07 | T-01, T-04 | Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández) | pendiente |
| T-04 | Datos: crear, subir, confirmar por foto, enviar y obtener, con mapeo de `code` | R-02, R-09, R-10, R-16, R-19 · CA-02, CA-04–CA-07, CA-17, CA-20, CA-24, CA-25 | T-01, T-02 | T-07 | T-03, T-05 | Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández) | pendiente |
| T-05 | Pantallas de consentimiento con CURP, captura y envío con sus mensajes | R-01, R-03, R-13 · CA-01, CA-03, CA-14 | T-02 | T-07 | T-04, T-06 | Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández) | pendiente |
| T-06 | Pantalla de estado (en revisión, verificada, no verificada, fotos borradas) y apertura desde el aviso push | R-07, R-08, R-11 · CA-08–CA-12 | T-02 | T-07 | T-05 | Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández) | pendiente |
| T-07 | Seguridad negativa (CURP y fotos fuera de disco, registros y caché), accesibilidad y rutas por rol | R-12, R-14, R-15, R-18 · CA-15, CA-23 | T-03, T-04, T-05, T-06 | T-08 | — | Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández) | pendiente |
| T-08 | Integración con API simulada, recorrido real con imágenes sintéticas, ARB, `Memoria.md` y PR | §11 | T-07 | — | — | Erick Trejo Reséndiz (responsable de la historia: José Julián Hernández Hernández) | pendiente |

## Dependencias con backend y con otras specs
- **Backend 025** debe publicar sus cinco rutas antes de T-01; su cifrado, OCR y borrado a 7 días no se prueban desde la app.
- La URL fija del aviso de privacidad en la landing debe existir antes de T-05.

## Ruta crítica y trabajo en paralelo
- Ruta crítica: backend 025 publicado → T-01 → T-04 → T-07 → T-08.
- En paralelo: T-02, T-03, T-05 y T-06 con dobles de pruebas.

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde (`python scripts/sdd_lint.py --trace 018` sin `FALTA`).
- Análisis estático, formato, pruebas, cobertura y escáneres del CI en verde, con resultados reales en el PR.
- Un par revisó el cambio, el PR usa la plantilla completa y `Memoria.md` está al día.
