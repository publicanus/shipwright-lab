# Definition of Ready

A work item is ready for implementation when ALL of the following hold. Writer: `business-analyst` for stories, `technical-architect` for tasks.

1. **Problem and cost stated.** The body says what needs to be true after the change and why it matters now — the cost of inaction, not just the symptom.

2. **Acceptance criteria observable and outcome-shaped.** Each AC is testable yes/no without re-interpretation and describes what must be true rather than how to achieve it. The litmus is actor-relative **and at the actor's altitude**: an AC may name any artifact that is the contract surface for the work item's declared actor, and must state what that surface does under exercise — its observable behavior (exit codes, outputs, rendered state) — never merely that the artifact exists or is enabled (a refactor's corpus-wide structural invariant is the one valid non-behavioral shape). For a **task** (developer / CI / operator actor) an implementation surface is the right altitude; for a **story whose actor is a business persona** the surface must be one the actor can perceive (a screen, message, email, document, status) — an internal implementation artifact (flow, sObject, field, queue, Apex, routing model) named as the AC's surface is wrong-altitude and fails. (A situation-triggered story with no business-persona actor is exempt — it is judged on its observable system effect.) The gate and the phrasing bar live in the `observable-ac` and `outcome-phrasing` rules; the definitions of "business persona" and "situation-triggered" live in `observable-ac`.

3. **Scope bounded.** What is in-scope and what stays unchanged is explicit. Every code surface named in the body exists in the system, or is explicitly listed as in-scope-to-be-built.

4. **Sized for one session.** Roughly one module, no new patterns introduced. If the item is splittable without creating artificial cross-item dependencies, split it.

5. **Dependencies tracked.** Blocks / Blocked by / Related to declared. Blocked-by items resolved or the blocker called out.

## Type-specific shape

- **Stories** name a specific actor (or, for situation-triggered work, the specific trigger). Generic actors — "user" or "admin" without a role title — are insufficient. Error and exception paths are first-class ACs, not in a separate section.
- **Tasks** state the problem the code change solves directly — symptom, constraint, or gap. No "As a [role]" header. The body names its observable surface — who or what observes the outcome (operator, CI, developer-runner). Each AC states the effect that observer gains, never the artifact inventory that produces it. New error paths introduced by the task are first-class ACs.

Format-agnostic — Rules + Examples, GWT, prose all pass if each AC meets criterion 2. Plan-related readiness (plan file exists, names module, names patterns) is checked at workflow step 4, not at filing.
