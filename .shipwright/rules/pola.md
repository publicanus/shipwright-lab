<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/pola.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [all]
severity: MINOR
---

# POLA — Principle of Least Astonishment

**Rule:** Names, signatures, and defaults match behavior — the obvious assumption from what's visible is correct.

**Fires when:** a `get` mutates, a `validate` silently fixes, a `send` also persists; a default quietly enables expensive behavior; `N=0` is handled structurally differently from `N>0`; a subclass throws where the base didn't.

**Reject → prefer:** `parseConfig` that also writes a normalized file to disk → split into `parseConfig` (pure read) + `normalizeConfigFile` (explicit write), or rename to disclose the side effect.
