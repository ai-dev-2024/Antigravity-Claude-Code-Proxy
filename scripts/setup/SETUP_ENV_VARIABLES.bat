@echo off
echo ========================================
echo Set up Environment Variables
echo ========================================
echo.
echo This script will set up the required environment variables
echo for the Antigravity Claude Proxy to work globally.
echo.
pause
echo.
echo Setting up ANTHROPIC_BASE_URL...
setx ANTHROPIC_BASE_URL "http://localhost:8080" /M
echo.
echo Setting up ANTHROPIC_API_KEY...
setx ANTHROPIC_API_KEY "test" /M
echo.
echo ========================================
echo Environment variables have been set!
echo ========================================
echo.
echo IMPORTANT: You need to RESTART your terminal/VSCode
echo for these environment variables to take effect.
echo.
echo Press any key to continue...
pause >nul