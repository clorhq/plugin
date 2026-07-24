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


<help command="clor memory analytics">
<summary>Report how much your agents have run, by token and tool-call counts</summary>
<description>Exact counts of how much your agents have worked, split by agent, model,
and tool. bucket=day is ready for heatmaps, bucket=month gives monthly reports,
bucket=total gives lifetime counts.

Use when:
  - the user asks how many tokens their agents used, per day or model
  - the user asks which tools an agent uses and how often

Subcommands:
  tokens  Token usage per day, month, or lifetime, by agent and model
  tools   Tool-call counts per day, month, or lifetime, by agent and tool

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor memory analytics</usage>

<subcommands>
- tokens: Report exact token usage per day, month, or lifetime, split by agent and model
- tools: Report tool-call counts per day, month, or lifetime, split by agent and tool
</subcommands>
</help>


<help command="clor memory analytics tokens">
<summary>Report exact token usage per day, month, or lifetime, split by agent and model</summary>
<usage>clor memory analytics tokens [flags]</usage>

<flags>
- --agent string: restrict to one agent (claude|codex)
- --bucket string: time bucket (day|month|total)
- --model string: restrict to one model name
- --since string: inclusive lower time bound, RFC3339 or a relative age (24h, 7d)
- --until string: inclusive upper time bound, RFC3339 or a relative age (24h, 7d)
</flags>

<output>json outputs the whole envelope {buckets[]}. jsonl outputs each bucket on its own line; text is the logfmt of the same keys. Day buckets are heatmap-ready.</output>

<output-example format="json">
{
  "buckets": [
    {
      "agent": "claude",
      "bucket": "2026-07-15",
      "cache_creation_tokens": 120331,
      "cache_read_tokens": 1204552,
      "event_count": 389,
      "input_tokens": 48213,
      "model": "claude-fable-5",
      "output_tokens": 9874
    },
    {
      "agent": "codex",
      "bucket": "2026-07-15",
      "cache_creation_tokens": 0,
      "cache_read_tokens": 88412,
      "event_count": 96,
      "input_tokens": 12050,
      "model": "gpt-5.6-sol",
      "output_tokens": 3311
    }
  ]
}
</output-example>

<examples-good>
- clor memory analytics tokens --bucket total    # precise lifetime counts per agent and model
- clor memory analytics tokens --since 30d --stdout-format json | jq '.buckets'    # a month of daily buckets for a heatmap
- clor memory analytics tokens --bucket month --agent claude --model claude-fable-5    # monthly usage of one model
</examples-good>

<examples-bad>
- clor memory analytics tokens --bucket week    # bucket must be day, month, or total
- clor memory analytics tokens claude    # tokens takes no arguments; use --agent claude
</examples-bad>
</help>


<help command="clor memory analytics tools">
<summary>Report tool-call counts per day, month, or lifetime, split by agent and tool</summary>
<usage>clor memory analytics tools [flags]</usage>

<flags>
- --agent string: restrict to one agent (claude|codex)
- --bucket string: time bucket (day|month|total)
- --since string: inclusive lower time bound, RFC3339 or a relative age (24h, 7d)
- --until string: inclusive upper time bound, RFC3339 or a relative age (24h, 7d)
</flags>

<output-example format="json">
{
  "buckets": [
    {
      "agent": "claude",
      "bucket": "2026-07-15",
      "tool_name": "Bash",
      "use_count": 214
    },
    {
      "agent": "claude",
      "bucket": "2026-07-15",
      "tool_name": "Read",
      "use_count": 156
    }
  ]
}
</output-example>

<examples-good>
- clor memory analytics tools --bucket total    # lifetime tool-call counts
- clor memory analytics tools --since 7d --agent claude    # this week's claude tool usage per day
- clor memory analytics tools --bucket total --stdout-format json | jq '.buckets | sort_by(-.use_count)[:5]'    # top five tools
</examples-good>

