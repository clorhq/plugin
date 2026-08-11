---
name: bluesky
description: Bluesky feeds, posts, social graph, notifications, and direct messages. Use when the user wants to read or search Bluesky, publish or engage with posts, attach media, follow, block, or mute accounts, or use Bluesky notifications and direct messages.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Sharing a link as a card

To post a URL as a tappable link card (thumbnail, title, domain chip, and
description), pass `--link-card <URL>` to `clor bluesky post`. The title,
description, and thumbnail are fetched automatically, and each `--link-card-*`
flag overrides one field. Preview what the card will contain first with
`clor bluesky card extract <URL>`; when its `image` is empty the URL has no
thumbnail, so generate one and pass it with `--link-card-thumbnail`.

Sharing a Hacker News story is two commands, no coupling between them. Read the
story to get its title and URL, then post with a card:

    clor social hn item 12345 --stdout-format json    # read {title, url}
    clor bluesky post "Great read https://example.com/story" \
      --link-card https://example.com/story \
      --link-card-title "The story headline"

Pass `--link-card-title` from the story's own title so the card is correct even
when the origin site has thin metadata.

## Changing to a custom-domain handle

`clor bluesky profile update --handle <HANDLE>` changes the account handle,
including to a custom domain you own. Bluesky proves control of a custom
domain before the change, so point the domain at the account first by adding
a TXT record at `_atproto.<HANDLE>` with value `did=<your-did>`, or by serving
your DID at `https://<HANDLE>/.well-known/atproto-did`. The command verifies
this itself and fails with the exact record to add when it is missing. Pass
`--force` to skip the check when you know the setup is correct.

## Bluesky reference

<help command="clor bluesky">
<summary>Post to Bluesky and read it: timeline, feeds, threads, search, follow, like, notifications, direct messages</summary>
<description>Speaks the AT Protocol directly to a Bluesky server, authenticated with
a handle and an app password stored as a typed secret. Covers reading
(timeline, custom and author feeds, threads, search, profiles), posting with
rich-text links, hashtags, mentions, replies, quotes, images, and video, the
social graph (follow, block, mute), engagement (like, repost),
notifications, and direct messages.

Use when:
  - the user wants to read their Bluesky timeline, a profile, a thread, or search posts
  - the user wants to post, reply, quote, like, repost, or delete
  - the user wants to follow, unfollow, block, or mute accounts
  - the user wants to read notifications or send and read direct messages

Subcommands:
  account       Manage saved Bluesky credentials
  timeline      Read the home timeline
  feed          List, read, and browse feeds
  thread        Read a post and its replies
  post          Create a post, reply, or quote
  pin           Pin one of your posts to the top of your profile
  unpin         Remove the pinned post from your profile
  card          Preview a URL's link-card metadata before posting
  video         Upload a video and track its transcode job
  delete        Delete one of your posts
  search        Search public posts
  profile       Show, search, or update profiles
  follow        Follow an account
  unfollow      Stop following an account
  follower      List who follows an account
  following     List who an account follows
  block         Block, unblock, and list blocked accounts
  mute          Mute, unmute, and list muted accounts
  like          Like a post
  unlike        Remove your like
  repost        Repost a post
  unrepost      Remove your repost
  notification  Read notifications and mark them seen
  chat          Read and send direct messages

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor bluesky [flags]</usage>

<uses>
- the user wants to read their Bluesky timeline, an account's posts, a thread, or search public posts
- the user wants to post, reply, quote, like, repost, or delete a post
- the user wants to follow, unfollow, block, or mute accounts, or list their followers and follows
- the user wants to read notifications, or send and read direct messages
</uses>

<subcommands>
- account: Manage saved Bluesky credentials (handle, app password) used by every Bluesky subcommand
- block: Block and unblock accounts, and list the accounts you block
- card: Preview a URL's link-card metadata before posting: title, description, thumbnail
- chat: Read and send direct messages: list conversations, read one, send a message
- delete: Delete one of your own posts by its at:// URI
- feed: List saved feeds, read a custom or pinned feed, and read an account's posts
- follow: Follow one or more accounts by handle or DID in a single session
- follower: List the accounts that follow an account
- following: List the accounts an account follows
- like: Like one or more posts by their at:// URIs in a single session
- mute: Mute and unmute accounts, and list the accounts you mute
- notification: Read notifications (likes, reposts, follows, replies, mentions) and mark them seen
- pin: Pin one of your posts to the top of your profile by its at:// URI
- post: Create a post, optionally as a reply or quote, with images, a video, or a link card
- profile: Read and update Bluesky profiles: show one account, or update your own
- repost: Repost one or more posts by their at:// URIs in a single session
- search: Search public posts by keyword, newest or top first
- thread: Read a post and its reply tree, flattened depth-first with a depth attribute
- timeline: Read the home timeline of posts from accounts you follow, newest first
- unfollow: Stop following one or more accounts by handle or DID in a single session
- unlike: Remove your like from one or more posts by their at:// URIs in a single session
- unpin: Remove the pinned post from your profile
- unrepost: Remove your repost of one or more posts by their at:// URIs in a single session
- video: Upload a video, track its transcode job, then embed it in a post
</subcommands>

<flags>
- --help bool: help for bluesky
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

