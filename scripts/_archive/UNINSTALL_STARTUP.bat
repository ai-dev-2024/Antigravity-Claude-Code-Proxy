@echo off
echo ====================================
echo  Remove Antigravity Proxy Startup
echo ====================================
echo.

set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

if exist "%STARTUP_FOLDER%\AntigravityProxy.vbs" (
    del "%STARTUP_FOLDER%\AntigravityProxy.vbs"
    echo Startup entry removed successfully.
) else (
    echo No startup entry found.
)

echo.
pause
