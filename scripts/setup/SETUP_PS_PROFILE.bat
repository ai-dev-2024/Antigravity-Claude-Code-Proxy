@echo off
chcp 65001 >nul

echo ╔══════════════════════════════════════════════════════════════╗
echo ║  Setting up PowerShell Profile for Claude Proxy              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Create PowerShell profile directory if not exists
mkdir "%USERPROFILE%\Documents\PowerShell" 2>nul

REM Create the profile file
echo # Claude Proxy Configuration > "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
echo. >> "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
echo # Environment variables for Antigravity Proxy >> "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
echo $env:ANTHROPIC_BASE_URL = "http://localhost:8080" >> "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
echo $env:ANTHROPIC_API_KEY = "sk-antigravity" >> "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
echo. >> "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
echo Write-Host "✅ Claude Proxy configured - Using 4 Google accounts" -ForegroundColor Green >> "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

echo ✅ PowerShell profile created at:
echo    %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
echo.
echo ⚠️  IMPORTANT: Restart PowerShell or Windows Terminal to apply changes!
echo.
echo After restarting PowerShell, simply run:
echo    claude "your request"
echo.
pause
