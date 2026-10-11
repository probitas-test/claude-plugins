---
description: Sync plugin content with latest Probitas documentation
---

## Workflow

1. **Fetch latest documentation**

   Use WebFetch to get the latest docs:

   - https://probitas-test.github.io/llms.txt
   - https://probitas-test.github.io/docs/scenario/index.md
   - https://probitas-test.github.io/docs/client/index.md
   - https://probitas-test.github.io/docs/expect/index.md
   - https://probitas-test.github.io/docs/configuration/index.md

2. **Review and update plugin files**

   Compare fetched docs with current plugin content:

   - `plugins/probitas/skills/*/SKILL.md` - Patterns and quick reference
   - `plugins/probitas/commands/*.md` - Slash command definitions
   - `plugins/probitas/agents/*.md` - Agent definitions

3. **Focus on**

   - New clients or assertions
   - Changed best practices
   - Updated API patterns
   - New configuration options

4. **Keep plugin content concise**

   - Rules: Essential conventions only
   - Skills: Quick patterns, link to docs for details
   - Commands: Self-contained workflows
   - Agents: Minimal, invoke skills/commands

5. **Report changes**

   Summarize what was updated and why.
