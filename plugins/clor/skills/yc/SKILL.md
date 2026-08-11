---
name: yc
description: Y Combinator company and founder directory. Use when the user wants to search or filter YC startups by topic, batch, industry, status, hiring, or team size, find founders by name or region, or inspect a full company or founder record.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Y Combinator reference

<help command="clor social yc">
<summary>Search Y Combinator companies and founders by text, batch, industry, region, tag, status, or slug</summary>
<description>The YC directory as a queryable index. Full-text search and
filter ~6k companies by batch, status, industry, tag, and team size, and
~13k founders by batch, industry, region, and current company. Show pulls
the full joined record.</description>
<usage>clor social yc [flags]</usage>

<uses>
- the user wants to find YC companies matching a topic, batch, or industry
- the user wants the full record for one YC company including its founders
- the user wants to find YC founders by name, batch, region, or company
- the user wants one founder's profile plus their current company
</uses>

<subcommands>
- company: Search Y Combinator companies by text, batch, industry, tag, status, or team size, or show one by slug
- founder: Search Y Combinator founders by text, batch, industry, region, or current company, or show one by slug
</subcommands>

<flags>
- --help bool: help for yc
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

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</output>
</help>


<help command="clor social yc company">
<summary>Search Y Combinator companies by text, batch, industry, tag, status, or team size, or show one by slug</summary>
<description>Search and filter the YC company index, or show one company by
slug with its canonical founder list.</description>
<usage>clor social yc company</usage>

<uses>
- the user wants to find YC companies by topic, batch, industry, tag, status, or team size
- the user has a company slug and wants its full record plus founder list
</uses>

<subcommands>
- search: Search Y Combinator companies by text, batch, industry, tag, status, or team size
- show: Show one Y Combinator company by slug with its founder list
</subcommands>

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</output>
</help>


<help command="clor social yc company search">
<summary>Search Y Combinator companies by text, batch, industry, tag, status, or team size</summary>
<description>Returns slug, name, one-liner, batch, status, team size, and
industry. Pass a slug to `social yc company show` for the full
record. With no query the result is a browseable listing.</description>
<usage>clor social yc company search [QUERY] [flags]</usage>

<flags>
- --batch string: exact YC company batch name, not a founder batch code (e.g. "Winter 2023", not W23)
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: id,slug*,name*,one_liner*,batch*,status*,stage,team_size*,industry*,subindustry,website*,all_locations,launched,founder_count*,is_hiring,nonprofit,top_company*,regions,industries,tags,former_names,long_description,directory_url,small_logo_thumbnail_url (* = default)
- --hiring bool: restrict to companies that are hiring
- --industry string: exact match on the primary industry
- --limit int: max results (1-200) (default "20")
- --min-team-size int: restrict to team size >= N
- --nonprofit bool: restrict to nonprofits
- --offset int: skip the first N results (pagination)
- --sort string: sort order (team_size|batch|relevance); relevance requires a query
- --stage string: exact match on stage
- --status string: exact match on status (Active|Inactive|Acquired|Public)
- --tag string: exact match on a company tag, quote multi-word values (e.g. "Developer Tools")
- --top bool: restrict to YC top companies
</flags>

<output>json outputs the whole envelope {results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "results": [
    {
      "batch": "Summer 2009",
      "founder_count": 2,
      "id": 1594,
      "industry": "Fintech",
      "is_hiring": true,
      "name": "Stripe",
      "nonprofit": false,
      "one_liner": "Economic infrastructure for the internet",
      "slug": "stripe",
      "status": "Active",
      "tags": [
        "Fintech",
        "Payments",
        "SaaS"
      ],
      "team_size": 8000,
      "top_company": true,
      "website": "https://stripe.com"
    }
  ]
}
</output-example>

<examples-good>
- clor social yc company search "fintech"    # free-text search across name and descriptions
- clor social yc company search "payments" --batch "Winter 2023" --sort relevance    # one batch, ranked by relevance
- clor social yc company search --tag Fintech --top --min-team-size 100    # filter-only, no free-text query
- clor social yc company search "ai" --sort team_size --stdout-format json | jq '.results[].slug'    # single-object JSON, extract slugs
- clor social yc company search "devtools" --stdout-format jsonl | jq -c 'select(.event=="result") | {slug, name}'    # JSONL piped through jq
- clor social yc company search "climate" --fields slug,name,tags    # render only chosen fields
</examples-good>

<examples-bad>
- clor social yc company search --sort relevance    # relevance requires a query argument
- clor social yc company search --batch W23    # company --batch expects a full batch name like "Winter 2023"
- clor social yc company search "x" --limit 500    # max --limit is 200
- clor social yc company search "x" --stdout-format yaml    # only text, jsonl, or json supported
- clor social yc company search "x" --sort score    # sort must be team_size, batch, or relevance
</examples-bad>
</help>


<help command="clor social yc company show">
<summary>Show one Y Combinator company by slug with its founder list</summary>
<description>Returns the full company record plus YC's canonical founder
list, one event=founder depth=1 line per founder.</description>
<usage>clor social yc company show <SLUG></usage>

<output>json outputs the whole envelope {company, founders[]} with founders nested under the company. text and jsonl flatten to a company header followed by one event=founder depth=1 line per founder; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "company": {
    "batch": "Summer 2009",
    "founder_count": 2,
    "id": 1594,
    "industry": "Fintech",
    "is_hiring": true,
    "name": "Stripe",
    "nonprofit": false,
    "one_liner": "Economic infrastructure for the internet",
    "slug": "stripe",
    "status": "Active",
    "tags": [
      "Fintech",
      "Payments",
      "SaaS"
    ],
    "team_size": 8000,
    "top_company": true,
    "website": "https://stripe.com"
  },
  "founders": [
    {
      "full_name": "Patrick Collison",
      "hacker_news_username": "patrickc",
      "title": "CEO",
      "url_slug": "patrick-collison",
      "yc_id": 312
    },
    {
      "full_name": "John Collison",
      "title": "President",
      "url_slug": "john-collison",
      "yc_id": 313
    }
  ]
}
</output-example>

