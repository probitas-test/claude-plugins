---
paths: "**/*.md, **/*.json"
---

# Formatting Rules

After modifying `*.md` or `*.json` files, run `just fmt` (which runs
`deno fmt`) to ensure consistent formatting. `just ci` fails on unformatted
files.

```bash
just fmt
```
