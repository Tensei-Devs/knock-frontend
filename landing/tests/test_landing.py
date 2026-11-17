"""Comprobaciones estáticas de la landing (TT-WEB-01, KNOCK-148).

Solo biblioteca estándar y sin red. Corre desde la raíz del repositorio con
`python -m unittest discover -s landing/tests -v`. Cada método lleva el ID del
caso con guiones bajos, que es lo que busca `sdd_lint.py --trace`.
"""

import re
import unittest
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlsplit

LANDING = Path(__file__).resolve().parents[1]

URL_PLAY = (
    "https://play.google.com/store/apps/details?id=app.knock.mobile"
    "&referrer=utm_source%3Dlanding%26utm_medium%3Dweb%26utm_campaign%3Dlanding"
)
URL_BETA_WEB = "https://play.google.com/apps/testing/app.knock.mobile"
URL_BETA_ANDROID = "https://play.google.com/store/apps/details?id=app.knock.mobile"
URLS_BETA = [URL_BETA_ANDROID, URL_BETA_WEB]
URL_INSTAGRAM = "https://www.instagram.com/knock.mx/"
# Redes del proyecto, en el orden del pie: (URL exacta, nombre accesible).
REDES = (
    (URL_INSTAGRAM, "Instagram de Knock"),
    ("https://www.tiktok.com/@knockmx", "TikTok de Knock"),
    ("https://x.com/knock_mx", "X de Knock"),
    ("https://www.facebook.com/share/1C3PA8XoUb/", "Facebook de Knock"),
)
URLS_REDES = [url for url, _ in REDES]
FOTOS = (
    "h6-electricidad.webp",
    "h6-familia.webp",
    "h6-herramientas.webp",
    "h6-manos.webp",
    "h6-mecanica.webp",
    "h7-electricidad.webp",
    "h7-llegada.webp",
    "h7-manos.webp",
    "h7-mecanica.webp",
    "h7-plomeria.webp",
    "h7-telefono.webp",
    "h8-electricidad.webp",
    "h8-llegada.webp",
    "h8-manos.webp",
    "h8-mecanica.webp",
    "h8-plomeria.webp",
    "h8-telefono.webp",
    "h9-electricidad.webp",
    "h9-llegada.webp",
    "h9-manos.webp",
    "h9-plomeria.webp",
    "h9-telefono.webp",
)
TEXTO_PROXIMAMENTE = "Próximamente en Google Play"
TEXTO_ANTIPHISHING = "Knock nunca te pedirá códigos SMS ni contraseñas en esta página"
DESCRIPCION = (
    "Knock te conecta con técnicos de confianza en mecánica, plomería y "
    "electricidad, colonia por colonia."
)

CABECERAS = {
    "Content-Security-Policy": (
        "default-src 'none'; style-src 'self'; font-src 'self'; img-src 'self'; "
        "base-uri 'none'; form-action 'none'; frame-ancestors 'none'; "
        "upgrade-insecure-requests"
    ),
    "Strict-Transport-Security": "max-age=31536000",
    "X-Content-Type-Options": "nosniff",
    "X-Frame-Options": "DENY",
    "Referrer-Policy": "no-referrer",
    "Cross-Origin-Opener-Policy": "same-origin",
    "Cross-Origin-Resource-Policy": "same-origin",
    "Permissions-Policy": (
        "camera=(), microphone=(), geolocation=(), payment=(), usb=(), "
        "browsing-topics=()"
    ),
}

# Tokens de TT-MOB-02 (spec §7) y pares (texto, fondo) permitidos por tema.
CREMA, BLANCO = "#fbf5e9", "#ffffff"
INK, INK2, MUT = "#231a15", "#4a3c33", "#6b5d52"
AMBER, AMBER_INK = "#e9682d", "#8f3510"
BG, SURFACE = "#14110f", "#1e1b18"
INK_O, INK2_O, MUT_O = "#f6eee3", "#dcd0c2", "#b5a798"

PARES_CLARO = {
    (texto, fondo)
    for texto in (INK, INK2, MUT, AMBER_INK)
    for fondo in (CREMA, BLANCO)
} | {(INK, AMBER), (CREMA, INK)}
PARES_OSCURO = {
    (texto, fondo)
    for texto in (INK_O, INK2_O, MUT_O, AMBER)
    for fondo in (BG, SURFACE)
} | {(BG, AMBER), (BG, INK_O)}


