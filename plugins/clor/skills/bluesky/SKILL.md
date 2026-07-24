---
name: bluesky
description: Bluesky feeds, posts, social graph, notifications, and direct messages. Use when the user wants to read or search Bluesky, publish or engage with posts, attach media, follow, block, or mute accounts, or use Bluesky notifications and direct messages.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Sharing a link as a card

To post a URL as a tappable link card (thumbnail, title, domain chip, and
description), pass `--link-card <URL>` to `clor bluesky post`. The title,
description, and thumbnail are fetched automatically, and each `--link-card-*`
flag overrides one field. Preview what the card will contain first with
`clor bluesky card extract <URL>`; when its `image` is empty the URL has no
thumbnail, so generate one and pass it with `--link-card-thumbnail`.

Sharing a Hacker News story is two commands, no coupling between them. Read the
story to get its title and URL, then post with a card:

    clor social hn item 12345 --stdout-format json    # read {title, url}
    clor bluesky post "Great read https://example.com/story" \
      --link-card https://example.com/story \
      --link-card-title "The story headline"

Pass `--link-card-title` from the story's own title so the card is correct even
when the origin site has thin metadata.

## Changing to a custom-domain handle

`clor bluesky profile update --handle <HANDLE>` changes the account handle,
including to a custom domain you own. Bluesky proves control of a custom
domain before the change, so point the domain at the account first by adding
a TXT record at `_atproto.<HANDLE>` with value `did=<your-did>`, or by serving
your DID at `https://<HANDLE>/.well-known/atproto-did`. The command verifies
this itself and fails with the exact record to add when it is missing. Pass
`--force` to skip the check when you know the setup is correct.

## Bluesky reference

<help command="clor bluesky">
<summary>Post to Bluesky and read it: timeline, feeds, threads, search, follow, like, notifications, direct messages</summary>
<description>Speaks the AT Protocol directly to a Bluesky server, authenticated with
a handle and an app password stored as a typed secret. Covers reading
(timeline, custom and author feeds, threads, search, profiles), posting with
rich-text links, hashtags, mentions, replies, quotes, images, and video, the
social graph (follow, block, mute), engagement (like, repost),
notifications, and direct messages.

Use when:
  - the user wants to read their Bluesky timeline, a profile, a thread, or search posts
  - the user wants to post, reply, quote, like, repost, or delete
  - the user wants to follow, unfollow, block, or mute accounts
  - the user wants to read notifications or send and read direct messages

Subcommands:
  account       Manage saved Bluesky credentials
  timeline      Read the home timeline
  feed          List, read, and browse feeds
  thread        Read a post and its replies
  post          Create a post, reply, or quote
  pin           Pin one of your posts to the top of your profile
  unpin         Remove the pinned post from your profile
  card          Preview a URL's link-card metadata before posting
  video         Upload a video and track its transcode job
  delete        Delete one of your posts
  search        Search public posts
  profile       Show, search, or update profiles
  follow        Follow an account
  unfollow      Stop following an account
  follower      List who follows an account
  following     List who an account follows
  block         Block, unblock, and list blocked accounts
  mute          Mute, unmute, and list muted accounts
  like          Like a post
  unlike        Remove your like
  repost        Repost a post
  unrepost      Remove your repost
  notification  Read notifications and mark them seen
  chat          Read and send direct messages

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky [flags]</usage>

<uses>
- the user wants to read their Bluesky timeline, an account's posts, a thread, or search public posts
- the user wants to post, reply, quote, like, repost, or delete a post
- the user wants to follow, unfollow, block, or mute accounts, or list their followers and follows
- the user wants to read notifications, or send and read direct messages
</uses>

<subcommands>
- account: Manage saved Bluesky credentials (handle, app password) used by every Bluesky subcommand
- block: Block and unblock accounts, and list the accounts you block
- card: Preview a URL's link-card metadata before posting: title, description, thumbnail
- chat: Read and send direct messages: list conversations, read one, send a message
- delete: Delete one of your own posts by its at:// URI
- feed: List saved feeds, read a custom or pinned feed, and read an account's posts
- follow: Follow one or more accounts by handle or DID in a single session
- follower: List the accounts that follow an account
- following: List the accounts an account follows
- like: Like one or more posts by their at:// URIs in a single session
- mute: Mute and unmute accounts, and list the accounts you mute
- notification: Read notifications (likes, reposts, follows, replies, mentions) and mark them seen
- pin: Pin one of your posts to the top of your profile by its at:// URI
- post: Create a post, optionally as a reply or quote, with images, a video, or a link card
- profile: Read and update Bluesky profiles: show one account, or update your own
- repost: Repost one or more posts by their at:// URIs in a single session
- search: Search public posts by keyword, newest or top first
- thread: Read a post and its reply tree, flattened depth-first with a depth attribute
- timeline: Read the home timeline of posts from accounts you follow, newest first
- unfollow: Stop following one or more accounts by handle or DID in a single session
- unlike: Remove your like from one or more posts by their at:// URIs in a single session
- unpin: Remove the pinned post from your profile
- unrepost: Remove your repost of one or more posts by their at:// URIs in a single session
- video: Upload a video, track its transcode job, then embed it in a post
</subcommands>

<flags>
- --help bool: help for bluesky
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


<help command="clor bluesky account">
<summary>Manage saved Bluesky credentials (handle, app password) used by every Bluesky subcommand</summary>
<description>Credentials are stored as a typed secret (handle, app password,
optional service host). Once saved, every Bluesky subcommand picks them
up automatically (or via --account when more than one is configured).

App passwords are generated in the Bluesky app under Settings, Privacy
and Security, App Passwords. They bypass two-factor prompts, so no
email-code step is needed. Never store the real account password here.

Use when:
  - the user wants to register a Bluesky account for the CLI to use
  - the user wants to see which Bluesky accounts are saved
  - the user wants to inspect or rotate stored credentials
  - the user wants to remove a Bluesky account

Subcommands:
  add     Save or update a Bluesky account by handle and app password
  list    List saved Bluesky accounts visible to the caller
  get     Read one saved Bluesky account, with the raw JSON in json mode
  delete  Permanently remove a saved Bluesky account by name

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky account</usage>

<uses>
- the user wants to register a new Bluesky account for the CLI to use
- the user wants to see which Bluesky accounts are saved
- the user wants to inspect or rotate stored credentials
- the user wants to remove a Bluesky account
</uses>

<subcommands>
- add: Save or update a Bluesky account by handle and app password for use by other Bluesky subcommands
- delete: Permanently remove a saved Bluesky account by name
- get: Read a saved Bluesky account; pass --stdout-format json for the raw JSON including the app password
- list: List saved Bluesky accounts with id and name
</subcommands>
</help>


<help command="clor bluesky account add">
<summary>Save or update a Bluesky account by handle and app password for use by other Bluesky subcommands</summary>
<description>[NAME] defaults to the handle itself; re-running with the same name
updates in place.

The app password is generated in the Bluesky app under Settings,
Privacy and Security, App Passwords. It looks like xxxx-xxxx-xxxx-xxxx,
applies only to API access, can be revoked independently, and bypasses
two-factor prompts. Pass it on --app-password directly, or pipe it via
--stdin-format text to keep it out of shell history.

--service only needs setting for self-hosted servers; the default
entryway routes to whichever server actually holds the repository.</description>
<usage>clor bluesky account add [NAME] [flags]</usage>

<flags>
- --app-password string: app password from the Bluesky app (Settings, Privacy and Security, App Passwords), not the account password
- --handle string: Bluesky handle, e.g. you.bsky.social (required)
- --service string: AT Protocol service host (default https://bsky.social; set only for self-hosted servers)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the saved account's metadata object {id, name, type, created, updated, accessed}; the app password is never returned. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "accessed": "2026-06-18T14:30:00Z",
  "created": "2026-05-02T09:15:00Z",
  "id": "01931f7e-4c2a-7e10-9a3b-5d8c2f1e4b7a",
  "name": "main",
  "revision": 0,
  "type": "bluesky-account",
  "updated": "2026-06-18T14:30:00Z"
}
</output-example>

