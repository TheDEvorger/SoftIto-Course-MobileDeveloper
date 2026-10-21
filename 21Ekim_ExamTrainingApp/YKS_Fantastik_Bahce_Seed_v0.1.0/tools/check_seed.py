#!/usr/bin/env python3
"""Seed dosyalarının varlığını / orijinal görsel hashlerini stdlib ile doğrular."""
from pathlib import Path
from hashlib import sha256
import json, sys
root=Path(__file__).resolve().parents[1]
m=json.loads((root/'assets/illustrations/asset_manifest.json').read_text(encoding='utf-8'))
required=[
'AGENTS.md','ANTIGRAVITY_ILK_PROMPT.txt','20_yks_calisma_uygulamasi.md',
'pubspec.yaml','lib/main.dart','docs/agent/task_board.md',
'design/references/approved_ui_direction.png'
]
issues=[]
for f in required:
    if not (root/f).is_file(): issues.append(f'Missing: {f}')
if len(m['scenes'])!=10: issues.append(f'Expected 10 scenes, got {len(m["scenes"])}')
for s in m['scenes']:
    o=root/s['original']; a=root/s['app_asset']
    if not o.is_file(): issues.append(f'Missing PNG: {o}')
    elif sha256(o.read_bytes()).hexdigest()!=s['source_sha256']:
        issues.append(f'Hash mismatch: {o}')
    if not a.is_file() or a.stat().st_size==0: issues.append(f'Missing WEBP: {a}')
for task_file in sorted((root/'docs/agent/tasks').glob('TASK-*.md')):
    if not task_file.read_text(encoding='utf-8').strip(): issues.append(f'Empty task {task_file.name}')
if issues:
    print('SEED FAIL\n'+'\n'.join(issues)); sys.exit(1)
print(f'SEED OK | {len(m["scenes"])} distinct PNG + WebP scenes | {len(list((root/"docs/agent/tasks").glob("TASK-*.md")))} TASK files')
