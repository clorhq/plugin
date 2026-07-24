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


<help command="clor email account">
<summary>Manage saved email-account credentials (address, hosts, password) used by every email subcommand</summary>
<description>Credentials are stored as a typed secret (address, IMAP/SMTP host/port,
auth). Once saved, every email subcommand picks them up automatically
(or via --account when more than one is configured).

Gmail/Workspace, Outlook/365, and iCloud all reject regular account
passwords over IMAP/SMTP. Generate a provider-specific app password
(Google: https://myaccount.google.com/apppasswords; Outlook:
https://account.microsoft.com/security; iCloud:
https://appleid.apple.com) and pass it via --stdin-format text.</description>
<usage>clor email account</usage>

<uses>
- the user wants to register a new email account for the CLI to use
- the user wants to see which email accounts are saved
- the user wants to inspect or rotate stored credentials
- the user wants to remove an email account
</uses>

<subcommands>
- add: Save or update an email account (address, IMAP/SMTP hosts, password) for use by other email subcommands
- delete: Permanently remove a saved email account by name
- get: Read a saved email account's credentials; pass --stdout-format json for the raw JSON including password
- list: List saved email accounts with id and name
- update: Update fields on a saved email account (e.g. display name) without re-supplying unchanged values
</subcommands>
</help>


<help command="clor email account add">
<summary>Save or update an email account (address, IMAP/SMTP hosts, password) for use by other email subcommands</summary>
<description>IMAP/SMTP hosts auto-detect for known providers (gmail.com,
outlook.com, icloud.com, fastmail.com); pass --imap-host/--smtp-host
explicitly otherwise. [NAME] defaults to the address itself;
re-running with the same name updates in place.

Gmail, Google Workspace, iCloud, and Yahoo do not accept the regular
account password for IMAP/SMTP. They require a provider-issued
app-specific password instead:

  - Gmail / Workspace: https://myaccount.google.com/apppasswords
    (requires 2-Step Verification turned on). Generate a 16-character
    password and pass it as --password. The spaces shown in Google's UI
    can be kept or stripped; both work.
  - iCloud: https://account.apple.com -> Sign-In and Security ->
    App-Specific Passwords.
  - Yahoo: account security settings -> Generate app password.

If a user gives you their real account password and the provider needs
an app password, point them at the URL above and ask them to paste the
generated one back. Pass it on --password directly. Stdin
(--stdin-format text) is still supported when you need to avoid the
shell history.</description>
<usage>clor email account add [NAME] [flags]</usage>

<flags>
- --address string: email address (required)
- --auth-method string: authentication method (only password is supported today) (default "password")
- --display-name string: display name used on the From header (e.g. "Leo")
- --imap-host string: IMAP host (auto-detected for known providers like gmail.com)
- --imap-port int: IMAP port (auto-detected; 993 for implicit TLS)
- --password string: IMAP/SMTP password. For Gmail/Workspace, iCloud, and Yahoo, this must be a provider-issued app-specific password (see Long help for the per-provider URL), not the user's regular account password
- --smtp-host string: SMTP host (auto-detected for known providers like gmail.com)
- --smtp-port int: SMTP port (auto-detected; 465 for implicit TLS)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the secret metadata object {id, name, type, created, updated, accessed}; the password stays encrypted server-side and is never returned. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "created": "2026-04-02T18:05:11Z",
  "id": "0192f3a4-5b6c-7d8e-9f01-23456789abcd",
  "name": "default",
  "revision": 0,
  "type": "email-account",
  "updated": "2026-04-02T18:05:11Z"
}
</output-example>

<examples-good>
- clor email account add --address you@gmail.com --password "xxxx xxxx xxxx xxxx"    # Gmail: ask the user to generate an app password at https://myaccount.google.com/apppasswords and paste it here; hosts auto-detect
- clor email account add --address leo@example.com --password "..." --display-name "Leo"    # outbound From becomes "Leo <leo@example.com>" instead of the bare address
- clor email account add --address you@icloud.com --password "xxxx-xxxx-xxxx-xxxx"    # iCloud: app-specific password from https://account.apple.com -> Sign-In and Security -> App-Specific Passwords
- clor email account add work --address you@example.com --password "..." --imap-host imap.example.com --smtp-host smtp.example.com    # non-auto-detected provider: explicit hosts, short alias name
- clor email account add --address you@gmail.com --password "..." --stdout-format json | jq .id    # extract the new secret id
- printf '%s' "xxxx xxxx xxxx xxxx" | clor email account add --address you@gmail.com --stdin-format text    # stdin path, only when avoiding shell history matters
</examples-good>

