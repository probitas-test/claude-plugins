---
description: List available scenarios with filtering
model: haiku
---

## Usage

```bash
# List all scenarios
probitas list

# List scenarios in specific directory
probitas list api/

# Filter by tag
probitas list -s tag:smoke

# Filter by name
probitas list -s "Login"

# Exclude scenarios
probitas list -s "!tag:slow"

# JSON output
probitas list --json
```

## Selector Syntax

```bash
# Tag matching
-s tag:api              # Scenarios with @api tag
-s "!tag:slow"          # Exclude @slow tag

# Name matching
-s "Login"              # Name contains "Login" (case-insensitive)
-s "!wip"               # Exclude names containing "wip"

# AND condition (comma-separated)
-s "tag:api,tag:smoke"  # @api AND @smoke tags
-s "tag:api,User"       # @api tag AND name contains "User"

# OR condition (multiple -s)
-s tag:smoke -s tag:api # @smoke OR @api tags
```

## File Pattern Options

```bash
--include "api/**/*.ts"         # Include pattern
--exclude "**/*.skip.ts"        # Exclude pattern
```

## Environment Variables

```bash
probitas list                   # Loads .env automatically
probitas list --env .env.test   # Load custom env file
probitas list --no-env          # Skip loading .env
```

## Output

Lists discovered scenarios with their metadata:

- Scenario name
- File path
- Tags
- Description (if available)

Use `--json` for machine-readable output.

## Notes

- Uses patterns from config file or defaults to `**/*.probitas.ts`
- Selectors are case-insensitive
- `.env` file is automatically loaded before listing (use `--no-env` to skip)

## Documentation

https://probitas-test.github.io/
