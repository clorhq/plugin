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
              claude-opus-5 (frontier), claude-fable-5 (max
              capability).
  openai      GPT text generation, gpt-image generation and editing,
              and audio transcription. Promoted text tiers:
              gpt-5.6-luna (cheap), gpt-5.6-sol (frontier).
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
- the caller wants a specific model version (gpt-5.6-sol, claude-opus-5, gemini-3.1-pro-preview) that may be newer than its own SDK
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


<help command="clor inference anthropic">
<summary>Call Anthropic's Claude models for text generation and exact prompt token counting</summary>
<description>Claude text generation and prompt token counting. Pick the smallest
model that can do the job.

  claude-haiku-4-5    Cheap and fast. Best for high-volume extraction,
                      summarization, classification, reformatting.
                      Legacy reasoning (budget_tokens). $1/$5 per Mtok.
  claude-sonnet-5     Balanced tier. $3/$15 per Mtok with 128K max
                      output and adaptive thinking. Accepts sampling
                      controls. Good when ordinary reasoning and
                      writing don't justify Opus prices.
  claude-opus-5       Default frontier model. $5/$25 per Mtok with
                      128K max output and adaptive thinking. Strong
                      coding, multidisciplinary reasoning, and
                      agentic benchmarks. claude-opus-4-8 stays
                      selectable at the same price.
  claude-fable-5      Maximum capability. $10/$50 per Mtok with 128K
                      max output and adaptive thinking always on. Best
                      for the most demanding reasoning and long-horizon
                      agentic work.

Opus and Fable forbid --temperature and --top-p. All models forbid sampling
controls when --reasoning is on. System prompts auto-cache on the
server (~5 min ephemeral TTL, ~90 percent discount on hits).</description>
<usage>clor inference anthropic</usage>

<uses>
- the caller needs Claude text output and cannot generate it inline
- the request needs a specific Claude version that the caller's SDK lacks
- the caller wants auto-cached system prompts (~5 min TTL on Anthropic) or extended-thinking effort (low/medium/high/xhigh/max)
- the caller wants Opus 5's 128K max output for hard reasoning tasks
</uses>

<subcommands>
- count-tokens: Count prompt tokens for a Claude Messages call without running generation
- text: Generate text with Claude via the Anthropic Messages API
</subcommands>
</help>


<help command="clor inference anthropic count-tokens">
<summary>Count prompt tokens for a Claude Messages call without running generation</summary>
<description>Exact count via Anthropic's count_tokens endpoint. Matches input_tokens
on a real Messages call with the same model/system/messages.

Input modes (mutually exclusive): positional arg, --stdin-format text
(single user message), or --stdin-format json (multi-turn array).</description>
<usage>clor inference anthropic count-tokens [PROMPT] [flags]</usage>

<flags>
- --model string: model id (claude-opus-5|claude-haiku-4-5). Tokenization is model-specific so the count returned matches a real Messages call against the same model (default "claude-opus-5")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --system string: optional system prompt; counted against the input
</flags>

<output>text writes the bare token count on stdout and a one-line summary on stderr. jsonl outputs the same object on one line; json outputs the model and input_tokens object on stdout.</output>

<output-example format="json">
{
  "model": "claude-opus-5",
  "input_tokens": 14
}
</output-example>

<examples-good>
- clor inference anthropic count-tokens "what is 2+2?"    # default model (claude-opus-5); prints input_tokens on stdout
- clor inference anthropic count-tokens "summarize this" --model claude-haiku-4-5    # smaller model shares the tokenizer; count is identical across the family today
- cat large_doc.txt | clor inference anthropic count-tokens --stdin-format text --system "be terse" --stdout-format json | jq '.input_tokens'    # JSON envelope; useful when piping count into a budget check
- clor inference anthropic count-tokens "hi" --stdout-format jsonl | grep '^event=count '    # logfmt summary line
- echo '[{"role":"user","content":"a"},{"role":"assistant","content":"b"},{"role":"user","content":"c"}]' | clor inference anthropic count-tokens --stdin-format json    # multi-turn count
</examples-good>

<examples-bad>
- clor inference anthropic count-tokens    # no input: pass a positional prompt or --stdin-format text|json
- clor inference anthropic count-tokens "hi" --model claude-fake    # rejected: not in the supported model set
- clor inference anthropic count-tokens "hi" --stdin-format text    # --stdin-format and a positional prompt are mutually exclusive
</examples-bad>
</help>


<help command="clor inference anthropic text">
<summary>Generate text with Claude via the Anthropic Messages API</summary>
<description>Pick the smallest model that can do the job. haiku for extraction
and reformatting, opus-5 (default) for hard reasoning.

System prompts auto-cache on the server (~5 min ephemeral TTL,
~90 percent discount on cache hits).

--reasoning enables extended thinking. Adaptive models (opus-5,
opus-4-8, opus-4-7, sonnet-4-6) send it as output_config.effort.
Legacy models (haiku-4-5) translate to a numeric budget. Cost
framing per level:

  off    No thinking. Right default for extraction, summarization,
         classification, reformatting. Costs nothing extra.
  low    ~2K thinking tokens on legacy. Light reasoning. Use for
         simple structured edits, short explanations, basic planning.
  medium ~8K thinking tokens on legacy. Working default for ordinary
         multi-step tasks.
  high   ~16K thinking tokens on legacy. Multi-step planning, harder
         analysis, code review across multiple files.
  xhigh  ~32K thinking tokens on legacy. Hardest reasoning problems
         that justify the spend.
  max    Up to max_tokens minus 1024 on legacy. Dynamic on adaptive.
         Let the model spend whatever it needs.

Thinking tokens are billed as output tokens and share the --max-tokens
cap, so raising effort raises both cost and the risk that visible
output gets truncated. --temperature and --top-p are rejected when
--reasoning is on, and on claude-opus-5, claude-opus-4-8,
claude-opus-4-7, and claude-fable-5 regardless of reasoning state.</description>
<usage>clor inference anthropic text [PROMPT] [flags]</usage>

