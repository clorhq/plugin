---
name: slack
description: Slack messaging and event streams. Use when the user wants to post to a Slack channel or direct message, reply in a Slack thread, react to or search messages, share a file, or watch Slack workspace events.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Slack reference

<help command="clor messenger">
<summary>Send Slack messages, follow the event stream, post to channels and threads, react, share files, and build bots</summary>
<description>Send Slack messages and read the unified event stream from connected
workspaces. read and wait surface messages plus joins and leaves, reactions,
pins, channel and user events on one resumable cursor filterable by --type, so a
bot can follow everything from a single position. Every command acts as your own
connected Slack account, so it reads and posts only in the conversations that
account belongs to (plus workspace-wide events); anything else returns 403.</description>
<usage>clor messenger [flags]</usage>

<uses>
- the user wants to post a Slack message, reply in a thread, react, or share a file
- the user wants to read or wait on the Slack event stream (messages, joins, leaves, reactions, pins, channel and user events) on one cursor filtered by --type
- the user wants to build a Slack bot that reacts to new events before continuing
</uses>

<skips>
- the user wants an interactive chat client; every command is one request and one response, not a live session
</skips>

<subcommands>
- slack: Send, read the event stream, wait, react, search, and share files in a connected Slack workspace
</subcommands>

<flags>
- --help bool: help for messenger
</flags>

<global-flags>
- --clor-dir string: explicit path to the clor home directory holding config, state, and caches (overrides $CLOR_DIR; defaults to ~/.clor)
- --config string: explicit path to the TOML config file (overrides --clor-dir); defaults to <clor-dir>/config.toml
- --impersonate string: run commands as another team member by user id, like sudo (requires team admin, or a delegate grant from that member)
- --profile string: API-key profile to use for this command (overrides CLOR_PROFILE and the persisted default_profile); manage with `clor account profile`
- --stderr-file string: write stderr to this file instead of the terminal
- --stderr-format string: stderr format for progress/diagnostic events: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
- --stdout-file string: write stdout to this file instead of the terminal
- --stdout-format string: stdout format: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
</global-flags>

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</output>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