<examples-bad>
- clor memory analytics tools --bucket hourly    # bucket must be day, month, or total
- clor memory analytics tools --model claude-fable-5    # tools has no model split; that is analytics tokens
</examples-bad>
</help>

<help command="clor memory document">
<summary>Store, read, search, and link documents in the shared markdown wiki</summary>
<description>A shared markdown wiki every one of your agents can read and write, on any
machine. Use it to leave durable notes, decisions, runbooks, and context that
the next agent picks up. Each agent's own CLAUDE.md and project memory files
show up here too. Documents can link to other documents, to past sessions, and
to URLs.

Use when:
  - the user wants a durable note their agents can read anywhere
  - you want to record a decision or context for the next agent
  - the user asks what an agent has written down or remembered
  - a document should point at a session or a reference URL

Subcommands:
  list    List documents, most recently updated first
  get     Print one document's markdown
  put     Create or replace one document from stdin
  delete  Delete one document and its links
  link    Link a document to another document, a session, or a URL
  unlink  Remove one link
  links   List one document's links
  search  Search document names, titles, and bodies

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor memory document</usage>

<subcommands>
- delete: Delete one document and its links
- get: Print one document's markdown body
- link: Attach a link from a document to another document, a session, or a URL
- links: List one document's links
- list: List documents in the wiki, most recently updated first
- put: Create or replace one document with markdown from stdin
- search: Search document names, titles, and bodies by free text
- unlink: Remove one link from a document
</subcommands>
</help>


<help command="clor memory document delete">
<summary>Delete one document and its links</summary>
<usage>clor memory document delete <NAME></usage>

<output-example format="json">
{
  "deleted": true
}
</output-example>

<examples-good>
- clor memory document delete notes/deploys.md    # removes the document and its links
- clor memory document delete notes/deploys.md --stdout-format json | jq '.deleted'    # whether anything was removed
- clor memory document list --stdout-format json | jq -r '.documents[].name' | grep ^scratch/ | xargs -n1 clor memory document delete    # bulk-delete a prefix
</examples-good>

<examples-bad>
- clor memory document delete    # the document name argument is required
- clor memory document delete --all    # there is no --all; delete by name
</examples-bad>
</help>


<help command="clor memory document get">
<summary>Print one document's markdown body</summary>
<usage>clor memory document get <NAME></usage>

<output>text prints the raw markdown body; json outputs {document, body}.</output>

<output-example format="json">
{
  "body": "# Deploy notes\n\n- run the smoke checks before rollout\n",
  "document": {
    "body_bytes": 1467,
    "content_hash": "8a1f0c2e4d5b6a7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c",
    "created": "2026-07-12T18:25:33Z",
    "id": "0198a0f4-1b2c-7d3e-9f4a-5b6c7d8e9f0a",
    "name": "notes/deploys.md",
    "title": "Deploy notes",
    "updated": "2026-07-16T08:41:09Z"
  }
}
</output-example>

<examples-good>
- clor memory document get notes/deploys.md    # the raw markdown body
- clor memory document get claude/workstation/CLAUDE.md    # an agent's synced CLAUDE.md by its full name
- clor memory document get notes/deploys.md --stdout-format json | jq '.document.content_hash'    # the stored hash
</examples-good>

<examples-bad>
- clor memory document get    # the document name argument is required
- clor memory document get CLAUDE.md    # synced names carry an agent/hostname prefix; find the full name with document list
</examples-bad>
</help>


<help command="clor memory document link">
<summary>Attach a link from a document to another document, a session, or a URL</summary>
<usage>clor memory document link <NAME> <TARGET> [flags]</usage>

<flags>
- --caption string: short label for the link
- --target-type string: what the target is (document|session|url) (default "url")
</flags>

