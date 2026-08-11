---
name: site
description: Static web hosting for sites, single-page applications, reports, and dashboards. Use when the user wants to publish or redeploy a static directory, roll back a release, patch a published file, attach a custom domain, or keep a site private and share it with specific people or teams.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Sites reference

<help command="clor site">
<summary>Publish static sites and single-page apps over HTTPS with custom domains, atomic deploys, rollbacks, and private sharing</summary>
<description>Publish a directory of static files as a website served over HTTPS.
Deploy uploads the whole directory as one archive that atomically
replaces the live release; previous releases stay available for
rollback up to the site's revision limit. Each site is reachable at a
stable URL right away and can also be served at a DNS-verified custom
domain with an automatically provisioned certificate. Sites are owned
by the account (with --owner team) or by the calling user.</description>
<usage>clor site [flags]</usage>

<uses>
- publishing a static site or single-page app over HTTPS
- serving a published site at a custom domain you control
- shipping a new build that should atomically replace the live site
- rolling a site back to a previous release after a bad deploy
- keeping a published site private and sharing it with specific people or teams
- inspecting which sites the caller owns and how much they store
</uses>

<rules>
- A subdomain is a single DNS label: lowercase letters, digits, and hyphens only
- It must be 1 to 63 characters and must not start or end with a hyphen
- Reserved and brand-confusable names like www, api, admin, and docs are rejected
- The site is served at <subdomain>.clor.app once a release is deployed
- A custom domain can also be pointed at the site with site config <SUBDOMAIN> --domain
</rules>

<subcommands>
- config: Update site configuration
- create: Claim a subdomain and create a site
- delete: Delete a site and its files
- deploy: Deploy a directory as the live release
- file: List, download, upload, and delete individual files in a site's live release
- list: List the sites the caller can see
- releases: List the retained releases for a site, oldest first
- rollback: Roll the live release back to a chosen or the previous release
- share: Share a private site with specific email addresses and whole teams
- show: Show one site including size, current release, and file count
</subcommands>

<flags>
- --help bool: help for site
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

