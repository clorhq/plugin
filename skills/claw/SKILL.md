---
name: claw
description: End-to-end management for claws, async agents that run on a schedule or on demand. Each task executes as a real agent with full tool use that reuses the same MCP servers, CLIs, skills, and tools the user's coding agent already has. List the claws an account owns, create new ones from scratch, import ready-made ones from the library, edit their tasks, schedule, runner, and personality, run them on demand, replay past run output, and pause or delete them. Invoked with no specific request it shows the claws you already have and asks what to do next. Use when the user wants to create, import, run, edit, list, inspect, pause, or delete a claw, schedule a recurring or on-demand job, watch a page for changes, set up a report or alert, or hand a workflow off to run unattended.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---


## You run clor, the user does not

Execute clor commands yourself. Do not hand the user CLI snippets to paste, walk them through flags, explain subcommand syntax, or say "you can run...". If clor needs information only the user has (a secret value, a choice between options, confirmation of a side effect), ask in plain English, then run the command. Report results, not recipes.

## What this skill does

This skill creates and manages claws, the async agents that run on a schedule or on demand. It covers the whole lifecycle:

- **Discover and inspect** the claws an account already owns, and their past runs.
- **Import and customize** a ready-made claw from the library, a file, or a URL, then tailor it to this user.
- **Modify** an existing claw: its tasks, schedule, runner, personality, and reporting.
- **Create from scratch** when nothing existing fits.
- **Run, test, and replay** claws on demand.

Default to reusing and adapting what already exists. Importing a proven claw and customizing it is usually faster and more reliable than authoring from a blank page; build from scratch when no existing claw fits.

## Start here

- If the user invoked this skill with no specific request, run `clor claw list` and show them the claws they own, with each claw's schedule, runner, and whether it is enabled. Then ask what they want to do (create one, import one, edit one, run one, inspect a past run, pause, or delete).
- If the user already said what they want, do that. Inspect first with `clor claw list` and `clor claw show <id>` before changing anything.

Before using unfamiliar flags, read the relevant `--help`. Do not invent flags.

## What a claw is

A claw is an async agent under one name: one repeatable job the user's agent runs on its own, on a schedule or on demand. Think of it as an agentic cron job. It fires on a schedule like cron, but instead of a fixed script it runs a real agent that reasons about what it finds and acts on it. Each task inside runs as a real agent with full tool use (or a plain bash step), reusing the same MCP servers, CLIs, skills, and tools the user's coding agent already has. Anything the agent can do once, a claw can do over and over, unattended.

The flagship shape is a single scheduled task, one agent with full tools plus a personality. Reach for multiple tasks only when runtimes differ or the pieces are genuinely independent; cross-task filesystem state is not shared, so combine related work into one task.

A claw is the async agent itself; its portable description is a single self-contained CLAW.md (YAML frontmatter plus ordered `# Task` sections), the format published at https://agentclaws.io. A claw is not always-on. It starts, runs its tasks, saves anything that must outlive the run to `clor drive`, and exits. A scheduled run fires only while the chosen machine is on; a run missed because that machine was off is not caught up later. Every run is recorded, so you can replay past output or tail one live.

## Preflight before acting

The first time this skill activates in a conversation, run these once up front so you have the lay of the land:

- `clor claw list` shows the claws this account already owns. Use ids the user describes; do not recreate something that already exists.
- `clor node list` shows registered nodes and which are online. If targeting `--runner <name>`, confirm a matching node is `status=online`; an offline target means runs queue and stall.
- `clor notification list` shows unread alerts from prior runs. Surface anything at `level=error` (and `level=warn` if the user seems unaware) before doing other work.

One inventory pass per claw interaction, not per command.

## Import and customize an existing claw

This is the fastest path to a working claw, and the right default whenever something close already exists.

1. Find a starting point. `clor claw library list` browses the published library; `clor claw library show <name>` inspects one before taking it. `clor claw import` accepts a library name, a local CLAW.md path, a URL (for example a shared CLAW.md), or stdin.
2. Import it with `clor claw import`. This fetches and creates the claw in one shot.
3. Customize it for this user before any schedule fires. Read `clor claw show <id>`, then adapt:
   - Replace every placeholder or sample value with the user's real values (recipients, thresholds, account names, paths, search terms).
   - Adjust the schedule, timezone, and runner to this user.
   - Confirm the toolbox commands the tasks call are set up on the chosen runner (accounts, secrets, drive contents).
   Apply changes with `clor claw update` (settings) and `clor claw task update`/`add`/`delete` (the ordered task list).
4. Test before scheduling (see Running and inspecting).

A claw the user already has somewhere as a CLAW.md, or one shared by a teammate, imports the same way. `clor claw export <id>` produces a portable CLAW.md to share back.

## Modify an existing claw

If the user refers to a claw that already exists, inspect it with `clor claw list` and `clor claw show <id>` before changing anything. Preserve its runner, schedule, and task intent unless the user asks to change them.

- Settings (name, description, schedule, runner, personality, timezone): `clor claw update <id> ...`.
- The ordered task list: `clor claw task add`, `clor claw task update`, `clor claw task delete`.
- Pause or resume by toggling the schedule with `clor claw update`.

After a meaningful change, re-test by queueing a run before trusting the next scheduled fire.

## Create from scratch

When nothing existing fits, author a new claw.

`clor claw create` builds the claw shell (name, description, schedule if any, runner, personality, timezone), then `clor claw task add` adds tasks one at a time. Combine related work into one task. A personality is one shared system prompt every task inherits; pick a built-in with `--personality <name>` (`clor claw personality list` to browse) or bring your own with `--system-prompt`. Runtime knobs ride on `--option key=value` (model, effort, sandbox), per claw or per task. For flag detail, read `clor claw create --help` and `clor claw task add --help`. Do not invent flags.

You can also hand-author a CLAW.md to the format at https://agentclaws.io and `clor claw import ./my-claw.md`. A task defaults to the `agent` runtime (its body is the prompt); a `bash` task body is a single fenced bash block. Schedules read like `daily @ 09:00`, `weekdays @ 09:00,17:00`, `every 30m`, or `weekly`, evaluated in the claw's timezone.

Tasks call toolbox commands for their actual work (web research, AI inference, email, files, secrets, more). The full toolbox is in `clor --help`; reach for it when writing task instructions.

## Shaping the tasks

This applies whether you author from scratch or adapt an imported claw.

Default to a single agent task, even for multi-step work. One task can gather, reason, and report in sequence; a task is a full agent, not a single command. Keeping steps together shares context and avoids handoffs, and tasks do not share local filesystem state, so related work belongs together. Do not split a job into many tasks just to make it look like a pipeline. Split only along real seams: a step that needs a different runtime, a genuinely independent unit of work, or a piece that wants its own model, effort, or timeout.

Bias toward agentic tasks. The `agent` runtime reasons about what it finds and adapts, which is the whole point of a claw. Reach for a `bash` task only for deterministic, shell-only work where an agent would add nothing (a fixed file cleanup, a single deterministic command). When in doubt, let the agent do it.

## Choosing where it runs

The default runner is the user's active node (the host where this agent is running, surfaced by `clor node list`).

Before attaching a schedule, run `clor node list`. If exactly one node is online or recently online, use it without asking. If multiple are online or recently online, ask the user which to pin to with `--runner <name>`.

Pick a runner that already has the secrets, email accounts, and drive contents the tasks need. Otherwise the run fails at execution time. A scheduled claw with no matching online runner sits in `pending` forever with no error surfaced.

A claw spawns a coding agent (claude or codex) that must authenticate. By default it uses the runner's own machine sign-in, which is absent on a host the user has not signed into and is unreadable from a background daemon on some platforms. For a claw that must run as a specific account, or on any host without a local sign-in, save the user's token once and reference it. Before scheduling such a claw, run `clor credential list` and offer the existing entries; if none fit, run `clor credential create <NAME> --runtime claude|codex --oauth-token <T>` (or `--api-key <K>`), then pass `clor claw create ... --credential <NAME>`. The token is resolved from the vault at run time and never stored on the claw.

## State between runs and tasks

Each task runs in a fresh agent process. Tasks in the same claw do not share local filesystem state, and runs do not survive restarts. Do not use `/tmp`, the working directory, or any runner-local path for cross-task or cross-run state.

If a claw needs to remember anything (seen ids, cursors, last-checked timestamps, counters, partial drafts, intermediate task output), persist it to `clor drive`, namespaced under `claws/<claw-name>/`:

    claws/hn-watcher/seen.json
    claws/hn-watcher/last-checked.txt

Tasks read needed state from `clor drive` at the start and write updated state back before exit. Use a different store only when the data has a natural home elsewhere: credentials in `clor secret`, mail in the inbox itself, content whose source of truth is an external service stays there.

## Reporting back to the user

An unattended run is invisible by default. A claw that quietly finishes and produces a result the user wanted has effectively swallowed it. So when there is something worth surfacing, pick a channel; a quiet claw with nothing meaningful to say (a watcher on a no-op) stays silent.

There is rarely one obvious channel, and the choice is the user's. Unless they already told you how they want to hear back, ask. The options:

