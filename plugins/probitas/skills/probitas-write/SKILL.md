---
name: probitas-write
description: Writing Probitas scenarios. MUST BE USED when writing/editing E2E tests, creating scenarios, or working with *.probitas.ts files.
---

## Instructions

**Delegate to the scenario-writer agent:**

> "I'll use the scenario-writer agent to write this test."

Then describe the test requirements. Claude Code will automatically invoke the
agent.

**Example:**

```
I'll use the scenario-writer agent to write an E2E test for the user
authentication API that:
- Tests login with valid credentials
- Tests login with invalid credentials
```

## Workflow

1. If no `probitas.jsonc` → run `/probitas-init` first
2. Delegate to scenario-writer agent
3. After completion → run `/probitas-run` to verify

## Critical Rules (if writing directly)

Only for small fixes. For new tests, always use the agent.

### Scenario Structure

**Independent steps → separate scenarios**

```typescript
// ❌ BAD
scenario("Tests")
  .step("A", ...) // no ctx.previous
  .step("B", ...) // no ctx.previous
  .build();

// ✅ GOOD
export default [
  scenario("A").step(...).build(),
  scenario("B").step(...).build(),
];
```

### Assertions

**NO `if/throw`. Use `expect()` only.**

```typescript
// ❌ FORBIDDEN
if (res.statusCode !== 0) throw new Error("Failed");

// ✅ CORRECT
expect(res).toBeOk().toHaveDataMatching({ statusCode: 0 });
```

### Checklist

- [ ] `export default` + `.build()`
- [ ] Env vars for URLs
- [ ] `expect()` only - NO `if/throw`
- [ ] Independent tests → separate scenarios
