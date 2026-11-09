# Publicación de la app en Google Play

> Spec 007 (R-05 y R-06) y spec 011 (versionCode). Workflow: `.github/workflows/publish-android.yml`. Aquí está lo que una persona tiene que preparar y lo que el workflow no hace por sí solo.

## 1. Qué hace el workflow
1. Corre solo sobre `main`, cuando `ci-pr` terminó en verde para ese commit (o a mano, desde `main`).
2. Calcula la versión de `app/pubspec.yaml` (`X.Y.Z`), el número de subida `n` (cuántas etiquetas `app-vX.Y.Z-nK` existen) y el `versionCode` = `X × 1 000 000 + Y × 10 000 + Z × 100 + n` (`scripts/ci/publish_info.py`).
3. Construye el paquete (AAB) firmado con la llave de subida y comprueba que **no** quedó firmado con la llave de depuración.
4. Lo sube a la pista **interna** de Google Play con la API oficial (acción `r0adkll/upload-google-play`, fijada por SHA).
5. Crea la etiqueta `app-vX.Y.Z-nN`; así la siguiente subida de esa versión lleva un `versionCode` mayor (Google Play rechaza uno repetido).

No usa Azure ni `az acr build`: ACR Tasks no está permitido en la suscripción del proyecto.

## 2. Lo que prepara una persona (una sola vez)
Crear en **Settings → Secrets and variables → Actions** del repositorio `knock-frontend`:

| Secreto | Qué es |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | El archivo de la llave de subida (`.jks`) en Base64 |
| `ANDROID_KEYSTORE_PASSWORD` | Contraseña del almacén de llaves |
| `ANDROID_KEY_ALIAS` | Alias de la llave |
| `ANDROID_KEY_PASSWORD` | Contraseña de la llave |
| `PLAY_SERVICE_ACCOUNT_JSON` | JSON de una cuenta de servicio con permiso de publicar en Play Console |
| `MAPS_API_KEY` | Clave de Maps SDK for Android (la misma de `local.properties`) |
| `GOOGLE_SERVICES_JSON` | Contenido del `google-services.json` de la app Android `app.knock.mobile` (consola de Firebase). Sin él la entrada por SMS no funciona en la tienda |

Además, una **variable** (no secreto) en **Settings → Secrets and variables → Actions → Variables**: `KNOCK_API_URL`, la URL `https` del gateway. Sin ella la app compilada no llama a la API.

Una forma de generar la llave de subida y el Base64: `keytool -genkeypair -v -keystore knock-upload.jks -alias knock -keyalg RSA -keysize 2048 -validity 10000` y, en PowerShell, `[Convert]::ToBase64String([IO.File]::ReadAllBytes("knock-upload.jks"))`. **Guarda el `.jks` y sus contraseñas fuera del repositorio** (gestor de contraseñas): si se pierden no se puede actualizar la app. Nada de esto se pega en un chat ni en un PR. Activa **Play App Signing** en la consola y registra esta llave como llave de subida.

Sin los cinco primeros secretos, `GOOGLE_SERVICES_JSON` o la variable `KNOCK_API_URL`, el workflow falla antes de construir, con un mensaje que dice cuáles faltan; nunca publica con la llave de depuración. Las huellas SHA-1 y SHA-256 de la llave de subida y de la firma de Play deben estar registradas en la app de Firebase para que Phone Auth funcione.

## 3. Etapas (R-06)
| Etapa | Cómo se llega | Quién |
|---|---|---|
| **Pista interna** | Automático: cada fusión a `main` con el CI en verde (o ejecución manual desde `main`) | El workflow |
| **Prueba cerrada** | Promover la versión desde Play Console, con **al menos 12 testers durante 14 días seguidos** | Una persona, a mano |
| **Producción** | Promover desde Play Console después de la prueba cerrada y de revisar los problemas que reporte | Una persona, a mano |

El workflow no promueve de una pista a otra a propósito: Google Play exige la prueba cerrada para cuentas nuevas, y producción debe ser una decisión humana.

## 4. Checks obligatorios del CI (T-05)
El check requerido en la protección de rama es **`gate`** (`docs/BRANCH_PROTECTION.md`). Pasa solo si cada job de la lista terminó en `success` o `skipped` (no aplicaba), y un job fallido lo hace fallar (CA-01):

`detect` · `pr-meta` · `pr-points` · `governance` · `contract` · `app` · `panel` · `sast` · `sca` · `secrets` · `landing`

- `app` solo corre si el PR toca `app/` o `contracts/`; `panel`, si toca `panel/` o `contracts/` (`scripts/ci/detect_changes.py`, CA-02).
- `secrets` (Gitleaks) y `sca` (revisión de dependencias, licencias y OSV-Scanner) corren en todos los PR (R-03).
- Las acciones de terceros van fijadas por SHA y cada job declara sus permisos (R-04); `governance` lo comprueba con `scripts/ci/pin_actions.py --check`.

## 5. Primera publicación (humo, CA-03)
Cuando existan la cuenta de Google Play y los secretos: **Actions → publish-android → Run workflow** sobre `main`. Debe terminar en verde y la versión debe aparecer en **Play Console → Pruebas → Pruebas internas**. Anota la fila en `docs/VERSIONES_PUBLICADAS.md`. La app tiene que estar creada en Play Console con el nombre de paquete `app.knock.mobile`; si todavía está en borrador, la subida a la pista interna puede exigir `status: draft` en el workflow.
