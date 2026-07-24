---
name: secret
description: Encrypted secret storage for credentials, API keys, passwords, tokens, and structured JSON. Use when the user wants to save or retrieve a secret, list secret names without revealing values, or delete a stored secret.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Secrets reference

<help command="clor secret">
<summary>Store and retrieve named JSON secrets for the signed-in user</summary>
<description>Server-side vault for credentials, API keys, and structured JSON.
Values are sealed at rest (AES-GCM, per-row HKDF keys) and stored
under a name. Other clor subcommands fetch from this vault at
runtime (e.g. `clor email`).</description>
<usage>clor secret [flags]</usage>

<uses>
- the user wants to save credentials, tokens, or structured secrets
- another command needs to fetch credentials at runtime instead of
    accepting them on the command line
</uses>

<subcommands>
- delete: Permanently remove a secret by name
- get: Read the full decrypted JSON value of one named secret
- list: List metadata for secrets (names, types) without revealing the values
- set: Create or update an encrypted JSON secret under a given name
</subcommands>

<flags>
- --help bool: help for secret
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


<help command="clor secret delete">
<summary>Permanently remove a secret by name</summary>
<description>Permanent: no soft-delete or recovery window for secrets.</description>
<usage>clor secret delete <NAME></usage>

<output>json outputs the whole envelope {deleted, name}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "deleted": true,
  "name": "email/work"
}
</output-example>

<examples-good>
- clor secret delete email/work    # delete a secret
- clor secret delete shared/contacts    # delete by name
- clor secret delete email/work --stdout-format json | jq .deleted    # scriptable confirmation
</examples-good>

<examples-bad>
- clor secret delete    # name argument is required
- clor secret delete email/work extra    # delete takes exactly one name
</examples-bad>
</help>

<help command="clor secret get">
<summary>Read the full decrypted JSON value of one named secret</summary>
<description>--stdout-format json prints the raw JSON value alone (ideal for
piping); text/jsonl include the value alongside metadata. Use list
when you only need names without exposing values.</description>
<usage>clor secret get <NAME></usage>

<examples-good>
- clor secret get email/work --stdout-format json    # print the raw JSON value alone
- clor secret get email/work --stdout-format json | clor email list --stdin-format json    # pipe credentials into another command
- clor secret get email/work    # logfmt with metadata + value_json
- clor secret get email/work --stdout-format json | jq .address    # read one field from the value
</examples-good>

<examples-bad>
- clor secret get    # name argument is required
- clor secret get email/work extra    # get takes exactly one name
</examples-bad>
</help>

<help command="clor secret list">
<summary>List metadata for secrets (names, types) without revealing the values</summary>
<description>Values are never returned (use `secret get`). Filter by --type,
--name-prefix, or --name-contains.</description>
<usage>clor secret list [flags]</usage>

<flags>
- --name-contains string: filter to secrets whose name contains this substring
- --name-prefix string: filter to secrets whose name starts with this string
- --type string: filter by exact type (e.g. email-account)
</flags>

<output>json outputs the whole envelope {secrets[]}. jsonl outputs each record from secrets on its own line; text is the logfmt of the same keys, an event=list header line then one event=result line per record.</output>

<output-example format="json">
{
  "secrets": [
    {
      "accessed": "2026-02-03T18:05:00Z",
      "created": "2026-01-14T09:30:00Z",
      "id": "0190f3a1-7c2e-7e44-9b3a-1f2c4d5e6a7b",
      "name": "email/work",
      "revision": 0,
      "type": "email-account",
      "updated": "2026-01-14T09:30:00Z"
    },
    {
      "created": "2026-01-20T11:00:00Z",
      "id": "0190f3a1-9d4f-7a11-8c52-2e3b6f7a8c9d",
      "name": "shared/contacts",
      "revision": 0,
      "type": "generic",
      "updated": "2026-01-22T14:12:00Z"
    }
  ]
}
</output-example>

<examples-good>
- clor secret list    # every saved secret, logfmt
- clor secret list --type email-account --stdout-format json | jq '.secrets[].name'    # names of every email-account secret
- clor secret list --name-prefix login/    # every secret whose name starts with login/
- clor secret list --name-contains github    # substring match against secret names
- clor secret list --stdout-format jsonl | grep '^{"event":"result"'    # drop the header line
</examples-good>

<examples-bad>
- clor secret list secret-name    # list takes no arguments; use `clor secret get <NAME>`
- clor secret list --stdout-format yaml    # format must be text, jsonl, or json
</examples-bad>
</help>

<help command="clor secret set">
<summary>Create or update an encrypted JSON secret under a given name</summary>
<description>Value source: --value (literal JSON) or --value-file (path or - for
stdin). Re-running with the same name updates in place. --type tags
the secret for typed consumers like `clor email account`.</description>
<usage>clor secret set <NAME> [flags]</usage>

<flags>
- --type string: type discriminator the consumer interprets (e.g. email-account, api-token) (default "generic")
- --value string: secret value as a JSON string (e.g. '{"k":"v"}')
- --value-file string: path to a file containing the JSON value (- for stdin)
</flags>

<output>json outputs the secret metadata object {id, name, type, created, updated, accessed}. The value is never echoed back. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "created": "2026-01-14T09:30:00Z",
  "id": "0190f3a1-7c2e-7e44-9b3a-1f2c4d5e6a7b",
  "name": "email/work",
  "revision": 0,
  "type": "email-account",
  "updated": "2026-01-14T09:30:00Z"
}
</output-example>

<examples-good>
- clor secret set email/work --type email-account --value '{"address":"a@b.com","app_password":"xxxx"}'    # typed secret with inline JSON
- clor secret set api/openai --value-file ./openai.json    # load value from a file
- echo '{"key":"value"}' | clor secret set deploy/token --value-file -    # read JSON from stdin
- clor secret set test --value '{"x":1}' --stdout-format json | jq .id    # extract the new secret id
</examples-good>

<examples-bad>
- clor secret set test --value 'not json'    # value must be valid JSON
- clor secret set test --value '{"x":1}' --value-file ./x.json    # --value and --value-file are mutually exclusive
- clor secret set test    # must supply --value or --value-file
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

