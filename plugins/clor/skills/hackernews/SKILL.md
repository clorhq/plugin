---
name: hackernews
description: Hacker News (HN) stories and comments. Use when the user wants to search HN, read top stories or a full comment thread, learn what Hacker News says about a topic, or analyze posting-time and domain trends.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Hacker News client reference

<help command="clor hn">
<summary>Use Hacker News as a client: read feeds and threads, comment, submit, poll, vote, flag, favorite, hide, edit, delete</summary>
<description>Drives Hacker News by scraping news.ycombinator.com directly,
authenticated with a username and password stored as a typed secret. Reads
every feed (top, new, best, ask, show, jobs, your submissions, comments,
favorites, upvoted) and any thread, and performs the full set of
authenticated actions. Every read also carries each item's available action
tokens, so a read flows straight into a comment, vote, or flag.

Use when:
  - the user wants to read a Hacker News feed, a thread, or a profile while signed in
  - the user wants to comment on or reply to a story or comment
  - the user wants to submit a story or poll, or vote, flag, favorite, hide, vouch
  - the user wants to edit or delete their own posts, or update their profile

Subcommands:
  account   Manage saved Hacker News credentials
  whoami    Show the logged-in account, karma, and creation date
  profile   Show profiles or update your own
  list      Read a feed
  show      Read a story or comment with its comment tree
  comment   Comment on a story or reply to a comment
  submit    Submit a story or text post
  poll      Submit a poll
  edit      Edit one of your items
  delete    Delete your items
  vote      Upvote or downvote items
  unvote    Remove your vote
  flag      Flag items
  unflag    Remove your flag
  favorite  Favorite items
  unfavorite Remove your favorite
  hide      Hide items from your feed
  unhide    Unhide items
  vouch     Vouch for dead items
  unvouch   Remove your vouch

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor hn [flags]</usage>

<uses>
- the user wants to read a Hacker News feed, a thread, or a profile while signed in
- the user wants to comment on or reply to a story or comment
- the user wants to submit a story or poll, or vote, flag, favorite, hide, or vouch
- the user wants to edit or delete their own posts, or update their profile
</uses>

<subcommands>
- account: Manage saved Hacker News credentials (username, password) used by every Hacker News subcommand
- comment: Comment on a story or reply to a comment
- delete: Delete one or more of your own items in a single session
- edit: Edit the title, URL, or text of one of your own items
- favorite: Favorite one or more items in a single session
- flag: Flag one or more items in a single session
- hide: Hide one or more items from your feed in a single session
- list: Read a Hacker News feed (top, new, best, ask, show, jobs, submitted, comments, favorites, upvoted)
- poll: Submit a poll with two or more choices
- profile: Read Hacker News profiles or update your own (about, email, display settings)
- show: Read a story or comment with its comment tree, each node carrying its available action tokens
- submit: Submit a story by URL or a text post (Ask HN, Show HN)
- unfavorite: Remove your favorite from one or more items in a single session
- unflag: Remove your flag from one or more items in a single session
- unhide: Unhide one or more items in a single session
- unvote: Remove your vote from one or more items in a single session
- unvouch: Remove your vouch from one or more items in a single session
- vote: Upvote or downvote one or more items in a single session
- vouch: Vouch for one or more dead items in a single session
- whoami: Show the logged-in account with its karma, creation date, and about text
</subcommands>

<flags>
- --help bool: help for hn
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


<help command="clor hn account">
<summary>Manage saved Hacker News credentials (username, password) used by every Hacker News subcommand</summary>
<description>Credentials are stored as a typed secret (username, password). Once
saved, every Hacker News subcommand picks them up automatically (or via
--account when more than one is configured), and the session cookie from
the first login is cached back so later commands skip re-logging in.

Use when:
  - the user wants to register a Hacker News account for the CLI to use
  - the user wants to see which Hacker News accounts are saved
  - the user wants to inspect or rotate stored credentials
  - the user wants to remove a Hacker News account

Subcommands:
  add     Save or update a Hacker News account by username and password
  list    List saved Hacker News accounts visible to the caller
  get     Read one saved Hacker News account, with the raw JSON in json mode
  delete  Permanently remove a saved Hacker News account by name

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor hn account</usage>

<uses>
- the user wants to register a new Hacker News account for the CLI to use
- the user wants to see which Hacker News accounts are saved
- the user wants to inspect or rotate stored credentials
- the user wants to remove a Hacker News account
</uses>

<subcommands>
- add: Save or update a Hacker News account by username and password for use by other Hacker News subcommands
- delete: Permanently remove a saved Hacker News account by name
- get: Read a saved Hacker News account; pass --stdout-format json for the raw JSON including the password
- list: List saved Hacker News accounts with id and name
</subcommands>
</help>


<help command="clor hn account add">
<summary>Save or update a Hacker News account by username and password for use by other Hacker News subcommands</summary>
<description>[NAME] defaults to the username itself; re-running with the same name
updates in place.

Pass the password on --password directly, or pipe it via --stdin-format
text to keep it out of shell history. Hacker News has no app-password
concept, so this is the real account password; store it only in a secret
you control.</description>
<usage>clor hn account add [NAME] [flags]</usage>

<flags>
- --password string: Hacker News account password
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --username string: Hacker News username (required)
</flags>

<output>json outputs the saved account's metadata object {id, name, type, created, updated, accessed}; the password is never returned. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "accessed": "2026-06-18T14:30:00Z",
  "created": "2026-05-02T09:15:00Z",
  "id": "01931f7e-4c2a-7e10-9a3b-5d8c2f1e4b7a",
  "name": "jacobgold",
  "revision": 0,
  "type": "hackernews-account",
  "updated": "2026-06-18T14:30:00Z"
}
</output-example>

<examples-good>
- clor hn account add --username jacobgold --password hunter2    # save under the username
- clor hn account add main --username jacobgold --password hunter2    # save under a short alias instead of the username
- clor hn account add --username jacobgold --password hunter2 --stdout-format json | jq .id    # extract the new secret id
- printf '%s' hunter2 | clor hn account add --username jacobgold --stdin-format text    # stdin path, keeps the password out of shell history
</examples-good>

<examples-bad>
- clor hn account add --password hunter2    # --username is required
- clor hn account add --username jacobgold --password hunter2 --stdin-format text    # --password and --stdin-format are mutually exclusive
</examples-bad>
</help>


<help command="clor hn account delete">
<summary>Permanently remove a saved Hacker News account by name</summary>
<description>After deletion the other Hacker News subcommands can no longer use the
account unless re-added or supplied via --credentials-file or
--stdin-format json.</description>
<usage>clor hn account delete <NAME></usage>

<output>json outputs the whole envelope {deleted, name}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "deleted": true,
  "name": "jacobgold"
}
</output-example>

<examples-good>
- clor hn account delete jacobgold    # delete a Hacker News account
- clor hn account delete main    # delete by name
- clor hn account delete jacobgold --stdout-format json | jq .deleted    # scriptable confirmation
</examples-good>

<examples-bad>
- clor hn account delete    # name argument is required
- clor hn account delete jacobgold extra    # delete takes exactly one name
</examples-bad>
</help>


<help command="clor hn account get">
<summary>Read a saved Hacker News account; pass --stdout-format json for the raw JSON including the password</summary>
<description>Default logfmt drops the password; `--stdout-format json` returns
the raw hackernews-account JSON suitable for piping into
`clor hn <SUBCOMMAND> --stdin-format json`.</description>
<usage>clor hn account get <NAME></usage>