<examples-bad>
- clor email account add --password "..."    # --address is required
- clor email account add --address not-an-email --password "..."    # address must be a valid RFC 5322 email
- clor email account add --address you@gmail.com --password "my-regular-google-password"    # Gmail rejects regular account passwords; use an app password from https://myaccount.google.com/apppasswords
- clor email account add --address you@gmail.com --password x --stdin-format text    # --password and --stdin-format are mutually exclusive
</examples-bad>
</help>


<help command="clor email account delete">
<summary>Permanently remove a saved email account by name</summary>
<description>After deletion the other email subcommands can no longer use the
account unless re-added or supplied via --credentials-file or
--stdin-format json.</description>
<usage>clor email account delete <NAME></usage>

<output>json outputs the whole object {deleted, name}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "deleted": true,
  "name": "default"
}
</output-example>

<examples-good>
- clor email account delete default    # delete an email account
- clor email account delete shared    # delete by name
- clor email account delete default --stdout-format json | jq .deleted    # scriptable confirmation
</examples-good>

<examples-bad>
- clor email account delete    # name argument is required
- clor email account delete default extra    # delete takes exactly one name
</examples-bad>
</help>


<help command="clor email account get">
<summary>Read a saved email account's credentials; pass --stdout-format json for the raw JSON including password</summary>
<description>Default logfmt drops the password; `--stdout-format json` returns
the raw email-account JSON suitable for piping into
`clor email <SUBCOMMAND> --stdin-format json`.</description>
<usage>clor email account get <NAME></usage>

<examples-good>
- clor email account get default    # logfmt without the password
- clor email account get default --stdout-format json    # raw email-account JSON including the password
- clor email account get default --stdout-format json | clor email send --stdin-format json --to a@b.com --subject hi --body x    # pipe credentials into another command
</examples-good>

<examples-bad>
- clor email account get    # name argument is required
- clor email account get default extra    # get takes exactly one name
</examples-bad>
</help>


<help command="clor email account list">
<summary>List saved email accounts with id and name</summary>
<description>Metadata only (id, name, last access); passwords stay encrypted
server-side. Use `account get` to retrieve the full JSON.</description>
<usage>clor email account list</usage>

<output>json outputs the whole envelope {secrets[]}. jsonl outputs each record from secrets on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "secrets": [
    {
      "accessed": "2026-06-17T09:14:05Z",
      "created": "2026-04-02T18:05:11Z",
      "id": "0192f3a4-5b6c-7d8e-9f01-23456789abcd",
      "name": "default",
      "revision": 0,
      "type": "email-account",
      "updated": "2026-04-02T18:05:11Z"
    }
  ]
}
</output-example>

<examples-good>
- clor email account list    # every saved email account, logfmt
- clor email account list --stdout-format jsonl    # one account per line
- clor email account list --stdout-format json | jq '.secrets[].name'    # names of every saved email account
</examples-good>

<examples-bad>
- clor email account list default    # list takes no arguments; use `clor email account get <NAME>`
- clor email account list --stdout-format yaml    # format must be text, jsonl, or json
</examples-bad>
</help>


<help command="clor email account update">
<summary>Update fields on a saved email account (e.g. display name) without re-supplying unchanged values</summary>
<description>Loads the stored account, overwrites only the fields whose flags
were explicitly passed, and writes the result back. Pass
`--display-name ""` to wipe an existing display name.</description>
<usage>clor email account update <NAME> [flags]</usage>

<flags>
- --address string: email address
- --auth-method string: authentication method (only password is supported today) (default "password")
- --display-name string: display name used on the From header (pass "" to wipe)
- --imap-host string: IMAP host
- --imap-port int: IMAP port
- --password string: IMAP/SMTP password (provider-issued app-specific password for Gmail/Workspace, iCloud, Yahoo)
- --smtp-host string: SMTP host
- --smtp-port int: SMTP port
</flags>

<output>json outputs the secret metadata object {id, name, type, created, updated, accessed}; the password stays encrypted server-side and is never returned. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "accessed": "2026-06-17T11:42:00Z",
  "created": "2026-04-02T18:05:11Z",
  "id": "0192f3a4-5b6c-7d8e-9f01-23456789abcd",
  "name": "default",
  "revision": 0,
  "type": "email-account",
  "updated": "2026-06-17T11:42:00Z"
}
</output-example>

<examples-good>
- clor email account update default --display-name "Leo"    # outbound From becomes "Leo <leo@example.com>" without re-supplying the password
- clor email account update default --display-name ""    # wipe the stored display name; subsequent sends use the bare address
- clor email account update work --imap-host imap.example.com --smtp-host smtp.example.com --stdout-format json | jq .name    # rotate hosts on a self-hosted account and print the secret name
</examples-good>

