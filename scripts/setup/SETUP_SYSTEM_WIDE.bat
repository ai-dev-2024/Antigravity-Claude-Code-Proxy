@echo off
setlocal
echo ===================================================
echo   Claude Proxy - System Wide Setup
echo ===================================================

:: 1. Verify VBS launcher (re-create to ensure path is correct)
echo Creating launcher script...
echo Set WshShell = CreateObject("WScript.Shell") > start_proxy_hidden.vbs
echo WshShell.Run "cmd /c cd /d ""%CD%"" && npm start", 0 >> start_proxy_hidden.vbs
echo Set WshShell = Nothing >> start_proxy_hidden.vbs

:: 2. Add to Windows Startup
echo Adding to Windows Startup...
set "TARGET=%CD%\start_proxy_hidden.vbs"
set "SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\ClaudeProxy.lnk"

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT%');$s.TargetPath='%TARGET%';$s.WorkingDirectory='%CD%';$s.Description='Auto-start Claude Proxy';$s.Save()"

echo.
echo [SUCCESS] Claude Proxy has been added to Startup!
echo It will now start automatically when you log in.
echo.
echo ===================================================
echo [info] Model Switching Guide:
echo - To use Gemini 1.5 Pro:   Select 'Claude 3.5 Sonnet'
echo - To use Gemini 1.5 Flash: Select 'Claude 3 Haiku'
echo - To use Gemini 1.5 Pro+:  Select 'Claude 3 Opus'
echo ===================================================
echo.
echo Press any key to exit...
pause >nul
