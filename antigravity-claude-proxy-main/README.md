# Antigravity Claude Proxy

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A proxy server that exposes an **Anthropic-compatible API** backed by **Antigravity's Cloud Code** and **Perplexity Pro**, letting you use Claude, Gemini, GPT, Grok, and more with **Claude Code CLI**.

## Features

- 🔄 **Multi-Provider Support**: Google AI (Antigravity) + Perplexity Pro models
- ⚖️ **Load Balancing**: Automatic rotation across multiple accounts
- 📊 **Dashboard**: Real-time usage monitoring at `http://localhost:8080/dashboard`
- 🚀 **Auto-Start**: Runs on Windows startup for instant availability
- 🌊 **Streaming**: Real-time response streaming for all models

## How It Works

```
┌──────────────────┐     ┌─────────────────────┐     ┌────────────────────────────┐
│   Claude Code    │────▶│  Antigravity Proxy  │────▶│  Google AI / Perplexity    │
│   (any terminal) │     │  (localhost:8080)   │     │  (multiple providers)      │
└──────────────────┘     └─────────────────────┘     └────────────────────────────┘
```

## Prerequisites

- **Node.js** 18+
- **Python** 3.10+ (for Perplexity models)
- **Antigravity** installed (for Google AI access)

---

## Quick Start

### 1. Clone and Install

```bash
git clone https://github.com/ai-dev-2024/Claude-Cli-GoogleAiPro.git
cd Claude-Cli-GoogleAiPro/antigravity-claude-proxy-main
npm install
```

### 2. Start the Proxy

```bash
npm start
```

The server runs on `http://localhost:8080`.

### 3. Configure Claude Code

Set environment variables (already done if using auto-start):

**Windows:**
```cmd
setx ANTHROPIC_BASE_URL "http://localhost:8080"
setx ANTHROPIC_API_KEY "antigravity-proxy"
```

**macOS/Linux:**
```bash
export ANTHROPIC_BASE_URL="http://localhost:8080"
export ANTHROPIC_API_KEY="antigravity-proxy"
```

### 4. Use Claude Code

From any terminal:
```bash
claude
```

---

## Available Models

### Google AI Models (via Antigravity)

| Model ID | Description |
|----------|-------------|
| `gemini-3-pro-high` | Gemini 3 Pro (recommended default) |
| `gemini-3-flash` | Gemini 3 Flash (fast responses) |
| `claude-opus-4-5-thinking` | Claude Opus 4.5 with extended thinking |
| `claude-sonnet-4-5-thinking` | Claude Sonnet 4.5 with extended thinking |
| `gemini-2.5-flash-thinking` | Gemini 2.5 with extended thinking |

### Perplexity Pro Models (web-augmented)

| Model ID | Description |
|----------|-------------|
| `pplx-claude-opus` | Claude Opus 4.5 via Perplexity |
| `pplx-gpt51` / `pplx-gpt52` | GPT-5 via Perplexity |
| `pplx-grok` | Grok 4.1 via Perplexity |
| `pplx-kimi` | Kimi K2 Thinking via Perplexity |
| `pplx-gemini-pro` | Gemini 3 Pro via Perplexity |

**Switch models:** `/model gemini-3-flash`

---

## Dashboard

Access at **http://localhost:8080/dashboard**

Features:
- 📊 **Overview**: All accounts at a glance
- ☁️ **Google Usage**: Per-model quota tracking
- 🔮 **Perplexity Usage**: Request counts and per-model stats
- 🩺 **Health Status**: Account availability monitoring
- ✏️ **Rename/Delete**: Manage accounts directly

---

## Auto-Start Setup

The proxy can auto-start on Windows login:

1. **Startup Script**: `start-proxy.bat` in project root
2. **Windows Shortcut**: Added to Startup folder
3. **Environment Variables**: Set system-wide

To manually start:
```batch
C:\path\to\start-proxy.bat
```

---

## Perplexity Integration

### Setup

1. Start the proxy
2. Go to Dashboard → Perplexity Usage → "+ Add Account"
3. Login to your Perplexity Pro account in the browser
4. Token is captured automatically

### Python Server

Perplexity requests are handled by a Python FastAPI server using `curl_cffi`:

```bash
cd perplexity-openai-api-ref
pip install -e .
python openai_server.py
```

The main proxy automatically forwards `pplx-*` model requests to this server.

---

## Multi-Account Load Balancing

When you add multiple accounts:
- **Automatic rotation**: Switches when rate-limited
- **Sticky sessions**: Maximizes prompt cache hits
- **Cooldown management**: Accounts recover automatically
- **Status tracking**: Dashboard shows real-time status

---

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/v1/messages` | POST | Anthropic Messages API |
| `/v1/models` | GET | List available models |
| `/dashboard` | GET | Web dashboard |
| `/account-limits` | GET | Account status |
| `/perplexity-sessions` | GET/POST/PATCH/DELETE | Manage Perplexity accounts |

---

## File Structure

```
antigravity-claude-proxy-main/
├── src/
│   ├── server.js              # Main Express server
│   ├── account-manager.js     # Google account handling
│   ├── perplexity-*.js        # Perplexity integration
│   └── public/
│       └── dashboard.html     # Web dashboard
├── start-proxy.bat            # Windows startup script
└── package.json

perplexity-openai-api-ref/
├── openai_server.py           # FastAPI Perplexity server
├── src/perplexity_webui_scraper/
└── .env                       # Perplexity session token
```

---

## Troubleshooting

### Proxy not starting
- Check if ports 8080 and 8000 are available
- Verify Node.js and Python are installed

### 403 errors from Perplexity
- Ensure Python server is running on port 8000
- Re-login via Dashboard if token expired

### Rate limiting
- Add more accounts for automatic rotation
- Check Dashboard for account status

---

## Safety Notice

- For personal/development use only
- Respect provider terms of service
- You assume all risks of use

---

## License

MIT

---

## Credits

Based on work from:
- [antigravity-claude-proxy](https://github.com/badri-s2001/antigravity-claude-proxy)
- [perplexity-openai-api-ref](https://github.com/artp1ay/perplexity-openai-api-ref)