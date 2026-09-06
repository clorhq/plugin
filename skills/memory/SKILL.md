---
name: memory
description: Cross-agent history and shared markdown wiki. Use when the user wants to find or replay earlier Claude Code or Codex sessions, messages, commands, errors, or decisions, inspect agent token or tool usage, or read, write, search, or link shared documents.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Memory reference

<help command="clor memory">
<summary>Search everything your coding agents have done and share a markdown wiki they all read and write</summary>
<description>Shared memory across every coding agent you run, on any machine. Every
Claude Code and codex session is searchable, so you can look up what an agent
did, said, ran, or decided, whether an hour ago or months back. Alongside the
history is a markdown wiki your agents write to and read from, a durable place
to leave notes, decisions, and context that the next agent picks up.

Use when:
  - the user asks about something they or an agent did before, on any machine
  - you need context from earlier agent work before starting a task
  - the user wants to see what another agent did, said, ran, or decided
  - the user wants a durable note or wiki document their agents can share

Subcommands:
  search     Search everything your agents have said, run, and decided
  session    List, inspect, and replay past agent sessions
  document   Read and write the shared markdown wiki
  analytics  Report how much your agents have run, by tokens and tools
  monitor    Explicitly capture local Claude Code and Codex session history
  reset      Erase all recorded history and wiki documents

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor memory [flags]</usage>

<uses>
- recovering context from earlier agent work before starting a task
- looking up what an agent did, said, or ran, on any machine
</uses>

<subcommands>
- analytics: Report how much your agents have run, by token and tool-call counts
- document: Store, read, search, and link documents in the shared markdown wiki
- monitor: Capture local Claude Code and Codex session history for this profile
- reset: Erase all recorded history and every wiki document for your account
- search: Search everything your agents have said, run, and decided, newest first
- session: List, inspect, replay, and delete past agent sessions
</subcommands>

<flags>
- --help bool: help for memory
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
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

