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


<help command="clor messenger slack">
<summary>Send, read the event stream, wait, react, search, and share files in a connected Slack workspace</summary>
<description>Send messages and follow the full Slack event stream in a connected workspace,
plus react, share files, and search. read and wait expose one resumable cursor
over messages, joins and leaves, reactions, pins, channel and user events,
filterable by --type, so you can build bot-style automation on Slack. Every
command acts as your connected Slack account and reads or posts only in
conversations that account belongs to (plus workspace-wide events), so acting
anywhere else returns 403. Pass --workspace with a team id from "workspace list";
a CHANNEL is a name such as #general or an id such as C0123ABC.</description>
<usage>clor messenger slack</usage>

<uses>
- the user wants to post to a channel or thread, react, share a file, or read what was said
- the user wants to follow the Slack event stream (messages plus joins, leaves, reactions, pins, channel and user events) on one cursor, filtered by --type
- the user wants to build a Slack bot that reacts to new messages, mentions, reactions, or members joining
- the user wants to wait for a new event before continuing
</uses>

<subcommands>
- conversation: List the channels and DMs you belong to
- file: Share a file to a channel or download a stored file
- reaction: Add or remove an emoji reaction
- read: Read the stored Slack event stream from a cursor, oldest first
- search: Search messages you can see
- send: Send a Slack message to a channel or thread
- thread: Read a thread's replies
- wait: Block until new Slack events arrive or a timeout elapses
- workspace: List the workspaces you have connected
</subcommands>

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</output>
</help>


<help command="clor messenger slack conversation">
<summary>List the channels and DMs you belong to</summary>
<description>List the channels and direct messages your connected account belongs to in a
workspace, the conversations you can read and post to. Names resolve to ids for
the other commands. The work happens in the list subcommand, which takes the
required --workspace team id.</description>
<usage>clor messenger slack conversation</usage>

<uses>
- the user wants the channels and DMs the connected account can read or post to
- the user needs a channel id for another command
</uses>

<subcommands>
- list: List the channels and DMs you belong to in a workspace
</subcommands>

<examples-good>
- clor messenger slack conversation list --workspace T0123ABC    # list the channels and DMs in a workspace
</examples-good>

<examples-bad>
- clor messenger slack conversation --workspace T0123ABC    # the flags live on the list subcommand, run conversation list --workspace ...
- clor messenger slack conversation    # a group, call its list subcommand
</examples-bad>
</help>


<help command="clor messenger slack conversation list">
<summary>List the channels and DMs you belong to in a workspace</summary>
<description>List the channels and direct messages your connected account is a member of,
the conversations you can read and post to. Names resolve to ids for the other
commands. Pass --refresh to pull the latest membership from Slack before
listing.</description>
<usage>clor messenger slack conversation list [flags]</usage>

<flags>
- --refresh bool: refresh the directory from Slack before listing
- --workspace string: slack team id of the workspace (required)
</flags>

<output>json outputs the whole envelope {conversations[]}. jsonl outputs each record from conversations on its own line; text is the logfmt of the same keys, an event=conversations header line then one event=conversation line per record.</output>

<output-example format="json">
{
  "conversations": [
    {
      "bot_member": true,
      "id": "C0123ABC",
      "name": "general",
      "topic": "Company-wide announcements",
      "type": "channel"
    },
    {
      "id": "D0789GHI",
      "name": "alice",
      "type": "im"
    }
  ]
}
</output-example>

<examples-good>
- clor messenger slack conversation list --workspace T0123ABC    # list cached channels and DMs
- clor messenger slack conversation list --workspace T0123ABC --refresh --stdout-format json | jq '.conversations[].name'    # refresh from Slack then list names
- clor messenger slack conversation list --workspace T0123ABC | grep '^event=conversation '    # conversation lines only
</examples-good>

<examples-bad>
- clor messenger slack conversation list    # missing required --workspace
- clor messenger slack conversation    # conversation is a group, call its list subcommand
</examples-bad>
</help>


<help command="clor messenger slack file">
<summary>Share a file to a channel or download a stored file</summary>
<usage>clor messenger slack file</usage>

<subcommands>
- get: Download a stored file's bytes
- send: Share a local file into a channel
</subcommands>
</help>


<help command="clor messenger slack file get">
<summary>Download a stored file's bytes</summary>
<description>Download the bytes of a file by its FILE_ID, which appears on stored messages
that carry attachments. You can only download a file shared into a conversation
you can see; otherwise the download returns 403. Write to a path with --output,
or stream to stdout when --output is empty or -.</description>
<usage>clor messenger slack file get <FILE_ID> [flags]</usage>

