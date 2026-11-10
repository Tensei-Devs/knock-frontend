#!/usr/bin/env python3
"""Pruebas estáticas de los workflows de la spec 007: publicación en Google Play (R-04, R-05, R-06, CA-03) y `ci-pr` (R-01 a R-03).

Leen el texto de `.github/workflows/*.yml` (sin dependencias). Que la versión aparezca de verdad en la pista interna
(CA-03, humo) solo se comprueba ejecutando el workflow con los secretos reales: ver docs/PUBLICACION_ANDROID.md.

Uso: python scripts/ci/test_publish_workflow.py
"""
from __future__ import annotations

import re
import unittest
from pathlib import Path

WORKFLOWS = Path(__file__).resolve().parents[2] / ".github" / "workflows"
PUBLISH = (WORKFLOWS / "publish-android.yml").read_text(encoding="utf-8")
CI = (WORKFLOWS / "ci-pr.yml").read_text(encoding="utf-8")
CODE = "\n".join(line for line in PUBLISH.splitlines() if not line.lstrip().startswith("#"))  # sin comentarios
USES = re.compile(r"^\s*-?\s*uses:\s*(\S+)@(\S+)", re.M)


def jobs(text: str) -> dict[str, str]:
    """Texto de cada job de primer nivel (clave bajo `jobs:`)."""
    body = text.split("\njobs:\n", 1)[1]
    parts = re.split(r"^  ([A-Za-z0-9_-]+):\s*$", body, flags=re.M)
    return {parts[i]: parts[i + 1] for i in range(1, len(parts) - 1, 2)}


class PublishTrackTests(unittest.TestCase):
    def test_the_release_goes_to_the_internal_track_only_CA_007_03(self) -> None:
        self.assertEqual(["internal"], re.findall(r"^\s*track:\s*(\S+)", PUBLISH, re.M))
        for stage in ("production", "alpha", "beta"):
            self.assertNotRegex(PUBLISH, rf"track:\s*{stage}")

    def test_the_package_and_the_signed_bundle_are_published_CA_007_03(self) -> None:
        self.assertIn("packageName: app.knock.mobile", PUBLISH)
        self.assertIn("releaseFiles: aab/app-release.aab", PUBLISH)
        self.assertIn("flutter build appbundle --release", PUBLISH)

    def test_the_publish_job_waits_for_the_build_and_the_tag_waits_for_the_publish_CA_007_03(self) -> None:
        j = jobs(PUBLISH)
        self.assertIn("needs: build", j["publish"])
        self.assertIn("needs: [build, publish]", j["tag"])


class PublishGuardTests(unittest.TestCase):
    def test_it_only_runs_on_main_after_a_green_ci_or_by_hand_from_main_R_05(self) -> None:
        head = PUBLISH.split("\njobs:\n", 1)[0]
        self.assertRegex(head, r"workflow_run:\s*\n\s+workflows: \[ci-pr\]\s*\n\s+types: \[completed\]\s*\n\s+branches: \[main\]")
        cond = jobs(PUBLISH)["build"]
        self.assertIn("github.event.workflow_run.conclusion == 'success'", cond)
        self.assertIn("github.event.workflow_run.event == 'push'", cond)
        self.assertIn("github.ref == 'refs/heads/main'", cond)

    def test_it_builds_the_commit_that_passed_the_ci_R_05(self) -> None:
        self.assertIn("github.event.workflow_run.head_sha", PUBLISH)
        self.assertRegex(PUBLISH, r"ref:\s*\$\{\{ steps\.src\.outputs\.sha \}\}")

    def test_it_refuses_to_publish_without_the_signing_secrets_or_with_the_debug_key_R_05(self) -> None:
        for secret in ("ANDROID_KEYSTORE_BASE64", "ANDROID_KEYSTORE_PASSWORD", "ANDROID_KEY_ALIAS", "ANDROID_KEY_PASSWORD", "PLAY_SERVICE_ACCOUNT_JSON"):
            self.assertIn(f"secrets.{secret}", PUBLISH)
        self.assertIn("Faltan GitHub Secrets", PUBLISH)
        self.assertIn("Android Debug", PUBLISH)

    def test_secrets_only_enter_through_env_or_with_never_through_a_script_R_05(self) -> None:
        for line in PUBLISH.splitlines():
            if "${{ secrets." in line:
                self.assertRegex(line, r"^\s+[A-Za-z0-9_]+:\s*\$\{\{ secrets\.[A-Z0-9_]+ \}\}\s*$", line)

    def test_it_never_depends_on_azure_container_registry_tasks_R_05(self) -> None:
        self.assertNotRegex(CODE, r"az\s+acr|azure/login")


