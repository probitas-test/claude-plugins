---
description: Get available expect methods for a specific Expectation interface
model: haiku
allowed-tools: Bash
argument-hint: "<InterfaceName>"
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
  - Common interfaces: `HttpResponseExpectation`, `GraphqlResponseExpectation`, `GrpcResponseExpectation`, `ConnectRpcResponseExpectation`, `SqlQueryResultExpectation`, `RedisGetResultExpectation`, `MongoFindResultExpectation`, `RabbitMqPublishResultExpectation`, `SqsSendResultExpectation`, `AnythingExpectation` (plain values)

## Implementation

The expectation interfaces are declared in the `@probitas-test/expect` npm
package, a dependency of `@probitas-test/probitas`.

1. **Installed project** - Search the type declarations under the project's
   `node_modules` (present after installing the `package.json` that
   `probitas init` writes):

   ```bash
   find . -path '*/node_modules/@probitas-test/expect/dist/*' -name '*.d.ts' -not -path '*/_vendor/*' \
     -exec perl -ne 'if (/^export interface INTERFACE_NAME\b/) { $in = 1; next } if ($in && /^}/) { $in = 0; next } print "$1\n" if $in && /^    (\w+)[(<]/ && !$seen{$1}++' {} +
   ```

2. **Nothing installed** - If step 1 prints nothing because no
   `@probitas-test/expect` is installed, download the published package and run
   the same search on it:

   ```bash
   dir="${TMPDIR:-/tmp}/probitas-expect/node_modules/@probitas-test/expect"
   mkdir -p "$dir"
   curl -fsSL "$(curl -fsSL https://registry.npmjs.org/@probitas-test/expect/latest | jq -r .dist.tarball)" \
     | tar xz -C "$dir" --strip-components=1
   find "${TMPDIR:-/tmp}/probitas-expect" -path '*/node_modules/@probitas-test/expect/dist/*' -name '*.d.ts' -not -path '*/_vendor/*' \
     -exec perl -ne 'if (/^export interface INTERFACE_NAME\b/) { $in = 1; next } if ($in && /^}/) { $in = 0; next } print "$1\n" if $in && /^    (\w+)[(<]/ && !$seen{$1}++' {} +
   ```

Replace `INTERFACE_NAME` with the interface name provided by the user.

## Output

A clean list of method names available for that interface:

```
toBeOk
toHaveStatus
toHaveStatusEqual
toHaveJson
toHaveJsonMatching
toHaveJsonProperty
...
```

## Notes

- Use this command BEFORE writing assertions to find the most appropriate expect method
- The installed package reflects the Probitas version pinned by the project; the download fallback reflects the latest release
- For result types with multiple operation-specific expectations (Redis, MongoDB, RabbitMQ, SQS), use the specific interface name (e.g., `MongoFindResultExpectation`, not `MongoExpectation`, which is a conditional type without methods of its own)
