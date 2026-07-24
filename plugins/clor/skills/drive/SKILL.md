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


<help command="clor drive cp">
<summary>Server-side copy a file to a new drive path; bytes never flow through the CLI</summary>
<description>Server clones object storage directly; the new file is independent of
the source. Trailing slash on <DESTINATION> means "copy into this
directory and keep the source's basename". Use --destination-drive
to land in a different drive.</description>
<usage>clor drive cp <SOURCE> <DESTINATION> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --destination-drive string: which drive the copy lands in ("team" or a user UUID); defaults to the source's drive
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
- --ttl duration: delete the copy this much time after it lands (e.g. 24h, 168h) (default "0s")
</flags>

<output>json outputs the new file object at the destination path, with a fresh id independent of the source. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "content_length": 482318,
  "content_type": "application/pdf",
  "created": "2026-06-18T17:20:00Z",
  "download_count": 0,
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "etag": "9f86d081884c7d659a2feaa0c55ad015",
  "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194abc9-3c4d-7e5f-9a6b-7c8d9e0f1a2b",
  "name": "reports/2026-q1.pdf",
  "status": "uploaded",
  "updated": "2026-06-18T17:20:00Z",
  "upload_count": 0,
  "uploaded": "2026-06-18T17:20:00Z"
}
</output-example>

<examples-good>
- clor drive cp Downloads/report.pdf reports/2026-q1.pdf    # copy across directories within your drive
- clor drive cp Downloads/report.pdf shared/ --destination-drive team    # promote into the team drive (admin only)
- clor drive cp 0193abc.team.0194xyz templates/template.md --ttl 720h    # by composite id, with a 30-day TTL on the copy
</examples-good>

<examples-bad>
- clor drive cp Downloads/report.pdf    # missing <DESTINATION>
- clor drive cp a.txt /reports/b.pdf    # leading slash is rejected; paths are relative to the drive root
- clor drive cp a.txt drive://b.txt    # scheme prefixes like drive:// are rejected
- clor drive cp a.txt reports//b.pdf    # doubled slash makes an empty segment
</examples-bad>
</help>

<help command="clor drive df">
<summary>Show every drive the caller can access along with its file count, total size, and capacity</summary>
<description>Includes the caller's personal drive, the shared account drive, and
drives reached via share grants. Admins see every personal drive in
the account.</description>
<usage>clor drive df</usage>

<uses>
- the user wants to see which drives the caller can read or write
- the user wants to know how many files or bytes live in each accessible drive
</uses>

<output>json outputs the whole envelope {drives[]}. jsonl outputs each record from drives on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "drives": [
    {
      "capacity_bytes": 10737418240,
      "file_count": 128,
      "id": "0193abc7-aaaa-7c21-9a1b-000000000001",
      "total_bytes": 734003200,
      "type": "user"
    },
    {
      "capacity_bytes": 107374182400,
      "file_count": 842,
      "id": "team",
      "total_bytes": 5368709120,
      "type": "team"
    }
  ]
}
</output-example>

<examples-good>
- clor drive df    # logfmt: one event=drive line per drive with id, type, file_count, total_bytes
- clor drive df --stdout-format json | jq '.drives[] | {id, total_bytes}'    # JSON: pull size per drive
- clor drive df --stdout-format jsonl | jq -c 'select(.event=="drive")'    # JSONL: one object per drive, streamable
</examples-good>

<examples-bad>
- clor drive df foo    # no positional arguments accepted
- clor drive df --stdout-format yaml    # only text, jsonl, json supported
</examples-bad>
</help>

<help command="clor drive download">
<summary>Download a file by drive path or composite id to a local path or stdout</summary>
<description>Streams bytes from object storage via a short-lived signed URL. Saves
to the file's basename in the cwd by default; --out picks a path,
--stdout pipes the bytes. <PATH> may be a drive path or composite id.</description>
<usage>clor drive download <PATH> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
- --out string: write the bytes to this local path (defaults to the file's name in the cwd)
- --stdout bool: stream the bytes to stdout instead of a file
</flags>

<output>json outputs a small summary {id, name, size_bytes} of the downloaded file while the bytes go to the chosen local path. With --stdout the bytes themselves go to stdout and no summary is written. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "name": "Downloads/report.pdf",
  "size_bytes": 482318
}
</output-example>

