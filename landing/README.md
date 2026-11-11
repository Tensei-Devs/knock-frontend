# landing/ — sitio estático de Knock

> Spec vigente: [`specs/004-landing-page-estructura-y-publicacion/spec.md`](../specs/004-landing-page-estructura-y-publicacion/spec.md) (KNOCK-218, Aprobada). La estructura base viene de TT-WEB-01 (KNOCK-148, ahora en `specs/_legacy/`). El texto legal de `/privacidad/` y `/eliminar-cuenta/` está **vigente** desde la versión 1.0 (5 de noviembre de 2026), con la revisión legal pendiente (ver «Textos legales»).

HTML y CSS sin JavaScript ni build, servidos por nginx sin root (`nginxinc/nginx-unprivileged`, fijada por versión y digest) en el puerto 8080. Railway construye la imagen con el `Dockerfile` de esta carpeta. El `Dockerfile` aplica con `apk upgrade` los parches de Alpine que la imagen base aún no trae (lista en su comentario); al subir el digest base, revisa con Trivy si esa línea sigue haciendo falta.

## Rutas
| Ruta | Archivo | Nota |
|---|---|---|
| `/` | `index.html` | Inicio, bloque de Google Play y pie con la versión |
| `/privacidad/` | `privacidad/index.html` | Aviso de privacidad **vigente** (`data-estado="vigente"`, versión 1.0, indexable) |
| `/eliminar-cuenta/` | `eliminar-cuenta/index.html` | Eliminación de cuenta y datos **vigente** (`data-estado="vigente"`, versión 1.0, indexable); sin formularios |
| cualquier otra | `404.html` | 404 propio (también para carpetas sin `index.html`) |
| `/favicon.ico` | — | 204 hasta tener el icono de la app |
| `/terminos/` | — | No la pide la spec 004; todavía no existe (el consentimiento de términos se registra en el backend) |

## Correr en local
```bash
python -m unittest discover -s landing/tests -v      # desde la raíz del repositorio, sin red
docker build -t knock-landing landing
docker run -d --rm -p 8080:8080 --name kl knock-landing
curl -sI http://localhost:8080/            # cabeceras de seguridad
docker exec kl id -u                       # 101 (sin root)
docker stop kl
```
Si el puerto 8080 de tu máquina está ocupado, publica otro: `-p 18080:8080` y usa `http://localhost:18080/`.

Validar el HTML con el Nu HTML Checker fijado por digest (en Git Bash, antepón `MSYS_NO_PATHCONV=1`). La imagen trae el validador como `/vnu.jar`, no como `/vnu-runtime-image/bin/vnu`:
```bash
docker run --rm ghcr.io/validator/validator@sha256:8f21030474e68e06905cfa801b37376e99c0e37867c653c5b6cd7e2dcaf3f503 java -jar /vnu.jar --version
docker run --rm -v "$PWD/landing":/w ghcr.io/validator/validator@sha256:8f21030474e68e06905cfa801b37376e99c0e37867c653c5b6cd7e2dcaf3f503 java -jar /vnu.jar --skip-non-html /w
```

## Cabeceras de seguridad (spec 004, R-03)
Las fija `nginx.conf` con `add_header ... always` en el bloque `server`; la prueba `test_TC_TT_WEB_01_04_cabeceras` exige exactamente este conjunto.

| Cabecera | Valor | Para qué |
|---|---|---|
| `Content-Security-Policy` | `default-src 'none'; style-src 'self'; font-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'; upgrade-insecure-requests` | Solo recursos del mismo origen; sin scripts; nadie puede enmarcar la página |
| `X-Frame-Options` | `DENY` | Equivalente de `frame-ancestors` para navegadores viejos |
| `X-Content-Type-Options` | `nosniff` | Evita que el navegador adivine el tipo de archivo |
| `Referrer-Policy` | `no-referrer` | No envía la URL de origen a otros sitios |
| `Strict-Transport-Security` | `max-age=31536000` | HSTS: el navegador pide HTTPS durante un año. Railway termina el HTTPS y redirige HTTP a HTTPS en su dominio; nginx solo ve HTTP en el 8080 y por eso declara también la cabecera |
| `Cross-Origin-Opener-Policy` / `Cross-Origin-Resource-Policy` | `same-origin` | Aislamiento entre sitios |
| `Permissions-Policy` | cámara, micrófono, geolocalización, pagos, USB y `browsing-topics` desactivados | Menos superficie |

## Reglas que rompen la CSP si se ignoran
- Nada de `<script>`, `style=""`, `<style>`, atributos `on*`, formularios ni recursos de otro origen. La CSP es `default-src 'none'; style-src 'self'; font-src 'self'; img-src 'self'; …`.
- No declares `add_header` dentro de un `location` de `nginx.conf`: nginx deja de heredar las cabeceras del `server`. La caché usa `expires`.
- Los colores salen solo de los tokens `--color-*` de `css/landing.css`, con los pares permitidos de TT-MOB-02. La prueba TC-06 rechaza otro par.

