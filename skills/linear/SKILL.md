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

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.
