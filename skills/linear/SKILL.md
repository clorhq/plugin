---
name: linear
description: Linear workspace management for issues, projects, cycles, initiatives, documents, comments, and milestones. Use when the user wants to inspect or change work in Linear, triage issues, manage product plans, or post project progress.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Working with Linear

Use typed `clor linear` commands first. They resolve workspace references exactly, normalize output, and protect recoverable deletion behavior. Use `clor linear graphql` only when the typed command tree does not cover the operation.

Authentication comes from a connected Linear workspace. When several are connected, pass the persistent `--connection <ID>` flag using an ID from `clor connection list`. A trimmed `LINEAR_ACCESS_TOKEN` can replace connected authentication for a single process, but it cannot be combined with `--connection` and is never saved.

References accept Linear IDs and URLs. Issues also accept canonical identifiers such as `ENG-482`; teams accept keys; users accept email or `me`; named resources require an exact case-insensitive match. Pass a team or project scope when names could be shared.

`issue delete` moves an issue to Linear's recoverable trash. It does not expose permanent deletion. Project deletion is also recoverable with `project unarchive`.

## Common examples

```bash
clor linear issue list --team ENG --assignee me --stdout-format json
clor linear issue create "Ship workspace audit log" --team ENG --priority high --assignee me
clor linear project progress create "Workspace audit log" --body-file update.md --health on-track
clor linear initiative project add INI-31 "Workspace audit log"
```

Typed JSON uses normalized snake-case fields. A successful issue list can look like this.

```json
{
  "issues": [
    {
      "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
      "identifier": "ENG-482",
      "title": "Ship workspace audit log",
      "priority": 2,
      "state": {"name": "In Progress"},
      "created": "2026-07-18T09:30:00Z",
      "updated": "2026-07-21T11:45:00Z"
    }
  },
  "cursor": "2f07f96a"
}
```

## Linear reference

<help command="clor linear">
<summary>Read and update Linear issues, projects, cycles, initiatives, documents, and workspace records</summary>
<description>Direct Linear workspace access through GraphQL. Typed commands cover
the common developer and product-management workflow; graphql handles uncommon
operations without changing the normalized output contract of typed commands.

Use it when
  - issues, comments, relations, labels, states, or attachments need to be read or changed
  - projects, progress updates, milestones, cycles, or initiatives need to be managed
  - workspace users, teams, or documents need to be queried

Subcommands
  whoami     Show the authenticated Linear user
  search     Search issues, projects, or documents
  issue      Read and change issues, comments, and relations
  project    Read and change projects, progress updates, and milestones
  cycle      Read and change cycles
  initiative Read and change initiatives and their projects
  document   Read and change documents
  attachment Read and change issue attachments
  team       List and show teams
  user       List and show users
  state      List and show workflow states
  label      Read and change issue labels
  graphql    Run a named GraphQL operation directly

Output formats

Every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor linear [flags]</usage>

<uses>
- the user asks to read or change Linear product and engineering work
- an uncommon Linear API operation needs a direct GraphQL escape hatch
</uses>

<rules>
- use typed subcommands before graphql so references and output stay normalized
- LINEAR_ACCESS_TOKEN and --connection are mutually exclusive
- issue deletion is recoverable; permanent deletion is not exposed
</rules>

<subcommands>
- attachment: Read and change Linear issue attachments
- cycle: Read and change Linear team cycles
- document: Read and change Linear Markdown documents
- graphql: Run an uncommon Linear GraphQL operation directly
- initiative: Read and change Linear initiatives and their projects
- issue: Read and change Linear issues, comments, and relations
- label: Read and change Linear issue labels
- project: Read and change Linear projects, progress updates, and milestones
- search: Search Linear issues, projects, or documents
- state: List and show Linear workflow states
- team: List and show Linear teams
- user: List and show Linear workspace users
- whoami: Show the authenticated Linear user
</subcommands>

<flags>
- --connection string: connection ID when several Linear workspaces are connected
- --help bool: help for linear
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


<help command="clor linear attachment">
<summary>Read and change Linear issue attachments</summary>
<usage>clor linear attachment</usage>

<uses>
- the user needs Linear attachment records
</uses>

<subcommands>
- create: Create a linked issue attachment
- delete: Delete an issue attachment
- list: List workspace attachments or attachments on one issue
- show: Show one attachment
- update: Update an issue attachment
</subcommands>
</help>


<help command="clor linear attachment create">
<summary>Create a linked issue attachment</summary>
<usage>clor linear attachment create <ISSUE> <URL> [flags]</usage>

<flags>
- --comment-body string: Markdown linked-comment body
- --comment-body-file string: file containing the Markdown linked-comment body, or - for stdin
- --icon-url string: attachment icon URL
- --metadata string: attachment metadata as a JSON object
- --subtitle string: attachment subtitle
- --title string: attachment title
</flags>

<output>text and jsonl emit one event=attachment record; json returns the normalized attachment</output>

<output-example format="json">
{
  "id": "0197b6c7-d8e9-7f34-a567-89abcdef0123",
  "issue": {
    "identifier": "ENG-482"
  },
  "title": "Design specification",
  "url": "https://docs.example.com/audit-log"
}
</output-example>

<examples-good>
- clor linear attachment create ENG-482 https://docs.example.com/audit-log --title "Design specification"    # attachment title and URL
- clor linear attachment create ENG-482 https://docs.example.com/audit-log --title "Design specification" --stdout-format json | jq .id    # normalized JSON
- clor linear attachment create ENG-482 https://docs.example.com/audit-log --title "Design specification" --subtitle "Architecture review" | grep '^event=attachment '    # subtitle in default output
</examples-good>

<examples-bad>
- clor linear attachment create    # an issue, URL, and --title are required
- clor linear attachment create ENG-482 https://docs.example.com/audit-log    # --title is required
</examples-bad>
</help>


<help command="clor linear attachment delete">
<summary>Delete an issue attachment</summary>
<usage>clor linear attachment delete <ATTACHMENT></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197b6c7-d8e9-7f34-a567-89abcdef0123",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear attachment delete "Design specification"    # act on an exact reference
- clor linear attachment delete 0197b6c7-d8e9-7f34-a567-89abcdef0123 --stdout-format json | jq .success    # check the action result
- clor linear attachment delete "Design specification" | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear attachment delete    # a resource reference is required
- clor linear attachment delete approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear attachment list">
<summary>List workspace attachments or attachments on one issue</summary>
<usage>clor linear attachment list [ISSUE] [flags]</usage>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit one event=attachment record; json returns {attachments, cursor?}</output>

<output-example format="json">
{
  "attachments": [
    {
      "id": "0197b6c7-d8e9-7f34-a567-89abcdef0123",
      "issue": {
        "identifier": "ENG-482"
      },
      "title": "Design specification",
      "url": "https://docs.example.com/audit-log"
    }
  ]
}
</output-example>

<examples-good>
- clor linear attachment list ENG-482    # attachments on one issue
- clor linear attachment list ENG-482 --stdout-format json | jq '.attachments[].url'    # attachment URLs as JSON
- clor linear attachment list | grep '^event=attachment '    # workspace attachments
</examples-good>

<examples-bad>
- clor linear attachment list ENG-482 extra    # at most one issue reference is accepted
- clor linear attachment list --limit 0    # limit must be positive
</examples-bad>
</help>


<help command="clor linear attachment show">
<summary>Show one attachment</summary>
<usage>clor linear attachment show <ATTACHMENT></usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<output>text and jsonl emit concise event=attachment records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "id": "0197b6c7-d8e9-7f34-a567-89abcdef0123",
  "issue": {
    "identifier": "ENG-482"
  },
  "title": "Design specification",
  "url": "https://docs.example.com/audit-log"
}
</output-example>

<examples-good>
- clor linear attachment show "Design specification"    # typed attachment output
- clor linear attachment show "Design specification" --stdout-format json | jq .    # normalized JSON output
- clor linear attachment show "Design specification" | grep '^event=attachment '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear attachment show approximate    # names must match exactly
- clor linear attachment show    # a reference is required
</examples-bad>
</help>


<help command="clor linear attachment update">
<summary>Update an issue attachment</summary>
<usage>clor linear attachment update <ATTACHMENT> [flags]</usage>

<flags>
- --clear-icon-url bool: clear the icon URL
- --clear-metadata bool: clear the metadata
- --clear-subtitle bool: clear the subtitle
- --icon-url string: attachment icon URL
- --metadata string: attachment metadata as a JSON object
- --subtitle string: attachment subtitle
- --title string: new attachment title
</flags>

<output>text and jsonl emit one event=attachment record; json returns the normalized attachment</output>

<output-example format="json">
{
  "id": "0197b6c7-d8e9-7f34-a567-89abcdef0123",
  "issue": {
    "identifier": "ENG-482"
  },
  "title": "Design specification",
  "url": "https://docs.example.com/audit-log"
}
</output-example>

<examples-good>
- clor linear attachment update 0197b6c7-d8e9-7f34-a567-89abcdef0123 --title "Updated design specification"    # attachment title and URL
- clor linear attachment update 0197b6c7-d8e9-7f34-a567-89abcdef0123 --title "Updated design specification" --stdout-format json | jq .id    # normalized JSON
- clor linear attachment update 0197b6c7-d8e9-7f34-a567-89abcdef0123 --title "Updated design specification" --subtitle "Architecture review" | grep '^event=attachment '    # subtitle in default output
</examples-good>

<examples-bad>
- clor linear attachment update    # an attachment reference is required
- clor linear attachment update 0197b6c7-d8e9-7f34-a567-89abcdef0123 --subtitle text --clear-subtitle    # a field cannot be set and cleared together
</examples-bad>
</help>

<help command="clor linear cycle">
<summary>Read and change Linear team cycles</summary>
<usage>clor linear cycle</usage>

<uses>
- the user needs Linear cycle records
</uses>

<subcommands>
- archive: Archive a cycle
- create: Create a cycle for a team
- list: List cycles
- show: Show one cycle
- update: Update cycle dates and details
</subcommands>
</help>


<help command="clor linear cycle archive">
<summary>Archive a cycle</summary>
<usage>clor linear cycle archive <CYCLE> [flags]</usage>

<rules>
- names match exactly and --team disambiguates cycles with the same name
</rules>

<flags>
- --team string: team ID, URL, key, or exact name used to disambiguate
</flags>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197e3f4-a5b6-7c01-d234-56789abcdef0",
  "action": "archive",
  "success": true
}
</output-example>

<examples-good>
- clor linear cycle archive "Cycle 42" --team ENG    # team-scoped cycle name
- clor linear cycle archive 0197e3f4-a5b6-7c01-d234-56789abcdef0 --stdout-format json | jq .success    # archive by ID and check success
- clor linear cycle archive "Cycle 42" --team ENG | grep '^event=action '    # default logfmt
</examples-good>

<examples-bad>
- clor linear cycle archive    # a cycle reference is required
- clor linear cycle archive approximate    # names must match exactly
</examples-bad>
</help>


<help command="clor linear cycle create">
<summary>Create a cycle for a team</summary>
<usage>clor linear cycle create [flags]</usage>