<examples-good>
- clor drive download Downloads/report.pdf    # by path; saves to ./report.pdf
- clor drive download Downloads/report.pdf --out /tmp/saved.pdf    # explicit local path
- clor drive download Downloads/report.pdf --stdout | sha256sum    # pipe bytes elsewhere
- clor drive download 0193abc.team.0194xyz --out /tmp/x --stdout-format json | jq '.size_bytes'    # by composite id; JSON summary on stdout, file body in /tmp/x
</examples-good>

<examples-bad>
- clor drive download    # missing <PATH>
- clor drive download Downloads/report.pdf --out x --stdout    # --out and --stdout are mutually exclusive
- clor drive download /Downloads/report.pdf    # leading slash is rejected; paths are relative to the drive root
</examples-bad>
</help>

<help command="clor drive info">
<summary>Print full metadata for one file by drive path or composite id</summary>
<description>Returns id, name, size, content type, status, ETag, owner, retention
TTL, expiry, and timestamps. Use stat instead when the target might
be a directory or missing.</description>
<usage>clor drive info <PATH> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
</flags>

<output>json outputs the full file object with id, name, size, content type, status, ETag, retention, expiry, and timestamps. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "content_length": 482318,
  "content_type": "application/pdf",
  "created": "2026-01-14T09:30:00Z",
  "download_count": 3,
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "etag": "9f86d081884c7d659a2feaa0c55ad015",
  "expires": "2026-01-21T09:31:12Z",
  "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "name": "Downloads/report.pdf",
  "status": "uploaded",
  "ttl_seconds": 604800,
  "updated": "2026-01-14T09:31:12Z",
  "upload_count": 1,
  "uploaded": "2026-01-14T09:31:12Z"
}
</output-example>

<examples-good>
- clor drive info Downloads/report.pdf    # by path
- clor drive info 0193abc.team.0194xyz    # by composite id
- clor drive info Downloads/report.pdf --stdout-format json | jq '.status'    # JSON, pluck a single field
</examples-good>

<examples-bad>
- clor drive info    # missing <PATH>
- clor drive info /Downloads/report.pdf    # leading slash is rejected; paths are relative to the drive root
</examples-bad>
</help>

<help command="clor drive link">
<summary>Manage public links for sharing files in or out of a drive</summary>
<description>Token-addressable URLs that resolve without authentication. Two
directions: download (read one uploaded file) and upload (PUT a file
at a pre-named drive path). Each supports optional expiry and
use-count cap. Use `drive share` instead for user-scoped access.</description>
<usage>clor drive link</usage>

<uses>
- the user wants to share an uploaded file via a public URL
- the user wants someone else to drop a file into a drive path via a public URL
- the user wants to see or revoke active public links
</uses>

<subcommands>
- download: Public read links to one uploaded file, with optional expiry and use-count cap
- upload: Public write links that let an anonymous browser PUT a file at a drive path
</subcommands>
</help>


<help command="clor drive link download">
<summary>Public read links to one uploaded file, with optional expiry and use-count cap</summary>
<description>/l/<token> renders a preview page; /d/<token> redirects to a
short-lived signed download URL.</description>
<usage>clor drive link download</usage>

<subcommands>
- create: Issue a public read link for an uploaded file
- ls: List public download links the caller has issued (filterable by file)
- rm: Revoke a public download link by id
</subcommands>
</help>


<help command="clor drive link download create">
<summary>Issue a public read link for an uploaded file</summary>
<usage>clor drive link download create <PATH> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
- --expires duration: link is dead after this much time (e.g. 24h, 168h); 0 = never (default "0s")
- --max-uses int64: cap on the number of times the link can resolve; 0 = unlimited
</flags>

<output>json outputs the created link object with its token, preview url, and direct download_url. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "created": "2026-06-18T17:25:00Z",
  "download_url": "https://drive.clor.com/d/a7Kp9mQ2wXt",
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "expires": "2026-06-19T17:25:00Z",
  "file_id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "id": "0194lnk1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "max_uses": 5,
  "token": "a7Kp9mQ2wXt",
  "type": "download",
  "url": "https://drive.clor.com/l/a7Kp9mQ2wXt",
  "use_count": 0,
  "user_id": "0193def4-1a2b-7c3d-8e4f-5a6b7c8d9e01"
}
</output-example>

