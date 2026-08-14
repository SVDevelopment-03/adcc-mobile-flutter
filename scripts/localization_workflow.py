#!/usr/bin/env python3
"""Helpers for the repo-specific localization pass.

This tool enforces the project's file-by-file workflow instead of doing a
blind repo-wide localization pass.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path


def parse_pending_files(map_path: Path) -> list[str]:
    text = map_path.read_text(encoding='utf-8')
    pattern = re.compile(r"^\s*-\s+\[(.*?)\]\((.*?)\)", re.MULTILINE)
    items = []
    for match in pattern.finditer(text):
        label = match.group(1)
        path = match.group(2)
        if "✅" in label:
            continue
        if path.strip():
            items.append(path)
    return items


def parse_completed_files(map_path: Path) -> list[str]:
    text = map_path.read_text(encoding='utf-8')
    pattern = re.compile(r"^\s*✅\s+\[(.*?)\]\((.*?)\)", re.MULTILINE)
    items = []
    for match in pattern.finditer(text):
        path = match.group(2)
        if path.strip():
            items.append(path)
    return items


def run_cmd(cmd: list[str], cwd: Path) -> int:
    print(f"\n> {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=str(cwd), shell=True if sys.platform == 'win32' else False)
    return result.returncode


def handle_next(args: argparse.Namespace) -> int:
    project_root = Path(args.project_root).resolve()
    map_path = project_root / "text_usage_map.md"
    pending = parse_pending_files(map_path)
    if not pending:
        print("No pending localization files found.")
        return 0
    print(pending[0])
    return 0


def handle_list(args: argparse.Namespace) -> int:
    project_root = Path(args.project_root).resolve()
    map_path = project_root / "text_usage_map.md"
    pending = parse_pending_files(map_path)
    if not pending:
        print("No pending localization files found.")
        return 0
    for idx, item in enumerate(pending, start=1):
        print(f"{idx}. {item}")
    return 0


def handle_validate(args: argparse.Namespace) -> int:
    project_root = Path(args.project_root).resolve()
    map_path = project_root / "text_usage_map.md"
    files = args.files
    if not files:
        files = parse_pending_files(map_path)
    if not files:
        print("No files to validate.")
        return 0

    gen = run_cmd(["flutter", "gen-l10n"], project_root)
    if gen != 0:
        return gen

    analyze = run_cmd(["dart", "analyze", *files], project_root)
    return analyze


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Automation helper for the repo-specific localization workflow."
    )
    parser.add_argument("--project-root", default=".", help="Project root directory")
    sub = parser.add_subparsers(dest="command")

    sub.add_parser("next", help="Print the next pending file from text_usage_map.md")
    sub.add_parser("list", help="List pending files in order")

    validate = sub.add_parser("validate", help="Run flutter gen-l10n and dart analyze for files")
    validate.add_argument("files", nargs="*", help="Files to analyze; default is all pending files")

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 0

    if args.command == "next":
        return handle_next(args)
    if args.command == "list":
        return handle_list(args)
    if args.command == "validate":
        return handle_validate(args)

    parser.print_help()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