<rules>
- cycle times use RFC3339 with an explicit timezone
</rules>

<flags>
- --description string: cycle description
- --ends string: cycle end time (RFC3339)
- --name string: custom cycle name
- --starts string: cycle start time (RFC3339)
- --team string: team ID, URL, key, or exact name
</flags>

<output>text and jsonl emit one event=cycle record; json returns the normalized cycle</output>

<output-example format="json">
{
  "ends": "2026-08-03T00:00:00Z",
  "id": "0197e3f4-a5b6-7c01-d234-56789abcdef0",
  "name": "Cycle 42",
  "number": 42,
  "starts": "2026-07-20T00:00:00Z",
  "team": {
    "key": "ENG",
    "name": "Engineering"
  }
}
</output-example>

<examples-good>
- clor linear cycle create --team ENG --starts 2026-07-20T00:00:00Z --ends 2026-08-03T00:00:00Z    # team and cycle interval
- clor linear cycle create --team ENG --starts 2026-07-20T00:00:00Z --ends 2026-08-03T00:00:00Z --name "Cycle 42" --stdout-format json | jq .id    # custom name and JSON
- clor linear cycle create --team ENG --starts 2026-07-20T00:00:00Z --ends 2026-08-03T00:00:00Z --description "Audit log delivery" | grep '^event=cycle '    # default logfmt
</examples-good>

<examples-bad>
- clor linear cycle create --team ENG --starts 2026-07-20 --ends 2026-08-03T00:00:00Z    # cycle times use RFC3339
- clor linear cycle create --team ENG    # start and end times are required
</examples-bad>
</help>


<help command="clor linear cycle list">
<summary>List cycles</summary>
<usage>clor linear cycle list [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
- --team string: team ID, URL, key, or exact name
</flags>

<output>text and jsonl emit concise event=cycle records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "cycles": [
    {
      "ends": "2026-08-03T00:00:00Z",
      "id": "0197e3f4-a5b6-7c01-d234-56789abcdef0",
      "name": "Cycle 42",
      "number": 42,
      "starts": "2026-07-20T00:00:00Z",
      "team": {
        "key": "ENG",
        "name": "Engineering"
      }
    }
  ]
}
</output-example>

<examples-good>
- clor linear cycle list    # typed cycle output
- clor linear cycle list --stdout-format json | jq .    # normalized JSON output
- clor linear cycle list | grep '^event=cycle '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear cycle list approximate    # names must match exactly
- clor linear cycle list --limit 0    # limits must be positive
</examples-bad>
</help>


<help command="clor linear cycle show">
<summary>Show one cycle</summary>
<usage>clor linear cycle show <CYCLE> [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --team string: team ID, URL, key, or exact name used to disambiguate
</flags>

<output>text and jsonl emit concise event=cycle records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "ends": "2026-08-03T00:00:00Z",
  "id": "0197e3f4-a5b6-7c01-d234-56789abcdef0",
  "name": "Cycle 42",
  "number": 42,
  "starts": "2026-07-20T00:00:00Z",
  "team": {
    "key": "ENG",
    "name": "Engineering"
  }
}
</output-example>

<examples-good>
- clor linear cycle show "Cycle 42"    # typed cycle output
- clor linear cycle show "Cycle 42" --stdout-format json | jq .    # normalized JSON output
- clor linear cycle show "Cycle 42" | grep '^event=cycle '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear cycle show approximate    # names must match exactly
- clor linear cycle show    # a reference is required
</examples-bad>
</help>


<help command="clor linear cycle update">
<summary>Update cycle dates and details</summary>
<usage>clor linear cycle update <CYCLE> [flags]</usage>

<rules>
- cycle times use RFC3339 with an explicit timezone
</rules>

<flags>
- --clear-completed bool: clear the completion time
- --clear-description bool: clear the description
- --clear-name bool: clear the custom name
- --completed string: cycle completion time (RFC3339)
- --description string: cycle description
- --ends string: cycle end time (RFC3339)
- --name string: custom cycle name
- --starts string: cycle start time (RFC3339)
- --team string: team ID, URL, key, or exact name used to disambiguate
</flags>

<output>text and jsonl emit one event=cycle record; json returns the normalized cycle</output>

<output-example format="json">
{
  "ends": "2026-08-03T00:00:00Z",
  "id": "0197e3f4-a5b6-7c01-d234-56789abcdef0",
  "name": "Cycle 42",
  "number": 42,
  "starts": "2026-07-20T00:00:00Z",
  "team": {
    "key": "ENG",
    "name": "Engineering"
  }
}
</output-example>

<examples-good>
- clor linear cycle update "Cycle 42" --team ENG --ends 2026-08-04T00:00:00Z    # team-scoped cycle date
- clor linear cycle update "Cycle 42" --team ENG --name "Cycle 42 delivery" --stdout-format json | jq .id    # custom name and JSON
- clor linear cycle update "Cycle 42" --team ENG --description "Audit log delivery" | grep '^event=cycle '    # default logfmt
</examples-good>

<examples-bad>
- clor linear cycle update "Cycle 42" --team ENG --starts 2026-07-20    # cycle times use RFC3339
- clor linear cycle update "Cycle 42" --name Sprint --clear-name    # a field cannot be set and cleared together
</examples-bad>
</help>

<help command="clor linear document">
<summary>Read and change Linear Markdown documents</summary>
<usage>clor linear document</usage>

<uses>
- the user needs Linear document records
</uses>

<subcommands>
- create: Create a Markdown document
- delete: Move a document to recoverable trash
- list: List documents
- show: Show one document
- unarchive: Restore a trashed document
- update: Update a document with explicit clear operations
</subcommands>
</help>


<help command="clor linear document create">
<summary>Create a Markdown document</summary>
<usage>clor linear document create <TITLE> [flags]</usage>

<rules>
- Markdown can be inline or read from --content-file; - reads stdin
- related resources use exact references
</rules>

<flags>
- --color string: document icon color
- --content string: Markdown document content
- --content-file string: file containing Markdown document content, or - for stdin
- --cycle string: related cycle ID, URL, or exact name
- --icon string: document icon
- --initiative string: related initiative ID, URL, identifier, or exact name
- --issue string: related issue ID, URL, or identifier
- --project string: related project ID, URL, or exact name
- --team string: related team ID, URL, key, or exact name
</flags>

<output>text and jsonl emit one event=document record; json returns the normalized document</output>

<output-example format="json">
{
  "id": "0197a5b6-c7d8-7e23-f456-789abcdef012",
  "slug_id": "audit-log-rollout-4a9c",
  "title": "Audit log rollout",
  "url": "https://linear.app/acme/document/audit-log-rollout-4a9c"
}
</output-example>

<examples-good>
- clor linear document create "Audit log rollout" --project "Workspace audit log" --content-file rollout.md    # project document from Markdown
- clor linear document create "Audit log rollout" --issue ENG-482 --stdout-format json | jq .url    # related issue and JSON
- clor linear document create "Audit log rollout" --content "# Rollout\n\nReady for review." | grep '^event=document '    # inline Markdown
</examples-good>

<examples-bad>
- clor linear document create    # a title or document reference is required
- clor linear document create "Audit log rollout" --content text --content-file rollout.md    # inline and file content are mutually exclusive
</examples-bad>
</help>


<help command="clor linear document delete">
<summary>Move a document to recoverable trash</summary>
<usage>clor linear document delete <DOCUMENT></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197a5b6-c7d8-7e23-f456-789abcdef012",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear document delete "Audit log rollout"    # act on an exact reference
- clor linear document delete 0197a5b6-c7d8-7e23-f456-789abcdef012 --stdout-format json | jq .success    # check the action result
- clor linear document delete "Audit log rollout" | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear document delete    # a resource reference is required
- clor linear document delete approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear document list">
<summary>List documents</summary>
<usage>clor linear document list [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit concise event=document records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "documents": [
    {
      "id": "0197a5b6-c7d8-7e23-f456-789abcdef012",
      "slug_id": "audit-log-rollout-4a9c",
      "title": "Audit log rollout",
      "url": "https://linear.app/acme/document/audit-log-rollout-4a9c"
    }
  ]
}
</output-example>

<examples-good>
- clor linear document list    # typed document output
- clor linear document list --stdout-format json | jq .    # normalized JSON output
- clor linear document list | grep '^event=document '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear document list approximate    # names must match exactly
- clor linear document list --limit 0    # limits must be positive
</examples-bad>
</help>


<help command="clor linear document show">
<summary>Show one document</summary>
<usage>clor linear document show <DOCUMENT></usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<output>text and jsonl emit concise event=document records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "id": "0197a5b6-c7d8-7e23-f456-789abcdef012",
  "slug_id": "audit-log-rollout-4a9c",
  "title": "Audit log rollout",
  "url": "https://linear.app/acme/document/audit-log-rollout-4a9c"
}
</output-example>

<examples-good>
- clor linear document show "Audit log rollout"    # typed document output
- clor linear document show "Audit log rollout" --stdout-format json | jq .    # normalized JSON output
- clor linear document show "Audit log rollout" | grep '^event=document '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear document show approximate    # names must match exactly
- clor linear document show    # a reference is required
</examples-bad>
</help>


<help command="clor linear document unarchive">
<summary>Restore a trashed document</summary>
<usage>clor linear document unarchive <DOCUMENT></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197a5b6-c7d8-7e23-f456-789abcdef012",
  "action": "unarchive",
  "success": true
}
</output-example>

<examples-good>
- clor linear document unarchive "Audit log rollout"    # act on an exact reference
- clor linear document unarchive 0197a5b6-c7d8-7e23-f456-789abcdef012 --stdout-format json | jq .success    # check the action result
- clor linear document unarchive "Audit log rollout" | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear document unarchive    # a resource reference is required
- clor linear document unarchive approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear document update">
<summary>Update a document with explicit clear operations</summary>
<usage>clor linear document update <DOCUMENT> [flags]</usage>

<rules>
- Markdown can be inline or read from --content-file; - reads stdin
- related resources use exact references
</rules>

<flags>
- --clear-color bool: clear the icon color
- --clear-content bool: clear the Markdown content
- --clear-cycle bool: clear the related cycle
- --clear-icon bool: clear the icon
- --clear-initiative bool: clear the related initiative
- --clear-issue bool: clear the related issue
- --clear-project bool: clear the related project
- --clear-team bool: clear the related team
- --color string: document icon color
- --content string: Markdown document content
- --content-file string: file containing Markdown document content, or - for stdin
- --cycle string: related cycle ID, URL, or exact name
- --icon string: document icon
- --initiative string: related initiative ID, URL, identifier, or exact name
- --issue string: related issue ID, URL, or identifier
- --project string: related project ID, URL, or exact name
- --team string: related team ID, URL, key, or exact name
- --title string: new document title
</flags>

<output>text and jsonl emit one event=document record; json returns the normalized document</output>

<output-example format="json">
{
  "id": "0197a5b6-c7d8-7e23-f456-789abcdef012",
  "slug_id": "audit-log-rollout-4a9c",
  "title": "Audit log rollout",
  "url": "https://linear.app/acme/document/audit-log-rollout-4a9c"
}
</output-example>

