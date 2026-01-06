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

### Client Selection

**CRITICAL**: Always use the correct factory function from `client.*` namespace.

| Client     | Factory Function                             | Use Case             |
| ---------- | -------------------------------------------- | -------------------- |
| HTTP       | `client.http.createHttpClient()`             | REST APIs, webhooks  |
| HTTP OIDC  | `client.http.oidc.createOidcHttpClient()`    | OAuth 2.0/OIDC APIs  |
| PostgreSQL | `client.sql.postgres.createPostgresClient()` | PostgreSQL databases |
| MySQL      | `client.sql.mysql.createMySqlClient()`       | MySQL databases      |
| SQLite     | `client.sql.sqlite.createSqliteClient()`     | Embedded databases   |
| DuckDB     | `client.sql.duckdb.createDuckDbClient()`     | Analytics databases  |
| gRPC       | `client.grpc.createGrpcClient()`             | gRPC services        |
| ConnectRPC | `client.connectrpc.createConnectRpcClient()` | Connect/gRPC-Web     |
| GraphQL    | `client.graphql.createGraphqlClient()`       | GraphQL APIs         |
| Redis      | `client.redis.createRedisClient()`           | Cache, pub/sub       |
| MongoDB    | `client.mongodb.createMongoClient()`         | Document databases   |
| Deno KV    | `client.deno_kv.createDenoKvClient()`        | Deno KV store        |
| RabbitMQ   | `client.rabbitmq.createRabbitMqClient()`     | AMQP message queues  |
| SQS        | `client.sqs.createSqsClient()`               | AWS message queues   |

**Examples:**

```typescript
// HTTP
.resource("http", () =>
  client.http.createHttpClient({
    url: Deno.env.get("API_URL") ?? "http://localhost:8080",
  }))

// HTTP with OIDC authentication
.resource("http", () =>
  client.http.oidc.createOidcHttpClient({
    url: Deno.env.get("API_URL") ?? "http://localhost:8080",
    oidc: {
      issuer: Deno.env.get("OIDC_ISSUER") ?? "http://localhost:8080",
      clientId: "test-client",
    },
  }))

// PostgreSQL
.resource("db", () =>
  client.sql.postgres.createPostgresClient({
    url: Deno.env.get("DATABASE_URL") ?? "postgres://user:pass@localhost:5432/db",
  }))

// GraphQL
.resource("graphql", () =>
  client.graphql.createGraphqlClient({
    url: Deno.env.get("GRAPHQL_URL") ?? "http://localhost:4000/graphql",
  }))
```

Follow the same pattern for other clients using the factory functions from the table above.

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

**MANDATORY PROCESS - BEFORE writing ANY assertion:**

1. **Identify the response type** and corresponding Expectation interface:
   - HTTP → `HttpResponseExpectation`
   - GraphQL → `GraphqlResponseExpectation`
   - gRPC → `GrpcResponseExpectation`
   - ConnectRPC → `ConnectRpcResponseExpectation`
   - SQL → `SqlQueryResultExpectation`
   - Redis → `RedisExpectation` (or `RedisGetResultExpectation`, `RedisSetResultExpectation`, etc.)
   - MongoDB → `MongoExpectation` (or `MongoFindResultExpectation`, `MongoInsertOneResultExpectation`, etc.)
   - RabbitMQ → `RabbitMqExpectation` (or `RabbitMqPublishResultExpectation`, `RabbitMqConsumeResultExpectation`, etc.)
   - SQS → `SqsExpectation` (or `SqsSendResultExpectation`, `SqsReceiveResultExpectation`, etc.)
   - Deno KV → `DenoKvExpectation` (or `DenoKvGetResultExpectation`, `DenoKvSetResultExpectation`, etc.)

2. **Use `/probitas:probitas-expect-methods` command to get ACTUAL available methods** for that specific interface:
   ```bash
   # Example for HTTP:
   /probitas:probitas-expect-methods HttpResponseExpectation

   # Example for SQL:
   /probitas:probitas-expect-methods SqlQueryResultExpectation

   # Example for MongoDB find:
   /probitas:probitas-expect-methods MongoFindResultExpectation

   # Example for RabbitMQ publish:
   /probitas:probitas-expect-methods RabbitMqPublishResultExpectation
   ```
   - The command will output a clean list of method names: `toBeOk`, `toHaveStatus`, etc.
   - Read the list and choose the most appropriate method for your assertion
   - This always reflects the current Probitas version's API

3. **Choose the appropriate expect method** based on the actual API - DO NOT improvise with `if/throw`

**Why using `/probitas:probitas-expect-methods` is mandatory:**

- Always reflects the current Probitas version (no outdated documentation)
- Covers ALL client types including RabbitMQ, SQS, Deno KV
- Shows operation-specific methods (e.g., `MongoFindResultExpectation` vs `MongoInsertOneResultExpectation`)
- Eliminates guesswork - you see the actual available methods before writing code

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

### Common Mistakes

```typescript
// ❌ Missing export default / .build()
const s = scenario("Test").step(() => {});
// ✅ export default scenario("Test").step(() => {}).build();

// ❌ Hardcoded URLs
client.http.createHttpClient({ url: "http://localhost:8080" });
// ✅ Use env vars with fallback
client.http.createHttpClient({
  url: Deno.env.get("API_URL") ?? "http://localhost:8080",
});

// ❌ json is a property, not a method
const data = res.json<T>()!;
// ✅ Type assertion on property
const data = res.json as T | null;
```

## Checklist

- [ ] `export default` + `.build()`
- [ ] Env vars for URLs (e.g., `Deno.env.get("API_URL")`)
- [ ] Use `/probitas:probitas-expect-methods` to find correct expect methods
- [ ] Fluent assertions with `expect()` - NO `if/throw`
- [ ] Independent tests → separate scenarios
- [ ] Descriptive step names
- [ ] File: `*.probitas.ts`
