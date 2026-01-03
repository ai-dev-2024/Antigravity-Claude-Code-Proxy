Set WshShell = CreateObject("WScript.Shell")

' Start Node.js proxy hidden
WshShell.Run "cmd /c cd /d C:\Users\Muhib\Desktop\Projects\Antigravity-Claude-Code-Proxy\Antigravity-Claude-Code-Proxy && npm start", 0, False

' Wait a moment for first server to start
WScript.Sleep 3000

' Start Python Perplexity server hidden
WshShell.Run "cmd /c cd /d C:\Users\Muhib\Desktop\Projects\Antigravity-Claude-Code-Proxy\perplexity-openai-api-ref && python openai_server.py", 0, False
