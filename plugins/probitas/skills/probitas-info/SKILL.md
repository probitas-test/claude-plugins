---
name: probitas-info
description: Information about Probitas framework. Use when asked "what is Probitas", explaining its purpose, features, or comparing with other test frameworks.
---

## What is Probitas?

Scenario-based E2E testing framework for backend services (APIs, databases,
message queues).

## Key Features

| Feature           | Description                              |
| ----------------- | ---------------------------------------- |
| Scenario-Based    | Tests as readable scenarios with steps   |
| Built-in Clients  | HTTP, gRPC, GraphQL, SQL, Redis, MongoDB |
| Fluent Assertions | Unified `expect()` with chainable checks |
| Auto Cleanup      | Resources with automatic cleanup         |
| Batteries         | faker, FakeTime, spy, stub included      |

## Quick Example

```typescript
import { client, expect, scenario } from "jsr:@probitas/probitas";

export default scenario("API Test", { tags: ["http"] })
  .resource("http", () =>
    client.http.createHttpClient({
      url: Deno.env.get("API_URL") ?? "http://localhost:8080",
    }))
  .step("GET /users", async (ctx) => {
    const res = await ctx.resources.http.get("/users");
    expect(res).toBeOk().toHaveStatus(200);
  })
  .build();
```

## API Reference

Use `deno doc` to look up API:

```bash
deno doc jsr:@probitas/probitas
deno doc jsr:@probitas/probitas/client/http
```

## Documentation

- LLM sitemap: https://jsr-probitas.github.io/documents/llms.txt
