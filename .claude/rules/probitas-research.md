# Probitas Research Rules

When asked about Probitas framework or needing Probitas-related information, **ALWAYS follow this priority order**:

## 1. Plugin Resources (Highest Priority)

Check `plugins/probitas/` for existing documentation:

- **Skills** (`skills/*/SKILL.md`): Core concepts, quick examples
  - `probitas-info`: Framework overview, features, client list
  - `probitas-setup`: Project initialization patterns
  - `probitas-write`: Scenario writing conventions
  - `probitas-run`: Execution patterns
- **Commands** (`commands/*.md`): CLI usage patterns
  - `probitas-init`, `probitas-new`, `probitas-run`, etc.
- **Agents** (`agents/*.md`): Specialized workflows
  - `scenario-writer`: Scenario generation patterns

## 2. Official Documentation

If plugin resources don't cover the question:

- **LLM Sitemap**: https://probitas-test.github.io/documents/llms.txt
  - Comprehensive documentation optimized for AI consumption
  - Use WebFetch to retrieve specific sections

## 3. API Reference

For detailed API information:

```bash
deno doc jsr:@probitas/probitas
deno doc jsr:@probitas/probitas/client/http
deno doc jsr:@probitas/probitas/client/[client-name]
```

## Anti-Patterns

**DO NOT**:

- Search the web first without checking plugin resources
- Guess Probitas APIs or patterns without verification
- Use outdated information from general knowledge

**DO**:

- Reference plugin skills for quick answers
- Fetch official docs for detailed explanations
- Use `deno doc` for precise API signatures

## Examples

| Question                         | First Action                                         |
| -------------------------------- | ---------------------------------------------------- |
| "What is Probitas?"              | Reference `probitas-info` skill                      |
| "How to write scenarios?"        | Reference `probitas-write` skill                     |
| "Available clients?"             | Check `probitas-info` client table                   |
| "GraphQL client API?"            | Run `deno doc jsr:@probitas/probitas/client/graphql` |
| "Advanced scenario patterns?"    | WebFetch LLM sitemap section                         |
| "How to initialize new project?" | Reference `probitas-init` command                    |

## Rationale

This plugin repository **IS the authoritative source** for Probitas information within this project. Plugin content is synced from official docs via `/doc:update`, ensuring accuracy and freshness.
