---
description: Run format, lint, and type check for scenarios
allowed-tools: Bash, Read, Edit
---

## Workflow

1. **Format** - Run `probitas fmt` (same output as `deno fmt`; `--check` only reports)
2. **Lint** - Run `probitas lint` (Biome recommended rules)
3. **Check** - Run `probitas check` (TypeScript checker built into the binary)
4. **Fix** - If issues found, fix them and repeat

```bash
probitas fmt
probitas lint
probitas check
```

Fix issues iteratively until all pass.

## Notes

- `probitas check` resolves `@probitas-test/probitas` from the project. If it
  reports the module as missing, install the `package.json` written by
  `probitas init` (e.g. `npm install` in the `probitas/` directory).
- If it reports `process`, `Buffer` or `node:*` modules as unknown, add
  `@types/node` to `package.json` (`npm install -D @types/node`) and
  `"types": ["node"]` to `compilerOptions` in `tsconfig.json`.
- Scenarios importing `jsr:@probitas/probitas` (1.x) still run but do not
  type-check; change the import to `@probitas-test/probitas`.
- Silence a lint finding only when it is intentional, with
  `// biome-ignore lint/<group>/<rule>: <reason>`.
