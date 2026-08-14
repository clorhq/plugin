---
name: clor
description: Clor's umbrella toolbox for cross-capability workflows. Use when the user explicitly asks about Clor or needs one workflow spanning multiple distinct capabilities such as web research, generation, email, files, secrets, weather, or domains.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---


## You run clor, the user does not

Execute clor commands yourself. Do not hand the user CLI snippets to paste, walk them through flags, explain subcommand syntax, or say "you can run...". If clor needs information only the user has (a secret value, a choice between options, confirmation of a side effect), ask in plain English, then run the command. Report results, not recipes.

## Routing defaults

Use `clor` when the user explicitly asks for Clor, `clor`, `/clor`, or a toolbox domain shown in `clor --help`.

If the user writes `/clor ...`, interpret it as a request to use `clor ...`.

Before using unfamiliar flags, read the relevant `--help`. Do not invent flags.

## What clor is

`clor` is a toolbox of direct subcommands for one-off agent-run work: web research, AI inference, social reads, email, cloud files, secrets, weather, domain availability, more. See the embedded `clor --help` below.

## State that outlives the session

If work produces something the user needs later (a report, a dataset, intermediate output), persist it to `clor drive` rather than `/tmp` or the working directory. Credentials belong in `clor secret`; mail stays in the inbox itself.

## Side effects

Before sending external messages or moving files off the user's machine, confirm recipient and account with the user if they were not already supplied. If the user already gave those details, act.

## After acting

Report only operational facts:
- command run and its result
- any setup the user must complete (e.g. `clor email account add`, `clor secret set`)

## Toolbox commands

<help command="clor">
<summary>Fast web research, AI text/image/audio inference, social-platform research, email, cloud files, encrypted secrets, and bulk domain name checking, and more</summary>
<description>One CLI with many services: web research, inference across Claude/GPT/Gemini/ElevenLabs (text, images, audio), social-platform reads, email over IMAP/SMTP, cloud-stored files with Unix-style verbs, encrypted JSON secrets, and bulk domain name checking, and more.

New here? Run `clor account login` first (browser approval; the
issued API key is saved automatically and reused by every subcommand).
Then run `clor <subcommand> --help` on any group to see flags,
output shapes, and runnable examples. `clor --long-help` dumps
every subcommand's help in one shot if you want the whole tree.</description>
<usage>clor [flags]</usage>

<uses>
- no API key is configured yet: start with `clor account login` to open a browser approval flow; the issued key is saved automatically
- the user asks for current, recent, or post-knowledge-cutoff information from the open web, or wants a URL scraped/parsed/mapped/crawled/screenshotted (`clor search ...`)
- the user wants to delegate text generation, classification, or summarization to Claude, GPT, or Gemini (`clor inference anthropic|openai|gemini text`)
- the user wants AI image generation or editing (Gemini nano-banana, OpenAI gpt-image) (`clor inference ... image`)
- the user wants AI audio: text-to-speech, transcription, music, sound effects, voice isolation, or voice change (`clor inference elevenlabs ...` / `clor inference openai whisper transcribe`)
- the user asks what people are saying on Hacker News and other social platforms (`clor social hn ...`)
- the user wants to read, search, send, or triage email over IMAP/SMTP (`clor email ...`)
- the user wants persistent cloud file storage with personal and shared drives, ACL grants, and public links (`clor drive ...`)
- the user wants to store or retrieve encrypted JSON secrets for the signed-in user (`clor secret ...`)
- the user wants to bulk-classify domain names as available, taken, or unknown across hundreds of TLDs (`clor domain ...`)
- the user wants to install or upgrade this CLI, the daemon service, or the plugin inside Claude Code or Codex; just run `clor install`, it is idempotent and handles both fresh installs and upgrades
- the user wants to check who is signed in, their credit balance, recharge settings, or recent per-service usage (`clor account ...`)
- the user holds keys for several accounts and wants to switch between them or add another (`clor account profile ...`, or the `--profile` flag for one command)
- the user wants to read or write the global configuration (api.base_url, api.control_plane_base_url, idea and notification toggles) (`clor config ...`)
</uses>