## Diseño de la página principal (KNOCK-258)
`/` ocupa una sola pantalla sin scroll (spec 004, R-06) y se anima solo con CSS (R-07):
- El logo es el oficial de la maqueta (`knock-icono.svg` y `knock-letras.svg`), incrustado como SVG. La ilustración y las insignias de oficios también son SVG en el HTML, para no agregar archivos al `Dockerfile` ni pasar el límite de peso.
- El selector de tema («Claro» y «Oscuro») usa enlaces de ancla y `:target`, sin JavaScript ni `<input>` (R-08); no se recuerda entre páginas.
- Redes sociales (R-09): el pie lleva un ícono de Instagram (SVG propio, `aria-label="Instagram de Knock"`, 48×44 px) hacia `https://www.instagram.com/knock.mx/`. Cuando haya más redes se agregan igual, una por una y con su URL oficial; `test_landing.py` y `check_links.py` solo permiten las URL externas de esa lista. Google Analytics no entra (spec 004 y CSP).
- Todo el diseño cuelga de `body.inicio`; el aviso de privacidad, eliminar cuenta y el 404 no cambian.
- Si la pantalla es baja, primero se oculta lo decorativo y después las etiquetas; el contenido y los enlaces no se recortan.
- `prefers-reduced-motion: reduce` apaga todas las animaciones y transiciones.
- Para comprobar CA-04 sin scroll: abre `/` en 1920×1080, 1366×768, 390×844, 360×640, 320×568 y 844×390 y verifica que `documentElement.scrollHeight` no pase de `clientHeight`.

## Google Play: de «próximamente» a «disponible»
Al nacer, `index.html` tiene la variante «próximamente». Cuando la ficha de Play sea pública, cambia en un PR esa línea por la variante «disponible» y sube la versión del pie:
```html
<!-- Antes -->
<p class="play" data-play="proximamente">Próximamente en Google Play</p>
<!-- Después -->
<p class="play" data-play="disponible"><a class="play-boton" href="https://play.google.com/store/apps/details?id=app.knock.mobile&amp;referrer=utm_source%3Dlanding%26utm_medium%3Dweb%26utm_campaign%3Dlanding">Descargar en Google Play</a></p>
```
Solo una variante puede estar presente. No uses `target="_blank"` (si algún día hace falta, con `rel="noopener noreferrer"`). La prueba `test_TC_TT_WEB_01_02_enlaces` exige la URL exacta.

## Fuentes
`fonts/nunito-400-latin.woff2` y `fonts/nunito-700-latin.woff2` son subconjuntos de `app/assets/fonts/nunito/Nunito-Regular.ttf` y `Nunito-Bold.ttf` (TT-MOB-02). `fonts/OFL.txt` es copia sin cambios de `app/assets/fonts/nunito/OFL.txt` (OFL 1.1, sin Reserved Font Name). Se generaron una vez con fontTools 4.68.0 y brotli 1.2.1 en un entorno virtual fuera del repositorio; no entran al contenedor ni al CI:
```bash
pyftsubset app/assets/fonts/nunito/Nunito-Regular.ttf --unicodes="U+0020-007E,U+00A0-00FF,U+2013-2014,U+2018-2019,U+201C-201D,U+2026" --flavor=woff2 --output-file=landing/fonts/nunito-400-latin.woff2
pyftsubset app/assets/fonts/nunito/Nunito-Bold.ttf --unicodes="U+0020-007E,U+00A0-00FF,U+2013-2014,U+2018-2019,U+201C-201D,U+2026" --flavor=woff2 --output-file=landing/fonts/nunito-700-latin.woff2
```
| Archivo | Bytes | SHA-256 |
|---|---|---|
| `nunito-400-latin.woff2` | 13 200 | `117502c8a30d28bec3fdebf04a6375e2cc6f1f43410bbaba55a5ac5af355dc2c` |
| `nunito-700-latin.woff2` | 13 144 | `af6534af220df798e5d1bef74283cfc989d5d516de268e61cd550ed1665f1710` |