<flags>
- --output string: path to write the file to; - or empty writes to stdout
- --workspace string: slack team id of the workspace (required)
</flags>

<examples-good>
- clor messenger slack file get F0123ABC --workspace T0123ABC --output ./report.pdf    # download to a file
- clor messenger slack file get F0123ABC --workspace T0123ABC > out.bin    # stream bytes to stdout
- clor messenger slack file get F0123ABC --workspace T0123ABC --output - | shasum    # pipe bytes to another tool
</examples-good>

<examples-bad>
- clor messenger slack file get --workspace T0123ABC    # missing required <FILE_ID>
- clor messenger slack file get F0123ABC    # missing required --workspace
</examples-bad>
</help>


<help command="clor messenger slack file send">
<summary>Share a local file into a channel</summary>
<description>Upload the local file at PATH and share it into a channel by id or name. You
must be a member of the channel; sharing where you are not returns 403. Set a
display title with --title and share into a thread with --thread.</description>
<usage>clor messenger slack file send <PATH> [flags]</usage>

<flags>
- --channel string: channel id or name to share the file into (required)
- --thread string: thread_ts to share the file into
- --title string: title for the shared file
- --workspace string: slack team id of the workspace (required)
</flags>

<output>json outputs the whole envelope {file_id, channel}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "channel": "C0123ABC",
  "file_id": "F0123ABC"
}
</output-example>

<examples-good>
- clor messenger slack file send ./report.pdf --workspace T0123ABC --channel C0123ABC    # upload a file to a channel
- clor messenger slack file send ./diagram.png --workspace T0123ABC --channel "#design" --title "v2 layout"    # upload with a title
- clor messenger slack file send ./log.txt --workspace T0123ABC --channel C0123ABC --thread 1700000000.000100 --stdout-format json | jq .file_id    # share into a thread, read the file id
</examples-good>

<examples-bad>
- clor messenger slack file send --workspace T0123ABC --channel C0123ABC    # missing required <PATH>
- clor messenger slack file send ./a.pdf --workspace T0123ABC    # missing required --channel
</examples-bad>
</help>


<help command="clor messenger slack reaction">
<summary>Add or remove an emoji reaction</summary>
<usage>clor messenger slack reaction</usage>

<subcommands>
- add: Add an emoji reaction to a message
- remove: Remove an emoji reaction from a message
</subcommands>
</help>


<help command="clor messenger slack reaction add">
<summary>Add an emoji reaction to a message</summary>
<usage>clor messenger slack reaction add [flags]</usage>

<flags>
- --channel string: channel id or name the message is in (required)
- --name string: emoji name without colons, e.g. thumbsup (required)
- --ts string: message id to react to (required)
- --workspace string: slack team id of the workspace (required)
</flags>

<output>json outputs the whole envelope {ok}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "ok": true
}
</output-example>

<examples-good>
- clor messenger slack reaction add --workspace T0123ABC --channel C0123ABC --ts 1700000000.000100 --name thumbsup    # add a reaction
- clor messenger slack reaction add --workspace T0123ABC --channel "#general" --ts 1700000000.000100 --name eyes --stdout-format json | jq .ok    # confirm via JSON
- clor messenger slack reaction add --workspace T0123ABC --channel C0123ABC --ts 1700000000.000100 --name white_check_mark    # react with a named emoji
</examples-good>

<examples-bad>
- clor messenger slack reaction add --workspace T0123ABC --channel C0123ABC    # missing required --ts and --name
- clor messenger slack reaction add --workspace T0123ABC --channel C0123ABC --ts 1700000000.000100 --name :tada:    # emoji name has no colons
</examples-bad>
</help>


<help command="clor messenger slack reaction remove">
<summary>Remove an emoji reaction from a message</summary>
<usage>clor messenger slack reaction remove [flags]</usage>

<flags>
- --channel string: channel id or name the message is in (required)
- --name string: emoji name without colons, e.g. thumbsup (required)
- --ts string: message id to react to (required)
- --workspace string: slack team id of the workspace (required)
</flags>

<output>json outputs the whole envelope {ok}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "ok": true
}
</output-example>

<examples-good>
- clor messenger slack reaction remove --workspace T0123ABC --channel C0123ABC --ts 1700000000.000100 --name thumbsup    # remove a reaction
- clor messenger slack reaction remove --workspace T0123ABC --channel "#general" --ts 1700000000.000100 --name eyes --stdout-format json | jq .ok    # confirm via JSON
- clor messenger slack reaction remove --workspace T0123ABC --channel C0123ABC --ts 1700000000.000100 --name white_check_mark    # react with a named emoji
</examples-good>

