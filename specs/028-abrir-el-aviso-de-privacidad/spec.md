# Spec 028 — Abrir el aviso de privacidad desde la entrada con celular

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Jira:** KNOCK-260 (parte del aviso de KNOCK-169) · **Capas:** Mobile · **Otra parte en:** landing (spec 004, ruta `/privacidad/`, ya publicada)
> **Relacionada con:** specs 004, 009 y 012 de este repositorio; KNOCK-169 (permisos del teléfono, que queda fuera).

## 1. Objetivo
En la pantalla «Entra con tu celular», la casilla dice «Acepto el aviso de privacidad» y el aviso tiene aspecto de enlace, pero al tocarlo no pasa nada. La persona no puede leer el aviso antes de aceptarlo, y la tienda de aplicaciones espera que la política de privacidad sea accesible desde dentro de la app. Esta spec hace que el aviso abra la página `/privacidad/` de la landing en el navegador del teléfono, sin cambiar el resto del flujo de entrada.

## 2. Alcance
**Dentro**
- Abrir la página de privacidad de la landing en el navegador externo al tocar el texto del aviso en la pantalla de entrada.
- Una única constante con la dirección del aviso, con valor por defecto (la página publicada) y sustituible al compilar.
- Aviso a la persona, sin cerrar la pantalla ni perder lo escrito, si el teléfono no puede abrir la página.
- Declarar en la app lo necesario para que Android permita abrir enlaces `https`.
- Una dependencia nueva de Flutter para abrir enlaces, evaluada y registrada en `Memoria.md`.

**Fuera**
- El texto legal del aviso y la página de la landing (spec 004).
- Los permisos del teléfono (ubicación, cámara, notificaciones) y sus avisos previos: siguen en KNOCK-169 y en la spec 012.
- Mostrar el aviso dentro de la app (vista web embebida o pantalla propia) y el enlace «Eliminar mi cuenta».
- Cambios de diseño, de rutas y de textos distintos de los que pide esta spec.

## 3. Requisitos
- **R-01:** Tocar el texto «aviso de privacidad» de la casilla abre en el navegador la dirección del aviso. Tocar el resto de la fila sigue marcando o desmarcando la casilla, y tocar el aviso **no** cambia el estado de la casilla.
- **R-02:** La dirección del aviso es `https://knock-frontend-production.up.railway.app/privacidad/` y vive en una sola constante. Puede sustituirse al compilar con una variable (`KNOCK_PRIVACY_URL`). Solo se aceptan direcciones `https`; cualquier otra se ignora y se usa la de por defecto.
- **R-03:** Si no se puede abrir la página (sin navegador, o el sistema rechaza la apertura), la pantalla muestra un mensaje breve que dice que no se pudo abrir el aviso y no cierra la pantalla, no borra el celular escrito ni cambia la casilla.
- **R-04:** El enlace se abre fuera de la app, en el navegador externo, y la app no envía datos de la persona en la dirección (sin celular, sin identificadores).
- **R-05:** El aviso tiene área táctil de al menos 48 dp, descripción semántica de enlace para lectores de pantalla y funciona con el texto al 200 %.
- **R-06:** El comportamiento es el mismo en español y en inglés; los textos nuevos están en los archivos ARB de ambos idiomas.
- **R-07:** El AndroidManifest declara la consulta de `https` para que Android 11 o posterior permita abrir enlaces. No se piden permisos nuevos al teléfono.
- **R-08:** Se agrega una sola dependencia (`url_launcher`) con licencia permitida y sin vulnerabilidades conocidas, y queda registrada con su motivo en `Memoria.md`.

## 4. Criterios de aceptación

- **CA-01:** Dada la pantalla de entrada, cuando toco el texto «aviso de privacidad», entonces se solicita abrir la dirección del aviso en el navegador externo. *Verificación: Prueba de widget con un abridor de enlaces falso.*
- **CA-02:** Dada la casilla sin marcar, cuando toco el aviso, entonces la casilla sigue sin marcar; y cuando toco otra parte de la fila, entonces se marca. *Verificación: Prueba de widget.*
- **CA-03:** Dada la constante por defecto, cuando se lee, entonces es la dirección `https` de la landing; y si se sustituye por una dirección que no es `https`, entonces se usa la de por defecto. *Verificación: Prueba unitaria.*
- **CA-04:** Dado que el sistema no puede abrir la página, cuando toco el aviso, entonces aparece un mensaje y la pantalla conserva el celular escrito y el estado de la casilla. *Verificación: Prueba de widget con un abridor que falla.*
- **CA-05:** Dada la dirección que se abre, cuando se inspecciona, entonces no contiene celular, token ni identificador de la persona. *Verificación: Prueba unitaria.*
- **CA-06:** Dado el aviso, cuando se mide su área táctil y su semántica, entonces mide al menos 48 dp y se anuncia como enlace. *Verificación: Prueba de widget (guía de accesibilidad y semántica).*
- **CA-07:** Dado el texto al 200 %, cuando se muestra la pantalla de entrada, entonces el aviso no se corta ni se desborda. *Verificación: Prueba de widget.*
- **CA-08:** Dados los idiomas español e inglés, cuando se muestra el mensaje de error, entonces aparece en el idioma activo. *Verificación: Prueba de widget.*
- **CA-09:** Dado el AndroidManifest, cuando se revisa, entonces declara la consulta de `https` y no agrega permisos nuevos. *Verificación: Prueba de archivo (comando).*
- **CA-10:** Dado el teléfono con la app instalada, cuando toco el aviso, entonces se abre la página de privacidad publicada. *Verificación: Humo manual en teléfono, con evidencia.*

