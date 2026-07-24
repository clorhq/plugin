---
name: tunnel
description: Reverse HTTP tunnels for running local servers. Use when the user wants to expose a local development server, application, webhook receiver, or demo at a public URL, claim a stable subdomain, or create, revoke, or manage temporary tunnel links.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Tunnel reference

<help command="clor tunnel">
<summary>Expose a local HTTP or WebSocket server on the public internet at a stable subdomain or an ephemeral link, run by the daemon</summary>
<description>Register a reverse tunnel from a local HTTP(S) server to the public
internet. A tunnel binds this machine's node to a target like
127.0.0.1:3000; the daemon opens one outbound connection to the edge and
reverse-proxies inbound requests to the target. WebSocket connections,
server-sent events, and other streaming responses pass through end to
end, and an h2c target serves gRPC and other native HTTP/2 apps. Reach a
tunnel at an optional stable subdomain or at any number of ephemeral
links with a fixed expiry; each command prints the full public URL. The
tunnel service is the source of truth, so a daemon that lost its local
state rebuilds every tunnel on its next poll.</description>
<usage>clor tunnel [flags]</usage>

<uses>
- exposing a local dev server on a public URL for a webhook, demo, or remote test
- claiming a stable subdomain that lives as long as the tunnel
- handing out short-lived, revocable links to a local server
</uses>

<subcommands>
- create: Register a tunnel from this machine to a local HTTP target, optionally claiming a subdomain
- delete: Delete a tunnel, freeing its subdomain and dropping its connection
- link: Create, list, and revoke ephemeral public links for a tunnel
- list: List the tunnels the caller owns
- show: Show one tunnel with its links and live connection status
- update: Change a tunnel's target or name, or set, change, or clear its subdomain
</subcommands>

<flags>
- --help bool: help for tunnel
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


<help command="clor tunnel create">
<summary>Register a tunnel from this machine to a local HTTP target, optionally claiming a subdomain</summary>
<usage>clor tunnel create [flags]</usage>

<uses>
- exposing a local server the daemon should keep online
- claiming a stable subdomain at create time
</uses>

