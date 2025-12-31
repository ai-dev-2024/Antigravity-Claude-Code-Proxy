# Antigravity Model Sync

Real-time model synchronization between Antigravity Proxy dashboard and Claude Code extension.

## Features

- **Status Bar Indicator**: Shows current model with emoji (⚡ Flash, 💎 Pro, 🎭 Opus, etc.)
- **Real-Time Sync**: Watches `settings.json` for changes
- **Proxy Polling**: Polls `/active-model` every 5 seconds as backup
- **Notifications**: Shows toast when model changes

## How It Works

```
Dashboard changes model
    ↓
Proxy updates settings.json
    ↓
Extension detects file change
    ↓
Status bar updates + notification shows
```

## Installation

### From VSIX (Recommended)
```bash
code --install-extension antigravity-model-sync-1.0.0.vsix
```

### From Source
```bash
cd antigravity-model-sync
npm install
npx vsce package
code --install-extension antigravity-model-sync-1.0.0.vsix
```

## Commands

| Command | Description |
|---------|-------------|
| `Antigravity: Show Current Model` | Display current model in notification |
| `Antigravity: Refresh Model from Proxy` | Force refresh from proxy |

## Status Bar Icons

| Icon | Model |
|------|-------|
| ⚡ Flash | gemini-3-flash |
| 💎 Pro | gemini-3-pro-high |
| 🎭 Opus | claude-opus-* |
| 🎵 Sonnet | claude-sonnet-* |
| 📝 Haiku | claude-haiku-* |
| 🌐 Grok | pplx-grok |
| 🔍 Perplexity | pplx-* |

## Requirements

- Antigravity Proxy running on `localhost:8080`
- Claude Code extension installed
