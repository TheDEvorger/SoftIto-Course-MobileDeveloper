"""Enforce the strict <=250 line rule for all MeHEnG-authored text files."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
LIMIT = 250
SKIP_DIRS = {
    '.git', '.dart_tool', 'build', '.idea', '.vscode',
    '.gradle', '.pub-cache', 'coverage',
    # Created and owned by flutter tooling. Must be inventoried separately.
    'android', 'windows', 'ios', 'linux', 'macos', 'web',
}
SKIP_FILES = {'pubspec.lock', '.flutter-plugins-dependencies'}
ALLOWED = {'.dart', '.md', '.yaml', '.yml', '.json', '.py', '.ps1',
           '.txt', '.gitignore'}


def authored_files():
    for path in ROOT.rglob('*'):
        if not path.is_file():
            continue
        if any(part in SKIP_DIRS for part in path.relative_to(ROOT).parts):
            continue
        if path.name in SKIP_FILES:
            continue
        if path.suffix in ALLOWED or path.name == '.gitignore':
            yield path


def check():
    violations = []
    files = sorted(authored_files())
    for path in files:
        text = path.read_text(encoding='utf-8')
        count = len(text.splitlines())
        if count > LIMIT:
            violations.append((path.relative_to(ROOT), count))
    for path, count in violations:
        print(f'FAIL {path}: {count} lines > {LIMIT}')
    print(f'Checked {len(files)} authored files, {len(violations)} over limit.')
    print('Platform-generated files and pubspec.lock require separate inventory.')
    return not violations


if __name__ == '__main__':
    sys.exit(0 if check() else 1)
