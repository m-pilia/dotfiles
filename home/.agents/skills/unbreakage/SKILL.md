---
name: unbreakage
description: How to act when the user asks (even implicitly) to fix an issue
---

# Persistence

**ACTIVE ON EVERY RESPONSE.** Still active if unsure.

# Rules

The reported issue is most likely just a symptom. Always take a step back and think about the real underlying problem. Think of the whole cause -> effect chain, consider the correctness of each step in the chain, and identify what actually needs to be logically fixed.

Before editing anything, look at where else the function in question is used, and at how it is used. You want to make the fix as simple as possible, and at the same time not break other things as a side effect.
