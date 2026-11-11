# Spec 004 — Landing page: estructura y publicación

> **Estado:** Aprobada · **Jira:** KNOCK-218, KNOCK-258 · **Repositorio:** knock-frontend · **Rector:** `constitution.md`

## 1. Objetivo
Definir cómo está hecha y dónde se publica la landing page, sin escribir su contenido.

## 2. Alcance
**Dentro**
- Sitio estático con HTML y CSS.
- Hosting con HTTPS y publicación automática desde la rama principal.
- Cabeceras de seguridad y política de contenido.
- Rutas reservadas para el aviso de privacidad y la eliminación de cuenta.
- Diseño visual de la página principal: una sola pantalla y animaciones solo con CSS (KNOCK-258).

**Fuera**
- Texto del aviso de privacidad.
- Analítica.

## 3. Requisitos
- **R-01:** La landing es un sitio estático sin servidor propio ni JavaScript innecesario.
- **R-02:** Se publica con HTTPS obligatorio y cada cambio aprobado en la rama principal se publica solo.
- **R-03:** El servidor envía una política de seguridad de contenido y las cabeceras de seguridad habituales.
- **R-04:** El proceso de publicación revisa enlaces rotos y busca claves olvidadas.
- **R-05:** La landing lleva su propia versión.
- **R-06:** La página principal (`/`) cabe en una sola pantalla, sin scroll, en escritorio y en celular (vertical y horizontal) con el tamaño de texto normal; lo decorativo se reduce o se oculta antes que el contenido o los enlaces.
- **R-08:** Cada página tiene un selector de tema «Claro / Oscuro» hecho solo con enlaces de ancla y CSS (`:target`), sin JavaScript ni formularios; sin elegir, se sigue el tema del sistema. La elección no se recuerda entre páginas.
- **R-07:** Las animaciones son solo de CSS, no hacen falta para entender la página y se apagan cuando la persona pide movimiento reducido (`prefers-reduced-motion`).
- **R-09:** La página principal muestra una imagen con personas reales sonriendo (`landing/img/hero.webp`, archivo propio, menos de 80 KB, con texto alternativo y sin texto dentro de la imagen) con la leyenda «Tu técnico de confianza, a tu puerta» escrita en HTML, y enlaza a las redes sociales del proyecto con un ícono SVG de al menos 44 px. Hoy solo está Instagram (`https://www.instagram.com/knock.mx/`, con `rel="noopener noreferrer"`); las demás redes se agregan cuando existan sus direcciones oficiales. Google Analytics queda fuera por ahora: la spec y la política de contenido (`default-src 'none'`) prohíben scripts y recursos de terceros, y su adopción se decide aparte.

## 4. Criterios de aceptación
- **CA-01:** Dado un cambio fusionado en la rama principal, cuando termina el proceso, entonces la landing se publica.
- **CA-02:** Dada la landing publicada, cuando se pide por HTTP, entonces redirige a HTTPS.
- **CA-03:** Dado un enlace roto, cuando corre el proceso, entonces falla.
- **CA-04:** Dada la página principal, cuando se abre en 1920×1080, 1366×768, 390×844, 360×640, 320×568 y 844×390, entonces no hace scroll. (comando)
- **CA-05:** Dado un navegador con movimiento reducido, cuando se abre la página, entonces ningún elemento se anima.
- **CA-06:** Dada la página principal, cuando se revisa su HTML, entonces tiene una sola `<img>` con `src="/img/hero.webp"`, `alt`, `width` y `height`, el archivo es un WebP de menos de 80 KB, la leyenda está como texto HTML, y el único enlace a redes sociales es el de Instagram con la URL exacta, `rel` con `noopener` y `noreferrer` y nombre accesible «Instagram de Knock». (comando)

## 5. Contrato
No consume la API. Interfaces que fija: las rutas reservadas `/privacidad/` y `/eliminar-cuenta/`, y la URL de redirección a Google Play.

## 6. Amenazas y controles
| Amenaza | Control |
|---|---|
| Un clon de la página engaña a las personas | HTTPS con HSTS y un único enlace oficial desde la ficha de Google Play y la app |
| Inyección de contenido o terceros | Sitio estático, sin JavaScript innecesario y política de seguridad de contenido restrictiva |
| Un enlace de la página apunta a otra aplicación | El enlace a Google Play es una constante revisada en el PR |

## 7. Plan de pruebas
| Tipo | ¿Aplica? | Motivo |
|---|---|---|
| Unitarias | Sí | Revisión de enlaces y de cabeceras con scripts |
| Integración | Sí | Contenedor local con las cabeceras |
| Seguridad negativa | Sí | Cabeceras de seguridad y ausencia de recursos de terceros |
| Humo / extremo a extremo | Sí | Publicación en Railway y redirección HTTP a HTTPS |
| Accesibilidad | Sí | Contraste, títulos y enlaces con nombre, y movimiento reducido |
| Arquitectura | No | No aplica |

## 8. Decisiones
- **Railway:** el líder ya tiene un espacio contratado, no genera costo adicional y usa HTTPS; se descartó Azure Static Web Apps porque sus regiones no coinciden con las que permite la suscripción.
- **Estática:** menos superficie de ataque y costo cero.
- **Una sola pantalla y animaciones con CSS (KNOCK-258):** es la versión final de la página principal; la ilustración va como SVG incrustado para no agregar archivos ni pasar el límite de peso, y sin JavaScript para respetar la política de contenido.

## 9. Riesgos y dudas abiertas
- «Sin scroll» se mide con las seis pantallas de CA-04; en una pantalla más baja o con el texto ampliado, la página puede hacer scroll antes que recortar contenido.
- Ninguna otra duda abierta por ahora; se agregan aquí las que surjan al revisar la spec.

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-10
- [x] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
