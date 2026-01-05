---
description: Get available expect methods for a specific Expectation interface
model: haiku
---

## Usage

```bash
# Get methods for HTTP response expectations
/probitas:probitas-expect-methods HttpResponseExpectation

# Get methods for SQL query result expectations
/probitas:probitas-expect-methods SqlQueryResultExpectation

# Get methods for MongoDB find result expectations
/probitas:probitas-expect-methods MongoFindResultExpectation

# Get methods for RabbitMQ publish result expectations
/probitas:probitas-expect-methods RabbitMqPublishResultExpectation
```

## Parameters

- **Interface name** (required): The Expectation interface name to query
  - Common interfaces: `HttpResponseExpectation`, `GraphqlResponseExpectation`, `SqlQueryResultExpectation`, `RedisExpectation`, `MongoFindResultExpectation`, `RabbitMqPublishResultExpectation`, `SqsSendResultExpectation`, `DenoKvGetResultExpectation`

## Implementation

Run the following command with the provided interface name:

```bash
deno doc --json jsr:@probitas/expect 2>/dev/null | jq -r '.nodes[] | select(.name == "INTERFACE_NAME") | .interfaceDef.methods[] | .name'
```

Replace `INTERFACE_NAME` with the interface name provided by the user.

## Output

A clean list of method names available for that interface:

```
toBeOk
toHaveStatus
toHaveStatusText
toHaveJson
toHaveJsonMatching
toHaveJsonProperty
...
```

## Notes

- Use this command BEFORE writing assertions to find the most appropriate expect method
- The output reflects the actual current API from the installed Probitas version
- For result types with multiple operation-specific expectations (MongoDB, RabbitMQ, SQS, Deno KV), use the specific interface name (e.g., `MongoFindResultExpectation`, not just `MongoExpectation`)
