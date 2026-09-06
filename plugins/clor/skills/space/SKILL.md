---
name: space
description: Task-aware coding-agent workspaces called spaces, running on a node or in a sandbox. Gather authoritative work context, split independent targets into separate spaces, infer repositories, select a fitting configuration, write self-contained prompts, launch concurrently, and verify lifecycle, credential, and tab readiness. Supports Linear and GitHub issues, repository tasks, websites, research, data analysis, documents, hosted services, and explicitly requested saved or Team configurations. Use when the user wants to launch, create, list, open, stop, resume, move, rename, or delete spaces, or turn one or more work requests into ready coding sessions.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Turn work into spaces

Treat an ordinary work request as enough input to prepare a space. Gather the
authoritative task context before launching, using the relevant skill or the
local repository already in scope. For example, read GitHub issues and pull
requests through the GitHub skill, inspect website or research inputs through
their owning skill, and inspect local repository files for repository work.
Gather only what the new agent needs to start without repeating discovery.

Linear issue identifiers in a space-launch request are work targets. Use the
Linear skill to read each existing issue, including its title, description,
discussion, project context, links, and repository hints that affect the work.
Do not treat an issue identifier as a space name, configuration, or repository.
Linear is one source of task context, not a requirement for launching spaces.

Honor any explicit number of spaces or grouping. Otherwise, make one space per
independent work unit so tasks can proceed in parallel. Two unrelated Linear
issues, GitHub issues, or repository tasks normally become two spaces. Keep
tightly coupled changes in one space when they must share a branch, design, or
working tree. If one target is inaccessible, continue preparing and launching
the independent targets that have usable context.

Choose the repository in this order: an explicit repository from the user, the
current repository when it matches the task, then an unambiguous repository
named by the task metadata. Ask one plain question only when multiple plausible
repositories remain. Use `--repository none` for work that genuinely has no
repository. An explicit repository always overrides inference.

## Selecting a configuration

Honor a configuration the user explicitly requests. Otherwise, pass
`code-workspace` explicitly for normal coding, debugging, review, refactoring,
command-line interface, backend, library, infrastructure, and general
repository work. Do not omit CONFIG for these launches because omission can
select the member's saved launcher default.

Choose another system configuration only when its environment strongly
matches the task.

- `remotion-video` for programmatic video
- `data-lab` for notebooks or data analysis
- `browser-desktop` for browser-driven research
- `markdown-editor` for viewing-first document work

Treat terminal user interface, shell, and experimental multi-agent
configurations as opt-in interaction models. Use them only when the user asks
for one. Do not list the configuration library before a routine launch. Run
`clor space config list` when the user asks what is available, requests a saved
or Team configuration, or no known system configuration fits.

## Name and prompt each space

When choosing a name for a launch or rename, use a concise Git-branch-style
name in lowercase kebab-case. Prefer two or three meaningful components. One is
enough when fully descriptive, and up to four is acceptable when clarity
requires it. Put the specific target first, followed by the action or outcome,
such as `sidebar-navigation-fix` or `billing-csv-export`. Exclude filler,
conversational phrasing, unnecessary repository prefixes, and generic terms
such as `task`, `work`, `space`, `change`, or `update`.

Build a self-contained initial prompt for each space rather than forwarding the
user's short request verbatim. Include the task reference, the authoritative
context you gathered, the selected repository, the requested outcome and
acceptance conditions, important constraints, and the collaboration mode.
State whether the space owns an independent work unit or is intentionally
coupled to another target. Do not assume the new agent can read the conversation
that launched it.

Use `--mode code` for implementation, debugging, review, and other ordinary
software work. Use `--mode plan` only when the user explicitly asks for
investigation or planning without implementation. An explicit mode always wins.

## Launch and verify

Leave the Claude and Codex configuration and credential flags unset so the
launcher resolves both runtimes through its defaults. A space configuration's
agent recommendation takes precedence, followed by the member's saved choice
and the shipped agent configuration. Credentials use the member's saved choice
or the launcher's deterministic fallback. If several choices exist, accept the
selected default instead of choosing one by its name. Never pass `none` for an
agent configuration or credential unless the user explicitly asks to disable
that attachment.

Also leave Node and agent runtime unset unless the user requests an override.
Use `clor space launch [CONFIG] --dry-run` to resolve Node, repository,
credential, environment, and secret questions before creation. The plan reports
the selected Node, Claude and Codex configurations, and credentials. Supply an
override only when the user requested one or the preflight reports a real
ambiguity. If either runtime has no selected configuration or credential,
report the gap and ask before launching without it. Never invent a reference.

Launch several spaces through independent concurrent invocations, one command
per space, using `clor space launch`, not the compatibility `create` workflow.
Preserve successful spaces when another launch fails, and report each success
and failure against its work target. Never delete a successful launch merely to
make a mixed batch look atomic.

After creation, poll `clor space show <SPACE> --stdout-format json`. Report a
space ready only after all three checks pass:

- lifecycle `status` is `ready`
- `agent.credential_state` is `available`
- an agent tab has a non-empty `public_url` and an HTTP request to that exact URL
  succeeds

Treat tab URLs as passwords because they can contain access tokens. Do not print
them in diagnostics beyond the concise final access link the user requested.
If a lifecycle failure, unavailable credential, inaccessible tab, or bounded
wait prevents a check from passing, report the space as launched but not ready
and explain the failing check.

## Spaces reference

<help command="clor space">
<summary>Launch, list, stop, resume, and delete spaces on your nodes</summary>
<description>A space is a long-lived instance bound to one of your nodes. It can
be a coding session, a hosted service, or an unattended agent. The daemon on
the node brings each one up wholly and keeps it converged. This tree
launches immutable snapshots from space configs, lists and inspects them,
stops and resumes them, renames them, and deletes them.

Start with
  clor space launch code-workspace --prompt "..."
  clor space launch code-workspace --repository OWNER/REPO --branch BRANCH --prompt "..."
  clor space launch code-workspace --dry-run

Use when
  - the user wants to launch a space from a space config or only a prompt
  - the user asks what spaces are running or wants a space's URLs
  - the user wants to stop, resume, rename, or delete a space

Subcommands
  launch    Launch a space from a selected configuration
  list      List every space you own (with node and running status)
  show      Show one space by its id (with its tab URLs)
  create    Create a space with the compatibility flag form
  rename    Rename a space
  stop      Stop a space so the daemon suspends it
  resume    Resume a stopped space
  delete    Delete a space

Output supports --stdout-format text|jsonl|json on every subcommand (default
text, logfmt with event= leader).</description>
<usage>clor space [flags]</usage>

<uses>
- the user wants to launch, list, stop, resume, rename, or delete a space on one of their nodes
- the user asks which spaces are running or wants a space's tab URLs
</uses>

<subcommands>
- config: Manage reusable space configs
- create: Create a space with the compatibility flag form
- delete: Delete a space
- launch: Launch a space from a selected configuration
- list: List every space you own
- move: Move a space to another node
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

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