<examples-good>
- clor linear document update audit-log-rollout-4a9c --project "Workspace audit log" --content-file rollout.md    # project document from Markdown
- clor linear document update audit-log-rollout-4a9c --issue ENG-482 --stdout-format json | jq .url    # related issue and JSON
- clor linear document update audit-log-rollout-4a9c --content "# Rollout\n\nReady for review." | grep '^event=document '    # inline Markdown
</examples-good>

<examples-bad>
- clor linear document update    # a title or document reference is required
- clor linear document update audit-log-rollout-4a9c --content text --content-file rollout.md    # inline and file content are mutually exclusive
</examples-bad>
</help>

<help command="clor linear graphql">
<summary>Run an uncommon Linear GraphQL operation directly</summary>
<usage>clor linear graphql [QUERY] [flags]</usage>

<uses>
- a needed Linear operation does not have a typed subcommand
</uses>

<skips>
- a typed subcommand covers the task and can normalize references and output
</skips>

<rules>
- provide exactly one inline query, query file, or stdin source
- all dynamic values belong in variables rather than string interpolation
</rules>

<flags>
- --operation-name string: GraphQL operation name
- --query-file string: file containing the GraphQL query
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --variable stringArray: variable as NAME=JSON, repeatable (default "[]")
- --variables string: variables as one JSON object
</flags>

<output>json returns a data object while preserving Linear field names; text and jsonl emit one event=graphql record</output>

<output-example format="json">
{
  "data": {
    "viewer": {
      "id": "0197d8e9-f0a1-7156-c789-abcdef012345",
      "name": "Alex Rivera"
    }
  }
}
</output-example>

<examples-good>
- clor linear graphql 'query Viewer { viewer { id name email } }'    # small uncommon read
- clor linear graphql --query-file operation.graphql --variables '{"team":"ENG"}' --operation-name TeamLookup --stdout-format json | jq .data    # file query with variables
- printf '%s' 'query Viewer { viewer { id name } }' | clor linear graphql --stdin-format text | grep '^event=graphql '    # query from stdin
</examples-good>

<examples-bad>
- clor linear graphql 'query A { viewer { id } }' --query-file operation.graphql    # query sources are mutually exclusive
- clor linear graphql 'query Team($id: String!) { team(id: $id) { id } }' --variable id=ENG    # variable values must be valid JSON, including quotes for strings
</examples-bad>
</help>

<help command="clor linear initiative">
<summary>Read and change Linear initiatives and their projects</summary>
<description>Use when:
  - the user needs Linear initiative records</description>
<usage>clor linear initiative</usage>

<uses>
- the user needs workspace initiatives or the projects grouped under them
</uses>

<subcommands>
- archive: Archive an initiative
- create: Create a workspace initiative
- delete: Move an initiative to recoverable trash
- list: List initiatives
- project: List, add, and remove initiative projects
- show: Show one initiative
- unarchive: Unarchive an initiative
- update: Update an initiative with explicit clear operations
</subcommands>
</help>


<help command="clor linear initiative archive">
<summary>Archive an initiative</summary>
<usage>clor linear initiative archive <INITIATIVE></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197f4a5-b6c7-7d12-e345-6789abcdef01",
  "action": "archive",
  "success": true
}
</output-example>

<examples-good>
- clor linear initiative archive INI-31    # act on an exact reference
- clor linear initiative archive 0197f4a5-b6c7-7d12-e345-6789abcdef01 --stdout-format json | jq .success    # check the action result
- clor linear initiative archive INI-31 | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear initiative archive    # a resource reference is required
- clor linear initiative archive approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear initiative create">
<summary>Create a workspace initiative</summary>
<usage>clor linear initiative create <NAME> [flags]</usage>

<flags>
- --content string: Markdown initiative content
- --content-file string: file containing Markdown initiative content, or - for stdin
- --description string: initiative description
- --owner string: owner ID, email, me, or exact name
- --priority string: initiative priority (no-priority|urgent|high|medium|low)
- --status string: initiative status (proposed|planned|active|completed|canceled)
- --target-date string: estimated completion date (YYYY-MM-DD)
</flags>

<output>text and jsonl emit one event=initiative record; json returns the normalized initiative</output>

<output-example format="json">
{
  "health": "onTrack",
  "id": "0197f4a5-b6c7-7d12-e345-6789abcdef01",
  "identifier": "INI-31",
  "name": "Reliability foundations",
  "status": "Active",
  "target_date": "2026-09-30"
}
</output-example>

<examples-good>
- clor linear initiative create "Reliability foundations" --owner me --priority high --status active    # owner, priority, and status
- clor linear initiative create "Reliability foundations" --content-file brief.md --stdout-format json | jq .id    # Markdown file and JSON
- clor linear initiative create "Reliability foundations" --target-date 2026-09-30 | grep '^event=initiative '    # target date
</examples-good>

<examples-bad>
- clor linear initiative create    # a name or initiative reference is required
- clor linear initiative create "Reliability foundations" --status underway    # status must use a documented value
</examples-bad>
</help>


<help command="clor linear initiative delete">
<summary>Move an initiative to recoverable trash</summary>
<usage>clor linear initiative delete <INITIATIVE></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197f4a5-b6c7-7d12-e345-6789abcdef01",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear initiative delete INI-31    # act on an exact reference
- clor linear initiative delete 0197f4a5-b6c7-7d12-e345-6789abcdef01 --stdout-format json | jq .success    # check the action result
- clor linear initiative delete INI-31 | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear initiative delete    # a resource reference is required
- clor linear initiative delete approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear initiative list">
<summary>List initiatives</summary>
<usage>clor linear initiative list [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit concise event=initiative records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "initiatives": [
    {
      "health": "onTrack",
      "id": "0197f4a5-b6c7-7d12-e345-6789abcdef01",
      "identifier": "INI-31",
      "name": "Reliability foundations",
      "status": "Active",
      "target_date": "2026-09-30"
    }
  ]
}
</output-example>

<examples-good>
- clor linear initiative list    # typed initiative output
- clor linear initiative list --stdout-format json | jq .    # normalized JSON output
- clor linear initiative list | grep '^event=initiative '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear initiative list approximate    # names must match exactly
- clor linear initiative list --limit 0    # limits must be positive
</examples-bad>
</help>


<help command="clor linear initiative project">
<summary>List, add, and remove initiative projects</summary>
<description>Use when:
  - the user needs Linear project records</description>
<usage>clor linear initiative project</usage>

<uses>
- the user needs to inspect or change the projects grouped under an initiative
</uses>

<subcommands>
- add: Add a project to an initiative
- list: List projects in an initiative
- remove: Remove a project from an initiative
</subcommands>
</help>


<help command="clor linear initiative project add">
<summary>Add a project to an initiative</summary>
<usage>clor linear initiative project add <INITIATIVE> <PROJECT></usage>

<output>text and jsonl emit a concise initiative-project or action event; json returns the normalized operation output</output>

<output-example format="json">
{
  "id": "0197f6a7-b8c9-7934-e567-23456789abcd",
  "initiative": {
    "id": "0197f4a5-b6c7-7d12-e345-6789abcdef01",
    "identifier": "INI-31",
    "name": "Reliability foundations"
  },
  "project": {
    "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
    "name": "Workspace audit log"
  }
}
</output-example>

<examples-good>
- clor linear initiative project add INI-31 "Workspace audit log"    # exact initiative and project references
- clor linear initiative project add INI-31 "Workspace audit log" --stdout-format json | jq .    # normalized JSON
- clor linear initiative project add INI-31 "Workspace audit log" | grep '^event='    # default output
</examples-good>

<examples-bad>
- clor linear initiative project add INI-31    # initiative and project references are required
- clor linear initiative project add approximate project    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear initiative project list">
<summary>List projects in an initiative</summary>
<usage>clor linear initiative project list <INITIATIVE> [flags]</usage>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit one event=project record; json returns {projects, cursor?}</output>

<output-example format="json">
{
  "projects": [
    {
      "health": "onTrack",
      "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
      "name": "Workspace audit log",
      "slug_id": "workspace-audit-log-8f2d",
      "target_date": "2026-08-15",
      "url": "https://linear.app/acme/project/workspace-audit-log-8f2d"
    }
  ]
}
</output-example>

<examples-good>
- clor linear initiative project list INI-31    # initiative projects
- clor linear initiative project list INI-31 --stdout-format json | jq '.projects[].name'    # project names as JSON
- clor linear initiative project list INI-31 | grep '^event=project '    # default logfmt
</examples-good>

<examples-bad>
- clor linear initiative project list    # an initiative reference is required
- clor linear initiative project list INI-31 --limit 0    # limit must be positive
</examples-bad>
</help>


<help command="clor linear initiative project remove">
<summary>Remove a project from an initiative</summary>
<usage>clor linear initiative project remove <INITIATIVE> <PROJECT></usage>

<output>text and jsonl emit a concise initiative-project or action event; json returns the normalized operation output</output>

<output-example format="json">
{
  "id": "0197f6a7-b8c9-7934-e567-23456789abcd",
  "action": "remove",
  "success": true
}
</output-example>

<examples-good>
- clor linear initiative project remove INI-31 "Workspace audit log"    # exact initiative and project references
- clor linear initiative project remove INI-31 "Workspace audit log" --stdout-format json | jq .    # normalized JSON
- clor linear initiative project remove INI-31 "Workspace audit log" | grep '^event='    # default output
</examples-good>

<examples-bad>
- clor linear initiative project remove INI-31    # initiative and project references are required
- clor linear initiative project remove approximate project    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear initiative show">
<summary>Show one initiative</summary>
<usage>clor linear initiative show <INITIATIVE></usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<output>text and jsonl emit concise event=initiative records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "health": "onTrack",
  "id": "0197f4a5-b6c7-7d12-e345-6789abcdef01",
  "identifier": "INI-31",
  "name": "Reliability foundations",
  "status": "Active",
  "target_date": "2026-09-30"
}
</output-example>

<examples-good>
- clor linear initiative show INI-31    # typed initiative output
- clor linear initiative show INI-31 --stdout-format json | jq .    # normalized JSON output
- clor linear initiative show INI-31 | grep '^event=initiative '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear initiative show approximate    # names must match exactly
- clor linear initiative show    # a reference is required
</examples-bad>
</help>


<help command="clor linear initiative unarchive">
<summary>Unarchive an initiative</summary>
<usage>clor linear initiative unarchive <INITIATIVE></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197f4a5-b6c7-7d12-e345-6789abcdef01",
  "action": "unarchive",
  "success": true
}
</output-example>

<examples-good>
- clor linear initiative unarchive INI-31    # act on an exact reference
- clor linear initiative unarchive 0197f4a5-b6c7-7d12-e345-6789abcdef01 --stdout-format json | jq .success    # check the action result
- clor linear initiative unarchive INI-31 | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear initiative unarchive    # a resource reference is required
- clor linear initiative unarchive approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear initiative update">
<summary>Update an initiative with explicit clear operations</summary>
<usage>clor linear initiative update <INITIATIVE> [flags]</usage>

