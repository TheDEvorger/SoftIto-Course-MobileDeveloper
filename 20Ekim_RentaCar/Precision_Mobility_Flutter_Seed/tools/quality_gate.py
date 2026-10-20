"""Check authored repository files for hard size cap and core structure."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAX_LINES = 300
SUFFIXES = {'.dart', '.md', '.yaml', '.yml', '.json', '.py', '.sh', '.ps1', '.xml', '.html', '.css', '.js', '.ts'}
SKIP_DIRS = {'.git', '.dart_tool', 'build', '.idea', '.pub', '.gradle', '.swiftpm', 'Pods', 'Flutter', 'ephemeral', 'Generated.xcconfig', 'generated'}
SKIP_FILES = {'pubspec.lock', 'package-lock.json', 'Podfile.lock', 'gradle-wrapper.properties', 'gradlew', 'gradlew.bat'}
REQUIRED = ['AGENTS.md', 'pubspec.yaml', 'lib/main.dart', 'tasks/INDEX.md', 'docs/product/vision.md']

def check() -> int:
    violations = []
    checked = 0
    for path in ROOT.rglob('*'):
        if not path.is_file() or path.suffix not in SUFFIXES:
            continue
        rel = path.relative_to(ROOT)
        if any(part in SKIP_DIRS for part in rel.parts) or path.name in SKIP_FILES:
            continue
        if path.name.startswith('generated_') or path.name.endswith('.g.dart') or path.name.endswith('.freezed.dart'):
            continue
        try:
            line_count = len(path.read_text(encoding='utf-8').splitlines())
        except UnicodeDecodeError:
            continue
        checked += 1
        if line_count > MAX_LINES:
            violations.append(f'{rel}: {line_count} lines (max {MAX_LINES})')
    for item in REQUIRED:
        if not (ROOT / item).exists():
            violations.append(f'missing: {item}')
    print(f'Checked {checked} authored text files; cap {MAX_LINES}.')
    if violations:
        print('FAIL:')
        print('\n'.join(violations))
        return 1
    print('PASS: authored file boundaries and required files.')
    return 0

if __name__ == '__main__':
    raise SystemExit(check())
