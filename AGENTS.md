# probitas-test Claude Plugins

Official Claude Code plugin marketplace for
[Probitas](https://probitas-test.github.io/) ecosystem.

There is no build step: the plugins are Markdown and JSON.

## How it is built

- **Each layer holds one thing.** Put a fact in the one layer that owns it,
  and nowhere else.

  | Layer          | Holds                                                |
  | -------------- | ---------------------------------------------------- |
  | `docs/adr/`    | one decision and why it was made                     |
  | `docs/spec/`   | the behaviour users and other components can rely on |
  | Plugin content | the skills, commands and agents the plugins ship     |
  | Commits        | why a change was made                                |

  Before writing, fixing or reviewing a record, read `docs/adr/README.md`;
  before writing, fixing or reviewing a spec, read `docs/spec/README.md`.
  Follow their writing order.
- **Dependencies are current.** Before adding or bumping one, look up its
  latest release in the registry. Do not copy a version from memory or from
  another repository.

When editing anything under `plugins/`, follow
[`.claude/rules/plugin-maintenance.md`](.claude/rules/plugin-maintenance.md).
For questions about Probitas itself, follow
[`.claude/rules/probitas-research.md`](.claude/rules/probitas-research.md).

## Quality gate

Run `just ci` before reporting a change as done. CI runs the same recipe. It
checks the formatting of Markdown, JSON and Nix files and that every plugin
manifest parses; `just fmt` fixes the formatting.

## Layout

| Path                              | What lives there                                                          |
| --------------------------------- | ------------------------------------------------------------------------- |
| `.claude-plugin/marketplace.json` | the marketplace definition                                                |
| `plugins/probitas/`               | the Probitas plugin: `.claude-plugin/`, `skills/`, `commands/`, `agents/` |
| `docs/`                           | ADRs and specs                                                            |
| `.claude/`                        | this repository's own rules and commands                                  |
| `.github/`                        | CI                                                                        |

## Documentation source

Plugin content is based on the Probitas documentation:

- Site: https://probitas-test.github.io/
- LLM sitemap: https://probitas-test.github.io/llms.txt

Use `/doc:update` to sync the plugin content with the latest documentation.

## Language

- README, docs and commit messages: English
- Plugin content and code comments: English

## Commits

[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), as
described in [`.gitmessage`](.gitmessage) (install it with
`git config commit.template .gitmessage`):

```
<type>[optional scope]: <description>
```

- Types: `feat`, `fix`, `deps`, `refactor`, `test`, `docs`, `style`, `chore`.
- Scopes name the area touched, such as `probitas` (the plugin) or
  `marketplace`.
