# Antigravity Claude Proxy - PowerShell Profile Addition
# Add this to your PowerShell profile to auto-start proxy and set environment variables

# Set environment variables for Claude Code
$env:ANTHROPIC_BASE_URL = "http://localhost:8080"
$env:ANTHROPIC_API_KEY = "antigravity-proxy"

# Function to start the proxy if not running
function Start-AntigravityProxy {
    $proxyRunning = Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue
    $pythonRunning = Get-NetTCPConnection -LocalPort 8000 -State Listen -ErrorAction SilentlyContinue
    
    if (-not $proxyRunning) {
        Write-Host "Starting Antigravity proxy..." -ForegroundColor Cyan
        Start-Process -WindowStyle Minimized -FilePath "cmd" -ArgumentList "/c cd /d C:\Users\Muhib\Desktop\Projects\Antigravity-Claude-Code-Proxy\Antigravity-Claude-Code-Proxy && npm start"
        Start-Sleep -Seconds 2
    }
    
    if (-not $pythonRunning) {
        Write-Host "Starting Perplexity server..." -ForegroundColor Magenta
        Start-Process -WindowStyle Minimized -FilePath "cmd" -ArgumentList "/c cd /d C:\Users\Muhib\Desktop\Projects\Antigravity-Claude-Code-Proxy\perplexity-openai-api-ref && python openai_server.py"
        Start-Sleep -Seconds 2
    }
    
    Write-Host "Antigravity Claude Proxy ready! Use 'claude' to start." -ForegroundColor Green
}

# Alias for quick proxy start
Set-Alias -Name startproxy -Value Start-AntigravityProxy

# Auto-start proxy on PowerShell launch (optional - comment out if not wanted)
# Start-AntigravityProxy
