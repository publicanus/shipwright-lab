<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/fail-fast.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [all]
severity: MAJOR
---

# Fail Fast

**Rule:** Halt at the point wrongness is detected, with a diagnostic naming what failed. No degraded state, substituted defaults, or swallowed errors.

**Fires when:** you're tempted to "be helpful" — a default filling in for missing config, a try/catch that logs and continues, a fallback producing "something reasonable" when the real answer is unavailable.

**Reject → prefer:** a missing tenant key returns a default tenant (request proceeds, writes cross-tenant) → raise "tenant <name> not configured" immediately. Failure modes are part of the contract; keep them visible.
