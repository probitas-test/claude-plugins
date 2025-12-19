# Probitas Plugin for Claude Code

Integration plugin for [Probitas](https://jsr-probitas.github.io/documents/)
scenario testing framework.

## Features

### Rules

- **conventions** - File structure, naming, and coding conventions (always
  applied)

### Skills

- **probitas** - Scenario testing knowledge and patterns (on-demand)

### Commands

| Command                    | Description                   |
| -------------------------- | ----------------------------- |
| `/probitas:init`           | Initialize a Probitas project |
| `/probitas:run [selector]` | Run scenarios                 |
| `/probitas:new <type>`     | Generate scenario template    |
| `/probitas:check`          | Run syntax check              |

### Agents

- **scenario-writer** - Specialized agent for creating integration test
  scenarios

## Installation

```bash
# Add marketplace
/plugin marketplace add jsr-probitas/claude-plugins

# Install plugin
/plugin install probitas@jsr-probitas
```

## Team Setup

Add to your project's `.claude/settings.json`:

```json
{
  "plugins": {
    "marketplaces": ["jsr-probitas/claude-plugins"],
    "installed": ["probitas@jsr-probitas"]
  }
}
```
