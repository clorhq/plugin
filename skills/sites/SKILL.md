---
name: sites
description: Static web hosting for sites, single-page apps, reports, and dashboards, served over HTTPS at a stable URL plus an optional DNS-verified custom domain with an automatically provisioned certificate. Deploy a whole directory as one atomic release that replaces the live site, roll back to a previous release after a bad deploy, gate a site behind basic authentication, and patch individual files in place without a full redeploy. Use when the user wants to put a built static site, single-page app, report, or dashboard online at a public URL or a custom domain, ship a new build, roll back a broken one, attach a custom domain, or password-protect a published site.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Sites reference

<help command="clor sites">
<summary>Publish static sites and single-page apps over HTTPS with custom domains, atomic deploys, rollbacks, and basic auth</summary>
<description>Publish a directory of static files as a website served over HTTPS.
Deploy uploads the whole directory as one archive that atomically
replaces the live release; previous releases stay available for
rollback up to the site's revision limit. Each site is reachable at a
stable URL right away and can also be served at a DNS-verified custom
domain with an automatically provisioned certificate. Sites are owned
by the account (with --owner org) or by the calling user.</description>
<usage>clor sites [flags]</usage>

<uses>
- publishing a static site or single-page app over HTTPS
- serving a published site at a custom domain you control
- shipping a new build that should atomically replace the live site
- rolling a site back to a previous release after a bad deploy
- gating a published site behind HTTP basic auth
- inspecting which sites the caller owns and how much they store
</uses>

<rules>
- A subdomain is a single DNS label: lowercase letters, digits, and hyphens only
- It must be 1 to 63 characters and must not start or end with a hyphen
- Reserved and brand-confusable names like www, api, admin, and docs are rejected
- The site is served at <subdomain>.clor.app once a release is deployed
- A custom domain can also be pointed at the site with sites config <SUBDOMAIN> --domain
</rules>

<subcommands>
- auth: Manage HTTP basic auth on a site
- config: Update site configuration
- create: Claim a subdomain and create a site
- delete: Delete a site and its files
- deploy: Deploy a directory as the live release
- file: List, download, upload, and delete individual files in a site's live release
- list: List the sites the caller can see
- releases: List the retained releases for a site, oldest first
- rollback: Roll the live release back to a chosen or the previous release
- show: Show one site including size, current release, and file count
</subcommands>

<flags>
- --help bool: help for sites
</flags>

<global-flags>
- --clor-dir string: explicit path to the clor home directory holding config, state, and caches (overrides $CLOR_DIR; defaults to ~/.clor)
- --config string: explicit path to the TOML config file (overrides --clor-dir); defaults to <clor-dir>/config.toml
- --impersonate string: run commands as another team member by user id, like sudo (requires org admin, or a delegate grant from that member)
- --profile string: API-key profile to use for this command (overrides CLOR_PROFILE and the persisted default_profile); manage with `clor account profile`
- --stderr-file string: write stderr to this file instead of the terminal
- --stderr-format string: stderr format for progress/diagnostic events: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
- --stdout-file string: write stdout to this file instead of the terminal
- --stdout-format string: stdout format: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
</global-flags>
</help>


<help command="clor sites auth">
<summary>Manage HTTP basic auth on a site</summary>
<usage>clor sites auth</usage>

<subcommands>
- remove: Remove HTTP basic auth from a site
- set: Require HTTP basic auth on a site
</subcommands>
</help>


<help command="clor sites auth remove">
<summary>Remove HTTP basic auth from a site</summary>
<usage>clor sites auth remove <SUBDOMAIN></usage>

<uses>
- opening a previously gated site back up to the public
</uses>

<output>json outputs the whole updated site object. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "basic_auth_enabled": false,
  "created": "2026-06-07T14:30:05Z",
  "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
  "file_count": 38,
  "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
  "max_bytes_per_day": 1000000000,
  "max_hits_per_minute": 600,
  "max_revisions": 5,
  "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
  "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
  "spa_fallback": false,
  "status": "active",
  "subdomain": "my-cool-blog",
  "total_bytes": 4812944,
  "updated": "2026-06-18T16:41:00Z",
  "url": "https://my-cool-blog.clor.app"
}
</output-example>

<examples-good>
- clor sites auth remove my-cool-blog    # drops basic auth
</examples-good>
</help>


<help command="clor sites auth set">
<summary>Require HTTP basic auth on a site</summary>
<usage>clor sites auth set <SUBDOMAIN> [flags]</usage>

