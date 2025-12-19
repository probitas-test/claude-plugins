---
paths: "**/*.probitas.ts"
---

# Probitas Scenario Writing

## Structure

```typescript
export default scenario("Name", { tags: ["..."] })
  .resource(...)  // 1. Resources
  .setup(...)     // 2. Setup/cleanup
  .step(...)      // 3. Test steps
  .build();       // 4. Required!
```

## Split vs Single Scenario

**Split into array** for independent tests (parallel execution, better failure
identification):

```typescript
export default [
  scenario("Validation - rejects empty name", { tags: ["validation"] })
    .resource("http", () => client.http.createHttpClient({ url: "..." }))
    .step("Test", async (ctx) => {
      const res = await ctx.resources.http.post("/users", {
        body: { name: "" },
      });
      expect(res).toHaveStatus(400);
    })
    .build(),

  scenario("Validation - rejects invalid email", { tags: ["validation"] })
    .resource("http", () => client.http.createHttpClient({ url: "..." }))
    .step("Test", async (ctx) => {
      const res = await ctx.resources.http.post("/users", {
        body: { email: "bad" },
      });
      expect(res).toHaveStatus(400);
    })
    .build(),
];
```

**Keep single** for sequential workflows (steps depend on previous):

```typescript
export default scenario("User CRUD workflow", { tags: ["crud"] })
  .resource("http", () => client.http.createHttpClient({ url: "..." }))
  .step("Create", async (ctx) => {
    const res = await ctx.resources.http.post("/users", {
      body: { name: "Alice" },
    });
    return res.json<{ id: number }>()!;
  })
  .step("Get", async (ctx) => {
    const res = await ctx.resources.http.get(`/users/${ctx.previous.id}`);
    expect(res).toHaveStatus(200);
    return ctx.previous;
  })
  .step("Delete", async (ctx) => {
    await ctx.resources.http.delete(`/users/${ctx.previous.id}`);
  })
  .build();
```

## Common Mistakes

```typescript
// BAD: Missing export default and .build()
const s = scenario("Test").step(() => {});

// GOOD
export default scenario("Test").step(() => {}).build();
```

```typescript
// BAD: Hardcoded URL
client.http.createHttpClient({ url: "http://localhost:8080" });

// GOOD: Use environment variable with fallback
client.http.createHttpClient({
  url: Deno.env.get("API_URL") ?? "http://localhost:8080",
});
```

```typescript
// BAD: Step returns nothing, loses data
.step("Create", async (ctx) => {
  await ctx.resources.http.post("/users", { body: { name: "Alice" } });
})

// GOOD: Return data for next step
.step("Create", async (ctx) => {
  const res = await ctx.resources.http.post("/users", { body: { name: "Alice" } });
  return res.json<{ id: number }>()!;
})
```

**Missing cleanup**

```typescript
.setup(async (ctx) => {
  await ctx.resources.db.query("INSERT...");
  return async () => {
    await ctx.resources.db.query("DELETE...");  // Cleanup!
  };
})
```

## Best Practices

- **Descriptive step names**: "Create user with valid email" not "Step 1"
- **Return meaningful values**: Enable type-safe `ctx.previous`
- **Use tags**: For filtering (`probitas run -s tag:api`)
- **Keep steps focused**: Single responsibility
- **Use setup for test data**: Guarantees cleanup on failure

## Context

- `ctx.previous` - Previous step's return
- `ctx.results` - All previous results
- `ctx.store` - Shared Map
- `ctx.signal` - Pass to cancelable ops

## Docs

https://jsr-probitas.github.io/documents/llms.txt