<examples-bad>
- clor email account update default    # no flags changed; nothing to update
- clor email account update    # name argument is required
</examples-bad>
</help>

<help command="clor email delete">
<summary>Move messages to Trash (recoverable) or expunge them permanently with --permanent</summary>
<description>Default moves messages to Trash (resolved via SPECIAL-USE, so
recoverable from the user's mail client). --permanent flags
\Deleted and expunges immediately, no recovery path.</description>
<usage>clor email delete <UID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --folder string: source mailbox; role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider (default "INBOX")
- --permanent bool: expunge instead of moving to Trash
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole object {folder, uids, count, permanent}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "count": 2,
  "folder": "INBOX",
  "permanent": false,
  "uids": [
    "48213",
    "48217"
  ]
}
</output-example>

<examples-good>
- clor email delete 12345    # move to Trash (auto-detected per provider)
- clor email delete 12345 12346    # delete several messages
- clor email delete 12345 --permanent    # expunge immediately, no recovery
</examples-good>

<examples-bad>
- clor email delete    # at least one UID is required
</examples-bad>
</help>

<help command="clor email draft">
<summary>Compose a message and save it to the Drafts mailbox without sending</summary>
<description>Builds the same RFC 822 message as `email send` but never hands
it to SMTP. Instead it IMAP APPENDs to the Drafts mailbox (resolved via
SPECIAL-USE, never hardcoded) with the \Draft flag, so the message shows
up in the user's normal mail client ready to review, edit, and send.

--to is optional: a draft can be staged before its recipients are known,
and a subject-only draft is valid. Same body/attachment flags as
`email send`.

Subject: keep it short and specific so it sits cleanly in an inbox
list and is easy to search for later. Lead with the concrete thing
("HN digest 2026-05-28", "Site down: example.com", "Stripe receipt
$129.40"), not the framing ("Daily report", "Update", "FYI"). Avoid
junk-flavored words ("urgent", "important"), all caps, and emoji at
the start. Aim for under ~60 characters.</description>
<usage>clor email draft [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --attach stringSlice: attachment file path (repeatable) (default "[]")
- --bcc stringSlice: Bcc recipient (repeatable) (default "[]")
- --body string: plain-text body (mutually exclusive with --body-file)
- --body-file string: read plain-text body from a file (- for stdin)
- --cc stringSlice: Cc recipient (repeatable) (default "[]")
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --from-name string: display name on the From header for this send only (e.g. "HN Digest Bot"); overrides the saved account's display name without changing it
- --html-file string: read HTML body from a file (added as multipart alternative)
- --in-reply-to string: In-Reply-To header (Message-ID of the parent)
- --references stringSlice: References header (repeatable; chain of parent Message-IDs) (default "[]")
- --reply-to string: Reply-To header
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --subject string: Subject header
- --to stringSlice: recipient address (repeatable; required for send) (default "[]")
</flags>

<output>json outputs the whole object {saved, message_id, to, subject, draft_folder}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "draft_folder": "Drafts",
  "message_id": "\u003ca1b2c3d4-e5f6-4789-90ab-cdef01234567@example.com\u003e",
  "saved": true,
  "subject": "Re: Invoice 2026-0427",
  "to": [
    "leo@example.com"
  ]
}
</output-example>

<examples-good>
- clor email draft --to me@example.com --subject "draft test" --body "hi"    # stage a reply to review and send later from the mail client
- clor email draft --subject "no recipient yet"    # subject-only draft, recipients filled in later
- clor email draft --to a@b.com --cc c@d.com --subject report --html-file ./report.html --attach ./report.pdf    # rich draft with HTML body and attachment
- clor email draft --to a@b.com --subject x --body y --stdout-format json | jq .draft_folder    # print the resolved Drafts mailbox
</examples-good>

<examples-bad>
- clor email draft --to a@b.com --subject hi --body x --body-file ./b.txt    # --body and --body-file are mutually exclusive
- clor email draft --subject "spaces in subject"    # quote any value that contains spaces
</examples-bad>
</help>

<help command="clor email folder">
<summary>List, create, rename, and delete IMAP mailboxes and Gmail labels</summary>
<description>Manage the mailboxes on an account. On Gmail these mailboxes are the
account's labels, so creating a folder creates a label and deleting one
removes it.

Use when:
  - the user wants to see the mailboxes/labels on an account before reading or moving messages
  - the user wants to create, rename, or delete a mailbox or a Gmail label

Subcommands:
  list    List every mailbox and Gmail label with message and unseen counts
  create  Create a mailbox, or a label on Gmail
  rename  Rename a mailbox, or a label on Gmail
  delete  Delete a mailbox, or remove a label on Gmail

Output: every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</description>
<usage>clor email folder</usage>

<uses>
- the user wants to see the available mailboxes/labels on an account before reading or moving messages
- the user wants to create, rename, or delete a mailbox or a Gmail label
</uses>

<subcommands>
- create: Create an IMAP mailbox, which is a new label on Gmail accounts
- delete: Delete an IMAP mailbox, removing a label on Gmail while its messages stay in All Mail
- list: List every mailbox and Gmail label with message and unseen counts
- rename: Rename an IMAP mailbox, which renames a label on Gmail accounts
</subcommands>
</help>


<help command="clor email folder create">
<summary>Create an IMAP mailbox, which is a new label on Gmail accounts</summary>
<usage>clor email folder create <NAME> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole object {name}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "name": "Receipts"
}
</output-example>

