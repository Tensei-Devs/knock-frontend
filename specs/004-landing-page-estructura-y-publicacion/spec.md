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
- **R-08:** Cada página tiene un único interruptor de tema (pista y perilla con un sol y una luna dibujados en SVG, de al menos 44 px de alto) hecho solo con dos enlaces de ancla y CSS (`:target`), sin JavaScript, `<input>`, `<button>` ni formularios: solo se ve el enlace que cambia al otro tema («Cambiar a modo oscuro» o «Cambiar a modo claro», con `aria-label`); sin elegir, se sigue el tema del sistema. La elección no se recuerda entre páginas.
- **R-07:** Las animaciones son solo de CSS, no hacen falta para entender la página y se apagan cuando la persona pide movimiento reducido (`prefers-reduced-motion`).
- **R-09:** La página principal muestra un mosaico de 22 fotos de personas reales recibiendo a un técnico (22 archivos WebP propios en `landing/img/`, cada foto de 24 KB como máximo y todas juntas de 215 KB como máximo, con el atributo `alt` —descriptivo en unas pocas y vacío en las decorativas—, `width` y `height` y sin texto dentro de las imágenes), compuesto solo con CSS en un panel que ocupa la mitad derecha de la pantalla de arriba a abajo y lo cubre por completo, con fotos que sobresalen de los bordes y se ven parciales, sobre una capa de respaldo con las mismas fotos veladas (en celular, una franja inferior a todo lo ancho con una versión reducida de nueve fotos; el texto, el encabezado y el pie quedan en la mitad izquierda) y escala con el panel sin deformar las fotos (recortes con tamaños, giros y capas distintos, cinta y adornos decorativos con `aria-hidden`), con la leyenda «Tu técnico de confianza, a tu puerta» escrita en HTML. El pie enlaza a las redes del proyecto con un ícono SVG propio de al menos 44 px cada una: Instagram (`https://www.instagram.com/knock.mx/`), TikTok (`https://www.tiktok.com/@knockmx`), X (`https://x.com/knock_mx`) y Facebook (`https://www.facebook.com/share/1C3PA8XoUb/`), todas con `rel="noopener noreferrer"`. El peso total de la página (HTML, CSS, fuentes e imágenes) es de 300 KB como máximo. Google Analytics queda fuera por ahora: la spec y la política de contenido (`default-src 'none'`) prohíben scripts y recursos de terceros, y su adopción se decide aparte.

## 4. Criterios de aceptación
- **CA-01:** Dado un cambio fusionado en la rama principal, cuando termina el proceso, entonces la landing se publica.
- **CA-02:** Dada la landing publicada, cuando se pide por HTTP, entonces redirige a HTTPS.
- **CA-03:** Dado un enlace roto, cuando corre el proceso, entonces falla.
- **CA-04:** Dada la página principal, cuando se abre en 1920×1080, 1366×768, 390×844, 360×640, 320×568 y 844×390, entonces no hace scroll. (comando)
- **CA-05:** Dado un navegador con movimiento reducido, cuando se abre la página, entonces ningún elemento se anima.
- **CA-06:** Dada la página principal, cuando se revisa su HTML, entonces tiene exactamente las 22 `<img>` del mosaico (`/img/h6-*.webp` a `/img/h9-*.webp`, una por archivo de `landing/img/`), cada una con el atributo `alt` (al menos cuatro con texto descriptivo y las demás vacías), `width`, `height` y `decoding="async"` y sin `loading="lazy"`, dentro de un panel (`.moodboard`) que en escritorio ocupa la mitad derecha de borde a borde y en celular la parte inferior, y el mosaico cubre el panel sin huecos; los archivos son WebP reales de 24 KB como máximo cada uno (215 KB como máximo en conjunto), los adornos son SVG con `aria-hidden="true"` y sin texto, la leyenda está como texto HTML, no hay `<script>`, `<input>`, `<form>`, `<iframe>` ni `style=""`, el peso total no pasa de 300 KB, y los únicos enlaces a redes sociales son los de Instagram, TikTok, X y Facebook con la URL exacta, `rel` con `noopener` y `noreferrer`, nombre accesible («Instagram de Knock», «TikTok de Knock», «X de Knock», «Facebook de Knock») e ícono SVG `aria-hidden`. (comando)

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
