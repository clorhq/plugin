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


<help command="clor search crawl">
<summary>Crawl a site from a seed URL and return per-page content</summary>
<description>Fetches every reachable page up to the configured ceilings (max
pages, max depth, max duration). Each page returns in the requested
formats (markdown, HTML, raw HTML, links). Use map instead when you
only need the URL list.</description>
<usage>clor search crawl <URL> [flags]</usage>

<flags>
- --allow-subdomains bool: follow subdomain links
- --crawl-entire-domain bool: follow non-descendant paths within the same domain
- --exclude string: comma-separated path regexes to skip
- --formats string: comma-separated per-page formats (markdown|html|raw_html|links)
- --include string: comma-separated path regexes to include
- --max-depth int: discovery-depth limit relative to the seed URL
- --max-duration duration: absolute deadline for the crawl (e.g. 30s, 1h30m); on expiry partial results are returned (default "0s")
- --max-pages int: hard ceiling on pages crawled
- --no-main-content bool: include all page content per page
- --only-main-content bool: drop nav/header/footer per page
</flags>

<output>json outputs the whole envelope {url, completed, pages_count, pages[]}, each page the same shape scrape returns. jsonl outputs each record from pages on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "completed": true,
  "pages": [
    {
      "markdown": "# Getting started\n\nInstall the package, configure your credentials, and run your first query.\n",
      "metadata": {
        "language": "en",
        "status_code": 200,
        "title": "Getting started"
      },
      "url": "https://example.com/docs/getting-started"
    },
    {
      "markdown": "# Configuration\n\nEvery option can be set through a flag or an environment variable.\n",
      "metadata": {
        "language": "en",
        "status_code": 200,
        "title": "Configuration"
      },
      "url": "https://example.com/docs/configuration"
    }
  ],
  "pages_count": 2,
  "url": "https://example.com"
}
</output-example>

<examples-good>
- clor search crawl https://example.com --max-pages 10    # summary line + one event=page line per page
- clor search crawl https://example.com --max-duration 30s --max-pages 100    # 30s deadline; whatever pages were collected are returned
- clor search crawl https://example.com --max-duration 1h30m    # long-running crawl; absolute ceiling is 2h
- clor search crawl https://example.com --include /docs/ --exclude /archive/    # path-filtered crawl
- clor search crawl https://example.com --stdout-format json | jq -r '.pages[].url'    # URLs of crawled pages via jq
</examples-good>

<examples-bad>
- clor search crawl    # missing required <URL>
- clor search crawl https://example.com --max-pages 0    # must be >= 1; omit the flag for the default
- clor search crawl example.com    # URL must include http:// or https://
- clor search crawl https://example.com --only-main-content --no-main-content    # mutually exclusive
</examples-bad>
</help>

<help command="clor search image">
<summary>Search the open web for images by query</summary>
<usage>clor search image</usage>

<uses>
- the user wants images by free-text query
</uses>

<subcommands>
- search: Search the open web for images matching a query (max 200, no pagination)
</subcommands>
</help>


<help command="clor search image search">
<summary>Search the open web for images matching a query (max 200, no pagination)</summary>
<usage>clor search image search <QUERY> [flags]</usage>

<flags>
- --country string: 2-letter country code, ISO 3166-1 alpha-2 (us, ar, jp)
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: title*,image_url*,page_url*,source*,thumbnail_url (* = default)
- --limit int: max results (1-200); pagination is handled automatically (default "5")
- --safesearch string: safe-search level (off|moderate|strict)
</flags>

<output>json outputs the whole envelope {query, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "query": "northern lights",
  "results": [
    {
      "image_url": "https://images.example.com/aurora.jpg",
      "page_url": "https://example.com/aurora",
      "source": "example.com",
      "thumbnail_url": "https://images.example.com/aurora-thumb.jpg",
      "title": "Aurora over Tromso"
    }
  ]
}
</output-example>

<examples-good>
- clor search image search "northern lights"    # default 5 image results in logfmt; thumbnail_url omitted by default
- clor search image search "logos" --limit 200 --stdout-format json | jq -r '.results[].image_url'    # max 200 image URLs via jq
- clor search image search "logos" | grep '^event=result '    # keep only result lines
- clor search image search "logos" --safesearch off --fields all    # drop safesearch, include thumbnail_url
</examples-good>