<examples-good>
- clor email folder create Receipts    # create a mailbox, or a label on Gmail
- clor email folder create "Clients/Acme"    # nested mailbox or hierarchical Gmail label
- clor email folder create Receipts --stdout-format json | jq .name    # scriptable confirmation
</examples-good>

<examples-bad>
- clor email folder create    # the mailbox name is required
- clor email folder create A B    # exactly one name; quote names that contain spaces
</examples-bad>
</help>


<help command="clor email folder delete">
<summary>Delete an IMAP mailbox, removing a label on Gmail while its messages stay in All Mail</summary>
<description>On standard IMAP this discards the messages the mailbox contains. On
Gmail it only detaches the label; the messages remain in All Mail.</description>
<usage>clor email folder delete <NAME> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole object {name}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "name": "Receipts"
}
</output-example>

<examples-good>
- clor email folder delete Receipts    # delete a mailbox, or remove a label on Gmail
- clor email folder delete "Clients/Acme"    # quote names that contain spaces or slashes
- clor email folder delete Receipts --stdout-format json | jq .name    # scriptable confirmation
</examples-good>

<examples-bad>
- clor email folder delete    # the mailbox name is required
- clor email folder delete INBOX    # INBOX cannot be deleted; servers reject this
</examples-bad>
</help>


<help command="clor email folder list">
<summary>List every mailbox and Gmail label with message and unseen counts</summary>
<description>Names returned are the exact strings `email move` and
`email list --folder` expect.</description>
<usage>clor email folder list [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {folders[]}. jsonl outputs each record from folders on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "folders": [
    {
      "name": "INBOX",
      "messages": 2841,
      "unseen": 12
    },
    {
      "name": "[Gmail]/All Mail",
      "messages": 31064,
      "unseen": 0
    }
  ]
}
</output-example>

<examples-good>
- clor email folder list    # logfmt list of every mailbox visible on this account
- clor email folder list --stdout-format json | jq '.folders[].name'    # extract just the folder names
- clor email folder list --account work    # use the credentials saved as `work`
</examples-good>

<examples-bad>
- clor email folder list --stdout-format yaml    # only text, jsonl, or json supported
</examples-bad>
</help>


<help command="clor email folder rename">
<summary>Rename an IMAP mailbox, which renames a label on Gmail accounts</summary>
<usage>clor email folder rename <OLD> <NEW> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole object {old, new}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "new": "Invoices",
  "old": "Receipts"
}
</output-example>

<examples-good>
- clor email folder rename Receipts Invoices    # rename a mailbox, or a label on Gmail
- clor email folder rename "Old Name" "New Name"    # quote names that contain spaces
- clor email folder rename Receipts Invoices --stdout-format json | jq .new    # scriptable confirmation
</examples-good>

<examples-bad>
- clor email folder rename Receipts    # both the old and new names are required
- clor email folder rename    # both the old and new names are required
</examples-bad>
</help>

<help command="clor email label">
<summary>Tag and untag Gmail messages with labels without moving them out of the inbox</summary>
<description>Gmail lets a single message carry many labels at once. These
subcommands add and remove a label on specific messages while leaving
them where they are, which plain mailbox moves cannot do. They target
Gmail accounts; other providers should use `clor email move` instead.

Create the label itself with `clor email folder create` first.

Use when:
  - the user wants to label or unlabel Gmail messages while keeping them in the inbox
  - the user is organizing a Gmail inbox with multiple overlapping labels

Subcommands:
  add     Apply a Gmail label to one or more messages, leaving them in place
  remove  Remove a Gmail label from one or more messages, keeping them in All Mail

Output: every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</description>
<usage>clor email label</usage>

<uses>
- the user wants to apply or remove a Gmail label on specific messages without moving them
</uses>

<subcommands>
- add: Apply a Gmail label to one or more messages, leaving them in place
- remove: Remove a Gmail label from one or more messages, keeping them in All Mail
</subcommands>
</help>


