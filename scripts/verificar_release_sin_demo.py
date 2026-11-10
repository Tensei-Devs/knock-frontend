#!/usr/bin/env python3
"""Spec 027, R-11 y CA-27: comprueba que un binario de tienda (`release`) no
contiene los datos de ejemplo del modo demostración.

Se compila `release` con la bandera puesta y se revisa el resultado:

  flutter build apk --release --dart-define=KNOCK_DEMO_DATOS=true
  python scripts/verificar_release_sin_demo.py app/build/app/outputs/flutter-apk/app-release.apk

Acepta archivos y carpetas; un .apk, .aab o .zip se abre y se revisan sus
miembros (por ejemplo `lib/arm64-v8a/libapp.so`). Falla (código 1) si encuentra
alguno de los textos que solo existen en `features/previa/demo/`, y también
si no encuentra nada que revisar (para no dar un falso verde).

Los nombres de ejemplo y la colonia ficticia viven solo en
`datos_de_ejemplo.dart`; el rótulo «Datos de ejemplo» sale del ARB y el
compilador lo descarta junto con el panel cuando la bandera no aplica, por eso
también se busca (en UTF-8 y en UTF-16).

Sin dependencias externas.
"""
from __future__ import annotations

import sys
import zipfile
from pathlib import Path

# Texto -> motivo. Los nombres se leen de datos_de_ejemplo.dart cuando se
# puede, para que agregar un experto no exija tocar este script.
RASTROS_FIJOS = {
    "Datos de ejemplo": "rótulo del modo demostración",
    "Colonia Muestra Centro": "colonia ficticia",
}
FUENTE_DATOS = Path("app/lib/features/previa/demo/datos_de_ejemplo.dart")


def _nombres_de_la_fuente(raiz: Path) -> dict[str, str]:
    import re

    fuente = raiz / FUENTE_DATOS
    if not fuente.is_file():
        return {}
    texto = fuente.read_text(encoding="utf-8")
    return {
        m.group(1): "nombre de un experto de ejemplo"
        for m in re.finditer(r"nombre:\s*'([^']+)'", texto)
    }


def _contenidos(ruta: Path):
    """Entrega (etiqueta, bytes) de cada archivo; abre los comprimidos."""
    if ruta.is_dir():
        for hijo in sorted(p for p in ruta.rglob("*") if p.is_file()):
            yield from _contenidos(hijo)
        return
    if ruta.suffix.lower() in {".apk", ".aab", ".zip"}:
        with zipfile.ZipFile(ruta) as paquete:
            for miembro in paquete.namelist():
                yield f"{ruta}!{miembro}", paquete.read(miembro)
        return
    yield str(ruta), ruta.read_bytes()


def buscar_rastros(rutas: list[Path], rastros: dict[str, str]) -> list[str]:
    """Devuelve una línea por cada rastro hallado y cuántos archivos revisó."""
    hallazgos: list[str] = []
    for ruta in rutas:
        for etiqueta, datos in _contenidos(ruta):
            for texto, motivo in rastros.items():
                for variante in (texto.encode("utf-8"), texto.encode("utf-16-le")):
                    if variante in datos:
                        hallazgos.append(f"{etiqueta}: «{texto}» ({motivo})")
                        break
    return hallazgos


def main(argv: list[str]) -> int:
    if not argv:
        print(__doc__)
        return 2
    rutas = [Path(a) for a in argv]
    faltan = [str(r) for r in rutas if not r.exists()]
    if faltan:
        print(f"ERROR: no existe: {', '.join(faltan)}", file=sys.stderr)
        return 2
    raiz = Path(__file__).resolve().parent.parent
    rastros = {**RASTROS_FIJOS, **_nombres_de_la_fuente(raiz)}
    revisados = sum(1 for r in rutas for _ in _contenidos(r))
    if revisados == 0:
        print("ERROR: no hay archivos que revisar.", file=sys.stderr)
        return 2
    hallazgos = buscar_rastros(rutas, rastros)
    if hallazgos:
        print("FALLA: el binario contiene datos de ejemplo del modo demostración:")
        for h in hallazgos:
            print(f"  - {h}")
        return 1
    print(f"OK: {revisados} archivo(s) revisados, sin rastros de los datos de ejemplo.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
