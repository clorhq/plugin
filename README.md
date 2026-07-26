# Clor

Give your AI agent super skills. Web research, AI generation, email,
cloud files, secrets, and more, all behind one API key.

Jump to your agent:

- [Claude Code](#claude-code)
- [Codex](#codex)
- [Gemini CLI](#gemini-cli)
- [OpenCode](#opencode)
- [OpenClaw](#openclaw)
- [Cursor](#cursor)
- [Hermes](#hermes)

Then: [what you get](#what-you-get) · [automate with /claw](#automate-with-claw)
· [troubleshooting](#troubleshooting)

---

## Claude Code

### 1. Install

```sh
curl https://clor.com/install.sh | bash
```

Installs the CLI, signs you in through your browser, and adds the
plugin to Claude Code.

### 2. Reload plugins

If you had Claude Code open during install, run

```
/reload-plugins
```

inside the session. New sessions load the plugin automatically.

### 3. Use it automatically

Ask in plain language and Claude picks the right clor skill on its
own:

```
What's the latest news on the federal reserve interest rate decision?
Scrape https://example.com and summarise it.
Generate an image of a watercolor sunrise.
```

### 4. Invoke a specific skill

Prefix with `/`:

```
/clor scrape https://example.com as markdown
/clor generate a 30-second upbeat synthwave intro
/clor transcribe ./meeting.m4a
```

---

## Codex

### 1. Install

```sh
curl https://clor.com/install.sh | bash
```

Installs the CLI, signs you in through your browser, and registers
the clor marketplace with Codex.

### 2. Start a new session

Quit any open `codex` session and start a new one. Inside that new
session, run

```
/plugins
```

pick `clor` from the `Clor` marketplace, and install it (Codex needs
a one-time confirmation; the installer has already registered the
marketplace).

### 3. Use it automatically

Ask in plain language:

```
What's the latest news on the federal reserve interest rate decision?
Scrape https://example.com and summarise it.
Generate an image of a watercolor sunrise.
```

### 4. Invoke a specific skill

In Codex, skills use a `$` prefix:

```
$clor scrape https://example.com as markdown
$clor search the web for the best coffee shops in Brooklyn
$clor transcribe ./meeting.m4a
```

---

## Gemini CLI

### 1. Install

```sh
curl https://clor.com/install.sh | bash
```

Installs the CLI, signs you in through your browser, and adds the
extension to Gemini CLI.

### 2. Start a new session

Quit any open `gemini` session and start a new one. New sessions
load the extension automatically.

### 3. Use it automatically

Ask in plain language:

```
What's the latest news on the federal reserve interest rate decision?
Scrape https://example.com and summarise it.
Generate an image of a watercolor sunrise.
```

### 4. Invoke a specific skill

Prefix with `/`:

```
/clor scrape https://example.com as markdown
/clor search the web for the best coffee shops in Brooklyn
/clor transcribe ./meeting.m4a
```

---

## OpenCode

### 1. Install

```sh
curl https://clor.com/install.sh | bash
```

Installs the CLI, signs you in through your browser, and adds the
plugin to your `opencode.json`.

### 2. Start a new session

Quit any open `opencode` session and start a new one.

### 3. Use it automatically

Ask in plain language:

```
What's the latest news on the federal reserve interest rate decision?
Scrape https://example.com and summarise it.
Generate an image of a watercolor sunrise.
```

### 4. Invoke a specific skill

Prefix with `/`:

```
/clor scrape https://example.com as markdown
/clor generate a 30-second upbeat synthwave intro
```

---

## OpenClaw

### 1. Install

```sh
curl https://clor.com/install.sh | bash
```

Installs the CLI, signs you in through your browser, and adds the
plugin to OpenClaw.

### 2. Start a new session

Quit any open `openclaw` session and start a new one.

### 3. Use it automatically

Ask in plain language:

```
What's the latest news on the federal reserve interest rate decision?
Scrape https://example.com and summarise it.
```

### 4. Invoke a specific skill

Prefix with `/`:

```
/clor scrape https://example.com as markdown
/clor transcribe ./meeting.m4a
```

---

## Cursor

### 1. Install

```sh
curl https://clor.com/install.sh | bash
```

Installs the CLI, signs you in through your browser, and drops the
skills into `~/.cursor/skills/clor/`.

### 2. Start a new chat

Reload the Cursor window or open a new chat to pick up the new
skills.

### 3. Use it automatically

Ask in plain language in any Cursor chat:

```
What's the latest news on the federal reserve interest rate decision?
Scrape https://example.com and summarise it.
Generate an image of a watercolor sunrise.
```

### 4. Invoke a specific skill

Prefix with `/`:

```
/clor scrape https://example.com as markdown
/clor search the web for the best coffee shops in Brooklyn
```

---

## Hermes

### 1. Install

```sh
curl https://clor.com/install.sh | bash
```

Installs the CLI, signs you in through your browser, and adds the
skills to Hermes.

### 2. Reload skills

Either start a new `hermes` session, or run

```
/skills reload
```

inside an existing chat.

### 3. Use it automatically

Ask in plain language:

```
What's the latest news on the federal reserve interest rate decision?
Scrape https://example.com and summarise it.
```

### 4. Invoke a specific skill

Prefix with `/`:

```
/clor scrape https://example.com as markdown
/clor transcribe ./meeting.m4a
```

---

## What you get

Every agent above loads the same set of skills. Your agent picks the
right one on its own; you only need this list to know what is on the
table.

| Skill | What it does |
| --- | --- |
| `websearch` | Search the web (pages, news, images, videos), then scrape, parse, map, crawl, or screenshot URLs |
| `ai` | Generate text, images, and audio through Claude, GPT, Gemini, OpenRouter, and ElevenLabs |
| `claw` | Create and run async agents on a schedule or on demand with full tool use, MCP servers, and skills |
| `email` | Read, search, send, and triage email over IMAP and SMTP |
| `drive` | Store, share, and link cloud files with ACL grants, public links, and Unix verbs |
| `secret` | Store and retrieve named JSON secrets for the signed-in user |
| `memory` | Search everything your coding agents have done, and share a wiki they all read and write |
| `site` | Publish static sites and SPAs over HTTPS with custom domains, atomic deploys, rollbacks, and basic auth |
| `tunnel` | Expose a local HTTP or WebSocket server at a stable subdomain or an ephemeral link |
| `space` | Create, list, stop, resume, and delete disposable agent environments on your nodes |
| `slack` | Post to channels and threads, react, share files, follow the event stream, build bots |
| `bluesky` | Timeline, feeds, threads, search, follow, like, notifications, direct messages |
| `hackernews` | Read feeds and threads, comment, submit, poll, vote, favorite, hide, edit, delete |
| `linear` | Read and update issues, projects, cycles, initiatives, and documents |
| `weather` | Forecasts, air quality, astronomy, marine conditions, alerts, and location data |
| `domains` | Bulk-classify domain names as available, taken, or unknown across hundreds of TLDs |
| `yc` | Search Y Combinator companies and founders by text, batch, industry, region, or tag |
| `clor` | The umbrella skill, for workflows that span several of the above |

---

## Automate with /claw

Claws are subagents that run in the background or on a schedule. Each
claw runs as a real agent with full tool use, reusing the same skills,
CLIs, and tools your coding agent already has, so anything you can ask
your agent to do once a claw can do unattended. Think of it as an
agentic cron job that reasons about what it finds and acts on it.

Invoke the skill with `/claw` (or `$claw` in Codex):

```
/claw watch https://example.com and email me when the pricing changes
/claw every weekday at 8am send me the top 5 Hacker News stories
/claw back up my notes drive folder every night
```

The skill lists the claws you own, creates new ones from scratch or
imports ready-made ones from the library, edits their tasks and
schedule, runs them on demand, replays past run output, and pauses or
deletes them. Invoked with no specific request it shows the claws you
already have and asks what to do next.

---

## Troubleshooting

**The skills do not show up.** Every agent caches its plugin list at
session start. Quit the session and start a new one, or use the reload
step in your agent's section above. Claude Code has `/reload-plugins`;
Hermes has `/skills reload`; the rest need a fresh session.

**The agent says `clor` is not found.** The skills shell out to the
`clor` CLI, which the installer puts in `~/.local/bin`. Confirm with
`which clor`, and add that directory to your `PATH` if your shell does
not already have it.

**Commands fail with an auth error.** Run `clor account login`. It opens
a browser approval flow and saves the issued API key for every
subcommand. `clor account whoami` shows who is currently signed in.

**Check what is installed.** `clor --version` prints the CLI version and
`clor --help` lists every subcommand. To reinstall or upgrade, run
`clor install`; it is idempotent and handles both.

### Uninstall

```sh
clor uninstall
```

Removes the plugin, service, and skills from every detected agent. The
CLI binary itself is left in place; delete `~/.local/bin/clor` to remove
it too.

---

## More information

[https://clor.com](https://clor.com)
