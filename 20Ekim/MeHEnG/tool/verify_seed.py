"""Run integrity checks available even without Flutter SDK."""
from pathlib import Path
import re
import sys
from check_limits import check

ROOT = Path(__file__).resolve().parents[1]
SKILLS = ROOT / '.agents' / 'skills'
TASKS = ROOT / 'tasks' / 'backlog'


def verify():
    errors = []
    if not check():
        errors.append('File size check failed')
    for skill in SKILLS.glob('*/SKILL.md'):
        content = skill.read_text(encoding='utf-8')
        if not content.startswith('---\nname: '):
            errors.append(f'Missing Skill frontmatter: {skill}')
        if not re.search(r'\ndescription: .+\n---\n', content):
            errors.append(f'Missing Skill description: {skill}')
    for task in TASKS.glob('TASK-*.md'):
        content = task.read_text(encoding='utf-8')
        for field in ('Status:', 'Depends:', '## Acceptance', '## Verify'):
            if field not in content:
                errors.append(f'{task.name}: missing {field}')
    expected = {
        'lib/main.dart', 'lib/core/database/app_database.dart',
        'lib/features/ventures/domain/venture.dart',
        'lib/features/discover/domain/evidence.dart',
        'AGENTS.md', 'ANTIGRAVITY_PROMPT_TR.md',
    }
    for path in expected:
        if not (ROOT / path).exists():
            errors.append(f'Missing {path}')
    if errors:
        for error in errors:
            print('FAIL:', error)
        return False
    print(f'PASS: {len(list(SKILLS.glob("*/SKILL.md")))} skills, '
          f'{len(list(TASKS.glob("TASK-*.md")))} tasks, required files.')
    return True


if __name__ == '__main__':
    sys.exit(0 if verify() else 1)