class Pagina(HTMLParser):
    """Lo que las pruebas necesitan de una página HTML."""

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.etiquetas = []  # (nombre, atributos)
        self.enlaces = []  # {"attrs": ..., "texto": ...}
        self.texto = []
        self._enlace = None
        self._ignorar = 0

    def handle_starttag(self, tag, attrs):
        atributos = dict(attrs)
        self.etiquetas.append((tag, atributos))
        if tag == "a":
            self._enlace = {"attrs": atributos, "texto": ""}
            self.enlaces.append(self._enlace)
        if tag in ("title", "style", "script"):
            self._ignorar += 1

    def handle_startendtag(self, tag, attrs):
        self.etiquetas.append((tag, dict(attrs)))

    def handle_endtag(self, tag):
        if tag == "a":
            self._enlace = None
        if tag in ("title", "style", "script"):
            self._ignorar -= 1

    def handle_data(self, data):
        if self._ignorar:
            return
        self.texto.append(data)
        if self._enlace is not None:
            self._enlace["texto"] += data

    def de(self, nombre):
        return [attrs for tag, attrs in self.etiquetas if tag == nombre]

    def texto_visible(self):
        return " ".join(" ".join(self.texto).split())


def leer(ruta):
    return (LANDING / ruta).read_text(encoding="utf-8")


def analizar(html):
    pagina = Pagina()
    pagina.feed(html)
    pagina.close()
    return pagina


def es_externo(url):
    partes = urlsplit(url)
    return bool(partes.scheme or partes.netloc)


def estado_de_play(pagina):
    """Devuelve `disponible` o `proximamente`; lanza si no es uno de los dos."""
    marcados = [a["data-play"] for _, a in pagina.etiquetas if "data-play" in a]
    if len(marcados) != 1:
        raise AssertionError(f"Debe haber una sola variante de Play: {marcados}")
    enlaces_play = [
        e for e in pagina.enlaces if "play.google.com" in e["attrs"].get("href", "")
    ]
    if marcados == ["proximamente"]:
        if enlaces_play:
            raise AssertionError("«Próximamente» no lleva enlace a Google Play")
        if TEXTO_PROXIMAMENTE not in pagina.texto_visible():
            raise AssertionError(f"Falta el texto «{TEXTO_PROXIMAMENTE}»")
        return "proximamente"
    if marcados == ["disponible"]:
        if len(enlaces_play) != 1:
            raise AssertionError("«Disponible» lleva exactamente un enlace a Play")
        atributos = enlaces_play[0]["attrs"]
        if atributos["href"] != URL_PLAY:
            raise AssertionError(f"URL de Play distinta: {atributos['href']}")
        if atributos.get("target") == "_blank":
            rel = atributos.get("rel", "").split()
            if "noopener" not in rel or "noreferrer" not in rel:
                raise AssertionError('target="_blank" sin rel="noopener noreferrer"')
        return "disponible"
    if marcados == ["beta"]:
        hrefs = [e["attrs"]["href"] for e in enlaces_play]
        if hrefs != URLS_BETA:
            raise AssertionError(f"Enlaces de la beta distintos: {hrefs}")
        return "beta"
    raise AssertionError(f"Estado de Play desconocido: {marcados}")


def enlaces_externos(pagina):
    return [
        e["attrs"].get("href", "")
        for e in pagina.enlaces
        if es_externo(e["attrs"].get("href", ""))
    ]


def bloques_css(texto):
    """Reglas `selector { cuerpo }` del CSS, entrando en los `@media`."""
    sin_comentarios = re.sub(r"/\*.*?\*/", "", texto, flags=re.S)
    reglas = []
    posicion = 0
    while True:
        apertura = sin_comentarios.find("{", posicion)
        if apertura < 0:
            return reglas
        selector = sin_comentarios[posicion:apertura].strip()
        profundidad, cierre = 1, apertura + 1
        while profundidad:
            caracter = sin_comentarios[cierre]
            profundidad += {"{": 1, "}": -1}.get(caracter, 0)
            cierre += 1
        cuerpo = sin_comentarios[apertura + 1 : cierre - 1]
        if selector.startswith("@media"):
            reglas.extend(
                (f"{selector} {interior}", cuerpo_interior)
                for interior, cuerpo_interior in bloques_css(cuerpo)
            )
        else:
            reglas.append((selector, cuerpo))
        posicion = cierre