<flags>
- --name string: optional human label
- --subdomain string: optional stable public subdomain to claim (e.g. myapp)
- --target string: local address to expose (e.g. 127.0.0.1:3000, https://localhost:8443, or h2c://localhost:50051 for gRPC and native HTTP/2 servers)
</flags>

<output>json outputs the created tunnel object; text and jsonl output one event=tunnel line.</output>

<output-example format="json">
{
  "cert_expires": "2027-06-30T12:00:00Z",
  "created": "2026-06-30T12:00:00Z",
  "host": "jakes-mbp",
  "id": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "name": "api",
  "online": true,
  "owner": "0193abc7-1111-7c21-9a1b-000000000002",
  "owner_team_id": "0193abc7-0000-7c21-9a1b-000000000000",
  "port": 0,
  "subdomain": "myapp",
  "target": "127.0.0.1:3000",
  "updated": "2026-06-30T12:00:00Z",
  "url": "https://myapp.clor.host"
}
</output-example>

<examples-good>
- clor tunnel create --target 127.0.0.1:3000    # register a tunnel with no subdomain; reach it via links
- clor tunnel create --target 127.0.0.1:3000 --subdomain myapp    # claim the stable subdomain myapp
- clor tunnel create --target https://localhost:8443 --name api --stdout-format json | jq .id    # JSON: capture the new tunnel id
</examples-good>

<examples-bad>
- clor tunnel create    # --target is required
- clor tunnel create --target 127.0.0.1:3000 --subdomain www    # www is reserved
</examples-bad>
</help>

<help command="clor tunnel delete">
<summary>Delete a tunnel, freeing its subdomain and dropping its connection</summary>
<usage>clor tunnel delete <ID></usage>

<uses>
- tearing down a tunnel and releasing its subdomain for anyone to reclaim
</uses>

<output>json outputs the deleted tunnel object with its disabled timestamp set; text and jsonl output one event=tunnel line.</output>

<output-example format="json">
{
  "cert_expires": "2027-06-30T12:00:00Z",
  "created": "2026-06-30T12:00:00Z",
  "host": "jakes-mbp",
  "id": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "name": "api",
  "online": true,
  "owner": "0193abc7-1111-7c21-9a1b-000000000002",
  "owner_team_id": "0193abc7-0000-7c21-9a1b-000000000000",
  "port": 0,
  "subdomain": "myapp",
  "target": "127.0.0.1:3000",
  "updated": "2026-06-30T12:00:00Z",
  "url": "https://myapp.clor.host"
}
</output-example>

<examples-good>
- clor tunnel delete 0193abc7-aaaa-7c21-9a1b-000000000001    # delete the tunnel and free its subdomain
- clor tunnel delete 0193abc7-aaaa-7c21-9a1b-000000000001 --stdout-format json | jq .disabled    # JSON: confirm the disabled timestamp
</examples-good>

<examples-bad>
- clor tunnel delete    # the tunnel id is required
- clor tunnel delete a b    # exactly one id
</examples-bad>
</help>

<help command="clor tunnel link">
<summary>Create, list, and revoke ephemeral public links for a tunnel</summary>
<description>Links are unguessable, revocable public URLs that point at a tunnel for
a fixed lifetime (default 24h, maximum 1 year). A tunnel may have many
links at once.</description>
<usage>clor tunnel link</usage>

<uses>
- handing out a short-lived public URL to a tunnel
- revoking a link without touching the tunnel or its subdomain
</uses>

<subcommands>
- create: Create an ephemeral public link for a tunnel
- delete: Revoke one link so its URL stops resolving immediately
- list: List a tunnel's links
</subcommands>
</help>


<help command="clor tunnel link create">
<summary>Create an ephemeral public link for a tunnel</summary>
<usage>clor tunnel link create <ID> [flags]</usage>

<uses>
- creating a short-lived public URL to a tunnel
</uses>

<flags>
- --expires duration: link lifetime as a duration (e.g. 1h, 24h, 720h); maximum 1 year (default "24h0m0s")
</flags>

<output>json outputs the created link object; text and jsonl output one event=link line.</output>

<output-example format="json">
{
  "created": "2026-06-30T12:00:00Z",
  "expires": "2026-07-01T12:00:00Z",
  "id": "0193abc7-cccc-7c21-9a1b-000000000003",
  "live": true,
  "token": "abcdefghijklmnopqrstuvw",
  "tunnel_id": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "updated": "2026-06-30T12:00:00Z",
  "url": "https://abcdefghijklmnopqrstuvw.clor.host"
}
</output-example>

<examples-good>
- clor tunnel link create 0193abc7-aaaa-7c21-9a1b-000000000001    # default 24h link
- clor tunnel link create 0193abc7-aaaa-7c21-9a1b-000000000001 --expires 1h    # a one-hour link
- clor tunnel link create 0193abc7-aaaa-7c21-9a1b-000000000001 --stdout-format json | jq .url    # JSON: capture the link URL
</examples-good>

<examples-bad>
- clor tunnel link create    # the tunnel id is required
- clor tunnel link create 0193abc7-aaaa-7c21-9a1b-000000000001 --expires 9000h    # over the one-year cap
</examples-bad>
</help>


<help command="clor tunnel link delete">
<summary>Revoke one link so its URL stops resolving immediately</summary>
<usage>clor tunnel link delete <LINK_ID></usage>

<uses>
- revoking a single link while leaving the tunnel and its other links intact
</uses>

<output>json outputs the revoked link object with live=false; text and jsonl output one event=link line.</output>

<output-example format="json">
{
  "created": "2026-06-30T12:00:00Z",
  "expires": "2026-07-01T12:00:00Z",
  "id": "0193abc7-cccc-7c21-9a1b-000000000003",
  "live": true,
  "token": "abcdefghijklmnopqrstuvw",
  "tunnel_id": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "updated": "2026-06-30T12:00:00Z",
  "url": "https://abcdefghijklmnopqrstuvw.clor.host"
}
</output-example>

<examples-good>
- clor tunnel link delete 0193abc7-bbbb-7c21-9a1b-000000000002    # revoke one link by its id
- clor tunnel link delete 0193abc7-bbbb-7c21-9a1b-000000000002 --stdout-format json | jq .live    # JSON: confirm the link is no longer live
</examples-good>

<examples-bad>
- clor tunnel link delete    # the link id is required
- clor tunnel link delete a b    # exactly one id
</examples-bad>
</help>


<help command="clor tunnel link list">
<summary>List a tunnel's links</summary>
<usage>clor tunnel link list <ID></usage>

<uses>
- the user wants to see a tunnel's links and which are still live
</uses>

<output>json outputs the whole envelope {tunnel_id, links[]}; jsonl outputs each link on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "links": [
    {
      "created": "2026-06-30T12:00:00Z",
      "expires": "2026-07-01T12:00:00Z",
      "id": "0193abc7-cccc-7c21-9a1b-000000000003",
      "live": true,
      "token": "abcdefghijklmnopqrstuvw",
      "tunnel_id": "0193abc7-aaaa-7c21-9a1b-000000000001",
      "updated": "2026-06-30T12:00:00Z",
      "url": "https://abcdefghijklmnopqrstuvw.clor.host"
    }
  ],
  "tunnel_id": "0193abc7-aaaa-7c21-9a1b-000000000001"
}
</output-example>

