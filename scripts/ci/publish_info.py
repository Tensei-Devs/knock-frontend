#!/usr/bin/env python3
"""Datos de una publicación de la app en Google Play (spec 007, R-05; spec 011, R-06).

Lee la versión `X.Y.Z` de `app/pubspec.yaml`, cuenta las subidas anteriores de esa versión por sus etiquetas de Git
`app-vX.Y.Z-nK` y calcula el `versionCode`. Así el `versionCode` solo crece y nunca se repite (Google Play rechaza uno repetido).

Uso (CI, escribe en $GITHUB_OUTPUT):
  python3 scripts/ci/publish_info.py >> "$GITHUB_OUTPUT"
Imprime: version, n, version_code y tag (la etiqueta de esta subida, `app-vX.Y.Z-nN`).
Sin dependencias.
"""
from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import version as versioning  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
PUBSPEC_VERSION = re.compile(r"^version:\s*(\d+\.\d+\.\d+)(?:\+\d+)?\s*$", re.M)


def pubspec_version(text: str) -> str:
    m = PUBSPEC_VERSION.search(text)
    if not m:
        raise ValueError("app/pubspec.yaml no tiene una línea «version: X.Y.Z» (con o sin +build).")
    versioning.parse_version(m.group(1))  # rechaza lo que la spec 011 no admite
    return m.group(1)


def next_upload(tags: list[str], version: str) -> int:
    """Número de subida n (0 a 99) de `version`: uno más que el mayor `app-v<version>-nK` existente."""
    pattern = re.compile(rf"^app-v{re.escape(version)}-n(\d+)$")
    used = [int(m.group(1)) for t in tags if (m := pattern.match(t.strip()))]
    return max(used) + 1 if used else 0


def git_tags() -> list[str]:
    out = subprocess.run(["git", "tag", "--list", "app-v*"], cwd=ROOT, capture_output=True, text=True, check=True)
    return out.stdout.split()


def main() -> int:
    version = pubspec_version((ROOT / "app" / "pubspec.yaml").read_text(encoding="utf-8"))
    n = next_upload(git_tags(), version)
    code = versioning.version_code(version, n)  # falla si n pasa de 99
    print(f"version={version}")
    print(f"n={n}")
    print(f"version_code={code}")
    print(f"tag=app-v{version}-n{n}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
