@echo off
chcp 65001 >nul

echo ╔══════════════════════════════════════════════════════════════╗
echo ║  Running Claude Code with Antigravity Proxy                  ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Set environment variables
set ANTHROPIC_BASE_URL=http://localhost:8080
set ANTHROPIC_API_KEY=sk-antigravity

echo ✅ Using Proxy at: http://localhost:8080
echo ✅ Using 4 Google accounts for quota
echo.
echo Running: claude %*
echo.

REM Run claude with the proxy settings
claude %*

echo.
pause
