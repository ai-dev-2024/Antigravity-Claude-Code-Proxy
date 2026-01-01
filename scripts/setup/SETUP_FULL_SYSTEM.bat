@echo off
setlocal
echo ===================================================
echo   Claude Proxy - Complete System Setup
echo ===================================================

:: 1. Configure Claude Code CLI (Global Settings)
echo [1/2] Configuring Claude CLI...
if not exist "%USERPROFILE%\.claude" mkdir "%USERPROFILE%\.claude"
echo { > "%USERPROFILE%\.claude\settings.json"
echo   "env": { >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_AUTH_TOKEN": "test-token-for-proxy", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_BASE_URL": "http://localhost:8080", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_MODEL": "claude-3-5-sonnet-20240620", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-3-opus-20240229", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-3-5-sonnet-20240620", >> "%USERPROFILE%\.claude\settings.json"
echo     "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-3-haiku-20240307", >> "%USERPROFILE%\.claude\settings.json"
echo     "CLAUDE_CODE_SUBAGENT_MODEL": "claude-3-5-sonnet-20240620" >> "%USERPROFILE%\.claude\settings.json"
echo   } >> "%USERPROFILE%\.claude\settings.json"
echo } >> "%USERPROFILE%\.claude\settings.json"
echo    - Settings written to %USERPROFILE%\.claude\settings.json

:: 2. Setup Auto-Start
echo [2/2] Enabling Auto-Start...
echo Set WshShell = CreateObject("WScript.Shell") > start_proxy_hidden.vbs
echo WshShell.Run "cmd /c cd /d ""%CD%"" && npm start", 0 >> start_proxy_hidden.vbs
echo Set WshShell = Nothing >> start_proxy_hidden.vbs

set "TARGET=%CD%\start_proxy_hidden.vbs"
set "SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\ClaudeProxy.lnk"

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT%');$s.TargetPath='%TARGET%';$s.WorkingDirectory='%CD%';$s.Description='Auto-start Claude Proxy';$s.Save()"
echo    - Added to Startup folder.

echo.
echo [SUCCESS] Setup Complete!
echo ---------------------------------------------------
echo 1. The Proxy will start automatically when you log in.
echo 2. 'claude' command will now use the Proxy in ANY terminal.
echo 3. To switch models (mapped to Gemini):
echo    - Use 'Claude 3.5 Sonnet' -> Gets Gemini 1.5 Pro
echo    - Use 'Claude 3 Haiku'  -> Gets Gemini 1.5 Flash
echo ---------------------------------------------------
echo.
echo Press any key to exit...
pause >nul
