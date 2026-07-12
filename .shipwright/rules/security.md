<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/security.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [all]
severity: CRITICAL
---

# Security

**Rule:** Validate untrusted input at the trust boundary; authorize every privileged operation server-side, deny-by-default; secrets never in source; errors and logs reveal only what the caller is entitled to. Judge the **goal** — "can an attacker reach harm from here" — not whether a standard mechanism was used.

**Fires when:** input reaches a query/command/markup without boundary validation; an operation is reachable by a lower-privileged actor than intended; a key/token/password sits in code, committed config, or logs; an error or log echoes internals, other actors' data, or PII.

**Reject → prefer:** load a record by request-supplied id and return it, trusting the caller owns it → authorize the running actor's entitlement server-side so an unauthorized id returns nothing; test both the entitled (succeeds) and unentitled (denied) cases.

**Mechanism lives in the stack's rules** (how authz is enforced, how secrets are stored, how queries are parameterized) — this rule is the goal each must meet.