<examples-good>
- clor drive link download create Downloads/report.pdf --expires 24h --max-uses 5    # 1-day, 5-use link
- clor drive link download create 0193abc.0193abc.0194xyz --stdout-format json | jq '.url'    # JSON: capture the URL
- clor drive link download create handbook.md --drive team    # link to a file in the team drive
</examples-good>

<examples-bad>
- clor drive link download create    # missing <PATH>
- clor drive link download create /Downloads/report.pdf    # leading slash is rejected; paths are relative to the drive root
</examples-bad>
</help>


<help command="clor drive link download ls">
<summary>List public download links the caller has issued (filterable by file)</summary>
<usage>clor drive link download ls [flags]</usage>

<flags>
- --cursor string: next_cursor returned by a prior page
- --file-id string: filter by composite file id
- --limit int: max rows per page (1-1000); zero uses the server default
- --mine bool: only list links the caller created
</flags>

<output>json outputs the whole envelope {links[], next_cursor}. jsonl outputs each record from links on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "links": [
    {
      "created": "2026-06-18T17:25:00Z",
      "download_url": "https://drive.clor.com/d/a7Kp9mQ2wXt",
      "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
      "expires": "2026-06-19T17:25:00Z",
      "file_id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
      "id": "0194lnk1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
      "max_uses": 5,
      "token": "a7Kp9mQ2wXt",
      "type": "download",
      "url": "https://drive.clor.com/l/a7Kp9mQ2wXt",
      "use_count": 2,
      "user_id": "0193def4-1a2b-7c3d-8e4f-5a6b7c8d9e01"
    }
  ]
}
</output-example>

<examples-good>
- clor drive link download ls --mine    # download links you created
- clor drive link download ls --file-id 0193abc.0193abc.0194xyz    # every download link to one file
- clor drive link download ls --stdout-format json | jq '.links[] | .url'    # JSON: pull URLs
</examples-good>

<examples-bad>
- clor drive link download ls --limit -1    # negative limit is rejected
</examples-bad>
</help>


<help command="clor drive link download rm">
<summary>Revoke a public download link by id</summary>
<description>Revocation is immediate; the public URL stops resolving on the next request.</description>
<usage>clor drive link download rm <LINK></usage>

<examples-good>
- clor drive link download rm 0193abc...    # delete a download link by id
</examples-good>

<examples-bad>
- clor drive link download rm    # missing <LINK>
</examples-bad>
</help>


<help command="clor drive link upload">
<summary>Public write links that let an anonymous browser PUT a file at a drive path</summary>
<description>/u/<token> renders an upload page that PUTs bytes directly to storage
and reports completion. One-shot by default; --max-uses allows more.</description>
<usage>clor drive link upload</usage>

<subcommands>
- create: Issue a public write link that lets an anonymous browser PUT a file at <PATH>
- ls: List public upload links the caller has issued (filterable by file)
- rm: Revoke a public upload link by id
</subcommands>
</help>


<help command="clor drive link upload create">
<summary>Issue a public write link that lets an anonymous browser PUT a file at <PATH></summary>
<description>One-shot by default; --max-uses allows more uploads at the same path.
--content-type pre-binds the MIME type the page will send.</description>
<usage>clor drive link upload create <PATH> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --content-type string: MIME type to bind to the upload URL
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
- --expires duration: link is dead after this much time (e.g. 1h, 24h); 0 = never (default "0s")
- --max-uses int64: cap on uploads accepted at this path; 0 = server default (one-shot)
</flags>

<output>json outputs the created link object with its token and the public upload_url an anonymous browser can PUT to. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "created": "2026-06-18T17:25:00Z",
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "expires": "2026-06-18T18:25:00Z",
  "id": "0194lnk2-3c4d-7e5f-9a6b-7c8d9e0f1a2b",
  "max_uses": 1,
  "token": "b8Lq0nR3xYu",
  "type": "upload",
  "upload_url": "https://drive.clor.com/u/b8Lq0nR3xYu",
  "use_count": 0,
  "user_id": "0193def4-1a2b-7c3d-8e4f-5a6b7c8d9e01"
}
</output-example>