<flags>
- --clear-content bool: clear the Markdown content
- --clear-description bool: clear the description
- --clear-owner bool: clear the owner
- --clear-priority bool: set no priority
- --clear-target-date bool: clear the target date
- --content string: Markdown initiative content
- --content-file string: file containing Markdown initiative content, or - for stdin
- --description string: initiative description
- --name string: new initiative name
- --owner string: owner ID, email, me, or exact name
- --priority string: initiative priority (no-priority|urgent|high|medium|low)
- --status string: initiative status (proposed|planned|active|completed|canceled)
- --target-date string: estimated completion date (YYYY-MM-DD)
</flags>

<output>text and jsonl emit one event=initiative record; json returns the normalized initiative</output>

<output-example format="json">
{
  "health": "onTrack",
  "id": "0197f4a5-b6c7-7d12-e345-6789abcdef01",
  "identifier": "INI-31",
  "name": "Reliability foundations",
  "status": "Active",
  "target_date": "2026-09-30"
}
</output-example>

<examples-good>
- clor linear initiative update INI-31 --owner me --priority high --status active    # owner, priority, and status
- clor linear initiative update INI-31 --content-file brief.md --stdout-format json | jq .id    # Markdown file and JSON
- clor linear initiative update INI-31 --target-date 2026-09-30 | grep '^event=initiative '    # target date
</examples-good>

<examples-bad>
- clor linear initiative update    # a name or initiative reference is required
- clor linear initiative update INI-31 --status underway    # status must use a documented value
</examples-bad>
</help>

<help command="clor linear issue">
<summary>Read and change Linear issues, comments, and relations</summary>
<description>Use when:
  - the user needs Linear issue records</description>
<usage>clor linear issue</usage>

<uses>
- the user needs issues, issue comments, or issue relations
</uses>

<rules>
- delete uses Linear's recoverable trash behavior and never permanent deletion
</rules>

<subcommands>
- archive: Archive an issue
- comment: Read and change issue comments
- create: Create an issue with typed workspace references
- delete: Move an issue to recoverable trash
- list: List issues with exact workspace filters
- relation: List, add, and remove issue relations
- show: Show one issue
- unarchive: Unarchive an issue
- update: Update an issue with explicit set and clear operations
</subcommands>
</help>


<help command="clor linear issue archive">
<summary>Archive an issue</summary>
<usage>clor linear issue archive <ISSUE></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
  "action": "archive",
  "success": true
}
</output-example>

<examples-good>
- clor linear issue archive ENG-482    # act on an exact reference
- clor linear issue archive 0197c1d2-e3f4-7a89-b012-3456789abcde --stdout-format json | jq .success    # check the action result
- clor linear issue archive ENG-482 | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear issue archive    # a resource reference is required
- clor linear issue archive approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear issue comment">
<summary>Read and change issue comments</summary>
<description>Use when:
  - the user needs Linear comment records</description>
<usage>clor linear issue comment</usage>

<uses>
- the user needs comments or comment-thread resolution on a Linear issue
</uses>

<subcommands>
- create: Create an issue comment in Markdown
- delete: Delete an issue comment
- list: List comments on an issue
- resolve: Resolve a comment thread
- unresolve: Unresolve a comment thread
- update: Update an issue comment in Markdown
</subcommands>
</help>


<help command="clor linear issue comment create">
<summary>Create an issue comment in Markdown</summary>
<usage>clor linear issue comment create <ISSUE> [BODY] [flags]</usage>

<rules>
- Markdown is preserved byte for byte; --body-file - reads stdin
</rules>

<flags>
- --body-file string: file containing the Markdown body, or - for stdin
- --parent string: parent comment ID
</flags>

<output>text and jsonl emit one event=comment record; json returns the normalized comment</output>

<output-example format="json">
{
  "body": "The migration plan is ready for review.",
  "created": "2026-07-21T12:00:00Z",
  "id": "0197c3d4-e5f6-7601-b234-f0123456789a",
  "user": {
    "name": "Alex Rivera"
  }
}
</output-example>

<examples-good>
- clor linear issue comment create ENG-482 "The migration plan is ready for review."    # inline Markdown body
- clor linear issue comment create ENG-482 --body-file comment.md --stdout-format json | jq .id    # file body and JSON
- clor linear issue comment create ENG-482 "Review requested" | grep '^event=comment '    # default logfmt
</examples-good>

<examples-bad>
- clor linear issue comment create ENG-482    # a body is required
- clor linear issue comment create ENG-482 "text" --body-file comment.md    # inline and file bodies are mutually exclusive
</examples-bad>
</help>


<help command="clor linear issue comment delete">
<summary>Delete an issue comment</summary>
<usage>clor linear issue comment delete <COMMENT></usage>

<output>text and jsonl emit a concise comment or action event; json returns the normalized operation output</output>

<output-example format="json">
{
  "id": "0197c3d4-e5f6-7601-b234-f0123456789a",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear issue comment delete 0197c3d4-e5f6-7601-b234-f0123456789a    # act on an exact comment ID
- clor linear issue comment delete 0197c3d4-e5f6-7601-b234-f0123456789a --stdout-format json | jq .    # JSON output
- clor linear issue comment delete 0197c3d4-e5f6-7601-b234-f0123456789a | grep '^event='    # default output
</examples-good>

<examples-bad>
- clor linear issue comment delete    # a comment ID is required
- clor linear issue comment delete approximate    # comment references are exact
</examples-bad>
</help>


<help command="clor linear issue comment list">
<summary>List comments on an issue</summary>
<usage>clor linear issue comment list <ISSUE> [flags]</usage>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit one event=comment record per comment; json returns {comments, cursor?}</output>

<output-example format="json">
{
  "comments": [
    {
      "body": "The migration plan is ready for review.",
      "created": "2026-07-21T12:00:00Z",
      "id": "0197c3d4-e5f6-7601-b234-f0123456789a",
      "user": {
        "name": "Alex Rivera"
      }
    }
  ],
  "cursor": "2f07f96a"
}
</output-example>

<examples-good>
- clor linear issue comment list ENG-482    # issue comments in default logfmt
- clor linear issue comment list ENG-482 --stdout-format json | jq '.comments[].body'    # comment bodies as JSON
- clor linear issue comment list ENG-482 --ordering updated | grep '^event=comment '    # recently updated comments
</examples-good>

<examples-bad>
- clor linear issue comment list    # an issue reference is required
- clor linear issue comment list ENG-482 --limit 0    # limit must be positive
</examples-bad>
</help>


<help command="clor linear issue comment resolve">
<summary>Resolve a comment thread</summary>
<usage>clor linear issue comment resolve <COMMENT></usage>

<output>text and jsonl emit a concise comment or action event; json returns the normalized operation output</output>

<output-example format="json">
{
  "body": "The migration plan is ready for review.",
  "created": "2026-07-21T12:00:00Z",
  "id": "0197c3d4-e5f6-7601-b234-f0123456789a",
  "user": {
    "name": "Alex Rivera"
  }
}
</output-example>

<examples-good>
- clor linear issue comment resolve 0197c3d4-e5f6-7601-b234-f0123456789a    # act on an exact comment ID
- clor linear issue comment resolve 0197c3d4-e5f6-7601-b234-f0123456789a --stdout-format json | jq .    # JSON output
- clor linear issue comment resolve 0197c3d4-e5f6-7601-b234-f0123456789a | grep '^event='    # default output
</examples-good>

<examples-bad>
- clor linear issue comment resolve    # a comment ID is required
- clor linear issue comment resolve approximate    # comment references are exact
</examples-bad>
</help>


<help command="clor linear issue comment unresolve">
<summary>Unresolve a comment thread</summary>
<usage>clor linear issue comment unresolve <COMMENT></usage>

<output>text and jsonl emit a concise comment or action event; json returns the normalized operation output</output>

<output-example format="json">
{
  "body": "The migration plan is ready for review.",
  "created": "2026-07-21T12:00:00Z",
  "id": "0197c3d4-e5f6-7601-b234-f0123456789a",
  "user": {
    "name": "Alex Rivera"
  }
}
</output-example>

<examples-good>
- clor linear issue comment unresolve 0197c3d4-e5f6-7601-b234-f0123456789a    # act on an exact comment ID
- clor linear issue comment unresolve 0197c3d4-e5f6-7601-b234-f0123456789a --stdout-format json | jq .    # JSON output
- clor linear issue comment unresolve 0197c3d4-e5f6-7601-b234-f0123456789a | grep '^event='    # default output
</examples-good>

<examples-bad>
- clor linear issue comment unresolve    # a comment ID is required
- clor linear issue comment unresolve approximate    # comment references are exact
</examples-bad>
</help>


<help command="clor linear issue comment update">
<summary>Update an issue comment in Markdown</summary>
<usage>clor linear issue comment update <COMMENT> [BODY] [flags]</usage>

<rules>
- Markdown is preserved byte for byte; --body-file - reads stdin
</rules>

<flags>
- --body-file string: file containing the Markdown body, or - for stdin
</flags>

<output>text and jsonl emit one event=comment record; json returns the normalized comment</output>

<output-example format="json">
{
  "body": "The migration plan is ready for review.",
  "created": "2026-07-21T12:00:00Z",
  "id": "0197c3d4-e5f6-7601-b234-f0123456789a",
  "user": {
    "name": "Alex Rivera"
  }
}
</output-example>

<examples-good>
- clor linear issue comment update 0197c3d4-e5f6-7601-b234-f0123456789a "The migration plan is ready for review."    # inline Markdown body
- clor linear issue comment update 0197c3d4-e5f6-7601-b234-f0123456789a --body-file comment.md --stdout-format json | jq .id    # file body and JSON
- clor linear issue comment update 0197c3d4-e5f6-7601-b234-f0123456789a "Review requested" | grep '^event=comment '    # default logfmt
</examples-good>

<examples-bad>
- clor linear issue comment update 0197c3d4-e5f6-7601-b234-f0123456789a    # a body is required
- clor linear issue comment update 0197c3d4-e5f6-7601-b234-f0123456789a "text" --body-file comment.md    # inline and file bodies are mutually exclusive
</examples-bad>
</help>


<help command="clor linear issue create">
<summary>Create an issue with typed workspace references</summary>
<usage>clor linear issue create <TITLE> [flags]</usage>

<rules>
- Markdown can be inline or read from a file, and - reads stdin
- state, cycle, milestone, and label names are scoped by their team or project
</rules>

<flags>
- --assignee string: assignee ID, email, me, or exact name
- --cycle string: cycle ID, URL, or exact name
- --description string: Markdown description
- --description-file string: file containing the Markdown description, or - for stdin
- --due-date string: due date (YYYY-MM-DD)
- --estimate int: issue estimate
- --label stringArray: label ID or exact name, repeatable (default "[]")
- --milestone string: project milestone ID or exact name
- --parent string: parent issue ID, URL, or identifier
- --priority string: issue priority (no-priority|urgent|high|medium|low)
- --project string: project ID, URL, or exact name
- --state string: state ID or exact name
- --team string: team ID, URL, key, or exact name
- --template string: template ID
</flags>

<output>text and jsonl emit one event=issue record; json returns the normalized issue</output>

<output-example format="json">
{
  "created": "2026-07-18T09:30:00Z",
  "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
  "identifier": "ENG-482",
  "priority": 2,
  "state": {
    "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
    "name": "In Progress"
  },
  "title": "Ship workspace audit log",
  "updated": "2026-07-21T11:45:00Z",
  "url": "https://linear.app/acme/issue/ENG-482/ship-workspace-audit-log"
}
</output-example>

<examples-good>
- clor linear issue create "Ship workspace audit log" --team ENG --priority high --assignee me    # typed issue fields
- clor linear issue create "Ship workspace audit log" --team ENG --description-file plan.md --stdout-format json | jq .identifier    # Markdown file and JSON output
- clor linear issue create "Ship workspace audit log" --team ENG --project "Workspace audit log" --label security | grep '^event=issue '    # project and label assignment
</examples-good>

<examples-bad>
- clor linear issue create "Ship workspace audit log"    # create needs a team and update needs a reference
- clor linear issue create "Ship workspace audit log" --description text --description-file plan.md    # inline and file Markdown are mutually exclusive
</examples-bad>
</help>


<help command="clor linear issue delete">
<summary>Move an issue to recoverable trash</summary>
<usage>clor linear issue delete <ISSUE></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear issue delete ENG-482    # act on an exact reference
- clor linear issue delete 0197c1d2-e3f4-7a89-b012-3456789abcde --stdout-format json | jq .success    # check the action result
- clor linear issue delete ENG-482 | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear issue delete    # a resource reference is required
- clor linear issue delete approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear issue list">
<summary>List issues with exact workspace filters</summary>
<usage>clor linear issue list [flags]</usage>

<rules>
- state, cycle, and label names are restricted by --team when supplied
- each GraphQL page requests at most 50 issues
</rules>

<flags>
- --assignee string: assignee ID, email, me, or exact name
- --cursor string: Relay cursor to continue after
- --cycle string: cycle ID, URL, or exact name
- --include-archived bool: include archived records
- --label string: label ID or exact name
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
- --priority string: issue priority (no-priority|urgent|high|medium|low)
- --project string: project ID, URL, or exact name
- --state string: state ID or exact name
- --team string: team ID, URL, key, or exact name
</flags>

<output>text and jsonl emit one event=issue record per issue; json returns {issues, cursor?}</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "issues": [
    {
      "created": "2026-07-18T09:30:00Z",
      "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
      "identifier": "ENG-482",
      "priority": 2,
      "state": {
        "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
        "name": "In Progress"
      },
      "title": "Ship workspace audit log",
      "updated": "2026-07-21T11:45:00Z",
      "url": "https://linear.app/acme/issue/ENG-482/ship-workspace-audit-log"
    }
  ]
}
</output-example>

