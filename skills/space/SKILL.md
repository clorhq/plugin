---
name: space
description: Long-lived coding-agent workspaces called spaces, running on a computer or in a sandbox. Create immutable snapshots from saved configs and report lifecycle and agent sign-in readiness. Use when the user wants to create, list, open, stop, resume, move, rename, or delete a space, or run a coding session, hosted service, or unattended agent.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Reliable creation

Before creation, run `clor space config list`, inspect the selected UUID with
`clor space config show <ID>`, and answer only its unresolved launch questions.
Create the immutable snapshot with `clor space create --config <ID>`, using
`--agent <TAB>=<AGENT>` for each unresolved agent tab. After creation,
inspect the returned `agent.credential_state` as well as lifecycle status.
`status=ready` does not prove the coding agent is signed in.

## Spaces reference

<help command="clor space">
<summary>Create, list, stop, resume, and delete spaces on your computers</summary>
<description>A space is a long-lived instance bound to one of your computers. It can
be a coding session, a hosted service, or an unattended agent. The daemon on
the computer brings each one up wholly and keeps it converged. This tree
creates immutable space snapshots from Environments, lists and inspects them,
stops and resumes them, renames them, and deletes them.

Use when
  - the user wants to start a space from a saved Environment
  - the user asks what spaces are running or wants a space's URLs
  - the user wants to stop, resume, rename, or delete a space

Subcommands
  list      List every space you own (with computer and running status)
  show      Show one space by its id (with its tab URLs)
  create    Create a space from an Environment
  rename    Rename a space
  stop      Stop a space so the daemon suspends it
  resume    Resume a stopped space
  delete    Delete a space

Output supports --stdout-format text|jsonl|json on every subcommand (default
text, logfmt with event= leader).</description>
<usage>clor space [flags]</usage>

<uses>
- the user wants to create, list, stop, resume, rename, or delete a space on one of their computers
- the user asks which spaces are running or wants a space's tab URLs
</uses>

<subcommands>
- config: Manage reusable space configs
- create: Create an immutable space snapshot from a config
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

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

