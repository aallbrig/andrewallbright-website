---
title: "Treemand"
slug: treemand
excerpt: "A Go CLI that maps any command-line tool's help output into a navigable tree and lets you build commands interactively."
wp_post_id: 3902
url: https://aallbrig.github.io/treemand
repo: aallbrig/treemand
image: images/treemand.png
---
Most of us explore an unfamiliar CLI by running `--help` again and again, one subcommand at a time.
Treemand does that crawl for you. It introspects a tool's help output, builds the whole command hierarchy and prints it as a tree, or as JSON or YAML for scripting.
In interactive mode (`-i`) a keyboard-driven terminal UI lets you browse commands, pick flags, fill positional arguments, and copy or run the assembled command.

![Treemand documentation site](treemand.png)

### Tech stack

- **Language:** Go (about 98% of the repo)
- **TUI:** [Bubble Tea](https://github.com/charmbracelet/bubbletea), Bubbles and Lip Gloss from Charm
- **CLI plumbing:** Cobra and Viper, zerolog for logging, `go-sqlite3` for caching discovered trees, `atotto/clipboard`
- **Release and docs:** GitHub Actions CI, Homebrew tap, prebuilt binaries, a docs site on GitHub Pages with a recorded terminal demo (VHS tape)
- **Quality:** golangci-lint, Go workspace layout, Taskfile
- **License:** MIT

Source: [aallbrig/treemand](https://github.com/aallbrig/treemand)