<examples-good>
- clor linear issue list --team ENG --state "In Progress" --assignee me    # scoped active work
- clor linear issue list --project "Workspace audit log" --stdout-format json | jq '.issues[].identifier'    # project issue identifiers
- clor linear issue list --priority high --ordering updated | grep '^event=issue '    # recent high-priority issues
</examples-good>

<examples-bad>
- clor linear issue list --priority critical    # priority must use a documented value
- clor linear issue list --limit 0    # limit must be positive
</examples-bad>
</help>


<help command="clor linear issue relation">
<summary>List, add, and remove issue relations</summary>
<description>Use when:
  - the user needs Linear relation records</description>
<usage>clor linear issue relation</usage>

<rules>
- the first issue is the source of blocks, duplicate, related, or similar relations
</rules>

<subcommands>
- add: Add a typed relation from one issue to another
- list: List relations sourced from an issue
- remove: Remove an issue relation
</subcommands>
</help>


<help command="clor linear issue relation add">
<summary>Add a typed relation from one issue to another</summary>
<usage>clor linear issue relation add <ISSUE> <RELATED_ISSUE> [flags]</usage>

<rules>
- the first issue is the source of the relation
</rules>

<flags>
- --type string: relation type (blocks|duplicate|related|similar) (default "related")
</flags>

<output>text and jsonl emit one event=relation record; json returns the normalized relation</output>

<output-example format="json">
{
  "id": "0197d4e5-f6a7-7712-c345-0123456789ab",
  "issue": {
    "identifier": "ENG-482"
  },
  "related_issue": {
    "identifier": "ENG-491"
  },
  "type": "blocks"
}
</output-example>

<examples-good>
- clor linear issue relation add ENG-482 ENG-491 --type blocks    # ENG-482 blocks ENG-491
- clor linear issue relation add ENG-482 ENG-491 --type related --stdout-format json | jq .id    # related issues as JSON
- clor linear issue relation add ENG-482 ENG-491 --type duplicate | grep '^event=relation '    # default logfmt
</examples-good>

<examples-bad>
- clor linear issue relation add ENG-482    # source and related issues are required
- clor linear issue relation add ENG-482 ENG-491 --type blocked-by    # use blocks with the blocking issue first
</examples-bad>
</help>


<help command="clor linear issue relation list">
<summary>List relations sourced from an issue</summary>
<usage>clor linear issue relation list <ISSUE> [flags]</usage>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit one event=relation record; json returns {relations, cursor?}</output>

<output-example format="json">
{
  "relations": [
    {
      "id": "0197d4e5-f6a7-7712-c345-0123456789ab",
      "issue": {
        "identifier": "ENG-482"
      },
      "related_issue": {
        "identifier": "ENG-491"
      },
      "type": "blocks"
    }
  ]
}
</output-example>

<examples-good>
- clor linear issue relation list ENG-482    # relations sourced from the issue
- clor linear issue relation list ENG-482 --stdout-format json | jq '.relations[] | {type, related_issue}'    # relation targets as JSON
- clor linear issue relation list ENG-482 | grep '^event=relation '    # default logfmt
</examples-good>

<examples-bad>
- clor linear issue relation list    # an issue reference is required
- clor linear issue relation list ENG-482 --limit 0    # limit must be positive
</examples-bad>
</help>


<help command="clor linear issue relation remove">
<summary>Remove an issue relation</summary>
<usage>clor linear issue relation remove <RELATION></usage>

<output>text and jsonl emit one event=action record; json returns {id, action, success}</output>

<output-example format="json">
{
  "id": "0197d4e5-f6a7-7712-c345-0123456789ab",
  "action": "remove",
  "success": true
}
</output-example>

<examples-good>
- clor linear issue relation remove 0197d4e5-f6a7-7712-c345-0123456789ab    # remove by relation ID
- clor linear issue relation remove 0197d4e5-f6a7-7712-c345-0123456789ab --stdout-format json | jq .success    # check success
- clor linear issue relation remove 0197d4e5-f6a7-7712-c345-0123456789ab | grep '^event=action '    # default logfmt
</examples-good>

<examples-bad>
- clor linear issue relation remove    # a relation ID is required
- clor linear issue relation remove ENG-482    # remove takes a relation ID, not an issue identifier
</examples-bad>
</help>


<help command="clor linear issue show">
<summary>Show one issue</summary>
<usage>clor linear issue show <ISSUE></usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<output>text and jsonl emit concise event=issue records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "created": "2026-07-18T09:30:00Z",
  "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
  "identifier": "ENG-482",
  "priority": 2,
  "state": {
    "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
    "name": "In Progress"
  },
  "title": "Ship workspace audit log",
  "updated": "2026-07-21T11:45:00Z",
  "url": "https://linear.app/acme/issue/ENG-482/ship-workspace-audit-log"
}
</output-example>

<examples-good>
- clor linear issue show ENG-482    # typed issue output
- clor linear issue show ENG-482 --stdout-format json | jq .    # normalized JSON output
- clor linear issue show ENG-482 | grep '^event=issue '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear issue show approximate    # names must match exactly
- clor linear issue show    # a reference is required
</examples-bad>
</help>


<help command="clor linear issue unarchive">
<summary>Unarchive an issue</summary>
<usage>clor linear issue unarchive <ISSUE></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
  "action": "unarchive",
  "success": true
}
</output-example>

<examples-good>
- clor linear issue unarchive ENG-482    # act on an exact reference
- clor linear issue unarchive 0197c1d2-e3f4-7a89-b012-3456789abcde --stdout-format json | jq .success    # check the action result
- clor linear issue unarchive ENG-482 | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear issue unarchive    # a resource reference is required
- clor linear issue unarchive approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear issue update">
<summary>Update an issue with explicit set and clear operations</summary>
<usage>clor linear issue update <ISSUE> [flags]</usage>

<rules>
- at least one field must change
- a field cannot be set and cleared in the same request
- --add-label and --remove-label are repeatable; --clear-labels conflicts with both
</rules>

<flags>
- --add-label stringArray: label ID or exact name to add, repeatable (default "[]")
- --assignee string: assignee ID, email, me, or exact name
- --clear-assignee bool: clear the assignee
- --clear-cycle bool: clear the cycle
- --clear-description bool: clear the description
- --clear-due-date bool: clear the due date
- --clear-estimate bool: clear the estimate
- --clear-labels bool: remove all labels
- --clear-milestone bool: clear the project milestone
- --clear-parent bool: clear the parent issue
- --clear-priority bool: set no priority
- --clear-project bool: clear the project and milestone
- --clear-state bool: clear the state
- --clear-template bool: clear the last applied template
- --cycle string: cycle ID, URL, or exact name
- --description string: Markdown description
- --description-file string: file containing the Markdown description, or - for stdin
- --due-date string: due date (YYYY-MM-DD)
- --estimate int: issue estimate
- --milestone string: project milestone ID or exact name
- --parent string: parent issue ID, URL, or identifier
- --priority string: issue priority (no-priority|urgent|high|medium|low)
- --project string: project ID, URL, or exact name
- --remove-label stringArray: label ID or exact name to remove, repeatable (default "[]")
- --state string: state ID or exact name
- --team string: team ID, URL, key, or exact name
- --template string: template ID
- --title string: new issue title
</flags>

<output>text and jsonl emit one event=issue record; json returns the normalized issue</output>

<output-example format="json">
{
  "created": "2026-07-18T09:30:00Z",
  "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
  "identifier": "ENG-482",
  "priority": 2,
  "state": {
    "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
    "name": "In Progress"
  },
  "title": "Ship workspace audit log",
  "updated": "2026-07-21T11:45:00Z",
  "url": "https://linear.app/acme/issue/ENG-482/ship-workspace-audit-log"
}
</output-example>

<examples-good>
- clor linear issue update ENG-482 --title "Ship workspace audit log" --priority high    # set ordinary fields
- clor linear issue update ENG-482 --description-file plan.md --add-label security --stdout-format json | jq .updated    # Markdown and label addition
- clor linear issue update ENG-482 --clear-assignee --clear-due-date | grep '^event=issue '    # explicit clear operations
</examples-good>

<examples-bad>
- clor linear issue update ENG-482    # at least one change is required
- clor linear issue update ENG-482 --assignee me --clear-assignee    # a field cannot be set and cleared together
</examples-bad>
</help>

