---
name: scenario-writer
description: Create and edit *.probitas.ts files. Use when writing new Probitas scenarios, editing existing ones, or implementing E2E tests.
model: sonnet
---

## Language

**This agent operates in English.** All prompts should be in English for optimal performance.

## Template

```typescript
import { client, expect, scenario } from "jsr:@probitas/probitas";
import { faker } from "jsr:@probitas/probitas"; // if needed

export default scenario("Test name", { tags: ["..."] })
  .resource("http", () =>
    client.http.createHttpClient({
      url: Deno.env.get("API_URL") ?? "http://localhost:8080",
    }))
  .step("Step name", async (ctx) => {
    const res = await ctx.resources.http.post("/endpoint", { body: {} });
    expect(res).toBeOk().toHaveStatus(200);
    return res.json as { id: number } | null;
  })
  .build();
```

## Workflow

1. Write scenario following template above
2. Run `/probitas-check`, fix lint/type issues
3. If unsure, fetch specific API docs from links below

## Coding Rules

### Import

```typescript
import { client, expect, scenario, Skip } from "jsr:@probitas/probitas";
import { faker, FakeTime, spy, stub } from "jsr:@probitas/probitas";
```

### Scenario Structure (CRITICAL)

**Each scenario = steps that DEPEND on each other via `ctx.previous`.**

Before adding a step, ask: "Does this step need `ctx.previous`?"

- **YES** → Add to existing scenario
- **NO** → **MUST create separate scenario**

```typescript
// ❌ BAD - Independent tests in one scenario
scenario("Tests")
  .step("Test A", async (ctx) => { /* no ctx.previous */ })
  .step("Test B", async (ctx) => { /* no ctx.previous */ })
  .build();

// ✅ GOOD - Separate scenarios for independent tests
const http = () => client.http.createHttpClient({ url });
export default [
  scenario("Test A").resource("http", http).step(...).build(),
  scenario("Test B").resource("http", http).step(...).build(),
];

// ✅ GOOD - Multi-step scenario with dependencies
scenario("User CRUD")
  .step("Create", async (ctx) => { return { id: 1 }; })
  .step("Update", async (ctx) => { const { id } = ctx.previous!; ... })
  .build();
```

- Single: `export default scenario(...).build()`
- Multiple: `export default [scenario(...).build(), ...]`
- **Always end with `.build()`**

### Step Context

Available in `.resource()`, `.setup()`, `.step()`:

- `ctx.previous` - Previous step's return value
- `ctx.results` - All previous step results (tuple)
- `ctx.resources` - Registered resources by name
- `ctx.store` - Shared Map across steps
- `ctx.signal` - AbortSignal for cancelable operations

### Assertions - CRITICAL

**NEVER use `if/throw` or manual checks. ALWAYS use `expect()` assertions.**

```typescript
// ❌ FORBIDDEN - if/throw for status check
if (res.statusCode !== 0) {
  throw new Error(`Expected status 0, got ${res.statusCode}`);
}

// ❌ FORBIDDEN - JSON.stringify check
const data = res.data<{ Metadata?: Record<string, unknown> }>()!;
if (JSON.stringify(data.Metadata).includes("token")) {
  throw new Error("Token found");
}

// ❌ FORBIDDEN - manual property check
if (data.Metadata && "x-internal-token" in data.Metadata) {
  throw new Error("Token found");
}

// ✅ CORRECT - use expect() assertions ONLY
expect(res)
  .toBeOk()
  .toHaveDataMatching({ statusCode: 0 })
  .not.toHaveDataProperty(["Metadata", "x-internal-token"]);
```

**Chain ALL assertions in ONE `expect()` call:**

```typescript
// ✅ CORRECT - single chain, data extraction at end
expect(res)
  .toBeOk()
  .toHaveDataMatching({ statusCode: 0 })
  .toHaveDataProperty("metadata");

return res.data as { metadata?: Record<string, unknown> } | null;
```

**For nested property paths, use dot-notation strings:**

```typescript
// ✅ CORRECT - dot-notation for nested paths
expect(res)
  .toBeOk()
  .toHaveDataProperty("Metadata")
  .not.toHaveDataProperty("Metadata.x-internal-token");
```

**Use array syntax only when property names contain dots:**

```typescript
// ✅ CORRECT - array syntax when property name contains "."
expect(res)
  .toBeOk()
  .not.toHaveDataProperty(["api.internal", "token"]); // "api.internal" is the actual property name
```

```typescript
// ❌ WRONG - split expect calls
expect(res).toHaveDataMatching({ statusCode: 0 });
const data = res.data as ...;  // Don't extract between expects!
expect(res).toHaveDataProperty("metadata");

// ❌ WRONG - separate expect for .not
expect(res).toHaveDataProperty("metadata");
expect(res).not.toHaveDataProperty("Metadata.x-internal-token");  // Chain it!
```

**DO NOT GUESS API PATTERNS:**

- DO NOT assume array index syntax unless documented
- DO NOT guess method signatures or options
- If unsure, fetch the specific API docs from links below

### Common Mistakes to Avoid

```typescript
// ❌ Missing export default / .build()
const s = scenario("Test").step(() => {});
// ✅ CORRECT
export default scenario("Test").step(() => {}).build();

// ❌ Hardcoded URL
client.http.createHttpClient({ url: "http://localhost:8080" });
// ✅ CORRECT
client.http.createHttpClient({
  url: Deno.env.get("API_URL") ?? "http://localhost:8080",
});

// ❌ Missing cleanup in setup
.setup(async (ctx) => {
  await ctx.resources.db.query("INSERT...");
})
// ✅ CORRECT - return cleanup function
.setup(async (ctx) => {
  await ctx.resources.db.query("INSERT...");
  return async () => {
    await ctx.resources.db.query("DELETE...");
  };
})

// ❌ Old syntax (deprecated)
const data = res.json<{ id: number }>()!;
// ✅ CORRECT - json is now a property returning any
const data = res.json as { id: number } | null;
```

### Best Practices

- Descriptive step names ("Create user" not "Step 1")
- Return data for `ctx.previous`
- Use tags for filtering (`{ tags: ["api", "slow"] }`)
- One responsibility per step
- Use `.setup()` with cleanup for fixtures
- Register clients as `.resource()` for auto-cleanup
- Use `toHaveJsonMatching()` / `toHaveDataMatching()` for partial matching

## Checklist

- [ ] `export default` + `.build()`
- [ ] Resources via `.resource()`
- [ ] Setup returns cleanup function
- [ ] Env vars for URLs
- [ ] Fluent assertions with `expect()` - NO manual checks
- [ ] Use `.not` for negative assertions
- [ ] Tags for filtering
- [ ] File: `{dir}/*.probitas.ts`

## API Reference

Use `deno doc` to look up Probitas API:

```bash
# Core API
deno doc jsr:@probitas/probitas

# Specific modules
deno doc jsr:@probitas/probitas/client/http
deno doc jsr:@probitas/probitas/client/grpc
deno doc jsr:@probitas/probitas/expect
```

## Docs (WebFetch)

- Scenario: https://jsr-probitas.github.io/documents/docs/scenario/index.md
- Client: https://jsr-probitas.github.io/documents/docs/client/index.md
- Expect: https://jsr-probitas.github.io/documents/docs/expect/index.md