<examples-bad>
- clor messenger slack reaction remove --workspace T0123ABC --channel C0123ABC    # missing required --ts and --name
- clor messenger slack reaction remove --workspace T0123ABC --channel C0123ABC --ts 1700000000.000100 --name :tada:    # emoji name has no colons
</examples-bad>
</help>


<help command="clor messenger slack read">
<summary>Read the stored Slack event stream from a cursor, oldest first</summary>
<description>Read the workspace event stream, oldest first, limited to the conversations
you belong to plus workspace-wide events. One monotonic cursor covers messages
plus joins and leaves, reactions, pins, channel and user events, so a bot can
follow everything from a single resumable position. Each read returns
next_cursor; pass it back with --since to read only what arrived after, so you
never miss or repeat an event. Narrow to event types with --type (repeatable),
or with --channel, --dm, --thread, or --mentions, and cap the page with --limit.</description>
<usage>clor messenger slack read [flags]</usage>

<flags>
- --channel string: restrict to a single channel id or name (excludes workspace-wide events)
- --dm bool: restrict to direct and group direct messages
- --limit int: maximum events to return (1-500)
- --mentions bool: restrict to messages that mention the bot
- --since string: cursor from a prior read; empty reads from the beginning
- --thread string: restrict to replies under this thread_ts
- --type stringArray: restrict to these event types (repeatable), e.g. message, member_joined_channel, reaction_added (default "[]")
- --workspace string: slack team id of the workspace to read from (required)
</flags>

<output>json outputs the whole envelope {count, events[], next_cursor}. jsonl outputs each record from events on its own line; text is the logfmt of the same keys, an event=read header line then one line per event keyed by its Slack event type.</output>

<output-example format="json">
{
  "count": 2,
  "events": [
    {
      "channel": "C0123ABC",
      "channel_type": "channel",
      "sender": "U07ALICE",
      "sequence": 512,
      "text": "deploy finished, build is green",
      "ts": "1716394800.001700",
      "type": "message"
    },
    {
      "actor": "U07BOBBY",
      "channel": "C0123ABC",
      "channel_type": "channel",
      "item_channel": "C0123ABC",
      "item_ts": "1716394800.001700",
      "sequence": 513,
      "type": "reaction_added"
    }
  ],
  "next_cursor": "eyJzZXF1ZW5jZSI6NTEzfQ"
}
</output-example>

<examples-good>
- clor messenger slack read --workspace T0123ABC    # read the whole event stream from the beginning in logfmt
- clor messenger slack read --workspace T0123ABC --type reaction_added --type pin_added --stdout-format json | jq '.events[].type'    # only reactions and pins, as JSON
- clor messenger slack read --workspace T0123ABC --channel C0123ABC --limit 20 | grep '^event=message '    # last 20 in one channel, message lines only
</examples-good>

<examples-bad>
- clor messenger slack read    # missing required --workspace
- clor messenger slack read --workspace T0123ABC --type messages    # unknown event type, use message (singular)
</examples-bad>
</help>


<help command="clor messenger slack search">
<summary>Search messages you can see</summary>
<description>Search the workspace's messages, scoped by Slack to exactly what your connected
account can see, since the search runs as you. Reach for search to find
messages across many conversations at once, and for read to follow one channel
or thread in order. Slack query operators such as in:#channel, from:@user, and
before:2026-01-01 work in QUERY. Cap results with --count.</description>
<usage>clor messenger slack search <QUERY> [flags]</usage>

<flags>
- --count int: maximum matches to return (1-100)
- --workspace string: slack team id of the workspace (required)
</flags>

<output>json outputs the whole envelope {matches[], total}. jsonl outputs each record from matches on its own line; text is the logfmt of the same keys, an event=search header line then one event=match line per record.</output>

<output-example format="json">
{
  "matches": [
    {
      "channel": "C0123ABC",
      "permalink": "https://example.slack.com/archives/C0123ABC/p1716394800001700",
      "sender": "U07ALICE",
      "text": "the deploy failed on the database migration step",
      "ts": "1716394800.001700"
    },
    {
      "channel": "C0456DEF",
      "permalink": "https://example.slack.com/archives/C0456DEF/p1716221700000800",
      "sender": "U07BOBBY",
      "text": "deploy failed again, reverting",
      "ts": "1716221700.000800"
    }
  ],
  "total": 2
}
</output-example>

