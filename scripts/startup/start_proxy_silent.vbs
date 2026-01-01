' Start Antigravity Claude Proxy silently in background
' This script is designed to run at Windows startup

Set WshShell = CreateObject("WScript.Shell")
proxyPath = "C:\Users\Muhib\Desktop\Projects\Antigravity-Claude-Code-Proxy\Antigravity-Claude-Code-Proxy"

' Start the proxy server in a hidden window
WshShell.Run "cmd /c cd /d """ & proxyPath & """ && npm start", 0, False

' Optional: Show a notification (uncomment if desired)
' WshShell.Popup "Antigravity Proxy started!", 2, "Claude Proxy", 64
