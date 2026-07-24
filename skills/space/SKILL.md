---
name: space
description: Coding-agent environments in Docker containers called spaces. Use when the user wants to create, list, open, stop, resume, move, rename, or delete a space, or run a coding session, hosted service, or unattended agent in one.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Spaces reference

<help command="clor space">
<summary>Create, list, stop, resume, and delete spaces on your nodes</summary>
<description>A space is a long-lived instance bound to one of your nodes: a
coding session, a hosted service, or an unattended agent. The daemon on
the node brings each one up wholly and keeps it converged. This tree
creates spaces from a config, lists and inspects them, stops and
resumes them, renames them, and deletes them.

Use when
  - the user wants to start a space on one of their nodes from a config
  - the user asks what spaces are running or wants a space's URLs
  - the user wants to stop, resume, rename, or delete a space

Subcommands
  list      List every space you own (with node and running status)
  show      Show one space by its id (with its tab URLs)
  create    Create a space on a node from a config
  rename    Rename a space
  stop      Stop a space so the daemon suspends it
  resume    Resume a stopped space
  delete    Delete a space
  config    Discover the configs a space can be created from

Output supports --stdout-format text|jsonl|json on every subcommand (default
text, logfmt with event= leader).</description>
<usage>clor space [flags]</usage>

<uses>
- the user wants to create, list, stop, resume, rename, or delete a space on one of their nodes
- the user asks which spaces are running or wants a space's tab URLs
</uses>

<subcommands>
- config: Discover the configs a space can be created from
- create: Create a space on a node from a config
- delete: Delete a space
- list: List every space you own
- move: Move a space to another of your nodes
- rename: Rename a space
- resume: Resume a stopped space
- show: Show one space by its id
- stop: Stop a space so the daemon suspends it
</subcommands>

<flags>
- --help bool: help for space
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


<help command="clor space config">
<summary>Discover the configs a space can be created from</summary>
<description>The gallery of configs a space is created from. Each config has a
slug the create command's --config flag accepts, plus a label, icon,
description, and category.

Use when
  - the user asks which configs or kinds of space they can create
  - you need a valid --config slug before running space create

Subcommands
  list    List every config available to create from

Output supports --stdout-format text|jsonl|json on every subcommand (default
text, logfmt with event= leader).</description>
<usage>clor space config</usage>

<uses>
- the user asks which configs or space kinds they can create
- you need a valid --config slug before running `clor space create`
</uses>

<subcommands>
- list: List every config available to create from
</subcommands>
</help>


<help command="clor space config list">
<summary>List every config available to create from</summary>
<usage>clor space config list</usage>

<output>json outputs the whole envelope {configs[]}. jsonl outputs each config on its own line; text is an event=list header line then one event=result line per config (slug, label, category, description).</output>

<output-example format="json">
{
  "configs": [
    {
      "category": "General",
      "description": "A plain shell on the node",
      "icon": "mdi:console",
      "label": "Shell",
      "slug": "shell"
    },
    {
      "category": "Agents",
      "description": "A coding agent in the home directory",
      "icon": "mdi:robot",
      "label": "Chat",
      "slug": "chat"
    }
  ]
}
</output-example>

<examples-good>
- clor space config list    # one row per config with its --config slug
- clor space config list | grep '^event=result '    # default logfmt rows, one per config
- clor space config list --stdout-format json | jq -r '.configs[].slug'    # just the slugs, one per line, to feed space create --config
</examples-good>

<examples-bad>
- clor space config list extra-arg    # no positional args
- clor space config list --stdout-format yaml    # only text, jsonl, json supported
</examples-bad>
</help>

<help command="clor space create">
<summary>Create a space on a node from a config</summary>
<usage>clor space create --node <NODE> --config <SLUG> [flags]</usage>

<flags>
- --archive-script string: an archive script replacing the config's for this space
- --config string: the config slug to instantiate; mutually exclusive with --config-file
- --config-file string: path to an authored config TOML file; mutually exclusive with --config
- --directory string: an existing host directory overriding the config's directory preset
- --env stringArray: a create-time env value as KEY=VALUE; repeatable (default "[]")
- --home bool: use the node user's home directory
- --name string: a display name; derived from the prompt or config when empty
- --node string: the node to create the space on, by its id (required)
- --preset stringArray: a terminal preset choice as TABSLUG=PRESET; repeatable (default "[]")
- --prompt string: an initial prompt, compiled into the space as CLOR_INITIAL_PROMPT
- --repository string: a clone URL overriding the config's repository preset
- --repository-connection string: the connected GitHub account for the repository, by its connection ID
- --setup-script string: a setup script replacing the config's for this space
</flags>

