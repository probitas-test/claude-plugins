# probitas-test Claude Plugins

Official Claude Code plugin marketplace for
[Probitas](https://probitas-test.github.io/documents/) ecosystem.

## Available Plugins

| Plugin                         | Description                            |
| ------------------------------ | -------------------------------------- |
| [probitas](./plugins/probitas) | Scenario testing framework integration |

## Installation

```bash
# Add this marketplace
/plugin marketplace add probitas-test/claude-plugins

# Install a plugin
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

## License

MIT