<uses>
- gating a published site behind a username and password
</uses>

<flags>
- --password string: basic-auth password (required)
- --username string: basic-auth username (required)
</flags>

<output>json outputs the whole updated site object. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "basic_auth_enabled": true,
  "created": "2026-06-07T14:30:05Z",
  "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
  "file_count": 38,
  "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
  "max_bytes_per_day": 1000000000,
  "max_hits_per_minute": 600,
  "max_revisions": 5,
  "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
  "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
  "spa_fallback": false,
  "status": "active",
  "subdomain": "my-cool-blog",
  "total_bytes": 4812944,
  "updated": "2026-06-18T16:41:00Z",
  "url": "https://my-cool-blog.clor.app"
}
</output-example>

<examples-good>
- clor sites auth set my-cool-blog --username editor --password s3cret    # visitors must authenticate
</examples-good>
</help>

<help command="clor sites config">
<summary>Update site configuration</summary>
<usage>clor sites config <SUBDOMAIN> [flags]</usage>

<uses>
- enabling single-page-app fallback for client-side routing
- setting a Content-Security-Policy or per-site rate limits
- pointing a DNS-verified custom domain at the site
</uses>

<flags>
- --csp string: Content-Security-Policy header value
- --domain string: custom domain to also serve the site at, DNS-verified at set time, empty clears it
- --max-bytes-per-day int64: per-site daily served-bytes limit (0 uses the service default)
- --max-hits-per-minute int: per-site request rate limit (0 uses the service default)
- --max-revisions int: number of releases to retain (min 1)
- --not-found string: relative path served on a miss
- --spa bool: serve the fallback document for unmatched routes
</flags>

<output>json outputs the whole site object with the updated configuration. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "basic_auth_enabled": false,
  "created": "2026-06-07T14:30:05Z",
  "csp": "default-src 'self'",
  "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
  "domain": "blog.example.com",
  "file_count": 38,
  "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
  "max_bytes_per_day": 1000000000,
  "max_hits_per_minute": 600,
  "max_revisions": 5,
  "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
  "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
  "spa_fallback": true,
  "status": "active",
  "subdomain": "my-cool-blog",
  "total_bytes": 4812944,
  "updated": "2026-06-18T16:41:00Z",
  "url": "https://my-cool-blog.clor.app"
}
</output-example>

<examples-good>
- clor sites config my-cool-blog --domain blog.example.com    # also serve the site at a DNS-verified custom domain
- clor sites config my-cool-blog --spa    # serve index.html on unmatched routes
- clor sites config my-cool-blog --max-hits-per-minute 600    # tighten the request rate limit
</examples-good>
</help>

<help command="clor sites create">
<summary>Claim a subdomain and create a site</summary>
<usage>clor sites create <SUBDOMAIN> [flags]</usage>

<uses>
- claiming a subdomain before the first deploy
- creating an account-wide site with --owner org
</uses>

<rules>
- A subdomain is a single DNS label: lowercase letters, digits, and hyphens only
- It must be 1 to 63 characters and must not start or end with a hyphen
- Reserved and brand-confusable names like www, api, admin, and docs are rejected
- The site is served at <subdomain>.clor.app once a release is deployed
- A custom domain can also be pointed at the site with sites config <SUBDOMAIN> --domain
</rules>

<flags>
- --owner string: set to "org" to create an account-wide site; defaults to your user
</flags>

<output>json outputs the whole site object. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "basic_auth_enabled": false,
  "created": "2026-06-07T14:30:05Z",
  "file_count": 0,
  "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
  "max_bytes_per_day": 1000000000,
  "max_hits_per_minute": 600,
  "max_revisions": 3,
  "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
  "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
  "spa_fallback": false,
  "status": "active",
  "subdomain": "my-cool-blog",
  "total_bytes": 0,
  "updated": "2026-06-07T14:30:05Z",
  "url": "https://my-cool-blog.clor.app"
}
</output-example>

<examples-good>
- clor sites create my-cool-blog    # creates a user-owned site at my-cool-blog.clor.app
- clor sites create launch --owner org    # account-wide site (requires admin)
</examples-good>

<examples-bad>
- clor sites create www    # reserved subdomains are rejected
- clor sites create My_Site    # subdomains are lowercase letters, digits, and hyphens only
</examples-bad>
</help>

