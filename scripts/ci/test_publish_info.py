#!/usr/bin/env python3
"""Pruebas de scripts/ci/publish_info.py (spec 007, R-05 y CA-03; versionCode de la spec 011).

Uso: python scripts/ci/test_publish_info.py (sin dependencias).
"""
from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import publish_info  # noqa: E402
import version  # noqa: E402


class PubspecVersionTests(unittest.TestCase):
    def test_the_version_is_read_with_or_without_a_build_number_CA_007_03(self) -> None:
        self.assertEqual("1.0.0", publish_info.pubspec_version("name: app\nversion: 1.0.0+1\npublish_to: 'none'\n"))
        self.assertEqual("1.2.3", publish_info.pubspec_version("version: 1.2.3\n"))

    def test_a_pubspec_without_a_valid_version_is_rejected_CA_007_03(self) -> None:
        for text in ("name: app\n", "version: 1.0\n", "version: 1.10.0\n", "version: abc\n"):
            with self.assertRaises(ValueError, msg=text):
                publish_info.pubspec_version(text)


class NextUploadTests(unittest.TestCase):
    def test_the_first_upload_of_a_version_is_n_0_CA_007_03(self) -> None:
        self.assertEqual(0, publish_info.next_upload([], "1.0.0"))
        self.assertEqual(0, publish_info.next_upload(["app-v0.9.0-n3", "panel-v1.0.0-n0"], "1.0.0"))

    def test_each_upload_of_the_same_version_raises_n_by_one_CA_007_03(self) -> None:
        self.assertEqual(1, publish_info.next_upload(["app-v1.0.0-n0"], "1.0.0"))
        self.assertEqual(3, publish_info.next_upload(["app-v1.0.0-n0", "app-v1.0.0-n2", "app-v1.0.0-n1"], "1.0.0"))

    def test_a_tag_of_another_version_or_with_another_shape_is_ignored_CA_007_03(self) -> None:
        tags = ["app-v1.0.1-n7", "app-v1.0.0", "app-v1.0.0-nx", "app-v1.0.0-n1-rc"]
        self.assertEqual(0, publish_info.next_upload(tags, "1.0.0"))

    def test_the_version_code_never_repeats_and_always_grows_CA_007_03(self) -> None:
        codes = [version.version_code("1.0.0", publish_info.next_upload([f"app-v1.0.0-n{k}" for k in range(n)], "1.0.0")) for n in range(5)]
        self.assertEqual([1_000_000, 1_000_001, 1_000_002, 1_000_003, 1_000_004], codes)
        self.assertEqual(sorted(set(codes)), codes)

    def test_more_than_100_uploads_of_one_version_are_rejected_CA_007_03(self) -> None:
        tags = [f"app-v1.0.0-n{k}" for k in range(100)]
        n = publish_info.next_upload(tags, "1.0.0")
        with self.assertRaises(ValueError):
            version.version_code("1.0.0", n)


if __name__ == "__main__":
    unittest.main()
