---
description: Initialize a Probitas project
model: haiku
allowed-tools: Bash, Read
---

```bash
probitas init
ls -la probitas/
```

`probitas init` writes `example.probitas.ts`, `probitas.jsonc`, `package.json`
(pinning `@probitas-test/probitas` to the CLI version) and `tsconfig.json`.

Install that `package.json` with the project's package manager so editors and
`probitas check` can resolve the Probitas types:

```bash
cd probitas && npm install   # or bun install, pnpm install, ...
```

Scenarios that use Node.js APIs (`process.env`, `node:fs/promises`, ...) need
the Node.js types for `probitas check`. If `package.json` has no
`@types/node` (`probitas init` 2.0.0 does not add it), add it and list it in
`tsconfig.json`:

```bash
npm install -D @types/node   # then set "types": ["node"] in tsconfig.json compilerOptions
```

If `probitas` command not found, fetch installation instructions from:
https://probitas-test.github.io/docs/installation/index.md

Report created files to user.