<flags>
- --max-tokens int: max output tokens (caps at the model's documented max). Reasoning tokens count toward this cap
- --model string: model id. Cheap to strong: claude-haiku-4-5 (simple, high-volume), claude-sonnet-5 (balanced, $3/$15 per Mtok, 128K max output, adaptive thinking), claude-opus-5 (default frontier, $5/$25 per Mtok, 128K max output), claude-opus-4-8 (prior Opus, same price, still selectable), claude-fable-5 (max capability, $10/$50 per Mtok, 128K max output) (default "claude-opus-5")
- --reasoning string: reasoning effort (off|low|medium|high|xhigh|max). off is the right default for extraction, summarization, classification, reformatting. low/medium/high climb in capability and cost. xhigh and max are for the hardest problems and are billed as output tokens. Adaptive models (opus-5, opus-4-8, opus-4-7, sonnet-5, sonnet-4-6) pass through to output_config.effort. Legacy models (haiku-4-5) translate to budget_tokens (low=2048, medium=8192, high=16384, xhigh=32768, max=max_tokens-1024). Cannot be combined with --temperature or --top-p (default "off")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --stop stringArray: stop sequence; pass repeatedly for multiple (max 4) (default "[]")
- --system string: optional system prompt; auto-cached on the server (~5 min ephemeral TTL, ~90 percent discount on cache hits)
- --temperature float32: sampling temperature (0.0-1.0); -1 means use the model's default. Rejected when --reasoning is set or with claude-opus-5, claude-opus-4-8, claude-opus-4-7, or claude-fable-5 (these reject sampling controls regardless of reasoning state) (default "-1")
- --top-p float32: nucleus-sampling threshold (0.0-1.0); -1 means use the model's default. Rejected when --reasoning is set or with claude-opus-5, claude-opus-4-8, claude-opus-4-7, or claude-fable-5. Anthropic recommends temperature OR top-p, not both (default "-1")
</flags>

<output>the model's final text answer appears on stdout in text mode; thinking and signature blocks are visible only via --stdout-format json. Default output (text): the model's text response on stdout, plus a one-line summary (model, token counts) on stderr. JSON output: the full response envelope including usage. jsonl outputs the same object on one line; text writes the assistant text on stdout and a one-line summary on stderr.</output>

<output-example format="json">
{
  "content": [
    {
      "text": "The capital of France is Paris.",
      "type": "text"
    }
  ],
  "id": "msg_01XFDUDYJgAACzvnptvVoYEL",
  "model": "claude-opus-5",
  "stop_reason": "end_turn",
  "usage": {
    "cache_creation_input_tokens": 0,
    "cache_read_input_tokens": 0,
    "input_tokens": 12,
    "output_tokens": 9
  }
}
</output-example>

<examples-good>
- clor inference anthropic text "summarize in 3 words: I went to the store" --model claude-haiku-4-5    # cheap tier for a trivial task; legacy reasoning mode is off by default
- clor inference anthropic text "draft a one-paragraph release note" --model claude-sonnet-4-6    # everyday tier for ordinary writing tasks
- clor inference anthropic text "summarize this RFC and list open questions" --model claude-sonnet-5 --reasoning medium    # balanced tier with adaptive thinking; $3/$15 per Mtok with 128K max output
- clor inference anthropic text "name a color" --model claude-sonnet-4-6 --system "be terse" --temperature 0.2    # sampling control on sonnet; no --reasoning so temperature is allowed
- clor inference anthropic text "plan a 3-step refactor of this module" --reasoning high    # high effort on the default opus-5; thinking blocks surface under --stdout-format json
- clor inference anthropic text "design a distributed scheduler with three consistency invariants" --reasoning max    # maximum effort for hard reasoning; opus-5 is the right tier
- clor inference anthropic text "port this 4k-line service from Python to Go and keep the tests green" --model claude-fable-5 --reasoning xhigh    # max-capability tier for the most demanding long-horizon work; $10/$50 per Mtok
- clor inference anthropic text "what is 2+2?" --model claude-haiku-4-5 --stdout-format json | jq '.usage'    # JSON envelope with token usage on the cheapest tier
- echo '[{"role":"user","content":"name a color"},{"role":"assistant","content":"blue"},{"role":"user","content":"name another"}]' | clor inference anthropic text --stdin-format json --model claude-sonnet-4-6    # multi-turn via stdin JSON
- cat note.txt | clor inference anthropic text --stdin-format text --model claude-haiku-4-5    # treat the file body as a single user message; cheap tier for routine extraction
</examples-good>

<examples-bad>
- clor inference anthropic text "hi" --model claude-fake    # rejected: not in the supported model set
- clor inference anthropic text "hi" --stdin-format text    # --stdin-format and a positional prompt are mutually exclusive
- clor inference anthropic text "hi" --reasoning extreme    # --reasoning must be off, low, medium, high, xhigh, or max
- clor inference anthropic text "hi" --reasoning high --temperature 0.5    # temperature/top-p are not allowed when reasoning is enabled
- clor inference anthropic text "hi" --temperature 0.5    # default model (claude-opus-5) does not accept temperature/top-p; switch to claude-sonnet-4-6 if you need sampling control
- clor inference anthropic text "hi" --model claude-haiku-4-5 --reasoning high --max-tokens 8000    # max-tokens must exceed the resolved budget (legacy high=16384)
- clor inference anthropic text "what is 2+2?"    # wasteful: paying opus-5 prices for arithmetic. Either answer inline or pass --model claude-haiku-4-5
</examples-bad>
</help>

<help command="clor inference elevenlabs">
<summary>ElevenLabs audio surface, text-to-speech, transcription, music, sound effects, voice isolation, and voice changing</summary>
<description>Audio is the clearest case for shelling out from an LLM host. Seven
subcommands cover the full ElevenLabs surface.

  speech           Text-to-speech with a chosen voice. Pick a model
                   from the TTS tier guide on the subcommand.
  transcribe       Speech-to-text via Scribe v2 (default) or v1.
  music            Generate a music clip from a text prompt.
  sound-effects    Generate a sound-effect clip from a text prompt.
  voice-isolator   Strip background noise from a recording.
  voice-changer    Re-voice a recording as a different speaker.
  voice            Browse the voice library to find voice ids.

TTS tiers (faster to richer)
  eleven_flash_v2_5         Lowest latency (~75ms). Use for real-time
                            interactive work.
  eleven_turbo_v2_5         High-throughput conversational use with
                            a strong quality/latency balance.
  eleven_multilingual_v2    Broad language coverage where v3's
                            expressiveness is not needed.
  eleven_v3                 Default. Highest expressiveness, widest
                            language support, GA since 2026-02-02.</description>
<usage>clor inference elevenlabs</usage>

<uses>
- the request is text-to-speech for narration, voiceovers, or replies
- the request is speech-to-text on a recording (Scribe), with optional keyterm biasing or entity detection
- the request is music or sound-effect generation from a text prompt
- the request is to isolate a voice from noisy audio or convert it into a different speaker
</uses>

<subcommands>
- music: Generate a music clip from a text prompt with ElevenLabs Music
- sound-effects: Generate a sound effect clip from a text prompt
- speech: Synthesize speech from text with a chosen ElevenLabs voice (text-to-speech)
- transcribe: Transcribe an audio file to text with ElevenLabs Scribe (speech-to-text)
- voice: Browse the ElevenLabs voice library to find voice ids for speech and voice-changer
- voice-changer: Convert the speaker in an audio file to a target voice (speech-to-speech)
- voice-isolator: Strip background noise from an audio recording, isolating the voice
</subcommands>

<output>every subcommand supports --stdout-format text|jsonl|json (default text, logfmt with event= leader). Audio output endpoints write the raw audio to --audio-output-file separately from the metadata stream.</output>
</help>


<help command="clor inference elevenlabs music">
<summary>Generate a music clip from a text prompt with ElevenLabs Music</summary>
<description>Pass the prompt positionally or via --stdin-format text. Control
duration with --length (e.g. 30s, 2m).</description>
<usage>clor inference elevenlabs music [PROMPT] [flags]</usage>

<flags>
- --audio-output-file string: destination MP3 path (auto-generated in CWD when omitted)
- --length duration: target output duration (e.g. 30s, 2m, 1h) (default "0s")
- --model string: music model id (music_v1 is the only publicly documented id today)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>The audio is written to --audio-output-file as MP3; when omitted, an unused MP3 path is generated in the current working directory. The chosen path is reported on stdout in text mode and in the file field of the response envelope under --stdout-format jsonl|json. The usage.output_seconds field reports the duration of the returned audio. jsonl outputs the same object on one line; json outputs the full envelope including the base64 audio bytes.</output>

<output-example format="json">
{
  "audio": "SUQzBAAAAAAAI1RTU0UAAAAPAAAD...",
  "audio_mime_type": "audio/mpeg",
  "id": "music_5b2e8f1a7c",
  "usage": {
    "output_seconds": 30
  }
}
</output-example>

<examples-good>
- clor inference elevenlabs music "lo-fi beat with rain" --audio-output-file lofi.mp3    # default duration
- clor inference elevenlabs music "lo-fi beat with rain"    # omit --audio-output-file; an MP3 path is auto-generated in CWD and printed on stdout
- clor inference elevenlabs music "ambient pad" --length 30s --audio-output-file ambient.mp3 --stdout-format json | jq '.usage.output_seconds'    # 30s clip; report duration
- clor inference elevenlabs music "epic orchestral" --length 2m --audio-output-file orchestral.mp3    # 2-minute clip; --length accepts s/m/h
- echo "epic orchestral build" | clor inference elevenlabs music --stdin-format text --audio-output-file epic.mp3    # prompt via stdin
</examples-good>

<examples-bad>
- clor inference elevenlabs music    # missing prompt: pass positional or --stdin-format text
- clor inference elevenlabs music "ambient pad" --length 30    # --length needs a unit (use 30s)
</examples-bad>
</help>


<help command="clor inference elevenlabs sound-effects">
<summary>Generate a sound effect clip from a text prompt</summary>
<description>Pass the prompt positionally or via --stdin-format text. --duration
caps the clip; --prompt-influence (0..1) biases adherence.</description>
<usage>clor inference elevenlabs sound-effects [PROMPT] [flags]</usage>

<flags>
- --audio-output-file string: destination MP3 path (auto-generated in CWD when omitted)
- --duration duration: target clip duration (e.g. 3s, 10s, 30s) (default "0s")
- --prompt-influence float32: 0..1 weight controlling how closely the output follows the prompt (0 disables)
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
</flags>

<output>The clip is written to --audio-output-file as MP3; when omitted, an unused MP3 path is generated in the current working directory. The chosen path is reported on stdout in text mode and in the file field of the response envelope under --stdout-format jsonl|json. jsonl outputs the same object on one line; json outputs the full envelope including the base64 audio bytes.</output>

<output-example format="json">
{
  "audio": "SUQzBAAAAAAAI1RTU0UAAAAPAAAD...",
  "audio_mime_type": "audio/mpeg",
  "id": "sfx_8c3e1a7f2b",
  "usage": {
    "output_seconds": 3
  }
}
</output-example>

<examples-good>
- clor inference elevenlabs sound-effects "rain on a tin roof" --audio-output-file rain.mp3    # single short clip
- clor inference elevenlabs sound-effects "rain on a tin roof"    # omit --audio-output-file; an MP3 path is auto-generated in CWD and printed on stdout
- clor inference elevenlabs sound-effects "thunder cracks" --duration 3s --audio-output-file thunder.mp3 --stdout-format json | jq '.usage'    # 3-second clip; JSON envelope with usage
- echo "footsteps on gravel" | clor inference elevenlabs sound-effects --stdin-format text --audio-output-file steps.mp3 --stdout-format jsonl | grep '^event=result '    # stdin prompt + logfmt summary
</examples-good>

<examples-bad>
- clor inference elevenlabs sound-effects --audio-output-file x.mp3    # missing prompt: pass positional or --stdin-format text
- clor inference elevenlabs sound-effects "rain" --audio-output-file x.mp3 --prompt-influence 2    # --prompt-influence must be between 0 and 1
- clor inference elevenlabs sound-effects "rain" --audio-output-file x.mp3 --duration 30    # --duration needs a unit (use 30s)
</examples-bad>
</help>


<help command="clor inference elevenlabs speech">
<summary>Synthesize speech from text with a chosen ElevenLabs voice (text-to-speech)</summary>
<description>Default voice is Maria Mysh (calm female American narrator,
vZzlAds9NzvLsFSWp0qk). Use the voice subcommand to search the full
library.

Pick the right TTS model for the use case.

  eleven_flash_v2_5         Lowest latency, around 75ms. Best for
                            real-time interactive voice work where
                            time-to-first-audio matters most.
  eleven_turbo_v2_5         High-throughput conversational use. Best
                            for voice agents and chat applications
                            that want strong quality at sub-second
                            latency.
  eleven_multilingual_v2    Broad multilingual coverage. Use when v3's
                            expressiveness is overkill and the workload
                            spans many languages.
  eleven_v3                 Default. Highest expressiveness and the
                            widest language support (70+). Best for
                            pre-rendered narration, audiobooks, and
                            podcasts where quality outranks latency.</description>
<usage>clor inference elevenlabs speech [flags]</usage>

<flags>
- --audio-output-file string: destination MP3 path (auto-generated in CWD when omitted)
- --language-code string: 2-letter language code, ISO 639-1 (en, es, fr); optional
- --model string: TTS model id. Faster to richer: eleven_flash_v2_5 (~75ms latency, real-time), eleven_turbo_v2_5 (high-throughput conversational), eleven_multilingual_v2 (broad language coverage), eleven_v3 (default, highest expressiveness) (default "eleven_v3")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --text string: text to synthesize
- --voice-id string: ElevenLabs voice id; default vZzlAds9NzvLsFSWp0qk (Maria Mysh, calm female American narrator). Other featured picks: PIGsltMj3gFMR34aFDI3 (Jonathan Livingston, calm male American narrator), Q7yjSu9pVI6fMxiCGwMo (Sarah, warm midwest female narrator), NuRyEq0OdD9mMOyd51UZ (Jofra, expressive young British male), tJ8LOFTaeHnV8MwJjjDK (Monique, female American audiobook narrator), flHkNRp1BlvT73UL6gyz (Jessica Anne Bogart, female American villainous), weA4Q36twV5kwSaTEL0Q (Eva, female American robotic AI assistant). Search the full library with the voice subcommand (default "vZzlAds9NzvLsFSWp0qk")
</flags>

<output>The audio is written to --audio-output-file (always MP3); when omitted, an unused MP3 path is generated in the current working directory. The chosen path is reported on stdout in text mode and in the file field of the response envelope under --stdout-format jsonl|json. The metadata stream also carries model, voice id, and character count. jsonl outputs the same object on one line; json outputs the full envelope including the base64 audio bytes.</output>

<output-example format="json">
{
  "audio": "SUQzBAAAAAAAI1RTU0UAAAAPAAAD...",
  "audio_mime_type": "audio/mpeg",
  "id": "speech_7f3a1c9b2e",
  "model": "eleven_v3",
  "usage": {
    "characters": 11
  }
}
</output-example>

<examples-good>
- clor inference elevenlabs speech --text "hello world"    # all-defaults: Maria Mysh voice, eleven_v3 model, auto-named MP3 in CWD
- clor inference elevenlabs speech --voice-id PIGsltMj3gFMR34aFDI3 --text "hello world" --audio-output-file hello.mp3    # explicit voice (Jonathan Livingston narrator) and path
- clor inference elevenlabs speech --voice-id 21m00Tcm4TlvDq8ikWAM --text "fast" --model eleven_flash_v2_5 --audio-output-file fast.mp3    # Flash v2.5 model
- clor inference elevenlabs speech --voice-id 21m00Tcm4TlvDq8ikWAM --text "hola mundo" --language-code es --audio-output-file es.mp3    # force Spanish pronunciation on a multilingual model
- echo "long script..." | clor inference elevenlabs speech --voice-id 21m00Tcm4TlvDq8ikWAM --stdin-format text --audio-output-file narration.mp3 --stdout-format json | jq '.usage.characters'    # stdin input; print character count
- clor inference elevenlabs speech --voice-id 21m00Tcm4TlvDq8ikWAM --text "hi" --audio-output-file hi.mp3 --stdout-format jsonl | grep '^event=result '    # logfmt summary line
</examples-good>

<examples-bad>
- clor inference elevenlabs speech    # missing text: pass --text or --stdin-format text
- clor inference elevenlabs speech --text "hi" --stdin-format text --audio-output-file hi.mp3    # --text and --stdin-format are mutually exclusive
</examples-bad>
</help>


<help command="clor inference elevenlabs transcribe">
<summary>Transcribe an audio file to text with ElevenLabs Scribe (speech-to-text)</summary>
<description>Accepts mp3, mp4, m4a, wav, webm, ogg, flac. Pick scribe_v2 (default)
for the lowest word-error rate across 90+ languages and the strongest
multi-language audio handling. scribe_v1 is kept supported for
compatibility with workflows pinned to its outputs.

--language-code locks the language and improves accuracy when known.
--keyterm-prompt (repeatable) biases recognition toward specific
terms (brand names, technical vocabulary, speaker names). Each prompt
adds keyterm_seconds to the usage block.
--enable-entity-detection surfaces detected entities (people, places,
organizations) in the response and bills entity_seconds.</description>
<usage>clor inference elevenlabs transcribe <FILE> [flags]</usage>

<flags>
- --enable-entity-detection bool: return detected entities in the response (entity_seconds populated in usage)
- --keyterm-prompt stringArray: keyterm prompt; pass repeatedly to bias recognition toward specific terms (keyterm_seconds populated in usage) (default "[]")
- --language-code string: 2-letter language code, ISO 639-1 (en, es, fr); optional hint
- --model string: STT model id (scribe_v1|scribe_v2) (default "scribe_v2")
</flags>

<output>The transcript is written to stdout in text mode; --stdout-format json also includes the per-word timings, entities, and audio duration. jsonl outputs the same object on one line; text writes the transcript on stdout and a one-line summary on stderr.</output>

<output-example format="json">
{
  "id": "transcribe_3e9a7c1f5b",
  "model": "scribe_v2",
  "text": "Thanks everyone for joining the weekly sync.",
  "usage": {
    "audio_seconds": 42.5,
    "entity_seconds": 0,
    "keyterm_seconds": 0
  }
}
</output-example>

<examples-good>
- clor inference elevenlabs transcribe meeting.mp3    # transcript on stdout, summary on stderr (default model: scribe_v2)
- clor inference elevenlabs transcribe meeting.mp3 --model scribe_v1    # use the v1 Scribe model
- clor inference elevenlabs transcribe meeting.mp3 --language-code en    # ISO 639-1 language hint to improve accuracy
- clor inference elevenlabs transcribe meeting.mp3 --enable-entity-detection --stdout-format json | jq '.entities'    # JSON envelope with detected entities
- clor inference elevenlabs transcribe meeting.mp3 --keyterm-prompt "Acme" --keyterm-prompt "Project Cygnus"    # improve recognition of two key terms
- clor inference elevenlabs transcribe call.wav --stdout-format jsonl | grep '^event=result '    # logfmt summary line
</examples-good>

<examples-bad>
- clor inference elevenlabs transcribe    # missing required <FILE>
- clor inference elevenlabs transcribe meeting.mp3 --model scribe_v3    # unknown model; use scribe_v1 or scribe_v2
- clor inference elevenlabs transcribe notes.txt    # rejected: not an audio extension
</examples-bad>
</help>


<help command="clor inference elevenlabs voice">
<summary>Browse the ElevenLabs voice library to find voice ids for speech and voice-changer</summary>
<usage>clor inference elevenlabs voice</usage>

<uses>
- the user wants to find a voice id to pass to speech or voice-changer
</uses>

<subcommands>
- list: Search the ElevenLabs voice library by gender, age, accent, language, use case, or free text
</subcommands>
</help>


<help command="clor inference elevenlabs voice list">
<summary>Search the ElevenLabs voice library by gender, age, accent, language, use case, or free text</summary>
<description>Always pass at least one filter or --search (the library has tens of
thousands of voices). Pagination: --page (0-indexed) + --page-size;
the response carries has_more.</description>
<usage>clor inference elevenlabs voice list [flags]</usage>

<flags>
- --accent string: filter by accent (american|british|australian|...)
- --age string: filter by age (young|middle_aged|old)
- --category string: filter by category (professional|high_quality|premade)
- --featured bool: only return voices flagged as featured
- --gender string: filter by gender (male|female|neutral)
- --language string: 2-letter language code, ISO 639-1 (en, es, fr); filter
- --page int: 0-indexed page number
- --page-size int: voices per page (1-100; default 30)
- --search string: free-text search across voice name and description
- --use-case string: filter by use case (social_media|narrative_story|characters_animation|...)
</flags>

<output>Text mode outputs a summary header plus one event=result line per voice. jsonl outputs the same one-line-per-voice records on stdout; json outputs the full voices array as one object.</output>

<output-example format="json">
{
  "has_more": true,
  "total_count": 248,
  "voices": [
    {
      "accent": "american",
      "category": "premade",
      "gender": "female",
      "language": "en",
      "name": "Rachel",
      "voice_id": "21m00Tcm4TlvDq8ikWAM"
    }
  ]
}
</output-example>

<examples-good>
- clor inference elevenlabs voice list --search "narrator" --language en    # find English narrator voices
- clor inference elevenlabs voice list --gender female --accent british --age middle_aged    # filter by demographics
- clor inference elevenlabs voice list --use-case characters_animation --stdout-format json | jq '.voices[] | {voice_id, name}'    # scope to character/animation voices
- clor inference elevenlabs voice list --search "calm" --page 0 --page-size 20    # first 20 calm voices
- clor inference elevenlabs voice list --search "calm" --page 1    # next page of the same query
- clor inference elevenlabs voice list --featured --stdout-format jsonl | grep '^event=result '    # featured voices as logfmt
</examples-good>

<examples-bad>
- clor inference elevenlabs voice list Adam    # this command takes no positional args; use --search instead
- clor inference elevenlabs voice list --page-size 500    # --page-size must be between 1 and 100
</examples-bad>
</help>


<help command="clor inference elevenlabs voice-changer">
<summary>Convert the speaker in an audio file to a target voice (speech-to-speech)</summary>
<description>Speech-to-speech: re-voices --audio-file as --voice-id. Discover
voice ids with the voice subcommand.</description>
<usage>clor inference elevenlabs voice-changer [flags]</usage>

<flags>
- --audio-file string: path to the source audio (required)
- --audio-output-file string: destination MP3 path (auto-generated in CWD when omitted)
- --model string: voice-changer model id (eleven_multilingual_sts_v2|eleven_english_sts_v2)
- --voice-id string: target voice id (required)
</flags>

<output>When --audio-output-file is omitted, an unused MP3 path is generated in the current working directory. The chosen path is reported on stdout in text mode and in the file field of the response envelope under --stdout-format jsonl|json. jsonl outputs the same object on one line; json outputs the full envelope with the saved file path.</output>

<output-example format="json">
{
  "id": "convert_4a8e2c1f9b",
  "audio_mime_type": "audio/mpeg",
  "usage": {
    "input_seconds": 12.7
  },
  "file": "converted.mp3"
}
</output-example>

<examples-good>
- clor inference elevenlabs voice-changer --voice-id 21m00Tcm4TlvDq8ikWAM --audio-file source.mp3 --audio-output-file converted.mp3    # convert source.mp3 into the target voice
- clor inference elevenlabs voice-changer --voice-id 21m00Tcm4TlvDq8ikWAM --audio-file source.mp3    # omit --audio-output-file; an MP3 path is auto-generated in CWD and printed on stdout
- clor inference elevenlabs voice-changer --voice-id X --audio-file in.wav --audio-output-file out.mp3 --stdout-format json | jq '.usage'    # JSON envelope with input duration
- clor inference elevenlabs voice-changer --voice-id X --audio-file in.mp3 --audio-output-file out.mp3 --stdout-format jsonl | grep '^event=result '    # logfmt summary line
</examples-good>

<examples-bad>
- clor inference elevenlabs voice-changer --audio-file in.mp3 --audio-output-file out.mp3    # missing required --voice-id
- clor inference elevenlabs voice-changer --voice-id X --audio-output-file out.mp3    # missing required --audio-file
</examples-bad>
</help>


<help command="clor inference elevenlabs voice-isolator">
<summary>Strip background noise from an audio recording, isolating the voice</summary>
<usage>clor inference elevenlabs voice-isolator [flags]</usage>

<flags>
- --audio-file string: path to the input audio (required)
- --audio-output-file string: destination MP3 path (auto-generated in CWD when omitted)
</flags>

<output>When --audio-output-file is omitted, an unused MP3 path is generated in the current working directory. The chosen path is reported on stdout in text mode and in the file field of the response envelope under --stdout-format jsonl|json. jsonl outputs the same object on one line; json outputs the full envelope with the saved file path.</output>

<output-example format="json">
{
  "id": "isolate_9c1f3e7a2b",
  "audio_mime_type": "audio/mpeg",
  "usage": {
    "input_seconds": 18.3
  },
  "file": "clean.mp3"
}
</output-example>

<examples-good>
- clor inference elevenlabs voice-isolator --audio-file noisy.wav --audio-output-file clean.mp3    # isolate voice; write to clean.mp3
- clor inference elevenlabs voice-isolator --audio-file noisy.wav    # omit --audio-output-file; an MP3 path is auto-generated in CWD and printed on stdout
- clor inference elevenlabs voice-isolator --audio-file call.mp3 --audio-output-file iso.mp3 --stdout-format json | jq '.usage.input_seconds'    # JSON envelope; show input audio duration
- clor inference elevenlabs voice-isolator --audio-file in.mp3 --audio-output-file out.mp3 --stdout-format jsonl | grep '^event=result '    # logfmt summary line
</examples-good>

<examples-bad>
- clor inference elevenlabs voice-isolator --audio-output-file out.mp3    # missing required --audio-file
- clor inference elevenlabs voice-isolator --audio-file notes.txt    # rejected: not an audio extension
</examples-bad>
</help>

<help command="clor inference google">
<summary>Call Google for Gemini text generation and nano-banana image generation and editing</summary>
<description>Gemini text generation, exact prompt token counting, and nano-banana
image generation and editing. Pick the smallest model that can do
the job.

Text tiers (cheap to strong)
  gemini-3.1-flash-lite     Default. Cheap and fast with Gemini 3
                            thinking controls. $0.25/$1.5 per Mtok.
  gemini-3.1-pro-preview    Preview frontier reasoning model with the
                            thinkingLevel enum (LOW or HIGH only).
                            $2/$12 per Mtok (short), $4/$18 (long).
                            200K input cliff bills the whole request
                            at the long-context tier.

Image tiers (cheap to strong)
  gemini-3.1-flash-lite-image       Nano Banana Lite. Cheapest and
                                    fastest. Per-token output billing
                                    at $0.25/$30 per Mtok. Lowest cost,
                                    lower fidelity.
  gemini-3.1-flash-image-preview    Default. Nano Banana 2. Per-token
                                    output billing. Faster preview
                                    iteration than Pro, at lower
                                    fidelity.
  gemini-3-pro-image-preview        Nano Banana Pro. Highest fidelity.
                                    Per-token output billing.

Reasoning surface differs by family. Gemini 2.5 uses thinkingBudget
(numeric). Gemini 3+ uses thinkingLevel (enum). The --reasoning flag
maps both transparently. Thinking tokens are billed as output tokens
and share the --max-tokens cap.</description>
<usage>clor inference google</usage>

<uses>
- the request is image generation or editing with nano banana
- the caller needs Gemini text output and cannot generate it inline
- the request needs Gemini's long-context window (>200K) or its thinking modes
- the caller wants gemini-3.1-flash-lite at flash-lite cost with Gemini 3 thinking controls
- the caller wants Gemini 3.1 Pro preview for frontier reasoning
</uses>

<subcommands>
- count-tokens: Count prompt tokens for a Gemini generate call without running generation
- image: Generate or edit an image with Gemini's nano-banana family from a text prompt
- text: Generate text with a Gemini model (2.5 GA family, 3.1 and 3.5 stable, or 3.x previews)
</subcommands>
</help>


<help command="clor inference google count-tokens">
<summary>Count prompt tokens for a Gemini generate call without running generation</summary>
<description>Exact count via Gemini's countTokens endpoint; text-only (image
models rejected). Use this before committing to a long-context Pro
call (>200K input bills the long-context tier on the whole request).