def propiedades(cuerpo):
    pares = (d.split(":", 1) for d in cuerpo.split(";") if ":" in d)
    return {nombre.strip(): valor.strip() for nombre, valor in pares}


def tokens_de_color(reglas):
    """Tokens `--color-*` resueltos para el tema claro y el oscuro."""
    claro, oscuro = {}, {}
    for selector, cuerpo in reglas:
        if selector.endswith(":root"):
            destino = oscuro if "prefers-color-scheme: dark" in selector else claro
            destino.update(
                (nombre, valor.lower())
                for nombre, valor in propiedades(cuerpo).items()
                if nombre.startswith("--color-")
            )
    return claro, {**claro, **oscuro}


def pares_declarados(reglas):
    """Pares (token de texto, token de fondo) que declara el CSS.

    Una regla con `color` y sin fondo propio se pinta sobre cada fondo que el
    CSS declara, porque el texto heredado puede caer en cualquiera de ellos.
    """
    con_color = []
    fondos = set()
    for _, cuerpo in reglas:
        declaradas = propiedades(cuerpo)
        fondo = declaradas.get("background-color")
        if fondo:
            fondos.add(fondo)
        if "color" in declaradas:
            con_color.append((declaradas["color"], fondo))
    pares = set()
    for color, fondo in con_color:
        for destino in [fondo] if fondo else fondos - {"var(--color-boton-fondo)", "var(--color-texto)"}:
            pares.add((color, destino))
    return pares


def resolver(valor, tokens):
    coincidencia = re.fullmatch(r"var\((--color-[a-z0-9-]+)\)", valor)
    if not coincidencia:
        raise AssertionError(f"Color fuera de los tokens --color-*: {valor}")
    return tokens[coincidencia.group(1)]


def luminancia(color):
    """Luminancia relativa sRGB (WCAG 2.x), como `Color.computeLuminance`."""

    def canal(valor):
        c = valor / 255
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4

    r, g, b = (int(color[i : i + 2], 16) for i in (1, 3, 5))
    return 0.2126 * canal(r) + 0.7152 * canal(g) + 0.0722 * canal(b)


def contraste(a, b):
    """Misma fórmula que `relacionDeContraste` de `contraste.dart`."""
    la, lb = luminancia(a), luminancia(b)
    return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)


def bloques_nginx(texto):
    """Devuelve `(directivas del server, {location: directivas})`."""
    limpio = re.sub(r"#.*", "", texto)
    server = re.search(r"\bserver\s*\{", limpio)
    if not server:
        raise AssertionError("nginx.conf sin bloque server")
    propias, locations, actual, cabecera, comilla = [], {}, "", None, None
    for caracter in limpio[server.end() :]:
        if comilla or caracter in "\"'":
            # Dentro de un valor entre comillas, `;` y las llaves son texto.
            if comilla is None:
                comilla = caracter
            elif caracter == comilla:
                comilla = None
            actual += caracter
        elif caracter == "{":
            cabecera, actual = " ".join(actual.split()), ""
        elif caracter == "}":
            if cabecera is None:
                break
            locations[cabecera] = _directivas(actual)
            cabecera, actual = None, ""
        elif caracter == ";" and cabecera is None:
            propias.append(" ".join(actual.split()))
            actual = ""
        else:
            actual += caracter
    return propias, locations


def _directivas(cuerpo):
    """Parte un bloque en directivas sin cortar los valores entre comillas."""
    directivas, actual, comilla = [], "", None
    for caracter in cuerpo:
        if caracter == ";" and comilla is None:
            directivas.append(" ".join(actual.split()))
            actual = ""
            continue
        if caracter in "\"'":
            if comilla is None:
                comilla = caracter
            elif caracter == comilla:
                comilla = None
        actual += caracter
    return [d for d in directivas if d]


def cabeceras_declaradas(directivas):
    return [d for d in directivas if d.startswith("add_header ")]