<help command="clor email label add">
<summary>Apply a Gmail label to one or more messages, leaving them in place</summary>
<description>Adds the label to messages identified by their UIDs in --folder
(default INBOX) without moving them. Create the label first with
`clor email folder create`. Gmail-only; other providers should use
`clor email move` instead.</description>
<usage>clor email label add --label <NAME> <UID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --folder string: source mailbox the UIDs belong to; role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider (default "INBOX")
- --label string: label to apply (required)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole object {label, folder, uids, count}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "count": 2,
  "folder": "INBOX",
  "label": "Receipts",
  "uids": [
    "48213",
    "48217"
  ]
}
</output-example>

<examples-good>
- clor email label add --label Receipts 12345    # tag an inbox message with the Receipts label
- clor email label add --label Receipts --folder "[Gmail]/All Mail" 12345 12346    # tag messages found in another mailbox
- clor email label add --label Receipts 12345 --stdout-format json | jq .count    # scriptable confirmation
</examples-good>

<examples-bad>
- clor email label add 12345    # --label is required
- clor email label add --label Receipts    # at least one UID is required
</examples-bad>
</help>


<help command="clor email label remove">
<summary>Remove a Gmail label from one or more messages, keeping them in All Mail</summary>
<description>The UIDs are scoped to the label's own mailbox, since Gmail assigns
each mailbox its own UIDs. Get them with `clor email list --folder <NAME>`.
Removing a label never deletes the message; it stays in All Mail.
Gmail-only.</description>
<usage>clor email label remove --label <NAME> <UID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --label string: label to remove (required)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole object {label, uids, count}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "count": 2,
  "label": "Receipts",
  "uids": [
    "71204",
    "71208"
  ]
}
</output-example>

<examples-good>
- clor email label remove --label Receipts 12345    # untag a message found via `list --folder Receipts`
- clor email label remove --label Receipts 12345 12346    # untag several messages at once
- clor email label remove --label Receipts 12345 --stdout-format json | jq .count    # scriptable confirmation
</examples-good>

<examples-bad>
- clor email label remove 12345    # --label is required
- clor email label remove --label Receipts    # at least one UID is required
</examples-bad>
</help>

<help command="clor email list">
<summary>List the most recent messages in an IMAP mailbox or Gmail label</summary>
<description>Sorted newest first, with UID, sender, subject, date, read/flagged,
size. --since accepts durations (7d, 24h), RFC3339, or Unix seconds.
Use the UIDs with `email read`, `mark`, `move`, or `delete`.</description>
<usage>clor email list [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --folder string: mailbox to list; role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider (default "INBOX")
- --limit int: max messages to return (1-1000) (default "25")
- --since string: only messages received after this point: duration (e.g. 30s, 90m, 24h, 7d, 2w, 1w3d), RFC3339 (2026-05-04T00:00:00Z), or Unix seconds (1746460800)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --unread-only bool: only return messages without \Seen
</flags>

<output>json outputs the whole envelope {folder, messages[]}. jsonl outputs each record from messages on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "folder": "INBOX",
  "messages": [
    {
      "uid": 48213,
      "date": "2026-06-17T09:14:02Z",
      "received": "2026-06-17T09:14:05Z",
      "from": [
        "Stripe \u003creceipts@stripe.com\u003e"
      ],
      "to": [
        "leo@example.com"
      ],
      "subject": "Your receipt from Acme Inc.",
      "unread": true,
      "flagged": false,
      "size_bytes": 18432
    }
  ]
}
</output-example>

<examples-good>
- clor email list    # 25 most recent INBOX messages, logfmt
- clor email list --unread-only --limit 5    # 5 most recent unread messages
- clor email list --since 7d --stdout-format json | jq '.messages[].subject'    # subjects in the last 7 days
- clor email list --since 2026-04-01T00:00:00Z    # absolute RFC3339 lower bound
- clor email list --folder "[Gmail]/All Mail" --limit 100    # search across All Mail (Gmail label syntax)
- clor email list --folder Drafts    # role name resolves to the provider's Drafts mailbox ([Gmail]/Drafts on Gmail)
</examples-good>

<examples-bad>
- clor email list --limit 5000    # max --limit is 1000
- clor email list --since yesterday    # use 24h, 7d, 2w, RFC3339, or unix seconds
- clor email list --since 7    # duration needs a unit (use 7d)
</examples-bad>
</help>

<help command="clor email mark">
<summary>Set or clear the read and flagged ("starred") flags on one or more messages</summary>
<description>Pass exactly one of --read/--unread and/or one of --flagged/--unflagged.
Both pairs can be supplied in the same call.</description>
<usage>clor email mark <UID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --flagged bool: add the \Flagged flag
- --folder string: mailbox the UIDs belong to; role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider (default "INBOX")
- --read bool: add the \Seen flag
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --unflagged bool: remove the \Flagged flag
- --unread bool: remove the \Seen flag
</flags>