## 5. Contrato consumido
No consume la API. Abre una página estática de la landing:

| Elemento | Valor |
|---|---|
| Ruta | `/privacidad/` de la landing (spec 004), publicada y disponible |
| Dirección por defecto | `https://knock-frontend-production.up.railway.app/privacidad/` |
| Cómo se abre | Navegador externo del teléfono, con la dirección tal cual, sin parámetros |

## 6. Modelo de datos local
No aplica: no se guarda nada en el teléfono.

## 7. Arquitectura
- La constante de la dirección y su validación (`https`) van en `core/config`, junto a las demás configuraciones de compilación.
- Un abridor de enlaces pequeño (`AbridorDeEnlaces`) en `core/` envuelve `url_launcher`, para poder sustituirlo por uno falso en las pruebas; el resto de la app no importa el paquete directamente.
- La pantalla de entrada (`features/entrada`) recibe el abridor por su proveedor de Riverpod y lo llama desde el texto del aviso, con un reconocedor de toques en el fragmento de texto.
- Sin rutas nuevas, sin cambios de estado de sesión y sin cambios en `contracts/` ni en `app/packages/knock_api`.

## 8. Amenazas y controles
| Amenaza | Control | Caso que lo prueba |
|---|---|---|
| Abrir una dirección distinta de la prevista (sustituida al compilar) | Solo `https`; cualquier otra se ignora y se usa la de por defecto | CA-03 |
| Fuga de datos de la persona en la dirección | La dirección no lleva celular, token ni identificadores | CA-05 |
| Pantalla que se queda bloqueada o pierde lo escrito si falla la apertura | Error breve, sin cerrar ni borrar | CA-04 |
| Aceptación involuntaria del aviso por tocar el enlace | Tocar el aviso no cambia la casilla | CA-02 |
| Dependencia vulnerable o con licencia no permitida | Evaluación previa, registro en `Memoria.md` y análisis de dependencias del CI | CA-09 y CI |
| Apertura dentro de la app con acceso a su almacenamiento | Se abre en el navegador externo, no en una vista embebida | CA-01, CA-10 |

## 9. Plan de pruebas
Las pruebas citan el caso como `CA-028-NN` en el nombre (para `python scripts/sdd_lint.py --trace 028`).

| Tipo | ¿Aplica? | Qué se prueba / herramienta |
|---|---|---|
| Unitarias | Sí | Validación de la dirección y su valor por defecto (CA-03), dirección sin datos de la persona (CA-05) |
| Widget / componente | Sí | Toque en el aviso, casilla, error de apertura, accesibilidad, texto al 200 % e idiomas (CA-01, CA-02, CA-04, CA-06 a CA-08) |
| Seguridad negativa | Sí | Direcciones no `https` y datos en la dirección (CA-03, CA-05) |
| Archivo / comando | Sí | AndroidManifest con la consulta `https` y sin permisos nuevos (CA-09) |
| Integración / extremo a extremo | No aplica | No hay flujo de red propio; se cubre con el humo manual de CA-10 |
| Contrato | No aplica | No consume la API |
| Humo manual | Sí | Teléfono con la app instalada desde la tienda (CA-10), con captura en el PR |
| Puertas de CI | Sí | `flutter analyze` sin advertencias, `dart format`, `flutter test`, `sdd_lint --trace 028`, mapa de arquitectura, análisis de dependencias y Semgrep |

## 10. Definición de terminado
- Los criterios de aceptación están cubiertos por pruebas en verde (CA-10 con evidencia manual).
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día, con la dependencia nueva registrada.
- No se tocaron `contracts/`, `app/packages/knock_api/` ni `.github/`.
- Sale en una versión nueva de la app (la 1.0.1 ya preparada).

## 11. Decisiones tomadas sin consulta
- **D-01:** Se abre en el navegador externo y no en una vista embebida: es lo más simple y no da a la página acceso a la app. Alternativa descartada: pantalla propia con el texto del aviso (obliga a duplicar el texto legal).
- **D-02:** La dirección por defecto es la de la landing publicada hoy; si cambia el dominio, basta sustituirla al compilar sin tocar el código.
- **D-03:** Solo el texto del aviso es tocable; el resto de la fila sigue marcando la casilla.

## 12. Riesgos y dudas abiertas
- La página de la landing debe seguir disponible; si cambia de dirección hay que publicar una versión nueva o compilar con la variable.
- Algunos teléfonos sin navegador instalado no podrán abrirla; por eso existe el mensaje de R-03.

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-11
- [x] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
