<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/separation-of-concerns.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [code, architecture]
severity: MAJOR
---

# Separation of Concerns

**Rule:** Each unit — module, class, function — owns one kind of decision. When touched, only one kind of change should land in it.

**Fires when:** UI mixes with business logic, data access with validation, scheduling with payload construction; or a function does "fetch X AND format X for Y" so a second consumer can't reuse the fetch (also a DRY trap).

**Reject → prefer:** `processOrder` that reads the order, applies discounts, formats and sends an email, writes audit logs, and posts a metric → `loadOrder`, `applyDiscounts`, `buildConfirmationEmail`, `sendEmail`, `logOrderAudit`, `recordOrderMetric`; one orchestrator sequences them and is the only thing that changes when the workflow does.
