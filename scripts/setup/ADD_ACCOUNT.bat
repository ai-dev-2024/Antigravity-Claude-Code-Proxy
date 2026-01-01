@echo off
echo Adding Google AI Account...
echo This will open your browser for OAuth authentication.
echo.
cd /d "%~dp0antigravity-claude-proxy-main"
npm run accounts:add
pause