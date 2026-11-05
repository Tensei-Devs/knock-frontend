#!/usr/bin/env python3
"""Resultado del check obligatorio `gate` (spec 007, R-01 y CA-01).

El `gate` agrupa los jobs del CI: pasa solo si cada job terminó en `success` o `skipped` (no aplicaba).
Un job fallido, cancelado o sin terminar hace fallar el check, y con él el PR.

Uso (CI): NEEDS='<toJSON(needs)>' python3 scripts/ci/gate.py
Sin dependencias.
"""
from __future__ import annotations

import json
import os
import sys

OK = ("success", "skipped")


def failures(needs: dict[str, dict[str, object]]) -> dict[str, object]:
    """Jobs cuyo resultado no es `success` ni `skipped`. Vacío significa que el gate pasa."""
    return {name: job.get("result") for name, job in needs.items() if job.get("result") not in OK}


def main() -> int:
    needs = json.loads(os.environ["NEEDS"])
    for name, job in needs.items():
        print(f"{name}: {job.get('result')}")
    bad = failures(needs)
    if bad:
        print(f"Fallaron: {bad}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