<output-example format="json">
{
  "link": {
    "caption": "deploy dashboard",
    "created": "2026-07-16T08:45:02Z",
    "document_id": "0198a0f4-1b2c-7d3e-9f4a-5b6c7d8e9f0a",
    "id": "0198a0f5-3c4d-7e5f-8a9b-1c2d3e4f5a6b",
    "target": "https://grafana.example.com",
    "target_type": "url",
    "updated": "2026-07-16T08:45:02Z"
  }
}
</output-example>

<examples-good>
- clor memory document link notes/deploys.md https://grafana.example.com --caption "deploy dashboard"    # URL link with a caption
- clor memory document link notes/deploys.md 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b --target-type session    # point at a past session
- clor memory document link notes/deploys.md runbooks/oncall.md --target-type document    # cross-reference another document
</examples-good>

<examples-bad>
- clor memory document link notes/deploys.md    # both the document name and the target are required
- clor memory document link notes/deploys.md x --target-type page    # target-type must be document, session, or url
</examples-bad>
</help>


<help command="clor memory document links">
<summary>List one document's links</summary>
<usage>clor memory document links <NAME></usage>

<output-example format="json">
{
  "count": 1,
  "links": [
    {
      "caption": "deploy dashboard",
      "created": "2026-07-16T08:45:02Z",
      "document_id": "0198a0f4-1b2c-7d3e-9f4a-5b6c7d8e9f0a",
      "id": "0198a0f5-3c4d-7e5f-8a9b-1c2d3e4f5a6b",
      "target": "https://grafana.example.com",
      "target_type": "url",
      "updated": "2026-07-16T08:45:02Z"
    }
  ]
}
</output-example>

<examples-good>
- clor memory document links notes/deploys.md    # every link on the document
- clor memory document links notes/deploys.md --stdout-format json | jq '.links[].target'    # just the targets
- clor memory document links notes/deploys.md | grep target_type=session    # only the session links
</examples-good>

<examples-bad>
- clor memory document links    # the document name argument is required
- clor memory document links notes/deploys.md extra    # links takes exactly one name
</examples-bad>
</help>


<help command="clor memory document list">
<summary>List documents in the wiki, most recently updated first</summary>
<usage>clor memory document list [flags]</usage>

<flags>
- --agent string: restrict to documents from one agent (claude|codex)
- --hostname string: restrict to documents from one machine
- --limit int: maximum results (1-1000)
- --offset int: results to skip for pagination
- --space-id string: restrict to one space
</flags>

<output-example format="json">
{
  "count": 2,
  "documents": [
    {
      "agent": "claude",
      "body_bytes": 5212,
      "content_hash": "1d9e8f7a6b5c4d3e2f1a0b9c8d7e6f5a4b3c2d1e0f9a8b7c6d5e4f3a2b1c0d9e",
      "created": "2026-07-10T07:02:58Z",
      "hostname": "alien",
      "id": "0198a0f4-6e7f-7a8b-9c0d-1e2f3a4b5c6d",
      "name": "claude/alien/CLAUDE.md",
      "path": "/home/jake/.claude/CLAUDE.md",
      "updated": "2026-07-16T06:30:12Z"
    },
    {
      "body_bytes": 1467,
      "content_hash": "8a1f0c2e4d5b6a7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c",
      "created": "2026-07-12T18:25:33Z",
      "id": "0198a0f4-1b2c-7d3e-9f4a-5b6c7d8e9f0a",
      "name": "notes/deploys.md",
      "title": "Deploy notes",
      "updated": "2026-07-16T08:41:09Z"
    }
  ]
}
</output-example>

<examples-good>
- clor memory document list    # every stored document
- clor memory document list --agent claude --hostname workstation    # claude documents from one machine
- clor memory document list --stdout-format json | jq '.documents[].name'    # just the names
</examples-good>

<examples-bad>
- clor memory document list notes.md    # list takes no arguments; use document get <NAME>
- clor memory document list --agent gemini    # agent must be claude or codex
</examples-bad>
</help>


<help command="clor memory document put">
<summary>Create or replace one document with markdown from stdin</summary>
<usage>clor memory document put <NAME> [flags]</usage>