<output>json outputs the whole object {folder, uids, read, unread, flagged, unflagged}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "flagged": false,
  "folder": "INBOX",
  "read": true,
  "uids": [
    "48213"
  ],
  "unflagged": false,
  "unread": false
}
</output-example>

<examples-good>
- clor email mark 12345 --read    # mark a single message as read
- clor email mark 12345 12346 12347 --read    # mark several messages as read
- clor email mark 12345 --flagged    # star a message
- clor email mark 12345 --unread --unflagged    # unmark read and starred at once
</examples-good>

<examples-bad>
- clor email mark 12345    # must supply at least one of --read/--unread/--flagged/--unflagged
- clor email mark 12345 --read --unread    # mutually exclusive
</examples-bad>
</help>

<help command="clor email move">
<summary>Move one or more messages from a source mailbox into a destination mailbox or label</summary>
<description>Role names (Drafts, Sent, Trash, Junk, Archive, All) resolve to the
provider's real mailbox; exact names from `email folder list` work too
(Gmail labels look like `[Gmail]/All Mail`). Atomic server-side: a
failed move never leaves messages in both mailboxes.</description>
<usage>clor email move <UID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --folder string: source mailbox; role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider (default "INBOX")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --to string: destination mailbox (required); role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider
</flags>

<output>json outputs the whole object {from, to, uids, count}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "count": 2,
  "from": "INBOX",
  "to": "[Gmail]/All Mail",
  "uids": [
    "48213",
    "48217"
  ]
}
</output-example>

<examples-good>
- clor email move 12345 --to "[Gmail]/All Mail"    # archive a Gmail message
- clor email move 12345 12346 --to Receipts    # move several messages to a label/folder
- clor email move 12345 --to Spam --stdout-format json | jq .count    # scriptable confirmation
- clor email move 12345 --to Trash    # role name resolves to the provider's Trash mailbox ([Gmail]/Trash on Gmail)
</examples-good>

<examples-bad>
- clor email move 12345    # --to is required
- clor email move    # at least one UID is required
</examples-bad>
</help>

<help command="clor email read">
<summary>Show full headers and body for one message by UID</summary>
<description>Returns headers, flags, plain-text body, and optionally the HTML
alternative. Body output capped at 32 KB by default to bound agent
context; raise with --max-bytes (0=unlimited), or use --headers-only
(no body fetch over the wire) or --raw (full RFC 822, may include
base64 attachments).</description>
<usage>clor email read <UID> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --folder string: mailbox the UID belongs to; role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider (default "INBOX")
- --headers-only bool: skip body fetch entirely; return metadata only
- --include-html bool: include the HTML alternative in addition to text/plain
- --max-bytes int: cap each body part at N bytes (0 for unlimited); truncates at a UTF-8 rune boundary (default "32000")
- --raw bool: write the raw RFC 822 bytes to stdout (overrides --stdout-format; output may include base64-encoded attachments and run to many MB, check size_bytes from list/search first)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole message object {uid, folder, headers, body_text, ...}. jsonl outputs the same object on one line; text is the logfmt of the same keys followed by the body.</output>

<output-example format="json">
{
  "uid": 48213,
  "folder": "INBOX",
  "date": "2026-06-17T09:14:02Z",
  "from": [
    "Stripe \u003creceipts@stripe.com\u003e"
  ],
  "to": [
    "leo@example.com"
  ],
  "subject": "Your receipt from Acme Inc.",
  "message_id": "\u003cCA+receipt-9f3c1a@mail.stripe.com\u003e",
  "unread": true,
  "flagged": false,
  "size_bytes": 18432,
  "body_text": "Thanks for your payment of $129.40. This receipt confirms your subscription renewed through July 2026."
}
</output-example>

<examples-good>
- clor email read 12345    # headers + first 32 KB of text body
- clor email read 12345 --headers-only    # metadata only; cheapest read, no body fetch over the wire
- clor email read 12345 --max-bytes 200000 --stdout-format json | jq .body_text    # larger body cap, extract plain-text body as JSON
- clor email read 12345 --include-html --max-bytes 0 --stdout-format json | jq .body_html    # full HTML body with no truncation
- clor email read 12345 --raw > message.eml    # save the raw RFC 822 message
- clor email read 12345 --folder Drafts    # read a UID from the provider's Drafts mailbox by role name
</examples-good>

