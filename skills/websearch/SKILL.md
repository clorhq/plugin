---
name: websearch
description: Web search and scraping for live pages, news, images, videos, URLs, and PDFs. Use when the user needs fresh online information, wants a page or PDF read, a site mapped or crawled, or a rendered webpage screenshot.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Web search reference

<help command="clor search">
<summary>Search the web (pages, news, images, videos), then scrape, parse, map, crawl, or screenshot URLs</summary>
<description>Search the open web across pages, news, images, and videos; pull
a single URL down as markdown, HTML, or links; extract clean text
from PDFs and HTML documents; map or crawl an entire site; and
capture pixel-accurate screenshots of any page.</description>
<usage>clor search [flags]</usage>

<uses>
- the user asks for current, recent, or post-knowledge-cutoff information from the open web
- the user wants the textual contents of a specific URL (markdown, HTML, or extracted PDF text)
- the user wants to enumerate or crawl a whole site
- the user wants a rendered image of a page (mobile viewport, full-page, or above-the-fold)
</uses>

<subcommands>
- crawl: Crawl a site from a seed URL and return per-page content
- image: Search the open web for images by query
- map: Discover URLs reachable from a seed URL on the same site
- news: Search recent news articles across mainstream sources
- parse: Extract clean text from a PDF or HTML document URL as markdown
- scrape: Scrape a single page as markdown, HTML, links, or screenshot
- screenshot: Capture a screenshot of a page and save it locally as PNG
- video: Search the open web for videos, with duration metadata
- web: Search the open web for pages, articles, and documents
</subcommands>

<flags>
- --help bool: help for search
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