<examples-bad>
- clor search image search    # missing required <QUERY>
- clor search image search "x" --limit 250    # max --limit is 200 for images
- clor search image search "x" --freshness pw    # no --freshness on images endpoint
- clor search image search "x" --fields foo    # unknown field name
</examples-bad>
</help>

<help command="clor search map">
<summary>Discover URLs reachable from a seed URL on the same site</summary>
<description>Returns the discovered URLs (with optional title and description).
Lighter than crawl: URL list only, not page contents.</description>
<usage>clor search map <URL> [flags]</usage>

<flags>
- --ignore-query-parameters bool: treat URLs that differ only in query string as duplicates
- --include-subdomains bool: follow subdomain links
- --limit int: max URLs to return
- --search string: filter discovered URLs by substring
- --timeout duration: per-request timeout (e.g. 60s, 2m) (default "0s")
</flags>

<output>json outputs the whole envelope {url, links[]}. jsonl outputs each record from links on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "links": [
    {
      "description": "Articles and announcements.",
      "title": "Blog",
      "url": "https://example.com/blog"
    },
    {
      "title": "How rainbows form",
      "url": "https://example.com/blog/light-and-color"
    },
    {
      "url": "https://example.com/about"
    }
  ],
  "url": "https://example.com"
}
</output-example>

<examples-good>
- clor search map https://example.com    # list URLs as logfmt event=link lines
- clor search map https://example.com --limit 50 --stdout-format json | jq -r '.links[].url'    # URL list via jq
- clor search map https://example.com --search blog --include-subdomains    # subdomain-aware filter
- clor search map https://example.com --timeout 2m    # raise the timeout for slow sitemaps
</examples-good>

<examples-bad>
- clor search map    # missing required <URL>
</examples-bad>
</help>

<help command="clor search news">
<summary>Search recent news articles across mainstream sources</summary>
<usage>clor search news</usage>

<uses>
- the user wants recent news articles by free-text query, ranked across mainstream sources
</uses>

<subcommands>
- search: Search news articles by query, with freshness and country filters
</subcommands>
</help>


<help command="clor search news search">
<summary>Search news articles by query, with freshness and country filters</summary>
<usage>clor search news search <QUERY> [flags]</usage>

<flags>
- --country string: 2-letter country code, ISO 3166-1 alpha-2 (us, ar, jp)
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: title*,url*,description*,source*,age*,thumbnail_url (* = default)
- --freshness string: freshness window (pd=past day, pw=past week, pm=past month, py=past year)
- --limit int: max results (1-500); pagination is handled automatically (default "5")
- --safesearch string: safe-search level (off|moderate|strict)
</flags>

<output>json outputs the whole envelope {query, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "query": "AI regulation",
  "results": [
    {
      "age": "6h",
      "description": "Regulators outline disclosure requirements for model providers.",
      "source": "news.example.com",
      "thumbnail_url": "https://news.example.com/thumb/ai-rules.jpg",
      "title": "New AI rules take effect",
      "url": "https://news.example.com/ai-rules"
    }
  ]
}
</output-example>

<examples-good>
- clor search news search "AI regulation"    # default 5 items in logfmt; thumbnail_url omitted by default
- clor search news search "earnings" --limit 500 --freshness pw    # max 500 items from the past week (auto-paginates)
- clor search news search "spacex" --stdout-format json | jq -r '.results[].url'    # extract URLs via jq
- clor search news search "spacex" | grep '^event=result '    # keep only result lines
- clor search news search "spacex" --fields default,thumbnail_url    # defaults plus thumbnail_url
</examples-good>

<examples-bad>
- clor search news search    # missing required <QUERY>
- clor search news search "x" --limit 600    # max --limit is 500 for news
- clor search news search "x" --freshness 24h    # must be pd|pw|pm|py
- clor search news search "x" --fields foo    # unknown field name
</examples-bad>
</help>

<help command="clor search parse">
<summary>Extract clean text from a PDF or HTML document URL as markdown</summary>
<description>Returns the document as clean markdown plus metadata (page count,
upstream status, title). Use scrape instead for one webpage as markdown
plus links or a screenshot.</description>
<usage>clor search parse <URL> [flags]</usage>

<flags>
- --timeout duration: per-fetch timeout (e.g. 60s, 5m) (default "0s")
</flags>