<examples-good>
- clor drive link upload create handoff/report.pdf --expires 1h    # one-shot 1-hour upload window
- clor drive link upload create inbox/screenshot.png --content-type image/png --stdout-format json | jq '.upload_url'    # JSON: capture the upload page URL
- clor drive link upload create dropbox/daily.csv --expires 24h --max-uses 10    # 10 uploads in 24 hours overwriting the same path
</examples-good>

<examples-bad>
- clor drive link upload create    # missing <PATH>
- clor drive link upload create /handoff/report.pdf    # leading slash is rejected; paths are relative to the drive root
- clor drive link upload create drive://handoff/report.pdf    # scheme prefixes like drive:// are rejected
</examples-bad>
</help>


<help command="clor drive link upload ls">
<summary>List public upload links the caller has issued (filterable by file)</summary>
<usage>clor drive link upload ls [flags]</usage>

<flags>
- --cursor string: next_cursor returned by a prior page
- --file-id string: filter by composite file id
- --limit int: max rows per page (1-1000); zero uses the server default
- --mine bool: only list links the caller created
</flags>

<output>json outputs the whole envelope {links[], next_cursor}. jsonl outputs each record from links on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "links": [
    {
      "created": "2026-06-18T17:25:00Z",
      "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
      "expires": "2026-06-18T18:25:00Z",
      "id": "0194lnk2-3c4d-7e5f-9a6b-7c8d9e0f1a2b",
      "max_uses": 1,
      "token": "b8Lq0nR3xYu",
      "type": "upload",
      "upload_url": "https://drive.clor.com/u/b8Lq0nR3xYu",
      "use_count": 0,
      "user_id": "0193def4-1a2b-7c3d-8e4f-5a6b7c8d9e01"
    }
  ]
}
</output-example>

<examples-good>
- clor drive link upload ls --mine    # upload links you created
- clor drive link upload ls --stdout-format json | jq '.links[] | .upload_url'    # JSON: pull upload page URLs
- clor drive link upload ls --file-id 0193abc.0193abc.0194xyz    # upload links targeting one file
</examples-good>

<examples-bad>
- clor drive link upload ls --limit 9999    # limit must be 1-1000
</examples-bad>
</help>


<help command="clor drive link upload rm">
<summary>Revoke a public upload link by id</summary>
<description>Revocation is immediate; the public URL stops resolving on the next request.</description>
<usage>clor drive link upload rm <LINK></usage>

<examples-good>
- clor drive link upload rm 0193abc...    # delete an upload link by id
</examples-good>

<examples-bad>
- clor drive link upload rm    # missing <LINK>
</examples-bad>
</help>

<help command="clor drive ls">
<summary>List files and subdirectories at a drive path (root by default)</summary>
<description>Lists direct children plus a synthesized directories array. --recursive
flattens every descendant (no directories array); --tree renders an
indented tree with depth markers in text/jsonl modes.</description>
<usage>clor drive ls [PATH] [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --cursor string: next_cursor returned by a prior page
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
- --include-deleted bool: include deleted files (still within the retention window) in the listing
- --limit int: max files per page (1-1000); zero uses the server default
- --prefix string: filter to files whose name starts with this prefix
- --recursive bool: include every descendant of the path; omit the directories array
- --tree bool: render a recursive listing as an indented tree (implies --recursive)
</flags>

<output>json outputs the whole envelope {drive, files[], directories, next_cursor}. jsonl outputs each record from files on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "directories": [
    "notes/2026/archive"
  ],
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "files": [
    {
      "content_length": 14902,
      "content_type": "text/markdown",
      "created": "2026-01-03T11:12:00Z",
      "download_count": 5,
      "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
      "etag": "e2fc714c4727ee9395f324cd2e7f331f",
      "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
      "name": "notes/2026/q1.md",
      "status": "uploaded",
      "updated": "2026-04-09T08:45:00Z",
      "upload_count": 2,
      "uploaded": "2026-04-09T08:45:00Z"
    }
  ],
  "next_cursor": "eyJvZmZzZXQiOjUwfQ"
}
</output-example>

<examples-good>
- clor drive ls    # root: top-level files plus first-level subdirectories
- clor drive ls notes/2026/    # files and subdirs directly inside notes/2026
- clor drive ls notes/ --recursive    # every file under notes/, no synthesized directories
- clor drive ls notes/ --tree    # indented tree with depth=N per row
- clor drive ls notes/ --stdout-format json | jq '.directories'    # JSON: pluck the directories list
</examples-good>

