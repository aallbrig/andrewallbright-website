---
title: "Specbase"
slug: specbase
excerpt: "The spec oracle for AI agents and developers: a CLI, web runner and MCP server that say which documents a software project needs."
wp_post_id: 4098
url: https://specbase.net
repo: aallbrig/specbase
image: images/specbase.png
---
Specbase answers one question for people and AI agents alike: *what specification documents should exist for this kind of project?*
Pick a project type (video game, CLI tool, web app, IoT, ML/AI and more) plus features such as multiplayer or payments.
Specbase composes the matching document set from a knowledge base of 200+ spec documents, then emits a checklist, a system-prompt snippet and starter Markdown stubs.

It is agent-native. The same data is served by a single-binary CLI, a browser runner at [specbase.net/runner](https://specbase.net/runner), and an MCP server, either local over stdio or hosted at `mcp.specbase.net`, so Claude Code, Cursor and Copilot can call `get_standard_docs` directly.

![Specbase home page](specbase.png)

### Tech stack

- **Language:** Go (about 50% of the repo), with Go templates (about 22%) generating the site and doc stubs
- **CLI:** [Cobra](https://github.com/spf13/cobra), `yaml.v3`, and `santhosh-tekuri/jsonschema` to validate the knowledge base against a JSON schema
- **Agent integration:** Model Context Protocol server (stdio and remote HTTPS)
- **Web:** generated static site (HTML, CSS and a little JavaScript) with the interactive runner
- **Distribution:** GoReleaser binaries, Homebrew tap, Scoop, `go install`, Docker image
- **Tooling:** Taskfile and Makefile, Python helper scripts, infra-as-code in `infra/`, and CLAUDE.md/AGENTS.md for agent-driven development
- **License:** Apache-2.0 code, CC-BY-4.0 knowledge base

Source: [aallbrig/specbase](https://github.com/aallbrig/specbase)
