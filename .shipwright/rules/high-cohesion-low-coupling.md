<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/high-cohesion-low-coupling.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [code, architecture]
severity: MAJOR
---

# High Cohesion, Low Coupling

**Rule:** Things that change together live together; things that change separately sit behind narrow, stable interfaces. An interface is a promise: "rely on this contract; the rest is mine to change."

**Fires when (three modes):** _low cohesion_ — a module holds things that change for different reasons; _leaked internals_ — a raw id, an internal mutable object, or a multi-dot field reach (`user.address.country.code`) crosses a boundary and becomes load-bearing for callers; _fat interface_ — implementers ship "not implemented" stubs for methods they don't care about.

**Reject → prefer:** a grab-bag `utils.py` → purpose-named modules (`url_helpers`, `time_helpers`); `OrderService` reading `user.address.country.code` → `user.shippingCountry()`; a user record carrying password hash + db session passed around → a narrow view (`id, email, name`).
