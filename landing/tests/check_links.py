"""Revisa los enlaces de la landing (spec 004, R-04 y CA-03).

Solo biblioteca estándar y sin red. Uso, desde la raíz del repositorio:

    python landing/tests/check_links.py [carpeta]

Falla (código 1) si un enlace interno (`href`, `src`) no apunta a un archivo
de la landing, si un ancla `#id` no existe en la página destino, o si un enlace
externo no es una de las URL permitidas (Google Play e Instagram de Knock)
que revisa `test_landing.py`.
Los enlaces externos no se piden por red: se comparan con la lista permitida.
"""

import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit

PERMITIDOS_EXTERNOS = {
    "https://play.google.com/store/apps/details?id=app.knock.mobile"
    "&referrer=utm_source%3Dlanding%26utm_medium%3Dweb%26utm_campaign%3Dlanding",
    "https://play.google.com/apps/testing/app.knock.mobile",
    "https://play.google.com/store/apps/details?id=app.knock.mobile",
    "https://www.instagram.com/knock.mx/",
    "https://www.tiktok.com/@knockmx",
    "https://x.com/knock_mx",
    "https://www.facebook.com/share/1C3PA8XoUb/",
}


class Enlaces(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.referencias = []  # (etiqueta, atributo, valor)
        self.ids = set()

    def handle_starttag(self, tag, attrs):
        atributos = dict(attrs)
        if "id" in atributos:
            self.ids.add(atributos["id"])
        for atributo in ("href", "src"):
            if atributos.get(atributo) is not None:
                self.referencias.append((tag, atributo, atributos[atributo]))

    handle_startendtag = handle_starttag


def analizar(ruta):
    parser = Enlaces()
    parser.feed(ruta.read_text(encoding="utf-8"))
    parser.close()
    return parser


def destino(raiz, origen, ruta):
    """Archivo al que apunta una ruta del sitio, o None si no existe."""
    base = raiz if ruta.startswith("/") else origen.parent
    limpia = unquote(ruta.lstrip("/")) if ruta.startswith("/") else unquote(ruta)
    candidato = (base / limpia).resolve()
    try:
        candidato.relative_to(raiz.resolve())
    except ValueError:
        return None
    if candidato.is_dir():
        candidato = candidato / "index.html"
    return candidato if candidato.is_file() else None


def revisar(raiz):
    """Devuelve la lista de errores de enlaces de todas las páginas de `raiz`."""
    raiz = Path(raiz).resolve()
    errores = []
    paginas = sorted(raiz.rglob("*.html"))
    if not paginas:
        return [f"No hay páginas HTML en {raiz}"]
    analizadas = {}
    for pagina in paginas:
        analizadas[pagina.resolve()] = analizar(pagina)
    for pagina in paginas:
        nombre = pagina.relative_to(raiz).as_posix()
        for tag, atributo, valor in analizadas[pagina.resolve()].referencias:
            partes = urlsplit(valor)
            if partes.scheme or partes.netloc:
                if valor not in PERMITIDOS_EXTERNOS:
                    errores.append(f"{nombre}: enlace externo no permitido <{tag} {atributo}={valor}>")
                continue
            if not partes.path and not partes.fragment:
                errores.append(f"{nombre}: {atributo} vacío en <{tag}>")
                continue
            if partes.path:
                archivo = destino(raiz, pagina, partes.path)
                if archivo is None:
                    errores.append(f"{nombre}: enlace roto {valor}")
                    continue
            else:
                archivo = pagina.resolve()
            if partes.fragment and archivo.suffix == ".html":
                paginas_destino = analizadas.get(archivo)
                if paginas_destino is None:
                    paginas_destino = analizar(archivo)
                if partes.fragment not in paginas_destino.ids:
                    errores.append(f"{nombre}: ancla inexistente {valor}")
    return errores


def main(argv):
    raiz = Path(argv[1]) if len(argv) > 1 else Path(__file__).resolve().parents[1]
    errores = revisar(raiz)
    for error in errores:
        print(f"ERROR {error}")
    if errores:
        print(f"{len(errores)} enlace(s) con problema.")
        return 1
    print(f"OK: enlaces de {raiz.name} sin problemas.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