<subcommands>
- account: Sign in, see who is signed in (whoami), credit balance, recharge settings, and per-service usage
- admin: List team members and grant or revoke who can run commands as whom, for team admins
- agent: Save Claude and Codex settings, credentials, and skills, install them into your local agent
- bluesky: Post to Bluesky and read it: timeline, feeds, threads, search, follow, like, notifications, direct messages
- connection: List the GitHub, Linear, and Slack accounts connected to this account
- domain: Bulk-classify domain names as available, taken, or unknown across hundreds of TLDs at huge scale
- drive: Store, share, and link cloud files in personal and shared drives with ACL grants, public links, and Unix verbs (ls, cp, mv, rm, df)
- email: Read, search, send, and triage email over IMAP and SMTP
- github: Use connected GitHub accounts for tokens and git credentials
- gitlab: Use connected GitLab accounts for tokens and git credentials
- hn: Use Hacker News as a client: read feeds and threads, comment, submit, poll, vote, flag, favorite, hide, edit, delete
- inference: Generate text, images, and audio through Claude, GPT, Gemini, OpenRouter, and ElevenLabs
- install: Install or upgrade the CLI and daemon, sync skills into Claude Code and Codex
- linear: Read and update Linear issues, projects, cycles, initiatives, documents, and workspace records
- memory: Search everything your coding agents have done and share a markdown wiki they all read and write
- messenger: Send Slack messages, follow the event stream, post to channels and threads, react, share files, and build bots
- node: List and hide registered daemon hosts
- notification: Read, filter, and mark read notifications from services, spaces, and the system
- repo: Host private git repos cloned, fetched, and pushed over HTTPS, with per-member access tokens and shares
- runner: Create and manage a long-lived cloud runner
- search: Search the web (pages, news, images, videos), then scrape, parse, map, crawl, or screenshot URLs
- secret: Store and retrieve named JSON secrets for the signed-in user
- site: Publish static sites and single-page apps over HTTPS with custom domains, atomic deploys, rollbacks, and private sharing
- social: Search Hacker News stories and comments plus Y Combinator companies and founders
- space: Create, list, stop, resume, and delete spaces on your computers
- support: Email the team for help, bug reports, and feature requests
- template: Render Go html and text templates with variables, partials, Markdown, and a curated function set
- tunnel: Expose a local HTTP or WebSocket server on the public internet at a stable subdomain or an ephemeral link, run by the daemon
- uninstall: Remove the plugin, service, and skills from every detected agent (leaves the CLI binary)
- version: Print the compiled CLI version (mirrors `--version` but supports --stdout-format for parsing)
- weather: Look up weather forecasts, air quality, astronomy, marine conditions, alerts, and location data
- webagent: Serve and control coding agents (Claude or Codex) through browser chat pages and local Unix sockets
- webdev: Run a repository's dev servers with live previews, logs, sharing, and publishing in a browser
- webgit: Work with Git changes in a browser
- webmd: Show a repository's markdown documents as a live browser pane
- webtui: Serve a terminal command as an interactive web page: htop, vim, or any TUI on a PTY, streamed to the browser over WebSocket
</subcommands>

<flags>
- --clor-dir string: explicit path to the clor home directory holding config, state, and caches (overrides $CLOR_DIR; defaults to ~/.clor)
- --config string: explicit path to the TOML config file (overrides --clor-dir); defaults to <clor-dir>/config.toml
- --help bool: help for clor
- --impersonate string: run commands as another team member by user id, like sudo (requires team admin, or a delegate grant from that member)
- --profile string: API-key profile to use for this command (overrides CLOR_PROFILE and the persisted default_profile); manage with `clor account profile`
- --stderr-file string: write stderr to this file instead of the terminal
- --stderr-format string: stderr format for progress/diagnostic events: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
- --stdout-file string: write stdout to this file instead of the terminal
- --stdout-format string: stdout format: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
- --version bool: version for clor
</flags>

<output>stdout carries results; stderr carries progress events plus help and --debug lifecycle logs. Every subcommand inherits persistent root flags `--stdout-format text|jsonl|json` (default `text` is logfmt with an `event=` leader), `--stderr-format text|jsonl|json`, plus `--stdout-file` and `--stderr-file` for redirecting either stream to a file. Pipe JSON to `jq`; for logfmt, `grep '^event=result '` keeps only the per-record lines.</output>

<examples-good>
- clor account login    # first run: opens browser approval; prints the resume `clor account claim <TOKEN>` command
- clor account login --wait    # one-shot sign-in: prints URL, blocks until the user approves, persists the key
- clor search web "openai news" --stdout-format json | jq '.results[].url'    # open-web search piped through jq
- clor inference anthropic text "summarize this in 3 bullets" --model claude-sonnet-4-6    # delegate a text task to Claude
- clor <subcommand> --help    # show flags, output shape, and runnable examples for any subcommand
</examples-good>

<examples-bad>
- clor    # bare invocation renders the human status dashboard (signing in first if needed); pass `--help` for the overview
- clor --stdout-format json    # the root command has no result to render; the format flag is meaningful only on leaf subcommands
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

