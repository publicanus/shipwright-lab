# Definition of Done

A work item is done when ALL of the following pass:

1. **Acceptance criteria verified.** Every AC has an automated test that fails without the change (or a named manual procedure with one-line justification documented in the work item's Testing section).

2. **Automated tests pass.** All test commands intersecting the diff exit green. Pre-existing failures excluded only with named justification in the implementer's completion report.

3. **CI green.** Static analysis, linters, and the project's coverage threshold all pass. The CI gate is canonical; the DoD does not restate its criteria.

4. **Review complete.** Feature-workflow step 7 has cleared per its severity-tiered handling: zero CRITICAL findings, MAJOR dispositions complete, MINOR collected to the PR description.

5. **Documentation reflects observable change.** A change that alters observable behavior — a new or changed command, flag, flow, skill, hook, output, or config surface — requires three things in the same PR:

    a. **Changelog entry.** The commit is a Conventional Commit (`feat:`, `fix:`, `perf:`, `chore:`, etc.) with an audience-meaningful description. The changelog is generated from commits; hand-writing `CHANGELOG.md` entries is not required.

    b. **Canonical-doc currency.** Every doc that describes the touched surface reflects reality after the change. Consult this project's documentation map (`standards/documentation-map.md`) to find which documents cover the changed surface. No document may contradict the shipped behavior.

    c. **Update over create.** An existing document is updated in place. A new document is created only when no existing document covers the audience × surface combination; the documentation map is the authority.

    **Trigger (observable behavior):** the same discriminator as a version bump — did a user-facing command, hook, skill, configuration key, or output change? If no, documentation is not required. Internal refactors, tests, comments, and build-tooling changes need no doc update.

    **Rationale stays in the work item and PR**, not in standalone rationale docs. The tracker, PR body, and work-item body are the project-management layer; product artifacts describe the thing as designed, never the project state around it.

    **Runtime-artifact carve-out:** `agents/*.md`, `skills/**`, and `scoped-rules/**` are product artifacts maintained by their own discipline (skill-creator + eval harness). They are not governed by this criterion — their own maintenance discipline is the authority.

The DoD is universal and tech-agnostic. Stack-specific items (coding standards, language-specific patterns) live in the rule corpus and the reviewer agent's rule-application pass — not here.