<help command="clor linear label">
<summary>Read and change Linear issue labels</summary>
<usage>clor linear label</usage>

<uses>
- the user needs Linear label records
</uses>

<subcommands>
- create: Create an issue label
- delete: Delete an issue label
- list: List labels
- show: Show one label
- update: Update an issue label
</subcommands>
</help>


<help command="clor linear label create">
<summary>Create an issue label</summary>
<usage>clor linear label create <NAME> [flags]</usage>

<flags>
- --color string: hex color
- --description string: label description
- --group bool: create a label group
- --parent string: parent label ID or exact name
- --team string: team ID, URL, key, or exact name
</flags>

<output>text and jsonl emit one event=label record; json returns the normalized label</output>

<output-example format="json">
{
  "color": "#EB5757",
  "id": "0197f0a1-b2c3-7378-e901-cdef01234567",
  "name": "security",
  "team": {
    "key": "ENG"
  }
}
</output-example>

<examples-good>
- clor linear label create security --color '#EB5757' --team ENG    # team-scoped label
- clor linear label create security --description "Security review" --stdout-format json | jq .id    # description and normalized JSON
- clor linear label create security --team ENG | grep '^event=label '    # default logfmt
</examples-good>

<examples-bad>
- clor linear label create    # a label name is required
- clor linear label create security --parent security --team UNKNOWN    # references must resolve exactly
</examples-bad>
</help>


<help command="clor linear label delete">
<summary>Delete an issue label</summary>
<usage>clor linear label delete <LABEL> [flags]</usage>

<rules>
- names match exactly and --team disambiguates labels with the same name
</rules>

<flags>
- --team string: team ID, URL, key, or exact name used to disambiguate
</flags>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197f0a1-b2c3-7378-e901-cdef01234567",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear label delete security --team ENG    # team-scoped label name
- clor linear label delete 0197f0a1-b2c3-7378-e901-cdef01234567 --stdout-format json | jq .success    # delete by ID and check success
- clor linear label delete security --team ENG | grep '^event=action '    # default logfmt
</examples-good>

<examples-bad>
- clor linear label delete    # a label reference is required
- clor linear label delete approximate    # names must match exactly
</examples-bad>
</help>


<help command="clor linear label list">
<summary>List labels</summary>
<usage>clor linear label list [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
- --team string: team ID, URL, key, or exact name
</flags>

<output>text and jsonl emit concise event=label records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "labels": [
    {
      "color": "#EB5757",
      "id": "0197f0a1-b2c3-7378-e901-cdef01234567",
      "name": "security",
      "team": {
        "key": "ENG"
      }
    }
  ]
}
</output-example>

<examples-good>
- clor linear label list    # typed label output
- clor linear label list --stdout-format json | jq .    # normalized JSON output
- clor linear label list | grep '^event=label '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear label list approximate    # names must match exactly
- clor linear label list --limit 0    # limits must be positive
</examples-bad>
</help>


<help command="clor linear label show">
<summary>Show one label</summary>
<usage>clor linear label show <LABEL> [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --team string: team ID, URL, key, or exact name used to disambiguate
</flags>

<output>text and jsonl emit concise event=label records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "color": "#EB5757",
  "id": "0197f0a1-b2c3-7378-e901-cdef01234567",
  "name": "security",
  "team": {
    "key": "ENG"
  }
}
</output-example>

<examples-good>
- clor linear label show security    # typed label output
- clor linear label show security --stdout-format json | jq .    # normalized JSON output
- clor linear label show security | grep '^event=label '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear label show approximate    # names must match exactly
- clor linear label show    # a reference is required
</examples-bad>
</help>


<help command="clor linear label update">
<summary>Update an issue label</summary>
<usage>clor linear label update <LABEL> [flags]</usage>

<flags>
- --clear-description bool: clear the description
- --clear-parent bool: clear the parent label
- --color string: hex color
- --description string: label description
- --group bool: set whether this is a label group
- --name string: new label name
- --parent string: parent label ID or exact name
- --team string: team ID, URL, key, or exact name used to disambiguate
</flags>

<output>text and jsonl emit one event=label record; json returns the normalized label</output>

<output-example format="json">
{
  "color": "#EB5757",
  "id": "0197f0a1-b2c3-7378-e901-cdef01234567",
  "name": "security",
  "team": {
    "key": "ENG"
  }
}
</output-example>

<examples-good>
- clor linear label update security --team ENG --color '#EB5757'    # team-scoped label
- clor linear label update security --team ENG --description "Security review" --stdout-format json | jq .id    # description and normalized JSON
- clor linear label update security --team ENG --clear-parent | grep '^event=label '    # explicit clear in default output
</examples-good>

<examples-bad>
- clor linear label update    # a label reference is required
- clor linear label update security --description text --clear-description    # a field cannot be set and cleared together
</examples-bad>
</help>

<help command="clor linear project">
<summary>Read and change Linear projects, progress updates, and milestones</summary>
<description>Use when:
  - the user needs Linear project records</description>
<usage>clor linear project</usage>

<uses>
- the user needs projects, project progress updates, or milestones
</uses>

<rules>
- project deletion is recoverable with project unarchive
</rules>

<subcommands>
- create: Create a project across one or more teams
- delete: Move a project to recoverable trash
- list: List projects
- milestone: Read and change project milestones
- progress: Read and change project progress updates
- show: Show one project
- unarchive: Restore a trashed or archived project
- update: Update a project with explicit set and clear operations
</subcommands>
</help>


<help command="clor linear project create">
<summary>Create a project across one or more teams</summary>
<usage>clor linear project create <NAME> [flags]</usage>

<rules>
- project content accepts inline Markdown or a file; - reads stdin
- team and member flags are repeatable
</rules>

<flags>
- --content string: Markdown project content
- --content-file string: file containing Markdown project content, or - for stdin
- --description string: project description
- --lead string: lead ID, email, me, or exact name
- --member stringArray: member ID, email, me, or exact name, repeatable (default "[]")
- --priority string: project priority (no-priority|urgent|high|medium|low)
- --start-date string: start date (YYYY-MM-DD)
- --status string: project status ID or exact name
- --target-date string: target date (YYYY-MM-DD)
- --team stringArray: team ID, URL, key, or exact name, repeatable (default "[]")
</flags>

<output>text and jsonl emit one event=project record; json returns the normalized project</output>

<output-example format="json">
{
  "health": "onTrack",
  "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
  "name": "Workspace audit log",
  "slug_id": "workspace-audit-log-8f2d",
  "target_date": "2026-08-15",
  "url": "https://linear.app/acme/project/workspace-audit-log-8f2d"
}
</output-example>

<examples-good>
- clor linear project create "Workspace audit log" --team ENG --lead me --priority high    # team, lead, and priority
- clor linear project create "Workspace audit log" --team ENG --content-file plan.md --stdout-format json | jq .id    # Markdown file and JSON
- clor linear project create "Workspace audit log" --team ENG --target-date 2026-08-15 | grep '^event=project '    # target date in default output
</examples-good>

<examples-bad>
- clor linear project create "Workspace audit log"    # create requires a team and update requires a change
- clor linear project create "Workspace audit log" --content text --content-file plan.md    # inline and file content are mutually exclusive
</examples-bad>
</help>


<help command="clor linear project delete">
<summary>Move a project to recoverable trash</summary>
<usage>clor linear project delete <PROJECT></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear project delete "Workspace audit log"    # act on an exact reference
- clor linear project delete 0197d2e3-f4a5-7b90-c123-456789abcdef --stdout-format json | jq .success    # check the action result
- clor linear project delete "Workspace audit log" | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear project delete    # a resource reference is required
- clor linear project delete approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear project list">
<summary>List projects</summary>
<usage>clor linear project list [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit concise event=project records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "projects": [
    {
      "health": "onTrack",
      "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
      "name": "Workspace audit log",
      "slug_id": "workspace-audit-log-8f2d",
      "target_date": "2026-08-15",
      "url": "https://linear.app/acme/project/workspace-audit-log-8f2d"
    }
  ]
}
</output-example>

<examples-good>
- clor linear project list    # typed project output
- clor linear project list --stdout-format json | jq .    # normalized JSON output
- clor linear project list | grep '^event=project '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear project list approximate    # names must match exactly
- clor linear project list --limit 0    # limits must be positive
</examples-bad>
</help>


<help command="clor linear project milestone">
<summary>Read and change project milestones</summary>
<description>Use when:
  - the user needs Linear milestone records</description>
<usage>clor linear project milestone</usage>

<uses>
- the user needs named checkpoints and target dates inside a Linear project
</uses>

<subcommands>
- create: Create a project milestone
- delete: Delete a project milestone
- list: List milestones for a project
- show: Show one milestone
- update: Update a project milestone
</subcommands>
</help>


<help command="clor linear project milestone create">
<summary>Create a project milestone</summary>
<usage>clor linear project milestone create <PROJECT> <NAME> [flags]</usage>

<flags>
- --description string: Markdown milestone description
- --description-file string: file containing the Markdown description, or - for stdin
- --target-date string: target date (YYYY-MM-DD)
</flags>

<output>text and jsonl emit one event=milestone record; json returns the normalized milestone</output>

<output-example format="json">
{
  "id": "0197a1b2-c3d4-7489-f012-def012345678",
  "name": "Private beta",
  "project": {
    "name": "Workspace audit log"
  },
  "target_date": "2026-08-01"
}
</output-example>

<examples-good>
- clor linear project milestone create "Workspace audit log" "Private beta" --target-date 2026-08-01    # milestone target date
- clor linear project milestone create "Workspace audit log" "Private beta" --description-file milestone.md --stdout-format json | jq .id    # Markdown and JSON
- clor linear project milestone create "Workspace audit log" "Private beta" --description "Ready for customer testing" | grep '^event=milestone '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project milestone create    # a project and name or milestone reference is required
- clor linear project milestone create "Workspace audit log" "Private beta" --target-date next-week    # dates use YYYY-MM-DD
</examples-bad>
</help>


<help command="clor linear project milestone delete">
<summary>Delete a project milestone</summary>
<usage>clor linear project milestone delete <MILESTONE></usage>

<output>text and jsonl emit one event=action record; json returns {id, action, success}</output>

