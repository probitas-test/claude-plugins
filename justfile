# Run `nix develop` (or use direnv) first so every tool is on PATH.

set shell := ["bash", "-euo", "pipefail", "-c"]

# List the recipes.
default:
    @just --list

# Format the Markdown, JSON and Nix files.
fmt:
    deno fmt
    git ls-files -z '*.nix' | xargs -0 nixfmt

# Check formatting without changing files.
fmt-check:
    deno fmt --check
    git ls-files -z '*.nix' | xargs -0 nixfmt --check

# Check that the marketplace and every plugin manifest parse as JSON.
check-manifests:
    jq empty .claude-plugin/marketplace.json plugins/*/.claude-plugin/plugin.json

# Everything CI runs.
ci: fmt-check check-manifests
