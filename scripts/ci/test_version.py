#!/usr/bin/env python3
"""Pruebas de scripts/ci/version.py (spec 011, CA-01 a CA-04): versión por puntos, versionCode y etiqueta de puntos.

Uso: python scripts/ci/test_version.py (sin dependencias).
"""
from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import version  # noqa: E402


class VersionCodeTests(unittest.TestCase):
    def test_first_upload_of_1_1_2_gives_1010200_CA_011_01(self) -> None:
        self.assertEqual(1_010_200, version.version_code("1.1.2", 0))

    def test_first_version_first_upload_CA_011_01(self) -> None:
        self.assertEqual("1.0.0", version.FIRST_VERSION)
        self.assertEqual(1_000_000, version.version_code(version.FIRST_VERSION, 0))

    def test_code_is_x_y_z_n_weighted_CA_011_01(self) -> None:
        self.assertEqual(2_050_907, version.version_code("2.5.9", 7))
        self.assertEqual(3_000_000, version.version_code("3.0.0", 0))

    def test_second_upload_of_same_version_raises_n_and_code_CA_011_02(self) -> None:
        first = version.version_code("1.1.2", 0)
        second = version.version_code("1.1.2", 1)
        self.assertEqual(1_010_201, second)
        self.assertGreater(second, first)

    def test_code_grows_with_every_upload_CA_011_02(self) -> None:
        codes = [version.version_code("1.1.2", n) for n in range(version.N_MAX + 1)]
        self.assertEqual(sorted(set(codes)), codes)

    def test_n_limits_0_and_99_are_accepted_and_outside_rejected_CA_011_02(self) -> None:
        self.assertEqual(1_010_200, version.version_code("1.1.2", 0))
        self.assertEqual(1_010_299, version.version_code("1.1.2", 99))
        for bad in (-1, 100, True, 1.5):
            with self.assertRaises(ValueError, msg=str(bad)):
                version.version_code("1.1.2", bad)  # type: ignore[arg-type]

    def test_last_upload_of_a_version_stays_below_the_next_version_CA_011_02(self) -> None:
        self.assertLess(version.version_code("1.1.2", 99), version.version_code("1.1.3", 0))
        self.assertLess(version.version_code("1.0.9", 99), version.version_code("1.1.0", 0))
        self.assertLess(version.version_code("1.9.9", 99), version.version_code("2.0.0", 0))

    def test_code_grows_across_consecutive_bumps_CA_011_02(self) -> None:
        current, last = version.FIRST_VERSION, version.version_code(version.FIRST_VERSION, 0)
        for _ in range(250):
            current = version.bump(current, 3)
            code = version.version_code(current, 0)
            self.assertGreater(code, last, current)
            last = code

    def test_code_over_google_play_maximum_is_rejected_CA_011_02(self) -> None:
        self.assertEqual(2_099_090_999, version.version_code("2099.9.9", 99))
        self.assertEqual(2_100_000_000, version.version_code("2100.0.0", 0))
        with self.assertRaises(ValueError):
            version.version_code("2100.0.0", 1)

    def test_bad_versions_are_rejected_in_the_code_CA_011_01(self) -> None:
        for bad in ("1.0", "v1.0.0", "1.10.0", "1.0.10", "01.0.0", "1.0.0-rc.1", ""):
            with self.assertRaises(ValueError, msg=bad):
                version.version_code(bad, 0)


