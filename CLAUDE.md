# Working agreement

This repo is delivered with the `sfmate` + `mate-core` plugins (four agents across them; the operator orchestrates; CI is the only mechanical gate).

1. **Refine:** for new work, `mate-core:analyst` drafts a plain story on the GitHub issue — problem, 5–7 acceptance criteria as **rule + example** pairs, out-of-scope, and a `Build:` line (`standard` or `red-first — <why>`, judged from the code it grounded in). Before the operator sees it, `mate-core:reviewer` (work-item mode) attacks the draft against the plugin's work-item rules — an untestable or existence-only criterion is CRITICAL, an under-called `Build:` line is MAJOR — and findings go back to the analyst first. The operator edits or approves the reviewed body by reading it (overriding the rigor is editing one word). No labels, no stages.
2. **Build:** one git worktree + branch per issue, cut from `origin/main`. Spawn `sfmate:developer` with the issue, the working directory, and an org alias (scratch org per worktree — see the plugin's `org` skill; `lab/org-setup.sh` creates one). The issue's `Build:` line sets its discipline — red-first means failing tests before implementation; the developer may escalate itself to red-first when the code reveals unnamed risk, never downgrade. It implements, tests for real, and reports honestly — including what it could not verify.
3. **Review:** spawn `mate-core:reviewer` (read-only) on the committed diff with the work item, the developer's report, and the path to sfmate's `rules/` directory. Critical and major findings are fixed and the **delta** re-reviewed; **done is a post-fix re-review with zero critical / zero major — minors never block, and a fix agent's "fixed" claim never substitutes for the re-review.** The loop runs without the operator; consult them only for a contested finding, a fix that would change scope, or a loop not converging after two fix rounds.
4. **Ship:** push, open the PR, CI green on the pushed SHA, the operator merges.
5. **Always:** verification is real commands and real exit codes, never an agent's claim. When something hurts, one line in `NOTES.md`; a mechanism may be added only when the same line appears twice.

## Repo facts

- Tracker: GitHub Issues (`gh`).
- Salesforce DX project (dreamhouse fork). Org strategy: scratch orgs off the DevHub; `lab/org-setup.sh <alias>` provisions one.
- CI: `.github/workflows/ci.yml` (prettier, lint, LWC unit tests). Org-based validation per the plugin's `cicd` skill templates is a candidate once DevHub secrets are configured — see the plugin README.
- `npm run test:unit` for LWC; Apex tests run against the org via `sf apex run test` (always `--wait`).
