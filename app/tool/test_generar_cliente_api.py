"""Pruebas del generador del cliente (spec 006, KNOCK-220): python -m unittest app/tool/test_generar_cliente_api.py"""
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import generar_cliente_api as g  # noqa: E402


class Normalizar(unittest.TestCase):
    def test_ca_006_01_baja_3_2_a_3_1_sin_tocar_el_original(self):
        original = {"openapi": "3.2.0", "paths": {}}
        self.assertEqual(g.normalizar(original)["openapi"], "3.1.0")
        self.assertEqual(original["openapi"], "3.2.0")

    def test_ca_006_01_numero_que_tambien_es_texto_queda_numerico(self):
        esquema = {"type": ["null", "integer", "string"], "pattern": "^-?\d+$", "format": "int32"}
        r = g.normalizar({"openapi": "3.2.0", "components": {"schemas": {"P": {"properties": {"s": esquema}}}}})
        s = r["components"]["schemas"]["P"]["properties"]["s"]
        self.assertEqual(s["type"], ["null", "integer"])
        self.assertNotIn("pattern", s)
        self.assertEqual(s["format"], "int32")

    def test_ca_006_01_union_desconocida_detiene_la_generacion(self):
        with self.assertRaises(g.ErrorNormalizacion):
            g.normalizar({"openapi": "3.2.0", "x": {"type": ["string", "boolean"]}})

    def test_version_no_soportada(self):
        with self.assertRaises(g.ErrorNormalizacion):
            g.normalizar({"openapi": "2.0"})


class QuitarIgnores(unittest.TestCase):
    def test_quita_lineas_y_finales_sin_tocar_el_codigo(self):
        codigo = "// ignore_for_file: x\n  // ignore: y\na = 1; // ignore: z\nb = 2; // comentario\n"
        self.assertEqual(g.quitar_ignores(codigo), "a = 1;\nb = 2; // comentario\n")


class Manifiesto(unittest.TestCase):
    def test_ca_006_02_el_orden_no_depende_del_sistema(self):
        # Mayúsculas y minúsculas mezcladas: antes Windows y Linux producían un orden distinto.
        with tempfile.TemporaryDirectory() as tmp:
            carpeta = Path(tmp)
            for nombre in ("README.md", "analysis_options.yaml", "doc/AuthApi.md", "lib/api.dart"):
                ruta = carpeta / nombre
                ruta.parent.mkdir(parents=True, exist_ok=True)
                ruta.write_text("x", encoding="utf-8")
            claves = list(g.manifiesto(carpeta, "0" * 64)["archivos"])
        self.assertEqual(claves, sorted(claves))


class Comparar(unittest.TestCase):
    def test_ca_006_02_detecta_edicion_falta_y_sobra(self):
        with tempfile.TemporaryDirectory() as tmp:
            a, b = Path(tmp, "a"), Path(tmp, "b")
            for d in (a, b):
                d.mkdir()
                (d / "igual.dart").write_text("x\n")
            (a / "editado.dart").write_text("original\n")
            (b / "editado.dart").write_text("a mano\n")
            (a / "falta.dart").write_text("x\n")
            (b / "sobra.dart").write_text("x\n")
            self.assertEqual(
                g.comparar(a, b),
                ["falta: falta.dart", "sobra: sobra.dart", "distinto: editado.dart"],
            )

    def test_ca_006_02_ignora_saltos_de_linea(self):
        with tempfile.TemporaryDirectory() as tmp:
            a, b = Path(tmp, "a"), Path(tmp, "b")
            a.mkdir(); b.mkdir()
            (a / "f.dart").write_bytes(b"x\ny\n")
            (b / "f.dart").write_bytes(b"x\r\ny\r\n")
            self.assertEqual(g.comparar(a, b), [])


if __name__ == "__main__":
    unittest.main()