<output>json outputs the whole document object {url, markdown, pages, metadata}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "markdown": "# Attention Is All You Need\n\nWe propose a new network architecture, the Transformer, based solely on attention mechanisms, dispensing with recurrence and convolutions entirely.\n",
  "metadata": {
    "num_pages": 11,
    "source_url": "https://arxiv.org/pdf/2017.03762.pdf",
    "status_code": 200,
    "title": "Attention Is All You Need"
  },
  "pages": 11,
  "url": "https://arxiv.org/pdf/2017.03762.pdf"
}
</output-example>

<examples-good>
- clor search parse https://example.com/paper.pdf    # PDF text printed to stdout as markdown
- clor search parse https://example.com/paper.pdf > paper.md    # save extracted markdown
- clor search parse https://example.com/big.pdf --timeout 5m    # raise the timeout for a long PDF
- clor search parse https://example.com/paper.pdf --stdout-format json | jq .pages    # see the page count parsed from the PDF
</examples-good>

<examples-bad>
- clor search parse    # missing required <URL>
- clor search parse https://example.com/missing.pdf    # non-2xx fetch is a hard error; use --stdout-format json to inspect the response
</examples-bad>
</help>

<help command="clor search scrape">
<summary>Scrape a single page as markdown, HTML, links, or screenshot</summary>
<description>Returns markdown (default), full HTML, raw HTML, link list, or PNG
screenshot in any combination. Strips boilerplate (nav/header/footer)
by default. Use parse instead for PDFs and document URLs.</description>
<usage>clor search scrape <URL> [flags]</usage>

<flags>
- --block-ads bool: block ads during the scrape
- --formats string: comma-separated formats (markdown|html|raw_html|links|screenshot|screenshot_full_page) (default "markdown")
- --mobile bool: render with a mobile viewport
- --no-main-content bool: include all page content
- --only-main-content bool: drop nav/header/footer (the default)
- --timeout duration: per-fetch timeout (e.g. 30s) (default "0s")
- --wait-for duration: extra wait after page load (e.g. 500ms, 2s) (default "0s")
</flags>

<output>json outputs the whole document object {url, markdown, html, links, metadata, screenshot, warning}, optional fields present only for the requested formats. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "links": [
    "https://example.com/blog",
    "https://example.com/blog/light-and-color",
    "https://example.com/about"
  ],
  "markdown": "# How rainbows form\n\nSunlight refracts as it enters a water droplet, reflects off the back, and refracts again on the way out, splitting white light into its component colors.\n",
  "metadata": {
    "description": "A short explainer on refraction and reflection inside water droplets.",
    "language": "en",
    "source_url": "https://example.com/blog/light-and-color",
    "status_code": 200,
    "title": "How rainbows form"
  },
  "url": "https://example.com/blog/light-and-color"
}
</output-example>

<examples-good>
- clor search scrape https://example.com    # markdown body printed to stdout
- clor search scrape https://example.com > page.md    # save the markdown directly
- clor search scrape https://example.com --stdout-format json | jq -r .metadata    # structured metadata via jq
- clor search scrape https://example.com --formats markdown,screenshot    # request a screenshot URL too
- clor search scrape https://example.com --formats html,links --no-main-content    # HTML and link list including chrome
- clor search scrape https://spa.example.com --wait-for 2s --timeout 60s    # JS-heavy SPA: wait 2s after load, allow 60s total
- clor search scrape https://example.com --mobile    # render with a mobile viewport
</examples-good>

<examples-bad>
- clor search scrape    # missing required <URL>
- clor search scrape https://x --formats foo    # unknown format
- clor search scrape example.com    # URL must include http:// or https://
- clor search scrape https://example.com --only-main-content --no-main-content    # mutually exclusive
</examples-bad>
</help>

<help command="clor search screenshot">
<summary>Capture a screenshot of a page and save it locally as PNG</summary>
<usage>clor search screenshot <URL> [flags]</usage>

<flags>
- --full-page bool: capture the entire scrollable page
- --image-output-file string: destination file path for the PNG; default is a unique safe-named file in the current directory
- --mobile bool: render with a mobile viewport
- --timeout duration: per-fetch timeout (e.g. 30s) (default "0s")
- --wait-for duration: extra wait after page load (e.g. 500ms, 2s) (default "0s")
</flags>

<output>Writes the resulting PNG to disk and prints the saved path on stdout. The file goes to --image-output-file when set, otherwise a unique safe-named file in the current directory.</output>

<examples-good>
- clor search screenshot https://example.com    # saves to ./<slug>-*.png in cwd; prints the path
- clor search screenshot https://example.com --image-output-file home.png    # save to a specific path
- clor search screenshot https://example.com --full-page    # capture the entire scrollable page
- clor search screenshot https://spa.example.com --wait-for 2s    # let JS-heavy SPAs settle before capture
- clor search screenshot https://example.com --mobile --full-page    # mobile viewport, full page
</examples-good>

