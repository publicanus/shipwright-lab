# Working agreement

This repo is delivered with the `sfmate` plugin (four agents; the operator orchestrates; CI is the only mechanical gate).

1. **Refine:** for new work, `sfmate:analyst` drafts a plain story on the GitHub issue — problem, 5–7 observable acceptance criteria, out-of-scope. Jaap edits or approves by reading it. No labels, no stages.
2. **Build:** one git worktree + branch per issue, cut from `origin/main`. Spawn `sfmate:developer` with the issue, the working directory, and an org alias (scratch org per worktree — see the plugin's `org` skill; `lab/org-setup.sh` creates one). It implements, writes economy tests, runs the blast-radius Apex tests for real, and reports honestly — including what it could not verify. For work Jaap judges risky: failing tests first, then implement.
3. **Review:** spawn `sfmate:reviewer` (read-only) on the committed diff with the work item and the developer's report. Fix findings conversationally; re-review the delta. Jaap decides when it's done.
4. **Ship:** push, open the PR, CI green on the pushed SHA, Jaap merges.
5. **Always:** verification is real commands and real exit codes, never an agent's claim. When something hurts, one line in `NOTES.md`; a mechanism may be added only when the same line appears twice.

## Repo facts

- Salesforce DX project (dreamhouse fork). Org strategy: scratch orgs off the DevHub; `lab/org-setup.sh <alias>` provisions one.
- CI: `.github/workflows/ci.yml` (prettier, lint, LWC unit tests). Org-based validation per the plugin's `cicd` skill templates is a candidate once DevHub secrets are configured — see the plugin README.
- `npm run test:unit` for LWC; Apex tests run against the org via `sf apex run test` (always `--wait`).
