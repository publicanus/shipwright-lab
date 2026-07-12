<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/dry.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [all]
severity: CRITICAL
---

# DRY — Don't Repeat Yourself

**Rule:** Each piece of logic lives in one place — no syntactic or semantic duplication.

**Fires when:** the same predicate, calculation, or mapping is written at two sites; or a bug appears in copy-pasted code.

**Fix at the unification point**, not one copy — patching one site lets the others drift into silent contradiction. When a second caller needs existing logic, lift it into a shared helper at that moment.
