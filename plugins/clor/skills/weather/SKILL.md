---
name: weather
description: Weather forecasts and location data. Use when the user wants current, hourly, historical, marine, or severe weather, rain chances, air quality, sunrise, sunset, moon phase, tides, or a city or region lookup.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Weather reference

<help command="clor weather">
<summary>Look up weather forecasts, air quality, astronomy, marine conditions, alerts, and location data</summary>
<description>Get current conditions, multi-day forecasts, historical weather since
2010, air-quality readings, sun and moon times, marine forecasts with
tides, government-issued weather alerts, and location autocomplete.

Subcommands:
  current     Get current conditions at a location
  forecast    Get a multi-day forecast with daily and hourly detail
  history     Get historical weather for a date or date range since 2010
  airquality  Get current air-quality readings at a location
  astronomy   Get sunrise, sunset, moonrise, moonset, and moon phase
  marine      Get a marine forecast with conditions and tide times
  alerts      Get active government-issued weather alerts
  search      Look up matching cities and regions by name

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor weather [flags]</usage>

<uses>
- the user wants weather, air-quality, astronomy, marine, or alert data for a location
- the user wants historical weather for a past date
- the user wants to find a city or region by name
</uses>

<subcommands>
- airquality: Get current air-quality readings at a location
- alerts: Get active government-issued weather alerts at a location
- astronomy: Get sunrise, sunset, moonrise, moonset, and moon phase for a date
- current: Get current conditions at a location
- forecast: Get a multi-day forecast with daily and hourly detail
- history: Get historical weather for a date or date range since 2010-01-01
- marine: Get a marine forecast with conditions and tide times
- search: Look up matching cities and regions by name
</subcommands>

<flags>
- --help bool: help for weather
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