## Textos legales: vigentes (versión 1.0)
- `/privacidad/` y `/eliminar-cuenta/` están en `data-estado="vigente"` (versión `1.0`, 5 de noviembre de 2026), sin aviso de borrador y sin `noindex`. Ya se puede dar la URL de `/privacidad/` a Google Play cuando el sitio esté publicado y la revisión legal esté hecha.
- Solo afirman lo que dicen las specs aprobadas: celular cifrado con huella para buscarlo (backend 009 R-07 y 015), consentimientos de aviso y términos con versión, fecha y dispositivo (015 R-04), sesiones (015), perfil (017), ubicación como permiso opcional con código postal como alternativa (frontend 012), fotos con moderación, enlaces de 5 minutos y sin metadatos de ubicación (013), región West US de Azure (backend 003 R-09), notificaciones (012) y sitio sin cookies ni analítica.
- Los demás datos salen del diseño del proyecto (`docs/descripcion-del-proyecto.md`, `docs/DECISION_TECNICA.md`, HU-006 y HU-055) y de valores típicos de un proyecto escolar mexicano (plazo de respuesta de 20 días hábiles, registros de 30 días, edad mínima de 18 años). El responsable y su contacto son los que dio José el 5 de noviembre de 2026: José Julián Hernández Hernández, Alonso de Borja 92, colonia Aviación, C.P. 42506, Actopan, Hidalgo, y `soporte@tdevs.com.mx`. El correo va como texto: un `mailto:` contaría como enlace externo en las pruebas.
- Pendiente fuera de este cambio: confirmar el domicilio, que una persona con criterio legal revise los textos, y que la aplicación cumpla lo que prometen (eliminar con «ELIMINAR» o código SMS en 7 días, descarga de datos y fotos de verificación destruidas a los 7 días). Si cambia algo, se sube `data-version`, la versión visible y el `<time>` en el mismo PR.
- `test_legal_y_enlaces.py` exige el estado vigente: sin marcadores `POR CONFIRMAR`, sin aviso de borrador, sin `noindex`, versión `1.0`, el responsable y el único correo de contacto.

## Versión de la landing (spec 004, R-05)
La versión vive en el pie de `index.html` como `landing-vX.Y.Z` (hoy `landing-v1.0.0`, valor inicial). La regla de puntos y la etiqueta de Git `landing-vX.Y.Z` las rige la spec 011 y `docs/VERSIONAMIENTO.md`; aquí no se define otra regla.

## CI (spec 004, R-04 y CA-03)
El job `landing` de `.github/workflows/ci-pr.yml` corre en cada PR: pruebas de `landing/tests`, `python landing/tests/check_links.py landing` (falla con un enlace roto, un ancla inexistente o un enlace externo que no sea la URL de Google Play) y Gitleaks sobre `landing/` (CLI fijada por versión y suma de verificación). Local: `python landing/tests/check_links.py landing`.

## Railway (lo configura el líder)
- Servicio en el proyecto del líder conectado a `knock-frontend` con la app de GitHub de Railway limitada a ese repositorio y de solo lectura; sin tokens, deploy keys ni secretos.
- Root Directory `landing`, builder Dockerfile, rutas vigiladas `landing/**`. `railway.json` lleva esa configuración, la ruta de salud `/` y una réplica; Railway no aplica el Root Directory al archivo de configuración, así que puede hacer falta indicarlo como `/landing/railway.json`.
- Dominio `*.up.railway.app` con puerto destino 8080, límite de memoria bajo (p. ej. 128 MB), ninguna variable de entorno, «Wait for CI» y el límite de uso de la cuenta.
- Pasos manuales de José (no los hace ningún agente ni el repositorio): 1) en Railway, con su cuenta personal, crear un proyecto y un servicio desde el repositorio `Tensei-Devs/knock-frontend` (app de GitHub de Railway limitada a ese repositorio, solo lectura); 2) Root Directory `landing`, builder Dockerfile; 3) Settings → Networking → generar el dominio `*.up.railway.app` con puerto destino 8080; 4) rama de despliegue (ver abajo) y activar «Wait for CI»; 5) límite de memoria bajo y límite de uso de la cuenta; 6) sin variables de entorno ni tokens; 7) con la URL publicada, comprobar CA-01 (fusionar un cambio y ver que se despliega) y CA-02 (`curl -sSI http://<dominio>/` devuelve 301 o 308 con `Location: https://...`) y anotar la fila en `docs/VERSIONES_DESPLEGADAS.md`; 8) pegar `https://<dominio>/privacidad/` en Play Console solo cuando el texto esté vigente.
- Rama: `develop` de forma temporal (excepción a la constitución §9, en `Memoria.md`); pasa a `main` en la primera promoción.
- Con la URL publicada se corren TC-04, 06, 07, 08 y 09 de la spec y se anota la fila en `docs/VERSIONES_DESPLEGADAS.md`.

## Plan B
La imagen es portátil: corre igual en cualquier hosting de contenedores. También sirven los mismos archivos en un hosting estático que permita cabeceras propias (p. ej. Azure Static Web Apps con `staticwebapp.config.json`; confirmar). GitHub Pages solo como último recurso, porque no permite cabeceras. Cambiar de URL obliga a actualizarla en Play Console y en la app.