<examples-good>
- clor messenger slack search "deploy failed" --workspace T0123ABC    # search for a phrase
- clor messenger slack search "from:@alice in:#general" --workspace T0123ABC --count 50 --stdout-format json | jq '.matches[].permalink'    # Slack search operators, permalinks as JSON
- clor messenger slack search "incident" --workspace T0123ABC | grep '^event=match '    # match lines only
</examples-good>

<examples-bad>
- clor messenger slack search --workspace T0123ABC    # missing required <QUERY>
- clor messenger slack search "hi"    # missing required --workspace
</examples-bad>
</help>


<help command="clor messenger slack send">
<summary>Send a Slack message to a channel or thread</summary>
<description>Post a message to a channel or direct message by id or name. You can only post
where your account is a member, so you reply in an existing direct message by
its id (D...) but cannot open a direct message with someone you have not
messaged; posting elsewhere returns 403. Provide the text as the second
argument or pipe it on stdin. Reply within a thread with --thread, attach Block
Kit blocks with --blocks, and post as yourself instead of as the bot with
--as-user. Bot posts include a Sent by line naming you so the channel knows who
triggered the message; pass --attribution=false to suppress it.</description>
<usage>clor messenger slack send <CHANNEL> [TEXT] [flags]</usage>

<flags>
- --as-user bool: post as the connected user instead of the workspace bot
- --attribution bool: append a small Sent by sender line to bot posts (ignored with --as-user) (default "true")
- --blocks string: block kit blocks as a JSON array
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --thread string: thread_ts of a parent message to reply within
- --workspace string: slack team id of the workspace to send into (required)
</flags>

<output>json outputs the whole envelope {channel, ts}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "channel": "C0123ABC",
  "ts": "1716394800.001700"
}
</output-example>

<examples-good>
- clor messenger slack send C0123ABC "deploy finished" --workspace T0123ABC    # post text to a channel by id
- echo "build is green" | clor messenger slack send "#general" --workspace T0123ABC    # pipe the text on stdin
- clor messenger slack send C0123ABC "see thread" --thread 1700000000.000100 --workspace T0123ABC --stdout-format json | jq .ts    # reply in a thread and read back the message id
- clor messenger slack send D0123ABC "on it" --workspace T0123ABC    # reply in a direct message by its id
- clor messenger slack send C0123ABC "deploy finished" --workspace T0123ABC --attribution=false    # post without the sender line
</examples-good>

<examples-bad>
- clor messenger slack send C0123ABC "hi"    # missing required --workspace
- clor messenger slack send "hi" --workspace T0123ABC    # first argument is the channel, not the text
</examples-bad>
</help>


<help command="clor messenger slack thread">
<summary>Read a thread's replies</summary>
<usage>clor messenger slack thread</usage>

<subcommands>
- read: Read the replies under a thread
</subcommands>
</help>


<help command="clor messenger slack thread read">
<summary>Read the replies under a thread</summary>
<description>Read every reply under a thread, newest fetched from Slack and returned in
order. --thread is the thread_ts of the parent message, and --channel is the
channel it lives in. You must be a member of that channel, or the read returns
403.</description>
<usage>clor messenger slack thread read [flags]</usage>

<flags>
- --channel string: channel id or name the thread lives in (required)
- --thread string: thread_ts of the parent message (required)
- --workspace string: slack team id of the workspace (required)
</flags>

<output>json outputs the whole envelope {count, events[], next_cursor}. jsonl outputs each record from events on its own line; text is the logfmt of the same keys, an event=read header line then one line per reply keyed by its Slack event type.</output>

<output-example format="json">
{
  "count": 2,
  "events": [
    {
      "channel": "C0123ABC",
      "channel_type": "channel",
      "sender": "U07ALICE",
      "sequence": 640,
      "text": "looking into it now",
      "thread": "1716394800.001700",
      "ts": "1716394812.001900",
      "type": "message"
    },
    {
      "channel": "C0123ABC",
      "channel_type": "channel",
      "sender": "U07BOBBY",
      "sequence": 641,
      "text": "thanks, rolling back the release",
      "thread": "1716394800.001700",
      "ts": "1716394890.002100",
      "type": "message"
    }
  ],
  "next_cursor": "eyJzZXF1ZW5jZSI6NjQxfQ"
}
</output-example>

