<!-- Seeded by shipwright plugin from /Users/jaapbranderhorst/.claude/plugins/cache/spire/shipwright/4.0.0/rules/yagni.md — edit freely; this copy takes precedence over the plugin default -->

---

artifact: [all]
severity: CRITICAL
---

# YAGNI — You Ain't Gonna Need It

**Rule:** Build only what current requirements need. Speculative capability is debt that may never pay off.

**Fires when:** an abstraction, interface, config option, or plugin point is added for a future that hasn't been committed to ("we might one day need SMS/Slack/push…").

**Reject → prefer:** a `Notification` interface + `Sender` plugin system with `SmsSender`/`SlackSender` stubs → a plain `send_email(...)`. Add the next channel when it actually arrives; let DRY drive the abstraction once concrete consumers exist.

**Not KISS:** YAGNI attacks complexity for _speculative future_ needs; KISS attacks complexity in the design chosen for _current_ needs.
