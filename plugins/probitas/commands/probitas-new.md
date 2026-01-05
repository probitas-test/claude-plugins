---
description: Generate scenario template (http, database, grpc, graphql)
model: haiku
---

## Workflow

1. Generate template based on type argument
2. Save to `probitas/{name}.probitas.ts`
3. Run `deno check **/*.probitas.ts`

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

## Docs

https://probitas-test.github.io/documents/docs/scenario/index.md