<examples-bad>
- clor email read    # UID argument is required
- clor email read 0    # UID 0 is invalid
- clor email read 12345 --raw    # dumps full RFC 822 incl. base64 attachments; check size_bytes first or omit --raw for just the text body
- clor email read 12345 --headers-only --include-html    # --headers-only suppresses the body; --include-html has nothing to add
</examples-bad>
</help>

<help command="clor email reply">
<summary>Reply to a message, auto-deriving Subject, recipients, and threading headers</summary>
<description>Subject defaults to "Re: ...", recipients default to the parent's
From (or Reply-To), and In-Reply-To/References headers are populated
from the parent. --to-all Ccs every other recipient ("reply all").
Same body/attachment flags as `email send`.</description>
<usage>clor email reply <UID> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --attach stringSlice: attachment file path (repeatable) (default "[]")
- --bcc stringSlice: Bcc recipient (repeatable) (default "[]")
- --body string: plain-text body (mutually exclusive with --body-file)
- --body-file string: read plain-text body from a file (- for stdin)
- --cc stringSlice: Cc recipient (repeatable) (default "[]")
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --folder string: mailbox the parent UID belongs to; role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider (default "INBOX")
- --from-name string: display name on the From header for this send only (e.g. "HN Digest Bot"); overrides the saved account's display name without changing it
- --html-file string: read HTML body from a file (added as multipart alternative)
- --in-reply-to string: In-Reply-To header (Message-ID of the parent)
- --no-save-sent bool: skip the IMAP APPEND to the Sent mailbox after delivery (Gmail saves automatically and is always skipped)
- --references stringSlice: References header (repeatable; chain of parent Message-IDs) (default "[]")
- --reply-to string: Reply-To header
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --subject string: Subject header
- --to stringSlice: recipient address (repeatable; required for send) (default "[]")
- --to-all bool: Cc every other recipient on the parent message ("reply all")
</flags>

<output>json outputs the whole object {sent, message_id, to, subject, sent_folder?}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "message_id": "\u003c98fe76dc-ba54-4321-8765-0fedcba98765@example.com\u003e",
  "sent": true,
  "sent_folder": "Sent",
  "subject": "Re: Invoice 2026-0427 is ready",
  "to": [
    "invoices@acme.com"
  ]
}
</output-example>

<examples-good>
- clor email reply 12345 --body "thanks!"    # send a quick reply preserving Subject and threading
- clor email reply 12345 --to-all --body "for everyone"    # reply-all: Cc every other recipient
- clor email reply 12345 --html-file ./reply.html --attach ./diff.patch    # rich reply with attachment
</examples-good>

<examples-bad>
- clor email reply    # UID argument is required
- clor email reply 12345    # supply --body, --body-file, or --html-file
</examples-bad>
</help>

<help command="clor email search">
<summary>Search messages by sender, recipient, subject, body, freshness, flags, or attachments</summary>
<description>Substring match on headers/body via --from/--to/--subject/--body.
Freshness window via --since/--until (durations, RFC3339, or Unix
seconds). Returns the same UID-keyed summary as `email list`.</description>
<usage>clor email search [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --body string: filter by message body (substring match)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --folder string: mailbox to search in; role names (Drafts, Sent, Trash, Junk, Archive, All) resolve per provider (default "INBOX")
- --from string: filter by From header (substring match)
- --has-attachment bool: only messages with attachments (multipart/mixed)
- --limit int: max messages to return (1-1000) (default "50")
- --since string: only messages received after this point: duration (e.g. 30s, 90m, 24h, 7d, 2w, 1w3d), RFC3339 (2026-05-04T00:00:00Z), or Unix seconds (1746460800)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --subject string: filter by Subject header (substring match)
- --to string: filter by To header (substring match)
- --unread bool: only unread messages
- --until string: only messages received before this point (same formats as --since)
</flags>

<output>json outputs the whole envelope {folder, messages[]}. jsonl outputs each record from messages on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "folder": "INBOX",
  "messages": [
    {
      "uid": 50917,
      "date": "2026-05-28T14:32:10Z",
      "received": "2026-05-28T14:32:12Z",
      "from": [
        "Acme Billing \u003cinvoices@acme.com\u003e"
      ],
      "to": [
        "leo@example.com"
      ],
      "subject": "Invoice 2026-0427 is ready",
      "unread": false,
      "flagged": true,
      "size_bytes": 24576
    }
  ]
}
</output-example>

<examples-good>
- clor email search --from someone@example.com    # messages from this sender
- clor email search --subject invoice --since 30d    # subject contains "invoice" in last 30 days
- clor email search --since 1w --until 2d    # received between 1 week and 2 days ago
- clor email search --since 2026-04-01T00:00:00Z --until 2026-05-01T00:00:00Z    # absolute RFC3339 window
- clor email search --unread --has-attachment --limit 10    # unread messages with attachments
- clor email search --from boss@acme.com --stdout-format json | jq '.messages[].uid'    # extract UIDs for further commands
</examples-good>

