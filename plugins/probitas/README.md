# Probitas Plugin for Claude Code

Integration plugin for [Probitas](https://probitas-test.github.io/documents/)
scenario testing framework.

## Features

### Skills

- **probitas-info** - Framework overview and features
- **probitas-setup** - CLI installation and project setup
- **probitas-write** - Scenario writing (delegates to agent)
- **probitas-run** - Running and debugging scenarios

### Commands

| Command                    | Description                   |
| -------------------------- | ----------------------------- |
| `/probitas-init`           | Initialize a Probitas project |
| `/probitas-run [selector]` | Run scenarios                 |
| `/probitas-list`           | List available scenarios      |
| `/probitas-check`          | Run format, lint, type check  |
| `/probitas-expect-methods` | Get available expect methods  |

### Agents

- **scenario-writer** - Create and edit `*.probitas.ts` files

## Installation

```bash
# Add marketplace
/plugin marketplace add probitas-test/claude-plugins

# Install plugin
/plugin install probitas@probitas-test
```

## Team Setup

Add to your project's `.claude/settings.json`:

```json
{
  "plugins": {
    "marketplaces": ["probitas-test/claude-plugins"],
    "installed": ["probitas@probitas-test"]
  },
  "enabledPlugins": {
    "probitas@probitas-test": true
  }
}
```
