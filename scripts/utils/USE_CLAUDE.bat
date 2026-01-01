@echo off
chcp 65001 >nul

echo ╔══════════════════════════════════════════════════════════════╗
echo ║  Starting Claude Code with Proxy                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Set environment variables for this session
set ANTHROPIC_BASE_URL=http://localhost:8080
set ANTHROPIC_API_KEY=sk-antigravity

echo ✅ Environment variables set:
echo    ANTHROPIC_BASE_URL=%ANTHROPIC_BASE_URL%
echo    ANTHROPIC_API_KEY=%ANTHROPIC_API_KEY%
echo.

REM Run claude
echo Starting Claude CLI...
echo.
claude %*

echo.
pause
