# Clor

Give your AI agent super skills. Web research, AI generation, email,
cloud files, secrets, and more, all behind one API key.

Jump to your agent:

- [Claude Code](#claude-code)
- [Codex](#codex)

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

## More information

[https://clor.com](https://clor.com)
