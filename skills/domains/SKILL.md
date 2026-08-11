---
name: domains
description: Bulk domain availability checks across many top-level domains. Use when the user wants to find registrable product, project, or company names, check one or many domains, discover supported top-level domains, or verify candidates reported as available.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Domains reference

<help command="clor domain">
<summary>Bulk-classify domain names as available, taken, or unknown across hundreds of TLDs at huge scale</summary>
<description>Mass domain availability lookups, no rate limits. A 100,000-domain
bulk request returns in 1-2s. Supported TLDs return available or
taken; unsupported return unknown. Follow up with "verify" for a
stricter recheck of the available tail.</description>
<usage>clor domain [flags]</usage>

<uses>
- an agent is brainstorming names and wants to narrow to
    registrable candidates before talking to a registrar
- a workflow needs to check thousands or millions of names
</uses>

<skips>
- the caller needs registrar-grade certainty for a single name;
    follow up with a registrar lookup on candidates flagged available
- the caller needs whois detail (registrar, expiry, contacts);
    this command does not return them
</skips>

<subcommands>
- lookup: Check one or many domain names as available, taken, or unknown in a single bulk call
- tld: Discover which top-level domains the bulk lookup service can check
- verify: Check domain names with a stricter pass that reduces false-positive available results
</subcommands>

<flags>
- --help bool: help for domain
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


<help command="clor domain lookup">
<summary>Check one or many domain names as available, taken, or unknown in a single bulk call</summary>
<description>Status values:
  - taken: registered. ~1 in 65,000 false alarms.
  - available: not currently registered. NOT the same as
    "registrable today". Premium, reserved, and recently-dropped
    names all read available. Confirm with a registrar.
  - unknown: TLD not supported, so the service did not check it.

Stdin: one-per-line text (--stdin-format text), or JSON array
(--stdin-format json). Inputs >100,000 auto-split into chunks.</description>
<usage>clor domain lookup [DOMAIN] [flags]</usage>

<flags>
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {results[], checked}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=lookup header line on stderr then one event=result line per domain on stdout.</output>

<output-example format="json">
{
  "checked": 2,
  "results": [
    {
      "domain": "example.com",
      "status": "taken"
    },
    {
      "domain": "asdfqwer.dev",
      "status": "available"
    },
    {
      "domain": "weird.zip",
      "status": "unknown"
    }
  ]
}
</output-example>

<examples-good>
- clor domain lookup example.com    # single domain; prints status to stdout
- clor domain lookup --stdin-format text --stdout-format json < candidates.txt | jq -r '.results[] | select(.status=="available") | .domain' | wc -l    # agent loop: count how many candidates from a file are registrable
- echo '["foo.dev","bar.dev","baz.dev"]' | clor domain lookup --stdin-format json --stdout-format jsonl | grep '^{"event":"result"'    # structured JSONL stream, one record per domain
- clor inference openai text --model gpt-5.4-mini --system "Generate 30 short brandable .com/.dev/.ai domain ideas for an AI music tool, one per line, lowercase, with TLD, no commentary." "go" | clor domain lookup --stdin-format text --stdout-format json | jq -r '.results[] | select(.status=="available") | .domain'    # brainstorm-and-check pipeline. Cheap small-model name ideas piped straight into bulk availability lookup
- clor domain lookup totally-not-real-1234.zip --stdout-format text    # logfmt summary on stderr plus per-result lines on stdout
</examples-good>

<examples-bad>
- clor domain lookup    # no input: pass a positional or --stdin-format text|json
- clor domain lookup foo.com --stdin-format text    # positional and --stdin-format are mutually exclusive
- clor domain lookup not_a_domain    # rejected by the server: must look like a domain (labels separated by dots)
</examples-bad>
</help>

<help command="clor domain tld">
<summary>Discover which top-level domains the bulk lookup service can check</summary>
<usage>clor domain tld</usage>

<uses>
- the user wants to see which TLDs the bulk lookup service can check before sending a request
</uses>

<subcommands>
- list: List the TLDs the service checks, ordered by US-biased popularity
</subcommands>
</help>


<help command="clor domain tld list">
<summary>List the TLDs the service checks, ordered by US-biased popularity</summary>
<description>Ranked by US-biased popularity (Tranco top-1M frequency with US
institutional and tech-startup TLDs hoisted). --limit 0 returns
every supported TLD.</description>
<usage>clor domain tld list [flags]</usage>

<flags>
- --limit int: max TLDs to return (0 for all) (default "100")
</flags>

<output>json outputs the whole envelope {tlds[], loaded}. jsonl outputs each record from tlds on its own line; text is the logfmt of the same keys, an event=tlds header line on stderr then one event=tld line per record on stdout.</output>

<output-example format="json">
{
  "loaded": "2026-05-08T19:12:01Z",
  "tlds": [
    "com",
    "org",
    "net",
    "io",
    "dev",
    "ai",
    "app",
    "co"
  ]
}
</output-example>

<examples-good>
- clor domain tld list    # top 100 TLDs by US-biased popularity, logfmt
- clor domain tld list --limit 0 --stdout-format json | jq -r '.tlds[]'    # every supported TLD as a JSON array
- clor domain tld list --limit 25 --stdout-format jsonl | grep '^{"event":"tld"'    # top 25 TLDs as JSONL, one record per line
</examples-good>

<examples-bad>
- clor domain tld list com    # no positional arguments accepted
- clor domain tld list --limit -1    # --limit must be >= 0
</examples-bad>
</help>

<help command="clor domain verify">
<summary>Check domain names with a stricter pass that reduces false-positive available results</summary>
<description>Same input/output shape as "lookup" but slower per domain. Use on the
narrow tail of a pipeline (candidates "lookup" already flagged as
available), not on bulk inputs.</description>
<usage>clor domain verify [DOMAIN] [flags]</usage>

<flags>
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>json outputs the whole envelope {results[], checked}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=lookup header line on stderr then one event=result line per domain on stdout.</output>

<output-example format="json">
{
  "checked": 2,
  "results": [
    {
      "domain": "example.com",
      "status": "taken"
    },
    {
      "domain": "asdfqwer.dev",
      "status": "available"
    }
  ]
}
</output-example>

<examples-good>
- clor domain verify example.com    # single domain stricter check; prints status to stdout
- clor domain lookup --stdin-format text --stdout-format json < candidates.txt | jq -r '.results[] | select(.status=="available") | .domain' | clor domain verify --stdin-format text --stdout-format json | jq -r '.results[] | select(.status=="available") | .domain'    # two-stage pipeline: cheap broad lookup, then stricter verify on the narrow tail
- echo '["foo.dev","bar.dev"]' | clor domain verify --stdin-format json --stdout-format jsonl | grep '^{"event":"result"'    # structured JSONL stream, one record per domain
</examples-good>

<examples-bad>
- clor domain verify    # no input: pass a positional or --stdin-format text|json
- clor domain verify foo.com --stdin-format text    # positional and --stdin-format are mutually exclusive
- clor domain verify not_a_domain    # rejected by the server: must look like a domain (labels separated by dots)
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

