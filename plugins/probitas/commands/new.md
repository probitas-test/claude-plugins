---
description: Generate scenario template (http, database, grpc, graphql)
---

## Workflow

1. Fetch template info from
   https://jsr-probitas.github.io/documents/docs/scenario/index.md
2. Generate template based on type argument
3. Save to `probitas/{name}.probitas.ts`
4. Run `deno check probitas/{name}.probitas.ts`

## Templates

### HTTP

```typescript
import { client, expect, scenario } from "jsr:@probitas/probitas";

export default scenario("HTTP API Test", { tags: ["http"] })
  .resource("http", () =>
    client.http.createHttpClient({
      url: Deno.env.get("API_URL") ?? "http://localhost:8080",
    }))
  .step("GET request", async (ctx) => {
    const res = await ctx.resources.http.get("/health");
    expect(res).toBeOk().toHaveStatus(200);
  })
  .build();
```

### Database

```typescript
import { client, expect, scenario } from "jsr:@probitas/probitas";

export default scenario("Database Test", { tags: ["database"] })
  .resource("db", () =>
    client.sql.postgres.createPostgresClient({
      url: Deno.env.get("DATABASE_URL") ?? "postgres://localhost:5432/testdb",
    }))
  .step("Query", async (ctx) => {
    const result = await ctx.resources.db.query("SELECT 1 as value");
    expect(result).toHaveRowCount(1);
  })
  .build();
```