- **In-Clor inbox**, `clor notification create --source claw --claw-id <id> --title <title>`. Lands an alert in the user's Clor inbox; `--level error` for failures, `--level warn` for things needing attention, omit for info. Best for failures, heads-ups, and short results when no richer channel is set up.
- **Email**, `clor email send`. For reports, digests, and briefs the user wants in their inbox. Send HTML with `--html-file` (mail clients show raw `**bold**` for Markdown), and lead the subject with the concrete thing, not framing words. Needs an email account on the runner first (`clor email account add`).
- **Slack**, `clor messenger slack send <channel> <text> --workspace <team-id>`. Posts to a channel, direct message, or thread (`--thread <ts>`). Best when the report belongs where the team already works.
- **A published page or dashboard**, `clor sites`. Serves a static site at `<subdomain>.clor.app`. Have the task build a self-contained HTML report and run `clor sites deploy <subdomain> <directory>`; each deploy atomically replaces the live release, so a recurring claw keeps one stable URL fresh and can roll back a bad build. Gate a private dashboard with `clor sites auth set <subdomain> --username <user> --password <password>`. Reach for this for living dashboards, longer reports, or anything the user wants to open in a browser and share by link.

If the claw's main job already reaches the user (it sends the email, posts the channel message, updates a shared doc), do not stack a redundant notification on top.

## Side effects before scheduling

Before attaching a schedule, sending external messages, publishing a page, or moving files off the user's machine, confirm cadence, recipient, account, and runner with the user if they were not already supplied. If the user already gave those details, act.

## Running and inspecting

- Run a claw on demand, or test one before scheduling, by queueing a run with `clor claw queue <id>`. A daemon must be up to claim it (`clor install service` starts one); read the result with `clor claw history <id>` and `clor claw run log <id> <run-id>`.
- Inspect past runs with `clor claw show <id>` and the run-history commands it points to, then replay output for the user.
- Delete with `clor claw delete <id>` once the user confirms.

## After acting

Report only operational facts:

- command run; claw name/id created/updated/imported/deleted
- runner (node)
- schedule, if any
- how the claw reports back, if set (notification, email, Slack, page)
- test/run result, if run
- any setup the user must complete (e.g. `clor email account add`, `clor secret create`, `clor sites create`)

## Claws reference

<help command="clor claw">
<summary>Create and run async agents on a schedule or on demand with full tool use, MCP servers, and skills</summary>
<description>A claw is an async agent under one name: one repeatable job your
agent carries out on its own, on a schedule or on demand.
Think of it as an agentic cron job. It runs on a schedule like
cron, but instead of a fixed script it runs a real agent that
reasons about what it finds and acts on it.

Under the hood each claw lives in a single CLAW.md: a bit of
metadata (name, schedule, personality) and one or more ordered
tasks. The claw is the async agent, not the file. Each task runs in
order as a real agent with full tool use, or as a plain bash step
for shell-only work, using the same MCP servers, CLIs, skills, and
tools your coding agent has. Anything you can ask your agent to do
once, a claw can do over and over. Trigger it from the terminal or
schedule it (every few minutes, weekday mornings, weekly, a
specific date). Every run is recorded, so you can tail one live or
replay one from last week.

Reach for a claw for work that benefits from agentic reasoning and
can run unattended: back up a database every night, shift ad
spend toward what is converting, renew a domain before it lapses,
reconcile records against a ledger, surface the page changes that
matter. If your agent can do it through a tool or an API, a claw can
do it on a schedule, unattended.

A claw is not always-on. It starts, runs its tasks, saves what
needs to outlive the run, and exits. A small process on the machine
you choose starts its scheduled runs, so a claw runs only while
that machine is on; if the machine is off at the scheduled time the
run is missed, not caught up later.

Flagship shape is a single-task scheduled claw, one agent task with
full tools plus a personality. Tasks run with an agent runtime by
default (claude), because the whole point is an agent that reasons
about what it finds and decides what to do. Reach for the bash
runtime only when a step is purely deterministic shell work where an
agent adds nothing; if there's any judgment, parsing, or branching,
keep it agentic. Reach for multiple tasks only when runtimes differ
or pieces are genuinely independent. Cross-task filesystem state
isn't shared, so combine related work into one task. For state that
must outlive a run, write to "clor drive" (a cloud file store with
ls, cp, mv, rm), or any other reachable store.

Best path is to build the claw for this user from scratch: "clor
claw create" to name it, then one "clor claw task add" per step.
That keeps every instruction, path, and recipient specific to this
user instead of inheriting someone else's assumptions. When you're
unsure how to shape a task, browse the published library with "clor
claw library list" and read an entry with "clor claw library show"
for reference, then write your own. Import a CLAW.md verbatim
("clor claw import ./my-claw.md" or a URL) only when the user points
you at a specific one.

Authoring loop with a user:
  1. Ask what the claw should do, when, and what it should produce.
     Probe for the specifics the tasks will need: recipients,
     thresholds, schedule, timezone, paths, credentials. Restate it
     in one or two sentences and get explicit confirmation.
  2. List the subcommands the tasks will call. If any need account
     setup the user hasn't done (e.g. "clor email send" requires
     "clor email account add"), have them run setup now and
     confirm. Tasks run non-interactively, so credentials must
     exist before the first test. Create any supporting files the
     tasks expect, and replace every placeholder or sample value
     with this user's real values.
  3. Build the claw, one "clor claw task add" per step.
  4. Test by queueing a run with "clor claw queue <CLAW-ID>", no
     schedule yet. A daemon must be up to claim it ("clor install
     service" starts one); read the output with "clor claw history
     <CLAW-ID>" and "clor claw run log <CLAW-ID> <RUN-ID>", fix, and
     re-run until it matches intent.
  5. Confirm with the user.
  6. Attach a schedule with "clor claw update <CLAW-ID> --schedule
     ...". Skip if on-demand only.

A personality is one shared system prompt every task inherits.
Pass --personality <name> on "clor claw create" to pick a built-in
("clor claw personality list" to browse) or --system-prompt to
bring your own. Default is "default"; --personality none opts out.

A claw runs on whatever machine has the daemon up: your laptop, a
spare Mac mini, a small cloud VM, your choice. Scheduled and queued
claws run only when the targeted node's daemon is running. Default
runner is this install; "clor install service" starts its daemon. A
run stuck in pending almost always means that node's daemon isn't
running. "clor node list" shows which nodes are currently online.

Runtime tuning rides on --option key=value. Recognized keys: model
and effort (claude, codex) and sandbox (codex). A codex claw with
--option sandbox=workspace-write confines writes to
"<clor-dir>/sandboxes/<run-id>/"; with no sandbox option codex and
every other runtime run with full host access. Per-task --option
overrides the claw default per key. Sandbox directories are removed
after a successful run and kept on failure for debugging.

Notifications: "clor notification create --source claw --claw-id
<CLAW-ID> --title <TITLE>" sends a message to the user's inbox
(--level error for failures, --level warn for attention, omit for
info). Use it to deliberately surface something the user needs to
see: a failure, a heads-up, a one-off requested report.

When a task should report something back to the user but doesn't
already have its own outbound channel (no "clor email send", no
Slack post, no webhook, no SMS), reach for a notification. Background
runs are invisible by default, so a claw that quietly finishes and
produces a result the user wanted has effectively swallowed it.
Wire a final-step notification with the headline and, if useful, a
short summary or a link.

If the claw's main job already reaches the user (it sends an email,
posts to a channel, writes to a shared doc), a notification on top
is redundant. Skip it.

Email reports: when a task emails the user (digests, summaries,
alerts, briefs), send HTML, not Markdown. Mail clients render HTML
inline but show raw "**bold**" and "- bullet" characters for
Markdown, which looks broken. Have the task write a small,
self-contained HTML file with inline styles, headings, lists, and
links, then pass it on "clor email send --html-file". Plain text is
fine for short, one-line notifications.