<examples-bad>
- clor drive ls --limit -1    # negative limit is rejected
- clor drive ls drive://notes    # scheme prefixes like drive:// are rejected
- clor drive ls notes//2026    # doubled slash makes an empty segment
- clor drive ls --stdout-format yaml    # only text, jsonl, json supported
</examples-bad>
</help>

<help command="clor drive mv">
<summary>Move or rename a file in a drive, preserving its identity and existing links</summary>
<description>File id, ETag, and public links survive the move. <SOURCE> may be a
drive path or composite id; <DESTINATION> is always a path. Trailing
slash on the destination means "move into this directory and keep the
source's basename".</description>
<usage>clor drive mv <SOURCE> <DESTINATION> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
</flags>

<output>json outputs the moved file object at its new name, with the same id and ETag as before the move. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "content_length": 482318,
  "content_type": "application/pdf",
  "created": "2026-01-14T09:30:00Z",
  "download_count": 3,
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "etag": "9f86d081884c7d659a2feaa0c55ad015",
  "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "name": "reports/2026-q1.pdf",
  "status": "uploaded",
  "updated": "2026-06-18T17:10:00Z",
  "upload_count": 1,
  "uploaded": "2026-01-14T09:31:12Z"
}
</output-example>

<examples-good>
- clor drive mv Downloads/report.pdf reports/2026-q1.pdf    # move and rename in one step
- clor drive mv Downloads/report.pdf Downloads/report-final.pdf    # rename in place
- clor drive mv Downloads/report.pdf reports/    # trailing slash: move into reports/, keep basename
- clor drive mv 0193abc.team.0194xyz notes/today.md    # source by composite id, destination always a path
</examples-good>

<examples-bad>
- clor drive mv Downloads/report.pdf ""    # empty <DESTINATION> is rejected
- clor drive mv a.txt /reports/b.pdf    # leading slash is rejected; paths are relative to the drive root
- clor drive mv a.txt drive://b.txt    # scheme prefixes like drive:// are rejected
- clor drive mv a.txt reports//b.pdf    # doubled slash makes an empty segment
</examples-bad>
</help>

<help command="clor drive retention">
<summary>Set or clear a file's auto-delete TTL, measured from upload completion</summary>
<description>When the window elapses the file is soft-deleted automatically (still
restorable via undelete for a grace period). --ttl sets the window;
--clear-ttl keeps the file indefinitely.</description>
<usage>clor drive retention <PATH> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --clear-ttl bool: remove the retention TTL
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
- --ttl duration: retention starting from upload completion (e.g. 24h, 720h) (default "0s")
</flags>

<output>json outputs the file object with the updated ttl_seconds and recomputed expires. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "content_length": 482318,
  "content_type": "application/pdf",
  "created": "2026-01-14T09:30:00Z",
  "download_count": 3,
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "etag": "9f86d081884c7d659a2feaa0c55ad015",
  "expires": "2026-01-21T09:31:12Z",
  "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "name": "Downloads/report.pdf",
  "status": "uploaded",
  "ttl_seconds": 604800,
  "updated": "2026-06-18T17:12:00Z",
  "upload_count": 1,
  "uploaded": "2026-01-14T09:31:12Z"
}
</output-example>

<examples-good>
- clor drive retention Downloads/report.pdf --ttl 168h    # delete 7 days after upload completes
- clor drive retention Downloads/report.pdf --clear-ttl    # keep the file indefinitely
- clor drive retention Downloads/report.pdf --ttl 24h --stdout-format json | jq '.expires'    # verify the new expiry
</examples-good>

<examples-bad>
- clor drive retention Downloads/report.pdf    # must pass --ttl or --clear-ttl
- clor drive retention Downloads/report.pdf --ttl 1h --clear-ttl    # mutually exclusive
- clor drive retention /Downloads/report.pdf --ttl 24h    # leading slash is rejected; paths are relative to the drive root
</examples-bad>
</help>

<help command="clor drive rm">
<summary>Delete a file from a drive (recoverable by default, --hard for immediate purge)</summary>
<description>Soft delete by default: restorable via undelete within the retention
window. --hard purges immediately and irreversibly.</description>
<usage>clor drive rm <PATH> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
- --hard bool: purge immediately rather than leaving recoverable
</flags>