<examples-good>
- clor hn account get jacobgold    # logfmt without the password
- clor hn account get jacobgold --stdout-format json    # raw hackernews-account JSON including the password
- clor hn account get jacobgold --stdout-format json | clor hn list --feed top --stdin-format json --limit 5    # pipe credentials into another command
</examples-good>

<examples-bad>
- clor hn account get    # name argument is required
- clor hn account get jacobgold extra    # get takes exactly one name
</examples-bad>
</help>


<help command="clor hn account list">
<summary>List saved Hacker News accounts with id and name</summary>
<description>Metadata only (id, name, last access); passwords stay encrypted
server-side. Use `account get` to retrieve the full JSON.</description>
<usage>clor hn account list</usage>

<output>json outputs the whole envelope {secrets[]} of account metadata; passwords stay encrypted server-side. jsonl outputs each record from secrets on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "secrets": [
    {
      "accessed": "2026-06-18T14:30:00Z",
      "created": "2026-05-02T09:15:00Z",
      "id": "01931f7e-4c2a-7e10-9a3b-5d8c2f1e4b7a",
      "name": "jacobgold",
      "revision": 0,
      "type": "hackernews-account",
      "updated": "2026-06-18T14:30:00Z"
    }
  ]
}
</output-example>

<examples-good>
- clor hn account list    # every saved Hacker News account, logfmt
- clor hn account list --stdout-format jsonl    # one account per line
- clor hn account list --stdout-format json | jq '.secrets[].name'    # names of every saved Hacker News account
</examples-good>

<examples-bad>
- clor hn account list main    # list takes no arguments; use `clor hn account get <NAME>`
- clor hn account list --stdout-format yaml    # format must be text, jsonl, or json
</examples-bad>
</help>

<help command="clor hn comment">
<summary>Comment on a story or reply to a comment</summary>
<description><PARENT_ID> is the story to comment on or the comment to reply to;
Hacker News uses the same form for both. The new comment id is returned by
reading it back off your own comments after the post.</description>
<usage>clor hn comment <PARENT_ID> <TEXT> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs {event, id} with the new comment id. jsonl and text output the same on one event=comment line. id is 0 when it could not be read back.</output>

<output-example format="json">
{
  "event": "comment",
  "id": 48709001
}
</output-example>

<examples-good>
- clor hn comment 48707763 "Great writeup, thanks for sharing."    # top-level comment on a story
- clor hn comment 48708460 "Agreed, the forgery angle is wild."    # reply to a comment
- clor hn comment 48707763 "Nice" --stdout-format json | jq .id    # capture the new comment id
</examples-good>

<examples-bad>
- clor hn comment 48707763    # both a parent id and the comment text are required
- clor hn comment abc "hi"    # parent id must be a positive integer
</examples-bad>
</help>

<help command="clor hn delete">
<summary>Delete one or more of your own items in a single session</summary>
<description>Each id is deleted via its confirmation form. Deleting is only possible
while the item is still yours and within the window; otherwise that id
reports the cause and the batch continues.</description>
<usage>clor hn delete <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]} with one result per id. jsonl outputs one result per line; text is an event=delete header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "delete",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn delete 48709050    # delete one of your items
- clor hn delete 48709050 48709001    # delete several of your items in one session
- clor hn delete 48709050 --stdout-format json | jq '.results[0].ok'    # confirm the delete landed
</examples-good>

<examples-bad>
- clor hn delete    # at least one item id is required
- clor hn delete abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn edit">
<summary>Edit the title, URL, or text of one of your own items</summary>
<description>Sets only the fields you pass; the rest keep their current values, read
off the edit form first. Editing is only possible while the item is still
yours and within the edit window, otherwise the form is absent and the
command says so.</description>
<usage>clor hn edit <ID> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --text string: new body text (for a text post or comment)
- --title string: new title
- --url string: new URL (for a link submission)
</flags>

<output>json outputs {event, id} for the edited item. jsonl and text output the same on one event=edit line.</output>

<output-example format="json">
{
  "event": "edit",
  "id": 48709050
}
</output-example>

<examples-good>
- clor hn edit 48709050 --title "A great article (updated)"    # change a story title
- clor hn edit 48709001 --text "Edited: clearer wording."    # edit your comment's text
- clor hn edit 48709050 --url https://example.com/v2 --stdout-format json | jq .id    # change the URL and confirm the id
</examples-good>

<examples-bad>
- clor hn edit 48709050    # pass at least one of --title, --url, or --text
- clor hn edit abc --title x    # id must be a positive integer
</examples-bad>
</help>

<help command="clor hn favorite">
<summary>Favorite one or more items in a single session</summary>
<usage>clor hn favorite <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=favorite header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "favorite",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn favorite 48707763    # favorite a single item
- clor hn favorite 48707763 48708941    # favorite several items in one session
- clor hn favorite 48707763 --stdout-format json | jq '.results[0].ok'    # confirm the favorite landed
</examples-good>

<examples-bad>
- clor hn favorite    # at least one item id is required
- clor hn favorite abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn flag">
<summary>Flag one or more items in a single session</summary>
<description>Flagging needs enough karma; when the flag link is absent the item
reports that and the batch continues.</description>
<usage>clor hn flag <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=flag header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "flag",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn flag 48707763    # flag a single item
- clor hn flag 48707763 48708941    # flag several items in one session
- clor hn flag 48707763 --stdout-format json | jq '.results[0].ok'    # check whether the flag landed
</examples-good>

<examples-bad>
- clor hn flag    # at least one item id is required
- clor hn flag abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn hide">
<summary>Hide one or more items from your feed in a single session</summary>
<usage>clor hn hide <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=hide header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "hide",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn hide 48707763    # hide a single item from your feed
- clor hn hide 48707763 48708941    # hide several items in one session
- clor hn hide 48707763 --stdout-format json | jq '.results[0].ok'    # confirm the hide landed
</examples-good>

