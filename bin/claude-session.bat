@echo off
REM Claude Code with auto-session - per-folder model persistence
REM Sets session ID based on current directory

set "CLAUDE_SESSION_ID=%CD:\=_%"
set "CLAUDE_SESSION_ID=%CLAUDE_SESSION_ID::=_%"
set "ANTHROPIC_BASE_URL=http://localhost:8080"
claude %*
