@echo off
echo Setting temporary environment variables for this session...
set ANTHROPIC_BASE_URL=http://localhost:8080
set ANTHROPIC_API_KEY=test
echo.
echo Environment variables set for this session:
echo ANTHROPIC_BASE_URL=%ANTHROPIC_BASE_URL%
echo ANTHROPIC_API_KEY=%ANTHROPIC_API_KEY%
echo.
echo Starting a new command prompt with these variables...
start cmd /k "set ANTHROPIC_BASE_URL=http://localhost:8080 && set ANTHROPIC_API_KEY=test && echo Environment variables loaded! && echo You can now run: claude"