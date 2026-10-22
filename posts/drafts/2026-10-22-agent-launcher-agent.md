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

For every host I want to control, I run one launcher. It is a small, low powered agent (Claude Haiku is plenty) started in remote control mode and named after the host. On my phone, a launcher named for each host (`launcher-laptop`, say) sits in the session list next to my other sessions.

The work is a lookup and one command, so I don't pay for a big model. Here is the whole flow:

1. I message the launcher: "start an agent on aallbrig/specbase".
2. The launcher runs one script.
3. The script clones the repo with the GitHub CLI if it isn't on the host yet.
4. The script starts a new Claude Code session at the base of that repo, also in remote control mode.
5. The new session shows up in my session list. I open it and start steering.

The launcher starts like this:

```bash
claude --remote-control "launcher-$(hostname)" \
  --model haiku \
  --restricted \
  --tools Bash \
  --allowedTools "Bash($HOME/.local/bin/spawn-agent *)" \
  --permission-mode dontAsk \
  --append-system-prompt "Your only job is to run spawn-agent owner/repo. Refuse everything else."
```

### The script is the guard

I don't want the model's judgment to be the safety boundary. A prompt that says "only start agents" is a request, not a limit. So the launcher gets exactly one command it may run, and the script behind that command does the real checking:

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

It validates the argument, allows only my own GitHub account, clones if needed, and refuses to start a second agent for the same repo. Test it against stub versions of `gh`, `tmux` and `claude` before trusting it: a normal repo should start once, a repeat should say "already running", and strings like `aallbrig/..` or `aallbrig/$(id)` should be rejected.

### Sandboxing the launcher

Think of it as layers, each one assuming the one above it failed.

- **Tools.** `--restricted` removes the built-in tools that run commands or code. `--tools Bash` gives back only Bash, `--allowedTools` matches only the spawn script, and `--permission-mode dontAsk` denies everything else instead of pinging my phone with a prompt.
- **The script.** Permission patterns are matching text, so I don't lean on them alone. The script re-checks its input and refuses anything unexpected.
- **Credentials.** The GitHub CLI token on a launcher host only needs to clone, so scope it that way. The launcher never needs any other secret.
- **The operating system.** If you want the OS to enforce this too, run the launcher as its own unprivileged user, or inside a container, that can write to the source directory and talk to tmux and nothing else.

One honest limit. This sandbox constrains the launcher, not the agents it starts. Each spawned session is as powerful as that repo's own settings allow, so those still deserve the same care you give any agent session.

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

Steering from the phone means I can direct and review changes while I'm on the move, in the gaps of the day I used to lose. Dictation makes it practical: I can speak a change request in a sentence or two instead of thumbing it out.

Speech is good at intent and bad at spelling, which is another reason the script is strict. If dictation turns a repo name into something else, the launcher fails loudly instead of guessing, and I just say it again.

If you run agents on more than one machine, try putting a launcher on each. One small agent that only knows how to start other agents turned out to be the missing piece for me. Let me know what you think in the comments below.