Subjects: keep email subjects short, specific, and searchable. Lead
with the concrete thing the message is about ("HN digest
2026-05-28", "Site down: example.com", "Stripe receipt $129.40"),
not framing words ("Daily report", "Update", "FYI"). The user will
later grep their inbox for the subject; bland subjects don't
survive that.</description>
<usage>clor claw [flags]</usage>

<uses>
- naming an async agent that needs to run unattended, on a schedule or on demand
- building a claw from scratch for this user with `clor claw create` + `clor claw task add`, the default path
- the flagship shape: one agent task with full tool use, a schedule, a personality; bash only for purely deterministic shell steps
- chaining multiple tasks when the work needs different runtimes or genuinely independent pieces; persist any cross-task state somewhere durable (`clor drive` recommended), never /tmp
- replaying or auditing past runs anytime, since every run is recorded
- reading a published CLAW.md with `clor claw library list` / `clor claw library show` for reference when unsure how to shape a task, then authoring your own
- authoring a claw with a user: clarify intent, set up any account prerequisites (e.g. `clor email account add`), build, test by queueing a run with `clor claw queue`, confirm, then schedule
</uses>

<subcommands>
- create: Create a new claw from scratch, then add its tasks, personalize it, test it, and schedule it
- delete: Delete a claw and everything it owns
- export: Export a claw and its tasks as a CLAW.md document
- history: List recent runs of a claw, newest first
- import: Import a CLAW.md from a file, URL, or stdin, then personalize and validate the new claw
- library: Browse published CLAW.md files for reference when authoring your own
- list: List your claws
- personality: Browse the built-in personality catalog
- queue: Queue a run for a daemon to execute; test a claw or trigger it on demand
- run: Inspect a past run, tail one in progress, or cancel it
- show: Show one claw's settings, schedule, and runner
- status: Show an at-a-glance health summary across your claws and online nodes
- task: Manage a claw's ordered tasks
- update: Update an existing claw
</subcommands>

<flags>
- --help bool: help for claw
</flags>

<global-flags>
- --clor-dir string: explicit path to the clor home directory holding config, state, and caches (overrides $CLOR_DIR; defaults to ~/.clor)
- --config string: explicit path to the TOML config file (overrides --clor-dir); defaults to <clor-dir>/config.toml
- --impersonate string: run commands as another team member by user id, like sudo (requires org admin, or a delegate grant from that member)
- --profile string: API-key profile to use for this command (overrides CLOR_PROFILE and the persisted default_profile); manage with `clor account profile`
- --stderr-file string: write stderr to this file instead of the terminal
- --stderr-format string: stderr format for progress/diagnostic events: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
- --stdout-file string: write stdout to this file instead of the terminal
- --stdout-format string: stdout format: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
</global-flags>
</help>


<help command="clor claw create">
<summary>Create a new claw from scratch, then add its tasks, personalize it, test it, and schedule it</summary>
<description>Create a new claw, then build it up with "clor claw task add". A
claw bundles an ordered list of tasks under one name. Every task
inherits the claw's system_prompt, its "personality". This is the
default path: build the claw for this user from scratch so every
instruction, path, and recipient is specific to them. If you're
unsure how to shape a task, read an existing entry with "clor claw
library list" / "clor claw library show" for reference, then write
your own rather than importing it.

Pass --personality <name> to pick a built-in (run "clor claw
personality list" to browse) or --system-prompt to supply your own
body. The two are mutually exclusive; default is the "default"
built-in; use --personality none to opt out. A custom prompt should
cover identity, output style, defaults, allowed tools, and failure
mode in ~100-200 words.

Design the claw for this user before scheduling it:
  1. Ask what it should do, when it should run, what it reads, what
     it produces, and who receives the result. Restate it in a
     sentence or two and get explicit confirmation.
  2. Gather the specifics that personalize it: recipients, thresholds,
     timezone, paths, repositories, branches, labels, filters, account
     names, API keys.
  3. Default to one agent task with full tools (claude). The point of
     a claw is an agent that reasons and decides, so keep it agentic.
     Add more tasks only when runtimes differ or steps are genuinely
     independent. Reach for the bash runtime only when a step is
     purely deterministic shell work where an agent adds nothing.
  4. Set up account prerequisites first. A task that calls "clor email
     send" needs "clor email account add"; tasks run non-interactively
     and cannot complete a login later. Create any supporting files
     the tasks expect and keep durable state in "clor drive", not /tmp.
  5. Add tasks with concrete instructions, real paths, real recipients,
     and explicit failure behavior. Leave no placeholder or sample
     value in a scheduled claw.
  6. Test by queueing a run with "clor claw queue <CLAW-ID>", no
     schedule yet. A daemon must be up to claim it ("clor install
     service" starts one); read the output with "clor claw history
     <CLAW-ID>" and "clor claw run log <CLAW-ID> <RUN-ID>", fix, and
     re-run until it matches intent.
  7. Schedule only after the user confirms the result, with "clor claw
     update <CLAW-ID> --schedule ...". Skip for on-demand claws.</description>
<usage>clor claw create [flags]</usage>

<flags>
- --compatibility string: CLAW.md compatibility note, a free-form version constraint preserved verbatim on export (max 500 characters)
- --concurrency string: what a scheduled run does when one is already active (skip|allow|queue|replace); skip drops the new run, allow runs it at the same time, queue parks it behind the active run, replace cancels the active run and starts fresh. default skip
- --concurrency-limit int: max runs of this claw to execute at once, 0 for no limit
- --credential string: name of a saved agent credential (`clor credential list`) to inject into every spawned agent. empty uses machine file credentials. per-task --credential overrides
- --description string: longer free-form description
- --end string: latest the schedule may run, a date (YYYY-MM-DD) or datetime; bare date means end of that day in the claw timezone; must be on or after --start; empty means unbounded; only matters with --schedule
- --env stringArray: literal environment variable as key=value, repeatable, injected into every spawned agent. per-task --env shallow-merges over these per key (default "[]")
- --license string: CLAW.md license identifier, a short SPDX-style string preserved verbatim on export
- --metadata stringArray: opaque CLAW.md metadata as key=value, repeatable. preserved verbatim on export (default "[]")
- --name string: human-readable name (required)
- --option stringArray: runtime tuning option as key=value, repeatable. recognized keys: model and effort (claude, codex), sandbox (codex; read-only|workspace-write|danger-full-access). Opaque; bash ignores. Per-task --option overrides per key (default "[]")
- --personality string: named built-in personality (run `clor claw personality list` to see them); mutually exclusive with --system-prompt (default "default")
- --runner string: required tags a key must hold to claim runs (defaults to host=<this machine>). Comma-separated flat tags, all required (e.g. host=db-1 or gpu,us-east), matched against the claiming key's tags. Empty string leaves the claw unassigned
- --runtime string: default runtime handler for this claw's tasks (claude, codex, bash, auto)
- --schedule string: when to queue runs automatically; empty disables. Clock rules use the claw's --timezone; interval rules are tz-independent. Grammar (';' separates rules):
  every Nm | every Nh | hourly        (interval, anchored at 00:00 UTC)
  daily | weekly | monthly            (period shorthand at 00:00 claw tz; weekly=Sun, monthly=1st)
  daily|weekdays|weekends @ HH:MM[,HH:MM...]
  weekly @ HH:MM | monthly @ HH:MM    (Sunday / the 1st at a custom time)
  mon,wed,fri @ HH:MM[,HH:MM...]      (specific weekdays)
  on YYYY-MM-DD[,YYYY-MM-DD...] @ HH:MM[,HH:MM...]
Examples: "every 5m"; "weekly"; "monthly @ 09:00"; "weekdays @ 09:00,17:00"; "weekdays @ 09:00; weekends @ 12:00"; requires --runner
- --skill stringArray: advisory Agent Skill name a runtime should load for every task, repeatable. a runtime may honor or ignore it. a per-task --skill set replaces this for that task (default "[]")
- --start string: earliest the schedule may run, a date (YYYY-MM-DD) or datetime; bare date means 00:00 that day in the claw timezone; empty means unbounded; only matters with --schedule
- --system-prompt string: raw system prompt body, replacing --personality for this claw
- --timeout duration: default per-task wall-clock cap (e.g. 5m, 30m, 1h); 0 inherits the built-in default (30m); per-task --timeout overrides (default "0s")
- --timezone string: IANA timezone (e.g. America/Los_Angeles) in which clock-rule schedules are interpreted. defaults to your local timezone at create time; pass an empty string for UTC. has no effect when --schedule is empty or only uses interval rules
</flags>

<output>json outputs the whole claw object. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "api_key_id": "0190d39f-3b1c-7d20-8e44-9a1b2c3d4e5f",
  "concurrency_limit": 0,
  "created": "2026-06-18T14:30:00Z",
  "disabled": false,
  "execution_mode": "local",
  "id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "name": "Summarize the top Hacker News stories",
  "org_id": "0190d39e-0a2b-7c10-9d33-5e6f7a8b9c0d",
  "runner": "host=mac-mini",
  "runtime": "claude",
  "system_prompt": "You are a concise daily news summarizer. One line per story, no preamble.",
  "timezone": "America/Los_Angeles",
  "updated": "2026-06-18T14:30:00Z"
}
</output-example>

<examples-good>
- clor claw create --name 'daily-digest' --runtime claude    # default personality applied; see "clor claw personality show default"
- clor claw create --name 'monitor' --runtime claude --personality researcher    # researcher archetype, citation-conscious primary-source synthesis
- clor claw create --name 'outreach' --runtime claude --personality sales --stdout-format json | jq '.id'    # sales archetype, targeted personalized prospecting
- clor claw create --name 'cleanup' --runtime bash --personality none    # bash claw with no persona
- clor claw create --name 'custom' --runtime claude --system-prompt "$(cat ./persona.md)"    # bring your own system prompt
- clor claw create --name 'campaign' --runtime claude --schedule 'every 30m' --start 2026-06-01 --end 2026-06-30    # time-boxed campaign that runs only within the window then stops
- clor claw create --name 'gpu-job' --runtime claude --runner host=mac-mini    # pin runs to the machine whose key carries host=mac-mini (see `clor node list` for names)
- clor claw create --name 'training' --runtime bash --runner gpu    # any machine whose key carries the gpu tag (plus its host tag) may claim it
- clor claw create --name 'digest' --runtime claude --option model=sonnet --option effort=low    # default every task to a smaller/cheaper model and lower reasoning effort
- clor claw create --name 'hard-problem' --runtime codex --option model=gpt-5.4 --option effort=high    # codex with explicit model and high reasoning effort
- clor claw create --name 'researcher' --runtime claude --skill web-search --skill email    # advise the runtime to load the web-search and email skills for every task
- clor claw create --name 'byok-digest' --runtime claude --credential claude-personal    # run as a saved Claude account (`clor credential list` for names); no local sign-in needed on the runner
- clor claw create --name 'release-notes' --runtime claude --credential anthropic-prod --env GITHUB_REPO=acme/app    # inject a credential plus a literal env var into every task
- clor claw create --name 'webhook-burst' --runtime claude --schedule 'every 5m' --concurrency allow    # let a scheduled run start even while a previous run is still active, instead of skipping it
- clor claw create --name 'webhook-burst' --runtime claude --schedule 'every 5m' --concurrency allow --concurrency-limit 3    # allow overlap but never run more than 3 of this claw's runs at once
</examples-good>

<examples-bad>
- clor claw create    # missing --name
- clor claw create --name 'x' --personality researcher --system-prompt foo    # --personality and --system-prompt are mutually exclusive
- clor claw create --name 'x' --personality ferret    # unknown personality; run `clor claw personality list`
- clor claw create --name 'x' --stdout-format yaml    # only text, jsonl, json supported
</examples-bad>
</help>

<help command="clor claw delete">
<summary>Delete a claw and everything it owns</summary>
<description>Permanently remove the claw and everything it owns. The server
performs a single os.RemoveAll of the claw's storage directory,
which wipes the claw row, its tasks, every recorded run, every run
log, and every persisted sandbox in one operation. There is no
undo and no soft-delete.

In-flight runs are not waited on. A "started" run continues until
its daemon notices the underlying record is gone and gives up;
treat any in-flight run on this claw as effectively cancelled.

To pause a claw without losing history, use "clor claw update
<CLAW-ID> --disabled=true" instead, then re-enable later with
--disabled=false. Disabled claws skip scheduled runs and reject
new queued runs but keep their tasks, history, and logs.</description>
<usage>clor claw delete <CLAW-ID></usage>

<output>json outputs the whole object {deleted, id}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "deleted": true,
  "id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11"
}
</output-example>

<examples-good>
- clor claw delete <CLAW-ID>    # permanently remove the claw and all its runs, tasks, logs, and sandboxes
- clor claw delete <CLAW-ID> --stdout-format json | jq '.deleted'    # verify deletion in a pipeline
- clor claw delete <CLAW-ID> | grep '^event=deleted '    # logfmt confirmation
</examples-good>

<examples-bad>
- clor claw delete    # missing CLAW-ID
- clor claw delete not-a-uuid    # 404 when the id does not resolve
</examples-bad>
</help>

<help command="clor claw export">
<summary>Export a claw and its tasks as a CLAW.md document</summary>
<description>Fetch the claw plus its tasks from the claw service and render
them to CLAW.md (frontmatter + tasks). Stdout by default; --file
writes to a path.

A CLAW.md produced by export round-trips with "clor claw import":
re-importing the file creates an equivalent claw on the local
runner.</description>
<usage>clor claw export <CLAW-ID> [flags]</usage>

<flags>
- --file string: write CLAW.md to this path instead of stdout
</flags>

<examples-good>
- clor claw export <CLAW-ID>    # write CLAW.md to stdout
- clor claw export <CLAW-ID> --file ./my-claw.md    # save to a file
- clor claw export <CLAW-ID> | clor claw import -    # round-trip a claw through CLAW.md to create a copy
</examples-good>

<examples-bad>
- clor claw export    # missing CLAW-ID
- clor claw export not-a-uuid    # 404 when the id does not resolve
</examples-bad>
</help>

<help command="clor claw history">
<summary>List recent runs of a claw, newest first</summary>
<description>List recent runs of a claw, newest first. Each row carries the
run id, type (manual, queued, scheduled), status (pending,
started, succeeded, failed, cancelled), log size, and the
timestamps recorded so far (started, succeeded, failed, cancelled,
error_message when present).

Results are paged; when more entries exist, a final
"event=cursor next_cursor=..." line names the cursor to pass to
the next call.

To dig into one row, run "clor claw run show <CLAW-ID> <RUN-ID>"
for status and metadata, or "clor claw run log <CLAW-ID> <RUN-ID>"
to replay its full output. To cancel a stuck run, "clor claw run
cancel <CLAW-ID> <RUN-ID>".</description>
<usage>clor claw history <CLAW-ID> [flags]</usage>

<flags>
- --cursor string: next_cursor returned by a prior page
- --limit int: max runs per page (1-1000); zero uses the server default
</flags>

<output>json outputs the whole envelope {runs, next_cursor}. jsonl outputs each record from runs on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "next_cursor": "0190d3b2-1f08-7a51-b3c9-7e0a4c2d9f33",
  "runs": [
    {
      "api_key_id": "",
      "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
      "created": "2026-06-18T09:00:00Z",
      "id": "0190d3b2-1f08-7a51-b3c9-7e0a4c2d9f33",
      "log_size_bytes": 4096,
      "started": "2026-06-18T09:00:01Z",
      "status": "succeeded",
      "succeeded": "2026-06-18T09:01:12Z",
      "type": "scheduled",
      "updated": "2026-06-18T09:01:12Z"
    }
  ]
}
</output-example>