<output>json outputs the deleted file object with status=deleted and the deleted timestamp set. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "content_length": 482318,
  "content_type": "application/pdf",
  "created": "2026-01-14T09:30:00Z",
  "deleted": "2026-06-18T17:05:00Z",
  "download_count": 3,
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "etag": "9f86d081884c7d659a2feaa0c55ad015",
  "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "name": "Downloads/report.pdf",
  "status": "deleted",
  "updated": "2026-06-18T17:05:00Z",
  "upload_count": 1,
  "uploaded": "2026-01-14T09:31:12Z"
}
</output-example>

<examples-good>
- clor drive rm Downloads/report.pdf    # recoverable delete by path; restorable via undelete within the retention window
- clor drive rm 0193abc.team.0194xyz --hard    # immediate, irreversible delete by composite id
- clor drive rm Downloads/report.pdf --stdout-format json | jq '.status'    # verify status=deleted
</examples-good>

<examples-bad>
- clor drive rm    # missing <PATH>
- clor drive rm /Downloads/report.pdf    # leading slash is rejected; paths are relative to the drive root
</examples-bad>
</help>

<help command="clor drive share">
<summary>Grant, list, and revoke ACL access to files or path prefixes in a drive</summary>
<description>A grant says "this principal (account or user) can read or write
that target (one file, path prefix, or whole drive)". Use `drive link`
instead for shareable public URLs.</description>
<usage>clor drive share</usage>

<uses>
- the user wants to grant another user or account access to a file or path prefix
- the user wants to see grants they've issued, or revoke one
- the user wants to see what others have shared with them
</uses>

<subcommands>
- grant: Grant read or write access on a file, a path prefix, or a whole drive
- ls: List ACL share grants on a drive, file, or path prefix
- mine: List ACL share grants where the caller is the principal (what's been shared with me)
- revoke: Revoke an existing ACL share grant by id
</subcommands>
</help>


<help command="clor drive share grant">
<summary>Grant read or write access on a file, a path prefix, or a whole drive</summary>
<description>Pick exactly one target (--file-id, --path, or --all-drive) and
exactly one principal (--team or --user). --permission is read|write.</description>
<usage>clor drive share grant [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --all-drive bool: share the entire drive (sets target_path to empty)
- --drive string: drive that holds the target ("team" or a user UUID)
- --file-id string: share a specific file (composite id); mutually exclusive with --path
- --path string: share a path prefix; empty path with --all-drive means the whole drive
- --permission string: permission level (read|write) (default "read")
- --team string: principal team id
- --user string: principal user id
</flags>

<output>json outputs the created grant object with its id, target, principal, and permission. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "created": "2026-06-18T17:30:00Z",
  "id": "0194shr1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "permission": "read",
  "principal_user_id": "0193def4-1a2b-7c3d-8e4f-5a6b7c8d9e01",
  "target_drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "target_path": "docs"
}
</output-example>

<examples-good>
- clor drive share grant --drive 0193abc... --path docs --user 0193def... --permission read    # share docs/* with one user
- clor drive share grant --drive 0193abc... --file-id 0193abc.0193abc.0194xyz --team 0193ghi... --permission write    # share one file with a team, write access
- clor drive share grant --drive team --all-drive --user 0193abc... --permission read --stdout-format json | jq '.id'    # share the whole team drive read-only
</examples-good>

<examples-bad>
- clor drive share grant --drive 0193abc... --user 0193def...    # missing target (--file-id, --path, or --all-drive)
- clor drive share grant --drive 0193abc... --path docs --team 0193def... --user 0193ghi...    # principal must be team OR user, not both
- clor drive share grant --drive 0193abc... --path /docs --user 0193def...    # leading slash is rejected; paths are relative to the drive root
</examples-bad>
</help>


<help command="clor drive share ls">
<summary>List ACL share grants on a drive, file, or path prefix</summary>
<description>Each row shows the target (drive plus file/path), the principal
(account or user), the permission level, and the grant id needed
for revoke.</description>
<usage>clor drive share ls [flags]</usage>

<flags>
- --cursor string: next_cursor returned by a prior page
- --drive string: filter by target drive
- --file-id string: filter by target file id
- --limit int: max rows per page (1-1000); zero uses the server default
- --path string: filter by target path (set to "" to match drive-wide grants)
</flags>

<output>json outputs the whole envelope {shares[], next_cursor}. jsonl outputs each record from shares on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "shares": [
    {
      "created": "2026-06-18T17:30:00Z",
      "id": "0194shr1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
      "permission": "read",
      "principal_user_id": "0193def4-1a2b-7c3d-8e4f-5a6b7c8d9e01",
      "target_drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
      "target_path": "docs"
    }
  ]
}
</output-example>

