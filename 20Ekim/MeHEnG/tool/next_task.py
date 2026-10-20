"""Display the next available task; do not modify files or spawn agents."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
BACKLOG = ROOT / 'tasks' / 'backlog'
DONE = ROOT / 'tasks' / 'done'


def main():
    completed = {p.stem.split('-')[1] for p in DONE.glob('TASK-*.md')}
    for task in sorted(BACKLOG.glob('TASK-*.md')):
        text = task.read_text(encoding='utf-8')
        status = re.search(r'^Status:\s*(.+)$', text, re.M)
        depends = re.search(r'^Depends:\s*(.*)$', text, re.M)
        deps = re.findall(r'TASK-(\d+)', depends.group(1) if depends else '')
        if status and status.group(1).strip() in ('ready', 'blocked') and all(
            dependency in completed for dependency in deps
        ):
            print(f'Next eligible: {task.relative_to(ROOT)}')
            return
    print('No eligible task: check dependencies in tasks/INDEX.md.')


if __name__ == '__main__':
    main()
