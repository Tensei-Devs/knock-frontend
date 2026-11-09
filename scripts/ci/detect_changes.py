#!/usr/bin/env python3
"""Detección de cambios por carpeta del CI (spec 007, R-01, R-02 y CA-02).

Decide qué jobs corren: la app solo si cambió `app/` (o `contracts/`), el panel solo si cambió `panel/` (o `contracts/`).
Con un evento que no es un PR (push a ramas fijas, ejecución manual) corren todos los proyectos que existen.

Uso (CI, escribe en $GITHUB_OUTPUT):
  python3 scripts/ci/detect_changes.py --event "$EVENT" --base "$BASE_SHA" >> "$GITHUB_OUTPUT"
Sin dependencias.
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from collections.abc import Callable, Iterable
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
# Proyecto → (archivo que prueba que existe, carpetas que lo disparan).
PROJECTS: dict[str, tuple[str, re.Pattern[str]]] = {
    "app": ("app/pubspec.yaml", re.compile(r"^(app/|contracts/)")),
    "panel": ("panel/angular.json", re.compile(r"^(panel/|contracts/)")),
}
CONTRACT_FILE = "contracts/openapi.v1.json"


def detect(changed: Iterable[str] | None, exists: Callable[[str], bool]) -> dict[str, bool]:
    """`changed` es la lista de archivos del PR, o None si el evento no es un PR (corren todos los que existen)."""
    files = list(changed) if changed is not None else None
    result: dict[str, bool] = {}
    for name, (marker, pattern) in PROJECTS.items():
        touched = files is None or any(pattern.match(f) for f in files)
        result[name] = exists(marker) and touched
    result["contract"] = exists(CONTRACT_FILE)
    return result


def changed_files(base: str) -> list[str]:
    out = subprocess.run(["git", "diff", "--name-only", base, "HEAD"], cwd=ROOT, capture_output=True, text=True, check=True)
    return [line.strip() for line in out.stdout.splitlines() if line.strip()]


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--event", required=True, help="github.event_name")
    parser.add_argument("--base", default="", help="SHA base del PR (solo con --event pull_request)")
    args = parser.parse_args(argv)
    is_pr = args.event == "pull_request"
    if is_pr and not args.base:
        print("ERROR: un pull_request necesita --base.", file=sys.stderr)
        return 2
    result = detect(changed_files(args.base) if is_pr else None, lambda rel: (ROOT / rel).is_file())
    for name, value in result.items():
        print(f"{name}={'true' if value else 'false'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
