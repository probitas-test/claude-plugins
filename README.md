# jsr-probitas Claude Plugins

Official Claude Code plugin marketplace for
[Probitas](https://jsr-probitas.github.io/documents/) ecosystem.

## Available Plugins

| Plugin                         | Description                            |
| ------------------------------ | -------------------------------------- |
| [probitas](./plugins/probitas) | Scenario testing framework integration |

## Installation

```bash
# Add this marketplace
/plugin marketplace add jsr-probitas/claude-plugins

# Install a plugin
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

## License

MIT