<examples-bad>
- clor hn hide    # at least one item id is required
- clor hn hide abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn list">
<summary>Read a Hacker News feed (top, new, best, ask, show, jobs, submitted, comments, favorites, upvoted)</summary>
<description>--feed selects the feed. The user-scoped feeds (submitted, comments,
favorites) default to the logged-in account and accept --user to read
another account; upvoted is your own account only. Each result carries its
available action tokens so a vote or comment is one follow-up command.</description>
<usage>clor hn list [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --feed string: feed to read (top|new|best|ask|show|jobs|submitted|comments|favorites|upvoted) (default "top")
- --limit int: maximum items to return (default "30")
- --page int: page to start from (30 items per page) (default "1")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --user string: account for the submitted, comments, or favorites feed (default self)
</flags>

<output>json outputs the whole envelope {feed, count, items[]} with each item's id, title, url, site, score, author, age, comments, and available actions. jsonl outputs one item per line; text is an event=<feed> header then one event=result line per item.</output>

<output-example format="json">
{
  "count": 1,
  "feed": "top",
  "items": [
    {
      "id": 48707763,
      "rank": 1,
      "type": "story",
      "title": "5k Restaurant Menus, Years 1880-1920",
      "url": "https://pudding.cool/2026/06/menu-collection/",
      "site": "pudding.cool",
      "score": 188,
      "author": "xbryanx",
      "age": "3 hours ago",
      "comments": 43,
      "actions": [
        "upvote",
        "hide",
        "favorite"
      ]
    }
  ]
}
</output-example>

<examples-good>
- clor hn list --feed top --limit 10    # the top 10 stories with their action tokens
- clor hn list --feed ask --stdout-format json | jq '.items[].title'    # Ask HN titles as JSON
- clor hn list --feed submitted --user pg --limit 20    # another account's recent submissions
- clor hn list --feed top --stdout-format jsonl | grep '^{' | head    # one JSON object per line
</examples-good>

<examples-bad>
- clor hn list --feed frontpage    # feed must be one of the documented names
- clor hn list --feed top --user pg    # --user only applies to submitted, comments, and favorites
- clor hn list --feed upvoted --user pg    # upvoted is your own account only
</examples-bad>
</help>

<help command="clor hn poll">
<summary>Submit a poll with two or more choices</summary>
<description>Pass --option once per choice; at least two are required. --text is an
optional body. Creating polls is karma-gated on Hacker News. The new item
id is read back off your own submissions.</description>
<usage>clor hn poll [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --option stringArray: a poll choice; pass once per choice (at least two) (default "[]")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --text string: optional poll body
- --title string: poll question (required)
</flags>

<output>json outputs {event, id} with the new poll id. jsonl and text output the same on one event=poll line.</output>

<output-example format="json">
{
  "event": "poll",
  "id": 48709070
}
</output-example>

<examples-good>
- clor hn poll --title "Best editor?" --option Vim --option Emacs --option VSCode    # a three-choice poll
- clor hn poll --title "Tabs or spaces?" --option Tabs --option Spaces --text "Settle it."    # a poll with a body
- clor hn poll --title "Coffee or tea?" --option Coffee --option Tea --stdout-format json | jq .id    # capture the new poll id
</examples-good>

<examples-bad>
- clor hn poll --title "x" --option Only    # a poll needs at least two choices
- clor hn poll --option A --option B    # --title is required
</examples-bad>
</help>

<help command="clor hn profile">
<summary>Read Hacker News profiles or update your own (about, email, display settings)</summary>
<description>Reads any account's public profile, and updates the logged-in
account's own profile fields.

Use when:
  - the user wants to read one or more Hacker News profiles
  - the user wants to change their about text, email, or display settings

Subcommands:
  show    Show one or more profiles by username
  update  Update the logged-in account's own profile

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor hn profile</usage>

<uses>
- the user wants to read one or more Hacker News profiles
- the user wants to change their about text, email, or display settings
</uses>

<subcommands>
- show: Show one or more Hacker News profiles with karma, creation date, and about text
- update: Update the logged-in account's own profile fields
</subcommands>
</help>


<help command="clor hn profile show">
<summary>Show one or more Hacker News profiles with karma, creation date, and about text</summary>
<description>Pass any number of usernames; each is fetched in the same session.
With no username, shows the logged-in account's own profile.</description>
<usage>clor hn profile show [USERNAME]... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {count, profiles[]} with each profile's username, karma, created, and about. jsonl outputs one profile per line; text is an event=profile header then one event=result line per profile.</output>

<output-example format="json">
{
  "count": 1,
  "profiles": [
    {
      "username": "pg",
      "karma": 157316,
      "created": "October 9, 2006",
      "about": "Bug fixer."
    }
  ]
}
</output-example>

<examples-good>
- clor hn profile show pg    # one profile
- clor hn profile show pg dang patio11    # several profiles in one session
- clor hn profile show pg --stdout-format json | jq .profiles[0].karma    # read a karma value
</examples-good>

<examples-bad>
- clor hn profile show pg --stdout-format yaml    # format must be text, jsonl, or json
- clor hn profile show @pg    # pass the bare username with no @
</examples-bad>
</help>


<help command="clor hn profile update">
<summary>Update the logged-in account's own profile fields</summary>
<description>Sets only the flags you pass; every other field keeps its current
value, which is read off the edit form first. The display settings mirror
the website's profile editor.</description>
<usage>clor hn profile update [flags]</usage>

<flags>
- --about string: about text shown on your profile
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --delay string: minutes to delay your comments from appearing
- --email string: contact email (private)
- --noprocrast string: enable the noprocrastination timer (yes|no)
- --noprocrast-maxvisit string: minutes of browsing before noprocrast locks you out
- --noprocrast-minaway string: minutes you must stay away once locked out
- --showdead string: show dead items (yes|no)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --topcolor string: top bar color as a hex value, e.g. ff6600
</flags>

<output>json outputs the refreshed profile object {username, karma, created, about}. jsonl and text output the same keys on one event=updated line.</output>

<output-example format="json">
{
  "username": "jacobgold",
  "karma": 142,
  "created": "March 3, 2014",
  "about": "Building things."
}
</output-example>

<examples-good>
- clor hn profile update --about "Building things."    # change only the about text
- clor hn profile update --showdead yes --topcolor 222222    # change several display settings at once
- clor hn profile update --about "Hi" --stdout-format json | jq .about    # confirm the new about text
</examples-good>

<examples-bad>
- clor hn profile update    # pass at least one field to change
- clor hn profile update pg --about Hi    # update only changes your own profile and takes no username
</examples-bad>
</help>

<help command="clor hn show">
<summary>Read a story or comment with its comment tree, each node carrying its available action tokens</summary>
<description><ID> is the numeric item id. The lead item prints first, then the
comment tree flattened depth-first with a depth attribute per node. Each
node lists the actions available to the logged-in account (upvote, reply,
flag, ...) so a follow-up write is one command.</description>
<usage>clor hn show <ID> [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {item, comments[]} with each comment carrying its depth. text and jsonl print one event=item line then one event=comment line per node with a depth= attr; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "comments": [
    {
      "id": 48708460,
      "type": "comment",
      "author": "ricardobayes",
      "age": "2 hours ago",
      "text": "Anyone interested in this might also like ...",
      "actions": [
        "upvote",
        "reply"
      ],
      "depth": 0
    }
  ],
  "item": {
    "id": 48707763,
    "type": "story",
    "title": "5k Restaurant Menus, Years 1880-1920",
    "url": "https://pudding.cool/2026/06/menu-collection/",
    "score": 188,
    "author": "xbryanx",
    "comments": 43,
    "actions": [
      "upvote",
      "favorite",
      "reply"
    ]
  }
}
</output-example>

<examples-good>
- clor hn show 48707763    # the story and its full comment tree
- clor hn show 48707763 --stdout-format json | jq '.comments | length'    # count comment nodes
- clor hn show 48707763 --stdout-format jsonl | grep '^{' | jq -c 'select(.depth==0)'    # just the top-level comments
</examples-good>

<examples-bad>
- clor hn show abc    # id must be a positive integer
- clor hn show    # an item id is required
</examples-bad>
</help>

<help command="clor hn submit">
<summary>Submit a story by URL or a text post (Ask HN, Show HN)</summary>
<description>Pass --url for a link submission or --text for a text post; exactly one
of the two. The new item id is read back off your own submissions.</description>
<usage>clor hn submit [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --text string: body for a text post, e.g. Ask HN (mutually exclusive with --url)
- --title string: story or post title (required)
- --url string: link to submit (mutually exclusive with --text)
</flags>

<output>json outputs {event, id} with the new item id. jsonl and text output the same on one event=submit line.</output>

<output-example format="json">
{
  "event": "submit",
  "id": 48709050
}
</output-example>

<examples-good>
- clor hn submit --title "A great article" --url https://example.com/article    # link submission
- clor hn submit --title "Ask HN: favorite debugging tools?" --text "What do you reach for first?"    # Ask HN text post
- clor hn submit --title "Show HN: my project" --url https://example.com --stdout-format json | jq .id    # capture the new item id
</examples-good>

<examples-bad>
- clor hn submit --url https://example.com    # --title is required
- clor hn submit --title "x" --url https://example.com --text "y"    # pass exactly one of --url or --text
</examples-bad>
</help>

<help command="clor hn unfavorite">
<summary>Remove your favorite from one or more items in a single session</summary>
<usage>clor hn unfavorite <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=unfavorite header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "unfavorite",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn unfavorite 48707763    # remove your favorite from an item
- clor hn unfavorite 48707763 48708941    # unfavorite several items in one session
- clor hn unfavorite 48707763 --stdout-format json | jq '.succeeded'    # count how many were unfavorited
</examples-good>

<examples-bad>
- clor hn unfavorite    # at least one item id is required
- clor hn unfavorite abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn unflag">
<summary>Remove your flag from one or more items in a single session</summary>
<usage>clor hn unflag <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=unflag header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "unflag",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn unflag 48707763    # remove your flag from an item
- clor hn unflag 48707763 48708941    # unflag several items in one session
- clor hn unflag 48707763 --stdout-format json | jq '.succeeded'    # count how many were unflagged
</examples-good>

<examples-bad>
- clor hn unflag    # at least one item id is required
- clor hn unflag abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn unhide">
<summary>Unhide one or more items in a single session</summary>
<usage>clor hn unhide <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=unhide header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "unhide",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn unhide 48707763    # unhide an item
- clor hn unhide 48707763 48708941    # unhide several items in one session
- clor hn unhide 48707763 --stdout-format json | jq '.succeeded'    # count how many were unhidden
</examples-good>

<examples-bad>
- clor hn unhide    # at least one item id is required
- clor hn unhide abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn unvote">
<summary>Remove your vote from one or more items in a single session</summary>
<usage>clor hn unvote <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=unvote header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "unvote",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn unvote 48707763    # remove your vote from an item
- clor hn unvote 48707763 48708941    # unvote several items in one session
- clor hn unvote 48707763 --stdout-format json | jq '.succeeded'    # count how many were unvoted
</examples-good>

<examples-bad>
- clor hn unvote    # at least one item id is required
- clor hn unvote abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn unvouch">
<summary>Remove your vouch from one or more items in a single session</summary>
<usage>clor hn unvouch <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=unvouch header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "unvouch",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn unvouch 48707763    # remove your vouch from an item
- clor hn unvouch 48707763 48708941    # unvouch several items in one session
- clor hn unvouch 48707763 --stdout-format json | jq '.succeeded'    # count how many were unvouched
</examples-good>

<examples-bad>
- clor hn unvouch    # at least one item id is required
- clor hn unvouch abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn vote">
<summary>Upvote or downvote one or more items in a single session</summary>
<description>--direction defaults to up. Downvoting needs enough karma and is only
offered for a window after a comment is posted; when the downvote link is
absent the item reports that and the batch continues to the next id.</description>
<usage>clor hn vote <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --direction string: vote direction (up|down) (default "up")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]} with one result per id carrying ok and any error. jsonl outputs one result per line; text is an event=vote header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "vote",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn vote 48707763    # upvote a single item
- clor hn vote 48707763 48708941 48708654    # upvote several items in one session
- clor hn vote 48708460 --direction down --stdout-format json | jq '.results[0].ok'    # attempt a downvote and read whether it landed
</examples-good>

<examples-bad>
- clor hn vote    # at least one item id is required
- clor hn vote 48707763 --direction sideways    # --direction must be up or down
</examples-bad>
</help>

<help command="clor hn vouch">
<summary>Vouch for one or more dead items in a single session</summary>
<description>Vouching only applies to dead (killed) items and needs enough karma;
when the vouch link is absent the item reports that and the batch
continues.</description>
<usage>clor hn vouch <ID>... [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {action, attempted, succeeded, results[]}. jsonl outputs one result per line; text is an event=vouch header then one event=result line per id.</output>

<output-example format="json">
{
  "action": "vouch",
  "attempted": 1,
  "results": [
    {
      "id": 48707763,
      "ok": true
    }
  ],
  "succeeded": 1
}
</output-example>

<examples-good>
- clor hn vouch 48707763    # vouch for a dead item
- clor hn vouch 48707763 48708941    # vouch for several dead items in one session
- clor hn vouch 48707763 --stdout-format json | jq '.results[0].ok'    # check whether the vouch landed
</examples-good>

<examples-bad>
- clor hn vouch    # at least one item id is required
- clor hn vouch abc    # item ids must be positive integers
</examples-bad>
</help>

<help command="clor hn whoami">
<summary>Show the logged-in account with its karma, creation date, and about text</summary>
<description>Confirms the saved credentials open a live session and reports the
account that requests go out as. A failure here means the session could
not be established, which is the first thing to check.</description>
<usage>clor hn whoami [flags]</usage>

<flags>
- --account string: secret name to load credentials from (omit to auto-pick the only saved account)
- --credentials-file string: read hackernews-account JSON from this path instead of secrets (- for stdin)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the profile object {username, karma, created, about}. jsonl and text output the same keys on one event=whoami line.</output>

<output-example format="json">
{
  "username": "jacobgold",
  "karma": 142,
  "created": "March 3, 2014",
  "about": "Building things."
}
</output-example>

<examples-good>
- clor hn whoami    # confirm the logged-in account and karma
- clor hn whoami --stdout-format json | jq .karma    # read the current karma
- clor hn whoami --account main    # check which account a named secret signs in as
</examples-good>

<examples-bad>
- clor hn whoami jacobgold    # whoami takes no arguments; use `clor hn profile show jacobgold`
- clor hn whoami --stdout-format yaml    # format must be text, jsonl, or json
</examples-bad>
</help>

## Hacker News query reference

<help command="clor social">
<summary>Search Hacker News stories and comments plus Y Combinator companies and founders</summary>
<description>Search Hacker News stories and comments, run posting-time and
domain analytics, and query the Y Combinator directory of companies and
founders by batch, industry, region, and more.</description>
<usage>clor social [flags]</usage>

<uses>
- the user wants to know what people are saying about a topic right now
- the user wants top stories by score in a recent time window
- the user wants the full comment tree for a specific story
- the user wants analytics across HN posts (timing, domains, trends)
- the user wants to search or browse Y Combinator companies and founders
</uses>

<subcommands>
- hn: Search, browse, and analyze Hacker News stories and comments
- yc: Search Y Combinator companies and founders by text, batch, industry, region, tag, status, or slug
</subcommands>

<flags>
- --help bool: help for social
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


<help command="clor social hn">
<summary>Search, browse, and analyze Hacker News stories and comments</summary>
<description>HN as an analytics surface, not a feed: search stories by
text/author/window, pull popular items by score, fetch one story
plus its comment tree, and run analytics on posting timing, domain
mix, and topic trends.</description>
<usage>clor social hn</usage>

<uses>
- the user wants to find HN stories matching a query, author, or time window
- the user wants the top items by score in the last hour, day, week, or month
- the user wants one story or comment plus its full nested replies
- the user wants analytics: when to post, which domains dominate, how
    a topic's volume and scores have moved over time
</uses>

<subcommands>
- domain: Discover which URL hosts dominate Hacker News by volume, score, or front-page hits
- item: Fetch one HN item by id, optionally with its full nested comment tree
- popular: Find the top Hacker News items by score in a recent time window
- search: Search Hacker News items by free text, tags, author, time window, or score floor
- timing: Analyze HN historical posting-time outcomes by day-of-week and hour-of-day
- trend: Track how a topic has trended on Hacker News over time (volume and score distribution)
</subcommands>
</help>


<help command="clor social hn domain">
<summary>Discover which URL hosts dominate Hacker News by volume, score, or front-page hits</summary>
<usage>clor social hn domain</usage>

<uses>
- the user wants to see which publications drive a topic on HN
- the user wants to find sites that consistently land on the front page
</uses>

<subcommands>
- list: Rank the top URL hosts on HN (--metric volume|median_score|frontpage_count)
</subcommands>
</help>


<help command="clor social hn domain list">
<summary>Rank the top URL hosts on HN (--metric volume|median_score|frontpage_count)</summary>
<description>--sort picks the ranking metric: count|median|p90|frontpage|top.
Narrow the corpus with --query, --from/--until, or --min-stories.</description>
<usage>clor social hn domain list [flags]</usage>

<flags>
- --from string: lower bound on item time (Unix seconds, RFC3339, or relative like 24h or 7d) (default "1y")
- --limit int: max results (1-500) (default "50")
- --min-stories int: minimum stories per host to include (0 uses server default)
- --offset int: skip the first N results (pagination)
- --query string: free-text filter applied to title and body
- --sort string: ranking metric (count|median|p90|frontpage|top)
- --until string: upper bound on item time (same formats as --from)
</flags>

<output>json outputs the whole envelope {results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "results": [
    {
      "frontpage_count": 1407,
      "host": "github.com",
      "median_score": 18,
      "p90_score": 142,
      "story_count": 12840,
      "top_score": 2891
    },
    {
      "frontpage_count": 612,
      "host": "arstechnica.com",
      "median_score": 26,
      "p90_score": 168,
      "story_count": 4213,
      "top_score": 1502
    }
  ]
}
</output-example>

<examples-good>
- clor social hn domain list --from 90d --sort p90 --limit 25    # top 25 hosts by p90 score over the past 90 days
- clor social hn domain list --query "ai" --sort frontpage    # domains publishing the most score>=100 AI stories
- clor social hn domain list --sort count --min-stories 100 --stdout-format json | jq '.results[] | {host, story_count, top_score}'    # highest-volume hosts with at least 100 stories
- clor social hn domain list --from 7d --stdout-format jsonl    # JSONL stream of last week's leaderboard
</examples-good>

<examples-bad>
- clor social hn domain list --sort score    # use median, p90, count, frontpage, or top
- clor social hn domain list --limit 1000    # max --limit is 500
- clor social hn domain list --stdout-format yaml    # only text, jsonl, or json supported
</examples-bad>
</help>


<help command="clor social hn item">
<summary>Fetch one HN item by id, optionally with its full nested comment tree</summary>
<description>--with-comments walks the comment tree depth-first with a depth
attribute per node; the entire thread returns in one response.</description>
<usage>clor social hn item <ID> [flags]</usage>

<flags>
- --comment-depth int: max recursion depth for the comment tree (0 = unlimited)
- --with-comments bool: also return the assembled comment tree
</flags>

<output>json outputs the whole envelope {item, comments[]} with the comment tree nested via each node's children. text and jsonl flatten the tree depth-first and output one event=comment line per node with a depth= attr; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "comments": [
    {
      "children": [
        {
          "depth": 2,
          "item": {
            "by": "patio11",
            "id": 47990318,
            "parent": 47990012,
            "text": "The hard part is picking a ticket worth caring about for a decade.",
            "time": 1730421900,
            "type": "comment"
          }
        }
      ],
      "depth": 1,
      "item": {
        "by": "dang",
        "id": 47990012,
        "parent": 47989883,
        "text": "This reframes obsession as the engine rather than the symptom.",
        "time": 1730420400,
        "type": "comment"
      }
    }
  ],
  "item": {
    "by": "pg",
    "descendants": 168,
    "id": 47989883,
    "score": 412,
    "time": 1730419200,
    "title": "The Bus Ticket Theory of Genius",
    "type": "story",
    "url": "http://www.paulgraham.com/genius.html"
  }
}
</output-example>