<examples-good>
- clor claw history <CLAW-ID>
- clor claw history <CLAW-ID> --stdout-format json | jq '.runs[].status'
- clor claw history <CLAW-ID> --limit 50
</examples-good>

<examples-bad>
- clor claw history    # missing CLAW-ID
- clor claw history <CLAW-ID> --limit -5    # negative limit rejected
</examples-bad>
</help>

<help command="clor claw import">
<summary>Import a CLAW.md from a file, URL, or stdin, then personalize and validate the new claw</summary>
<description>Resolve a CLAW.md, parse it, and create the claw plus its tasks
on the local runner. Reach for this when the user points you at a
specific CLAW.md: a shared template, a local file, an arbitrary URL,
or piped stdin. When you're building a claw for the user from
scratch, prefer "clor claw create" + "clor claw task add" so every
instruction stays specific to them; the published library is best
read for reference, not imported wholesale.

SOURCE is auto-detected, in order
  -                  reads CLAW.md from stdin
  http(s)://...      fetches the URL (text/*; capped at 256 KiB)
  anything else      read as a local file path

Browse the published library with "clor claw library list", which
prints a CLAW.md URL per entry that you pass straight to import.

The frontmatter drives create (name, description, system_prompt,
schedule, start, end, timezone, concurrency, runtime, options,
skills). Each top-level "# Task" heading becomes one task added in
order, and a per-task skills block replaces the claw skills for that
task.

Import produces a starting point, not a finished claw. Treat success
as ready for review, not ready to schedule. {{token}} placeholders are
stored verbatim. After a successful import, stdout includes the
canonical CLAW.md wrapped in <claw-md></claw-md>, one
"event=placeholder token=<name>" line per distinct token still present,
and one "event=next" line per suggested follow-up command.

Finish the claw for this user before anything relies on it. Don't stop
at a clean import:
  1. Read the canonical CLAW.md and every event=placeholder line, then
     list every value the claw still needs: credentials, API keys,
     recipients, thresholds, paths, timezone, repositories, account
     names, schedule.
  2. Ask the user for the missing values. Never guess secrets,
     recipients, destinations, deletion rules, spend limits, alert
     thresholds, or schedules.
  3. Review every task body for sample values even where there is no
     {{token}}. Replace template examples with this user's real
     services, paths, filters, and output shape.
  4. Create any supporting files the tasks expect (scripts, prompt
     files, allowlists, recipient lists, report templates, state
     files, directories) and point the task bodies at them. Keep
     durable cross-run state in "clor drive", never /tmp.
  5. Set up account prerequisites before the first test. A task that
     calls "clor email send" needs "clor email account add" first;
     tasks run non-interactively and cannot complete a login later.
  6. Replace placeholders with "clor claw task update <CLAW-ID>
     <TASK-ID>" (task body) or "clor claw update <CLAW-ID>"
     (frontmatter).
  7. Validate end-to-end by queueing a run with "clor claw queue
     <CLAW-ID>". A daemon must be up to claim it ("clor install
     service" starts one); read the output with "clor claw history
     <CLAW-ID>" and "clor claw run log <CLAW-ID> <RUN-ID>", fix, and
     re-run until it matches the user's intent.
  8. Only then attach or confirm the schedule. If the CLAW.md already
     carries a schedule the user has not confirmed, hold off until the
     run is validated.</description>
<usage>clor claw import <SOURCE> [flags]</usage>

<flags>
- --dry-run bool: parse and write the resolved CLAW.md to stdout without creating a claw
- --runner string: required tags a key must hold to claim runs (defaults to host=<this machine>). Comma-separated flat tags, all required (e.g. host=db-1 or gpu,us-east), matched against the claiming key's tags. Empty string leaves the new claw unassigned
- --timezone string: IANA timezone (e.g. America/Los_Angeles) in which clock-rule schedules are interpreted. defaults to your local timezone at import time; pass an empty string for UTC. has no effect when the CLAW.md schedule is empty or only uses interval rules
</flags>

<output>json outputs the whole object {claw_id, name, task_count, placeholders, claw_md, next_commands}; placeholders lists the {{token}} values still to resolve and next_commands lists the follow-up commands to run. jsonl outputs the same object on one line; text is the logfmt of the same keys, then the canonical CLAW.md wrapped in claw-md tags, one event=placeholder line per token, and one event=next line per command. The --dry-run path writes only the resolved CLAW.md and ignores the format.</output>

<output-example format="json">
{
  "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "claw_md": "---\nname: Shortlist available engineering domains\ndescription: Find short brandable domains for new projects\n---\n",
  "name": "Shortlist available engineering domains",
  "next_commands": [
    "clor claw show 0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
    "clor claw update 0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
    "clor claw queue 0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11"
  ],
  "placeholders": [
    "alert_email",
    "keywords"
  ],
  "task_count": 2
}
</output-example>