<examples-bad>
- clor email search --since not-a-date    # use 7d / 2w / RFC3339 / unix seconds
- clor email search --since 7    # duration needs a unit (use 7d)
- clor email search --limit 5000    # max --limit is 1000
</examples-bad>
</help>

<help command="clor email send">
<summary>Compose and send a new email message with optional HTML body and file attachments</summary>
<description>Body source: --body, --body-file (- for stdin), or --html-file
(combine an html-file with a text body for a multipart alternative).
On success the message is appended to the Sent folder unless the
provider auto-saves (Gmail) or --no-save-sent is passed.

Subject: keep it short and specific so it sits cleanly in an inbox
list and is easy to search for later. Lead with the concrete thing
("HN digest 2026-05-28", "Site down: example.com", "Stripe receipt
$129.40"), not the framing ("Daily report", "Update", "FYI"). Avoid
junk-flavored words ("urgent", "important"), all caps, and emoji at
the start. Aim for under ~60 characters.

From header: --from-name overrides the saved account's display name
for this send only (the stored account is untouched). Use it to make
the source obvious in the recipient's inbox when sending automated
reports or notifications, so the From column reads "Personalized Tech Report
<leo@example.com>" instead of a bare address. Prefer this over
stuffing the source into --subject; the subject stays free to
describe the actual content.</description>
<usage>clor email send [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --attach stringSlice: attachment file path (repeatable) (default "[]")
- --bcc stringSlice: Bcc recipient (repeatable) (default "[]")
- --body string: plain-text body (mutually exclusive with --body-file)
- --body-file string: read plain-text body from a file (- for stdin)
- --cc stringSlice: Cc recipient (repeatable) (default "[]")
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --from-name string: display name on the From header for this send only (e.g. "HN Digest Bot"); overrides the saved account's display name without changing it
- --html-file string: read HTML body from a file (added as multipart alternative)
- --in-reply-to string: In-Reply-To header (Message-ID of the parent)
- --no-save-sent bool: skip the IMAP APPEND to the Sent mailbox after delivery (Gmail saves automatically and is always skipped)
- --references stringSlice: References header (repeatable; chain of parent Message-IDs) (default "[]")
- --reply-to string: Reply-To header
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --subject string: Subject header
- --to stringSlice: recipient address (repeatable; required for send) (default "[]")
</flags>

<output>json outputs the whole object {sent, message_id, to, subject, sent_folder?}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "message_id": "\u003ca1b2c3d4-e5f6-4789-90ab-cdef01234567@example.com\u003e",
  "sent": true,
  "sent_folder": "Sent",
  "subject": "HN digest 2026-05-28",
  "to": [
    "leo@example.com"
  ]
}
</output-example>

<examples-good>
- clor email send --to me@example.com --subject hi --body "hello there"    # minimal text-only message
- clor email send --to a@b.com --to c@d.com --cc e@f.com --subject standup --body-file ./notes.md    # multi-recipient with body from a file
- clor email send --to me@example.com --subject report --html-file ./report.html --attach ./report.pdf    # HTML body with PDF attachment
- clor email send --from-name "Personalized Tech Report" --to me@example.com --subject "OpenAI ships GPT-6, Anthropic raises $40B, NVDA hits $5T" --body-file ./report.md    # per-send From override so the recipient sees "Personalized Tech Report <leo@example.com>"; clearer than putting "[Personalized Tech Report]" in the subject
- clor email send --to me@example.com --subject test --body x --stdout-format json | jq .message_id    # extract the sent Message-ID
</examples-good>

<examples-bad>
- clor email send --subject hi --body x    # --to is required
- clor email send --to a@b.com --subject hi --body x --body-file ./b.txt    # --body and --body-file are mutually exclusive
</examples-bad>
</help>

<help command="clor email thread">
<summary>Fetch every message in the same Gmail conversation as a given UID (Gmail-only)</summary>
<description>Uses Gmail's X-GM-THRID IMAP extension. Non-Gmail accounts return
an error pointing at `clor email search --subject` as a fallback.</description>
<usage>clor email thread <UID> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read email-account JSON from this path instead of secrets (- for stdin)
- --folder string: mailbox to search across (defaults to Gmail's All Mail label) (default "[Gmail]/All Mail")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<examples-good>
- clor email thread 12345    # fetch every message in the same Gmail conversation
</examples-good>

<examples-bad>
- clor email thread 12345  # against Fastmail    # non-Gmail provider; use search --subject instead
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