<examples-bad>
- clor search screenshot    # missing required <URL>
</examples-bad>
</help>

<help command="clor search video">
<summary>Search the open web for videos, with duration metadata</summary>
<usage>clor search video</usage>

<uses>
- the user wants videos by free-text query, with duration metadata
</uses>

<subcommands>
- search: Search the open web for videos by query, with duration metadata
</subcommands>
</help>


<help command="clor search video search">
<summary>Search the open web for videos by query, with duration metadata</summary>
<usage>clor search video search <QUERY> [flags]</usage>

<flags>
- --country string: 2-letter country code, ISO 3166-1 alpha-2 (us, ar, jp)
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: title*,url*,description*,duration*,source*,age*,thumbnail_url (* = default)
- --freshness string: freshness window (pd=past day, pw=past week, pm=past month, py=past year)
- --limit int: max results (1-500); pagination is handled automatically (default "5")
- --safesearch string: safe-search level (off|moderate|strict)
</flags>

<output>json outputs the whole envelope {query, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "query": "tutorial linux",
  "results": [
    {
      "age": "3d",
      "description": "A quick tour of the shell, files, and permissions.",
      "duration": "10:24",
      "source": "video.example.com",
      "thumbnail_url": "https://video.example.com/thumb/linux-basics.jpg",
      "title": "Linux basics in 10 minutes",
      "url": "https://video.example.com/watch/linux-basics"
    }
  ]
}
</output-example>

<examples-good>
- clor search video search "tutorial linux"    # default 5 video results in logfmt; thumbnail_url omitted by default
- clor search video search "demo" --limit 500 --freshness pm    # max 500 results from the past month (auto-paginates)
- clor search video search "demo" --stdout-format json | jq -r '.results[].url'    # extract video URLs via jq
- clor search video search "demo" | grep '^event=result '    # keep only result lines
- clor search video search "demo" --fields title,url,duration    # render only the listed fields
</examples-good>

<examples-bad>
- clor search video search    # missing required <QUERY>
- clor search video search "x" --limit 600    # max --limit is 500 for videos
- clor search video search "x" --fields foo    # unknown field name
</examples-bad>
</help>

<help command="clor search web">
<summary>Search the open web for pages, articles, and documents</summary>
<usage>clor search web <QUERY> [flags]</usage>

<flags>
- --country string: 2-letter country code, ISO 3166-1 alpha-2 (us, ar, jp)
- --fields string: fields to render in text/jsonl output (ignored for json); use 'default', 'all', or comma-separated names. available: title*,url*,description*,source*,age* (* = default)
- --freshness string: freshness window (pd=past day, pw=past week, pm=past month, py=past year)
- --limit int: max results (1-200); pagination is handled automatically (default "5")
- --safesearch string: safe-search level (off|moderate|strict)
</flags>

<output>json outputs the whole envelope {query, results[]}. jsonl outputs each record from results on its own line; text is the logfmt of the same keys, an event=search header line then one event=result line per record.</output>

<output-example format="json">
{
  "query": "rainbows",
  "results": [
    {
      "age": "2d",
      "description": "How light refracts through water droplets.",
      "source": "example.com",
      "title": "About rainbows",
      "url": "https://example.com/1"
    }
  ]
}
</output-example>

<examples-good>
- clor search web "rainbows"    # default 5 results in logfmt text
- clor search web "rust" --limit 200 --freshness pm    # max 200 results from the past month (auto-paginates)
- clor search web "rust" | grep '^event=result '    # drop the search header, keep result lines
- clor search web "go programming" --stdout-format json | jq --raw-output '.results[].url'    # extract URLs via jq
- clor search web "asado" --country ar --safesearch off    # country code + safesearch off
- clor search web "rust" --fields title,url    # render only title and url
</examples-good>

<examples-bad>
- clor search web    # missing required <QUERY>
- clor search web "x" --limit 250    # max --limit is 200 for web
- clor search web "x" --limit 0    # must be >= 1
- clor search web "x" --safesearch loose    # must be off|moderate|strict
- clor search web "x" --freshness 1d    # must be pd|pw|pm|py
- clor search web "x" --stdout-format yaml    # only text, jsonl, or json supported
- clor search web "x" --fields foo    # unknown field name
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