<examples-good>
- clor bluesky account add --handle you.bsky.social --app-password xxxx-xxxx-xxxx-xxxx    # save under the handle; ask the user to generate the app password in Settings, Privacy and Security, App Passwords
- clor bluesky account add main --handle you.bsky.social --app-password xxxx-xxxx-xxxx-xxxx    # save under a short alias instead of the handle
- clor bluesky account add --handle you.example.com --app-password xxxx-xxxx-xxxx-xxxx --service https://pds.example.com    # self-hosted server: explicit service host
- clor bluesky account add --handle you.bsky.social --app-password xxxx-xxxx-xxxx-xxxx --stdout-format json | jq .id    # extract the new secret id
- printf '%s' xxxx-xxxx-xxxx-xxxx | clor bluesky account add --handle you.bsky.social --stdin-format text    # stdin path, keeps the app password out of shell history
</examples-good>

<examples-bad>
- clor bluesky account add --app-password xxxx-xxxx-xxxx-xxxx    # --handle is required
- clor bluesky account add --handle you.bsky.social --app-password my-login-password    # use an app password from the Bluesky app, not the account login password
- clor bluesky account add --handle you.bsky.social --app-password x --stdin-format text    # --app-password and --stdin-format are mutually exclusive
</examples-bad>
</help>


<help command="clor bluesky account delete">
<summary>Permanently remove a saved Bluesky account by name</summary>
<description>After deletion the other Bluesky subcommands can no longer use the
account unless re-added or supplied via --credentials-file or
--stdin-format json.</description>
<usage>clor bluesky account delete <NAME></usage>

<output>json outputs the whole envelope {deleted, name}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "deleted": true,
  "name": "main"
}
</output-example>

<examples-good>
- clor bluesky account delete main    # delete a Bluesky account
- clor bluesky account delete shared    # delete by name
- clor bluesky account delete main --stdout-format json | jq .deleted    # scriptable confirmation
</examples-good>

<examples-bad>
- clor bluesky account delete    # name argument is required
- clor bluesky account delete main extra    # delete takes exactly one name
</examples-bad>
</help>


<help command="clor bluesky account get">
<summary>Read a saved Bluesky account; pass --stdout-format json for the raw JSON including the app password</summary>
<description>Default logfmt drops the app password; `--stdout-format json` returns
the raw bluesky-account JSON suitable for piping into
`clor bluesky <SUBCOMMAND> --stdin-format json`.</description>
<usage>clor bluesky account get <NAME></usage>

<examples-good>
- clor bluesky account get main    # logfmt without the app password
- clor bluesky account get main --stdout-format json    # raw bluesky-account JSON including the app password
- clor bluesky account get main --stdout-format json | clor bluesky timeline --stdin-format json --limit 5    # pipe credentials into another command
</examples-good>

<examples-bad>
- clor bluesky account get    # name argument is required
- clor bluesky account get main extra    # get takes exactly one name
</examples-bad>
</help>


<help command="clor bluesky account list">
<summary>List saved Bluesky accounts with id and name</summary>
<description>Metadata only (id, name, last access); app passwords stay encrypted
server-side. Use `account get` to retrieve the full JSON.</description>
<usage>clor bluesky account list</usage>