<flags>
- --space-id string: space the document belongs to
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --title string: display title
</flags>

<output-example format="json">
{
  "document": {
    "body_bytes": 1467,
    "content_hash": "8a1f0c2e4d5b6a7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c",
    "created": "2026-07-12T18:25:33Z",
    "id": "0198a0f4-1b2c-7d3e-9f4a-5b6c7d8e9f0a",
    "name": "notes/deploys.md",
    "title": "Deploy notes",
    "updated": "2026-07-16T08:41:09Z"
  }
}
</output-example>

<examples-good>
- echo '# Deploy notes' | clor memory document put notes/deploys.md    # create or replace from a pipe
- clor memory document put notes/deploys.md --stdin-file ./deploys.md --title "Deploy notes"    # upload a local file with a title
- clor memory document put runbooks/oncall.md --stdin-file ./oncall.md --stdout-format json | jq '.document.content_hash'    # hash of the stored body
</examples-good>

<examples-bad>
- clor memory document put notes/deploys.md ./deploys.md    # the body comes from stdin or --stdin-file, not a positional path
- clor memory document put    # the document name argument is required
</examples-bad>
</help>


<help command="clor memory document search">
<summary>Search document names, titles, and bodies by free text</summary>
<usage>clor memory document search <QUERY> [flags]</usage>

<flags>
- --limit int: maximum results (1-1000)
- --offset int: results to skip for pagination
</flags>

<output-example format="json">
{
  "count": 1,
  "documents": [
    {
      "body_bytes": 1467,
      "content_hash": "8a1f0c2e4d5b6a7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c",
      "created": "2026-07-12T18:25:33Z",
      "id": "0198a0f4-1b2c-7d3e-9f4a-5b6c7d8e9f0a",
      "name": "notes/deploys.md",
      "title": "Deploy notes",
      "updated": "2026-07-16T08:41:09Z"
    }
  ]
}
</output-example>

<examples-good>
- clor memory document search walrus    # documents mentioning walrus, best match first
- clor memory document search "deploy checklist" --limit 5    # quoted phrase, top five matches
- clor memory document search oncall --stdout-format json | jq '.documents[].name'    # matching names
</examples-good>

<examples-bad>
- clor memory document search    # the query argument is required
- clor memory document search "AND ("    # malformed search syntax; quote literal phrases
</examples-bad>
</help>


<help command="clor memory document unlink">
<summary>Remove one link from a document</summary>
<usage>clor memory document unlink <NAME> <TARGET> [flags]</usage>

<flags>
- --target-type string: what the target is (document|session|url) (default "url")
</flags>

<output-example format="json">
{
  "deleted": true
}
</output-example>

<examples-good>
- clor memory document unlink notes/deploys.md https://grafana.example.com    # remove a URL link
- clor memory document unlink notes/deploys.md runbooks/oncall.md --target-type document    # remove a document cross-reference
- clor memory document unlink notes/deploys.md 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b --target-type session --stdout-format json | jq '.deleted'    # whether the link existed
</examples-good>

<examples-bad>
- clor memory document unlink notes/deploys.md    # both the document name and the target are required
- clor memory document unlink notes/deploys.md x --target-type page    # target-type must be document, session, or url
</examples-bad>
</help>

<help command="clor memory reset">
<summary>Erase all recorded history and every wiki document for your account</summary>
<description>Erases everything recorded for your account, both the session history and
the shared wiki. Ongoing agent activity keeps being recorded after a reset.</description>
<usage>clor memory reset</usage>

<rules>
- Irreversible; there is no undo
</rules>

<output-example format="json">
{
  "reset": true
}
</output-example>

<examples-good>
- clor memory reset    # erases everything recorded for your account
- clor memory reset --stdout-format json | jq '.reset'    # machine-readable confirmation
- clor memory reset --stdout-format jsonl    # one-line machine-readable confirmation
</examples-good>

