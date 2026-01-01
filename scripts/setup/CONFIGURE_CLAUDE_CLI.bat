@echo off
chcp 65001 >nul

echo ╔══════════════════════════════════════════════════════════════╗
echo ║  Configuring Claude Code CLI to use Antigravity Proxy        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Create .claude directory
mkdir "%USERPROFILE%\.claude" 2>nul

REM Create settings.json with the CORRECT configuration (from README)
echo { > "%USERPROFILE%\.claude\settings.json"
echo   "env": { >> "%USERPROFILE%\.claude\settings.json"

echo     "ANTHROPIC_BASE_URL": "http://localhost:8080", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_MODEL": "claude-opus-4-5-thinking", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-opus-4-5-thinking", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-4-5-thinking", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-sonnet-4-5", >> "%USERPROFILE%\.claude\settings.json"
echo     "CLAUDE_CODE_SUBAGENT_MODEL": "claude-sonnet-4-5-thinking" >> "%USERPROFILE%\.claude\settings.json"
echo   } >> "%USERPROFILE%\.claude\settings.json"
echo } >> "%USERPROFILE%\.claude\settings.json"

echo ✅ Claude Code CLI configured!
echo.
echo Settings file: %USERPROFILE%\.claude\settings.json
echo.
echo Content:
type "%USERPROFILE%\.claude\settings.json"
echo.
echo ⚠️  IMPORTANT: Restart Claude Code CLI (close and open new terminal)!
echo.
pause