class ControlesDeLasAyudas(unittest.TestCase):
    """Las ayudas deben rechazar lo incorrecto, o las pruebas no valen."""

    def test_nginx_separa_server_y_location_sin_cortar_comillas(self):
        servidor, locations = bloques_nginx(
            "server { listen 8080; add_header A \"x; y\" always;\n"
            "  location /a { add_header B \"z\" always; } }"
        )
        self.assertEqual(servidor, ["listen 8080", 'add_header A "x; y" always'])
        self.assertEqual(locations, {"location /a": ['add_header B "z" always']})

    def test_contraste_con_los_valores_de_control(self):
        self.assertAlmostEqual(contraste("#000000", "#ffffff"), 21, places=6)
        self.assertAlmostEqual(contraste("#e9682d", "#e9682d"), 1, places=6)

    def test_play_disponible_correcto_y_manipulado(self):
        plantilla = '<p data-play="disponible"><a href="{}">Descargar</a></p>'
        self.assertEqual(
            estado_de_play(analizar(plantilla.format(URL_PLAY.replace("&", "&amp;")))),
            "disponible",
        )
        otra_app = URL_PLAY.replace("app.knock.mobile", "app.falsa.mobile")
        with self.assertRaises(AssertionError):
            estado_de_play(analizar(plantilla.format(otra_app.replace("&", "&amp;"))))

    def test_play_no_acepta_las_dos_variantes_ni_blank_sin_rel(self):
        dos = '<p data-play="disponible"></p><p data-play="proximamente"></p>'
        with self.assertRaises(AssertionError):
            estado_de_play(analizar(dos))
        blank = (
            '<p data-play="disponible"><a target="_blank" href="'
            + URL_PLAY.replace("&", "&amp;")
            + '">Descargar</a></p>'
        )
        with self.assertRaises(AssertionError):
            estado_de_play(analizar(blank))


