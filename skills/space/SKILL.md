---
name: space
description: Long-lived coding-agent workspaces called spaces, running on a node or in a sandbox. Launch ordinary coding work with the code-workspace system configuration, use web-developer for web-focused projects, or honor an explicitly requested specialized, saved, or Team configuration. Connect the default Claude and Codex configurations and credentials when available, and report lifecycle and agent sign-in readiness. Use when the user wants to launch, create, list, open, stop, resume, move, rename, or delete a space, or run a coding session, hosted service, or unattended agent.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Selecting a configuration

Honor a configuration the user explicitly requests. Otherwise, pass
`code-workspace` explicitly for normal coding, debugging, review, refactoring,
command-line interface, backend, library, infrastructure, and general
repository work. Do not omit CONFIG for these launches because omission can
select the member's saved launcher default.

Use `web-developer` only for a web application or website where a live browser
preview and supervised development server materially help. Choose another
system configuration only when its environment strongly matches the task.

- `remotion-video` for programmatic video
- `data-lab` for notebooks or data analysis
- `browser-desktop` for browser-driven research
- `markdown-editor` for viewing-first document work

Treat terminal user interface, shell, and experimental multi-agent
configurations as opt-in interaction models. Use them only when the user asks
for one. Do not list the configuration library before a routine launch. Run
`clor space config list` when the user asks what is available, requests a saved
or Team configuration, or no known system configuration fits.

## Reliable launches

Leave the Claude and Codex configuration and credential flags unset so the
launcher resolves both runtimes through its defaults. A space configuration's
agent recommendation takes precedence, followed by the member's saved choice
and the shipped agent configuration. Credentials use the member's saved choice
or the launcher's deterministic fallback. If several choices exist, accept the
selected default instead of choosing one by its name. Never pass `none` for an
agent configuration or credential unless the user explicitly asks to disable
that attachment.

Use `clor space launch [CONFIG] --dry-run` to resolve Node, repository,
credential, environment, and secret questions before creation when needed. The
plan reports the selected Claude and Codex configurations and credentials. If
either runtime has no selected configuration or credential, report the gap and
ask before launching without it. Never invent a reference.

Launch several spaces through independent concurrent invocations, one command
per space. After creation, inspect `agent.credential_state` as well as lifecycle
status because `status=ready` does not prove the coding agent is signed in.

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