class BumpTests(unittest.TestCase):
    def test_points_table_matches_the_spec_R_03_CA_011_01(self) -> None:
        expected = {1: {"fix", "text-adjustment", "translation", "style"}, 2: {"new-field", "rule-change"}, 3: {"screen"},
                    5: {"full-feature"}, 10: {"external-integration", "phone-permission"}}
        for value, kinds in expected.items():
            self.assertEqual(kinds, {k for k, v in version.POINTS.items() if v == value})

    def test_a_screen_on_the_first_version_gives_1_0_3_CA_011_01(self) -> None:
        self.assertEqual("1.0.3", version.bump("1.0.0", version.POINTS["screen"]))

    def test_z_carries_into_y_at_ten_CA_011_01(self) -> None:
        self.assertEqual("1.1.0", version.bump("1.0.0", 10))
        self.assertEqual("1.1.0", version.bump("1.0.9", 1))
        self.assertEqual("1.1.2", version.bump("1.0.4", 8))

    def test_y_carries_into_x_like_z_into_y_CA_011_01(self) -> None:
        self.assertEqual("2.0.0", version.bump("1.9.9", 1))
        self.assertEqual("2.0.5", version.bump("1.9.8", 7))
        self.assertEqual("2.0.0", version.bump("1.0.0", 100))

    def test_breaking_change_raises_x_and_zeroes_y_and_z_CA_011_01(self) -> None:
        self.assertEqual("2.0.0", version.bump("1.4.7", 3, breaking=True))
        self.assertEqual(2_000_000, version.version_code(version.bump("1.4.7", 3, breaking=True), 0))

    def test_negative_points_and_bad_versions_are_rejected_CA_011_01(self) -> None:
        with self.assertRaises(ValueError):
            version.bump("1.0.0", -1)
        for bad in ("1.0", "v1.0.0", "1.10.0", "1.0.10", "01.0.0", "1.0.0-rc.1", ""):
            with self.assertRaises(ValueError, msg=bad):
                version.bump(bad, 1)

    def test_zero_points_do_not_change_the_version_CA_011_04(self) -> None:
        for current in ("1.0.0", "1.4.7", "3.9.9"):
            self.assertEqual(current, version.bump(current, 0))

    def test_zero_points_keep_the_version_and_a_new_upload_still_raises_the_code_CA_011_04(self) -> None:
        same = version.bump("1.1.2", 0)
        self.assertEqual("1.1.2", same)
        self.assertGreater(version.version_code(same, 1), version.version_code(same, 0))

    def test_zero_points_with_breaking_change_still_raises_x_CA_011_04(self) -> None:
        self.assertEqual("2.0.0", version.bump("1.4.7", 0, breaking=True))


class LabelTests(unittest.TestCase):
    def test_pr_without_points_label_fails_CA_011_03(self) -> None:
        self.assertTrue(version.check_labels([]))
        self.assertTrue(version.check_labels(["bug", "documentation"]))

    def test_pr_with_valid_points_label_passes_CA_011_03(self) -> None:
        self.assertEqual([], version.check_labels(["bug", "puntos-app-3"]))
        self.assertEqual([], version.check_labels(["puntos-landing-0"]))

    def test_malformed_or_unknown_label_fails_CA_011_03(self) -> None:
        for bad in ("puntos-app", "puntos-app-", "puntos-app-03", "puntos-app--1", "puntos-gateway-3",
                    "puntos-app-3x", "puntos-app-1000"):
            self.assertTrue(version.check_labels([bad]), bad)

    def test_valid_label_does_not_hide_a_malformed_one_CA_011_03(self) -> None:
        self.assertTrue(version.check_labels(["puntos-app-3", "puntos-panel-x"]))

    def test_two_labels_for_the_same_component_fail_CA_011_03(self) -> None:
        self.assertTrue(version.check_labels(["puntos-app-3", "puntos-app-1"]))

    def test_points_are_kept_per_component_R_01_CA_011_03(self) -> None:
        found, errors = version.parse_labels(["puntos-app-3", "puntos-landing-1"])
        self.assertEqual([], errors)
        self.assertEqual({"app": 3, "landing": 1}, found)

    def test_bot_branches_are_exempt_CA_011_03(self) -> None:
        self.assertEqual([], version.check_labels([], "release-please--branches--main"))
        self.assertEqual([], version.check_labels([], "dependabot/npm_and_yarn/x"))
        self.assertTrue(version.check_labels([], "feature/KNOCK-1-x"))

    def test_labels_json_must_be_a_list_of_strings_CA_011_03(self) -> None:
        self.assertEqual(["puntos-app-1"], version.load_labels('["puntos-app-1"]'))
        with self.assertRaises(ValueError):
            version.load_labels('{"a": 1}')
        with self.assertRaises(ValueError):
            version.load_labels("[1, 2]")


if __name__ == "__main__":
    unittest.main()