<output>json outputs the whole envelope {secrets[]} of account metadata; app passwords stay encrypted server-side. jsonl outputs each record from secrets on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "secrets": [
    {
      "accessed": "2026-06-18T14:30:00Z",
      "created": "2026-05-02T09:15:00Z",
      "id": "01931f7e-4c2a-7e10-9a3b-5d8c2f1e4b7a",
      "name": "main",
      "revision": 0,
      "type": "bluesky-account",
      "updated": "2026-06-18T14:30:00Z"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky account list    # every saved Bluesky account, logfmt
- clor bluesky account list --stdout-format jsonl    # one account per line
- clor bluesky account list --stdout-format json | jq '.secrets[].name'    # names of every saved Bluesky account
</examples-good>

<examples-bad>
- clor bluesky account list main    # list takes no arguments; use `clor bluesky account get <NAME>`
- clor bluesky account list --stdout-format yaml    # format must be text, jsonl, or json
</examples-bad>
</help>

<help command="clor bluesky block">
<summary>Block and unblock accounts, and list the accounts you block</summary>
<description>Blocking hides both directions: the account cannot see or interact
with your posts, and theirs disappear from your views.

Use when:
  - the user wants to block or unblock an account
  - the user wants to see who they have blocked

Subcommands:
  add     Block an account by handle or DID
  remove  Unblock an account by handle or DID
  list    List the accounts you block

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky block</usage>

<subcommands>
- add: Block one or more accounts by handle or DID in a single session
- list: List the accounts you block
- remove: Unblock one or more accounts by handle or DID in a single session
</subcommands>
</help>


<help command="clor bluesky block add">
<summary>Block one or more accounts by handle or DID in a single session</summary>
<usage>clor bluesky block add <HANDLE>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=block header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "alice.bsky.social",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.graph.block/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky block add spammer.bsky.social    # block a single account
- clor bluesky block add spammer.bsky.social did:plc:abc123    # block several accounts in one session
- clor bluesky block add spammer.bsky.social --stdout-format json | jq '.results[].uri'    # capture the block record URIs
</examples-good>

<examples-bad>
- clor bluesky block add    # at least one handle or DID is required
- clor bluesky block spammer.bsky.social    # use the add subcommand: block add <HANDLE>
</examples-bad>
</help>


<help command="clor bluesky block list">
<summary>List the accounts you block</summary>
<usage>clor bluesky block list [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum accounts to return (1-100 per call, paginated above 100) (default "50")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {blocks, cursor}. jsonl outputs each record from blocks on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "blocks": [
    {
      "description": "building on the open social web, posts about distributed systems",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "displayName": "Alice Rivera",
      "handle": "alice.bsky.social",
      "indexedAt": "2026-05-02T09:15:00Z"
    }
  ],
  "cursor": "3kbcd1234ab::1717320900"
}
</output-example>

<examples-good>
- clor bluesky block list    # accounts you block, logfmt
- clor bluesky block list --limit 10    # the 10 most recently blocked accounts
- clor bluesky block list --stdout-format json | jq '.blocks[].handle'    # handles of accounts you block
</examples-good>

<examples-bad>
- clor bluesky block list spammer.bsky.social    # list takes no positional arguments; use block add to block
- clor bluesky block list --limit 0    # --limit must be at least 1
</examples-bad>
</help>


<help command="clor bluesky block remove">
<summary>Unblock one or more accounts by handle or DID in a single session</summary>
<usage>clor bluesky block remove <HANDLE>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=unblock header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "alice.bsky.social",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.graph.block/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky block remove spammer.bsky.social    # unblock a single account
- clor bluesky block remove spammer.bsky.social did:plc:abc123    # unblock several accounts in one session
- clor bluesky block remove spammer.bsky.social --stdout-format json | jq '.results[].uri'    # the deleted block record URIs
</examples-good>

<examples-bad>
- clor bluesky block remove    # at least one handle or DID is required
- clor bluesky block remove someone-you-dont-block.bsky.social    # reports not-blocking for that target and continues
</examples-bad>
</help>

<help command="clor bluesky card">
<summary>Preview a URL's link-card metadata before posting: title, description, thumbnail</summary>
<description>Preview the link card Bluesky would build for a URL, without posting. The
card service returns the title, description, and a resized thumbnail image
URL, so you can see what a post's card will look like and decide whether to
override a field or supply your own thumbnail.

Use when:
  - the user wants to see a URL's card title, description, and thumbnail before posting
  - the user wants to check whether a URL has a thumbnail so they can generate one when it does not
  - a workflow builds a post's link card in steps rather than in one shot

Subcommands:
  extract  Extract the title, description, and thumbnail for a URL

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky card</usage>

<uses>
- the user wants to preview a URL's card title, description, and thumbnail before posting
- the user wants to check whether a URL has a thumbnail so a missing one can be generated
- a workflow assembles a post's link card in steps
</uses>

<subcommands>
- extract: Extract the title, description, and thumbnail Bluesky would show for a URL
</subcommands>
</help>


<help command="clor bluesky card extract">
<summary>Extract the title, description, and thumbnail Bluesky would show for a URL</summary>
<description>Query the card service for the title, description, and thumbnail image URL
Bluesky would show for <URL>. When image is empty the URL has no thumbnail;
generate one and pass it to `clor bluesky post --link-card-thumbnail`.
likely_type and error report how the card service classified the URL.</description>
<usage>clor bluesky card extract <URL></usage>

<output>json outputs {url, title, description, image, likely_type, error}. jsonl outputs the same object on one line; text is one event=extract logfmt line with the fields that are present.</output>

<output-example format="json">
{
  "description": "The AT Protocol is a new federated social network",
  "error": "",
  "image": "https://cardyb.bsky.app/v1/image?url=https%3A%2F%2Fatproto.com%2Fdefault-social-card.png",
  "likely_type": "html",
  "title": "AT Protocol",
  "url": "https://atproto.com"
}
</output-example>

<examples-good>
- clor bluesky card extract https://atproto.com    # preview the title, description, and thumbnail as a logfmt line
- clor bluesky card extract https://atproto.com --stdout-format json | jq .image    # capture the thumbnail URL; empty means the URL has no thumbnail
- clor bluesky card extract https://example.com/report.pdf --stdout-format json | jq '{title, likely_type}'    # a PDF returns a title but no thumbnail, so generate one before posting
</examples-good>

<examples-bad>
- clor bluesky card extract    # the URL is required
- clor bluesky card extract atproto.com    # pass an absolute http(s) URL, not a bare host
</examples-bad>
</help>

<help command="clor bluesky chat">
<summary>Read and send direct messages: list conversations, read one, send a message</summary>
<description>Direct messages are served by your own data server, not the public
appview, so these subcommands proxy through it automatically.

Use when:
  - the user wants to see their direct-message conversations
  - the user wants to read the messages in a conversation
  - the user wants to send someone a direct message

Subcommands:
  list  List your direct-message conversations
  read  Read the messages in one conversation
  send  Send a direct message to an account

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky chat</usage>

<subcommands>
- list: List your direct-message conversations with their members and unread counts
- read: Read the messages in one conversation, oldest first
- send: Send a direct message to an account by handle or DID
</subcommands>
</help>


<help command="clor bluesky chat list">
<summary>List your direct-message conversations with their members and unread counts</summary>
<usage>clor bluesky chat list [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum conversations to return (1-100 per call, paginated above 100) (default "30")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {convos, cursor}. jsonl outputs each record from convos on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "convos": [
    {
      "id": "3kdmconvo7h6tvur2x4",
      "lastMessage": {
        "$type": "chat.bsky.convo.defs#messageView",
        "id": "3kdmmessage7h6tvur2x4",
        "rev": "3kdmrev7h6tvur2x4",
        "sender": {
          "did": "did:plc:z72i7hdynmk6r22z27h6tvur"
        },
        "sentAt": "2026-06-18T13:05:42Z",
        "text": "hey, are you free to chat about the new feature later today"
      },
      "members": [
        {
          "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
          "displayName": "Alice Rivera",
          "handle": "alice.bsky.social"
        }
      ],
      "muted": false,
      "rev": "3kdmrev7h6tvur2x4",
      "unreadCount": 2
    }
  ],
  "cursor": "3kdmconvo7h6tvur2x4::1718716142"
}
</output-example>

<examples-good>
- clor bluesky chat list    # your conversations with members and unread counts, logfmt
- clor bluesky chat list --limit 5 --stdout-format json | jq '.convos[].id'    # conversation ids to pass to chat read
- clor bluesky chat list --stdout-format text | grep '^event=result '    # one logfmt line per conversation
</examples-good>

<examples-bad>
- clor bluesky chat list --limit 0    # --limit must be at least 1
- clor bluesky chat list bsky.app    # list takes no arguments; use chat read <CONVERSATION> for one conversation
</examples-bad>
</help>


<help command="clor bluesky chat read">
<summary>Read the messages in one conversation, oldest first</summary>
<description><CONVERSATION> is a conversation id from `clor bluesky chat list`.
Messages are returned oldest first so a thread reads top to bottom.</description>
<usage>clor bluesky chat read <CONVERSATION> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --limit int: maximum messages to return (1-100) (default "50")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {messages, cursor}. jsonl outputs each record from messages on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "messages": [
    {
      "$type": "chat.bsky.convo.defs#messageView",
      "id": "3kdmmessage7h6tvur2x4",
      "rev": "3kdmrev7h6tvur2x4",
      "sender": {
        "did": "did:plc:z72i7hdynmk6r22z27h6tvur"
      },
      "sentAt": "2026-06-18T13:05:42Z",
      "text": "hey, are you free to chat about the new feature later today"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky chat read 3kabc123conversation    # the 50 most recent messages, oldest first, logfmt
- clor bluesky chat read 3kabc123conversation --limit 10 --stdout-format json | jq '.messages[].text'    # message text in a conversation
- clor bluesky chat list --stdout-format json | jq -r '.convos[0].id' | xargs clor bluesky chat read    # read the first conversation from the list
</examples-good>

<examples-bad>
- clor bluesky chat read    # a conversation id is required (from chat list)
- clor bluesky chat read 3kabc123conversation --limit 0    # --limit must be at least 1
</examples-bad>
</help>


<help command="clor bluesky chat send">
<summary>Send a direct message to an account by handle or DID</summary>
<description>Opens or reuses the one-to-one conversation with <HANDLE> and sends
<TEXT>. The recipient must allow direct messages from you.</description>
<usage>clor bluesky chat send <HANDLE> <TEXT> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {event, conversation, id, recipient}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "event": "sent",
  "conversation": "3kdmconvo7h6tvur2x4",
  "id": "3kdmmessage7h6tvur2x4",
  "recipient": "did:plc:z72i7hdynmk6r22z27h6tvur"
}
</output-example>

<examples-good>
- clor bluesky chat send friend.bsky.social "hey, are you free later?"    # send a direct message by handle
- clor bluesky chat send did:plc:abc123 "hello"    # send a direct message by DID
- clor bluesky chat send friend.bsky.social "hi" --stdout-format json | jq .id    # capture the sent message id
</examples-good>

<examples-bad>
- clor bluesky chat send friend.bsky.social    # both a recipient and message text are required
- clor bluesky chat send "hello there"    # the first argument is the recipient, the second is the text
</examples-bad>
</help>

<help command="clor bluesky delete">
<summary>Delete one of your own posts by its at:// URI</summary>
<description><URI> is an at:// post URI, e.g. the one printed by `clor bluesky post`.
Only records in your own repository can be deleted.</description>
<usage>clor bluesky delete <URI> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {event, uri}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "event": "deleted",
  "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.post/3kfoobar2x4"
}
</output-example>

<examples-good>
- clor bluesky delete at://did:plc:abc123/app.bsky.feed.post/3kfoobar    # delete your post by its at:// URI
- clor bluesky delete at://did:plc:abc123/app.bsky.feed.post/3kfoobar --stdout-format json | jq .uri    # scriptable confirmation
- clor bluesky post "oops" --stdout-format json | jq -r .uri | xargs clor bluesky delete    # post then immediately delete it
</examples-good>

<examples-bad>
- clor bluesky delete 3kfoobar    # pass the full at:// URI, not the bare record key
- clor bluesky delete    # the post URI is required
</examples-bad>
</help>

<help command="clor bluesky feed">
<summary>List saved feeds, read a custom or pinned feed, and read an account's posts</summary>
<description>Read the custom and pinned feeds you follow in the app, and the
author feed of any single account. A custom feed is an algorithmic
feed generator (the kind you pin in the Bluesky app); the author feed
is one account's own posts and reposts.

Use when:
  - the user wants to read one of their saved or pinned feeds by name
  - the user wants to read a feed generator by its at:// URI
  - the user wants to see which feeds an account has saved or pinned
  - the user wants one account's own posts and reposts

Subcommands:
  list    List your saved and pinned feeds
  read    Read the posts in a custom or pinned feed
  author  Read the posts authored by one account

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky feed</usage>

<subcommands>
- author: Read the posts authored by one account, newest first
- list: List your saved and pinned feeds
- read: Read the posts in a custom or pinned feed, newest first
</subcommands>
</help>


<help command="clor bluesky feed author">
<summary>Read the posts authored by one account, newest first</summary>
<description><HANDLE> is a handle (you.bsky.social) or a DID. Returns that
account's own posts and reposts, the same feed shown on their profile.</description>
<usage>clor bluesky feed author <HANDLE> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum posts to return (1-100 per call, paginated above 100) (default "30")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {feed, cursor}. jsonl outputs each record from feed on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "cursor": "3kfoobar2x4::1718721127",
  "feed": [
    {
      "post": {
        "$type": "app.bsky.feed.defs#postView",
        "author": {
          "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
          "displayName": "Alice Rivera",
          "handle": "alice.bsky.social"
        },
        "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz",
        "indexedAt": "2026-06-18T14:32:09Z",
        "likeCount": 128,
        "quoteCount": 3,
        "record": {
          "$type": "app.bsky.feed.post",
          "createdAt": "2026-06-18T14:32:07Z",
          "text": "shipping a new feature today, the open social web keeps getting better"
        },
        "replyCount": 12,
        "repostCount": 34,
        "uri": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4"
      }
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky feed author bsky.app    # 30 newest posts by @bsky.app, logfmt
- clor bluesky feed author bsky.app --limit 5 --stdout-format json | jq '.feed[].post.uri'    # URIs of the 5 newest posts
- clor bluesky feed author bsky.app --limit 100 --cursor "$SAVED_CURSOR" --stdout-format text | grep '^event=result '    # the next page of an author's posts after a saved cursor
</examples-good>

<examples-bad>
- clor bluesky feed author    # a handle or DID is required
- clor bluesky feed author bsky.app --limit 0    # --limit must be at least 1
</examples-bad>
</help>


<help command="clor bluesky feed list">
<summary>List your saved and pinned feeds</summary>
<description>Lists every feed saved to your account with a pinned= flag for the
ones you have pinned. Feed-generator display names are resolved, so the
name= attr matches what you see in the app. Pass a name or the uri= value
to feed read.</description>
<usage>clor bluesky feed list [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --pinned-only bool: list only the feeds you have pinned
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {feeds[]}. jsonl outputs each record from feeds on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "feeds": [
    {
      "name": "Discover",
      "uri": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/whats-hot",
      "type": "feed",
      "pinned": true
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky feed list    # every saved feed with pinned= and uri=, logfmt
- clor bluesky feed list --pinned-only --stdout-format json | jq '.feeds[].name'    # names of your pinned feeds
- clor bluesky feed list --stdout-format text | grep '^event=result '    # one line per saved feed
</examples-good>

<examples-bad>
- clor bluesky feed list Discover    # list takes no arguments; use feed read Discover to read a feed
- clor bluesky feed list --pinned    # the flag is --pinned-only
</examples-bad>
</help>


<help command="clor bluesky feed read">
<summary>Read the posts in a custom or pinned feed, newest first</summary>
<description><FEED> is an at:// feed-generator URI, or the display name of a feed
saved to your account (matched case-insensitively). Run feed list to see
your saved feeds and their at:// URIs.</description>
<usage>clor bluesky feed read <FEED> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum posts to return (1-100 per call, paginated above 100) (default "30")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {feed, cursor}. jsonl outputs each record from feed on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "cursor": "3kfoobar2x4::1718721127",
  "feed": [
    {
      "post": {
        "$type": "app.bsky.feed.defs#postView",
        "author": {
          "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
          "displayName": "Alice Rivera",
          "handle": "alice.bsky.social"
        },
        "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz",
        "indexedAt": "2026-06-18T14:32:09Z",
        "likeCount": 128,
        "quoteCount": 3,
        "record": {
          "$type": "app.bsky.feed.post",
          "createdAt": "2026-06-18T14:32:07Z",
          "text": "shipping a new feature today, the open social web keeps getting better"
        },
        "replyCount": 12,
        "repostCount": 34,
        "uri": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4"
      }
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky feed read Discover --limit 5    # 5 newest posts in your saved Discover feed
- clor bluesky feed read Discover --stdout-format json | jq '.feed[].post.uri'    # post URIs in the feed
- clor bluesky feed read at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/whats-hot --limit 100 --cursor "$SAVED_CURSOR" --stdout-format text | grep '^event=result '    # the next page of a feed read by at:// URI
</examples-good>

<examples-bad>
- clor bluesky feed read    # a feed name or at:// URI is required
- clor bluesky feed read no-such-feed    # no saved feed matches; run clor bluesky feed list to see your feeds
</examples-bad>
</help>

<help command="clor bluesky follow">
<summary>Follow one or more accounts by handle or DID in a single session</summary>
<description>Pass any number of handles or DIDs; they are all followed within one
session, so following back a whole list of accounts is one call rather
than one login per account. Passing DIDs skips handle resolution, so
piping DIDs from `follower list` is the fastest path. A target that
fails does not stop the rest.</description>
<usage>clor bluesky follow <HANDLE>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=follow header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "alice.bsky.social",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.graph.follow/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky follow bsky.app    # follow a single account by handle
- clor bluesky follow alice.bsky.social did:plc:abc123 bob.bsky.social    # follow several accounts in one session
- clor bluesky follow $(clor bluesky follower list --not-following --limit 100 --stdout-format json | jq -r '.followers[].did')    # follow back up to 100 followers you don't already follow, in one session
</examples-good>

<examples-bad>
- clor bluesky follow    # at least one handle or DID is required
- clor bluesky follow @    # pass a real handle or DID
</examples-bad>
</help>

<help command="clor bluesky follower">
<summary>List the accounts that follow an account</summary>
<description>Use when:
  - the user wants to see who follows them or another account

Subcommands:
  list  List the accounts that follow a handle (defaults to your own)

Output: the list subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky follower</usage>

<subcommands>
- list: List the accounts that follow an account, defaulting to your own
</subcommands>
</help>


<help command="clor bluesky follower list">
<summary>List the accounts that follow an account, defaulting to your own</summary>
<description>With --not-following, only followers you do not follow back are
returned, which is the candidate set for a follow-back: pipe their DIDs
into `clor bluesky follow` to follow them all in one session.</description>
<usage>clor bluesky follower list [HANDLE] [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum accounts to return (1-100 per call, paginated above 100) (default "50")
- --not-following bool: return only followers you do not follow back
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {followers, cursor, subject}. jsonl outputs each record from followers on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "cursor": "3kbcd1234ab::1717320900",
  "followers": [
    {
      "description": "building on the open social web, posts about distributed systems",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "displayName": "Alice Rivera",
      "handle": "alice.bsky.social",
      "indexedAt": "2026-05-02T09:15:00Z"
    }
  ],
  "subject": null
}
</output-example>

<examples-good>
- clor bluesky follower list    # your own followers, logfmt
- clor bluesky follower list bsky.app --limit 10    # 10 of @bsky.app's followers
- clor bluesky follower list --not-following --limit 100 --stdout-format json | jq -r '.followers[].did'    # DIDs of up to 100 followers you don't follow back, ready to pipe into follow
</examples-good>

<examples-bad>
- clor bluesky follower list a b    # list takes at most one handle
- clor bluesky follower list --limit 0    # --limit must be at least 1
</examples-bad>
</help>

<help command="clor bluesky following">
<summary>List the accounts an account follows</summary>
<description>Use when:
  - the user wants to see who they or another account follows

Subcommands:
  list  List the accounts a handle follows (defaults to your own)

Output: the list subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky following</usage>

<subcommands>
- list: List the accounts an account follows, defaulting to your own
</subcommands>
</help>


<help command="clor bluesky following list">
<summary>List the accounts an account follows, defaulting to your own</summary>
<usage>clor bluesky following list [HANDLE] [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum accounts to return (1-100 per call, paginated above 100) (default "50")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {follows, cursor, subject}. jsonl outputs each record from follows on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "cursor": "3kbcd1234ab::1717320900",
  "follows": [
    {
      "description": "building on the open social web, posts about distributed systems",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "displayName": "Alice Rivera",
      "handle": "alice.bsky.social",
      "indexedAt": "2026-05-02T09:15:00Z"
    }
  ],
  "subject": null
}
</output-example>

<examples-good>
- clor bluesky following list    # accounts you follow, logfmt
- clor bluesky following list bsky.app --limit 10    # 10 accounts @bsky.app follows
- clor bluesky following list --stdout-format json | jq '.follows[].handle'    # handles of accounts you follow
</examples-good>

<examples-bad>
- clor bluesky following list a b    # list takes at most one handle
- clor bluesky following list --limit 0    # --limit must be at least 1
</examples-bad>
</help>

<help command="clor bluesky like">
<summary>Like one or more posts by their at:// URIs in a single session</summary>
<description>Pass any number of at:// post URIs; they are all liked within one
session. A post that fails does not stop the rest.</description>
<usage>clor bluesky like <URI>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=like header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4",
      "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.like/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky like at://did:plc:abc123/app.bsky.feed.post/3kfoobar    # like a single post
- clor bluesky like $(clor bluesky search rainbows --limit 5 --stdout-format json | jq -r '.posts[].uri')    # like the top 5 search hits in one session
- clor bluesky like at://did:plc:abc/app.bsky.feed.post/3kfoo --stdout-format json | jq '.results[].uri'    # capture the like record URIs
</examples-good>

<examples-bad>
- clor bluesky like 3kfoobar    # pass the full at:// URI, not the bare record key
- clor bluesky like    # at least one post URI is required
</examples-bad>
</help>

<help command="clor bluesky mute">
<summary>Mute and unmute accounts, and list the accounts you mute</summary>
<description>Muting hides an account's posts from your views without telling them
or restricting them. It is private and one-directional.

Use when:
  - the user wants to mute or unmute an account
  - the user wants to see who they have muted

Subcommands:
  add     Mute an account by handle or DID
  remove  Unmute an account by handle or DID
  list    List the accounts you mute

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky mute</usage>

<subcommands>
- add: Mute one or more accounts by handle or DID in a single session
- list: List the accounts you mute
- remove: Unmute one or more accounts by handle or DID in a single session
</subcommands>
</help>


<help command="clor bluesky mute add">
<summary>Mute one or more accounts by handle or DID in a single session</summary>
<usage>clor bluesky mute add <HANDLE>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. Muting creates no record, so each result carries the resolved did rather than a uri. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=mute header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "alice.bsky.social",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky mute add noisy.bsky.social    # mute a single account
- clor bluesky mute add noisy.bsky.social did:plc:abc123    # mute several accounts in one session
- clor bluesky mute add noisy.bsky.social --stdout-format json | jq '.results[].did'    # the muted accounts' DIDs
</examples-good>

<examples-bad>
- clor bluesky mute add    # at least one handle or DID is required
- clor bluesky mute noisy.bsky.social    # use the add subcommand: mute add <HANDLE>
</examples-bad>
</help>


<help command="clor bluesky mute list">
<summary>List the accounts you mute</summary>
<usage>clor bluesky mute list [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum accounts to return (1-100 per call, paginated above 100) (default "50")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {mutes, cursor}. jsonl outputs each record from mutes on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "cursor": "3kbcd1234ab::1717320900",
  "mutes": [
    {
      "description": "building on the open social web, posts about distributed systems",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "displayName": "Alice Rivera",
      "handle": "alice.bsky.social",
      "indexedAt": "2026-05-02T09:15:00Z"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky mute list    # accounts you mute, logfmt
- clor bluesky mute list --limit 10    # 10 muted accounts
- clor bluesky mute list --stdout-format json | jq '.mutes[].handle'    # handles of accounts you mute
</examples-good>

<examples-bad>
- clor bluesky mute list noisy.bsky.social    # list takes no positional arguments; use mute add to mute
- clor bluesky mute list --limit 0    # --limit must be at least 1
</examples-bad>
</help>


<help command="clor bluesky mute remove">
<summary>Unmute one or more accounts by handle or DID in a single session</summary>
<usage>clor bluesky mute remove <HANDLE>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. Unmuting deletes no record, so each result carries the resolved did rather than a uri. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=unmute header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "alice.bsky.social",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky mute remove noisy.bsky.social    # unmute a single account
- clor bluesky mute remove noisy.bsky.social did:plc:abc123    # unmute several accounts in one session
- clor bluesky mute remove noisy.bsky.social --stdout-format json | jq '.results[].did'    # the unmuted accounts' DIDs
</examples-good>

<examples-bad>
- clor bluesky mute remove    # at least one handle or DID is required
- clor bluesky mute remove @    # pass a real handle or DID
</examples-bad>
</help>

<help command="clor bluesky notification">
<summary>Read notifications (likes, reposts, follows, replies, mentions) and mark them seen</summary>
<description>Use when:
  - the user wants to see who liked, reposted, followed, replied to, or
    mentioned them
  - the user wants to clear the unread notification badge

Subcommands:
  list  List recent notifications, optionally only unread ones
  seen  Mark all notifications as seen as of now

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky notification</usage>

<subcommands>
- list: List recent notifications, optionally only unread ones or only certain reasons
- seen: Mark all notifications as seen as of now
</subcommands>
</help>


<help command="clor bluesky notification list">
<summary>List recent notifications, optionally only unread ones or only certain reasons</summary>
<description>--reason filters to one or more notification reasons (like, repost,
follow, mention, reply, quote, starterpack-joined). A reply-bot, for
example, lists only mention and reply notifications to decide what to
answer.</description>
<usage>clor bluesky notification list [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum notifications to return (1-100 per call, paginated above 100) (default "30")
- --reason stringSlice: filter to these reasons (like|repost|follow|mention|reply|quote|starterpack-joined), repeatable or comma-separated (default "[]")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --unread-only bool: return only notifications you have not seen
</flags>

<output>json outputs the whole envelope {notifications, cursor, priority, seenAt}. jsonl outputs each record from notifications on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "cursor": "3kbcd1234ab::1718722882",
  "notifications": [
    {
      "author": {
        "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
        "displayName": "Alice Rivera",
        "handle": "alice.bsky.social"
      },
      "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz",
      "indexedAt": "2026-06-18T15:01:22Z",
      "isRead": false,
      "reason": "like",
      "reasonSubject": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.post/3kfoobar2x4",
      "record": null,
      "uri": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.like/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky notification list    # 30 most recent notifications, logfmt
- clor bluesky notification list --unread-only --reason mention,reply    # unseen mentions and replies, the reply-bot triage set
- clor bluesky notification list --reason mention --stdout-format json | jq -r '.notifications[].uri'    # URIs of posts that mentioned you, ready to reply to
</examples-good>

<examples-bad>
- clor bluesky notification list --limit 0    # --limit must be at least 1
- clor bluesky notification list --reason likes    # reason must be one of like, repost, follow, mention, reply, quote, starterpack-joined
</examples-bad>
</help>


<help command="clor bluesky notification seen">
<summary>Mark all notifications as seen as of now</summary>
<usage>clor bluesky notification seen [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {event, at}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "event": "seen",
  "at": "2026-06-18T15:10:00Z"
}
</output-example>

<examples-good>
- clor bluesky notification seen    # clear the unread badge by marking everything seen
- clor bluesky notification seen --stdout-format json | jq .at    # the timestamp marked as seen
- clor bluesky notification list --unread-only && clor bluesky notification seen    # read unread, then clear the badge
</examples-good>

<examples-bad>
- clor bluesky notification seen now    # seen takes no positional arguments
- clor bluesky notification seen --at 2026-01-01    # there is no --at flag; seen always marks as of now
</examples-bad>
</help>

<help command="clor bluesky pin">
<summary>Pin one of your posts to the top of your profile by its at:// URI</summary>
<description>Sets the pinnedPost on your app.bsky.actor.profile record to the post at
<URI>, which the Bluesky app shows at the top of your profile. Pinning
replaces any previously pinned post. Only your own profile is changed;
the rest of it (display name, description, avatar, banner) is preserved.
Prints the updated profile record's at:// URI.</description>
<usage>clor bluesky pin <URI> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {event, post, uri, cid}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "event": "pinned",
  "post": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.post/3kfoobar2x4",
  "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.actor.profile/self",
  "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz"
}
</output-example>

<examples-good>
- clor bluesky pin at://did:plc:abc123/app.bsky.feed.post/3kfoobar    # pin a post to the top of your profile
- clor bluesky post "read this first" --stdout-format json | jq -r .uri | xargs clor bluesky pin    # post then pin it in one pipeline
- clor bluesky pin at://did:plc:abc123/app.bsky.feed.post/3kfoobar --stdout-format json | jq .post    # capture the pinned post URI
</examples-good>

<examples-bad>
- clor bluesky pin 3kfoobar    # pass the full at:// URI, not the bare record key
- clor bluesky pin    # the post URI is required
</examples-bad>
</help>

<help command="clor bluesky post">
<summary>Create a post, optionally as a reply or quote, with images, a video, or a link card</summary>
<description>Links, #hashtags, and @mentions in <TEXT> are detected and turned into
rich-text facets automatically; mentions resolve to the right account.
--reply and --quote take an at:// post URI. --image may be repeated up
to four times; pair each with --image-alt in the same order for
accessibility. --video-job embeds a finished upload from
`clor bluesky video upload`. --link-card attaches a link card for a
URL, rendered as a unified box with a thumbnail, title, and domain; the
title, description, and thumbnail are fetched automatically and each
--link-card-* flag overrides one field. A post carries at most one of
images, a video, or a link card, and any of them can pair with a --quote.
Prints the new post's at:// URI.</description>
<usage>clor bluesky post <TEXT> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --image stringArray: path to an image to attach (repeatable, up to 4) (default "[]")
- --image-alt stringArray: alt text for the image at the same position (repeatable) (default "[]")
- --language stringArray: BCP 47 language tag of the post text, e.g. en (repeatable) (default "[]")
- --link-card string: attach a link card (app.bsky.embed.external) for this URL, fetching its title, description, and thumbnail
- --link-card-description string: override the link-card description
- --link-card-no-fetch bool: skip the metadata fetch and build the card from --link-card plus the override flags
- --link-card-thumbnail string: use this local image file as the link-card thumbnail instead of the fetched one
- --link-card-title string: override the link-card title
- --quote string: at:// URI of a post to quote
- --reply string: at:// URI of a post to reply to
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --video-alt string: alt text for the embedded video
- --video-aspect-ratio string: aspect ratio of the video as W:H, e.g. 16:9
- --video-caption stringArray: WebVTT caption track as <FILE>:<LANG>, e.g. ./captions.vtt:en (repeatable) (default "[]")
- --video-job string: embed the finished video from this upload job uid (from `clor bluesky video upload`)
</flags>

<output>json outputs the whole createRecord envelope {uri, cid, commit, validationStatus}. jsonl outputs the same object on one line; text is the logfmt of the uri and cid.</output>

<output-example format="json">
{
  "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz",
  "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.post/3kfoobar2x4",
  "validationStatus": "valid"
}
</output-example>

<examples-good>
- clor bluesky post "hello from the CLI"    # a plain post; prints the new at:// URI
- clor bluesky post "great thread @bsky.app #atproto https://atproto.com"    # mention, hashtag, and link become rich-text facets automatically
- clor bluesky post "my reply" --reply at://did:plc:abc/app.bsky.feed.post/3kfoo --stdout-format json | jq .uri    # reply to a post and capture the new URI
- clor bluesky post "look at this" --image ./photo.jpg --image-alt "a sunset over the sea"    # attach an image with alt text
- clor bluesky post "a short clip" --video-job ft6c2x4abcd --video-alt "a short clip" --video-aspect-ratio 16:9    # embed a finished video upload; pass the job uid from `clor bluesky video upload`
- clor bluesky post "Great read https://atproto.com" --link-card https://atproto.com --stdout-format json | jq .uri    # attach a link card with an auto-fetched thumbnail, title, and domain
- clor bluesky post "worth a look" --quote at://did:plc:abc/app.bsky.feed.post/3kfoo --link-card https://atproto.com    # quote a post and attach a link card together (record-with-media)
</examples-good>

<examples-bad>
- clor bluesky post    # the post text is required
- clor bluesky post "hi" --reply 3kfoo    # --reply needs a full at:// URI, not a bare record key
- clor bluesky post "hi" --image a.jpg --image b.jpg --image c.jpg --image d.jpg --image e.jpg    # at most 4 images per post
- clor bluesky post "hi" --link-card https://atproto.com --image a.jpg    # a post carries at most one of images, a video, or a link card
- clor bluesky post "hi" --link-card-title "Custom"    # the --link-card-* flags require --link-card
</examples-bad>
</help>

<help command="clor bluesky profile">
<summary>Read and update Bluesky profiles: show one account, or update your own</summary>
<description>Show any account's profile, or update your own display name,
description, avatar, and banner.

Use when:
  - the user wants to see an account's bio and follower counts
  - the user wants to change their own display name or bio
  - the user wants to set a new avatar or banner image

Subcommands:
  show    Show one or more profiles (defaults to your own)
  search  Search for accounts by name, handle, or bio keyword
  update  Update your own display name, description, avatar, banner, or handle

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky profile</usage>

<subcommands>
- search: Search for accounts by name, handle, or bio keyword
- show: Show one or more profiles with follower counts, defaulting to your own
- update: Update your own display name, description, avatar, banner, or handle
</subcommands>
</help>


<help command="clor bluesky profile search">
<summary>Search for accounts by name, handle, or bio keyword</summary>
<description>Matches the query against display names, handles, and descriptions,
the same typeahead Bluesky uses, so a bot can discover accounts to
follow, mention, or message.</description>
<usage>clor bluesky profile search <QUERY> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --limit int: maximum accounts to return (1-100 per call, paginated above 100) (default "25")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {actors, cursor}. jsonl outputs each record from actors on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "actors": [
    {
      "description": "building on the open social web, posts about distributed systems",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "displayName": "Alice Rivera",
      "handle": "alice.bsky.social",
      "indexedAt": "2026-05-02T09:15:00Z"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky profile search "climate scientist"    # accounts matching the phrase, logfmt
- clor bluesky profile search rust --limit 10 --stdout-format json | jq -r '.actors[].handle'    # handles of the top 10 matches
- clor bluesky follow $(clor bluesky profile search "golang" --limit 5 --stdout-format json | jq -r '.actors[].did')    # discover and follow accounts in one pipeline
</examples-good>

<examples-bad>
- clor bluesky profile search    # a query is required
- clor bluesky profile search rust --limit 0    # --limit must be at least 1
</examples-bad>
</help>


<help command="clor bluesky profile show">
<summary>Show one or more profiles with follower counts, defaulting to your own</summary>
<description>With no arguments, shows your own profile. Pass any number of handles
or DIDs to hydrate them all in one session (batched 25 per call), which
is how a bot turns a list of follower DIDs into follower counts. Each
result carries a following= flag for whether you follow that account.</description>
<usage>clor bluesky profile show [HANDLE]... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {profiles[]}. jsonl outputs each record from profiles on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "profiles": [
    {
      "description": "building on the open social web, posts about distributed systems",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "displayName": "Alice Rivera",
      "followersCount": 8421,
      "followsCount": 312,
      "handle": "alice.bsky.social",
      "indexedAt": "2026-05-02T09:15:00Z",
      "postsCount": 1947,
      "viewer": {
        "following": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.graph.follow/3kbcd1234ab"
      }
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky profile show    # your own profile, logfmt
- clor bluesky profile show bsky.app pfrazee.com    # several profiles in one session
- clor bluesky profile show $(clor bluesky follower list --not-following --limit 100 --stdout-format json | jq -r '.followers[].did') --stdout-format json | jq '[.profiles[] | select(.followersCount > 5000) | .handle]'    # VIP (>5k followers) followers you don't follow back
</examples-good>

<examples-bad>
- clor bluesky profile show @    # pass a real handle or DID
- clor bluesky profile show --not-following    # there is no --not-following here; that flag is on follower list
</examples-bad>
</help>


<help command="clor bluesky profile update">
<summary>Update your own display name, description, avatar, banner, or handle</summary>
<description>Only the flags you pass change; everything else, including an existing
avatar or banner, is preserved. --avatar and --banner take image file
paths. --handle changes the account handle, for example to a custom
domain you own. A custom-domain handle is verified against its DNS or
well-known DID document before the change unless you pass --force.</description>
<usage>clor bluesky profile update [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --avatar string: path to a new avatar image
- --banner string: path to a new banner image
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --description string: new profile description (pass empty to clear)
- --display-name string: new display name (pass empty to clear)
- --force bool: skip the DNS and well-known verification and change the handle regardless
- --handle string: new account handle, for example a custom domain you own
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {event, uri, cid}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "event": "updated",
  "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.actor.profile/self",
  "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz"
}
</output-example>

<examples-good>
- clor bluesky profile update --display-name "Leo"    # change only the display name
- clor bluesky profile update --description "building on the open social web"    # change only the bio
- clor bluesky profile update --avatar ./avatar.png --stdout-format json | jq .uri    # set a new avatar and capture the record URI
- clor bluesky profile update --handle leo.example    # switch to a custom-domain handle after its _atproto record is set
- clor bluesky profile update --handle leo.example --force    # change the handle without the verification check when you know the setup is correct
</examples-good>

<examples-bad>
- clor bluesky profile update    # pass at least one field to change
- clor bluesky profile update --avatar ./missing.png    # the avatar file must exist and be readable
- clor bluesky profile update --force    # --force only applies together with --handle
- clor bluesky profile update --handle leo.example    # fails until the _atproto.leo.example TXT record points at your DID (or use --force)
</examples-bad>
</help>

<help command="clor bluesky repost">
<summary>Repost one or more posts by their at:// URIs in a single session</summary>
<description>Pass any number of at:// post URIs; they are all reposted within one
session. A post that fails does not stop the rest.</description>
<usage>clor bluesky repost <URI>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=repost header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4",
      "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.repost/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky repost at://did:plc:abc123/app.bsky.feed.post/3kfoobar    # repost a single post
- clor bluesky repost $(clor bluesky search "open source" --limit 3 --stdout-format json | jq -r '.posts[].uri')    # repost the top 3 search hits in one session
- clor bluesky repost at://did:plc:abc/app.bsky.feed.post/3kfoo --stdout-format json | jq '.results[].uri'    # capture the repost record URIs
</examples-good>

<examples-bad>
- clor bluesky repost 3kfoobar    # pass the full at:// URI, not the bare record key
- clor bluesky repost    # at least one post URI is required
</examples-bad>
</help>

<help command="clor bluesky search">
<summary>Search public posts by keyword, newest or top first</summary>
<usage>clor bluesky search <QUERY> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --author string: restrict to posts by this handle or DID
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum posts to return (1-100 per call, paginated above 100) (default "25")
- --since string: only posts at or after this time (RFC 3339, e.g. 2026-01-01T00:00:00Z)
- --sort string: ranking order (top|latest) (default "latest")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --until string: only posts before this time (RFC 3339)
</flags>

<output>json outputs the whole envelope {posts, cursor, hitsTotal}. jsonl outputs each record from posts on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "cursor": "3kfoobar2x4::1718721127",
  "hitsTotal": 742,
  "posts": [
    {
      "$type": "app.bsky.feed.defs#postView",
      "author": {
        "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
        "displayName": "Alice Rivera",
        "handle": "alice.bsky.social"
      },
      "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz",
      "indexedAt": "2026-06-18T14:32:09Z",
      "likeCount": 128,
      "quoteCount": 3,
      "record": {
        "$type": "app.bsky.feed.post",
        "createdAt": "2026-06-18T14:32:07Z",
        "text": "shipping a new feature today, the open social web keeps getting better"
      },
      "replyCount": 12,
      "repostCount": 34,
      "uri": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky search "at protocol"    # 25 latest public posts matching the phrase, logfmt
- clor bluesky search rainbows --sort top --limit 10 --stdout-format json | jq '.posts[].uri'    # URIs of the 10 top-ranked matches
- clor bluesky search bluesky --author bsky.app --since 2026-01-01T00:00:00Z --stdout-format text | grep '^event=result '    # posts by one author since a date, one line each
</examples-good>

<examples-bad>
- clor bluesky search    # a query is required
- clor bluesky search rainbows --sort newest    # --sort must be top or latest
</examples-bad>
</help>

<help command="clor bluesky thread">
<summary>Read a post and its reply tree, flattened depth-first with a depth attribute</summary>
<description><URI> is an at:// post URI, e.g. one printed by `clor bluesky timeline`
or `clor bluesky post`. In text and jsonl the root sits at depth=0 and each
reply carries depth=N; in json the nested thread is preserved.</description>
<usage>clor bluesky thread <URI> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --depth int: how many reply levels below the post to include (default "6")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {thread, threadgate}, with thread.post the root and thread.replies the nested reply tree. jsonl and text flatten the tree depth-first into one line per node with a depth= attr.</output>

<output-example format="json">
{
  "thread": {
    "$type": "app.bsky.feed.defs#threadViewPost",
    "post": {
      "$type": "app.bsky.feed.defs#postView",
      "author": {
        "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
        "displayName": "Alice Rivera",
        "handle": "alice.bsky.social"
      },
      "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz",
      "indexedAt": "2026-06-18T14:32:09Z",
      "likeCount": 128,
      "quoteCount": 3,
      "record": {
        "$type": "app.bsky.feed.post",
        "createdAt": "2026-06-18T14:32:07Z",
        "text": "shipping a new feature today, the open social web keeps getting better"
      },
      "replyCount": 12,
      "repostCount": 34,
      "uri": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4"
    },
    "replies": [
      {
        "$type": "app.bsky.feed.defs#threadViewPost",
        "post": {
          "$type": "app.bsky.feed.defs#postView",
          "author": {
            "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
            "displayName": "Alice Rivera",
            "handle": "alice.bsky.social"
          },
          "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz",
          "indexedAt": "2026-06-18T14:32:09Z",
          "likeCount": 128,
          "quoteCount": 3,
          "record": {
            "$type": "app.bsky.feed.post",
            "createdAt": "2026-06-18T14:32:07Z",
            "text": "shipping a new feature today, the open social web keeps getting better"
          },
          "replyCount": 12,
          "repostCount": 34,
          "uri": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4"
        }
      }
    ]
  }
}
</output-example>

<examples-good>
- clor bluesky thread at://did:plc:abc123/app.bsky.feed.post/3kfoobar    # the post and its replies, one logfmt line per node with depth=N
- clor bluesky thread at://did:plc:abc123/app.bsky.feed.post/3kfoobar --depth 1    # the post and only its direct replies
- clor bluesky thread at://did:plc:abc123/app.bsky.feed.post/3kfoobar --stdout-format json | jq '.thread.replies | length'    # number of direct replies
</examples-good>

<examples-bad>
- clor bluesky thread 3kfoobar    # pass the full at:// URI, not the bare record key
- clor bluesky thread at://did:plc:abc123/app.bsky.feed.post/3kfoobar --depth -1    # --depth must be 0 or more
</examples-bad>
</help>

<help command="clor bluesky timeline">
<summary>Read the home timeline of posts from accounts you follow, newest first</summary>
<usage>clor bluesky timeline [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --cursor string: resume from a cursor returned by a previous call
- --limit int: maximum posts to return (1-100 per call, paginated above 100) (default "30")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {feed, cursor}. jsonl outputs each record from feed on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "cursor": "3kfoobar2x4::1718721127",
  "feed": [
    {
      "post": {
        "$type": "app.bsky.feed.defs#postView",
        "author": {
          "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
          "displayName": "Alice Rivera",
          "handle": "alice.bsky.social"
        },
        "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz",
        "indexedAt": "2026-06-18T14:32:09Z",
        "likeCount": 128,
        "quoteCount": 3,
        "record": {
          "$type": "app.bsky.feed.post",
          "createdAt": "2026-06-18T14:32:07Z",
          "text": "shipping a new feature today, the open social web keeps getting better"
        },
        "replyCount": 12,
        "repostCount": 34,
        "uri": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4"
      }
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky timeline    # 30 newest posts from accounts you follow, logfmt
- clor bluesky timeline --limit 5 --stdout-format json | jq '{first:.feed[0].post.uri, next:.cursor}'    # newest post URI plus the cursor to resume from
- clor bluesky timeline --limit 50 --cursor "$SAVED_CURSOR" --stdout-format text | grep '^event=result '    # the next page after a saved cursor
</examples-good>

<examples-bad>
- clor bluesky timeline --limit 0    # --limit must be at least 1
- clor bluesky timeline post    # timeline takes no positional arguments
</examples-bad>
</help>

<help command="clor bluesky unfollow">
<summary>Stop following one or more accounts by handle or DID in a single session</summary>
<description>Pass any number of handles or DIDs; the matching follow records are
deleted within one session. A target you do not follow, or one that
fails, does not stop the rest.</description>
<usage>clor bluesky unfollow <HANDLE>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=unfollow header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "alice.bsky.social",
      "did": "did:plc:z72i7hdynmk6r22z27h6tvur",
      "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.graph.follow/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky unfollow bsky.app    # stop following a single account
- clor bluesky unfollow alice.bsky.social bob.bsky.social    # stop following several accounts in one session
- clor bluesky unfollow bsky.app --stdout-format json | jq '.results[].uri'    # the deleted follow record URIs
</examples-good>

<examples-bad>
- clor bluesky unfollow    # at least one handle or DID is required
- clor bluesky unfollow someone-you-dont-follow.bsky.social    # reports not-following for that target and continues
</examples-bad>
</help>

<help command="clor bluesky unlike">
<summary>Remove your like from one or more posts by their at:// URIs in a single session</summary>
<usage>clor bluesky unlike <URI>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=unlike header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4",
      "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.like/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky unlike at://did:plc:abc123/app.bsky.feed.post/3kfoobar    # remove your like from a post
- clor bluesky unlike at://did:plc:abc/app.bsky.feed.post/3kfoo at://did:plc:def/app.bsky.feed.post/3kbar    # unlike several posts in one session
- clor bluesky unlike at://did:plc:abc/app.bsky.feed.post/3kfoo --stdout-format json | jq '.results[].uri'    # the deleted like record URIs
</examples-good>

<examples-bad>
- clor bluesky unlike 3kfoobar    # pass the full at:// URI, not the bare record key
- clor bluesky unlike at://did:plc:abc/app.bsky.feed.post/never-liked    # reports not-liked for that post and continues
</examples-bad>
</help>

<help command="clor bluesky unpin">
<summary>Remove the pinned post from your profile</summary>
<description>Clears the pinnedPost on your app.bsky.actor.profile record. The rest of
your profile is preserved. Reports not-pinned when no post is pinned.</description>
<usage>clor bluesky unpin [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {event, post, uri, cid}; post is present only when a post was pinned. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "event": "unpinned",
  "post": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.post/3kfoobar2x4",
  "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.actor.profile/self",
  "cid": "bafyreib2rxk3rybk3xktdxewqkr3hr5ujg3lq4qhmq7e7c2x4abcdxyz"
}
</output-example>

<examples-good>
- clor bluesky unpin    # remove the pinned post from your profile
- clor bluesky unpin --stdout-format json | jq .event    # unpinned when a post was pinned, not-pinned when none was
- clor bluesky unpin --account leo.example    # unpin on a specific saved account
</examples-good>

<examples-bad>
- clor bluesky unpin at://did:plc:abc/app.bsky.feed.post/3kfoo    # unpin takes no arguments; it clears whatever is pinned
- clor bluesky unpin --account nope    # the named account must exist in the secrets store
</examples-bad>
</help>

<help command="clor bluesky unrepost">
<summary>Remove your repost of one or more posts by their at:// URIs in a single session</summary>
<usage>clor bluesky unrepost <URI>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {attempted, succeeded, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=unrepost header line then one event=result line per target.</output>

<output-example format="json">
{
  "attempted": 1,
  "succeeded": 1,
  "results": [
    {
      "target": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.post/3kfoobar2x4",
      "uri": "at://did:plc:youraccountdidxxxxxxxxxxxx/app.bsky.feed.repost/3kbcd1234ab"
    }
  ]
}
</output-example>

<examples-good>
- clor bluesky unrepost at://did:plc:abc123/app.bsky.feed.post/3kfoobar    # remove your repost of a post
- clor bluesky unrepost at://did:plc:abc/app.bsky.feed.post/3kfoo at://did:plc:def/app.bsky.feed.post/3kbar    # remove several reposts in one session
- clor bluesky unrepost at://did:plc:abc/app.bsky.feed.post/3kfoo --stdout-format json | jq '.results[].uri'    # the deleted repost record URIs
</examples-good>

<examples-bad>
- clor bluesky unrepost 3kfoobar    # pass the full at:// URI, not the bare record key
- clor bluesky unrepost at://did:plc:abc/app.bsky.feed.post/never-reposted    # reports not-reposted for that post and continues
</examples-bad>
</help>

<help command="clor bluesky video">
<summary>Upload a video, track its transcode job, then embed it in a post</summary>
<description>Attaching a video to Bluesky is asynchronous. A file is handed to the
video service, which transcodes it as a background job and yields a video
blob once it finishes. Upload first, then embed the finished job in a post
with post --video-job <UID>.

Use when:
  - the user wants to attach a video to a Bluesky post
  - the user wants to check whether an in-progress video upload has finished

Subcommands:
  upload  Upload a video file and start its transcode job
  status  Check the transcode state of a video upload job

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky video</usage>

<uses>
- the user wants to attach a video to a Bluesky post
- the user wants to check whether an in-progress video upload has finished transcoding
</uses>

<subcommands>
- status: Check the transcode state of a video upload job
- upload: Upload a video file and start its transcode job
</subcommands>
</help>


<help command="clor bluesky video status">
<summary>Check the transcode state of a video upload job</summary>
<description>Reports the job state and progress, and once transcoding finishes the
resulting video blob (cid and size). Embed a finished job in a post with
post --video-job <UID>.</description>
<usage>clor bluesky video status <UID> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole job status {jobId, did, state, progress, blob}. jsonl outputs the same object on one line; text is the logfmt of uid, state, progress, and once complete the blob cid and size.</output>

<output-example format="json">
{
  "blob": {
    "$type": "blob",
    "ref": {
      "$link": "bafkreih42jximhme3r3cumfmvfdf5odgkfqvt7yhd5xlsfhy7ulckv5bti"
    },
    "mimeType": "video/mp4",
    "size": 4194304
  },
  "did": "did:plc:youraccountdidxxxxxxxxxxxx",
  "jobId": "ft6c2x4abcd7h6tvur",
  "progress": 100,
  "state": "JOB_STATE_COMPLETED"
}
</output-example>

<examples-good>
- clor bluesky video status ft6c2x4abcd    # report the current transcode state and progress
- clor bluesky video status ft6c2x4abcd --stdout-format json | jq '{state, cid: .blob.ref}'    # read the state and the finished blob cid
- clor bluesky video status ft6c2x4abcd --stdout-format text | grep '^event=status '    # the logfmt status line
</examples-good>

<examples-bad>
- clor bluesky video status    # the job uid is required
- clor bluesky video status ./clip.mp4    # pass the job uid from `clor bluesky video upload`, not the file path
</examples-bad>
</help>


<help command="clor bluesky video upload">
<summary>Upload a video file and start its transcode job</summary>
<description>Hands an mp4 to the video service, which transcodes it as a background
job and returns a job uid immediately. Embed the finished video in a post
with post --video-job <UID>. Pass --wait to block until the job finishes
instead of polling video status yourself.</description>
<usage>clor bluesky video upload <FILE> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read bluesky-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --timeout duration: max time to wait when --wait is set (e.g. 30s, 5m) (default "5m0s")
- --wait bool: poll the transcode job to completion before returning
</flags>

<output>json outputs the whole job status {jobId, did, state, progress, blob}. jsonl outputs the same object on one line; text is the logfmt of uid, state, progress, and once complete the blob cid and size.</output>

<output-example format="json">
{
  "blob": {
    "$type": "blob",
    "ref": {
      "$link": "bafkreih42jximhme3r3cumfmvfdf5odgkfqvt7yhd5xlsfhy7ulckv5bti"
    },
    "mimeType": "video/mp4",
    "size": 4194304
  },
  "did": "did:plc:youraccountdidxxxxxxxxxxxx",
  "jobId": "ft6c2x4abcd7h6tvur",
  "progress": 100,
  "state": "JOB_STATE_COMPLETED"
}
</output-example>

<examples-good>
- clor bluesky video upload ./clip.mp4    # start the transcode and print the job uid immediately
- clor bluesky video upload ./clip.mp4 --wait --timeout 5m    # block until transcoding finishes, then print the resulting blob
- clor bluesky video upload ./clip.mp4 --stdout-format json | jq -r .jobId    # capture the job uid to pass to post --video-job
</examples-good>

<examples-bad>
- clor bluesky video upload    # the video file path is required
- clor bluesky video upload ./clip.mp4 --timeout 5m    # --timeout only takes effect together with --wait
</examples-bad>
</help>


## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

