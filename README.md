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

## More information

[https://clor.com](https://clor.com)
