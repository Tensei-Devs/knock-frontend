"""Páginas legales vigentes y revisión de enlaces (spec 004, KNOCK-218).

Solo biblioteca estándar y sin red. Corre con
`python -m unittest discover -s landing/tests -v` desde la raíz del repositorio.
Los métodos llevan el ID del caso con guiones bajos (CA-03 de la spec 004).
"""

import re
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import check_links  # noqa: E402
from test_landing import LANDING, analizar, enlaces_externos, leer  # noqa: E402

PAGINAS_LEGALES = ("privacidad/index.html", "eliminar-cuenta/index.html")
CORREO = "soporte@tdevs.com.mx"
RESPONSABLE = ("José Julián Hernández Hernández", "Alonso de Borja 92", "Aviación", "42506", "Actopan", "Hidalgo")


class PaginasLegales(unittest.TestCase):
    def test_CA_03_los_enlaces_de_la_landing_no_estan_rotos(self):
        self.assertEqual(check_links.revisar(LANDING), [])

    def test_CA_03_un_enlace_roto_hace_fallar(self):
        with tempfile.TemporaryDirectory() as tmp:
            raiz = Path(tmp)
            (raiz / "index.html").write_text(
                '<a href="/no-existe/">x</a><a href="#nada">y</a>'
                '<a href="https://otro.example/">z</a>',
                encoding="utf-8",
            )
            errores = check_links.revisar(raiz)
        self.assertEqual(len(errores), 3, errores)

    def test_R_01_las_rutas_reservadas_existen_y_estan_enlazadas(self):
        for ruta in ("/privacidad/", "/eliminar-cuenta/"):
            self.assertTrue((LANDING / ruta.strip("/") / "index.html").is_file(), ruta)
            hrefs = [e["attrs"].get("href") for e in analizar(leer("index.html")).enlaces]
            self.assertIn(ruta, hrefs)

    def test_vigente_indexable_version_y_fecha(self):
        for nombre in PAGINAS_LEGALES:
            pagina = analizar(leer(nombre))
            html = pagina.de("html")[0]
            self.assertEqual(html.get("lang"), "es-MX", nombre)
            self.assertEqual(html.get("data-estado"), "vigente", nombre)
            self.assertEqual(html.get("data-version"), "1.0", nombre)
            self.assertNotIn({"name": "robots", "content": "noindex"}, pagina.de("meta"), nombre)
            texto = pagina.texto_visible()
            for ausente in ("Borrador por revisar", "Texto provisional", "(borrador)"):
                self.assertNotIn(ausente, texto, nombre)
            self.assertEqual([a for t, a in pagina.etiquetas if "aviso-borrador" in a.get("class", "")], [], nombre)
            self.assertRegex(texto, rf"Versión {re.escape(html['data-version'])}\b", nombre)
            fechas = [a for a in pagina.de("time") if re.fullmatch(r"\d{4}-\d{2}-\d{2}", a.get("datetime", ""))]
            self.assertEqual(len(fechas), 1, nombre)
            self.assertEqual(len(pagina.de("h1")), 1, nombre)
            for region in ("header", "main", "footer"):
                self.assertEqual(len(pagina.de(region)), 1, f"<{region}> en {nombre}")

    def test_sin_marcadores_con_responsable_y_correo_de_contacto(self):
        for nombre in PAGINAS_LEGALES:
            html = leer(nombre)
            for marcador in ("POR COMPLETAR", "POR CONFIRMAR"):
                self.assertNotIn(marcador, html, nombre)
            self.assertNotRegex(html, r"\[[A-ZÁÉÍÓÚÑ ]{6,}[^\]]*\]", nombre)
            self.assertNotRegex(html, r"\b(TT|HU|KNOCK)-[A-Za-z0-9]", nombre)
            # El único contacto es el correo de soporte del proyecto, en texto (un mailto: contaría como enlace externo).
            self.assertEqual(set(re.findall(r"[\w.+-]+@[\w-]+(?:\.[\w-]+)+", html)), {CORREO}, nombre)
            self.assertNotRegex(html, r"https?://", nombre)
        privacidad = analizar(leer("privacidad/index.html")).texto_visible()
        for dato in RESPONSABLE:
            self.assertIn(dato, privacidad)

    def test_sin_scripts_formularios_ni_terceros(self):
        for nombre in PAGINAS_LEGALES:
            pagina = analizar(leer(nombre))
            for prohibida in ("script", "style", "form", "input", "iframe"):
                self.assertEqual(pagina.de(prohibida), [], f"<{prohibida}> en {nombre}")
            for tag, atributos in pagina.etiquetas:
                self.assertNotIn("style", atributos, nombre)
                self.assertEqual([a for a in atributos if a.startswith("on")], [], nombre)
            self.assertEqual(enlaces_externos(pagina), [], nombre)
            for enlace in pagina.enlaces:
                self.assertTrue(enlace["texto"].strip(), f"Enlace sin nombre en {nombre}")

    def test_el_aviso_declara_region_y_datos_que_respaldan_las_specs(self):
        texto = analizar(leer("privacidad/index.html")).texto_visible()
        for esperado in (
            "West US",
            "Estados Unidos",
            "cifrad",
            "aviso de privacidad y de los términos",
            "código postal",
            "no usa cookies ni analítica",
        ):
            self.assertIn(esperado, texto)
        ids = [a["id"] for tag, a in analizar(leer("privacidad/index.html")).etiquetas if tag == "h2" and "id" in a]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertTrue({"responsable", "datos-tratados", "alojamiento", "derechos", "contacto"} <= set(ids))
        # Afirmaciones que ninguna spec respalda no deben aparecer.
        for prohibida in ("anonimiz", "contraseña", "garantiz", "vendemos", "publicidad"):
            self.assertNotIn(prohibida, texto.lower())

    def test_eliminar_cuenta_no_recoge_datos(self):
        pagina = analizar(leer("eliminar-cuenta/index.html"))
        self.assertEqual(pagina.de("form") + pagina.de("input"), [])
        ids = {a["id"] for tag, a in pagina.etiquetas if tag == "h2" and "id" in a}
        self.assertTrue({"como-solicitar", "que-se-borra", "que-se-conserva", "contacto"} <= ids)


if __name__ == "__main__":
    unittest.main()