<examples-good>
- clor claw import ./my-claw.md    # import from a local CLAW.md path
- clor claw import https://clor.com/claws/eng-domain-shortlist/CLAW.md    # import a published claw from its CLAW.md URL (find it with `clor claw library list`)
- clor claw import https://example.com/claws/digest.md    # import from an arbitrary URL
- cat my-claw.md | clor claw import -    # import from stdin
- clor claw import my-claw.md --dry-run    # parse and write to stdout, no claw created
- clor claw import https://clor.com/claws/eng-domain-shortlist/CLAW.md --stdout-format json | jq '.placeholders'    # import and list the placeholder tokens still to resolve
- clor claw import https://clor.com/claws/eng-domain-shortlist/CLAW.md | grep '^event=next '    # import and read the suggested follow-up commands
</examples-good>

<examples-bad>
- clor claw import    # missing positional source
- clor claw import ./missing.md    # file not found
- clor claw import eng-domain-shortlist    # bare library names are not resolved; pass the printed CLAW.md URL instead
</examples-bad>
</help>

<help command="clor claw library">
<summary>Browse published CLAW.md files for reference when authoring your own</summary>
<description>The library is the public collection of CLAW.md files hosted on
the control plane at /claws. Use it for reference: read an entry to
see how a real claw is shaped, then author your own for this user
with "clor claw create" rather than importing it.
Building from scratch keeps every instruction, path, and recipient
specific to the user. Each entry also prints a CLAW.md URL for "clor
claw import" when the user does want a published claw verbatim.

Use "list" to see what is available and "show" to read one in full.</description>
<usage>clor claw library</usage>

<uses>
- looking at an existing claw for reference when unsure how to shape one, before authoring your own
- reading a published CLAW.md in full without writing it to disk
- the user explicitly asks what published claws exist or wants to import a specific one
</uses>

<subcommands>
- list: List published CLAW.md entries to read for reference when authoring your own
- show: Show one published CLAW.md entry's metadata or raw body
</subcommands>
</help>


<help command="clor claw library list">
<summary>List published CLAW.md entries to read for reference when authoring your own</summary>
<usage>clor claw library list [flags]</usage>

<flags>
- --featured bool: show only featured entries
</flags>

<output>json outputs the whole envelope {claws}. jsonl outputs each record from claws on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "claws": [
    {
      "compatibility": "",
      "created": "2026-05-20T12:00:00Z",
      "demo_video_url": "https://clor.com/claws/anti-hacker/demo.mp4",
      "description": "Find short brandable domains for new projects",
      "featured": true,
      "features": null,
      "license": "MIT",
      "name": "anti-hacker",
      "tags": null,
      "title": "Shortlist available engineering domains",
      "updated": "2026-06-10T08:30:00Z"
    }
  ]
}
</output-example>

<examples-good>
- clor claw library list    # browse the full published library
- clor claw library list --featured    # show only featured entries
- clor claw library list --stdout-format json | jq '.claws[].name'    # machine-readable name list
</examples-good>

<examples-bad>
- clor claw library list --status published    # no --status flag; the API only ever returns published entries
- clor claw library list --stdout-format yaml    # only text, jsonl, or json supported
</examples-bad>
</help>


<help command="clor claw library show">
<summary>Show one published CLAW.md entry's metadata or raw body</summary>
<usage>clor claw library show <NAME> [flags]</usage>

<flags>
- --raw bool: write only the raw CLAW.md body to stdout (skip the metadata line)
</flags>

<output>json outputs the whole envelope {claw}, where claw carries the published metadata and the raw_markdown body. jsonl outputs the same object on one line; text is the logfmt of the metadata then the raw CLAW.md body. The --raw flag writes only the body and ignores the format.</output>

<output-example format="json">
{
  "claw": {
    "compatibility": "",
    "created": "2026-05-20T12:00:00Z",
    "demo_video_url": "https://clor.com/claws/anti-hacker/demo.mp4",
    "description": "Find short brandable domains for new projects",
    "featured": true,
    "features": null,
    "license": "MIT",
    "name": "anti-hacker",
    "raw_markdown": "---\nname: Shortlist available engineering domains\ndescription: Find short brandable domains for new projects\n---\n",
    "tags": null,
    "title": "Shortlist available engineering domains",
    "updated": "2026-06-10T08:30:00Z"
  }
}
</output-example>

<examples-good>
- clor claw library show anti-hacker    # metadata line plus the raw CLAW.md body
- clor claw library show anti-hacker --raw > anti-hacker.md    # save the file locally
- clor claw library show anti-hacker --stdout-format json | jq -r .claw.raw_markdown    # extract just the CLAW.md body via jq
</examples-good>

<examples-bad>
- clor claw library show    # missing positional name
- clor claw library show no-such-name    # 404 when the name isn't published
</examples-bad>
</help>

<help command="clor claw list">
<summary>List your claws</summary>
<description>List the caller's claws on the local runner. Results are paged;
when more entries exist, a final "event=cursor next_cursor=..."
line names the cursor to pass to the next call. Each row is the
same shape as "clor claw show": id, name, disabled, runtime,
runner, schedule, timezone, last_run_id. To inspect one record,
follow up with "clor claw show <CLAW-ID>"; for its tasks, "clor
claw task list <CLAW-ID>".</description>
<usage>clor claw list [flags]</usage>

<flags>
- --cursor string: next_cursor returned by a prior page
- --limit int: max claws per page (1-1000); zero uses the server default
</flags>

<output>json outputs the whole envelope {claws, next_cursor}. jsonl outputs each record from claws on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "claws": [
    {
      "api_key_id": "",
      "concurrency_limit": 0,
      "created": "0001-01-01T00:00:00Z",
      "disabled": false,
      "execution_mode": "",
      "id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
      "last_run_id": "0190d3b2-1f08-7a51-b3c9-7e0a4c2d9f33",
      "name": "Find unlinked mentions",
      "org_id": "",
      "runner": "host=mac-mini",
      "runtime": "claude",
      "schedule": "weekdays @ 09:00",
      "timezone": "America/Los_Angeles",
      "updated": "0001-01-01T00:00:00Z"
    }
  ],
  "next_cursor": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11"
}
</output-example>

<examples-good>
- clor claw list
- clor claw list --stdout-format json | jq '.claws[].id'
- clor claw list --limit 100 --cursor abc123
</examples-good>

<examples-bad>
- clor claw list --limit -1    # negative limit rejected
- clor claw list --cursor stale    # 404 when the cursor is unknown to the server
</examples-bad>
</help>

<help command="clor claw personality">
<summary>Browse the built-in personality catalog</summary>
<description>Built-in personalities are named system prompts the CLI ships.
Pass --personality <name> on "clor claw create"/"update" to apply
one; the resolved prompt becomes the claw's always-on guidelines
for every task.</description>
<usage>clor claw personality</usage>

<subcommands>
- list: List built-in personalities
- show: Print one personality's full system prompt
</subcommands>
</help>


<help command="clor claw personality list">
<summary>List built-in personalities</summary>
<usage>clor claw personality list</usage>

<output>json outputs the whole array of personalities, each with name, description, and system_prompt. jsonl outputs each record on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
[
  {
    "name": "default",
    "description": "Balanced general-purpose assistant",
    "system_prompt": "You are a careful, concise assistant. State results plainly and flag anything uncertain."
  },
  {
    "name": "researcher",
    "description": "Citation-conscious primary-source synthesis",
    "system_prompt": "You synthesize from primary sources and cite every claim with a link."
  }
]
</output-example>

<examples-good>
- clor claw personality list    # default logfmt summary, one result line per personality
- clor claw personality list --stdout-format json | jq -r '.[].name'    # just the names
- clor claw personality list | grep '^event=result '    # logfmt result rows
</examples-good>

<examples-bad>
- clor claw personality list foo    # list takes no positional arguments
- clor claw personality list --stdout-format yaml    # only text, jsonl, or json supported
</examples-bad>
</help>


<help command="clor claw personality show">
<summary>Print one personality's full system prompt</summary>
<usage>clor claw personality show <NAME></usage>

<output>json outputs the whole personality object with name, description, and system_prompt. jsonl outputs the same object on one line; text is the logfmt of the same keys then the full system prompt body.</output>

<output-example format="json">
{
  "name": "researcher",
  "description": "Citation-conscious primary-source synthesis",
  "system_prompt": "You synthesize from primary sources and cite every claim with a link. Prefer official documentation and peer-reviewed work over secondary summaries."
}
</output-example>

<examples-good>
- clor claw personality show researcher
- clor claw personality show default --stdout-format json | jq -r '.system_prompt'    # just the body
</examples-good>

<examples-bad>
- clor claw personality show    # missing NAME
- clor claw personality show ferret    # unknown personality
</examples-bad>
</help>

<help command="clor claw queue">
<summary>Queue a run for a daemon to execute; test a claw or trigger it on demand</summary>
<description>Queue a run for a daemon to pick up and execute, off-terminal so
you can close the window. This is how you test a claw end-to-end and
how you trigger one on demand.

A daemon whose API key carries the tags the claw's --runner requires
must be online to claim the run; "clor install service" starts one on
this machine. Empty runner or no matching daemon online means the run
parks in pending; track progress with "clor claw history <CLAW-ID>",
read its output with "clor claw run log <CLAW-ID> <RUN-ID>", and clear
stuck runs with "clor claw run cancel <CLAW-ID> <RUN-ID>".

If the run sits in pending forever, no online machine holds a key with
the tags the claw's --runner requires. Verify with "clor node list"
(look for an online machine) and start the daemon with "clor install
service".</description>
<usage>clor claw queue <CLAW-ID></usage>

