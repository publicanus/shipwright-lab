# Working agreement

The working agreement — proportionality, triage, refine, build, review, ship, and the `NOTES.md` ledger duty — is injected into every session by the sfmate plugin (single-sourced in the plugin's `agreement.md`; amendments are PRs on publicanus/sfmate, never a local copy). The lines below are this repo's configuration, which the agreement defers to.

- Tracker: GitHub Issues in this repo, via `gh`.
- Orgs: scratch orgs from the DevHub, one per worktree — `lab/org-setup.sh <alias>` provisions one.

## Repo facts

- Salesforce DX project (dreamhouse fork).
- CI: `.github/workflows/ci.yml` (prettier, lint, LWC unit tests). Org-based validation per the plugin's `cicd` skill templates is a candidate once DevHub secrets are configured — see the plugin README.
- `npm run test:unit` for LWC; Apex tests run against the org via `sf apex run test` (always `--wait`).
