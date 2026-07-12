# 2026-07-12 — #1 price-per-square-meter

- shipwright: 4.0.0 (released, project pin)
- tier: M
- intent: lab/intents/price-per-square-meter.md

## Per-gate observations

- Seeding: `lab/seed.sh` hit "repository has disabled issues" — forks disable issues by
  default (as they disable Actions). Enabled via `gh api -X PATCH … has_issues=true`;
  seeder then created #1 cleanly. Fixture-setup finding, not a framework one.
- Refine: resume check `fresh`; grounding surfaced the real shape (no area field exists,
  no sort UI anywhere, `ORDER BY Price__c` hard-coded) and fed four grill questions
  (display surfaces, sort-control placement, units, sample data) — operator took all four
  recommended defaults. `resolve_type` returned `unknown` (seeded issues carry no type
  label) → business-analyst writer, correct for an actor-bearing story.
- Draft round 1: BA posted a 7.9 KB body; `verify-draft-landed` OK. Reviewer came back
  clean round 1 (0 findings, 15 rules applied, proof-of-read validated). No revise round.
- Labels auto-set and verified: `stack:salesforce`, `change:code`, `risk:medium`, no
  design signal. `stage:refined` verified.
- Body gate: operator asked whether the ACs' testing can be automated before approving —
  answered per-rule (Apex: formula + nulls-last sort; lwc-jest: tile/summary/filter + sort
  control; human-verify: end-to-end visual in the org). Approved without body changes.

- Build (in progress): prerequisites clean (`stage=refined`, no `pipeline:running`); worktree
  `shipwright-lab-1` cut from origin/main at the baseline tip; routing resolved
  `tier=medium / change=code / shipwright:salesforce-developer` from the labels alone (no
  file guessing). Approach gate skipped (medium, no open design questions), prober skipped
  (medium — implementer owns tests), review gate resolved to 1 round + 1 delta fix round.
- Org gate did NOT fire (environment.setup configured) — `lab/org-setup.sh` worked first
  try: scratch org `shipwright-lab-1` created off the DevHub (Active, 1-day), alias
  persisted to `.pipeline/org-alias` for teardown.

- Implementer blocked itself before writing anything: the body file I handed it held a
  DIFFERENT repo's issue #1. Root cause: `tracker.sh read` resolves the GitHub repo from the
  shell's cwd (via `gh`), not from `CLAUDE_PROJECT_DIR` — I ran the read from the shipwright
  dev checkout, so it fetched shipwright#1. Two findings: (a) framework — tracker.sh should
  pin the repo explicitly (e.g. `gh -R` from config) instead of inheriting cwd; candidate
  backlog item; (b) framework win — the developer's contradiction-stop HARD RULE fired
  exactly as designed (it cross-checked the body against the codebase and parked instead of
  improvising). Fixed by regenerating the file from the lab repo; implementer resumed.

- Implement: developer delivered 19 files (+446/−53) — Living_Area__c + Price_Per_Sqm__c
  formula field, FLS, layout, tile/summary display, filter-panel sort with whitelisted
  ORDER BY + NULLS LAST, sample data, 2 new Apex tests + jest updates. Completion report
  passed `validateStructuredReturn`. Ground-truth check caught a wrinkle: the on-disk Apex
  artifact was a STALE mid-development "Failed 4/6" run; an independent re-run confirmed
  6/6 — claim true, artifact misleading. Gate on a fresh run, not the newest file found.
- Verify: floor re-check no escalation; Code Analyzer exit 0 (0 high-sev); lint/shellcheck
  skipped appropriately; test_commands green (prettier, eslint, 89/89 jest).
- Review round 1 (reviewer, read-only, diff by path): 1 CRITICAL (rule-anchored dry),
  3 MAJOR (undispositioned PMD ApexSOQLInjection on new code; a fabricated
  nonBehavioralAcs entry not verbatim from the body; weak currency assertion), 6 minor.
  Substantive, grounded findings — the test-quality and challenge duties both fired.
- Fix round: all critical/major fixed + cheap minors swept (incl. an empirical in-org
  probe of the zero-area formula: renders blank, no guard needed; and a self-caught
  inclusive-language lint on its own comment). Fix agent returned PROSE instead of the
  JSON report contract (hygiene finding). Pre-commit then failed: prettier-apex cannot
  print a comment placed between two annotations — moved the comment above the
  annotations; a fixture-level quirk worth remembering for SF repos with prettier hooks.
- Delta re-review dispatched to the SAME reviewer (resume-by-id with carried-forward
  verdicts + falsifiable re-check assertions), per the delta-injection discipline.

- Ship: CI green on the pushed SHA (`static-sanity`, ancestor-verified 548e4c0); operator
  approved squash-merge at the gate; PR #2 MERGED (f9bd24e), issue #1 auto-closed and
  `stage:done` verified; worktree AND scratch org torn down by `worktree-cleanup.sh`
  (alias read from `.pipeline/org-alias`) — reset-by-design confirmed end to end.

## Cost

Build cost: 4 agent spawns, 2 review rounds, ~1216s park-free wall-clock (PR body line).
Plus refine: 2 subagents (writer + reviewer, both clean round 1). Operator time: 4 grill
answers, 1 test-automation question, body approval, merge click. Whole run ≈ 2.5 h
wall-clock including one orchestrator-error recovery.

## Deviations

1. `tracker.sh read` resolves the GitHub repo from the shell's cwd (`gh` inheritance), not
   `CLAUDE_PROJECT_DIR` — handed the implementer another repo's issue body. Framework
   finding (pin the repo explicitly); the developer's contradiction-stop caught it.
2. Implementer left a stale FAILED Apex artifact on disk while claiming green — an
   independent re-run confirmed green, but gate-on-artifact needs "artifact OF the final
   run", not "newest artifact found".
3. Fix agent returned prose instead of the JSON completion-report contract.
4. prettier-apex cannot print a comment between annotations — pre-commit hook rejected the
   fix commit until the comment moved above the annotation block. SF-fixture quirk.
5. Fork defaults bit twice at setup (Actions disabled, Issues disabled) — now fixed in repo
   settings, won't recur.
6. `impl-lab-1` idle-notification arrived reading as a stall while the agent was actually
   done; one redundant nudge sent. Completion-report delivery vs. idle signals is noisy.

## Verdict

**Pass with findings.** The full product path (refine → build → ship) ran end to end on a
real Salesforce scratch org with every human gate exercised and every ground-truth gate
honest (stale-artifact catch included). All deviations are framework/report-hygiene
findings for the shipwright backlog, not blockers; the feature itself merged clean with a
substantive adversarial review (1 critical + 3 major found and fixed).