<output>json outputs the whole newly queued run object, status pending until a daemon claims it. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "api_key_id": "0190d39f-3b1c-7d20-8e44-9a1b2c3d4e5f",
  "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "created": "2026-06-18T16:05:00Z",
  "id": "0190d3b2-1f08-7a51-b3c9-7e0a4c2d9f33",
  "log_size_bytes": 0,
  "pending": "2026-06-18T16:05:00Z",
  "status": "pending",
  "type": "queued",
  "updated": "2026-06-18T16:05:00Z"
}
</output-example>

<examples-good>
- clor claw queue <CLAW-ID>    # queue a pending run; some daemon claims and runs it
- clor claw queue <CLAW-ID> --stdout-format json | jq -r '.id'    # capture the run id for polling
- RUN_ID=$(clor claw queue <CLAW-ID> --stdout-format json | jq -r '.id') && clor claw run show <CLAW-ID> "$RUN_ID"    # queue and inspect the new run
</examples-good>

<examples-bad>
- clor claw queue    # missing CLAW-ID
- clor claw queue not-a-uuid    # 404 when the claw id does not resolve
</examples-bad>
</help>

<help command="clor claw run">
<summary>Inspect a past run, tail one in progress, or cancel it</summary>
<description>Operations on one run by id. Use "clor claw queue" to start a new
one and "clor claw history <CLAW-ID>" to find existing runs.</description>
<usage>clor claw run</usage>

<subcommands>
- cancel: Cancel a run that's in progress
- log: Replay a run's full output, line by line
- show: Show run status and metadata
</subcommands>
</help>


<help command="clor claw run cancel">
<summary>Cancel a run that's in progress</summary>
<usage>clor claw run cancel <CLAW-ID> <RUN-ID></usage>

<output>json outputs the whole run object with its cancelled status. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "api_key_id": "0190d39f-3b1c-7d20-8e44-9a1b2c3d4e5f",
  "cancelled": "2026-06-18T09:00:45Z",
  "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "created": "2026-06-18T09:00:00Z",
  "id": "0190d3b2-1f08-7a51-b3c9-7e0a4c2d9f33",
  "log_size_bytes": 512,
  "started": "2026-06-18T09:00:01Z",
  "status": "cancelled",
  "type": "queued",
  "updated": "2026-06-18T09:00:45Z"
}
</output-example>

<examples-good>
- clor claw run cancel <CLAW-ID> <RUN-ID>    # transition a pending or started run to cancelled
- clor claw run cancel <CLAW-ID> <RUN-ID> --stdout-format json | jq '.status'    # confirm the cancelled status
- clor claw run cancel <CLAW-ID> <RUN-ID> | grep '^event=run '    # logfmt summary line
</examples-good>

<examples-bad>
- clor claw run cancel <RUN-ID>    # missing CLAW-ID (it is the first positional)
- clor claw run cancel    # missing both CLAW-ID and RUN-ID
</examples-bad>
</help>


<help command="clor claw run log">
<summary>Replay a run's full output, line by line</summary>
<usage>clor claw run log <CLAW-ID> <RUN-ID></usage>

<examples-good>
- clor claw run log <CLAW-ID> <RUN-ID>    # raw JSONL on stdout
- clor claw run log <CLAW-ID> <RUN-ID> | jq -c 'select(.stream=="stdout") | .line'    # filter stdout lines
- clor claw run log <CLAW-ID> <RUN-ID> > run.jsonl    # save the full log to a file
</examples-good>

<examples-bad>
- clor claw run log <RUN-ID>    # missing CLAW-ID (it is the first positional)
- clor claw run log    # missing both CLAW-ID and RUN-ID
</examples-bad>
</help>


<help command="clor claw run show">
<summary>Show run status and metadata</summary>
<usage>clor claw run show <CLAW-ID> <RUN-ID></usage>

<output>json outputs the whole run object. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "api_key_id": "0190d39f-3b1c-7d20-8e44-9a1b2c3d4e5f",
  "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "created": "2026-06-18T09:00:00Z",
  "id": "0190d3b2-1f08-7a51-b3c9-7e0a4c2d9f33",
  "log_size_bytes": 4096,
  "started": "2026-06-18T09:00:01Z",
  "status": "succeeded",
  "succeeded": "2026-06-18T09:01:12Z",
  "type": "scheduled",
  "updated": "2026-06-18T09:01:12Z"
}
</output-example>

<examples-good>
- clor claw run show <CLAW-ID> <RUN-ID>    # default logfmt summary of the run
- clor claw run show <CLAW-ID> <RUN-ID> --stdout-format json | jq '.status'    # extract just the status
- clor claw run show <CLAW-ID> <RUN-ID> | grep '^event=run '    # logfmt summary line
</examples-good>

<examples-bad>
- clor claw run show <RUN-ID>    # missing CLAW-ID (it is the first positional)
- clor claw run show    # missing both CLAW-ID and RUN-ID
</examples-bad>
</help>

<help command="clor claw show">
<summary>Show one claw's settings, schedule, and runner</summary>
<description>Print one claw's frontmatter-level settings: id, name,
disabled state, runtime, runner, schedule, the schedule window
(start and end), timezone, and last run id. Tasks are not included.
To see the task list, follow up with
"clor claw task list <CLAW-ID>". To see recent runs, use "clor
claw history <CLAW-ID>". For the full CLAW.md form, use "clor
claw export <CLAW-ID>".</description>
<usage>clor claw show <CLAW-ID></usage>

<output>json outputs the whole claw object. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "api_key_id": "0190d39f-3b1c-7d20-8e44-9a1b2c3d4e5f",
  "concurrency_limit": 0,
  "created": "2026-06-01T14:30:00Z",
  "disabled": false,
  "execution_mode": "local",
  "id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "last_run_id": "0190d3b2-1f08-7a51-b3c9-7e0a4c2d9f33",
  "name": "Find unlinked mentions",
  "org_id": "0190d39e-0a2b-7c10-9d33-5e6f7a8b9c0d",
  "runner": "host=mac-mini",
  "runtime": "claude",
  "schedule": "weekdays @ 09:00",
  "system_prompt": "You watch for brand mentions that lack a link back and draft outreach.",
  "timezone": "America/Los_Angeles",
  "updated": "2026-06-18T09:01:12Z"
}
</output-example>

<examples-good>
- clor claw show <CLAW-ID>    # default logfmt summary of the claw
- clor claw show <CLAW-ID> --stdout-format json | jq '.schedule, .runner'    # extract schedule and runner
- clor claw show <CLAW-ID> && clor claw task list <CLAW-ID>    # claw plus its tasks; show does not include tasks
</examples-good>

<examples-bad>
- clor claw show    # missing CLAW-ID
- clor claw show not-a-uuid    # 404 when the id does not resolve
</examples-bad>
</help>

<help command="clor claw status">
<summary>Show an at-a-glance health summary across your claws and online nodes</summary>
<description>Summarize how the caller's claws are doing in one shot: total
claws, a per-claw health breakdown (healthy, failing, running,
paused, idle), the failed and succeeded run counts over the last
24 hours, and the newest run across all claws. It also flags claws
that are overdue, an enabled scheduled claw whose latest scheduled
run should have happened but did not (usually because no daemon was
online to run it), with a trailing-24-hour count of the runs it
missed. The summary line also reports how many of your registered
nodes have a live daemon right now, so a pile of pending runs with
zero nodes online is obvious at a glance. Each following line is one
claw with its derived health, last run, and overdue state.</description>
<usage>clor claw status</usage>

<output>json outputs the whole merged object: the claw health summary plus nodes_online and nodes_total, with a claws array of per-claw health. jsonl outputs the same object on one line; text is the logfmt of the same keys, a summary line then one line per claw.</output>

<output-example format="json">
{
  "claws": [
    {
      "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
      "health": "healthy",
      "last_run": "2026-06-18T09:01:12Z",
      "last_run_status": "succeeded",
      "missed": 0,
      "name": "Find unlinked mentions",
      "overdue": false,
      "runs_failed": 0
    }
  ],
  "claws_overdue": 1,
  "health_counts": {
    "failing": 1,
    "healthy": 2,
    "idle": 0,
    "paused": 0,
    "running": 0
  },
  "most_recent_run": "2026-06-18T09:01:12Z",
  "runs_failed": 1,
  "runs_missed": 2,
  "runs_succeeded": 8,
  "total_claws": 3,
  "nodes_online": 1,
  "nodes_total": 2
}
</output-example>

<examples-good>
- clor claw status    # summary line plus one line per claw, logfmt
- clor claw status --stdout-format json | jq '{claws_total: .total_claws, nodes_online, nodes_total}'    # merged claw and node counts as json
- clor claw status | grep 'health=failing'    # filter to claws whose latest run failed
</examples-good>

<examples-bad>
- clor claw status failing    # no positional args
- clor claw status --health failing    # no such flag; filter the output instead
</examples-bad>
</help>

<help command="clor claw task">
<summary>Manage a claw's ordered tasks</summary>
<description>A task is one entry in a claw's task list. Each runs as a real
agent (with full tool use) or as bash, in position order on each
run. Pick the runtime per task with --runtime.

Cross-task filesystem state is not guaranteed. When two tasks would
share data, combine them into one (a single task can do many
related things in one prompt or script). Split only when the
runtime differs or the pieces are genuinely independent.

Notifications: if a task needs to alert the user (e.g. it failed or
produced a report), use "clor notification create --source claw
--claw-id <CLAW-ID> --title <TITLE>" at the end. Prefer --level
error for failures. Do not notify on routine success.

