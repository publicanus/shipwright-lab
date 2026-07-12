<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/eval-cost.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [workflow-skill]
severity: MINOR
---

# Eval-Cost Discipline

When re-running framework-skill eval suites (e.g., `skills/refine/evals/`) during PR fix loops, default to slice re-runs (only the new or changed cases). Each case spawns a fresh subagent loading the skill from scratch — ~30k tokens per case is typical; full-suite re-runs across fix-loop rounds compound into 1M+ tokens.

Before initiating a full-suite re-run, warn the user with a rough cost estimate (case count × ~30k tokens) and confirm. The user picks: approve full cost, scope to a slice ("all r10-* cases"), or skip regression entirely.

Does NOT apply to fast pattern-intersected `test_commands` which run cheaply and should always run on intersect.