<examples-good>
- clor social hn item 47989883    # story metadata only
- clor social hn item 47989883 --with-comments    # story plus full comment tree (one event=comment per node)
- clor social hn item 47989883 --with-comments --comment-depth 2    # limit replies to two levels deep
- clor social hn item 47989883 --with-comments --stdout-format json | jq '.comments | length'    # count top-level comments via JSON
- clor social hn item 47989883 --with-comments --stdout-format jsonl | jq -c 'select(.event=="comment" and .depth==1)'    # JSONL filtered to just top-level comments
</examples-good>

<examples-bad>
- clor social hn item abc    # id must be a positive integer
- clor social hn item 0    # id must be >= 1
- clor social hn item 47989883 --comment-depth -1    # depth must be >= 0
</examples-bad>
</help>


<help command="clor social hn popular">
<summary>Find the top Hacker News items by score in a recent time window</summary>
<usage>clor social hn popular</usage>

<uses>
- the user wants the top HN stories by score in a recent time window (last hour, day, week, or month)
</uses>

<subcommands>
- list: List the highest-scoring HN items in a chosen time window (--window 1h|1d|1w|1m)
</subcommands>
</help>


<help command="clor social hn popular list">
<summary>List the highest-scoring HN items in a chosen time window (--window 1h|1d|1w|1m)</summary>
<usage>clor social hn popular list [flags]</usage>