Input modes (mutually exclusive): positional arg, --stdin-format text
(single user message), or --stdin-format json (multi-turn array).</description>
<usage>clor inference google count-tokens [PROMPT] [flags]</usage>

<flags>
- --model string: model id; must be a text-generation Gemini model (image-generation models are rejected). Tokenization is model-specific so the count matches a real generate call against the same model (default "gemini-3.1-flash-lite")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --system string: optional system prompt; counted against the input
</flags>

<output>text writes the bare token count on stdout and a one-line summary on stderr. jsonl outputs the same object on one line; json outputs the model and input_tokens object on stdout.</output>

<output-example format="json">
{
  "model": "gemini-2.5-flash",
  "input_tokens": 14
}
</output-example>

<examples-good>
- clor inference google count-tokens "what is 2+2?"    # default model (gemini-2.5-flash); prints input_tokens on stdout
- clor inference google count-tokens "summarize this" --model gemini-2.5-pro    # Pro tokenizer for context-cliff budgeting (long tier above 200K)
- cat large_doc.txt | clor inference google count-tokens --stdin-format text --stdout-format json | jq '.input_tokens'    # JSON envelope; pipe the count into a budget check
- clor inference google count-tokens "hi" --stdout-format jsonl | grep '^event=count '    # logfmt summary line
- echo '[{"role":"user","content":"a"},{"role":"assistant","content":"b"},{"role":"user","content":"c"}]' | clor inference google count-tokens --stdin-format json    # multi-turn count
</examples-good>

