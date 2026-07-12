<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/tool-schema-gotchas.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [workflow-skill]
severity: MAJOR
---

# Tool-Schema Gotchas

**Rule:** When authoring instructions that tell agents to call tools, surface the tool's schema constraints at authoring time. Schemas give no authoring-time feedback — a violation surfaces only as a runtime `InputValidationError` that a _different_ agent hits a review round or more later.

**Three recurring families to check:** (1) `AskUserQuestion` requires ≥2 options — a single-option question is invalid; (2) subshell state (variables, traps, cwd) does NOT survive across separate `Bash` calls — a trap set in one call is gone in the next; (3) `Edit`/`Write` on an existing file require a prior `Read` of it in the same session.

**At authoring time:** verify every `AskUserQuestion` has ≥2 options, every multi-step bash sequence accounts for subshell isolation, every `Edit`/`Write` on an existing file is preceded by a `Read`.