<flags>
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: id*,type*,by*,time*,title*,url*,score*,descendants*,text,parent,poll,dead,deleted,crawled,story_id*,story_title*,story_score*,story_url* (* = default)
- --limit int: max results (1-200) (default "50")
- --min-score int: filter score >= N
- --tags string: comma-separated subset (story|comment|job|poll|pollopt)
- --window string: time window (e.g. 1h, 24h, 7d, 2w, 1w3d12h)
</flags>

<output>json outputs the whole envelope {results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=popular header line then one event=result line per record.</output>

<output-example format="json">
{
  "results": [
    {
      "by": "tosh",
      "descendants": 312,
      "id": 47820551,
      "score": 934,
      "time": 1734691200,
      "title": "Show HN: I built a local-first sync engine in Rust",
      "type": "story",
      "url": "https://github.com/tosh/syncwave"
    }
  ]
}
</output-example>

<examples-good>
- clor social hn popular list    # default 24h window, top 50 stories
- clor social hn popular list --window 7d --limit 200    # top 200 over the past week
- clor social hn popular list --window 2w    # past 2 weeks; --window also accepts s/m/h/d/w combinations
- clor social hn popular list --tags comment --min-score 50 --stdout-format jsonl    # popular comments only
- clor social hn popular list --window 1h --stdout-format json | jq '.results[] | {title, url, score}'    # trending in the last hour as JSON
</examples-good>

<examples-bad>
- clor social hn popular list --window 24    # needs a unit (use 24h)
- clor social hn popular list --window 1y    # calendar units not supported; use 12mo-equivalent (use weeks/days)
- clor social hn popular list --limit 500    # max --limit is 200
- clor social hn popular list --stdout-format yaml    # only text, jsonl, or json supported
</examples-bad>
</help>


<help command="clor social hn search">
<summary>Search Hacker News items by free text, tags, author, time window, or score floor</summary>
<description>Returns id, title, url, by, score, comment count, timestamp. Pass
an id to `social hn item` for full content.</description>
<usage>clor social hn search [QUERY] [flags]</usage>

<flags>
- --author string: exact match on the `by` field
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: id*,type*,by*,time*,title*,url*,score*,descendants*,text,parent,poll,dead,deleted,crawled,story_id*,story_title*,story_score*,story_url* (* = default)
- --from string: lower bound on item time (Unix seconds, RFC3339, or relative like 24h or 7d)
- --limit int: max results (1-100) (default "20")
- --min-comments int: filter descendants >= N
- --min-score int: filter score >= N
- --offset int: skip the first N results (pagination)
- --sort string: sort order (date|score|relevance); relevance requires a query
- --tags string: comma-separated subset (story|comment|job|poll|pollopt)
- --until string: upper bound on item time (same formats as --from)
</flags>

<output>json outputs the whole envelope {results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "results": [
    {
      "by": "steveklabnik",
      "descendants": 243,
      "id": 47512004,
      "score": 587,
      "time": 1736424000,
      "title": "Rust 1.84.0 is released",
      "type": "story",
      "url": "https://blog.rust-lang.org/2026/01/09/Rust-1.84.0.html"
    }
  ]
}
</output-example>

<examples-good>
- clor social hn search "rust"    # free-text search across story titles and bodies
- clor social hn search "postgres" --from 7d --sort score    # past week, ordered by score
- clor social hn search --tags story --author dang --min-score 100    # filter-only, no free-text query
- clor social hn search "kubernetes" --limit 50 --stdout-format jsonl | jq -c 'select(.event=="result") | {id, title}'    # JSONL piped through jq
- clor social hn search "embedding" --stdout-format json | jq '.results[].url'    # single-object JSON, extract URLs
- clor social hn search "ai" --fields title,url,score    # render only chosen fields
- clor social hn search "ai" --fields default,text    # defaults plus the body text
</examples-good>

<examples-bad>
- clor social hn search --sort relevance    # relevance requires a query argument
- clor social hn search "x" --limit 500    # max --limit is 100
- clor social hn search "x" --stdout-format yaml    # only text, jsonl, or json supported
- clor social hn search "x" --fields foo    # unknown field name
</examples-bad>
</help>


<help command="clor social hn timing">
<summary>Analyze HN historical posting-time outcomes by day-of-week and hour-of-day</summary>
<usage>clor social hn timing</usage>

<uses>
- the user wants to know when posts about a topic perform best on HN (day-of-week, hour-of-day)
</uses>

<subcommands>
- show: Render the day-of-week x hour-of-day timing matrix for HN posts (--metric count|median_score)
</subcommands>
</help>


<help command="clor social hn timing show">
<summary>Render the day-of-week x hour-of-day timing matrix for HN posts (--metric count|median_score)</summary>
<description>Returns a 7x24 matrix aggregating HN items by day-of-week and
hour-of-day. Narrow with --query, --domain, --type, or --min-score.</description>
<usage>clor social hn timing show [flags]</usage>

<flags>
- --domain string: filter to a single host (e.g. github.com)
- --from string: lower bound on item time (Unix seconds, RFC3339, or relative like 24h or 7d) (default "2y")
- --min-score int: filter score >= N before bucketing
- --query string: free-text filter applied to title and body
- --type string: item type (story|comment|job|poll|pollopt)
- --until string: upper bound on item time (same formats as --from)
</flags>

<output>json outputs the whole envelope {buckets[]}. jsonl outputs each record from buckets on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "buckets": [
    {
      "count": 8421,
      "day_of_week": 1,
      "frontpage_count": 214,
      "hour": 15,
      "median_score": 12,
      "p90_score": 96
    },
    {
      "count": 9037,
      "day_of_week": 2,
      "frontpage_count": 251,
      "hour": 16,
      "median_score": 14,
      "p90_score": 108
    }
  ]
}
</output-example>

