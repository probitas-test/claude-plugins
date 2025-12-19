---
name: probitas
description: Probitas scenario testing patterns. Use when writing integration tests.
---

## Documentation

**Fetch latest via WebFetch:**

- Sitemap: https://jsr-probitas.github.io/documents/llms.txt
- Scenario: https://jsr-probitas.github.io/documents/docs/scenario/index.md
- Client: https://jsr-probitas.github.io/documents/docs/client/index.md
- Assertions: https://jsr-probitas.github.io/documents/docs/expect/index.md

## Commands

- `/probitas:init` - Initialize project
- `/probitas:run` - Run scenarios
- `/probitas:new` - Generate template
- `/probitas:check` - Format, lint, type check

## Pattern

**Split into array** for independent tests:

```typescript
import { client, expect, scenario } from "jsr:@probitas/probitas";

export default [
  scenario("Validation - empty name", { tags: ["validation"] })
    .resource("http", () =>
      client.http.createHttpClient({
        url: Deno.env.get("API_URL") ?? "http://localhost:8080",
      }))
    .step("Test", async (ctx) => {
      const res = await ctx.resources.http.post("/users", {
        body: { name: "" },
      });
      expect(res).toHaveStatus(400);
    })
    .build(),

  scenario("Validation - invalid email", { tags: ["validation"] })
    .resource("http", () =>
      client.http.createHttpClient({
        url: Deno.env.get("API_URL") ?? "http://localhost:8080",
      }))
    .step("Test", async (ctx) => {
      const res = await ctx.resources.http.post("/users", {
        body: { email: "bad" },
      });
      expect(res).toHaveStatus(400);
    })
    .build(),
];
```

**Keep single** for sequential workflows:

```typescript
export default scenario("CRUD workflow", { tags: ["crud"] })
  .resource("http", () =>
    client.http.createHttpClient({
      url: Deno.env.get("API_URL") ?? "http://localhost:8080",
    }))
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

## Assertions

```typescript
// HTTP
expect(res).toBeOk().toHaveStatus(200).toHaveJsonMatching({ id: 1 });

// SQL
expect(result).toHaveRowCount(5).toHaveRowsMatching({ name: "Alice" });

// Negation
expect(res).not.toHaveStatus(404);
```