<examples-bad>
- clor memory reset <SESSION_ID>    # reset takes no arguments; delete one session with session delete
- clor memory reset --team    # memory belongs to your account; there is no team-wide reset
</examples-bad>
</help>

<help command="clor memory search">
<summary>Search everything your agents have said, run, and decided, newest first</summary>
<description>Full-text search across everything your coding agents have said and done,
including their messages, thinking, commands, tool calls, and results. This is
how you recover context from earlier work. Find where an agent worked on
something, the command that fixed a bug, a past decision, or an error from
weeks ago. Quote literal phrases and combine terms with AND, OR, and NOT.
Without --since the search covers the last 28 days.</description>
<usage>clor memory search <QUERY> [flags]</usage>

<flags>
- --agent string: restrict to one agent (claude|codex)
- --limit int: maximum results (1-1000)
- --offset int: results to skip for pagination
- --session-id string: restrict to one session
- --since string: inclusive lower time bound, RFC3339 or a relative age (24h, 7d)
- --space-id string: restrict to one space
- --type string: restrict to one event type (user_message|assistant_message|thinking|tool_use|tool_result|system)
- --until string: inclusive upper time bound, RFC3339 or a relative age (24h, 7d)
</flags>

<output>json outputs the whole envelope {events[], count}. jsonl outputs each event on its own line; text is the logfmt of the same keys, an event=search header then one event=result line per match.</output>

<output-example format="json">
{
  "count": 1,
  "events": [
    {
      "abstract": "go test -run TestRetry -count=20 ./cli/daemon/",
      "agent": "claude",
      "block": 0,
      "cache_creation_tokens": 0,
      "cache_read_tokens": 0,
      "id": "0198a1b3-2f6e-7a1c-8b4d-5e6f7a8b9c0d",
      "input_tokens": 0,
      "line": 207,
      "model": "claude-fable-5",
      "occurred": "2026-07-15T09:48:17Z",
      "output_tokens": 0,
      "session_id": "0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b",
      "sidechain": false,
      "tool_name": "Bash",
      "type": "tool_use"
    }
  ]
}
</output-example>

<examples-good>
- clor memory search "flaky test"    # matches from the last 28 days, newest first
- clor memory search walrus --since 90d --agent claude --type tool_use    # claude tool calls mentioning walrus over three months
- clor memory search "rate limit" --stdout-format json | jq '.events[].session_id'    # session ids of every match
- clor memory search deploy | grep '^event=result '    # just the match lines
</examples-good>

<examples-bad>
- clor memory search    # the query argument is required
- clor memory search deploy --type shell    # type must be one of the listed event types
</examples-bad>
</help>

<help command="clor memory session">
<summary>List, inspect, replay, and delete past agent sessions</summary>
<description>Each session is one run of a coding agent, with its full transcript,
messages, and tool calls. Subagents a run spawns are sessions of their own,
linked back to their parent. Use this to see what an agent actually did, step
by step, or to pull an exact transcript back.

Use when:
  - the user wants to see recent agent activity or find a past session
  - the user wants the full transcript of a session replayed
  - a session should be removed from the history

Subcommands:
  list        List sessions, most recently active first
  show        Show one session's summary, activity, and token totals
  events      Walk one session's messages, commands, and results in order
  transcript  Replay a session's raw transcript exactly as it happened
  delete      Delete a session and the subagents it spawned

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor memory session</usage>

<subcommands>
- delete: Delete a session and the subagents it spawned
- events: List one session's messages, commands, and results in order
- list: List past agent sessions, most recently active first
- show: Show one session's summary, activity, and token totals
- transcript: Print raw transcript lines exactly as the agent wrote them
</subcommands>
</help>


<help command="clor memory session delete">
<summary>Delete a session and the subagents it spawned</summary>
<description>Removes the session's transcript and everything recorded from it. Deleting
a parent also deletes the subagents it spawned. Token and tool counts already
tallied stay in the usage reports.</description>
<usage>clor memory session delete <ID></usage>

