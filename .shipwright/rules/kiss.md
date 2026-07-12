<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/kiss.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [all]
severity: MAJOR
---

# KISS — Keep It Simple

**Rule:** Choose the design an unfamiliar engineer can understand and modify under pressure. When two designs solve the current need, the more comprehensible one wins.

**Fires when:** the chosen design is harder to operate than an equivalent — clever one-liners, dense expressions, indirection that saves nothing at construction.

**Reject → prefer:** `(ts.timetuple().tm_yday - now.timetuple().tm_yday) % 365 < 1` → `(now - ts) < timedelta(hours=24)`. Same result; the second reads as plain English and has no leap-year edge.

**Not YAGNI:** YAGNI attacks complexity for _speculative future_ needs; KISS attacks complexity in the design chosen for _current_ needs.
