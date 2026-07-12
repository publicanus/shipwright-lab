# Lab runbook

This repository is shipwright's Salesforce laboratory: a real SF codebase (Dreamhouse) where
the full pipeline — refine → build → ship → retro — runs end-to-end against a real scratch
org, as a piloted exercise with the operator present at every human gate. This runbook is the
test spec: what a run looks like, what to observe at each stage, and how the lab resets.

A run is **piloted, never unattended**. The pipeline's human gates (refine body approval,
build parks, merge click) are load-bearing — they are exactly where the operator watches.
There are no auto-approve shims, and none should be built.

## Scenario tiers

Pick the smallest tier that answers the question the run is asking.

| Tier | Path                                                  | When                                     | Rough cost |
| ---- | ----------------------------------------------------- | ---------------------------------------- | ---------- |
| S    | `/build` only, on a pre-refined seeded issue          | Default for experiments                  | ~30–60 min |
| M    | `/refine` → `/build` → `/ship`                        | The product path; integration validation | ~1.5–2.5 h |
| L    | Full incl. `/retro`, or A/B across a framework change | Release validation only                  | ~3 h+      |

## Reset ritual

Every run starts from a known state on all three axes:

- **Code** — start from the `baseline` tag (`git checkout baseline` for reference; runs build
  in worktrees off fresh `origin/main`, which equals `baseline` unless deliberately
  re-baselined). Experiment branches never merge to `main` without re-tagging a new
  `baseline` on purpose.
- **Tracker** — issues are never reused. Each run seeds a fresh issue from an intent file:
  `lab/seed.sh lab/intents/<intent>.md`. Old issues stay as the historical trail.
- **Org** — `org_strategy: scratch`: a scratch org is created per build worktree and deleted
  with it by the pipeline's own cleanup. Nothing to reset by hand.

## Run protocol

1. **Choose** an intent (`lab/intents/`) and a tier.
2. **Seed**: `lab/seed.sh lab/intents/<intent>.md` → note the fresh issue number.
3. **Fly** the tier's stages, answering the gates as the operator:
    - `/refine <N>` — answer the grill, approve (or correct) the drafted body.
    - `/build <N>` — watch parks; answer the org gate if it fires.
    - `/ship <N>` — review the PR, click the merge.
    - `/retro <N>` (L tier) — read the retrospective for honesty.
4. **Record**: write `lab/runs/<date>-<issue>-<slug>.md` (template below) as observations
   happen, not from memory afterwards.
5. **Route findings**: framework defects go to the shipwright backlog (by the operator);
   lab-fixture defects become plain commits here plus a deliberate re-baseline.

## Per-stage expected observables

- **refine** — issue carries `stage:refined` plus agent-set `stack:*`, `change:*`, and risk
  tier labels; body passed the work-item reviewer; operator approved the body at the gate.
- **build** — a worktree and scratch org exist during the run; PR opened from the issue
  branch; verify trail (static analysis) and review trail (rule-anchored findings, severities,
  re-review verdict) visible in the run output; issue reaches `stage:in-review`.
- **ship** — CI green on the pushed SHA; merge is a human click (`merge_policy: manual`);
  issue closed and `stage:done`; worktree and scratch org cleaned up after merge.
- **retro** — retrospective committed under `retrospectives/`, with the four anti-bias
  sections present and per-AC verdicts.

Any deviation from these observables is a finding — write it down even when the run
still succeeds.

## Experiment lever (framework A/B)

The lab normally runs the RELEASED shipwright version pinned for this project. To test a
framework change: register the dev checkout as a local plugin in this project
(`claude plugin marketplace add <dev-checkout> --scope project`, then install — see
shipwright's CONTRIBUTING.md dev-env steps) pointing at the shipwright branch under test,
run the same intent at the same tier, and compare the two runs' notebook entries.

## Notebook entry template (`lab/runs/<date>-<issue>-<slug>.md`)

```markdown
# <date> — #<issue> <slug>

- shipwright: <version or dev branch>
- tier: S | M | L
- intent: lab/intents/<file>

## Per-gate observations

<one bullet per gate/stage: what fired, what the operator answered, anything off>

## Cost

<the PR body's cost line, plus wall-clock>

## Deviations

<every mismatch against the runbook's expected observables — or "none">

## Verdict

<pass / pass-with-findings / fail, one sentence why>
```

## Known configuration notes

- Verify for the salesforce stack uses shipwright's framework default (static Code Analyzer
  over `force-app`) — deliberately not overridden in `shipwright.json`. Developers run
  blast-radius Apex tests in-build; the full regression belongs to CI/ship.
- `environment.setup` is wired to `lab/org-setup.sh`, which delegates to shipwright's own
  scratch recipe (`sf-env-setup.sh`): per-worktree alias, create-if-missing, deleted with the
  worktree. Settled at setup rather than left to the build's org gate, because that gate can
  only verify an org that already exists — it cannot create the per-run scratch org this lab
  depends on, and hand-creating one per run is exactly the toil the lab avoids.