<examples-bad>
- clor inference google count-tokens    # no input: pass a positional prompt or --stdin-format text|json
- clor inference google count-tokens "hi" --model gemini-2.5-flash-image    # image-generation model rejected; count-tokens is text-only
- clor inference google count-tokens "hi" --stdin-format text    # --stdin-format and a positional prompt are mutually exclusive
</examples-bad>
</help>


<help command="clor inference google image">
<summary>Generate or edit an image with Gemini's nano-banana family from a text prompt</summary>
<description>Generate from scratch or edit an existing image (--image-input).

  gemini-3.1-flash-lite-image       Nano Banana Lite. Cheapest and
                                    fastest. Per-token output billing
                                    at $0.25/$30 per Mtok. Lowest cost,
                                    lower fidelity.
  gemini-3.1-flash-image-preview    Default. Nano Banana 2. Per-token
                                    output billing. Faster preview
                                    iteration than Pro, at lower
                                    fidelity.
  gemini-3-pro-image-preview        Nano Banana Pro. Highest fidelity
                                    and best instruction following.
                                    Per-token output billing.

For multi-turn image editing on the preview models, thought signatures
from prior turns must be passed back; image-edit signatures are
strictly enforced.</description>
<usage>clor inference google image <PROMPT> [flags]</usage>

