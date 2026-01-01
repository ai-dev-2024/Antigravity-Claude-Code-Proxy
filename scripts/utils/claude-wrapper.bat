@echo off
:: Antigravity Claude Proxy - Auto-start wrapper for CMD
:: This script checks if proxy is running and starts it if needed

:: Check if proxy is running on port 8080
netstat -an | findstr ":8080.*LISTENING" >nul 2>&1
if %errorlevel% neq 0 (
    echo Starting Antigravity Proxy...
    start /b wscript "C:\Users\Muhib\Desktop\Projects\Antigravity-Claude-Code-Proxy\start-proxy-hidden.vbs"
    timeout /t 4 /nobreak >nul
    echo Proxy ready!
)

:: Run the real claude.exe with all arguments
claude.exe %*