<output>json outputs the created space object {id, name, node_id, node_name, status, ...}. jsonl outputs it on one line; text is an event=created line with id, name, node_id, node_name, and status.</output>

<output-example format="json">
{
  "activity": "",
  "activity_detail": "",
  "created": "0001-01-01T00:00:00Z",
  "icon": "",
  "id": "01930000-0000-7000-8000-000000000001",
  "name": "api refactor",
  "node_id": "01930000-0000-7000-8000-0000000000aa",
  "node_name": "jake-mbp",
  "status": "pending",
  "status_detail": "",
  "status_reason": "",
  "tabs": [],
  "updated": "0001-01-01T00:00:00Z"
}
</output-example>

<examples-good>
- clor space create --node 01930000-0000-7000-8000-0000000000aa --config shell --name "api refactor"    # create a shell space on a node from a stored config
- clor space create --node 01930000-0000-7000-8000-0000000000aa --config chat --prompt "review the auth module" --stdout-format json | jq .id    # create from a config with an initial prompt, capturing the new id
- clor space create --node 01930000-0000-7000-8000-0000000000aa --config-file ./space.toml --env API_TOKEN=abc123 --repository https://github.com/me/app    # create from an authored config file with an env value and a clone URL
</examples-good>

<examples-bad>
- clor space create --config shell    # --node is required
- clor space create --node 01930000-0000-7000-8000-0000000000aa    # one of --config or --config-file is required
- clor space create --node 01930000-0000-7000-8000-0000000000aa --config shell --config-file ./space.toml    # --config and --config-file are mutually exclusive
</examples-bad>
</help>

<help command="clor space delete">
<summary>Delete a space</summary>
<usage>clor space delete <SPACE></usage>

<output>json outputs the whole object {deleted, id, name}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "deleted": true,
  "id": "01930000-0000-7000-8000-000000000001",
  "name": "api refactor"
}
</output-example>

<examples-good>
- clor space delete 01930000-0000-7000-8000-000000000001    # delete a specific space by id
- clor space delete 01930000-0000-7000-8000-000000000001 --stdout-format json | jq .deleted    # confirm the deletion from the returned object
- clor space delete 01930000-0000-7000-8000-000000000001 --stdout-format json | jq .id    # capture the deleted space id
</examples-good>

<examples-bad>
- clor space delete    # the space id is required
- clor space delete one two    # exactly one argument
</examples-bad>
</help>

<help command="clor space list">
<summary>List every space you own</summary>
<usage>clor space list</usage>

<output>json outputs the whole envelope {spaces[]}. jsonl outputs each record from spaces on its own line; text is the logfmt of the same keys, an event=list header line then one event=result line per record (id, name, node_id, node_name, status, running).</output>

<output-example format="json">
{
  "spaces": [
    {
      "activity": "",
      "activity_detail": "",
      "created": "2026-07-12T09:00:00Z",
      "icon": "mdi:application-outline",
      "id": "01930000-0000-7000-8000-000000000001",
      "name": "api refactor",
      "node_id": "01930000-0000-7000-8000-0000000000aa",
      "node_name": "jake-mbp",
      "status": "running",
      "status_detail": "",
      "status_reason": "",
      "tabs": [],
      "updated": "2026-07-12T09:05:00Z"
    },
    {
      "activity": "",
      "activity_detail": "",
      "created": "2026-07-10T08:00:00Z",
      "icon": "mdi:application-outline",
      "id": "01930000-0000-7000-8000-000000000002",
      "name": "nightly report",
      "node_id": "01930000-0000-7000-8000-0000000000bb",
      "node_name": "build-runner",
      "status": "stopped",
      "status_detail": "",
      "status_reason": "",
      "stopped": "2026-07-13T18:30:00Z",
      "tabs": [],
      "updated": "2026-07-13T18:30:00Z"
    }
  ]
}
</output-example>