<output-example format="json">
{
  "deleted_session_count": 3
}
</output-example>

<examples-good>
- clor memory session delete 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b    # removes the session and its subagent sessions
- clor memory session delete 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b --stdout-format json | jq '.deleted_session_count'    # how many sessions were removed
- clor memory session list --query scratch --stdout-format json | jq -r '.sessions[].id' | xargs -n1 clor memory session delete    # bulk-delete matching sessions
</examples-good>

<examples-bad>
- clor memory session delete    # the session id argument is required
- clor memory session delete --all    # there is no --all; use clor memory reset to drop everything
</examples-bad>
</help>


<help command="clor memory session events">
<summary>List one session's messages, commands, and results in order</summary>
<usage>clor memory session events <ID> [flags]</usage>

<flags>
- --limit int: maximum results (1-1000)
- --offset int: results to skip for pagination
- --type string: restrict to one event type (user_message|assistant_message|thinking|tool_use|tool_result|system)
</flags>

<output-example format="json">
{
  "count": 1,
  "events": [
    {
      "abstract": "go test -run TestRetry -count=20 ./cli/daemon/",
      "agent": "claude",
      "block": 0,
      "cache_creation_tokens": 0,
      "cache_read_tokens": 0,
      "id": "0198a1b3-2f6e-7a1c-8b4d-5e6f7a8b9c0d",
      "input_tokens": 0,
      "line": 207,
      "model": "claude-fable-5",
      "occurred": "2026-07-15T09:48:17Z",
      "output_tokens": 0,
      "session_id": "0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b",
      "sidechain": false,
      "tool_name": "Bash",
      "type": "tool_use"
    }
  ]
}
</output-example>

<examples-good>
- clor memory session events 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b    # the session's events in order
- clor memory session events 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b --type tool_use    # just the tool calls
- clor memory session events 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b --stdout-format json | jq '.events[].abstract'    # readable extracts of every event
</examples-good>

<examples-bad>
- clor memory session events    # the session id argument is required
- clor memory session events <ID> --type bash    # type is an event class, not a tool name; filter tools with search --type tool_use
</examples-bad>
</help>


<help command="clor memory session list">
<summary>List past agent sessions, most recently active first</summary>
<usage>clor memory session list [flags]</usage>

<flags>
- --agent string: restrict to one agent (claude|codex)
- --hostname string: restrict to sessions run on one machine
- --limit int: maximum results (1-1000)
- --offset int: results to skip for pagination
- --parent-id string: restrict to subagent sessions of this parent session id
- --query string: substring match over title, slug, cwd, git branch, and identifier
- --since string: inclusive lower time bound, RFC3339 or a relative age (24h, 7d)
- --space-id string: restrict to one space
- --subagents string: whether subagent sessions appear (include|exclude|only)
- --until string: inclusive upper time bound, RFC3339 or a relative age (24h, 7d)
</flags>

<output>json outputs the whole envelope {sessions[], count}. jsonl outputs each session on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "count": 1,
  "sessions": [
    {
      "active": "2026-07-15T10:03:41Z",
      "agent": "claude",
      "cache_creation_tokens": 120331,
      "cache_read_tokens": 1204552,
      "created": "2026-07-15T09:12:05Z",
      "cwd": "/home/jake/repos/clor",
      "event_count": 389,
      "event_line_count": 412,
      "git_branch": "main",
      "hostname": "alien",
      "id": "0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b",
      "input_tokens": 48213,
      "model": "claude-fable-5",
      "output_tokens": 9874,
      "session_identifier": "e7f3b8a1-5c2d-4e9f-b6a0-3d8c1f4e7a92",
      "started": "2026-07-15T09:12:04Z",
      "stored_bytes": 214886,
      "title": "Fix the flaky retry test",
      "transcript_bytes": 1842733,
      "transcript_line_count": 412,
      "updated": "2026-07-15T10:03:42Z"
    }
  ]
}
</output-example>