<examples-good>
- clor messenger slack thread read --workspace T0123ABC --channel C0123ABC --thread 1700000000.000100    # read a thread's replies
- clor messenger slack thread read --workspace T0123ABC --channel "#general" --thread 1700000000.000100 --stdout-format json | jq '.events[].text'    # thread text as JSON
- clor messenger slack thread read --workspace T0123ABC --channel C0123ABC --thread 1700000000.000100 | grep '^event=message '    # reply lines only
</examples-good>

<examples-bad>
- clor messenger slack thread read --workspace T0123ABC    # missing required --channel and --thread
- clor messenger slack thread    # thread is a group, call its read subcommand
</examples-bad>
</help>


<help command="clor messenger slack wait">
<summary>Block until new Slack events arrive or a timeout elapses</summary>
<description>Block for new events after a cursor, returning as soon as any match the
filters or --timeout elapses, whichever comes first. The same filters as read
narrow what counts, including --type to wait on specific event types like
reaction_added or member_joined_channel. On timeout it returns an empty result
with an advanced cursor, so loop by passing the returned next_cursor to --since
on the next call. Like read, it only ever returns conversations you belong to
plus workspace-wide events.</description>
<usage>clor messenger slack wait [flags]</usage>

<flags>
- --channel string: restrict to a single channel id or name (excludes workspace-wide events)
- --dm bool: restrict to direct and group direct messages
- --limit int: maximum events to return (1-500)
- --mentions bool: restrict to messages that mention the bot
- --since string: cursor from a prior read; empty reads from the beginning
- --thread string: restrict to replies under this thread_ts
- --timeout duration: how long to block waiting for new events (e.g. 30s, 2m) (default "30s")
- --type stringArray: restrict to these event types (repeatable), e.g. message, member_joined_channel, reaction_added (default "[]")
- --workspace string: slack team id of the workspace to read from (required)
</flags>

<output>json outputs the whole envelope {count, events[], next_cursor}. jsonl outputs each record from events on its own line; text is the logfmt of the same keys, an event=read header line then one line per event keyed by its Slack event type.</output>

<output-example format="json">
{
  "count": 1,
  "events": [
    {
      "actor": "U07ALICE",
      "channel": "C0123ABC",
      "channel_type": "channel",
      "item_channel": "C0123ABC",
      "item_ts": "1716394812.001900",
      "sequence": 481,
      "type": "reaction_added"
    }
  ],
  "next_cursor": "eyJzZXF1ZW5jZSI6NDgxfQ"
}
</output-example>

<examples-good>
- clor messenger slack wait --workspace T0123ABC --timeout 30s    # wait up to 30s for any new event
- clor messenger slack wait --workspace T0123ABC --type reaction_added --timeout 2m --stdout-format json | jq '.events[].item_ts'    # block for a new reaction, return as JSON
- clor messenger slack wait --workspace T0123ABC --channel C0123ABC --since "$CURSOR" | grep '^event=message '    # resume from a cursor and wait for the next message in a channel
</examples-good>

<examples-bad>
- clor messenger slack wait    # missing required --workspace
- clor messenger slack wait --workspace T0123ABC --timeout 999    # timeout needs a unit, e.g. 30s or 2m
</examples-bad>
</help>


<help command="clor messenger slack workspace">
<summary>List the workspaces you have connected</summary>
<usage>clor messenger slack workspace</usage>

<subcommands>
- list: List connected Slack workspaces and their ids
</subcommands>
</help>


<help command="clor messenger slack workspace list">
<summary>List connected Slack workspaces and their ids</summary>
<description>List the Slack workspaces connected to your account. Each entry includes the
team id to pass as --workspace to every other command, so this is the place to
start. When nothing is connected yet, it prints a connect link to share with
the user so they can connect Slack.</description>
<usage>clor messenger slack workspace list</usage>

<output>json outputs the whole envelope {workspaces[]}. jsonl outputs each record from workspaces on its own line; text is the logfmt of the same keys, an event=workspaces header line then one event=workspace line per record.</output>

<output-example format="json">
{
  "workspaces": [
    {
      "name": "Acme Engineering",
      "slack_user_id": "U07ALICE",
      "team": "T0123ABC"
    }
  ]
}
</output-example>

<examples-good>
- clor messenger slack workspace list    # list connected workspaces in logfmt
- clor messenger slack workspace list --stdout-format json | jq '.workspaces[].team'    # team ids as JSON, to pass to --workspace
- clor messenger slack workspace list | grep '^event=workspace '    # workspace lines only
</examples-good>

<examples-bad>
- clor messenger slack workspace    # workspace is a group, call its list subcommand
- clor messenger slack workspace list T0123ABC    # list takes no positional arguments
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