<examples-good>
- clor social hn timing show    # best time to post on HN, all stories, all time
- clor social hn timing show --query "rust" --from 2y    # best time to post Rust stories over the past two years
- clor social hn timing show --domain github.com --stdout-format json | jq '[.buckets[] | {day_of_week, hour, p90_score}] | sort_by(-.p90_score) | .[0:5]'    # top 5 posting slots for github.com by p90 score
- clor social hn timing show --min-score 50 --stdout-format jsonl | grep '^{' | jq -c 'select(.event=="bucket") | {day_of_week, hour, count}'    # JSONL piped through jq
</examples-good>

<examples-bad>
- clor social hn timing show --type article    # type must be story|comment|job|poll|pollopt
- clor social hn timing show --from yesterday    # use Unix seconds, RFC3339, or a duration like 24h or 7d
- clor social hn timing show --stdout-format yaml    # only text, jsonl, or json supported
</examples-bad>
</help>


<help command="clor social hn trend">
<summary>Track how a topic has trended on Hacker News over time (volume and score distribution)</summary>
<usage>clor social hn trend</usage>

<uses>
- the user wants to see how attention to a topic has moved on HN over time (volume and score distribution)
</uses>

<subcommands>
- list: Return per-bucket time series (count + score distribution) for HN items matching a query
</subcommands>
</help>


<help command="clor social hn trend list">
<summary>Return per-bucket time series (count + score distribution) for HN items matching a query</summary>
<description>Each row carries a bucket timestamp, item count, and score
percentiles (p50, p90, etc). --bucket sets the grain (day|week|month).</description>
<usage>clor social hn trend list [flags]</usage>

<flags>
- --bucket string: time grain (day|week|month)
- --domain string: filter to a single host (e.g. github.com)
- --from string: lower bound on item time (Unix seconds, RFC3339, or relative like 24h or 7d) (default "2y")
- --query string: free-text filter applied to title and body
- --type string: item type (story|comment|job|poll|pollopt)
- --until string: upper bound on item time (same formats as --from)
</flags>

<output>json outputs the whole envelope {buckets[]}. jsonl outputs each record from buckets on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "buckets": [
    {
      "avg_score": 47.2,
      "bucket_start": 1727740800,
      "count": 1840,
      "p90_score": 162
    },
    {
      "avg_score": 51.6,
      "bucket_start": 1730419200,
      "count": 2103,
      "p90_score": 188
    }
  ]
}
</output-example>

<examples-good>
- clor social hn trend list --query "rust" --bucket month    # Rust mention volume by month over the default window
- clor social hn trend list --domain openai.com --bucket week --from 2y    # openai.com submissions per week over the past two years
- clor social hn trend list --type comment --bucket day --from 30d --stdout-format json | jq '.buckets[] | {bucket_start, count}'    # daily comment volume in the last 30 days
- clor social hn trend list --query "kubernetes" --stdout-format jsonl    # JSONL stream of monthly Kubernetes story volume
</examples-good>

