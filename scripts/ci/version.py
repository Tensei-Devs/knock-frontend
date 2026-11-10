#!/usr/bin/env python3
"""Versionamiento por puntos del frontend de Knock (spec 011): versión X.Y.Z, `versionCode` de Android y etiqueta de puntos.

Reglas (spec 011):
  R-01  La app, el panel y la landing llevan cada uno su versión X.Y.Z; la primera publicada es 1.0.0.
  R-02  X sube con un cambio que rompe lo anterior, Y con funciones acumuladas y Z con cambios pequeños.
  R-03  Puntos por tipo de cambio: ver POINTS (la tabla de CONTRIBUTING.md debe coincidir).
  R-04  Cada PR declara sus puntos por componente con la etiqueta `puntos-<componente>-N`.
  R-05  Al publicar se suman los puntos y se aplican a Z; con 10 puntos Z vuelve a cero y Y sube, y lo mismo entre Y y X.
        Un cambio que rompe compatibilidad sube X y deja Y y Z en cero.
  R-06  versionCode = X * 1 000 000 + Y * 10 000 + Z * 100 + n, con n (0 a 99) el número de subida de esa versión.
  R-07  Una publicación con cero puntos no cambia la versión.

Uso (sin dependencias):
  python scripts/ci/version.py bump --current 1.1.2 --points 4 [--breaking]   # imprime la versión nueva
  python scripts/ci/version.py code --version 1.1.2 --n 0                     # imprime 1010200
  python scripts/ci/version.py points --component app --labels '["puntos-app-3","puntos-panel-1"]'
  PR_LABELS='["puntos-app-3"]' python scripts/ci/version.py check-labels [--head <rama>]   # CA-03: falla sin etiqueta válida
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys

FIRST_VERSION = "1.0.0"  # R-01
COMPONENTS = ("app", "panel", "landing")  # R-01
# R-03: puntos por tipo de cambio.
POINTS = {
    "fix": 1, "text-adjustment": 1, "translation": 1, "style": 1,
    "new-field": 2, "rule-change": 2,
    "screen": 3,
    "full-feature": 5,
    "external-integration": 10, "phone-permission": 10,
}
CARRY = 10  # R-05: con 10 puntos Z vuelve a cero y Y sube; igual entre Y y X (la spec no da otro umbral)
N_MAX = 99  # R-06: n va de 0 a 99
MAX_VERSION_CODE = 2_100_000_000  # tope que Google Play acepta para versionCode
LABEL_PREFIX = "puntos-"
LABEL = re.compile(rf"^{LABEL_PREFIX}({'|'.join(COMPONENTS)})-(0|[1-9][0-9]{{0,2}})$")
VERSION = re.compile(r"^(0|[1-9][0-9]*)\.([0-9])\.([0-9])$")
# Ramas de bots que no declaran puntos (release-please y Dependabot).
EXEMPT_HEAD = re.compile(r"^(release-please--|dependabot/)")


def parse_version(text: str) -> tuple[int, int, int]:
    m = VERSION.match(text.strip())
    if not m:
        raise ValueError(f"Versión inválida «{text}»: se espera X.Y.Z con Y y Z de un dígito (0 a 9).")
    return int(m.group(1)), int(m.group(2)), int(m.group(3))


def bump(current: str, points: int, breaking: bool = False) -> str:
    """Versión que resulta de publicar `points` puntos sobre `current` (R-05, R-07)."""
    if points < 0:
        raise ValueError("Los puntos no pueden ser negativos.")
    x, y, z = parse_version(current)
    if breaking:
        return f"{x + 1}.0.0"
    if points == 0:
        return f"{x}.{y}.{z}"
    total = x * CARRY * CARRY + y * CARRY + z + points  # los acarreos Z→Y e Y→X son los de un número en base 10
    return f"{total // (CARRY * CARRY)}.{(total // CARRY) % CARRY}.{total % CARRY}"


def version_code(version: str, n: int = 0) -> int:
    """R-06: X × 1 000 000 + Y × 10 000 + Z × 100 + n. Crece con la versión y con n; rechaza lo que Google Play no acepta."""
    x, y, z = parse_version(version)
    if isinstance(n, bool) or not isinstance(n, int) or not 0 <= n <= N_MAX:
        raise ValueError(f"El número de subida n debe ser un entero de 0 a {N_MAX}; llegó «{n}».")
    code = x * 1_000_000 + y * 10_000 + z * 100 + n
    if code > MAX_VERSION_CODE:
        raise ValueError(f"El versionCode {code} supera el máximo de Google Play ({MAX_VERSION_CODE}).")
    return code


def parse_labels(labels: list[str]) -> tuple[dict[str, int], list[str]]:
    """Devuelve (puntos por componente, errores). Una etiqueta `puntos-…` mal formada o repetida por componente es error."""
    found: dict[str, int] = {}
    errors: list[str] = []
    for name in labels:
        if not name.startswith(LABEL_PREFIX):
            continue
        m = LABEL.match(name)
        if not m:
            errors.append(f"Etiqueta «{name}» inválida: usa puntos-<componente>-N con componente en {', '.join(COMPONENTS)} y N entero.")
        elif m.group(1) in found:
            errors.append(f"El componente «{m.group(1)}» tiene más de una etiqueta de puntos.")
        else:
            found[m.group(1)] = int(m.group(2))
    return found, errors


def check_labels(labels: list[str], head: str = "") -> list[str]:
    """CA-03: un PR sin etiqueta de puntos válida falla."""
    if head and EXEMPT_HEAD.match(head):
        return []
    found, errors = parse_labels(labels)
    if not found and not errors:
        errors.append("El PR no tiene etiqueta de puntos: agrega puntos-<componente>-N (p. ej. puntos-app-3; 0 si no suma). Ver CONTRIBUTING.md.")
    return errors


def load_labels(raw: str) -> list[str]:
    data = json.loads(raw or "[]")
    if not isinstance(data, list) or not all(isinstance(i, str) for i in data):
        raise ValueError("Las etiquetas deben ser una lista JSON de textos.")
    return data


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="cmd", required=True)
    b = sub.add_parser("bump"); b.add_argument("--current", default=FIRST_VERSION); b.add_argument("--points", type=int, required=True); b.add_argument("--breaking", action="store_true")
    k = sub.add_parser("code"); k.add_argument("--version", required=True); k.add_argument("--n", type=int, default=0)
    p = sub.add_parser("points"); p.add_argument("--component", required=True, choices=COMPONENTS); p.add_argument("--labels", required=True, help="lista JSON de etiquetas")
    c = sub.add_parser("check-labels"); c.add_argument("--labels", default=os.environ.get("PR_LABELS", "[]")); c.add_argument("--head", default=os.environ.get("HEAD_REF", ""))
    args = parser.parse_args()
    try:
        if args.cmd == "bump":
            print(bump(args.current, args.points, args.breaking))
            return 0
        if args.cmd == "code":
            print(version_code(args.version, args.n))
            return 0
        if args.cmd == "points":
            found, errors = parse_labels(load_labels(args.labels))
            for e in errors:
                print(f"✗ {e}", file=sys.stderr)
            print(found.get(args.component, 0))
            return 1 if errors else 0
        errors = check_labels(load_labels(args.labels), args.head)
    except ValueError as exc:  # json.JSONDecodeError es un ValueError
        errors = [str(exc)]
    for e in errors:
        print(f"::error::{e}" if os.environ.get("GITHUB_ACTIONS") else f"✗ {e}")
    if not errors:
        print("OK")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
