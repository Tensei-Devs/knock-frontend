#!/usr/bin/env python3
"""Pruebas de scripts/ci/detect_changes.py y scripts/ci/gate.py (spec 007, CA-01 y CA-02).

Uso: python scripts/ci/test_detect_changes.py (sin dependencias).
"""
from __future__ import annotations

import io
import os
import sys
import unittest
from contextlib import redirect_stderr, redirect_stdout
from pathlib import Path
from unittest import mock

sys.path.insert(0, str(Path(__file__).resolve().parent))
import detect_changes  # noqa: E402
import gate  # noqa: E402

EXISTS_ALL = {"app/pubspec.yaml", "panel/angular.json", "contracts/openapi.v1.json"}


def run(changed: list[str] | None, exists: set[str] = EXISTS_ALL) -> dict[str, bool]:
    return detect_changes.detect(changed, lambda rel: rel in exists)


class DetectChangesTests(unittest.TestCase):
    def test_a_pr_that_only_touches_the_panel_does_not_run_the_app_job_CA_007_02(self) -> None:
        result = run(["panel/src/app/app.ts", "panel/package.json"])
        self.assertFalse(result["app"])
        self.assertTrue(result["panel"])

    def test_a_pr_that_only_touches_the_app_does_not_run_the_panel_job_CA_007_02(self) -> None:
        result = run(["app/lib/main.dart"])
        self.assertTrue(result["app"])
        self.assertFalse(result["panel"])

    def test_a_pr_that_only_touches_docs_or_the_landing_runs_neither_project_CA_007_02(self) -> None:
        result = run(["docs/VERSIONAMIENTO.md", "landing/index.html", "Memoria.md"])
        self.assertFalse(result["app"])
        self.assertFalse(result["panel"])

    def test_a_contract_change_runs_both_projects_CA_007_02(self) -> None:
        result = run(["contracts/openapi.v1.json"])
        self.assertTrue(result["app"])
        self.assertTrue(result["panel"])

    def test_a_path_that_merely_starts_like_a_folder_does_not_count_CA_007_02(self) -> None:
        result = run(["application.md", "panelist/notes.txt"])
        self.assertFalse(result["app"])
        self.assertFalse(result["panel"])

    def test_without_a_pr_every_existing_project_runs_CA_007_02(self) -> None:
        result = run(None)
        self.assertTrue(result["app"])
        self.assertTrue(result["panel"])

    def test_a_project_that_does_not_exist_yet_never_runs_CA_007_02(self) -> None:
        result = run(["panel/src/app/app.ts", "app/lib/main.dart"], exists={"app/pubspec.yaml"})
        self.assertTrue(result["app"])
        self.assertFalse(result["panel"])
        self.assertFalse(result["contract"])

    def test_the_cli_requires_a_base_for_a_pull_request_CA_007_02(self) -> None:
        err = io.StringIO()
        with redirect_stderr(err):
            self.assertEqual(2, detect_changes.main(["--event", "pull_request"]))
        self.assertIn("--base", err.getvalue())


class GateTests(unittest.TestCase):
    def test_a_failed_job_makes_the_gate_fail_CA_007_01(self) -> None:
        bad = gate.failures({"app": {"result": "failure"}, "panel": {"result": "skipped"}, "secrets": {"result": "success"}})
        self.assertEqual({"app": "failure"}, bad)

    def test_a_cancelled_or_unfinished_job_makes_the_gate_fail_CA_007_01(self) -> None:
        bad = gate.failures({"app": {"result": "cancelled"}, "sca": {"result": "failure"}})
        self.assertEqual({"app": "cancelled", "sca": "failure"}, bad)

    def test_success_and_skipped_jobs_let_the_gate_pass_CA_007_01(self) -> None:
        self.assertEqual({}, gate.failures({"app": {"result": "success"}, "panel": {"result": "skipped"}}))

    def test_the_gate_exit_code_is_1_when_the_app_tests_fail_CA_007_01(self) -> None:
        needs = '{"detect": {"result": "success"}, "app": {"result": "failure"}, "panel": {"result": "skipped"}}'
        with mock.patch.dict(os.environ, {"NEEDS": needs}), redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            self.assertEqual(1, gate.main())

    def test_the_gate_exit_code_is_0_when_everything_passes_or_does_not_apply_CA_007_01(self) -> None:
        needs = '{"detect": {"result": "success"}, "app": {"result": "success"}, "panel": {"result": "skipped"}}'
        with mock.patch.dict(os.environ, {"NEEDS": needs}), redirect_stdout(io.StringIO()):
            self.assertEqual(0, gate.main())


if __name__ == "__main__":
    unittest.main()
