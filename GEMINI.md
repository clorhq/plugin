# Clor

Clor gives you a toolkit for working outside the repo: web research, AI
text, image, and audio generation, social platforms, email, cloud files,
encrypted secrets, weather, domains, and background agents called claws.

Everything runs through the `clor` CLI. If it is not on the PATH, install
it with `curl -fsSL https://clor.com/install.sh | bash`.

## You run clor, the user does not

Run `clor` commands yourself. Do not hand the user CLI snippets, flag
walkthroughs, or syntax explanations unless they ask for them. When usage
is unclear, read the relevant `clor ... --help`; live help wins over
anything written here. Use only documented subcommands, flags, and values.
Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a
credential, confirmation of a side effect), ask one plain question, then
run the command. If clor is missing, signed out, or blocked, say so and
ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe.
Do not loop. Report results, not recipes.

## Capabilities

| Command | What it does |
| --- | --- |
| `clor webgrep` | Search pages, news, images, and videos; scrape, parse, map, crawl, and screenshot URLs; extract text from PDFs |
| `clor ai` | Text, image, and audio generation across Claude, GPT, Gemini, OpenRouter, and ElevenLabs |
| `clor claw` | Background subagents that run on demand or on a schedule |
| `clor mail` | Read, search, send, and triage email over IMAP and SMTP |
| `clor drive` | Cloud file storage with personal and shared drives, ACL grants, and public links |
| `clor secret` | Encrypted vault for credentials, API keys, and structured JSON |
| `clor site` | Static web hosting over HTTPS with custom domains, atomic deploys, and rollbacks |
| `clor tunnel` | Reverse HTTP tunnels exposing a local server at a public URL |
| `clor space` | Disposable coding-agent environments bound to your nodes |
| `clor memory` | Shared long-term memory and wiki across every coding agent you run |
| `clor hackernews` | Search stories and comments; fetch a story with its full comment tree |
| `clor bluesky` | Read and post on Bluesky over the AT Protocol |
| `clor slack` | Post, react, search, and stream Slack events as your connected account |
| `clor linear` | Issues, projects, cycles, and documents in a connected Linear workspace |
| `clor weather` | Forecasts, history, air quality, alerts, marine and tide data |
| `clor domains` | Bulk domain availability checks across hundreds of TLDs |
| `clor yc` | Query the Y Combinator company and founder directory |

Run `clor --help` for the authoritative list.

## Getting started

Ask in plain language and pick the right capability yourself:

```
What's the latest news on the federal reserve interest rate decision?
Scrape https://example.com and summarise it.
Generate an image of a watercolor sunrise.
```

More information: https://clor.com