<examples-bad>
- clor social hn trend list --bucket year    # bucket must be day, week, or month
- clor social hn trend list --type article    # type must be story|comment|job|poll|pollopt
- clor social hn trend list --stdout-format yaml    # only text, jsonl, or json supported
</examples-bad>
</help>

<help command="clor social yc">
<summary>Search Y Combinator companies and founders by text, batch, industry, region, tag, status, or slug</summary>
<description>The YC directory as a queryable index. Full-text search and
filter ~6k companies by batch, status, industry, tag, and team size, and
~13k founders by batch, industry, region, and current company. Show pulls
the full joined record.</description>
<usage>clor social yc</usage>

<uses>
- the user wants to find YC companies matching a topic, batch, or industry
- the user wants the full record for one YC company including its founders
- the user wants to find YC founders by name, batch, region, or company
- the user wants one founder's profile plus their current company
</uses>

<subcommands>
- company: Search Y Combinator companies by text, batch, industry, tag, status, or team size, or show one by slug
- founder: Search Y Combinator founders by text, batch, industry, region, or current company, or show one by slug
</subcommands>

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</output>
</help>


<help command="clor social yc company">
<summary>Search Y Combinator companies by text, batch, industry, tag, status, or team size, or show one by slug</summary>
<description>Search and filter the YC company index, or show one company by
slug with its canonical founder list.</description>
<usage>clor social yc company</usage>

<uses>
- the user wants to find YC companies by topic, batch, industry, tag, status, or team size
- the user has a company slug and wants its full record plus founder list
</uses>

<subcommands>
- search: Search Y Combinator companies by text, batch, industry, tag, status, or team size
- show: Show one Y Combinator company by slug with its founder list
</subcommands>

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</output>
</help>


<help command="clor social yc company search">
<summary>Search Y Combinator companies by text, batch, industry, tag, status, or team size</summary>
<description>Returns slug, name, one-liner, batch, status, team size, and
industry. Pass a slug to `social yc company show` for the full
record. With no query the result is a browseable listing.</description>
<usage>clor social yc company search [QUERY] [flags]</usage>

<flags>
- --batch string: exact YC company batch name, not a founder batch code (e.g. "Winter 2023", not W23)
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: id,slug*,name*,one_liner*,batch*,status*,stage,team_size*,industry*,subindustry,website*,all_locations,launched,founder_count*,is_hiring,nonprofit,top_company*,regions,industries,tags,former_names,long_description,directory_url,small_logo_thumbnail_url (* = default)
- --hiring bool: restrict to companies that are hiring
- --industry string: exact match on the primary industry
- --limit int: max results (1-200) (default "20")
- --min-team-size int: restrict to team size >= N
- --nonprofit bool: restrict to nonprofits
- --offset int: skip the first N results (pagination)
- --sort string: sort order (team_size|batch|relevance); relevance requires a query
- --stage string: exact match on stage
- --status string: exact match on status (Active|Inactive|Acquired|Public)
- --tag string: exact match on a company tag, quote multi-word values (e.g. "Developer Tools")
- --top bool: restrict to YC top companies
</flags>

<output>json outputs the whole envelope {results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "results": [
    {
      "batch": "Summer 2009",
      "founder_count": 2,
      "id": 1594,
      "industry": "Fintech",
      "is_hiring": true,
      "name": "Stripe",
      "nonprofit": false,
      "one_liner": "Economic infrastructure for the internet",
      "slug": "stripe",
      "status": "Active",
      "tags": [
        "Fintech",
        "Payments",
        "SaaS"
      ],
      "team_size": 8000,
      "top_company": true,
      "website": "https://stripe.com"
    }
  ]
}
</output-example>

<examples-good>
- clor social yc company search "fintech"    # free-text search across name and descriptions
- clor social yc company search "payments" --batch "Winter 2023" --sort relevance    # one batch, ranked by relevance
- clor social yc company search --tag Fintech --top --min-team-size 100    # filter-only, no free-text query
- clor social yc company search "ai" --sort team_size --stdout-format json | jq '.results[].slug'    # single-object JSON, extract slugs
- clor social yc company search "devtools" --stdout-format jsonl | jq -c 'select(.event=="result") | {slug, name}'    # JSONL piped through jq
- clor social yc company search "climate" --fields slug,name,tags    # render only chosen fields
</examples-good>

<examples-bad>
- clor social yc company search --sort relevance    # relevance requires a query argument
- clor social yc company search --batch W23    # company --batch expects a full batch name like "Winter 2023"
- clor social yc company search "x" --limit 500    # max --limit is 200
- clor social yc company search "x" --stdout-format yaml    # only text, jsonl, or json supported
- clor social yc company search "x" --sort score    # sort must be team_size, batch, or relevance
</examples-bad>
</help>


<help command="clor social yc company show">
<summary>Show one Y Combinator company by slug with its founder list</summary>
<description>Returns the full company record plus YC's canonical founder
list, one event=founder depth=1 line per founder.</description>
<usage>clor social yc company show <SLUG></usage>

<output>json outputs the whole envelope {company, founders[]} with founders nested under the company. text and jsonl flatten to a company header followed by one event=founder depth=1 line per founder; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "company": {
    "batch": "Summer 2009",
    "founder_count": 2,
    "id": 1594,
    "industry": "Fintech",
    "is_hiring": true,
    "name": "Stripe",
    "nonprofit": false,
    "one_liner": "Economic infrastructure for the internet",
    "slug": "stripe",
    "status": "Active",
    "tags": [
      "Fintech",
      "Payments",
      "SaaS"
    ],
    "team_size": 8000,
    "top_company": true,
    "website": "https://stripe.com"
  },
  "founders": [
    {
      "full_name": "Patrick Collison",
      "hacker_news_username": "patrickc",
      "title": "CEO",
      "url_slug": "patrick-collison",
      "yc_id": 312
    },
    {
      "full_name": "John Collison",
      "title": "President",
      "url_slug": "john-collison",
      "yc_id": 313
    }
  ]
}
</output-example>

<examples-good>
- clor social yc company show stripe    # full record plus founders, as logfmt
- clor social yc company show stripe --stdout-format json | jq '.founders[].full_name'    # extract founder names via JSON
- clor social yc company show airbnb --stdout-format jsonl | jq -c 'select(.event=="founder")'    # JSONL filtered to founders
</examples-good>

<examples-bad>
- clor social yc company show    # a slug argument is required
- clor social yc company show "Stripe Inc"    # expects the directory slug, not the display name
</examples-bad>
</help>


<help command="clor social yc founder">
<summary>Search Y Combinator founders by text, batch, industry, region, or current company, or show one by slug</summary>
<description>Search and filter the YC founder index, or show one founder by
slug with their current company.</description>
<usage>clor social yc founder</usage>

<uses>
- the user wants to find YC founders by name, batch, industry, region, or current company
- the user has a founder slug and wants their full profile plus current company
</uses>

<subcommands>
- search: Search Y Combinator founders by text, batch, industry, region, or current company
- show: Show one Y Combinator founder by slug with their current company
</subcommands>

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</output>
</help>


<help command="clor social yc founder search">
<summary>Search Y Combinator founders by text, batch, industry, region, or current company</summary>
<description>Returns url slug, full name, current title, current company, and
region. Pass a slug to `social yc founder show` for the full
record. With no query the result is a browseable listing.</description>
<usage>clor social yc founder search [QUERY] [flags]</usage>