<help command="clor sites delete">
<summary>Delete a site and its files</summary>
<usage>clor sites delete <SUBDOMAIN></usage>

<uses>
- the user wants to take a site down and free its subdomain
</uses>

<output>json outputs the whole site object with status deleted. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "basic_auth_enabled": false,
  "created": "2026-06-07T14:30:05Z",
  "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
  "file_count": 38,
  "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
  "max_bytes_per_day": 1000000000,
  "max_hits_per_minute": 600,
  "max_revisions": 3,
  "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
  "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
  "spa_fallback": true,
  "status": "deleted",
  "subdomain": "my-cool-blog",
  "total_bytes": 4812944,
  "updated": "2026-06-18T16:41:00Z",
  "url": "https://my-cool-blog.clor.app"
}
</output-example>

<examples-good>
- clor sites delete my-cool-blog    # soft deletes; the sweeper reaps the files
</examples-good>
</help>

<help command="clor sites deploy">
<summary>Deploy a directory as the live release</summary>
<usage>clor sites deploy <SUBDOMAIN> <DIR></usage>

<uses>
- publishing a built site directory as the new live release
</uses>

<rules>
- Pass a local directory; its whole contents become the live release
- A single file must be at most 100 MB and the whole directory at most 1000 MB
- index.html at the directory root is served at /
</rules>

<output>json outputs the whole result {release, file_count, total_bytes, site}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "file_count": 38,
  "release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
  "site": {
    "basic_auth_enabled": false,
    "created": "2026-06-07T14:30:05Z",
    "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
    "file_count": 38,
    "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
    "max_bytes_per_day": 1000000000,
    "max_hits_per_minute": 600,
    "max_revisions": 3,
    "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
    "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
    "spa_fallback": true,
    "status": "active",
    "subdomain": "my-cool-blog",
    "total_bytes": 4812944,
    "updated": "2026-06-09T09:12:41Z",
    "url": "https://my-cool-blog.clor.app"
  },
  "total_bytes": 4812944
}
</output-example>

<examples-good>
- clor sites deploy my-cool-blog ./dist    # uploads ./dist as the live release
</examples-good>

<examples-bad>
- clor sites deploy my-cool-blog ./dist/index.html    # pass the directory, not a single file
</examples-bad>
</help>

<help command="clor sites file">
<summary>List, download, upload, and delete individual files in a site's live release</summary>
<description>Read and change one published file at a time against a site's live release.
An upload writes the file in place and it is served immediately; a delete drops it.
This is the surgical counterpart to deploy, which replaces the whole release.

Use when:
  - appending or updating a single file (a daily entry, one asset) without a full redeploy
  - downloading one published file to inspect or edit it
  - listing exactly which files the live release serves
  - deleting one stale file from the live site

A deploy still replaces the entire release, so any files uploaded out-of-band are
wiped by the next deploy.

Subcommands:
  list      List the files served by the live release
  download  Download one file from the live release
  upload    Upload or replace one file in the live release
  delete    Delete one file from the live release

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor sites file</usage>

<subcommands>
- delete: Delete one file from a site's live release
- download: Download one file from a site's live release
- list: List the files served by a site's live release
- upload: Upload or replace one file in a site's live release
</subcommands>
</help>


<help command="clor sites file delete">
<summary>Delete one file from a site's live release</summary>
<usage>clor sites file delete <SUBDOMAIN> <REMOTE_PATH></usage>

<uses>
- deleting a single stale file from the live site
</uses>

<output>json outputs the whole site object reflecting the removed file. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "basic_auth_enabled": false,
  "created": "2026-06-07T14:30:05Z",
  "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
  "file_count": 37,
  "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
  "max_bytes_per_day": 1000000000,
  "max_hits_per_minute": 600,
  "max_revisions": 3,
  "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
  "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
  "spa_fallback": true,
  "status": "active",
  "subdomain": "my-cool-blog",
  "total_bytes": 4787271,
  "updated": "2026-06-18T16:41:00Z",
  "url": "https://my-cool-blog.clor.app"
}
</output-example>

<examples-good>
- clor sites file delete my-cool-blog old-post.html    # drops the file and its compressed variants
- clor sites file delete my-cool-blog posts/2026-06-07.html    # delete a nested path
- clor sites file delete my-cool-blog stale.css --stdout-format json | jq '.file_count'    # JSON, confirm the new file count
</examples-good>

