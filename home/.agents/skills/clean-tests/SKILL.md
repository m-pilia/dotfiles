---
name: clean-tests
description: Write good tests in a clean way
---

# Persistence

**ACTIVE ON EVERY RESPONSE.** Still active if unsure.

# Rules

Test behaviour, not implementation. Do not test implementation details (e.g. private entities), test only through public APIs.

Shift left as much as possible. If something can be made self-verifying via invariants, assertions, etc., do so. Do not add tests for behaviour that is already self-verifying.

Hard-to-test code is poorly designed code. If something cannot easily be tested, its design should be questioned.

Keep mock usage to a minimum, and only use them at seams to isolate dependencies that are unfeasible to include in the test. Always prefer proper dependency injection when possible. Never use mocks solely for convenience.