<examples-good>
- clor drive share ls --drive 0193abc...    # all grants on a drive
- clor drive share ls --drive 0193abc... --path docs    # grants on the docs/ prefix
- clor drive share ls --drive team --stdout-format json | jq '.shares[] | .principal_user_id'    # JSON: who has access on the team drive
</examples-good>

<examples-bad>
- clor drive share ls --limit -1    # negative limit is rejected
</examples-bad>
</help>


<help command="clor drive share mine">
<summary>List ACL share grants where the caller is the principal (what's been shared with me)</summary>
<description>Returns grants where the caller (or the caller's account) is the
principal: which other users' or accounts' files the caller can reach.</description>
<usage>clor drive share mine</usage>

<output>json outputs the whole envelope {shares[], next_cursor} of grants where the caller is the principal. jsonl outputs each record from shares on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "shares": [
    {
      "created": "2026-05-02T14:08:00Z",
      "id": "0194shr2-3c4d-7e5f-9a6b-7c8d9e0f1a2b",
      "permission": "write",
      "principal_user_id": "0193def4-1a2b-7c3d-8e4f-5a6b7c8d9e01",
      "target_drive": "0193ccc8-bbbb-7c21-9a1b-000000000002",
      "target_path": "handbook"
    }
  ]
}
</output-example>

<examples-good>
- clor drive share mine    # what's been shared with me
- clor drive share mine --stdout-format json | jq '.shares[] | .target_drive'    # JSON: which drives I can reach via shares
</examples-good>

<examples-bad>
- clor drive share mine foo    # no positional arguments accepted
</examples-bad>
</help>


<help command="clor drive share revoke">
<summary>Revoke an existing ACL share grant by id</summary>
<description>Revocation is immediate; principals lose access on the next API call.</description>
<usage>clor drive share revoke <SHARE> [flags]</usage>

<flags>
- --drive string: drive that holds the share
</flags>

<examples-good>
- clor drive share revoke 0193abc... --drive 0193def...    # delete the grant
</examples-good>

<examples-bad>
- clor drive share revoke 0193abc...    # missing --drive
</examples-bad>
</help>

<help command="clor drive stat">
<summary>Distinguish file vs directory vs missing for a drive path in one round trip</summary>
<description>Returns type=file|directory|missing in one round trip (missing is
still 200 OK, no exception). When type=file, full metadata is
included under "file". No positional argument stats the drive root.</description>
<usage>clor drive stat [PATH] [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
</flags>

<output>json outputs the discriminated answer {type, path, drive} with the full file object under file when type=file. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "file": {
    "content_length": 14902,
    "content_type": "text/markdown",
    "created": "2026-01-03T11:12:00Z",
    "download_count": 5,
    "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
    "etag": "e2fc714c4727ee9395f324cd2e7f331f",
    "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
    "name": "notes/2026/q1.md",
    "status": "uploaded",
    "updated": "2026-04-09T08:45:00Z",
    "upload_count": 2,
    "uploaded": "2026-04-09T08:45:00Z"
  },
  "path": "notes/2026/q1.md",
  "type": "file"
}
</output-example>

<examples-good>
- clor drive stat    # no positional: stats the account root, always type=directory
- clor drive stat notes/2026/q1.md    # type=file plus the file's metadata in one event line
- clor drive stat notes/    # type=directory when the prefix has any descendant
- clor drive stat no/such/path    # type=missing (still 200 OK) so you can branch without exception handling
- clor drive stat notes/q1.md --stdout-format json | jq -r '.type'    # JSON discriminator for scripting
</examples-good>

<examples-bad>
- clor drive stat /notes/q1.md    # leading slash is rejected; paths are relative to the drive root
- clor drive stat foo bar    # at most one path argument
</examples-bad>
</help>

<help command="clor drive undelete">
<summary>Restore a recently soft-deleted file to its prior state</summary>
<description>Size, ETag, ACL grants, retention TTL, and public links are restored
unchanged. If the path was reused by a new file the restore returns
409; target by composite id to disambiguate. Must happen before
retention window elapses.</description>
<usage>clor drive undelete <PATH> [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
</flags>

<output>json outputs the restored file object with status back to uploaded and the deleted timestamp cleared. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "content_length": 14902,
  "content_type": "text/markdown",
  "created": "2026-01-03T11:12:00Z",
  "download_count": 5,
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "etag": "e2fc714c4727ee9395f324cd2e7f331f",
  "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "name": "notes/2026/q1.md",
  "status": "uploaded",
  "updated": "2026-06-18T17:15:00Z",
  "upload_count": 2,
  "uploaded": "2026-04-09T08:45:00Z"
}
</output-example>

<examples-good>
- clor drive undelete notes/2026/q1.md    # by path; targets the most recently deleted file at this path
- clor drive undelete 0193abc.team.0194xyz    # by composite id (preferred when the path was reused)
- clor drive undelete notes/2026/q1.md --stdout-format json | jq '.status'    # verify status returned to uploaded
</examples-good>

<examples-bad>
- clor drive undelete    # missing <PATH>
- clor drive undelete notes/active-file.md    # 400 if the file is not in deleted state
- clor drive undelete /notes/2026/q1.md    # leading slash is rejected; paths are relative to the drive root
</examples-bad>
</help>

<help command="clor drive upload">
<summary>Upload a local file to a drive path, overwriting any existing file there</summary>
<description>Streams to object storage via a short-lived signed URL, then records
metadata in the drive. <PATH> defaults to the basename of <FILE>; a
trailing slash means "drop into this directory and keep the basename".
Existing non-deleted files at the same path are overwritten in place,
preserving file id and links.</description>
<usage>clor drive upload <FILE> [PATH] [flags]</usage>

<rules>
- Use paths relative to the drive root, such as notes/q1.md, never a leading slash like /notes/q1.md
- Do not prefix a path with a scheme such as drive://
- Do not use empty segments such as the doubled slash in notes//q1.md
</rules>

<flags>
- --content-type string: MIME type to bind to the upload URL
- --drive string: which drive to target ("team" or a user UUID); defaults to your user drive
- --ttl duration: delete this much time after upload completes (e.g. 1h, 24h, 720h) (default "0s")
</flags>

<output>json outputs the stored file object after the upload completes, with status=uploaded, size, content type, and ETag recorded. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "content_length": 482318,
  "content_type": "application/pdf",
  "created": "2026-06-18T16:59:40Z",
  "download_count": 0,
  "drive": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "etag": "9f86d081884c7d659a2feaa0c55ad015",
  "id": "0193abc7-7f4e-7c21-9a1b-0194xyz12345.0193abc7-aaaa-7c21-9a1b-000000000001.0194xyz1-2b3c-7d4e-8f5a-6b7c8d9e0f12",
  "name": "Downloads/report.pdf",
  "status": "uploaded",
  "updated": "2026-06-18T17:00:05Z",
  "upload_count": 1,
  "uploaded": "2026-06-18T17:00:05Z"
}
</output-example>

<examples-good>
- clor drive upload ./README.md    # stored at README.md in your user drive
- clor drive upload ./report.pdf Downloads/    # stored at Downloads/report.pdf
- clor drive upload ./handbook.md handbook.md --drive team    # upload to the team drive (admin only)
- clor drive upload ./report.pdf reports/2026-q1.pdf --content-type application/pdf --ttl 168h    # explicit path, MIME, and 7-day TTL
- clor drive upload ./shared.txt --stdout-format json | jq '.file.id'    # capture the new id
</examples-good>

<examples-bad>
- clor drive upload    # missing <FILE> positional
- clor drive upload ./missing.txt    # errors when the file cannot be opened
- clor drive upload ./a /notes/x    # leading slash is rejected; paths are relative to the drive root
- clor drive upload ./a drive://notes/x    # scheme prefixes like drive:// are rejected
- clor drive upload ./a notes//x    # doubled slash makes an empty segment
- clor drive upload ./big.bin --stdout-format yaml    # only text, jsonl, json supported
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

