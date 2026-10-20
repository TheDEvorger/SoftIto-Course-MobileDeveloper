# TASK-007: 20-slot evidence checklist

Date: 2026-10-20. Status: DONE.

## Implementation
Versioned demo-20-v1 template with 20 distinct required angles, explicit
missing/uploading/failed/received states, simulated receipts and per-slot human
review demo states. All 20 must be received and accepted before the inspection
can return success to handover; a retake requires a fresh sample upload.
UI can simulate failure of the next upload and retry any slot. No bulk bypass.
Snapshots are saved after each edit in an inspection-owned app-session store;
reopening restores accepted progress. Interrupted uploads restore as failed,
never successful. Version, booking context, slot count and malformed state are
validated. Handover's generic inspection checkbox was removed.

## Evidence
`flutter test test/inspection_test.dart test/handover_test.dart`: 7 passed
(3 inspection + 4 handover). Covers every required slot, retake, invalid slot,
receipt requirement, upload retries, interrupted restore, JSON round trip,
version/context/count mismatch, separate drafts and widget reopen behavior.
`flutter analyze`: no issues. Python quality gate: passed.
Initial analyzer notices (braces) corrected; widget assertion now scrolls to
its header after interacting with a lazily rendered card. Logs: logs/TASK-007/.

## Files and limits
Added inspections/domain/evidence_template.dart and evidence_draft.dart,
application/demo_inspection_store.dart, presentation/inspection_demo_screen.dart,
and test/inspection_test.dart. Updated app routing, handover UI and registry.
Data is synthetic; no camera, image files, permissions, network, EXIF, AI,
cryptographic proof, server receipt or liability assignment. Receipt IDs and
timestamps are explicitly labelled device-generated demo values. Resume works
within this app session; serialized reconstruction is tested but no disk
persistence is enabled. Native/device verification not performed.
Next: TASK-008 fleet workspace and role/context demo.