<output-example format="json">
{
  "id": "0197a1b2-c3d4-7489-f012-def012345678",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear project milestone delete 0197a1b2-c3d4-7489-f012-def012345678    # delete by milestone ID
- clor linear project milestone delete 0197a1b2-c3d4-7489-f012-def012345678 --stdout-format json | jq .success    # check success
- clor linear project milestone delete 0197a1b2-c3d4-7489-f012-def012345678 | grep '^event=action '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project milestone delete    # a milestone reference is required
- clor linear project milestone delete approximate    # names must match exactly
</examples-bad>
</help>


<help command="clor linear project milestone list">
<summary>List milestones for a project</summary>
<usage>clor linear project milestone list <PROJECT> [flags]</usage>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit one event=milestone record; json returns {milestones, cursor?}</output>

<output-example format="json">
{
  "milestones": [
    {
      "id": "0197a1b2-c3d4-7489-f012-def012345678",
      "name": "Private beta",
      "project": {
        "name": "Workspace audit log"
      },
      "target_date": "2026-08-01"
    }
  ]
}
</output-example>

<examples-good>
- clor linear project milestone list "Workspace audit log"    # project milestones
- clor linear project milestone list "Workspace audit log" --stdout-format json | jq '.milestones[].target_date'    # target dates as JSON
- clor linear project milestone list "Workspace audit log" | grep '^event=milestone '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project milestone list    # a project reference is required
- clor linear project milestone list "Workspace audit log" --limit 0    # limit must be positive
</examples-bad>
</help>


<help command="clor linear project milestone show">
<summary>Show one milestone</summary>
<usage>clor linear project milestone show <MILESTONE> [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --project string: project ID, URL, key, or exact name used to disambiguate
</flags>

<output>text and jsonl emit concise event=milestone records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "id": "0197a1b2-c3d4-7489-f012-def012345678",
  "name": "Private beta",
  "project": {
    "name": "Workspace audit log"
  },
  "target_date": "2026-08-01"
}
</output-example>

<examples-good>
- clor linear milestone show "Private beta"    # typed milestone output
- clor linear milestone show "Private beta" --stdout-format json | jq .    # normalized JSON output
- clor linear milestone show "Private beta" | grep '^event=milestone '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear milestone show approximate    # names must match exactly
- clor linear milestone show    # a reference is required
</examples-bad>
</help>


<help command="clor linear project milestone update">
<summary>Update a project milestone</summary>
<usage>clor linear project milestone update <MILESTONE> [flags]</usage>

<flags>
- --clear-description bool: clear the description
- --clear-target-date bool: clear the target date
- --description string: Markdown milestone description
- --description-file string: file containing the Markdown description, or - for stdin
- --name string: new milestone name
- --project string: new project ID, URL, or exact name
- --target-date string: target date (YYYY-MM-DD)
</flags>

<output>text and jsonl emit one event=milestone record; json returns the normalized milestone</output>

<output-example format="json">
{
  "id": "0197a1b2-c3d4-7489-f012-def012345678",
  "name": "Private beta",
  "project": {
    "name": "Workspace audit log"
  },
  "target_date": "2026-08-01"
}
</output-example>

<examples-good>
- clor linear project milestone update 0197a1b2-c3d4-7489-f012-def012345678 --target-date 2026-08-01    # milestone target date
- clor linear project milestone update 0197a1b2-c3d4-7489-f012-def012345678 --description-file milestone.md --stdout-format json | jq .id    # Markdown and JSON
- clor linear project milestone update 0197a1b2-c3d4-7489-f012-def012345678 --description "Ready for customer testing" | grep '^event=milestone '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project milestone update    # a project and name or milestone reference is required
- clor linear project milestone update 0197a1b2-c3d4-7489-f012-def012345678 --target-date next-week    # dates use YYYY-MM-DD
</examples-bad>
</help>


<help command="clor linear project progress">
<summary>Read and change project progress updates</summary>
<description>Use when:
  - the user needs Linear progress records</description>
<usage>clor linear project progress</usage>

<uses>
- the user needs project status updates, health, or progress history
</uses>

<rules>
- delete uses the recoverable archive operation because permanent progress-update deletion is deprecated
</rules>

<subcommands>
- archive: Archive a project progress update
- create: Create a project progress update
- delete: Remove a project progress update recoverably
- list: List progress updates for a project
- unarchive: Unarchive a project progress update
- update: Update a project progress update
</subcommands>
</help>


<help command="clor linear project progress archive">
<summary>Archive a project progress update</summary>
<usage>clor linear project progress archive <PROGRESS></usage>

<rules>
- delete is recoverable and uses Linear's nondeprecated archive operation
</rules>

<output>text and jsonl emit one event=action record; json returns {id, action, success}</output>

<output-example format="json">
{
  "id": "0197b2c3-d4e5-7590-a123-ef0123456789",
  "action": "archive",
  "success": true
}
</output-example>

<examples-good>
- clor linear project progress archive 0197b2c3-d4e5-7590-a123-ef0123456789    # act by progress update ID
- clor linear project progress archive 0197b2c3-d4e5-7590-a123-ef0123456789 --stdout-format json | jq .success    # check success
- clor linear project progress archive 0197b2c3-d4e5-7590-a123-ef0123456789 | grep '^event=action '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project progress archive    # a progress update ID is required
- clor linear project progress archive approximate    # references are exact
</examples-bad>
</help>


<help command="clor linear project progress create">
<summary>Create a project progress update</summary>
<usage>clor linear project progress create <PROJECT> [BODY] [flags]</usage>

<rules>
- health maps on-track, at-risk, and off-track to Linear's typed enum
- Markdown can be inline or read from --body-file
</rules>

<flags>
- --body-file string: file containing the Markdown body, or - for stdin
- --health string: project health (on-track|at-risk|off-track)
</flags>

<output>text and jsonl emit one event=progress record; json returns the normalized progress update</output>

<output-example format="json">
{
  "body": "API and event storage are complete. UI review starts next.",
  "created": "2026-07-21T10:00:00Z",
  "health": "onTrack",
  "id": "0197b2c3-d4e5-7590-a123-ef0123456789",
  "project": {
    "name": "Workspace audit log"
  }
}
</output-example>

<examples-good>
- clor linear project progress create "Workspace audit log" "API and storage are complete." --health on-track    # body and health
- clor linear project progress create "Workspace audit log" --body-file update.md --stdout-format json | jq .health    # Markdown file and JSON
- clor linear project progress create "Workspace audit log" "UI review starts next." | grep '^event=progress '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project progress create "Workspace audit log" --health green    # health must use a documented value
- clor linear project progress create "Workspace audit log" "text" --body-file update.md    # inline and file bodies are mutually exclusive
</examples-bad>
</help>


<help command="clor linear project progress delete">
<summary>Remove a project progress update recoverably</summary>
<usage>clor linear project progress delete <PROGRESS></usage>

<rules>
- delete is recoverable and uses Linear's nondeprecated archive operation
</rules>

<output>text and jsonl emit one event=action record; json returns {id, action, success}</output>

<output-example format="json">
{
  "id": "0197b2c3-d4e5-7590-a123-ef0123456789",
  "action": "delete",
  "success": true
}
</output-example>

<examples-good>
- clor linear project progress delete 0197b2c3-d4e5-7590-a123-ef0123456789    # act by progress update ID
- clor linear project progress delete 0197b2c3-d4e5-7590-a123-ef0123456789 --stdout-format json | jq .success    # check success
- clor linear project progress delete 0197b2c3-d4e5-7590-a123-ef0123456789 | grep '^event=action '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project progress delete    # a progress update ID is required
- clor linear project progress delete approximate    # references are exact
</examples-bad>
</help>


<help command="clor linear project progress list">
<summary>List progress updates for a project</summary>
<usage>clor linear project progress list <PROJECT> [flags]</usage>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit one event=progress record; json returns {progress_updates, cursor?}</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "progress_updates": [
    {
      "body": "API and event storage are complete. UI review starts next.",
      "created": "2026-07-21T10:00:00Z",
      "health": "onTrack",
      "id": "0197b2c3-d4e5-7590-a123-ef0123456789",
      "project": {
        "name": "Workspace audit log"
      }
    }
  ]
}
</output-example>

<examples-good>
- clor linear project progress list "Workspace audit log"    # project update history
- clor linear project progress list "Workspace audit log" --stdout-format json | jq '.progress_updates[].health'    # health values as JSON
- clor linear project progress list "Workspace audit log" --ordering updated | grep '^event=progress '    # recently edited updates
</examples-good>

<examples-bad>
- clor linear project progress list    # a project reference is required
- clor linear project progress list "Workspace audit log" --limit 0    # limit must be positive
</examples-bad>
</help>


<help command="clor linear project progress unarchive">
<summary>Unarchive a project progress update</summary>
<usage>clor linear project progress unarchive <PROGRESS></usage>

<rules>
- delete is recoverable and uses Linear's nondeprecated archive operation
</rules>

<output>text and jsonl emit one event=action record; json returns {id, action, success}</output>

<output-example format="json">
{
  "id": "0197b2c3-d4e5-7590-a123-ef0123456789",
  "action": "unarchive",
  "success": true
}
</output-example>

<examples-good>
- clor linear project progress unarchive 0197b2c3-d4e5-7590-a123-ef0123456789    # act by progress update ID
- clor linear project progress unarchive 0197b2c3-d4e5-7590-a123-ef0123456789 --stdout-format json | jq .success    # check success
- clor linear project progress unarchive 0197b2c3-d4e5-7590-a123-ef0123456789 | grep '^event=action '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project progress unarchive    # a progress update ID is required
- clor linear project progress unarchive approximate    # references are exact
</examples-bad>
</help>


<help command="clor linear project progress update">
<summary>Update a project progress update</summary>
<usage>clor linear project progress update <PROGRESS> [BODY] [flags]</usage>

<rules>
- health maps on-track, at-risk, and off-track to Linear's typed enum
- Markdown can be inline or read from --body-file
</rules>

<flags>
- --body-file string: file containing the Markdown body, or - for stdin
- --clear-body bool: clear the progress body
- --health string: project health (on-track|at-risk|off-track)
</flags>

<output>text and jsonl emit one event=progress record; json returns the normalized progress update</output>

<output-example format="json">
{
  "body": "API and event storage are complete. UI review starts next.",
  "created": "2026-07-21T10:00:00Z",
  "health": "onTrack",
  "id": "0197b2c3-d4e5-7590-a123-ef0123456789",
  "project": {
    "name": "Workspace audit log"
  }
}
</output-example>

<examples-good>
- clor linear project progress update 0197b2c3-d4e5-7590-a123-ef0123456789 "API and storage are complete." --health on-track    # body and health
- clor linear project progress update 0197b2c3-d4e5-7590-a123-ef0123456789 --body-file update.md --stdout-format json | jq .health    # Markdown file and JSON
- clor linear project progress update 0197b2c3-d4e5-7590-a123-ef0123456789 "UI review starts next." | grep '^event=progress '    # default logfmt
</examples-good>

<examples-bad>
- clor linear project progress update 0197b2c3-d4e5-7590-a123-ef0123456789 --health green    # health must use a documented value
- clor linear project progress update 0197b2c3-d4e5-7590-a123-ef0123456789 "text" --body-file update.md    # inline and file bodies are mutually exclusive
</examples-bad>
</help>


<help command="clor linear project show">
<summary>Show one project</summary>
<usage>clor linear project show <PROJECT></usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<output>text and jsonl emit concise event=project records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "health": "onTrack",
  "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
  "name": "Workspace audit log",
  "slug_id": "workspace-audit-log-8f2d",
  "target_date": "2026-08-15",
  "url": "https://linear.app/acme/project/workspace-audit-log-8f2d"
}
</output-example>

