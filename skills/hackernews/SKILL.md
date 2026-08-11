---
name: hackernews
description: Hacker News (HN) client and research. Use when the user wants to read feeds or threads, search or analyze HN, submit a story or poll, comment, vote, flag, favorite, hide, edit, or delete items.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Hacker News client reference

<help command="clor hn">
<summary>Use Hacker News as a client: read feeds and threads, comment, submit, poll, vote, flag, favorite, hide, edit, delete</summary>
<description>Drives Hacker News by scraping news.ycombinator.com directly,
authenticated with a username and password stored as a typed secret. Reads
every feed (top, new, best, ask, show, jobs, your submissions, comments,
favorites, upvoted) and any thread, and performs the full set of
authenticated actions. Every read also carries each item's available action
tokens, so a read flows straight into a comment, vote, or flag.

Use when:
  - the user wants to read a Hacker News feed, a thread, or a profile while signed in
  - the user wants to comment on or reply to a story or comment
  - the user wants to submit a story or poll, or vote, flag, favorite, hide, vouch
  - the user wants to edit or delete their own posts, or update their profile

Subcommands:
  account   Manage saved Hacker News credentials
  whoami    Show the logged-in account, karma, and creation date
  profile   Show profiles or update your own
  list      Read a feed
  show      Read a story or comment with its comment tree
  comment   Comment on a story or reply to a comment
  submit    Submit a story or text post
  poll      Submit a poll
  edit      Edit one of your items
  delete    Delete your items
  vote      Upvote or downvote items
  unvote    Remove your vote
  flag      Flag items
  unflag    Remove your flag
  favorite  Favorite items
  unfavorite Remove your favorite
  hide      Hide items from your feed
  unhide    Unhide items
  vouch     Vouch for dead items
  unvouch   Remove your vouch

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor hn [flags]</usage>

<uses>
- the user wants to read a Hacker News feed, a thread, or a profile while signed in
- the user wants to comment on or reply to a story or comment
- the user wants to submit a story or poll, or vote, flag, favorite, hide, or vouch
- the user wants to edit or delete their own posts, or update their profile
</uses>

<subcommands>
- account: Manage saved Hacker News credentials (username, password) used by every Hacker News subcommand
- comment: Comment on a story or reply to a comment
- delete: Delete one or more of your own items in a single session
- edit: Edit the title, URL, or text of one of your own items
- favorite: Favorite one or more items in a single session
- flag: Flag one or more items in a single session
- hide: Hide one or more items from your feed in a single session
- list: Read a Hacker News feed (top, new, best, ask, show, jobs, submitted, comments, favorites, upvoted)
- poll: Submit a poll with two or more choices
- profile: Read Hacker News profiles or update your own (about, email, display settings)
- show: Read a story or comment with its comment tree, each node carrying its available action tokens
- submit: Submit a story by URL or a text post (Ask HN, Show HN)
- unfavorite: Remove your favorite from one or more items in a single session
- unflag: Remove your flag from one or more items in a single session
- unhide: Unhide one or more items in a single session
- unvote: Remove your vote from one or more items in a single session
- unvouch: Remove your vouch from one or more items in a single session
- vote: Upvote or downvote one or more items in a single session
- vouch: Vouch for one or more dead items in a single session
- whoami: Show the logged-in account with its karma, creation date, and about text
</subcommands>

<flags>
- --help bool: help for hn
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

## Hacker News query reference

<help command="clor social">
<summary>Search Hacker News stories and comments plus Y Combinator companies and founders</summary>
<description>Search Hacker News stories and comments, run posting-time and
domain analytics, and query the Y Combinator directory of companies and
founders by batch, industry, region, and more.</description>
<usage>clor social [flags]</usage>

<uses>
- the user wants to know what people are saying about a topic right now
- the user wants top stories by score in a recent time window
- the user wants the full comment tree for a specific story
- the user wants analytics across HN posts (timing, domains, trends)
- the user wants to search or browse Y Combinator companies and founders
</uses>