<examples-good>
- clor tunnel link list 0193abc7-aaaa-7c21-9a1b-000000000001    # logfmt: one event=link line per link
- clor tunnel link list 0193abc7-aaaa-7c21-9a1b-000000000001 --stdout-format json | jq '.links[] | select(.live)'    # JSON: only live links
- clor tunnel link list 0193abc7-aaaa-7c21-9a1b-000000000001 --stdout-format jsonl | jq -c 'select(.event=="link")'    # JSONL: one object per link
</examples-good>

<examples-bad>
- clor tunnel link list    # the tunnel id is required
- clor tunnel link list a b    # exactly one id
</examples-bad>
</help>

<help command="clor tunnel list">
<summary>List the tunnels the caller owns</summary>
<usage>clor tunnel list</usage>

<uses>
- the user wants to see their tunnels and which are online
</uses>

<output>json outputs the whole envelope {tunnels[]}; jsonl outputs each tunnel on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "tunnels": [
    {
      "cert_expires": "2027-06-30T12:00:00Z",
      "created": "2026-06-30T12:00:00Z",
      "host": "jakes-mbp",
      "id": "0193abc7-aaaa-7c21-9a1b-000000000001",
      "name": "api",
      "online": true,
      "owner": "0193abc7-1111-7c21-9a1b-000000000002",
      "owner_team_id": "0193abc7-0000-7c21-9a1b-000000000000",
      "port": 0,
      "subdomain": "myapp",
      "target": "127.0.0.1:3000",
      "updated": "2026-06-30T12:00:00Z",
      "url": "https://myapp.clor.host"
    }
  ]
}
</output-example>

<examples-good>
- clor tunnel list    # logfmt: one event=tunnel line per tunnel
- clor tunnel list --stdout-format json | jq '.tunnels[] | {id, subdomain, online}'    # JSON: pull routing and status
- clor tunnel list --stdout-format jsonl | jq -c 'select(.event=="tunnel" and .online==true)'    # JSONL: only online tunnels
</examples-good>

<examples-bad>
- clor tunnel list foo    # no positional arguments accepted
- clor tunnel list --stdout-format yaml    # only text, jsonl, json supported
</examples-bad>
</help>

<help command="clor tunnel show">
<summary>Show one tunnel with its links and live connection status</summary>
<usage>clor tunnel show <ID></usage>

<uses>
- the user wants the full state of one tunnel, including its links
- checking whether a tunnel's daemon is currently connected
</uses>

