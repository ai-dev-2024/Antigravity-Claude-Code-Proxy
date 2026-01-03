@echo off
echo ====================================
echo  Install Antigravity Proxy Startup
echo ====================================
echo.

set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set VBS_FILE=%~dp0start_proxy_silent.vbs

echo Creating shortcut in Windows Startup folder...
echo.

:: Copy the VBS file to startup folder
copy /Y "%VBS_FILE%" "%STARTUP_FOLDER%\AntigravityProxy.vbs"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo  SUCCESS! Proxy will auto-start on boot
    echo ========================================
    echo.
    echo Location: %STARTUP_FOLDER%\AntigravityProxy.vbs
    echo.
    echo The Antigravity Claude Proxy will now start automatically
    echo when Windows starts. Claude Code CLI will work system-wide!
    echo.
) else (
    echo.
    echo ERROR: Failed to create startup entry.
    echo Please run this script as Administrator.
    echo.
)

pause
