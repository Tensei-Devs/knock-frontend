# Calidad, pruebas y DevSecOps — knock-frontend

> Matriz de los controles que corren hoy en este repositorio. Si cambias una herramienta, actualiza esta tabla en el mismo PR.
> Nivel: **PR** = `ci-pr.yml` (corre en cada PR y en cada push a las ramas fijas; el job `gate` reúne el resultado) · **Publicación** = `publish-android.yml` · **Local** = git hooks y guardián.

## 1. Comparación con los repositorios de referencia del profesor

| Práctica de referencia | Repo del profesor | En knock-frontend |
|---|---|---|
| Clean Architecture de 3 capas con DI | MobileDevSecOps (Compose + Koin) | Flutter `presentation/domain/data` + Riverpod, con prueba de capas |
| Análisis estático (Detekt, Ktlint) | MobileDevSecOps | `flutter analyze --fatal-infos --fatal-warnings` y `dart format`; ESLint y `tsc` estricto en el panel |
| Cobertura (Kover) | MobileDevSecOps | lcov (app ≥ 50 %) e Istanbul (panel ≥ 60 % líneas / 50 % ramas) |
| Pruebas instrumentadas | MobileDevSecOps | `integration_test` se corre a mano en un teléfono (`app/README.md`); el CI no lo ejecuta |
| OWASP Dependency Check, CodeQL | MobileDevSecOps | OSV-Scanner, dependency-review y `npm audit`. No se usa CodeQL |
| Unit/E2E/SAST/SCA/DAST/secretos web | WebDevSecOps | Unitarias y de componentes, Semgrep y Gitleaks. Sin E2E web ni DAST |
| — | — | Además: contrato vendorizado y cliente Dart verificado, cambios incompatibles (oasdiff), duplicación (jscpd), actionlint, mapa de código y pruebas de la landing |

## 2. Pruebas

| Tipo | Valida | App (Flutter) | Panel (Angular) | Nivel |
|---|---|---|---|---|
| Unitarias | Casos de uso, controladores, servicios | `flutter test` | `ng test` | PR |
| Widget / componente | Estados de pantalla | `testWidgets` | TestBed | PR |
| Arquitectura | Capas y funciones sin cruces | `app/test/arquitectura/` y mapa de código | ESLint, mapa de código y Semgrep | PR y Local |
| Trazabilidad | Casos `TC-<ID>-KK` de la spec del PR (solo si toca `app/` o `panel/`) | `sdd_lint.py --trace` | ídem | PR |
| Contrato | Cliente = contrato; sin cambios incompatibles | `app/tool/generar_cliente_api.py --check` y oasdiff | Sin cliente generado todavía | PR |
| Accesibilidad | Contraste, etiquetas y tamaño táctil | `meetsGuideline` en pruebas de widget | Sin prueba automática | PR |
| Compilación | Roturas de compilación | APK de depuración | `ng build` de producción | PR |
| Landing | Páginas, cabeceras, enlaces y secretos (`landing/tests`) | — | — | PR |
| Recorridos en dispositivo | Flujos principales | `app/integration_test/` | Sin E2E | A mano |
| Usabilidad | SUS ≥ 70 con 5 personas (TT-QA-03 / TT-QA-05) | Manual | Manual | Manual |

Los jobs de app y panel corren cuando el PR cambia su carpeta o `contracts/`, y en cada push a las ramas fijas. El paso de E2E del panel (Playwright) se omite mientras no exista `panel/playwright.config.*`. No hay pruebas de mutación, de regresión visual ni compilación de iOS en el CI, y no hay workflow nocturno.

## 3. Seguridad y cadena de suministro

| Control | Herramienta | Nivel | Falla cuando |
|---|---|---|---|
| SAST | Semgrep (reglas propias, p/typescript, p/secrets, p/owasp-top-ten) | PR | Hay hallazgos ERROR |
| Dependencias | dependency-review (vulnerabilidades y licencias), OSV-Scanner, `npm audit --omit=dev` (job del panel) | PR | Severidad alta o licencia denegada; OSV, ante cualquier hallazgo no exceptuado |
| Secretos | Gitleaks | PR, y pre-commit si está instalado | Hay hallazgos |
| Workflows | actionlint y acciones fijadas a SHA (`pin_actions.py --check`) | PR | Hay errores o acciones sin fijar |
| Excepciones | `check_exceptions.py` | PR y Local | Hay excepciones vencidas o supresiones sin registro |
| Firma de la app | Llave de subida en GitHub Secrets; se borra al terminar | Publicación | El paquete queda firmado con la llave de depuración |

SonarQube Cloud analiza los commits como aplicación de GitHub; no forma parte de `gate`. La pre-revisión con IA (`ai-review.yml`) es opcional y solo corre si está configurada.

## 4. OWASP Mobile / Web → control → prueba

| Riesgo | Control | Prueba |
|---|---|---|
| Almacenamiento inseguro (M9) | Tokens en `flutter_secure_storage` | Semgrep y pruebas de sesión |
| Comunicación insegura (M5) | Solo HTTPS hacia la API; certificados validados | Semgrep y pruebas |
| Autenticación (M3) | Firebase Phone Auth y tokens propios con renovación y cierre | Pruebas de sesión |
| Privacidad (M6) | Sin datos personales en registros | Revisión del PR |
| XSS (A03 web) | Sin `innerHTML` ni `bypassSecurityTrust` | ESLint, Semgrep y guardián |
| Componentes vulnerables (A06) | OSV-Scanner, dependency-review, `npm audit` | CI |

## 5. Checks del merge
El check que reúne el CI es `gate` (detect, pr-meta, pr-points, governance, contract, app, panel, sast, sca, secrets y landing); un job omitido no lo hace fallar. `pr-meta` solo corre con la variable `ENFORCE_BRANCH_RULES=true`. Configuración de ramas: `docs/BRANCH_PROTECTION.md`.

## 6. Configuración externa
Firebase (app Android registrada y números de prueba), Google Play (`docs/PUBLICACION_ANDROID.md`) y Railway para la landing y el panel.