<examples-good>
- clor space list    # one row per space with node and running=true|false
- clor space list | grep '^event=result '    # default logfmt rows, one per space
- clor space list --stdout-format json | jq '.spaces[] | select(.stopped == null) | {name, node_name}'    # json projection of the running spaces (no stopped timestamp)
</examples-good>

<examples-bad>
- clor space list extra-arg    # no positional args
- clor space list --stdout-format yaml    # only text, jsonl, json supported
</examples-bad>
</help>

<help command="clor space move">
<summary>Move a space to another of your nodes</summary>
<usage>clor space move <SPACE> --node <NODE> [flags]</usage>

<flags>
- --node string: the node to move the space to, by its id (required)
</flags>

<output>json outputs the moved space object. jsonl outputs it on one line; text is an event=moved line with id, name, node_id, node_name, and status.</output>

<output-example format="json">
{
  "activity": "",
  "activity_detail": "",
  "created": "0001-01-01T00:00:00Z",
  "icon": "",
  "id": "01930000-0000-7000-8000-000000000001",
  "name": "api refactor",
  "node_id": "01930000-0000-7000-8000-0000000000bb",
  "node_name": "build-runner",
  "status": "pending",
  "status_detail": "",
  "status_reason": "",
  "tabs": [],
  "updated": "0001-01-01T00:00:00Z"
}
</output-example>

<examples-good>
- clor space move 01930000-0000-7000-8000-000000000001 --node 01930000-0000-7000-8000-0000000000bb    # move a space to another node, both by id
- clor space move 01930000-0000-7000-8000-000000000001 --node 01930000-0000-7000-8000-0000000000bb --stdout-format json | jq .node_name    # confirm the new node from the returned object
- clor space move 01930000-0000-7000-8000-000000000001 --node 01930000-0000-7000-8000-0000000000bb --stdout-format json | jq .status    # capture the space's new status after the move
</examples-good>

<examples-bad>
- clor space move 01930000-0000-7000-8000-000000000001    # --node is required
- clor space move --node 01930000-0000-7000-8000-0000000000bb    # the space id argument is required
</examples-bad>
</help>

<help command="clor space rename">
<summary>Rename a space</summary>
<usage>clor space rename <SPACE> --name <NAME> [flags]</usage>

<flags>
- --name string: the new display name (required)
</flags>

<output>json outputs the renamed space object. jsonl outputs it on one line; text is an event=renamed line with id, name, node_id, and node_name.</output>

<output-example format="json">
{
  "activity": "",
  "activity_detail": "",
  "created": "0001-01-01T00:00:00Z",
  "icon": "",
  "id": "01930000-0000-7000-8000-000000000001",
  "name": "api rewrite",
  "node_id": "01930000-0000-7000-8000-0000000000aa",
  "node_name": "jake-mbp",
  "status": "",
  "status_detail": "",
  "status_reason": "",
  "tabs": [],
  "updated": "0001-01-01T00:00:00Z"
}
</output-example>

<examples-good>
- clor space rename 01930000-0000-7000-8000-000000000001 --name "api rewrite"    # rename a space by its id
- clor space rename 01930000-0000-7000-8000-000000000001 --name "api rewrite" --stdout-format json | jq .name    # confirm the new name from the returned object
- clor space rename 01930000-0000-7000-8000-000000000001 --name "nightly report"    # give a space a clearer display name
</examples-good>

<examples-bad>
- clor space rename 01930000-0000-7000-8000-000000000001    # --name is required
- clor space rename --name "api rewrite"    # the space id is required
</examples-bad>
</help>

<help command="clor space resume">
<summary>Resume a stopped space</summary>
<usage>clor space resume <SPACE></usage>

<output>json outputs the resumed space object, whose stopped timestamp is now cleared. jsonl outputs it on one line; text is an event=resumed line with id, name, node_id, and node_name.</output>

<output-example format="json">
{
  "activity": "",
  "activity_detail": "",
  "created": "0001-01-01T00:00:00Z",
  "icon": "",
  "id": "01930000-0000-7000-8000-000000000001",
  "name": "api refactor",
  "node_id": "01930000-0000-7000-8000-0000000000aa",
  "node_name": "jake-mbp",
  "status": "running",
  "status_detail": "",
  "status_reason": "",
  "tabs": [],
  "updated": "0001-01-01T00:00:00Z"
}
</output-example>