<examples-good>
- clor social yc company show stripe    # full record plus founders, as logfmt
- clor social yc company show stripe --stdout-format json | jq '.founders[].full_name'    # extract founder names via JSON
- clor social yc company show airbnb --stdout-format jsonl | jq -c 'select(.event=="founder")'    # JSONL filtered to founders
</examples-good>

<examples-bad>
- clor social yc company show    # a slug argument is required
- clor social yc company show "Stripe Inc"    # expects the directory slug, not the display name
</examples-bad>
</help>

<help command="clor social yc founder">
<summary>Search Y Combinator founders by text, batch, industry, region, or current company, or show one by slug</summary>
<description>Search and filter the YC founder index, or show one founder by
slug with their current company.</description>
<usage>clor social yc founder</usage>

<uses>
- the user wants to find YC founders by name, batch, industry, region, or current company
- the user has a founder slug and wants their full profile plus current company
</uses>

<subcommands>
- search: Search Y Combinator founders by text, batch, industry, region, or current company
- show: Show one Y Combinator founder by slug with their current company
</subcommands>

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader).</output>
</help>


<help command="clor social yc founder search">
<summary>Search Y Combinator founders by text, batch, industry, region, or current company</summary>
<description>Returns url slug, full name, current title, current company, and
region. Pass a slug to `social yc founder show` for the full
record. With no query the result is a browseable listing.</description>
<usage>clor social yc founder search [QUERY] [flags]</usage>

<flags>
- --batch string: exact YC founder batch code, not a company batch name (e.g. W23, not "Winter 2023")
- --company string: match founders whose current company slug equals this value, not the display name
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: id,url_slug*,full_name*,first_name,last_name,current_title*,current_company_name*,current_company_slug*,current_region*,hacker_news_username,top_company*,batches*,titles,parent_industries,subindustries,all_companies_text,avatar_thumbnail_url,email*,phone* (* = default)
- --industry string: match founders in this parent industry
- --limit int: max results (1-200) (default "20")
- --offset int: skip the first N results (pagination)
- --region string: exact match on the founder's current region, quote multi-word values (e.g. "United States of America")
- --sort string: sort order (name|relevance); relevance requires a query
- --top bool: restrict to founders of YC top companies
</flags>

<output>json outputs the whole envelope {results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "results": [
    {
      "batches": [
        "S09"
      ],
      "current_company_name": "Stripe",
      "current_company_slug": "stripe",
      "current_region": "United States of America",
      "current_title": "CEO",
      "full_name": "Patrick Collison",
      "id": 312,
      "top_company": true,
      "url_slug": "patrick-collison"
    }
  ]
}
</output-example>

<examples-good>
- clor social yc founder search "rust"    # free-text search across name and company
- clor social yc founder search "machine learning" --region France --sort relevance    # one region, ranked by relevance
- clor social yc founder search --batch W23 --industry Fintech    # filter-only, no free-text query
- clor social yc founder search "payments" --company stripe --stdout-format json | jq '.results[].full_name'    # single-object JSON, extract names
- clor social yc founder search "ai" --stdout-format jsonl | jq -c 'select(.event=="result") | {url_slug, full_name}'    # JSONL piped through jq
- clor social yc founder search "design" --fields full_name,current_company_name    # render only chosen fields
</examples-good>

<examples-bad>
- clor social yc founder search --sort relevance    # relevance requires a query argument
- clor social yc founder search --batch "Winter 2023"    # founder --batch expects a batch code like W23
- clor social yc founder search "x" --limit 500    # max --limit is 200
- clor social yc founder search "x" --sort batch    # sort must be name or relevance
</examples-bad>
</help>


<help command="clor social yc founder show">
<summary>Show one Y Combinator founder by slug with their current company</summary>
<description>Returns the full founder record plus their current company,
resolved by company slug, as an event=company depth=1 line.</description>
<usage>clor social yc founder show <SLUG></usage>

<output>json outputs the whole envelope {founder, company} with the company nested under the founder. text and jsonl flatten to a founder header followed by an event=company depth=1 line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "company": {
    "batch": "Summer 2009",
    "founder_count": 2,
    "id": 1594,
    "industry": "Fintech",
    "is_hiring": false,
    "name": "Stripe",
    "nonprofit": false,
    "one_liner": "Economic infrastructure for the internet",
    "slug": "stripe",
    "status": "Active",
    "team_size": 8000,
    "top_company": true
  },
  "founder": {
    "batches": [
      "S09"
    ],
    "current_company_name": "Stripe",
    "current_company_slug": "stripe",
    "current_region": "United States of America",
    "current_title": "CEO",
    "full_name": "Patrick Collison",
    "hacker_news_username": "patrickc",
    "id": 312,
    "top_company": true,
    "url_slug": "patrick-collison"
  }
}
</output-example>

<examples-good>
- clor social yc founder show patrick-collison    # full record plus current company, as logfmt
- clor social yc founder show patrick-collison --stdout-format json | jq '{name: .founder.full_name, company: .company.slug}'    # join founder and company via JSON
- clor social yc founder show patrick-collison --stdout-format jsonl | jq -c 'select(.event=="company")'    # JSONL filtered to the company line
</examples-good>

<examples-bad>
- clor social yc founder show    # a slug argument is required
- clor social yc founder show "Patrick Collison"    # expects the profile slug, not the display name
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