<flags>
- --aspect-ratio string: aspect ratio (1:1|16:9|9:16|4:3|3:4)
- --image-input string: path to a PNG or JPEG to edit (optional)
- --image-output-file string: destination file path; default is a unique safe-named PNG in the current directory
- --model string: model id. gemini-3.1-flash-lite-image (Nano Banana Lite, cheapest and fastest, per-token billing, lower fidelity), gemini-3.1-flash-image-preview (default, Nano Banana 2, per-token billing, faster preview iteration), gemini-3-pro-image-preview (Nano Banana Pro, highest fidelity, per-token billing) (default "gemini-3.1-flash-image-preview")
</flags>

<output>The image is written to disk: to --image-output-file when set, otherwise a unique safe-named PNG in the current working directory. The saved path is printed on stdout in text mode; --stdout-format json also includes the base64-encoded image bytes. jsonl outputs a one-line summary on stdout instead of the saved path.</output>

<output-example format="json">
{
  "id": "gemini-img-7c3e1f9a2b",
  "images": [
    {
      "data_base64": "iVBORw0KGgoAAAANSUhEUgAA...",
      "mime_type": "image/png"
    }
  ],
  "model": "gemini-2.5-flash-image",
  "usage": {
    "images_generated": 1,
    "input_tokens": 16,
    "output_image_tokens": 0,
    "output_text_tokens": 0
  }
}
</output-example>

<examples-good>
- clor inference google image "a cat in sunglasses"    # saves a uniquely-named PNG in CWD; the path is printed on stdout
- clor inference google image "a cat in sunglasses" --model gemini-3.1-flash-lite-image    # cheapest and fastest tier (Nano Banana Lite); lower fidelity at $0.25/$30 per Mtok
- clor inference google image "a watercolor sunrise" --image-output-file sunrise.png    # save to a specific path
- clor inference google image "modern logo, minimalist" --aspect-ratio 16:9    # set aspect ratio
- clor inference google image "make this person smile" --image-input portrait.jpg    # edit an existing image
- clor inference google image "a koala" --model gemini-3-pro-image-preview --stdout-format json | jq '.usage'    # JSON envelope with token usage; uses Nano Banana Pro
</examples-good>

<examples-bad>
- clor inference google image    # missing required <PROMPT>
- clor inference google image "x" --model gemini-2.5-flash    # text model rejected; pass an image-generation model
- clor inference google image "x" --aspect-ratio 21:9    # unsupported aspect ratio
</examples-bad>
</help>


<help command="clor inference google text">
<summary>Generate text with a Gemini model (2.5 GA family, 3.1 and 3.5 stable, or 3.x previews)</summary>
<description>Pick the smallest model that can do the job. flash-lite for cheap
high-volume work, pro for frontier reasoning.

200K-input cliff on Pro models: prompts above 200K input tokens bill
the entire request (input + output + cache) at the long-context tier
(2x-1.5x the short-context rates). Count tokens with the count-tokens
subcommand before committing.

--reasoning per-effort cost framing:

  off    No thinking on Gemini 2.5. On Gemini 3 Flash this maps to
         MINIMAL (the model still does some thinking; thinkingLevel
         has no zero-budget escape hatch). On Gemini 3 Pro it clamps
         up to LOW, since Pro has no MINIMAL tier. Cheapest, lowest
         latency.
  low    2.5: 2048-token thinking budget. 3+: LOW. Light reasoning
         for simple structured edits.
  medium 2.5: 8192-token thinking budget. 3 Flash: MEDIUM. 3 Pro
         clamps to LOW. Working default for ordinary reasoning.
  high   2.5: 16384-token thinking budget. 3+: HIGH. Multi-step
         planning, code review, harder analysis.
  xhigh  2.5: 32768-token thinking budget. 3+: clamps to HIGH (3
         Flash maxes at HIGH, 3 Pro accepts only LOW/HIGH). For the
         hardest reasoning problems on 2.5.
  max    2.5: dynamic model-chosen ceiling. 3+: clamps to HIGH. Let
         the model spend whatever it needs (2.5) or hit the highest
         level (3+).

Thinking tokens are billed as output tokens and share the
--max-tokens cap, so raising effort raises both cost and the risk of
truncated visible output. Image-generation models reject --reasoning
with 400.</description>
<usage>clor inference google text [PROMPT] [flags]</usage>