class WorkflowHardeningTests(unittest.TestCase):
    def test_every_action_is_pinned_to_a_full_sha_R_04(self) -> None:
        refs = USES.findall(PUBLISH)
        self.assertGreaterEqual(len(refs), 5)
        for action, ref in refs:
            if action.startswith("./"):
                continue
            self.assertRegex(ref, r"^[0-9a-f]{40}$", f"{action}@{ref}")

    def test_permissions_are_read_only_except_for_the_tag_job_R_04(self) -> None:
        head = PUBLISH.split("\njobs:\n", 1)[0]
        self.assertRegex(head, r"\npermissions:\n  contents: read\n")
        j = jobs(PUBLISH)
        self.assertNotIn("contents: write", j["build"])
        self.assertNotIn("contents: write", j["publish"])
        self.assertIn("contents: write", j["tag"])
        self.assertEqual(1, PUBLISH.count("contents: write"))

    def test_the_publication_is_serialized_so_versions_do_not_race_R_05(self) -> None:
        self.assertRegex(PUBLISH, r"concurrency:\n  group: publish-android\n  cancel-in-progress: false")


class CiPrTests(unittest.TestCase):
    def test_the_gate_waits_for_every_check_including_secrets_dependencies_and_the_landing_R_01(self) -> None:
        needs = re.search(r"^    needs: \[([^\]]+)\]\s*$", jobs(CI)["gate"], re.M)
        self.assertIsNotNone(needs)
        names = {n.strip() for n in needs.group(1).split(",")}
        self.assertTrue({"app", "panel", "secrets", "sca", "sast", "landing", "governance"} <= names, names)

    def test_the_app_and_panel_jobs_only_run_when_the_detector_says_so_R_02(self) -> None:
        j = jobs(CI)
        self.assertIn("needs.detect.outputs.app == 'true'", j["app"])
        self.assertIn("needs.detect.outputs.panel == 'true'", j["panel"])
        self.assertIn("scripts/ci/detect_changes.py", j["detect"])

    def test_the_app_job_runs_pub_get_analyze_format_and_tests_with_coverage_R_01(self) -> None:
        app = jobs(CI)["app"]
        for step in ("flutter pub get", "dart format", "flutter analyze", "flutter test --coverage"):
            self.assertIn(step, app)

    def test_the_panel_job_runs_ci_install_lint_tests_and_build_R_02(self) -> None:
        panel = jobs(CI)["panel"]
        for step in ("npm ci", "ng lint", "ng test", "ng build"):
            self.assertIn(step, panel)

    def test_secrets_and_dependencies_are_audited_R_03(self) -> None:
        j = jobs(CI)
        self.assertIn("gitleaks", j["secrets"].lower())
        self.assertIn("dependency-review-action", j["sca"])
        self.assertIn("osv-scanner", j["sca"].lower())

    def test_the_ci_workflow_is_also_pinned_and_read_only_R_04(self) -> None:
        for action, ref in USES.findall(CI):
            if not action.startswith("./"):
                self.assertRegex(ref, r"^[0-9a-f]{40}$", f"{action}@{ref}")
        self.assertRegex(CI.split("\njobs:\n", 1)[0], r"\npermissions:\n  contents: read\n")


if __name__ == "__main__":
    unittest.main()