Output: every subcommand supports --stdout-format text|jsonl|json.</description>
<usage>clor claw task</usage>

<subcommands>
- add: Add a new task to a claw
- delete: Delete a task; the rest renumber to stay in order
- list: List a claw's tasks in run order
- show: Show one task's settings, runtime, and prompt or script
- update: Update a task or reorder it
</subcommands>
</help>


<help command="clor claw task add">
<summary>Add a new task to a claw</summary>
<description>Append a task to the claw (or insert at --position). Cross-task
filesystem state is not guaranteed, so combine related work into
one task rather than splitting it across many.

When the task sends email, pass clor email send --from-name "<source>"
so the recipient's inbox shows the source in the From column (e.g.
"Personalized Tech Report <leo@example.com>" or "Competitor Watch <leo@example.com>").
Prefer that over stuffing the claw name or source into --subject;
the subject stays free to describe the actual content.</description>
<usage>clor claw task add <CLAW-ID> [flags]</usage>

<flags>
- --credential string: name of a saved agent credential (`clor credential list`) to inject for this task, overriding the claw credential
- --env stringArray: per-task literal env as key=value, repeatable, shallow-merged over the claw env per key (default "[]")
- --name string: task display name (required)
- --option stringArray: runtime tuning option as key=value, repeatable. recognized keys: model and effort (claude, codex), sandbox (codex; read-only|workspace-write|danger-full-access). Opaque; bash ignores. each key overrides the claw default (default "[]")
- --position int: insertion position (1-based; first task is position 1); omit to append
- --prompt string: prompt body for the agent runtimes
- --prompt-file string: read prompt body from this file (- for stdin)
- --runtime string: runtime handler for this task: claude, codex, bash, auto (overrides claw default)
- --script string: script body for the bash runtime
- --script-file string: read script body from this file (- for stdin)
- --skill stringArray: per-task Agent Skill name, repeatable. replaces the claw skills for this task rather than merging, and passing the flag with no value clears them. advisory (default "[]")
- --system-prompt string: system prompt that replaces the claw default for this task
- --system-prompt-file string: read --system-prompt from this file (- for stdin)
- --timeout duration: per-task wall-clock cap (e.g. 5m, 30m, 1h); 0 inherits the claw default (default "0s")
</flags>

<output>json outputs the whole envelope: the task fields promoted to the top level plus an ideas array of advisory improvements. jsonl outputs the same object on one line; text is the logfmt of the task keys with each idea on its own event=idea line on stderr.</output>

<output-example format="json">
{
  "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "created": "2026-06-18T14:31:00Z",
  "id": "0190d3a8-5e60-7c19-a2b4-8d3f1e6c0a22",
  "name": "Summarize the top stories",
  "position": 1,
  "prompt": "Summarize today's top 5 Hacker News stories in one line each.",
  "runtime": "claude",
  "updated": "2026-06-18T14:31:00Z",
  "ideas": [
    {
      "type": "command",
      "command": "clor socialize hn",
      "reason": "Read the front page directly instead of scraping a web page."
    }
  ]
}
</output-example>

<examples-good>
- clor claw task add <CLAW-ID> --name digest --runtime claude --prompt "Summarise today's top 5 HN stories in one line each."    # agent task that inherits the claw personality
- cat ./cleanup.sh | clor claw task add <CLAW-ID> --name cleanup --runtime bash --script-file -    # bash task with the script piped via stdin
- clor claw task add <CLAW-ID> --name raw --runtime claude --system-prompt "Respond with raw JSON only, no markdown." --prompt "Pull the top item from HN."    # fully replaces the claw personality for this task only
- clor claw task add <CLAW-ID> --name monitor --runtime claude --prompt "Check if https://example.com is up. If it's down, run: clor notification create --source claw --claw-id <CLAW-ID> --title 'Site is down' --level error"    # task that notifies on failure only
- clor claw task add <CLAW-ID> --name digest --runtime claude --prompt "Summarize today's top HN stories in 5 bullets, then run: clor notification create --source claw --claw-id <CLAW-ID> --title 'HN digest' --body \"$SUMMARY\""    # task with no email or other outbound channel: ends with a notification so the report actually reaches the user
- clor claw task add <CLAW-ID> --name quick-summary --runtime claude --option model=sonnet --option effort=low --prompt "One-line summary of yesterday's top HN story."    # cheap, low-effort task for routine work
- clor claw task add <CLAW-ID> --name deep-analysis --runtime codex --option model=gpt-5.4 --option effort=high --prompt "Read the linked S-1 and extract risk factors."    # expensive, high-effort task for hard reasoning
- clor claw task add <CLAW-ID> --name research --runtime claude --skill web-search --prompt "Find recent coverage and summarize it."    # scope the web-search skill to just this task, replacing the claw skills
</examples-good>

<examples-bad>
- clor claw task add <CLAW-ID>    # missing --name
- clor claw task add <CLAW-ID> --name t --runtime ferret    # ferret is not a known runtime
- clor claw task add <CLAW-ID> --name t --runtime bash    # bash runtime needs --script or --script-file
- clor claw task add <CLAW-ID> --name t --prompt x --prompt-file y    # --prompt and --prompt-file are mutually exclusive
</examples-bad>
</help>


<help command="clor claw task delete">
<summary>Delete a task; the rest renumber to stay in order</summary>
<description>Remove one task from a claw. Tasks at higher positions shift
down by one to keep the sequence dense. The leading positional is
the parent claw id; the second is the task id.

There is no undo. To re-add an equivalent task, copy the body off
"clor claw task show <CLAW-ID> <TASK-ID> --stdout-format json"
before deleting, then "clor claw task add <CLAW-ID> ...".</description>
<usage>clor claw task delete <CLAW-ID> <TASK-ID></usage>

<output>json outputs the whole object {deleted, id, claw_id}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "deleted": true,
  "id": "0190d3a8-5e60-7c19-a2b4-8d3f1e6c0a22"
}
</output-example>

<examples-good>
- clor claw task delete <CLAW-ID> <TASK-ID>
- clor claw task delete <CLAW-ID> <TASK-ID> --stdout-format json | jq '.deleted'    # verify deletion in a pipeline
- clor claw task delete <CLAW-ID> <TASK-ID> | grep '^event=deleted '    # logfmt confirmation
</examples-good>

<examples-bad>
- clor claw task delete <TASK-ID>    # missing CLAW-ID (it is the first positional)
- clor claw task delete    # missing both CLAW-ID and TASK-ID
</examples-bad>
</help>


<help command="clor claw task list">
<summary>List a claw's tasks in run order</summary>
<usage>clor claw task list <CLAW-ID></usage>

<output>json outputs the whole envelope {tasks}. jsonl outputs each record from tasks on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "tasks": [
    {
      "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
      "created": "2026-06-01T14:31:00Z",
      "id": "0190d3a8-5e60-7c19-a2b4-8d3f1e6c0a22",
      "name": "Summarize the top stories",
      "position": 1,
      "prompt": "Summarize today's top 5 Hacker News stories in one line each.",
      "runtime": "claude",
      "updated": "2026-06-01T14:31:00Z"
    },
    {
      "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
      "created": "2026-06-01T14:32:00Z",
      "id": "0190d3a9-7f12-7a44-b6d8-1c2e3f4a5b66",
      "name": "Email the digest",
      "position": 2,
      "runtime": "bash",
      "script": "clor email send --to reader@example.com --subject 'HN digest' --body-file ./digest.txt",
      "updated": "2026-06-01T14:32:00Z"
    }
  ]
}
</output-example>

<examples-good>
- clor claw task list <CLAW-ID>
- clor claw task list <CLAW-ID> --stdout-format json | jq '.tasks[].name'
- clor claw task list <CLAW-ID> | grep '^event=result '
</examples-good>

<examples-bad>
- clor claw task list    # missing CLAW-ID
- clor claw task list not-a-uuid    # 404 when the claw id does not resolve
</examples-bad>
</help>


<help command="clor claw task show">
<summary>Show one task's settings, runtime, and prompt or script</summary>
<description>Show one task's settings, runtime, body, and system-prompt
overrides. Text mode truncates the prompt or script body to 80
characters for readability; use --stdout-format json to get the
full body.

The leading positional is the parent claw id; the second is the
task id. If you only have the claw id, list its tasks with
"clor claw task list <CLAW-ID>" and copy the task id off the
result.</description>
<usage>clor claw task show <CLAW-ID> <TASK-ID></usage>

<output>json outputs the whole task object with the full prompt or script body. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "created": "2026-06-01T14:31:00Z",
  "id": "0190d3a8-5e60-7c19-a2b4-8d3f1e6c0a22",
  "name": "Summarize the top stories",
  "position": 1,
  "prompt": "Summarize today's top 5 Hacker News stories in one line each.",
  "runtime": "claude",
  "updated": "2026-06-01T14:31:00Z"
}
</output-example>

<examples-good>
- clor claw task show <CLAW-ID> <TASK-ID>    # default logfmt summary of the task
- clor claw task show <CLAW-ID> <TASK-ID> --stdout-format json | jq '.prompt'    # extract the full prompt body (text mode truncates it)
- clor claw task show <CLAW-ID> <TASK-ID> | grep '^event=result '    # logfmt summary line
</examples-good>

<examples-bad>
- clor claw task show <TASK-ID>    # missing CLAW-ID (it is the first positional)
- clor claw task show    # missing both CLAW-ID and TASK-ID
</examples-bad>
</help>


