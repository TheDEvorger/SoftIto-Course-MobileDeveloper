# Rule: file-limits

All authored text files must be at most 300 physical lines. Aim 100–200 for Dart and 40–120 for Markdown. Split by cohesive responsibility, not arbitrary line count. Auto-generated platform artifacts and dependency locks are not hand-split. Run `python tools/quality_gate.py` after any changes.