<output>json outputs {tunnel, links[]}; text and jsonl output one event=tunnel line followed by one event=link per link.</output>

<output-example format="json">
{
  "links": [
    {
      "created": "2026-06-30T12:00:00Z",
      "expires": "2026-07-01T12:00:00Z",
      "id": "0193abc7-cccc-7c21-9a1b-000000000003",
      "live": true,
      "token": "abcdefghijklmnopqrstuvw",
      "tunnel_id": "0193abc7-aaaa-7c21-9a1b-000000000001",
      "updated": "2026-06-30T12:00:00Z",
      "url": "https://abcdefghijklmnopqrstuvw.clor.host"
    }
  ],
  "tunnel": {
    "cert_expires": "2027-06-30T12:00:00Z",
    "created": "2026-06-30T12:00:00Z",
    "host": "jakes-mbp",
    "id": "0193abc7-aaaa-7c21-9a1b-000000000001",
    "name": "api",
    "online": true,
    "owner": "0193abc7-1111-7c21-9a1b-000000000002",
    "owner_team_id": "0193abc7-0000-7c21-9a1b-000000000000",
    "port": 0,
    "subdomain": "myapp",
    "target": "127.0.0.1:3000",
    "updated": "2026-06-30T12:00:00Z",
    "url": "https://myapp.clor.host"
  }
}
</output-example>

<examples-good>
- clor tunnel show 0193abc7-aaaa-7c21-9a1b-000000000001    # logfmt: the tunnel then one event=link per link
- clor tunnel show 0193abc7-aaaa-7c21-9a1b-000000000001 --stdout-format json | jq '.tunnel.online'    # JSON: is the daemon connected
- clor tunnel show 0193abc7-aaaa-7c21-9a1b-000000000001 --stdout-format json | jq '.links[].url'    # JSON: list the tunnel's link URLs
</examples-good>

<examples-bad>
- clor tunnel show    # the tunnel id is required
- clor tunnel show a b    # exactly one id
</examples-bad>
</help>

<help command="clor tunnel update">
<summary>Change a tunnel's target or name, or set, change, or clear its subdomain</summary>
<usage>clor tunnel update <ID> [flags]</usage>

<uses>
- pointing a tunnel at a different local port
- claiming, changing, or releasing a subdomain
</uses>

<flags>
- --name string: new human label
- --subdomain string: new subdomain to claim, or "" to clear the current one
- --target string: new local target address (http, https, or h2c)
</flags>

<output>json outputs the updated tunnel object; text and jsonl output one event=tunnel line.</output>

<output-example format="json">
{
  "cert_expires": "2027-06-30T12:00:00Z",
  "created": "2026-06-30T12:00:00Z",
  "host": "jakes-mbp",
  "id": "0193abc7-aaaa-7c21-9a1b-000000000001",
  "name": "api",
  "online": true,
  "owner": "0193abc7-1111-7c21-9a1b-000000000002",
  "owner_team_id": "0193abc7-0000-7c21-9a1b-000000000000",
  "port": 0,
  "subdomain": "myapp",
  "target": "127.0.0.1:3000",
  "updated": "2026-06-30T12:00:00Z",
  "url": "https://myapp.clor.host"
}
</output-example>

<examples-good>
- clor tunnel update 0193abc7-aaaa-7c21-9a1b-000000000001 --target 127.0.0.1:4000    # retarget the tunnel
- clor tunnel update 0193abc7-aaaa-7c21-9a1b-000000000001 --subdomain myapp    # claim or change the subdomain
- clor tunnel update 0193abc7-aaaa-7c21-9a1b-000000000001 --subdomain ""    # release the subdomain
</examples-good>

<examples-bad>
- clor tunnel update 0193abc7-aaaa-7c21-9a1b-000000000001    # pass at least one of --target, --name, --subdomain
- clor tunnel update 0193abc7-aaaa-7c21-9a1b-000000000001 --subdomain admin    # admin is reserved
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

