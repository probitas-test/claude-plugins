---
name: probitas-setup
description: Probitas project setup and installation. Use when initializing Probitas, setting up E2E testing, or installing probitas CLI.
---

## Instructions

Run `/probitas-init` command to initialize the project.

If `probitas` CLI not found, install first. Probitas is a single binary; Deno
is not needed.

```bash
# Shell installer (installs to ~/.local/bin)
curl -fsSL https://raw.githubusercontent.com/probitas-test/probitas/main/install.sh | sh

# Or Homebrew
brew install probitas-test/tap/probitas
```

Other channels:

- GitHub Actions: `uses: probitas-test/setup-probitas@v2`
- Nix: the `github:probitas-test/probitas` flake provides `packages.default`
  and `overlays.default`

To stay on Probitas 1.x (Deno), pin `PROBITAS_VERSION=1.0.0` for the installer
or use `probitas-test/setup-probitas@v1`.

## Created Files

`probitas init` creates a `probitas/` directory containing:

- `example.probitas.ts` - Sample scenario
- `probitas.jsonc` - Configuration
- `package.json` - Pins `@probitas-test/probitas` to the CLI version
- `tsconfig.json` - TypeScript settings matching how scenarios run

Install the `package.json` with a package manager (`npm install`,
`bun install`, ...) inside that directory. Scenarios run without it, but it
provides editor support and is required by `probitas check`.

Scenarios that use Node.js APIs (`process.env`, `node:fs/promises`, `Buffer`,
...) also need the Node.js types, or `probitas check` reports `process` and
friends as unknown. Make sure both are present (`probitas init` in 2.0.0 does
not add them yet):

- `package.json`: `"@types/node"` in `devDependencies` (e.g. `npm install -D @types/node`)
- `tsconfig.json`: `"types": ["node"]` in `compilerOptions`

## Third-Party Modules

Only Probitas itself is embedded in the binary. Install other modules into the
same `package.json` and import them by bare name; `npm:` / `jsr:` specifiers
are not resolved.

```bash
npm install ms              # then: import ms from "ms";
npx jsr add @std/assert     # then: import { assertEquals } from "@std/assert";
```
