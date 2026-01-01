@echo off
setlocal
echo Setting up Claude Proxy Auto-Start...

:: Create VBS Launcher (Hidden Window)
echo Set WshShell = CreateObject("WScript.Shell") > "%~dp0start_proxy_hidden.vbs"
echo WshShell.Run "cmd /c cd /d ""%~dp0"" && npm start", 0 >> "%~dp0start_proxy_hidden.vbs"
echo Set WshShell = Nothing >> "%~dp0start_proxy_hidden.vbs"

:: Create Startup Shortcut via PowerShell
set "TARGET=%~dp0start_proxy_hidden.vbs"
set "SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\ClaudeProxy.lnk"

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT%');$s.TargetPath='%TARGET%';$s.WorkingDirectory='%~dp0';$s.Description='Claude Proxy Auto-Start';$s.Save()"

echo Done! The proxy will now start automatically when you log in.
pause
