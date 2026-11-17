"""El contexto de build de la landing deja pasar lo que copia el Dockerfile (KNOCK-258).

Railway construye con `landing/.dockerignore`, que ignora todo salvo lo permitido.
Si el Dockerfile copia una carpeta que no está permitida, el despliegue falla con
`"/img": not found` y el sitio publicado se queda con la versión anterior.
"""

import unittest
from pathlib import Path

LANDING = Path(__file__).resolve().parents[1]


def _origenes_copiados():
    origenes = []
    for linea in (LANDING / "Dockerfile").read_text(encoding="utf-8").splitlines():
        partes = linea.split()
        if partes and partes[0].upper() == "COPY":
            origenes.extend(p for p in partes[1:-1] if not p.startswith("--"))
    return origenes


def _permitidos():
    permitidos = set()
    for linea in (LANDING / ".dockerignore").read_text(encoding="utf-8").splitlines():
        linea = linea.strip()
        if linea.startswith("!"):
            permitidos.add(linea[1:].rstrip("/"))
    return permitidos


class ContextoDeBuildTest(unittest.TestCase):
    def test_dockerignore_permite_todo_lo_que_copia_el_dockerfile(self):
        origenes = _origenes_copiados()
        self.assertTrue(origenes, "el Dockerfile no copia nada: el test no lee bien")
        faltan = [o for o in origenes if o.rstrip("/") not in _permitidos()]
        self.assertEqual(faltan, [], f"el .dockerignore no permite: {faltan}")

    def test_lo_que_copia_el_dockerfile_existe(self):
        faltan = [o for o in _origenes_copiados() if not (LANDING / o).exists()]
        self.assertEqual(faltan, [], f"el Dockerfile copia rutas que no existen: {faltan}")


if __name__ == "__main__":
    unittest.main()
