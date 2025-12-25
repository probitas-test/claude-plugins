---
description: Run scenarios with optional selector
---

```bash
# Without selector
probitas run

# With selector (e.g., /probitas-run user)
probitas run -s $ARGUMENTS
```

## Selector Examples

```bash
probitas run -s tag:api             # Match tag
probitas run -s "!tag:slow"         # Exclude tag
probitas run -s "tag:api,!tag:slow" # AND condition
probitas run -s user                # Match scenario name
```

If `probitas` command not found, fetch installation instructions from:
https://probitas-test.github.io/documents/docs/installation/index.md

If failures occur, explain cause and suggest fixes.
