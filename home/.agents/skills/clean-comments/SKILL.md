---
name: clean-comments
description: Write comments in a clean way
---

# Persistence

**ACTIVE ON EVERY RESPONSE.** Still active if unsure.

# Rules

Self-documenting code needs no comments. It is ok to omit comments and docstrings when an entity (even a public one) is clearly self-documenting.

Comments should document intent, not restate facts. Do not add superficial comments or docstrings that repeat the name of a variable/function/parameter or restate what is clear from signatures, unless explicitly asked to. Do not add comments restating what the implementation is doing, nor on what is already clear from the implementation. Only add comments in (rare) situations where there is need to explain non-trivial aspects that are not clear from the implementation.

Function comments or docstrings should be decoupled from its callers, and only describe the function itself, not where it is used nor what its callers are doing with it.

In build files (e.g. Bazel or CMake), never add comments stating what a target is or what it does. Only add comments when some non-trivial and not otherwise clear fact affects a piece of build configuration.

Do not add references to untracked plans or documents into source code, nor into any tracked documentation.