<examples-good>
- clor linear project show "Workspace audit log"    # typed project output
- clor linear project show "Workspace audit log" --stdout-format json | jq .    # normalized JSON output
- clor linear project show "Workspace audit log" | grep '^event=project '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear project show approximate    # names must match exactly
- clor linear project show    # a reference is required
</examples-bad>
</help>


<help command="clor linear project unarchive">
<summary>Restore a trashed or archived project</summary>
<usage>clor linear project unarchive <PROJECT></usage>

<output>text and jsonl emit one event=action record; json returns id, action, and success</output>

<output-example format="json">
{
  "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
  "action": "unarchive",
  "success": true
}
</output-example>

<examples-good>
- clor linear project unarchive "Workspace audit log"    # act on an exact reference
- clor linear project unarchive 0197d2e3-f4a5-7b90-c123-456789abcdef --stdout-format json | jq .success    # check the action result
- clor linear project unarchive "Workspace audit log" | grep '^event=action '    # default logfmt output
</examples-good>

<examples-bad>
- clor linear project unarchive    # a resource reference is required
- clor linear project unarchive approximate-name    # references are exact, never fuzzy
</examples-bad>
</help>


<help command="clor linear project update">
<summary>Update a project with explicit set and clear operations</summary>
<usage>clor linear project update <PROJECT> [flags]</usage>

<rules>
- at least one field must change
- a field cannot be set and cleared together
- --member replaces the project member set and is repeatable
</rules>

<flags>
- --clear-content bool: clear the Markdown content
- --clear-description bool: clear the description
- --clear-lead bool: clear the project lead
- --clear-members bool: remove all project members
- --clear-priority bool: set no priority
- --clear-start-date bool: clear the start date
- --clear-status bool: clear the project status
- --clear-target-date bool: clear the target date
- --content string: Markdown project content
- --content-file string: file containing Markdown project content, or - for stdin
- --description string: project description
- --lead string: lead ID, email, me, or exact name
- --member stringArray: member ID, email, me, or exact name, repeatable (default "[]")
- --name string: new project name
- --priority string: project priority (no-priority|urgent|high|medium|low)
- --start-date string: start date (YYYY-MM-DD)
- --status string: project status ID or exact name
- --target-date string: target date (YYYY-MM-DD)
- --team stringArray: team ID, URL, key, or exact name, repeatable (default "[]")
</flags>

<output>text and jsonl emit one event=project record; json returns the normalized project</output>

<output-example format="json">
{
  "health": "onTrack",
  "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
  "name": "Workspace audit log",
  "slug_id": "workspace-audit-log-8f2d",
  "target_date": "2026-08-15",
  "url": "https://linear.app/acme/project/workspace-audit-log-8f2d"
}
</output-example>

<examples-good>
- clor linear project update "Workspace audit log" --priority high --lead me    # priority and lead
- clor linear project update "Workspace audit log" --content-file plan.md --stdout-format json | jq .updated    # Markdown file and JSON
- clor linear project update "Workspace audit log" --clear-target-date | grep '^event=project '    # explicit clear
</examples-good>

<examples-bad>
- clor linear project update "Workspace audit log"    # at least one change is required
- clor linear project update "Workspace audit log" --lead me --clear-lead    # a field cannot be set and cleared together
</examples-bad>
</help>

<help command="clor linear search">
<summary>Search Linear issues, projects, or documents</summary>
<usage>clor linear search <QUERY> [flags]</usage>

<rules>
- search uses Linear's current searchIssues, searchProjects, and searchDocuments operations
- each request fetches at most 50 records and follows Relay cursors until --limit is reached
</rules>

<flags>
- --comments bool: search associated comments
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived resources
- --limit int: maximum records to return (default "50")
- --ordering string: search ordering (relevance|created|updated) (default "relevance")
- --team-boost string: team ID, URL, key, or exact name to boost
- --type string: resource type (issue|project|document) (default "issue")
</flags>

<output>text emits one event=search summary and one event=item line per match; jsonl uses the same events; json returns query, type, items, and an optional cursor</output>

<output-example format="json">
{
  "query": "audit log",
  "type": "issue",
  "items": [
    {
      "created": "2026-07-18T09:30:00Z",
      "id": "0197c1d2-e3f4-7a89-b012-3456789abcde",
      "identifier": "ENG-482",
      "priority": 2,
      "state": {
        "id": "0197d2e3-f4a5-7b90-c123-456789abcdef",
        "name": "In Progress"
      },
      "title": "Ship workspace audit log",
      "updated": "2026-07-21T11:45:00Z",
      "url": "https://linear.app/acme/issue/ENG-482/ship-workspace-audit-log"
    }
  ],
  "cursor": "2f07f96a"
}
</output-example>

<examples-good>
- clor linear search "audit log" --team-boost ENG --comments    # issue search with comments and a team boost
- clor linear search "quarterly planning" --type project --stdout-format json | jq '.items[].url'    # project URLs as JSON
- clor linear search "rollout plan" --type document --ordering updated | grep '^event=item '    # recently updated documents
</examples-good>

<examples-bad>
- clor linear search "audit log" --type ticket    # type must be issue, project, or document
- clor linear search "audit log" --limit 0    # limit must be positive
</examples-bad>
</help>

<help command="clor linear state">
<summary>List and show Linear workflow states</summary>
<usage>clor linear state</usage>

<uses>
- the user needs Linear state records
</uses>

<subcommands>
- list: List states
- show: Show one state
</subcommands>
</help>


<help command="clor linear state list">
<summary>List states</summary>
<usage>clor linear state list [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
- --team string: team ID, URL, key, or exact name
</flags>

<output>text and jsonl emit concise event=state records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "states": [
    {
      "color": "#F2C94C",
      "id": "0197e9f0-a1b2-7267-d890-bcdef0123456",
      "name": "In Progress",
      "team": {
        "key": "ENG"
      },
      "type": "started"
    }
  ]
}
</output-example>

<examples-good>
- clor linear state list    # typed state output
- clor linear state list --stdout-format json | jq .    # normalized JSON output
- clor linear state list | grep '^event=state '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear state list approximate    # names must match exactly
- clor linear state list --limit 0    # limits must be positive
</examples-bad>
</help>


<help command="clor linear state show">
<summary>Show one state</summary>
<usage>clor linear state show <STATE> [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --team string: team ID, URL, key, or exact name used to disambiguate
</flags>

<output>text and jsonl emit concise event=state records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "color": "#F2C94C",
  "id": "0197e9f0-a1b2-7267-d890-bcdef0123456",
  "name": "In Progress",
  "team": {
    "key": "ENG"
  },
  "type": "started"
}
</output-example>

<examples-good>
- clor linear state show "In Progress"    # typed state output
- clor linear state show "In Progress" --stdout-format json | jq .    # normalized JSON output
- clor linear state show "In Progress" | grep '^event=state '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear state show approximate    # names must match exactly
- clor linear state show    # a reference is required
</examples-bad>
</help>

<help command="clor linear team">
<summary>List and show Linear teams</summary>
<usage>clor linear team</usage>

<uses>
- the user needs Linear team records
</uses>

<subcommands>
- list: List teams
- show: Show one team
</subcommands>
</help>


<help command="clor linear team list">
<summary>List teams</summary>
<usage>clor linear team list [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit concise event=team records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "teams": [
    {
      "id": "0197c7d8-e9f0-7045-b678-9abcdef01234",
      "key": "ENG",
      "name": "Engineering"
    }
  ]
}
</output-example>

<examples-good>
- clor linear team list    # typed team output
- clor linear team list --stdout-format json | jq .    # normalized JSON output
- clor linear team list | grep '^event=team '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear team list approximate    # names must match exactly
- clor linear team list --limit 0    # limits must be positive
</examples-bad>
</help>


<help command="clor linear team show">
<summary>Show one team</summary>
<usage>clor linear team show <TEAM></usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<output>text and jsonl emit concise event=team records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "id": "0197c7d8-e9f0-7045-b678-9abcdef01234",
  "key": "ENG",
  "name": "Engineering"
}
</output-example>

<examples-good>
- clor linear team show ENG    # typed team output
- clor linear team show ENG --stdout-format json | jq .    # normalized JSON output
- clor linear team show ENG | grep '^event=team '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear team show approximate    # names must match exactly
- clor linear team show    # a reference is required
</examples-bad>
</help>

<help command="clor linear user">
<summary>List and show Linear workspace users</summary>
<usage>clor linear user</usage>

<uses>
- the user needs Linear user records
</uses>

<subcommands>
- list: List users
- show: Show one user
</subcommands>
</help>


<help command="clor linear user list">
<summary>List users</summary>
<usage>clor linear user list [flags]</usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<flags>
- --cursor string: Relay cursor to continue after
- --include-archived bool: include archived records
- --limit int: maximum records to return (default "50")
- --ordering string: pagination ordering (created|updated) (default "created")
</flags>

<output>text and jsonl emit concise event=user records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "cursor": "2f07f96a",
  "users": [
    {
      "active": true,
      "display_name": "Alex",
      "email": "alex@example.com",
      "id": "0197d8e9-f0a1-7156-c789-abcdef012345",
      "name": "Alex Rivera"
    }
  ]
}
</output-example>

<examples-good>
- clor linear user list    # typed user output
- clor linear user list --stdout-format json | jq .    # normalized JSON output
- clor linear user list | grep '^event=user '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear user list approximate    # names must match exactly
- clor linear user list --limit 0    # limits must be positive
</examples-bad>
</help>


<help command="clor linear user show">
<summary>Show one user</summary>
<usage>clor linear user show <USER></usage>

<rules>
- references accept IDs, Linear URLs, and exact case-insensitive names; fuzzy matching is never used
</rules>

<output>text and jsonl emit concise event=user records; json uses normalized snake-case fields</output>

<output-example format="json">
{
  "active": true,
  "display_name": "Alex",
  "email": "alex@example.com",
  "id": "0197d8e9-f0a1-7156-c789-abcdef012345",
  "name": "Alex Rivera"
}
</output-example>

<examples-good>
- clor linear user show alex@example.com    # typed user output
- clor linear user show alex@example.com --stdout-format json | jq .    # normalized JSON output
- clor linear user show alex@example.com | grep '^event=user '    # default logfmt records
</examples-good>

<examples-bad>
- clor linear user show approximate    # names must match exactly
- clor linear user show    # a reference is required
</examples-bad>
</help>

<help command="clor linear whoami">
<summary>Show the authenticated Linear user</summary>
<usage>clor linear whoami</usage>

<output>text and jsonl emit one event=user record; json returns the normalized user</output>

<output-example format="json">
{
  "active": true,
  "display_name": "Alex",
  "email": "alex@example.com",
  "id": "0197d8e9-f0a1-7156-c789-abcdef012345",
  "name": "Alex Rivera"
}
</output-example>

<examples-good>
- clor linear whoami    # the selected workspace identity
- clor linear whoami --stdout-format json | jq '{id, name, email}'    # normalized identity fields
- clor linear whoami | grep '^event=user '    # default logfmt record
</examples-good>

<examples-bad>
- clor linear whoami me    # whoami takes no arguments
- clor linear whoami --connection workspace-name    # connection takes an ID from clor connection list
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.
