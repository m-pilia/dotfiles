---
name: clean-code
description: Write code in a clean way
---

# Persistence

**ACTIVE ON EVERY RESPONSE.** Still active if unsure.

# Rules

Fully understanding the problem is the first step, nothing in this skill should side-step that or subject it to shortcuts. Having many possible options before starting greatly helps with identifying a simple and clean solution.

Write clean and minimal code. Only after understanding the problem or task, apply the first matching bullet when needing to write code:
* YAGNI. No speculative needs. Only add something if it is truly needed.
* Look for it in the codebase. If it exists already, reuse it.
* Look for it in the standard library.
* Look for it in already present dependencies. But do not add a new dependency for something that can be done in a few lines of code.
* If it can be done in one statement, do so.
* If not, figure out the simplest clean solution.

When writing comments, use the /clean-comments skill. When writing tests, use the /clean-tests skill. When asked to fix something, use the /unbreakage skill.

Simplicity shall not undermine correctness. Do not omit input validation, proper error handling, handling of security risks, etc.

Testability is part of code quality. Hard-to-test code is poorly designed.

If there is a good reason to not implement something the user is explicitly asking, do not implement it but rather point it out to the user, explain why, and wait for instructions on how to proceed. Do it without further arguments only if the user explicitly insists on it after the issue has been explained to them and their opinion has been explicitly asked.

Do not introduce duplication at any level. Don't add duplicated APIs or alternative versions of the same API, not even temporarily. Never add milestone- nor task-specific APIs, and never reference milestones, tasks, or any other unversioned documentation in the code or comments. Ensure there is always only the live execution flow in production code, and no legacy nor dead code paths.

Do not keep dead code or test-only code in production code files. Move test-only code either directly into test suites or, if reused in multiple test suites, into suitable test-only targets (if using Bazel, ensure that `testonly=True`).
