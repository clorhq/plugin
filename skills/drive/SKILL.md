---
name: drive
description: Clor Drive cloud file storage and sharing. Use when the user wants to upload, download, list, copy, move, delete, or share Clor cloud files, create a public link, or persist files between claw runs.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Drive reference

<help command="clor drive">
<summary>Store, share, and link cloud files in personal and shared drives with ACL grants, public links, and Unix verbs (ls, cp, mv, rm, df)</summary>
<description>Drive paths are relative to the drive root, so use notes/q1.md, not
/notes/q1.md, drive://notes/q1.md, or notes//q1.md. Files live in
scoped drives, addressed by these filesystem paths, managed with
Unix-style verbs (ls, cp, mv, rm, stat). Every account has a personal
drive per user plus a shared account drive, with optional ACL grants
for cross-user access and public token links. Uploads and downloads
stream directly to storage, not through the CLI.</description>
<usage>clor drive [flags]</usage>

<uses>
- storing files that must outlive a single shell session or move between machines
- handing a file to another user (in any account) for later download
- exposing a single file via a public URL with an optional expiry or use-count cap
- applying a retention TTL or an immediate, irreversible delete
- granting ACL access to a path prefix or an individual file
- discovering which drives the caller can reach and how much they store
</uses>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Separate segments with a forward slash, never a backslash
- Do not use empty segments such as the doubled slash in notes//q1.md
- Do not use . or .. as a path segment
- Use a single trailing slash only to mean "into this directory and keep the basename"
- Keep each segment within 255 bytes and the whole path within 1024 bytes
- Address a file by composite identifier like 0193abc.team.0194xyz (exactly two dots, no slashes) as the alternative to a path
</rules>

<subcommands>
- cp: Server-side copy a file to a new drive path; bytes never flow through the CLI
- df: Show every drive the caller can access along with its file count, total size, and capacity
- download: Download a file by drive path or composite id to a local path or stdout
- info: Print full metadata for one file by drive path or composite id
- link: Manage public links for sharing files in or out of a drive
- ls: List files and subdirectories at a drive path (root by default)
- mv: Move or rename a file in a drive, preserving its identity and existing links
- retention: Set or clear a file's auto-delete TTL, measured from upload completion
- rm: Delete a file from a drive (recoverable by default, --hard for immediate purge)
- share: Grant, list, and revoke ACL access to files or path prefixes in a drive
- stat: Distinguish file vs directory vs missing for a drive path in one round trip
- undelete: Restore a recently soft-deleted file to its prior state
- upload: Upload a local file to a drive path, overwriting any existing file there
</subcommands>

<flags>
- --help bool: help for drive
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

