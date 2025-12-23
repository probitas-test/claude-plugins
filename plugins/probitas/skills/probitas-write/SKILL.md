---
name: probitas-write
description: Writing Probitas scenarios. MUST BE USED when writing/editing E2E tests, creating scenarios, or working with *.probitas.ts files.
---

## Instructions

**ALWAYS delegate to the scenario-writer agent using the Task tool.**

**CRITICAL - Language:**
- ALWAYS translate user requirements to English before invoking the agent
- Provide clear, concise English prompts for optimal agent performance

**Steps:**
1. Translate user requirements to English
2. Invoke Task tool with `subagent_type: "probitas:scenario-writer"`
3. Provide English prompt with test requirements

**Example:**

User asks: "ユーザー認証APIのテストを書いて"

Your response:
```
I'll use the probitas:scenario-writer agent to write this Probitas test scenario.
```

Then invoke Task tool:
- `subagent_type`: "probitas:scenario-writer"
- `prompt`: "Write an E2E test for the user authentication API that:
  - Tests login with valid credentials (should succeed)
  - Tests login with invalid credentials (should fail with appropriate error)"
- `description`: "Write auth test scenario"

## Workflow

1. If no `probitas.jsonc` → run `/probitas-init` first
2. Write scenario (directly or via agent)
3. After completion → run `/probitas-check` to verify
4. If needed → run `/probitas-run` to test

## Critical Rules

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
