@echo off
title Perplexity Account Setup
cd /d "%~dp0\antigravity-claude-proxy-main"
echo Starting Perplexity Account Setup...
call npm run login:perplexity
echo.
echo Setup complete.
pause