<flags>
- --batch string: exact YC founder batch code, not a company batch name (e.g. W23, not "Winter 2023")
- --company string: match founders whose current company slug equals this value, not the display name
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: id,url_slug*,full_name*,first_name,last_name,current_title*,current_company_name*,current_company_slug*,current_region*,hacker_news_username,top_company*,batches*,titles,parent_industries,subindustries,all_companies_text,avatar_thumbnail_url,email*,phone* (* = default)
- --industry string: match founders in this parent industry
- --limit int: max results (1-200) (default "20")
- --offset int: skip the first N results (pagination)
- --region string: exact match on the founder's current region, quote multi-word values (e.g. "United States of America")
- --sort string: sort order (name|relevance); relevance requires a query
- --top bool: restrict to founders of YC top companies
</flags>

<output>json outputs the whole envelope {results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "results": [
    {
      "batches": [
        "S09"
      ],
      "current_company_name": "Stripe",
      "current_company_slug": "stripe",
      "current_region": "United States of America",
      "current_title": "CEO",
      "full_name": "Patrick Collison",
      "id": 312,
      "top_company": true,
      "url_slug": "patrick-collison"
    }
  ]
}
</output-example>

<examples-good>
- clor social yc founder search "rust"    # free-text search across name and company
- clor social yc founder search "machine learning" --region France --sort relevance    # one region, ranked by relevance
- clor social yc founder search --batch W23 --industry Fintech    # filter-only, no free-text query
- clor social yc founder search "payments" --company stripe --stdout-format json | jq '.results[].full_name'    # single-object JSON, extract names
- clor social yc founder search "ai" --stdout-format jsonl | jq -c 'select(.event=="result") | {url_slug, full_name}'    # JSONL piped through jq
- clor social yc founder search "design" --fields full_name,current_company_name    # render only chosen fields
</examples-good>

<examples-bad>
- clor social yc founder search --sort relevance    # relevance requires a query argument
- clor social yc founder search --batch "Winter 2023"    # founder --batch expects a batch code like W23
- clor social yc founder search "x" --limit 500    # max --limit is 200
- clor social yc founder search "x" --sort batch    # sort must be name or relevance
</examples-bad>
</help>


<help command="clor social yc founder show">
<summary>Show one Y Combinator founder by slug with their current company</summary>
<description>Returns the full founder record plus their current company,
resolved by company slug, as an event=company depth=1 line.</description>
<usage>clor social yc founder show <SLUG></usage>

<output>json outputs the whole envelope {founder, company} with the company nested under the founder. text and jsonl flatten to a founder header followed by an event=company depth=1 line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "company": {
    "batch": "Summer 2009",
    "founder_count": 2,
    "id": 1594,
    "industry": "Fintech",
    "is_hiring": false,
    "name": "Stripe",
    "nonprofit": false,
    "one_liner": "Economic infrastructure for the internet",
    "slug": "stripe",
    "status": "Active",
    "team_size": 8000,
    "top_company": true
  },
  "founder": {
    "batches": [
      "S09"
    ],
    "current_company_name": "Stripe",
    "current_company_slug": "stripe",
    "current_region": "United States of America",
    "current_title": "CEO",
    "full_name": "Patrick Collison",
    "hacker_news_username": "patrickc",
    "id": 312,
    "top_company": true,
    "url_slug": "patrick-collison"
  }
}
</output-example>

<examples-good>
- clor social yc founder show patrick-collison    # full record plus current company, as logfmt
- clor social yc founder show patrick-collison --stdout-format json | jq '{name: .founder.full_name, company: .company.slug}'    # join founder and company via JSON
- clor social yc founder show patrick-collison --stdout-format jsonl | jq -c 'select(.event=="company")'    # JSONL filtered to the company line
</examples-good>

<examples-bad>
- clor social yc founder show    # a slug argument is required
- clor social yc founder show "Patrick Collison"    # expects the profile slug, not the display name
</examples-bad>
</help>

## HN Guidelines

### What to Submit

On-Topic: Anything that good hackers would find interesting. That includes more than hacking and startups. If you had to reduce it to a sentence, the answer might be: anything that gratifies one's intellectual curiosity.

Off-Topic: Most stories about politics, or crime, or sports, or celebrities, unless they're evidence of some interesting new phenomenon. If they'd cover it on TV news, it's probably off-topic.

### In Submissions

Please don't do things to make titles stand out, like using uppercase or exclamation points, or saying how great an article is.

Please submit the original source. If a post reports on something found on another site, submit the latter.

Please don't use HN primarily for promotion. It's ok to post your own stuff part of the time, but the primary use of the site should be for curiosity.

If the title includes the name of the site, please take it out, because the site name will be displayed after the link.

If the title contains a gratuitous number or number + adjective, we'd appreciate it if you'd crop it. E.g. translate "10 Ways To Do X" to "How To Do X," and "14 Amazing Ys" to "Ys." Exception: when the number is meaningful, e.g. "The 5 Platonic Solids."

Otherwise please use the original title, unless it is misleading or linkbait; don't editorialize.

If you submit a video or pdf, please warn us by appending [video] or [pdf] to the title.

Please don't post on HN to ask or tell us something. Send it to hn@ycombinator.com.

Please don't delete and repost. Deletion is for things that shouldn't have been submitted in the first place.

Don't solicit upvotes, comments, or submissions. Users should vote and comment when they run across something they personally find interesting—not for promotion.

### In Comments

Be kind. Don't be snarky. Converse curiously; don't cross-examine. Edit out swipes.

Comments should get more thoughtful and substantive, not less, as a topic gets more divisive.

When disagreeing, please reply to the argument instead of calling names. "That is idiotic; 1 + 1 is 2, not 3" can be shortened to "1 + 1 is 2, not 3."

Don't be curmudgeonly. Thoughtful criticism is fine, but please don't be rigidly or generically negative.

Don't post generated text or AI-edited text. HN is for conversation between humans.

Please don't fulminate. Please don't sneer, including at the rest of the community.

Please respond to the strongest plausible interpretation of what someone says, not a weaker one that's easier to criticize. Assume good faith.

Eschew flamebait. Avoid generic tangents. Omit internet tropes.

Please don't post shallow dismissals, especially of other people's work. A good critical comment teaches us something.

Please don't use Hacker News for political or ideological battle. It tramples curiosity.

Please don't comment on whether someone read an article. "Did you even read the article? It mentions that" can be shortened to "The article mentions that".

Please don't pick the most provocative thing in an article or post to complain about in the thread. Find something interesting to respond to instead.

Throwaway accounts are ok for sensitive information, but please don't create accounts routinely. HN is a community—users should have an identity that others can relate to.

Please don't use uppercase for emphasis. Instead, put *asterisks* around it and it will get italicized. More formatting info here.

Please don't post insinuations about astroturfing, shilling, brigading, foreign agents, and the like. It degrades discussion and is usually mistaken. If you're worried about abuse, email hn@ycombinator.com and we'll look at the data.

If a story is spam or off-topic, flag it. Don't feed egregious comments by replying; flag them instead. If you flag, please don't also comment that you did.

Please don't complain about tangential annoyances—e.g. article or website formats, name collisions, or back-button breakage. They're too common to be interesting.

Please don't comment about the voting on comments. It never does any good, and it makes boring reading.

Please don't post comments saying that HN is turning into Reddit. It's a semi-noob illusion, as old as the hills.

Latest: https://news.ycombinator.com/newsguidelines.html


## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