<examples-bad>
- clor sites file delete my-cool-blog    # the remote path argument is required
- clor sites file delete my-cool-blog ../other-site/index.html    # the path must stay inside the release
</examples-bad>
</help>


<help command="clor sites file download">
<summary>Download one file from a site's live release</summary>
<usage>clor sites file download <SUBDOMAIN> <REMOTE_PATH> [LOCAL_PATH]</usage>

<uses>
- downloading a single published file to inspect or edit it
</uses>

<examples-good>
- clor sites file download my-cool-blog index.html ./index.html    # save the live index.html locally
- clor sites file download my-cool-blog feed.xml    # stream the file to stdout
- clor sites file download my-cool-blog posts/2026-06-07.html ./entry.html    # fetch a nested path to a local name
</examples-good>

<examples-bad>
- clor sites file download my-cool-blog    # the remote path argument is required
- clor sites file download my-cool-blog /etc/passwd    # the path must stay inside the release; absolute paths are rejected
</examples-bad>
</help>


<help command="clor sites file list">
<summary>List the files served by a site's live release</summary>
<usage>clor sites file list <SUBDOMAIN></usage>

<uses>
- the user wants the list of files currently served by a site
</uses>

<output>json outputs the whole envelope {file_count, files[]}. jsonl outputs each record from files on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "file_count": 3,
  "files": [
    {
      "path": "index.html",
      "size": 18204
    },
    {
      "path": "styles/app.css",
      "size": 9133
    },
    {
      "path": "posts/2026-06-07.html",
      "size": 24877
    }
  ]
}
</output-example>

<examples-good>
- clor sites file list my-cool-blog    # one event=file line per served file
- clor sites file list my-cool-blog --stdout-format json | jq '.files[].path'    # JSON, pull served paths
- clor sites file list my-cool-blog | grep '^event=file '    # logfmt, filter to file lines
</examples-good>

<examples-bad>
- clor sites file list    # the subdomain argument is required
- clor sites file list https://my-cool-blog.clor.app    # pass the bare subdomain, not a URL
</examples-bad>
</help>


<help command="clor sites file upload">
<summary>Upload or replace one file in a site's live release</summary>
<usage>clor sites file upload <SUBDOMAIN> <LOCAL_PATH> [REMOTE_PATH]</usage>

<uses>
- adding or replacing a single file on the live site without a full redeploy
</uses>

<rules>
- The file must be at most 100 MB
- REMOTE_PATH defaults to the local file's base name when omitted
- A deploy replaces the whole release, wiping files uploaded out-of-band
</rules>

<output>json outputs the whole site object reflecting the new file. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "basic_auth_enabled": false,
  "created": "2026-06-07T14:30:05Z",
  "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
  "file_count": 39,
  "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
  "max_bytes_per_day": 1000000000,
  "max_hits_per_minute": 600,
  "max_revisions": 3,
  "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
  "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
  "spa_fallback": true,
  "status": "active",
  "subdomain": "my-cool-blog",
  "total_bytes": 4831148,
  "updated": "2026-06-18T16:41:00Z",
  "url": "https://my-cool-blog.clor.app"
}
</output-example>

<examples-good>
- clor sites file upload my-cool-blog ./index.html    # served at / as index.html
- clor sites file upload my-cool-blog ./entry.html posts/2026-06-07.html    # write to a nested remote path
- clor sites file upload my-cool-blog ./feed.xml --stdout-format json | jq '.total_bytes'    # JSON, read the new site size
</examples-good>

<examples-bad>
- clor sites file upload my-cool-blog ./dist    # upload takes one file; use deploy for a directory
- clor sites file upload my-cool-blog    # the local path argument is required
</examples-bad>
</help>

<help command="clor sites list">
<summary>List the sites the caller can see</summary>
<usage>clor sites list</usage>

<uses>
- the user wants to see which sites the caller owns and their sizes
</uses>

