---
name: email
description: Email and inbox management across Gmail, Outlook, Fastmail, iCloud, and IMAP providers. Use when the user wants to read, search, send, reply with attachments, triage, label, move, flag, or delete email, or manage mailboxes and Gmail threads.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Email reference

<help command="clor email">
<summary>Read, search, send, and triage email over IMAP and SMTP</summary>
<description>Speaks IMAP4rev1 and SMTP submission with SASL PLAIN over TLS, so it
works against Gmail/Workspace, Outlook/Microsoft 365, Fastmail, iCloud,
Dovecot, and similar. Trash/Sent/Drafts/Junk folders are discovered via
SPECIAL-USE, never hardcoded per provider. Refer to them by role name in
--folder and --to (Drafts, Sent, Trash, Junk, Archive, All) and they
resolve to the provider's real mailbox.</description>
<usage>clor email [flags]</usage>

<uses>
- the user wants to read, search, or triage their inbox
- the user wants to send a new message or reply to one, with optional HTML, attachments, and reply-all
- the user wants to stage a message as a draft to review and send later from their mail client
- the user wants to mark messages read or flagged, move them, or delete them
- the user wants to create or delete a mailbox, or add and remove Gmail labels on messages
- the user wants to fetch a Gmail conversation thread
</uses>

<subcommands>
- account: Manage saved email-account credentials (address, hosts, password) used by every email subcommand
- delete: Move messages to Trash (recoverable) or expunge them permanently with --permanent
- draft: Compose a message and save it to the Drafts mailbox without sending
- folder: List, create, rename, and delete IMAP mailboxes and Gmail labels
- label: Tag and untag Gmail messages with labels without moving them out of the inbox
- list: List the most recent messages in an IMAP mailbox or Gmail label
- mark: Set or clear the read and flagged ("starred") flags on one or more messages
- move: Move one or more messages from a source mailbox into a destination mailbox or label
- read: Show full headers and body for one message by UID
- reply: Reply to a message, auto-deriving Subject, recipients, and threading headers
- search: Search messages by sender, recipient, subject, body, freshness, flags, or attachments
- send: Compose and send a new email message with optional HTML body and file attachments
- thread: Fetch every message in the same Gmail conversation as a given UID (Gmail-only)
</subcommands>

<flags>
- --help bool: help for email
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