<subcommands>
- hn: Search, browse, and analyze Hacker News stories and comments
- yc: Search Y Combinator companies and founders by text, batch, industry, region, tag, status, or slug
</subcommands>

<flags>
- --help bool: help for social
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

## HN Guidelines

### What to Submit

On-Topic: Anything that good hackers would find interesting. That includes more than hacking and startups. If you had to reduce it to a sentence, the answer might be: anything that gratifies one's intellectual curiosity.

Off-Topic: Most stories about politics, or crime, or sports, or celebrities, unless they're evidence of some interesting new phenomenon. If they'd cover it on TV news, it's probably off-topic.

### In Submissions

Please don't do things to make titles stand out, like using uppercase or exclamation points, or saying how great an article is.

Please submit the original source. If a post reports on something found on another site, submit the latter.

Please don't use HN primarily for promotion. It's ok to post your own stuff part of the time, but the primary use of the site should be for curiosity.

If the title includes the name of the site, please take it out, because the site name will be displayed after the link.

If the title contains a gratuitous number or number + adjective, we'd appreciate it if you'd crop it. E.g. translate "10 Ways To Do X" to "How To Do X," and "14 Amazing Ys" to "Ys." Exception: when the number is meaningful, e.g. "The 5 Platonic Solids."

Otherwise please use the original title, unless it is misleading or linkbait; don't editorialize.

If you submit a video or pdf, please warn us by appending [video] or [pdf] to the title.

Please don't post on HN to ask or tell us something. Send it to hn@ycombinator.com.

Please don't delete and repost. Deletion is for things that shouldn't have been submitted in the first place.

Don't solicit upvotes, comments, or submissions. Users should vote and comment when they run across something they personally find interesting, not for promotion.

### In Comments

Be kind. Don't be snarky. Converse curiously; don't cross-examine. Edit out swipes.

Comments should get more thoughtful and substantive, not less, as a topic gets more divisive.

When disagreeing, please reply to the argument instead of calling names. "That is idiotic; 1 + 1 is 2, not 3" can be shortened to "1 + 1 is 2, not 3."

Don't be curmudgeonly. Thoughtful criticism is fine, but please don't be rigidly or generically negative.

Don't post generated text or AI-edited text. HN is for conversation between humans.

Please don't fulminate. Please don't sneer, including at the rest of the community.

Please respond to the strongest plausible interpretation of what someone says, not a weaker one that's easier to criticize. Assume good faith.

Eschew flamebait. Avoid generic tangents. Omit internet tropes.

Please don't post shallow dismissals, especially of other people's work. A good critical comment teaches us something.

Please don't use Hacker News for political or ideological battle. It tramples curiosity.

Please don't comment on whether someone read an article. "Did you even read the article? It mentions that" can be shortened to "The article mentions that".

Please don't pick the most provocative thing in an article or post to complain about in the thread. Find something interesting to respond to instead.

Throwaway accounts are ok for sensitive information, but please don't create accounts routinely. HN is a community. Users should have an identity that others can relate to.

Please don't use uppercase for emphasis. Instead, put *asterisks* around it and it will get italicized. More formatting info here.

Please don't post insinuations about astroturfing, shilling, brigading, foreign agents, and the like. It degrades discussion and is usually mistaken. If you're worried about abuse, email hn@ycombinator.com and we'll look at the data.

If a story is spam or off-topic, flag it. Don't feed egregious comments by replying; flag them instead. If you flag, please don't also comment that you did.

Please don't complain about tangential annoyances, e.g. article or website formats, name collisions, or back-button breakage. They're too common to be interesting.

Please don't comment about the voting on comments. It never does any good, and it makes boring reading.

Please don't post comments saying that HN is turning into Reddit. It's a semi-noob illusion, as old as the hills.

Latest: https://news.ycombinator.com/newsguidelines.html


## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