<examples-good>
- clor space resume 01930000-0000-7000-8000-000000000002    # resume by id; the daemon brings it back up on its next poll
- clor space resume 01930000-0000-7000-8000-000000000002 --stdout-format json | jq .stopped    # confirm the stop timestamp is cleared (null)
- clor space resume 01930000-0000-7000-8000-000000000002 --stdout-format json | jq .status    # capture the space's status after resuming
</examples-good>

<examples-bad>
- clor space resume    # the space id is required
- clor space resume one two    # exactly one argument
</examples-bad>
</help>

<help command="clor space show">
<summary>Show one space by its id</summary>
<usage>clor space show <SPACE></usage>

<output>json outputs the whole space object {id, name, node_id, node_name, status, status_reason, status_detail, stopped, reported, created, updated, sandbox, tabs}. jsonl outputs the same object on one line; text is the logfmt of the space plus one event=tab line per tab with its slug and public url.</output>

<output-example format="json">
{
  "activity": "",
  "activity_detail": "",
  "created": "2026-07-12T09:00:00Z",
  "icon": "mdi:application-outline",
  "id": "01930000-0000-7000-8000-000000000001",
  "name": "api refactor",
  "node_id": "01930000-0000-7000-8000-0000000000aa",
  "node_name": "jake-mbp",
  "sandbox": {
    "image": "ghcr.io/clorhq/space:latest",
    "isolation": "standard",
    "runtime_identifier": "docker"
  },
  "status": "running",
  "status_detail": "",
  "status_reason": "",
  "tabs": [
    {
      "label": "Claude",
      "pane": "agent",
      "port": 4000,
      "public_url": "https://agent-01930000.clor.host",
      "slug": "agent",
      "type": "web"
    },
    {
      "label": "Preview",
      "pane": "preview",
      "port": 3000,
      "public_url": "https://preview-01930000.clor.host",
      "slug": "preview",
      "type": "web"
    }
  ],
  "updated": "2026-07-12T09:05:00Z"
}
</output-example>

<examples-good>
- clor space show 01930000-0000-7000-8000-000000000001    # look up by id; logfmt shows status plus one event=tab line per tab URL
- clor space show 01930000-0000-7000-8000-000000000001 --stdout-format json | jq '.tabs[] | {slug, url: .public_url}'    # json projection of each tab's slug and public URL
- clor space show 01930000-0000-7000-8000-000000000001 --stdout-format json | jq .status    # capture the space's reported status
</examples-good>

<examples-bad>
- clor space show    # the space id is required
- clor space show api-refactor    # reference a space by its id, not its name; run `clor space list`
</examples-bad>
</help>

<help command="clor space stop">
<summary>Stop a space so the daemon suspends it</summary>
<usage>clor space stop <SPACE></usage>

<output>json outputs the stopped space object, whose stopped timestamp is now set. jsonl outputs it on one line; text is an event=stopped line with id, name, node_id, and node_name.</output>

<output-example format="json">
{
  "activity": "",
  "activity_detail": "",
  "created": "0001-01-01T00:00:00Z",
  "icon": "",
  "id": "01930000-0000-7000-8000-000000000001",
  "name": "api refactor",
  "node_id": "01930000-0000-7000-8000-0000000000aa",
  "node_name": "jake-mbp",
  "status": "running",
  "status_detail": "",
  "status_reason": "",
  "stopped": "2026-07-15T12:00:00Z",
  "tabs": [],
  "updated": "0001-01-01T00:00:00Z"
}
</output-example>

<examples-good>
- clor space stop 01930000-0000-7000-8000-000000000001    # stop by id; the daemon suspends it on its next poll
- clor space stop 01930000-0000-7000-8000-000000000001 --stdout-format json | jq .stopped    # confirm the stop timestamp is set
- clor space stop 01930000-0000-7000-8000-000000000001 --stdout-format json | jq .status    # capture the space's status after stopping
</examples-good>

<examples-bad>
- clor space stop    # the space id is required
- clor space stop one two    # exactly one argument
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

