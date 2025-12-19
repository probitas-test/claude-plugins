---
paths: "plugins/**/*"
---

# Claude Code Plugin Maintenance Guide

When creating or modifying plugin configuration files, follow these
context-optimization principles.

## Configuration Selection Framework

Choose configuration type based on **when context should load** and **how
context should be shared**:

| Type        | Trigger      | Context Isolation | Startup Loading                |
| ----------- | ------------ | ----------------- | ------------------------------ |
| `rules/`    | Startup/Path | Shared            | Full (lazy if paths specified) |
| `commands/` | User         | Shared            | None                           |
| `skills/`   | Auto         | Shared            | Description only               |
| `agents/`   | Auto/User    | Isolated          | Description only               |

## Anti-Patterns to Avoid

1. **Context bloat**: Move task-specific procedures to slash commands
2. **Duplicated content**: If skill and command overlap, have skill invoke the
   command
3. **Shared rules in multiple agents**: Extract to skill (conditional)
4. **Heavyweight tasks in main context**: Use agent when trial-and-error would
   pollute context

## Best Practices

### Rules

- Keep concise, essential conventions only
- Use `paths:` frontmatter for conditional loading
- Avoid detailed procedures (move to commands)

### Skills

- Include `name:` and `description:` in frontmatter
- Description should be specific enough for auto-discovery
- Mention related commands for discoverability
- Keep patterns minimal, link to docs for details

### Commands

- Include `description:` in frontmatter
- Self-contained, no external context required
- Clear workflow steps

### Agents

- Include `name:` and `description:` in frontmatter
- Keep focused on unique purpose
- Invoke skills for reusable workflows
- Invoke commands for standard procedures

## Skills + Commands Integration Pattern

For tasks needing both auto-detection AND manual invocation:

```yaml
---
# skills/example/SKILL.md
name: example
description: Brief description. Use when agent needs to do X.
---
Use `/example:command` slash command to do X.
```

Benefits:

- Auto-triggers when Claude detects intent
- Allows explicit command for manual control
- Eliminates duplication

## Agents vs Skills

| Aspect   | Skills                        | Agents                            |
| -------- | ----------------------------- | --------------------------------- |
| Context  | Shared with main conversation | Isolated subprocess               |
| Results  | Full context visible          | Only final result returned        |
| Best for | Deterministic workflows       | Exploratory/trial-and-error tasks |