class Landing(unittest.TestCase):
    def test_TC_TT_WEB_01_01_dockerfile(self):
        dockerfile = leer("Dockerfile")
        instrucciones = [
            linea.strip()
            for linea in dockerfile.splitlines()
            if linea.strip() and not linea.strip().startswith("#")
        ]
        desde = [i for i in instrucciones if i.upper().startswith("FROM ")]
        self.assertEqual(len(desde), 1, "Una sola imagen base")
        self.assertRegex(
            desde[0],
            r"^FROM nginxinc/nginx-unprivileged:\d+\.\d+\.\d+-alpine"
            r"@sha256:[0-9a-f]{64}$",
        )
        usuarios = [i.split()[1] for i in instrucciones if i.upper().startswith("USER ")]
        self.assertTrue(usuarios, "Debe declarar USER")
        self.assertNotIn(usuarios[-1].split(":")[0], ("root", "0"))
        self.assertIn("EXPOSE 8080", instrucciones)
        self.assertRegex(leer("nginx.conf"), r"listen\s+8080;")

        for instruccion in instrucciones:
            palabra = instruccion.split()[0].upper()
            self.assertNotIn(palabra, ("ENV", "ARG"), "La imagen no necesita variables")
            if palabra in ("COPY", "ADD"):
                origenes = [p for p in instruccion.split()[1:-1] if not p.startswith("--")]
                for origen in origenes:
                    self.assertIn(
                        origen,
                        ("index.html", "404.html", "css", "fonts", "img", "privacidad", "eliminar-cuenta", "nginx.conf"),
                        "Solo se copian los archivos públicos",
                    )

    def test_TC_TT_WEB_01_02_enlaces(self):
        pagina = analizar(leer("index.html"))
        texto = pagina.texto_visible()

        self.assertIn("Knock", texto)
        self.assertIn(DESCRIPCION, texto)
        self.assertRegex(texto, r"landing-v\d+\.\d+\.\d+")
        self.assertIn(TEXTO_ANTIPHISHING, texto)
        estado = estado_de_play(pagina)
        self.assertIn(estado, ("disponible", "proximamente", "beta"))

        privacidad = [e for e in pagina.enlaces if e["attrs"].get("href") == "/privacidad/"]
        self.assertTrue(privacidad, "Falta el enlace a /privacidad/")
        self.assertTrue(all(e["texto"].strip() == "Aviso de privacidad" for e in privacidad))

        permitidos = {"disponible": [URL_PLAY], "beta": URLS_BETA}.get(estado, [])
        self.assertEqual(enlaces_externos(pagina), permitidos + URLS_REDES)

    def test_TC_TT_WEB_01_03_privacidad(self):
        html = leer("privacidad/index.html")
        pagina = analizar(html)
        marcador = [a for _, a in pagina.etiquetas if a.get("data-estado") == "en-preparacion"]
        if not marcador:
            self.skipTest("Contenido de TT-WEB-02: lo prueba esa spec")

        self.assertIn(
            {"name": "robots", "content": "noindex"}, pagina.de("meta"), "Falta noindex"
        )
        self.assertEqual(pagina.de("script"), [])
        self.assertEqual(enlaces_externos(pagina), [])
        self.assertTrue(
            any(
                e["attrs"].get("href") == "/" and e["texto"].strip() == "Volver al inicio"
                for e in pagina.enlaces
            ),
            "Falta el enlace de regreso",
        )
        self.assertIn("Aviso de privacidad", pagina.texto_visible())
        self.assertIn("Estamos preparando el aviso de privacidad", pagina.texto_visible())
        for palabra in ("responsable", "finalidades", "arco"):
            self.assertNotRegex(pagina.texto_visible().lower(), rf"\b{palabra}\b")

    def test_TC_TT_WEB_01_04_cabeceras(self):
        conf = leer("nginx.conf")
        servidor, locations = bloques_nginx(conf)

        esperadas = {f"add_header {n} \"{v}\" always" for n, v in CABECERAS.items()}
        self.assertEqual(set(cabeceras_declaradas(servidor)), esperadas)
        self.assertIn("server_tokens off", servidor)
        self.assertIn("autoindex off", servidor)
        self.assertTrue(
            any(d.startswith("error_page") and "/404.html" in d for d in servidor),
            "Falta el 404 propio",
        )
        for nombre, directivas in locations.items():
            propias = cabeceras_declaradas(directivas)
            if propias:
                self.assertTrue(
                    esperadas <= set(propias),
                    f"add_header en «{nombre}» anula las cabeceras del servidor",
                )
            self.assertTrue(all(c.endswith(" always") for c in propias), nombre)

        self.assertIn("return 204", locations["location = /favicon.ico"])
        self.assertNotRegex(conf, r"(?i)set-cookie|\$arg_|\$query_string|\brewrite\b")
        self.assertTrue(leer("404.html"))

    def test_TC_TT_WEB_01_05_sin_terceros(self):
        for nombre in ("index.html", "404.html"):
            html = leer(nombre)
            pagina = analizar(html)
            for prohibida in ("script", "style", "form", "input", "iframe"):
                self.assertEqual(pagina.de(prohibida), [], f"<{prohibida}> en {nombre}")
            for tag, atributos in pagina.etiquetas:
                self.assertNotIn("style", atributos, f"style en <{tag}> de {nombre}")
                manejadores = [a for a in atributos if a.startswith("on")]
                self.assertEqual(manejadores, [], f"Manejadores en <{tag}> de {nombre}")
                recurso = atributos.get("src") or (
                    atributos.get("href") if tag != "a" else None
                )
                if recurso:
                    self.assertFalse(es_externo(recurso), f"{recurso} en {nombre}")
            externos = enlaces_externos(pagina)
            self.assertTrue(
                set(externos) <= {URL_PLAY, *URLS_BETA, *URLS_REDES}, f"{externos} en {nombre}"
            )

        hojas = sorted((LANDING / "css").glob("*.css"))
        self.assertTrue(hojas, "Falta el CSS")
        for hoja in hojas:
            css = hoja.read_text(encoding="utf-8")
            self.assertNotRegex(css, r"(?i)https?:|//[a-z0-9.-]+\.[a-z]{2,}")
            self.assertNotIn("@import", css)
            for url in re.findall(r"url\(\s*['\"]?([^'\")]+)", css):
                self.assertTrue(url.startswith("/") and not url.startswith("//"), url)

    def test_TC_TT_WEB_01_06_accesibilidad(self):
        for nombre in ("index.html", "404.html"):
            pagina = analizar(leer(nombre))
            self.assertEqual(pagina.de("html")[0].get("lang"), "es-MX", nombre)
            self.assertEqual(len(pagina.de("h1")), 1, nombre)
            for region in ("header", "main", "footer"):
                self.assertEqual(len(pagina.de(region)), 1, f"<{region}> en {nombre}")
            for enlace in pagina.enlaces:
                nombre_accesible = enlace["texto"].strip() or enlace["attrs"].get("aria-label", "").strip()
                self.assertTrue(nombre_accesible, f"Enlace sin nombre en {nombre}")
            for imagen in pagina.de("img"):
                self.assertIn("alt", imagen, f"<img> sin alt en {nombre}")
            viewport = [m for m in pagina.de("meta") if m.get("name") == "viewport"]
            self.assertEqual(len(viewport), 1, nombre)
            self.assertNotRegex(viewport[0]["content"], r"user-scalable|maximum-scale")

        css = leer("css/landing.css")
        reglas = bloques_css(css)
        claro, oscuro = tokens_de_color(reglas)
        self.assertTrue(claro, "Sin tokens --color-*")
        self.assertIn("@media (prefers-color-scheme: dark)", css)
        pares = pares_declarados(reglas)
        self.assertTrue(pares, "El CSS no declara pares de texto y fondo")

        for tema, tokens, permitidos in (
            ("claro", claro, PARES_CLARO),
            ("oscuro", oscuro, PARES_OSCURO),
        ):
            for color, fondo in pares:
                par = (resolver(color, tokens), resolver(fondo, tokens))
                self.assertIn(par, permitidos, f"Par no permitido en {tema}: {color}/{fondo}")
                self.assertGreaterEqual(contraste(*par), 4.5, f"{tema}: {par}")

        self.assertEqual(oscuro["--color-foco"], AMBER)
        self.assertEqual(claro["--color-foco"], AMBER_INK)
        foco = [c for s, c in reglas if ":focus-visible" in s]
        self.assertTrue(foco, "Sin estilo de foco")
        self.assertRegex(foco[0], r"outline:\s*2px solid var\(--color-foco\)")
        self.assertNotRegex(css, r"outline:\s*(none|0)\b")
        enlaces_css = [c for s, c in reglas if re.search(r"(^|,\s*)a\b", s)]
        self.assertTrue(any("underline" in c for c in enlaces_css), "Enlaces sin subrayado")

    def test_TC_TT_WEB_01_09_peso(self):
        html = leer("index.html")
        pagina = analizar(html)
        hojas = [
            enlace["href"] for enlace in pagina.de("link") if enlace.get("rel") == "stylesheet"
        ]
        self.assertEqual(hojas, ["/css/landing.css"])
        css = leer(hojas[0].lstrip("/"))

        fuentes = re.findall(r"url\(\s*['\"]?([^'\")]+\.woff2)", css)
        self.assertEqual(
            sorted(fuentes),
            ["/fonts/nunito-400-latin.woff2", "/fonts/nunito-700-latin.woff2"],
        )
        total = len(html.encode("utf-8")) + len(css.encode("utf-8"))
        fotos = [p.stat().st_size for p in (LANDING / "img").glob("*")]
        self.assertTrue(all(peso <= 24_000 for peso in fotos), "Una foto pasa de 24 KB")
        self.assertLessEqual(sum(fotos), 215_000, "Las fotos suman más de 215 KB")
        total += sum(fotos)
        for fuente in fuentes:
            ruta = LANDING / fuente.lstrip("/")
            contenido = ruta.read_bytes()
            self.assertEqual(contenido[:4], b"wOF2", fuente)
            self.assertLessEqual(len(contenido), 50_000, fuente)
            total += len(contenido)
        self.assertLessEqual(total, 300_000)

        caras = [c for s, c in bloques_css(css) if s == "@font-face"]
        self.assertEqual(len(caras), 2)
        for cara in caras:
            self.assertEqual(propiedades(cara).get("font-display"), "swap")

        servidor, _ = bloques_nginx(leer("nginx.conf"))
        self.assertIn("gzip on", servidor)
        self.assertTrue(any(d.startswith("gzip_types") and "text/css" in d for d in servidor))


    def test_TC_TT_WEB_01_10_una_pantalla_y_movimiento_reducido(self):
        """KNOCK-258 (spec 004, R-06 y R-07, CA-05). CA-04 se mide en un navegador."""
        css = leer("css/landing.css")
        reglas = bloques_css(css)

        reducido = [c for s, c in reglas if "prefers-reduced-motion: reduce" in s]
        self.assertTrue(reducido, "Sin @media (prefers-reduced-motion: reduce)")
        self.assertTrue(any("animation: none" in c for c in reducido), "No apaga las animaciones")
        self.assertTrue(any("transition: none" in c for c in reducido), "No apaga las transiciones")

        inicio = [c for s, c in reglas if s == ".inicio"]
        self.assertTrue(inicio, "Falta la regla .inicio")
        self.assertTrue(any("100dvh" in c for c in inicio), "La página principal no ocupa una pantalla")

        pagina = analizar(leer("index.html"))
        cuerpo = [a for t, a in pagina.etiquetas if t == "body"]
        self.assertEqual(cuerpo[0].get("class"), "inicio")
        for tag, atributos in pagina.etiquetas:
            if tag == "svg":
                decorativo = atributos.get("aria-hidden") == "true"
                con_nombre = atributos.get("role") == "img" and atributos.get("aria-label")
                self.assertTrue(decorativo or con_nombre, "<svg> sin aria-hidden ni nombre")
        self.assertEqual(pagina.de("script"), [])

    def test_TC_TT_WEB_01_11_instagram(self):
        """KNOCK-258 (spec 004, R-09 y CA-06): Instagram, TikTok, X y Facebook."""
        html = leer("index.html")
        pagina = analizar(html)
        redes = [
            e
            for e in pagina.enlaces
            if es_externo(e["attrs"].get("href", "")) and e["attrs"]["href"] not in {URL_PLAY, *URLS_BETA}
        ]
        self.assertEqual([e["attrs"]["href"] for e in redes], URLS_REDES)
        for enlace, (url, nombre) in zip(redes, REDES):
            atributos = enlace["attrs"]
            self.assertEqual(atributos.get("aria-label"), nombre)
            self.assertEqual(atributos.get("target"), "_blank")
            self.assertEqual(sorted(atributos.get("rel", "").split()), ["noopener", "noreferrer"])
            self.assertEqual(enlace["texto"].strip(), "", f"El ícono de {nombre} no duplica el nombre")
            bloque = html[html.index(f'href="{url}"') :]
            bloque = bloque[: bloque.index("</a>")]
            self.assertIn('<svg viewBox="0 0 24 24" aria-hidden="true">', bloque)
            self.assertNotIn("<img", bloque)
        self.assertEqual(html.count('class="red"'), 4)
        self.assertEqual(enlaces_externos(pagina).count(URL_INSTAGRAM), 1)

        # Objetivo táctil de al menos 44 px (3rem de ancho y 2.75rem de alto).
        reglas = bloques_css(leer("css/landing.css"))
        red = [propiedades(c) for s, c in reglas if s == ".enlaces .red"]
        self.assertTrue(red, "Falta la regla .enlaces .red")
        self.assertEqual(red[0].get("width"), "3rem")
        self.assertEqual(red[0].get("min-height"), "2.75rem")

    def test_TC_TT_WEB_01_12_imagen_con_personas_y_leyenda(self):
        """KNOCK-258 (spec 004, R-09 y CA-06): mosaico de 22 fotos propias, lema en HTML, sin terceros."""
        html = leer("index.html")
        pagina = analizar(html)
        imagenes = pagina.de("img")
        self.assertEqual(sorted(i.get("src") for i in imagenes), sorted(f"/img/{f}" for f in FOTOS))
        for imagen in imagenes:
            self.assertIn("alt", imagen, f"{imagen.get('src')} sin atributo alt")
            self.assertNotIn("Tu técnico de confianza", imagen.get("alt", ""))
            self.assertRegex(imagen.get("width", ""), r"^[1-9]\d*$")
            self.assertRegex(imagen.get("height", ""), r"^[1-9]\d*$")
            self.assertEqual(imagen.get("decoding"), "async")
            self.assertNotEqual(imagen.get("loading"), "lazy")
        con_texto = [i for i in imagenes if i.get("alt", "").strip()]
        self.assertGreaterEqual(len(con_texto), 4, "Al menos 4 fotos con alt descriptivo")
        self.assertLessEqual(len(con_texto), 6, "El resto son decorativas (alt vacío)")
        grupos = [a for a in pagina.de("div") if a.get("class") == "moodboard"]
        self.assertEqual(len(grupos), 1)
        self.assertEqual(grupos[0].get("role"), "group")
        self.assertTrue(grupos[0].get("aria-label", "").strip())

        carpeta = LANDING / "img"
        self.assertEqual(sorted(p.name for p in carpeta.iterdir()), sorted(FOTOS))
        pesos = []
        for nombre in FOTOS:
            contenido = (carpeta / nombre).read_bytes()
            self.assertEqual(contenido[:4], b"RIFF", nombre)
            self.assertEqual(contenido[8:12], b"WEBP", nombre)
            self.assertLessEqual(len(contenido), 24_000, nombre)
            pesos.append(len(contenido))
        self.assertLessEqual(sum(pesos), 215_000)

        adornos = [a for t, a in pagina.etiquetas if t == "svg" and "adorno" in a.get("class", "")]
        self.assertGreaterEqual(len(adornos), 4)
        for adorno in adornos:
            self.assertEqual(adorno.get("aria-hidden"), "true")
        for sin_texto in ("text", "desc"):
            self.assertEqual(pagina.de(sin_texto), [], f"<{sin_texto}> en un SVG")

        self.assertIn('Tu técnico de confianza, a tu puerta', pagina.texto_visible())
        for prohibida in ("script", "input", "form", "iframe"):
            self.assertEqual(pagina.de(prohibida), [], f"<{prohibida}>")
        self.assertNotIn('style="', html)
        self.assertEqual(html.count("<h1"), 1)
        self.assertIn("Técnicos de", html)


    def test_interruptor_de_tema_en_las_tres_paginas(self):
        """KNOCK-258 (spec 004, R-08): un interruptor con dos enlaces de ancla, sin JavaScript ni formularios."""
        for nombre in ("index.html", "privacidad/index.html", "eliminar-cuenta/index.html"):
            html = leer(nombre)
            pagina = analizar(html)
            for prohibida in ("input", "button", "script", "form", "select"):
                self.assertEqual(pagina.de(prohibida), [], f"<{prohibida}> en {nombre}")
            self.assertIn('<span id="tema-claro"></span><span id="tema-oscuro"></span>', html, nombre)
            interruptores = {
                a.get("href"): a
                for a in (e["attrs"] for e in pagina.enlaces)
                if "tema-sw" in a.get("class", "")
            }
            self.assertEqual(sorted(interruptores), ["#tema-claro", "#tema-oscuro"], nombre)
            self.assertEqual(interruptores["#tema-oscuro"].get("aria-label"), "Cambiar a modo oscuro")
            self.assertEqual(interruptores["#tema-claro"].get("aria-label"), "Cambiar a modo claro")
            self.assertIn("tema-a-oscuro", interruptores["#tema-oscuro"]["class"])
            self.assertIn("tema-a-claro", interruptores["#tema-claro"]["class"])
            for tag, atributos in pagina.etiquetas:
                if tag == "svg" and "tema-ic" in atributos.get("class", ""):
                    self.assertEqual(atributos.get("aria-hidden"), "true", nombre)
            for visible in ("Tema", "Claro", "Oscuro"):
                self.assertNotIn(visible, pagina.texto_visible().split(), nombre)
            self.assertNotIn("tema-sel", html, nombre)

        css = leer("css/landing.css")
        reglas = bloques_css(css)
        selectores = [s for s, _ in reglas]
        for esperado in (
            ":root:has(#tema-claro:target) .tema-a-claro",
            ":root:has(#tema-claro:target) .tema-a-oscuro",
            ":root:has(#tema-oscuro:target) .tema-a-oscuro",
            ":root:has(#tema-oscuro:target) .tema-a-claro",
        ):
            self.assertIn(esperado, selectores)
        base = [propiedades(c) for s, c in reglas if s == ".tema-a-claro"]
        self.assertEqual(base[0].get("display"), "none")
        interruptor = [propiedades(c) for s, c in reglas if s == ".tema-sw"]
        self.assertEqual(interruptor[0].get("min-height"), "2.75rem")
        self.assertTrue(
            any(
                "prefers-color-scheme: dark" in s and ".tema-a-oscuro" in s and propiedades(c).get("display") == "none"
                for s, c in reglas
            ),
            "Sin tema elegido, el interruptor sigue al del sistema",
        )


if __name__ == "__main__":
    unittest.main()
