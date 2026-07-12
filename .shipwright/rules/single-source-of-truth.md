<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/single-source-of-truth.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [all]
severity: MAJOR
---

# Single Source of Truth

**Rule:** Every fact — a value, a setting, a state — has one authoritative source. Others read from it or are explicit caches with a reconciliation path back.

**Fires when:** the same fact is held in two places — e.g. a hardcoded constant _and_ a runtime config entry for the same setting.

**Reject → prefer:** `DEFAULT_TIMEOUT = 30` in code plus a configurable timeout in the config store (they drift; one path reads each) → delete the constant, route all paths through the store, override via test fixture.

**Not DRY:** DRY forbids duplicate _code_; SoT forbids two places holding the same _fact_ — code can look unique yet hold two truths.
