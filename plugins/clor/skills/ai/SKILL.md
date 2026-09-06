---
name: ai
description: AI generation across Claude, GPT, Gemini, OpenRouter, and ElevenLabs. Use when the user names a model for text, wants an image generated or edited, or requests audio transcription, speech, music, sound effects, voice isolation, or voice changing.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## AI generation reference

<help command="clor inference">
<summary>Generate text, images, and audio through Claude, GPT, Gemini, OpenRouter, and ElevenLabs</summary>
<description>Five provider subcommands. Pick the one whose surface matches the
task, then pick the smallest model that can do the job.

  anthropic   Claude text generation and exact prompt token counting.
              Promoted tiers: claude-haiku-4-5 (cheap, fast),
              claude-opus-5 (frontier), claude-fable-5-1 (max
              capability).
  openai      GPT text generation, gpt-image generation and editing,
              and audio transcription. Promoted text tiers:
              gpt-5.6-luna (cheap), gpt-6-astra (frontier).
              Promoted image tiers: gpt-image-1-mini (cheap, fast),
              gpt-image-2 (frontier).
  google      Gemini text generation and nano-banana image generation.
              Promoted text tiers: gemini-3.1-flash-lite (cheap, fast),
              gemini-3.1-pro-preview (frontier). Promoted image tiers:
              gemini-3.1-flash-image-preview (cheap, fast),
              gemini-3-pro-image-preview (frontier).
  elevenlabs  Text-to-speech, Scribe transcription, music, sound
              effects, voice isolation, and voice-to-voice conversion.
  openrouter  Escape hatch for models the dedicated subcommands do not
              cover (Llama, DeepSeek, Qwen, X-AI, plus everything else
              OpenRouter fronts). Prefer the dedicated subcommands
              whenever the model lives there.

Reach for the fast tier for high-volume or simple work (extraction,
summarization, classification, reformatting). Reach for the frontier
tier only when the task genuinely needs frontier reasoning. Enable
--reasoning only when the task needs multi-step thinking; thinking
tokens are billed as output tokens and share the --max-tokens cap, so
higher effort raises both cost and latency.</description>
<usage>clor inference [flags]</usage>

<uses>
- the request needs a non-text modality (image generation or editing, text-to-speech, music, sound effects, voice isolation, voice changing, transcription)
- the request needs cross-provider routing without configuring a second SDK
- the caller wants a specific model version (gpt-6-astra, claude-opus-5, gemini-3.1-pro-preview) that may be newer than its own SDK
- the caller wants deterministic, request/response model access from a one-shot CLI rather than a long-lived SDK session
- the caller wants explicit --reasoning effort control (off, low, medium, high, xhigh, max) for thinking-capable models
</uses>

<skips>
- the caller can already generate plain text inline within its own competence; calling out adds a network round-trip
- the request is interactive or streaming-sensitive; this CLI is request/response and waits for the full completion before printing
</skips>

<subcommands>
- anthropic: Call Anthropic's Claude models for text generation and exact prompt token counting
- elevenlabs: ElevenLabs audio surface, text-to-speech, transcription, music, sound effects, voice isolation, and voice changing
- google: Call Google for Gemini text generation and nano-banana image generation and editing
- openai: Call OpenAI for GPT text, gpt-image generation and editing, and gpt-4o audio transcription
- openrouter: Reach hundreds of chat and image-generation models through OpenRouter
</subcommands>

<flags>
- --help bool: help for inference
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

