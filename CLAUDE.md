# Antigravity Claude Proxy - Available Models

This project uses the Antigravity Claude Proxy which provides access to multiple AI models through a local proxy server.

## Available Models

You can switch to any of these models using `/model <model-name>`:

### Gemini 3 Models (Google AI)
- `gemini-3-pro-high` - Gemini 3 Pro (High quota) [Default]
- `gemini-3-pro-low` - Gemini 3 Pro (Low quota)
- `gemini-3-flash` - Gemini 3 Flash (fast responses)
- `gemini-3-pro-image` - Gemini 3 Pro Image generation

### Gemini 2.5 Models (Google AI)
- `gemini-2.5-pro` - Gemini 2.5 Pro
- `gemini-2.5-flash` - Gemini 2.5 Flash
- `gemini-2.5-flash-thinking` - Gemini 2.5 Flash with extended thinking
- `gemini-2.5-flash-lite` - Gemini 2.5 Flash Lite (lightweight)

### Claude Models (Google AI)
- `claude-opus-4-5-thinking` - Claude Opus 4.5 with extended thinking
- `claude-sonnet-4-5-thinking` - Claude Sonnet 4.5 with extended thinking
- `claude-sonnet-4-5` - Claude Sonnet 4.5

### Other Google AI Models
- `gpt-oss-120b-medium` - GPT-OSS 120B

### Perplexity Pro Models (requires Perplexity Pro subscription)
- `perplexity-auto` - Perplexity Auto (best for most queries)
- `perplexity-sonar` - Perplexity Sonar (fast responses)
- `perplexity-research` - Perplexity Research (deep analysis)
- `perplexity-labs` - Perplexity Labs (experimental)
- `pplx-gpt51` - GPT-5.1 via Perplexity
- `pplx-gpt52` - GPT-5.2 via Perplexity
- `pplx-claude-sonnet` - Claude 4.5 Sonnet via Perplexity
- `pplx-claude-opus` - Claude Opus 4.5 via Perplexity
- `pplx-gemini-pro` - Gemini 3 Pro via Perplexity
- `pplx-gemini-flash` - Gemini 3 Flash via Perplexity
- `pplx-grok` - Grok 4.1 via Perplexity
- `pplx-kimi` - Kimi K2 Thinking via Perplexity

## How to Switch Models

Use the `/model` command followed by the model name:
```
/model gemini-3-pro-high
/model pplx-claude-opus
/model perplexity-auto
```

## Current Default Model

The default model is configured as `gemini-3-pro-high` in `~/.claude/settings.json`.

## Dashboard

Manage accounts and view quotas at: http://localhost:8080/dashboard

