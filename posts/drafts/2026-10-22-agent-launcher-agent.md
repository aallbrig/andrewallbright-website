---
title: The Agent Launcher Agent
slug: agent-launcher-agent
excerpt: One cheap, locked-down agent per host whose only job is to start other agents, so I can spin up new Claude Code sessions from my phone.
categories: [AI Engineering, Platform Engineering]
tags: [Agentic Coding, Claude Code, systemd, Linux, Developer Experience]
status: draft
---

Ideas for a codebase rarely show up while I'm sitting at the desk. They show up on a walk, in the car, or while I'm waiting on something else.

Claude Code's remote control mode helps with that. I can drive a session running on my computer from my phone. It has one catch: the session has to already be running. If I think of a change to a repo that has no agent open, there's nobody home to take my message.

So I put one agent on each machine whose only purpose is to start the others. I call it the agent launcher agent.

### The pattern

For every host I want to control, I run one launcher: a small agent on Claude Haiku, started in remote control mode and named after the host. It sits in the session list on my phone next to everything else. Haiku is plenty because the work is a lookup and one command.

From the phone it goes like this:

1. I message the launcher: "start an agent on aallbrig/specbase".
2. The launcher runs one script.
3. The script clones the repo with the GitHub CLI if it isn't on the host yet.
4. The script starts a new Claude Code session at the base of that repo, also in remote control mode.
5. The new session appears in my list. I open it and start steering.

The launcher starts like this, from its own empty directory:

```bash
claude --remote-control "launcher-$(hostname)" \
  --model haiku \
  --restricted \
  --tools Bash \
  --strict-mcp-config \
  --allowedTools "Bash(spawn-agent *)" \
  --permission-mode dontAsk \
  --append-system-prompt "Your only job is to start agents. Run exactly one command, spawn-agent owner/repo, on its own: never chain it with && or ; or pipes, and never run anything else first, not even command -v. Refuse everything else."
```

The allow rule matches the command as the model types it. If the rule holds a full path and the model types the bare name, every call is denied. Use the bare name in both places and put `spawn-agent` on the launcher's `PATH`. The "never chain it" part of the prompt matters too: a Haiku that probes with `command -v spawn-agent && spawn-agent ...` gets the whole line denied.

### The script does the checking

The system prompt tells the launcher to only start agents, but a prompt is only an instruction. Anything that has to hold goes in the script:

```bash
#!/usr/bin/env bash
# spawn-agent: the only command the launcher agent is allowed to run.
set -euo pipefail

valid() { [[ "$1" =~ ^[A-Za-z0-9][A-Za-z0-9_.-]*$ && "$1" != *..* ]]; }

repo="${1:-}"
owner="${repo%%/*}"
name="${repo#*/}"
if [[ "$repo" != */* ]] || ! valid "$owner" || ! valid "$name"; then
  echo "usage: spawn-agent owner/repo" >&2
  exit 2
fi

case "$owner" in
  aallbrig) ;;
  *) echo "owner not allowed: $owner" >&2; exit 3 ;;
esac

dir="$HOME/src/$name"
if [[ ! -d "$dir/.git" ]]; then
  gh repo clone "$repo" "$dir"
fi

session="agent-$name"
if tmux has-session -t "=$session" 2>/dev/null; then
  echo "already running: $session"
  exit 0
fi

tmux new-session -d -s "$session" -c "$dir" claude --remote-control "$name"
echo "started: $session"
```

It validates the argument, allows only my own GitHub account, clones if needed, and refuses to start a second agent for the same repo.

### Locking the launcher down

- **Tools.** With those flags the launcher can run `spawn-agent` and nothing else. Asked to run `ls`, it is denied by the permission layer even when the prompt doesn't tell it to refuse. A chained command like `spawn-agent x && touch y` is denied as a whole, and so is `$(...)`.
- **The script.** A quoted argument like `'aallbrig/x; touch y'` is one argument, so it does match the allow rule. The script is what rejects it.
- **Credentials.** The GitHub CLI token on a launcher host only needs to clone, so scope it that way. The launcher never needs any other secret.
- **The operating system.** If you want the OS to enforce this too, run the launcher as its own unprivileged user, or inside a container, that can write to the source directory and talk to tmux and nothing else.

All of this applies to the launcher. The agents it starts are as powerful as each repo's own settings make them, so those need the same care as any agent session.

### First-run prompts

New directories come with questions. The launcher's own directory shows the "do you trust this folder" prompt the first time, and so does every repo the script clones. A repo that ships an `.mcp.json` adds an approval prompt for its MCP servers. A session waiting on any of these never appears on the phone, because nobody is at the terminal to answer.

So the launcher works best for repos I've already opened once on that host. For a fresh clone, I accept the prompts once at the host and start it from the phone from then on. Claude Code keeps trust in `~/.claude.json`, which every running session also writes, so I'd rather not have a script editing it behind their backs.

### Start it when the computer starts

A launcher is only useful if it's running when I need it, and I won't be at the keyboard to start it. A systemd user unit takes care of that:

```ini
[Unit]
Description=Claude launcher agent

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=%h/.local/bin/launcher start
ExecStop=%h/.local/bin/launcher stop

[Install]
WantedBy=default.target
```

The `launcher` script is a few lines of tmux: `start` creates a detached `launcher` session running the command above (and does nothing if it already exists), and `stop` kills it. Two gotchas with units like this: user units don't inherit your login `PATH`, so set it explicitly; and without `loginctl enable-linger $USER`, the user manager stops at logout and never starts at boot.

### Why the phone

From the phone I can direct and review changes while I'm out, in time I'd otherwise spend waiting. Dictation makes that practical: I can say a change request in a sentence or two instead of typing it with my thumbs.

Dictation mishears repo names now and then. The script rejects anything it doesn't recognize, so a bad guess fails loudly and I just say it again.

If you run agents on more than one machine, try putting a launcher on each. Let me know what you think in the comments below.
