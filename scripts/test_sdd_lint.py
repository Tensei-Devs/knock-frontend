#!/usr/bin/env python3
"""Pruebas de las specs numeradas en sdd_lint.py. Uso: python scripts/test_sdd_lint.py (sin dependencias; no corre en el CI)."""
from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sdd_lint  # noqa: E402


class NumberedSpecTests(unittest.TestCase):
    def test_numbered_folders_are_recognised(self) -> None:
        self.assertTrue(sdd_lint.NUMBERED.match("006-contrato-de-la-api-y-cliente-generado"))
        self.assertFalse(sdd_lint.NUMBERED.match("TT-BD-06-catalogo"))
        self.assertFalse(sdd_lint.NUMBERED.match("_legacy"))

    def test_cases_are_the_ca_criteria_of_the_spec(self) -> None:
        text = "## 4. Criterios de aceptación\n- **CA-01:** Dado A.\n- **CA-02:** Dado B.\nTexto con **CA-09:** en medio.\n"
        self.assertEqual(["CA-01", "CA-02"], sdd_lint.numbered_cases(text))

    def test_a_test_may_cite_the_case_with_or_without_the_spec_number(self) -> None:
        self.assertEqual(["CA_006_01", "CA_01"], sdd_lint.needles("CA-01", "006"))
        self.assertEqual(["TC_HU_001_01"], sdd_lint.needles("TC-HU-001-01", None))


if __name__ == "__main__":
    unittest.main()