<output>json outputs the whole envelope {sites[]}. jsonl outputs each record from sites on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "sites": [
    {
      "basic_auth_enabled": false,
      "created": "2026-06-07T14:30:05Z",
      "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
      "file_count": 38,
      "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
      "max_bytes_per_day": 1000000000,
      "max_hits_per_minute": 600,
      "max_revisions": 3,
      "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
      "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
      "spa_fallback": true,
      "status": "active",
      "subdomain": "my-cool-blog",
      "total_bytes": 4812944,
      "updated": "2026-06-09T09:12:41Z",
      "url": "https://my-cool-blog.clor.app"
    },
    {
      "basic_auth_enabled": false,
      "created": "2026-06-01T18:05:22Z",
      "current_release": "0197f3d2-8a44-7c01-a2e9-3b7d6f1c8e22",
      "domain": "launch.example.com",
      "file_count": 6,
      "id": "0197f3d0-5e10-7a88-b6d3-1c9e4f2a7700",
      "max_bytes_per_day": 1000000000,
      "max_hits_per_minute": 600,
      "max_revisions": 3,
      "owner": "org",
      "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
      "spa_fallback": false,
      "status": "active",
      "subdomain": "launch",
      "total_bytes": 129004,
      "updated": "2026-06-01T18:05:22Z",
      "url": "https://launch.clor.app"
    }
  ]
}
</output-example>

<examples-good>
- clor sites list    # one event=site line per site
- clor sites list --stdout-format json | jq '.sites[].subdomain'    # JSON, pull subdomains
</examples-good>
</help>

<help command="clor sites releases">
<summary>List the retained releases for a site, oldest first</summary>
<usage>clor sites releases <SUBDOMAIN></usage>

<uses>
- the user wants to see which releases are available to roll back to
</uses>

<output>json outputs the whole envelope {releases[]}. jsonl outputs each record from releases on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "releases": [
    {
      "created": "2026-06-05T11:02:18Z",
      "current": false,
      "id": "0197f3b1-4c20-7d09-8a33-5e2b9f1c4a01"
    },
    {
      "created": "2026-06-09T09:12:41Z",
      "current": true,
      "id": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44"
    }
  ]
}
</output-example>

<examples-good>
- clor sites releases my-cool-blog    # one event=release line per retained release
</examples-good>
</help>

<help command="clor sites rollback">
<summary>Roll the live release back to a chosen or the previous release</summary>
<usage>clor sites rollback <SUBDOMAIN> [flags]</usage>

<uses>
- reverting to the previous release after a bad deploy
- pinning the live site to a specific earlier release id
</uses>

<flags>
- --release string: release id to make live; defaults to the previous release
</flags>

<output>json outputs the whole result {release, file_count, total_bytes, site}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "file_count": 35,
  "release": "0197f3b1-4c20-7d09-8a33-5e2b9f1c4a01",
  "site": {
    "basic_auth_enabled": false,
    "created": "2026-06-07T14:30:05Z",
    "current_release": "0197f3b1-4c20-7d09-8a33-5e2b9f1c4a01",
    "file_count": 35,
    "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
    "max_bytes_per_day": 1000000000,
    "max_hits_per_minute": 600,
    "max_revisions": 3,
    "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
    "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
    "spa_fallback": true,
    "status": "active",
    "subdomain": "my-cool-blog",
    "total_bytes": 4604112,
    "updated": "2026-06-18T16:41:00Z",
    "url": "https://my-cool-blog.clor.app"
  },
  "total_bytes": 4604112
}
</output-example>

<examples-good>
- clor sites rollback my-cool-blog    # rolls back to the immediately previous release
- clor sites rollback my-cool-blog --release 01900000-0000-7000-8000-000000000001    # rolls back to a specific release
</examples-good>
</help>

<help command="clor sites show">
<summary>Show one site including size, current release, and file count</summary>
<usage>clor sites show <SUBDOMAIN></usage>

<uses>
- the user wants the full state of one site (size, current release, file count)
</uses>

<output>json outputs the whole site object. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "basic_auth_enabled": false,
  "created": "2026-06-07T14:30:05Z",
  "current_release": "0197f3c5-2d80-7b14-9f02-6a1c3e7b9d44",
  "file_count": 38,
  "id": "0197f3c2-9a40-7e21-b3c8-2f9d4a6e15bb",
  "max_bytes_per_day": 1000000000,
  "max_hits_per_minute": 600,
  "max_revisions": 3,
  "owner": "0197f3a1-1c22-7c90-9b44-6e2a8d3f0011",
  "owner_org_id": "0197f39e-7b18-7a55-8d11-44c9a1e8f200",
  "spa_fallback": true,
  "status": "active",
  "subdomain": "my-cool-blog",
  "total_bytes": 4812944,
  "updated": "2026-06-09T09:12:41Z",
  "url": "https://my-cool-blog.clor.app"
}
</output-example>

<examples-good>
- clor sites show my-cool-blog    # one event=site line
</examples-good>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