<help command="clor claw task update">
<summary>Update a task or reorder it</summary>
<description>Patch mutable fields on a task. Only flags actually passed are
sent to the server, so omitting a flag leaves the field untouched.
Sending any --option replaces the task's whole tuning override map;
pass --position to renumber. The leading positional is the parent claw
id; the second is the task id.

--system-prompt replaces the claw default for this task; clearing it
inherits the claw default again.

Validate by queueing a run with "clor claw queue <CLAW-ID>" and
reading "clor claw run log <CLAW-ID> <RUN-ID>" after a body change.</description>
<usage>clor claw task update <CLAW-ID> <TASK-ID> [flags]</usage>

<flags>
- --credential string: name of a saved agent credential (`clor credential list`) for this task; empty string clears the override and inherits the claw credential
- --env stringArray: replace this task's literal env override; key=value, repeatable. sending any --env replaces the whole override map; omit to leave unchanged (default "[]")
- --name string: new name
- --option stringArray: replace the task's tuning override; key=value, repeatable. recognized keys: model and effort (claude, codex), sandbox (codex; read-only|workspace-write|danger-full-access). Opaque; bash ignores. sending any --option replaces the whole task override map; omit to leave unchanged (default "[]")
- --position int: new ordinal position (1-based; first task is position 1); neighbors renumber
- --prompt string: replace the prompt body
- --prompt-file string: replace prompt body from this file (- for stdin)
- --runtime string: new runtime handler: claude, codex, bash, auto (empty inherits claw default)
- --script string: replace the script body
- --script-file string: replace script body from this file (- for stdin)
- --skill stringArray: replace this task's Agent Skill set, repeatable. replaces the claw skills for this task rather than merging; omit to leave unchanged. advisory (default "[]")
- --system-prompt string: replace the task's system prompt (overrides claw default)
- --system-prompt-file string: read --system-prompt from this file (- for stdin)
- --timeout duration: new per-task wall-clock cap (e.g. 5m, 30m, 1h); 0 clears the override and inherits the claw default (default "0s")
</flags>

<output>json outputs the whole envelope: the updated task fields promoted to the top level plus an ideas array of advisory improvements. jsonl outputs the same object on one line; text is the logfmt of the task keys with each idea on its own event=idea line on stderr.</output>

<output-example format="json">
{
  "claw_id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "created": "2026-06-01T14:31:00Z",
  "id": "0190d3a8-5e60-7c19-a2b4-8d3f1e6c0a22",
  "name": "Summarize the top stories",
  "position": 1,
  "prompt": "Summarize today's top 5 Hacker News stories in one line each, then list each story's points and comment count.",
  "runtime": "codex",
  "updated": "2026-06-18T16:05:00Z",
  "ideas": [
    {
      "type": "runtime",
      "reason": "This task reasons over prose, so claude fits better than codex."
    }
  ]
}
</output-example>

<examples-good>
- clor claw task update <CLAW-ID> <TASK-ID> --position 1    # move to the front
- clor claw task update <CLAW-ID> <TASK-ID> --runtime codex    # swap runtime handler
- cat ./new-script.sh | clor claw task update <CLAW-ID> <TASK-ID> --script-file -    # replace bash script body from stdin
- clor claw task update <CLAW-ID> <TASK-ID> --option model=opus --option effort=high    # bump this single task to a stronger model with higher reasoning effort
- clor claw task update <CLAW-ID> <TASK-ID> --runtime codex --option sandbox=workspace-write    # confine just this codex task's writes to a sandbox directory
</examples-good>

<examples-bad>
- clor claw task update <TASK-ID> --name x    # missing CLAW-ID (it is the first positional)
- clor claw task update    # missing both CLAW-ID and TASK-ID
</examples-bad>
</help>

<help command="clor claw update">
<summary>Update an existing claw</summary>
<description>Patch mutable fields on a claw. Only flags actually passed are
sent to the server, so omitting a flag leaves that field
untouched. Pass an empty string to clear --description, --schedule,
--start, --end, --runner, or --timezone. --disabled toggles the pause
state without touching tasks or history.

--schedule requires --runner to be set on the claw, or set in the
same call; otherwise scheduled runs would queue forever with no
daemon eligible to claim them. The grammar matches "clor claw
create --schedule".

Personality and system prompt are mutually exclusive. Passing
--personality swaps to a different built-in; --system-prompt
replaces the body with raw text. Use "clor claw personality list"
to browse built-ins.

After updating runtime or option settings, validate by queueing a
run with "clor claw queue <CLAW-ID>" and reading "clor claw run log
<CLAW-ID> <RUN-ID>" before the next scheduled run. Task bodies are
not touched here; use "clor claw task update" for per-task changes.</description>
<usage>clor claw update <CLAW-ID> [flags]</usage>

<flags>
- --compatibility string: new CLAW.md compatibility note (empty clears it); preserved verbatim on export (max 500 characters)
- --concurrency string: what a scheduled run does when one is already active (skip|allow|queue|replace); omit to leave unchanged. skip drops the new run, allow runs it at the same time, queue parks it behind the active run, replace cancels the active run and starts fresh
- --concurrency-limit int: max runs of this claw to execute at once, 0 clears the cap (no limit); omit to leave unchanged
- --credential string: name of a saved agent credential (`clor credential list`) to inject into every spawned agent; empty string clears it (falls back to machine file credentials); per-task --credential overrides
- --description string: new description (pass empty string to clear)
- --disabled bool: set disabled state (--disabled=true to disable, --disabled=false to re-enable); omit to leave unchanged
- --end string: new schedule-window upper bound, a date (YYYY-MM-DD) or datetime (empty clears it); must be on or after start; same meaning as `clor claw create --end`
- --env stringArray: replace the claw's literal env map; key=value, repeatable. sending any --env replaces the whole map; omit to leave unchanged; per-task --env shallow-merges over these per key (default "[]")
- --license string: new CLAW.md license identifier (empty clears it); preserved verbatim on export
- --metadata stringArray: replace the claw's CLAW.md metadata map; key=value, repeatable. Sending any --metadata replaces the whole map; omit to leave unchanged (default "[]")
- --name string: new name
- --option stringArray: replace the claw's tuning map; key=value, repeatable. recognized keys: model and effort (claude, codex), sandbox (codex; read-only|workspace-write|danger-full-access). Opaque; bash ignores. Sending any --option replaces the whole map; omit to leave unchanged; per-task --option overrides per key (default "[]")
- --personality string: swap to a different built-in personality (run `clor claw personality list`); mutually exclusive with --system-prompt
- --runner string: new required-tag selector. Empty string clears it, after which no key will pick up runs until a selector is set again. Comma-separated flat tags, all required, matched against the claiming key's tags (e.g. host=db-1 or gpu,us-east)
- --runtime string: new default runtime handler (claude, codex, bash, auto)
- --schedule string: new schedule (empty clears it); same grammar and examples as `clor claw create --schedule`; requires --runner to be set on the claw, or set in the same call
- --skill stringArray: replace the claw's Agent Skill set; repeatable. sending any --skill replaces the whole set; omit to leave unchanged. advisory (default "[]")
- --start string: new schedule-window lower bound, a date (YYYY-MM-DD) or datetime (empty clears it); same meaning as `clor claw create --start`
- --system-prompt string: replace the system prompt with raw text; mutually exclusive with --personality
- --timeout duration: new default per-task wall-clock cap (e.g. 5m, 30m, 1h); 0 clears (falls through to built-in default) (default "0s")
- --timezone string: new IANA timezone (e.g. America/Los_Angeles) in which clock-rule schedules are interpreted. empty clears it (claw falls back to UTC). has no effect when --schedule is empty or only uses interval rules
</flags>

<output>json outputs the whole updated claw object. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "api_key_id": "0190d39f-3b1c-7d20-8e44-9a1b2c3d4e5f",
  "concurrency_limit": 0,
  "created": "2026-06-01T14:30:00Z",
  "disabled": false,
  "execution_mode": "local",
  "id": "0190d3a1-7c42-7e88-9f10-2b5c4d6e8a11",
  "last_run_id": "0190d3b2-1f08-7a51-b3c9-7e0a4c2d9f33",
  "name": "Find unlinked mentions",
  "org_id": "0190d39e-0a2b-7c10-9d33-5e6f7a8b9c0d",
  "runner": "host=mac-mini",
  "runtime": "codex",
  "schedule": "weekdays @ 09:00",
  "timezone": "America/Los_Angeles",
  "updated": "2026-06-18T16:05:00Z"
}
</output-example>

<examples-good>
- clor claw update <CLAW-ID> --runtime codex    # swap default runtime handler
- clor claw update <CLAW-ID> --personality researcher    # swap to the researcher personality
- clor claw update <CLAW-ID> --disabled=true
- clor claw update <CLAW-ID> --disabled=false    # re-enable a previously disabled claw
- clor claw update <CLAW-ID> --option model=opus --option effort=high    # switch the default model and reasoning effort
- clor claw update <CLAW-ID> --runtime codex --option sandbox=workspace-write    # confine codex writes to a per-run sandbox directory
- clor claw update <CLAW-ID> --credential claude-personal    # run this claw as a saved Claude account from now on
- clor claw update <CLAW-ID> --credential ''    # clear the credential; fall back to machine file credentials
</examples-good>

<examples-bad>
- clor claw update <CLAW-ID>    # no flags changed; nothing to update
- clor claw update <CLAW-ID> --personality x --system-prompt y    # --personality and --system-prompt are mutually exclusive
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

