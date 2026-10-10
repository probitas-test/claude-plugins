---
name: probitas-info
description: Information about Probitas framework. Use when asked "what is Probitas", explaining its purpose, features, or comparing with other test frameworks.
---

## What is Probitas?

Scenario-based E2E testing framework for backend services (APIs, databases,
message queues). It ships as a single `probitas` binary (built on Bun); no
other runtime is needed to run scenarios.

## Key Features

| Feature           | Description                                         |
| ----------------- | --------------------------------------------------- |
| Scenario-Based    | Tests as readable scenarios with steps              |
| Built-in Clients  | HTTP, gRPC, GraphQL, SQL, Redis, MongoDB, queues    |
| Fluent Assertions | Unified `expect()` with chainable checks            |
| Auto Cleanup      | Resources with automatic cleanup                    |
| Batteries         | faker, FakeTime, spy, stub included                 |
| Single Binary     | `run`, `list`, `init`, `fmt`, `lint`, `check` built |

## Quick Example

```typescript
import { client, expect, scenario } from "@probitas-test/probitas";

export default scenario("API Test", { tags: ["http"] })
  .resource("http", () =>
    client.http.createHttpClient({
      url: process.env.API_URL ?? "http://localhost:8080",
    }))
  .step("GET /users", async (ctx) => {
    const res = await ctx.resources.http.get("/users");
    expect(res).toBeOk().toHaveStatus(200);
  })
  .build();
```

## Available Clients

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
| RabbitMQ   | `client.rabbitmq.createRabbitMqClient()`     | AMQP message queues  |
| SQS        | `client.sqs.createSqsClient()`               | AWS message queues   |

The DuckDB native binding is downloaded on first use; run
`probitas cache duckdb` ahead of time for CI images or offline machines.

## API Reference

The library is published to npm as `@probitas-test/probitas` (and to JSR as
`@probitas/probitas`). Read the type declarations, which carry the JSDoc:

- In a project set up by `probitas init` (after installing its `package.json`):
  `node_modules/@probitas-test/probitas/dist/**/*.d.ts`, and the expectation
  interfaces in `node_modules/@probitas-test/expect/dist/**/*.d.ts`
- Online: https://jsr.io/@probitas/probitas/doc (subpaths such as
  `/doc/client/http`, `/doc/client/sql/postgres`, `/doc/expect`)

## Migrating from 1.x

Probitas 1.x ran on Deno. See
https://github.com/probitas-test/probitas/blob/main/MIGRATION.md for the
changes (imports, `Deno.*` APIs, removed Deno KV client, commands).

## Documentation

- LLM sitemap: https://probitas-test.github.io/llms.txt