<examples-good>
- clor memory session list    # most recently active sessions
- clor memory session list --agent claude --subagents exclude --since 7d    # this week's main claude sessions
- clor memory session list --query clor --stdout-format json | jq '.sessions[].id'    # ids of sessions matching a working directory or title
</examples-good>

<examples-bad>
- clor memory session list <ID>    # list takes no arguments; use session show <ID>
- clor memory session list --subagents none    # subagents must be include, exclude, or only
</examples-bad>
</help>


<help command="clor memory session show">
<summary>Show one session's summary, activity, and token totals</summary>
<usage>clor memory session show <ID></usage>

<output-example format="json">
{
  "months": [
    {
      "first_line": 0,
      "line_count": 412,
      "month": "2026-07",
      "stored_bytes": 214886,
      "transcript_bytes": 1842733
    }
  ],
  "session": {
    "active": "2026-07-15T10:03:41Z",
    "agent": "claude",
    "cache_creation_tokens": 120331,
    "cache_read_tokens": 1204552,
    "created": "2026-07-15T09:12:05Z",
    "cwd": "/home/jake/repos/clor",
    "event_count": 389,
    "event_line_count": 412,
    "git_branch": "main",
    "hostname": "alien",
    "id": "0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b",
    "input_tokens": 48213,
    "model": "claude-fable-5",
    "output_tokens": 9874,
    "session_identifier": "e7f3b8a1-5c2d-4e9f-b6a0-3d8c1f4e7a92",
    "started": "2026-07-15T09:12:04Z",
    "stored_bytes": 214886,
    "title": "Fix the flaky retry test",
    "transcript_bytes": 1842733,
    "transcript_line_count": 412,
    "updated": "2026-07-15T10:03:42Z"
  },
  "subagent_session_count": 2
}
</output-example>

<examples-good>
- clor memory session show 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b    # totals plus one event=month line per stored month
- clor memory session show 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b --stdout-format json | jq '.session.input_tokens'    # exact input tokens for one session
- clor memory session list --limit 1 --stdout-format json | jq -r '.sessions[0].id' | xargs clor memory session show    # inspect the most recent session
</examples-good>

<examples-bad>
- clor memory session show    # the session id argument is required
- clor memory session show my-session-name    # pass the server-assigned id from session list, not a title
</examples-bad>
</help>


<help command="clor memory session transcript">
<summary>Print raw transcript lines exactly as the agent wrote them</summary>
<description>Replays a session's raw transcript exactly as it happened. text prints the
raw lines straight to stdout; json wraps them in {first_line, line_count,
lines[]}.</description>
<usage>clor memory session transcript <ID> [flags]</usage>

<flags>
- --first-line int64: zero-based first transcript line
- --line-count int64: lines to return (1-10000)
</flags>

<output-example format="json">
{
  "first_line": 0,
  "line_count": 2,
  "lines": [
    "{\"type\":\"user\",\"timestamp\":\"2026-07-15T09:12:04.618Z\",\"message\":{\"role\":\"user\",\"content\":\"Fix the flaky retry test\"}}",
    "{\"type\":\"assistant\",\"timestamp\":\"2026-07-15T09:12:09.204Z\",\"message\":{\"role\":\"assistant\",\"model\":\"claude-fable-5\",\"content\":[{\"type\":\"text\",\"text\":\"Looking at the test now.\"}]}}"
  ]
}
</output-example>

<examples-good>
- clor memory session transcript 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b    # the first thousand raw lines
- clor memory session transcript 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b --first-line 2000 --line-count 500    # a later slice of a long session
- clor memory session transcript 0198a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b --stdout-format json | jq '.line_count'    # how many lines came back
</examples-good>

<examples-bad>
- clor memory session transcript    # the session id argument is required
- clor memory session transcript <ID> --line-count 50000    # at most 10000 lines per request; page with --first-line
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