<flags>
- --max-tokens int: max output tokens (caps at the model's documented max). Thinking tokens count toward this cap
- --model string: model id. Cheap to strong: gemini-3.1-flash-lite (default), gemini-3.1-pro-preview. Pro models charge a long-context premium above 200K input tokens. Gemini 3+ models use the thinkingLevel enum (default "gemini-3.1-flash-lite")
- --reasoning string: reasoning effort (off|low|medium|high|xhigh|max). Mapping depends on family. Gemini 2.5 uses thinkingBudget (off=0, low=2048, medium=8192, high=16384, xhigh=32768, max=dynamic ceiling). Gemini 3 Flash uses thinkingLevel (off=MINIMAL, low=LOW, medium=MEDIUM, high=HIGH; xhigh and max clamp to HIGH). Gemini 3 Pro accepts only LOW and HIGH, so off and medium clamp up to LOW (Pro has no MINIMAL tier) and xhigh/max clamp up to HIGH. Thinking tokens are billed as output tokens (default "off")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --stop stringArray: stop sequence; pass repeatedly for multiple (max 4) (default "[]")
- --system string: optional system prompt; passed to Gemini's systemInstruction
- --temperature float32: sampling temperature (0.0-2.0); -1 means use the model's default. Gemini 3 reasoning is calibrated for the default; tuning below 1.0 can cause looping on hard reasoning tasks (default "-1")
- --top-p float32: nucleus-sampling threshold (0.0-1.0); -1 means use the model's default (default "-1")
</flags>

<output>Default output (text): the model's text response on stdout, plus a one-line summary (model, token counts) on stderr. JSON output: the full response envelope including usage. jsonl outputs the same object on one line; text writes the assistant text on stdout and a one-line summary on stderr.</output>

<output-example format="json">
{
  "content": [
    {
      "text": "The capital of France is Paris.",
      "type": "text"
    }
  ],
  "finish_reason": "STOP",
  "id": "gemini-2f9c1a8b3d",
  "model": "gemini-2.5-flash",
  "usage": {
    "cached_input_audio_tokens": 0,
    "cached_input_tokens": 0,
    "input_audio_tokens": 0,
    "input_tokens": 12,
    "output_tokens": 9,
    "thinking_tokens": 0
  }
}
</output-example>

<examples-good>
- clor inference google text "summarize: rain falls" --model gemini-3.1-flash-lite    # fast tier for trivial summarization
- clor inference google text "summarize this in one paragraph"    # default (gemini-3.1-flash-lite)
- clor inference google text "plan a database migration with rollback" --model gemini-3.1-pro-preview --reasoning high    # Pro 3.1 preview at HIGH thinking level for hard planning
- clor inference google text "review this 300K-token codebase" --model gemini-3.1-pro-preview --reasoning high    # long context (>200K bills the long tier); HIGH thinking level for a frontier review
- clor inference google text "be terse" --system "answer in one word" --temperature 0.2 --model gemini-3.1-flash-lite    # system prompt + sampling control on the fast tier
- echo '[{"role":"user","content":"name a color"},{"role":"assistant","content":"blue"},{"role":"user","content":"name another"}]' | clor inference google text --stdin-format json    # multi-turn via stdin JSON
- cat note.txt | clor inference google text --stdin-format text --model gemini-3.1-flash-lite    # treat the file body as a single user message on the fast tier
</examples-good>

<examples-bad>
- clor inference google text "hi" --model gemini-1.5-pro    # rejected: legacy model not in supported set
- clor inference google text "hi" --reasoning extreme    # --reasoning must be off, low, medium, high, xhigh, or max
- clor inference google text "hi" --stdin-format wrong    # --stdin-format must be text or json
- clor inference google text "hi" --temperature 5    # --temperature must be between 0 and 2
- clor inference google text "what is 2+2?" --model gemini-3.1-pro-preview    # wasteful: paying Pro prices for arithmetic. Either answer inline or pass --model gemini-3.1-flash-lite
</examples-bad>
</help>

<help command="clor inference openai">
<summary>Call OpenAI for GPT text, gpt-image generation and editing, and gpt-4o audio transcription</summary>
<description>GPT text, gpt-image generation and editing, gpt-4o transcription.
Pick the smallest model that can do the job.

Text tiers (cheap to strong)
  gpt-5.4-nano   Cheapest. Best for the highest-volume extraction,
                 classification, and reformatting where cost dominates.
                 Accepts low|medium|high effort. $0.20/$1.25 per Mtok.
  gpt-5.4-mini   Cheap and fast. Best for high-volume extraction,
                 summarization, classification, reformatting.
                 Accepts low|medium|high effort. $0.75/$4.5 per Mtok.
  gpt-5.6-luna   Cheap general-purpose. Accepts low through max effort.
                 $1/$6 per Mtok.
  gpt-5.6-terra  Mid-tier. Strong reasoning at half the flagship rate.
                 Accepts low through max effort. $2.50/$15 per Mtok.
  gpt-5.6-sol    Default. Frontier reasoning. Adds xhigh and max effort
                 for the hardest problems. $5/$30 per Mtok.
  gpt-5.5        Previous flagship. Accepts low through xhigh effort.
                 $5/$30 per Mtok.

Image tiers (cheap to strong)
  gpt-image-1-mini  Lightest. Best for thumbnails and quick iteration.
  gpt-image-2       Default. Newest. Best instruction following and
                    output quality.

Audio (cheap to strong)
  gpt-4o-mini-transcribe  Speech-to-text, half the cost.
  gpt-4o-transcribe       Speech-to-text, default, most accurate.
                          mp3, mp4, m4a, wav, webm, ogg, flac.
                          25 MiB cap enforced client-side.</description>
<usage>clor inference openai</usage>

<uses>
- the request is image generation or editing
- the request is audio transcription (mp3, mp4, m4a, wav, webm, ogg, flac)
- the caller needs GPT text output and cannot generate it inline
- the caller wants OpenAI-specific knobs (auto-cached prompts >=1024 tokens, summarized reasoning traces, max effort on the gpt-5.6 family)
</uses>

<subcommands>
- count-tokens: Count prompt tokens for an OpenAI Responses call without running generation
- image: Generate or edit an image with OpenAI's gpt-image family from a text prompt
- text: Generate text with GPT via the OpenAI Responses API
- transcribe: Transcribe an audio file to text with OpenAI's gpt-4o-transcribe
</subcommands>
</help>


<help command="clor inference openai count-tokens">
<summary>Count prompt tokens for an OpenAI Responses call without running generation</summary>
<description>Counted locally with tiktoken (o200k_base for gpt-5.x/gpt-4o); lands
within a small constant of upstream's usage.input_tokens. OpenAI has
no count_tokens API.

Input modes (mutually exclusive): positional arg, --stdin-format text
(single user message), or --stdin-format json (multi-turn array).</description>
<usage>clor inference openai count-tokens [PROMPT] [flags]</usage>

<flags>
- --model string: model id (gpt-5.6-sol|gpt-5.6-terra|gpt-5.6-luna|gpt-5.5|gpt-5.4-mini). The gpt-5.x family shares the o200k_base tokenizer, so the count is identical across them today; the field is kept per-model for future-proofing (default "gpt-5.6-sol")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --system string: optional system prompt; counted against the input
</flags>

<output>text writes the bare token count on stdout and a one-line summary on stderr. jsonl outputs the same object on one line; json outputs the model and input_tokens object on stdout.</output>

<output-example format="json">
{
  "model": "gpt-5.6-sol",
  "input_tokens": 14
}
</output-example>

<examples-good>
- clor inference openai count-tokens "what is 2+2?"    # default model (gpt-5.6-sol); prints input_tokens on stdout
- clor inference openai count-tokens "summarize this" --model gpt-5.4-mini --system "be terse"    # smaller model; same o200k_base tokenizer across the family
- cat large_doc.txt | clor inference openai count-tokens --stdin-format text --stdout-format json | jq '.input_tokens'    # JSON envelope; pipe the count into a budget check
- clor inference openai count-tokens "hi" --stdout-format jsonl | grep '^event=count '    # logfmt summary line
- echo '[{"role":"user","content":"a"},{"role":"assistant","content":"b"},{"role":"user","content":"c"}]' | clor inference openai count-tokens --stdin-format json    # multi-turn count
</examples-good>

<examples-bad>
- clor inference openai count-tokens    # no input: pass a positional prompt or --stdin-format text|json
- clor inference openai count-tokens "hi" --model gpt-fake    # rejected: not in the supported model set
- clor inference openai count-tokens "hi" --stdin-format wrong    # --stdin-format must be text or json
</examples-bad>
</help>


<help command="clor inference openai image">
<summary>Generate or edit an image with OpenAI's gpt-image family from a text prompt</summary>
<description>Generate from scratch or edit an existing image (--image-input).
Pick the smallest model that meets the quality bar.

  gpt-image-1-mini   Lightest tier. Use for thumbnails, exploratory
                     drafts, fast iteration loops.
  gpt-image-2        Default. Newest. Best instruction following and
                     finest detail. Use when quality matters and the
                     prompt encodes specific composition or text.

--size and --quality default to auto. --n batches up to 10 generations
in one call; only the first is written to disk by default.</description>
<usage>clor inference openai image <PROMPT> [flags]</usage>

<flags>
- --image-input string: path to a PNG or JPEG to edit (optional)
- --image-output-file string: destination file path; default is a unique safe-named PNG in the current directory (only the first image is written when n>1)
- --model string: model id (gpt-image-1-mini|gpt-image-2) (default "gpt-image-2")
- --n int: number of images to generate (1-10) (default "1")
- --quality string: quality (auto|low|medium|high); defaults to auto
- --size string: image size (auto|1024x1024|1024x1536|1536x1024); defaults to auto
</flags>

<output>The image is written to disk: to --image-output-file when set, otherwise a unique safe-named PNG in the current working directory. The saved path is printed on stdout in text mode; --stdout-format json also includes the base64-encoded image bytes alongside the per-modality token breakdown. jsonl outputs a one-line summary on stdout instead of the saved path.</output>

<output-example format="json">
{
  "images": [
    {
      "data_base64": "iVBORw0KGgoAAAANSUhEUgAA...",
      "mime_type": "image/png"
    }
  ],
  "model": "gpt-image-2",
  "usage": {
    "cached_input_image_tokens": 0,
    "cached_input_text_tokens": 0,
    "images_generated": 1,
    "input_image_tokens": 0,
    "input_text_tokens": 18,
    "output_image_tokens": 1056,
    "output_text_tokens": 0
  }
}
</output-example>

<examples-good>
- clor inference openai image "a watercolor cat"    # saves a uniquely-named PNG in CWD; the path is printed on stdout
- clor inference openai image "a watercolor sunrise" --image-output-file sunrise.png    # save to a specific path
- clor inference openai image "modern logo, minimalist" --quality high --size 1024x1024    # default model (gpt-image-2) + explicit size and quality
- clor inference openai image "quick sketch" --model gpt-image-1-mini    # switch to the lightest tier
- clor inference openai image "make this person smile" --image-input portrait.jpg    # edit an existing image
- clor inference openai image "a koala" --stdout-format json | jq '.usage'    # JSON envelope with token usage
</examples-good>

<examples-bad>
- clor inference openai image    # missing required <PROMPT>
- clor inference openai image "x" --model gpt-5.5    # text model rejected; pass an image-generation model
- clor inference openai image "x" --quality extreme    # --quality must be auto, low, medium, or high
- clor inference openai image "x" --n 0    # --n must be between 1 and 10
- clor inference openai image "x" --model dall-e-3    # DALL-E shut down 2026-05-12; pass a gpt-image-* model
</examples-bad>
</help>


<help command="clor inference openai text">
<summary>Generate text with GPT via the OpenAI Responses API</summary>
<description>Pick the smallest model that can do the job. gpt-5.4-mini for
high-volume extraction or simple reformatting, gpt-5.6-sol (default)
when frontier reasoning is worth the spend.

Prompts >=1024 tokens auto-cache for ~90 percent discount on hits;
hits surface in usage.cached_input_tokens.

--reasoning per-effort cost framing:

  off    Lets the model use its built-in default. gpt-5.x cannot be
         fully disabled; the default tier is medium. Right choice for
         general-purpose calls where you want the model to pick.
  low    Light reasoning. Small slice of max_output_tokens reserved.
         Use for short structured edits and simple multi-step work.
  medium Working default for ordinary reasoning tasks.
  high   Multi-step planning, code review, harder analysis.
  xhigh  gpt-5.5 and the gpt-5.6 family. For the hardest problems that
         justify the spend.
  max    gpt-5.6 family only. The top effort tier for the very hardest
         problems.

Reasoning tokens are billed as output tokens and share the
--max-tokens cap, so raising effort raises both cost and the risk
that visible output gets truncated (status=incomplete). Summarized
reasoning traces surface under --stdout-format json. Raw reasoning
tokens are never returned.</description>
<usage>clor inference openai text [PROMPT] [flags]</usage>

<flags>
- --max-tokens int: max output tokens (caps at the model's documented max). Reasoning tokens count toward this cap together with visible output; hitting the cap mid-reasoning returns status=incomplete
- --model string: model id. Cheap to strong: gpt-5.4-nano ($0.20/$1.25 per Mtok, cheapest high-volume), gpt-5.4-mini ($0.75/$4.5, simple high-volume), gpt-5.6-luna ($1/$6, cheap general-purpose), gpt-5.6-terra ($2.50/$15, mid-tier), gpt-5.6-sol ($5/$30, frontier reasoning, default) (default "gpt-5.6-sol")
- --reasoning string: reasoning effort (off|low|medium|high|xhigh|max). off omits the field so the model uses its built-in default (gpt-5.x cannot be fully disabled, default is medium). low/medium/high climb in capability and cost. xhigh needs gpt-5.5 or the gpt-5.6 family; max is gpt-5.6 only and is for the hardest problems. Reasoning tokens are billed as output tokens and never returned verbatim (summaries surface under --stdout-format json) (default "off")
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --system string: optional system prompt (sent as OpenAI's instructions field). Prompts >=1024 tokens auto-cache for ~90 percent discount on hits
- --temperature float32: sampling temperature (0.0-2.0); -1 means use the model's default (default "-1")
- --top-p float32: nucleus-sampling threshold (0.0-1.0); -1 means use the model's default. OpenAI recommends temperature OR top-p, not both (default "-1")
</flags>

<output>Default output (text): the model's text response on stdout, plus a one-line summary (model, token counts) on stderr. JSON output: the full response envelope including usage. jsonl outputs the same object on one line; text writes the assistant text on stdout and a one-line summary on stderr.</output>

<output-example format="json">
{
  "id": "resp_68a1f2c3d4e5f6a7b8c9d0e1",
  "model": "gpt-5.6-sol",
  "output": [
    {
      "content": [
        {
          "text": "The capital of France is Paris.",
          "type": "output_text"
        }
      ],
      "role": "assistant",
      "type": "message"
    }
  ],
  "status": "completed",
  "usage": {
    "cached_input_tokens": 0,
    "input_tokens": 12,
    "output_tokens": 9,
    "reasoning_tokens": 0
  }
}
</output-example>

<examples-good>
- clor inference openai text "summarize in 3 words: I went to the store" --model gpt-5.4-mini    # cheap tier for trivial summarization
- clor inference openai text "draft a release note"    # default (gpt-5.6-sol) for ordinary writing
- clor inference openai text "name a color" --system "be terse" --temperature 0.2 --model gpt-5.4-mini    # system prompt sent as the instructions field; sampling on the cheap tier
- clor inference openai text "plan a 3-step refactor of this function" --reasoning high    # high effort on gpt-5.6-sol; reasoning summary surfaces under output[].summary in --stdout-format json
- clor inference openai text "design a distributed scheduler with 3 invariants" --reasoning max    # top effort, gpt-5.6 family only, for the hardest reasoning
- clor inference openai text "what is 2+2?" --model gpt-5.4-mini --stdout-format json | jq '.usage.reasoning_tokens'    # see how many output tokens were spent on reasoning
- echo '[{"role":"user","content":"name a color"},{"role":"assistant","content":"blue"},{"role":"user","content":"name another"}]' | clor inference openai text --stdin-format json --model gpt-5.4-mini    # multi-turn via stdin JSON
- cat note.txt | clor inference openai text --stdin-format text --model gpt-5.4-mini    # treat the file body as a single user message on the cheap tier
</examples-good>

<examples-bad>
- clor inference openai text "hi" --model gpt-fake    # rejected: not in the supported model set
- clor inference openai text "hi" --stdin-format text    # --stdin-format and a positional prompt are mutually exclusive
- clor inference openai text "hi" --model gpt-5.4-mini --reasoning max    # rejected: max needs the gpt-5.6 family; gpt-5.4-mini caps at high
- clor inference openai text "hi" --model gpt-5.5 --reasoning max    # rejected: gpt-5.5 caps at xhigh; max is gpt-5.6 only
- clor inference openai text "hi" --temperature 3    # --temperature must be between 0 and 2
- clor inference openai text "what is 2+2?"    # wasteful: paying gpt-5.6-sol prices for arithmetic. Either answer inline or pass --model gpt-5.4-mini
</examples-bad>
</help>


<help command="clor inference openai transcribe">
<summary>Transcribe an audio file to text with OpenAI's gpt-4o-transcribe</summary>
<description>Accepts mp3, mp4, mpeg, mpga, m4a, wav, webm, ogg, flac. 25 MiB cap
is enforced client-side so oversized uploads do not waste a round
trip.

gpt-4o-transcribe (default) is the most accurate; gpt-4o-mini-transcribe
is half the cost for high-volume work.

Set --language when the audio language is known; it cuts latency and
improves accuracy. Set --prompt to bias recognition toward known
vocabulary (brand names, technical terms, speaker names) or to
continue a prior segment. The prompt should match the audio language.</description>
<usage>clor inference openai transcribe <FILE> [flags]</usage>

<flags>
- --language string: 2-letter language code, ISO 639-1 (en, fr); optional, improves accuracy and latency when known
- --model string: transcription model id (gpt-4o-transcribe|gpt-4o-mini-transcribe). mini is half the cost; full is more accurate (default "gpt-4o-transcribe")
- --prompt string: optional context text to help with vocabulary or continue a previous segment; should match the audio language
</flags>

<output>The transcript is written to stdout in text mode; --stdout-format json also includes the detected language and audio duration. jsonl outputs the same object on one line; text writes the transcript on stdout and a one-line summary on stderr.</output>

<output-example format="json">
{
  "duration_seconds": 42.5,
  "language": "en",
  "text": "Thanks everyone for joining the weekly sync. Let's start with the roadmap."
}
</output-example>

<examples-good>
- clor inference openai transcribe meeting.mp3    # transcribe a meeting recording with the default gpt-4o-transcribe
- clor inference openai transcribe call.wav --language en    # force English language for faster, more accurate transcription
- clor inference openai transcribe podcast.m4a --model gpt-4o-mini-transcribe    # half-cost tier for high-volume transcription
- clor inference openai transcribe lecture.mp3 --stdout-format json | jq '.duration_seconds'    # JSON envelope; show audio duration
- clor inference openai transcribe interview.flac --stdout-format jsonl | grep '^event=transcript '    # logfmt summary line
</examples-good>

<examples-bad>
- clor inference openai transcribe    # missing required <FILE>
- clor inference openai transcribe notes.txt    # non-audio file rejected; pass mp3/wav/m4a/etc.
- clor inference openai transcribe call.mp3 --model whisper-1    # whisper-1 was delisted; pass gpt-4o-transcribe or gpt-4o-mini-transcribe
</examples-bad>
</help>

<help command="clor inference openrouter">
<summary>Reach hundreds of chat and image-generation models through OpenRouter</summary>
<description>Single OpenAI-compatible chat-completions surface fronting hundreds
of models from many labs (Anthropic, OpenAI, Google, X-AI, Meta,
Mistral, DeepSeek, Qwen, and many smaller labs). Model strings are
open passthrough; any id OpenRouter accepts is forwarded unchanged.
Per-call dollar cost comes back in the response, so no per-model rate
table is maintained here.

Prefer the dedicated subcommands (anthropic, openai, google) for
models that live there. They expose stronger feature parity (count
tokens, image generation, reasoning effort enums, modality-split
usage) and transparent pricing tiers. Reach for openrouter when:

  - the caller needs Llama, DeepSeek, Qwen, X-AI Grok, Mistral, or
    another model the dedicated subcommands do not cover
  - the caller wants to try an open-weights model without standing up
    inference infrastructure
  - the caller wants to benchmark a model against another vendor's
    surface (responses come back in OpenAI-compatible shape)

Use the model subcommand to discover model ids and pricing.</description>
<usage>clor inference openrouter</usage>

<subcommands>
- model: Browse the OpenRouter catalogue to find model ids for chat
- text: Generate text with any OpenRouter model
</subcommands>
</help>


<help command="clor inference openrouter model">
<summary>Browse the OpenRouter catalogue to find model ids for chat</summary>
<description>Discover model ids to pass as --model on the text subcommand. The
catalogue fronts hundreds of models from many labs.</description>
<usage>clor inference openrouter model</usage>

<subcommands>
- list: List OpenRouter models, defaulting to the top 30 newest from frontier labs
</subcommands>
</help>


<help command="clor inference openrouter model list">
<summary>List OpenRouter models, defaulting to the top 30 newest from frontier labs</summary>
<description>Defaults to top 30 newest from frontier labs (anthropic, openai,
google, x-ai, meta-llama, mistralai, deepseek, qwen, openrouter),
excluding `:free` and `:nitro` variants. --all dumps every model;
--provider/--modality/--search narrow within the default curation.
JSON output includes per-token pricing; text/jsonl omit it.</description>
<usage>clor inference openrouter model list [flags]</usage>

<flags>
- --all bool: skip the frontier-lab default curation and return every model OpenRouter fronts
- --limit int: maximum rows to return; ignored when --all is set (default "30")
- --modality string: filter by output modality (text|image|audio)
- --provider stringArray: filter to one provider id prefix (anthropic, openai, google, ...); repeatable (default "[]")
- --search string: case-insensitive substring match on model id, name, and description
</flags>

<output>Default text mode prints one event=result line per model with id, name, context length, and modalities. Use --stdout-format json to also surface per-token pricing. jsonl outputs the same one-line-per-model records on stdout; json outputs the full models array as one object.</output>

<output-example format="json">
{
  "models": [
    {
      "context_length": 200000,
      "created": 1735689600,
      "id": "anthropic/claude-sonnet-4-6",
      "input_modalities": [
        "text",
        "image"
      ],
      "name": "Anthropic: Claude Sonnet 4.6",
      "output_modalities": [
        "text"
      ],
      "pricing": {
        "completion": "0.000015",
        "prompt": "0.000003"
      }
    }
  ]
}
</output-example>

<examples-good>
- clor inference openrouter model list    # default: top 30 newest frontier-lab models
- clor inference openrouter model list --provider anthropic    # every anthropic model OpenRouter fronts
- clor inference openrouter model list --modality image    # image-capable models (includes google/gemini-2.5-flash-image)
- clor inference openrouter model list --search claude --stdout-format json | jq '.models[].pricing'    # JSON envelope; see per-token prices
- clor inference openrouter model list --all --provider qwen --limit 5    # first 5 qwen models from the full catalogue
- clor inference openrouter model list --stdout-format jsonl | grep '^event=result '    # logfmt one-line-per-model output
</examples-good>

<examples-bad>
- clor inference openrouter model list claude    # no positional args; pass --search claude instead
- clor inference openrouter model list --modality video    # --modality must be text, image, or audio
- clor inference openrouter model list --limit 0    # --limit must be >= 1
</examples-bad>
</help>


<help command="clor inference openrouter text">
<summary>Generate text with any OpenRouter model</summary>
<description>--model is required; OpenRouter has no implicit default since the
catalogue spans hundreds of models. Examples:
anthropic/claude-opus-4-8, openai/gpt-5.5, google/gemini-3.5-flash,
meta-llama/llama-3.3-70b-instruct, deepseek/deepseek-v3,
x-ai/grok-4. Discover ids with the model subcommand.

Input modes: positional, --stdin-format text, or --stdin-format json
(multi-turn array).

Multimodal: --image-input (local file, repeatable) or --image-url
(remote or data URL, repeatable) attach to the final user message.

Image generation: --image-output PATH on an image-capable model opts
the request into image-output modality; the first returned image is
saved.

Reasoning is a coarse effort hint passed through to whichever upstream
model supports thinking. --reasoning low|medium|high lands on the
upstream's effort enum where one exists. --reasoning-tokens N is an
explicit token budget that takes precedence over --reasoning when
both are set. Models without reasoning support silently ignore both
fields. Because OpenRouter normalizes a heterogeneous set of upstreams,
exact effort semantics vary by model; expect frontier behaviour to
match each lab's own surface.</description>
<usage>clor inference openrouter text [PROMPT] [flags]</usage>

<flags>
- --image-input stringArray: path to a local PNG/JPEG/WEBP to attach to the user message for vision models (read, base64-encoded, sent as a data: URL); repeatable (default "[]")
- --image-output string: destination file path for an image-generation model's output; setting this also opts the request into image-output modality. When the model returns multiple images only the first is written
- --image-url stringArray: image URL to attach to the user message for vision models (http(s) or data:); repeatable (default "[]")
- --max-tokens int: cap on output tokens (0 means the model's own default)
- --model string: OpenRouter model id (anthropic/claude-opus-4-8, openai/gpt-5.5, google/gemini-3.5-flash, meta-llama/llama-3.3-70b-instruct, deepseek/deepseek-v3, x-ai/grok-4, ...). Required; no default since OpenRouter is open passthrough across hundreds of models. Discover ids with the model subcommand
- --reasoning string: reasoning effort for models that support thinking (low|medium|high); ignored by models without reasoning
- --reasoning-tokens int: explicit reasoning budget in tokens; takes precedence over --reasoning when both are set
- --stdin-file string: read input from this file instead of process stdin
- --stdin-format string: shape of piped stdin: text (raw bytes / one item per line) or json (a JSON value); only set when actually piping input (cmd | clor ..., clor ... <file, or --stdin-file); if you have an inline string, pass it as a positional instead
- --stop stringArray: custom stop string; up to four entries; repeatable (default "[]")
- --system string: optional system prompt prepended as a role=system message
- --temperature float32: sampling temperature (0.0-2.0); -1 means use the model's default (default "-1")
- --top-p float32: nucleus sampling threshold (0.0-1.0); -1 means use the model's default (default "-1")
</flags>

<output>Default output (text): the assistant's text response on stdout, plus a one-line summary (model, token counts) on stderr. JSON output: the full envelope including choices, usage, and any returned images. jsonl outputs the same object on one line; text writes the assistant text (or the saved image path) on stdout and a one-line summary on stderr.</output>

<output-example format="json">
{
  "choices": [
    {
      "finish_reason": "stop",
      "index": 0,
      "message": {
        "content": "The capital of France is Paris.",
        "role": "assistant"
      }
    }
  ],
  "created": 1735689600,
  "id": "gen-1735689600-abc123",
  "model": "meta-llama/llama-3.3-70b-instruct",
  "usage": {
    "completion_tokens": 9,
    "prompt_tokens": 12,
    "reasoning_tokens": 0,
    "total_tokens": 21
  }
}
</output-example>

<examples-good>
- clor inference openrouter text "draft a release note" --model meta-llama/llama-3.3-70b-instruct    # open-weights model not covered by the dedicated subcommands
- clor inference openrouter text "name a color" --model deepseek/deepseek-v3 --system "be terse"    # system prompt prepended as a role=system message
- clor inference openrouter text "describe this" --image-input photo.png --model x-ai/grok-4    # multimodal: attach a local image to the user message
- clor inference openrouter text "plan a refactor" --model x-ai/grok-4 --reasoning high --stdout-format json | jq '.choices[0].message.reasoning'    # reasoning trace surfaces in the JSON envelope when the model supports it
- clor inference openrouter text "explain a concept" --model deepseek/deepseek-r1 --reasoning-tokens 8000    # explicit token budget; takes precedence over --reasoning
- clor inference openrouter text "a watercolor cat" --model google/gemini-2.5-flash-image --image-output cat.png    # image generation: --image-output opts the request into image modality and saves the first returned image
- clor inference openrouter text "name a color" --model meta-llama/llama-3.3-70b-instruct --stdout-format json | jq '.usage'    # JSON envelope with prompt/completion/total token counts and per-call cost
</examples-good>

<examples-bad>
- clor inference openrouter text "hi"    # missing --model; OpenRouter has no implicit default
- clor inference openrouter text "hi" --model openai/gpt-5.5 --reasoning extreme    # --reasoning must be low, medium, or high
- clor inference openrouter text "hi" --model openai/gpt-5.5 --temperature 3    # --temperature must be between 0 and 2
- clor inference openrouter text --model openai/gpt-5.5    # no input: pass a positional prompt or --stdin-format text|json
- clor inference openrouter text "hi" --model anthropic/claude-opus-4-8    # use the dedicated subcommand instead (clor inference anthropic text); it exposes adaptive reasoning effort, exact token counting, and transparent pricing
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

