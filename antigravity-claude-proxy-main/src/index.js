/**
 * Antigravity Claude Proxy
 * Entry point - starts the proxy server
 */

import app from './server.js';
import { DEFAULT_PORT } from './constants.js';

const PORT = process.env.PORT || DEFAULT_PORT;

app.listen(PORT, () => {
    console.log(`
╔══════════════════════════════════════════════════════════════╗
║           Antigravity Claude Proxy Server                    ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Server running at: http://localhost:${PORT}                   ║
║                                                              ║
║  Endpoints:                                                  ║
║    POST /v1/messages  - Anthropic Messages API               ║
║    GET  /v1/models    - List available models                ║
║    GET  /health       - Health check                         ║
║    GET  /account-limits - Account status & quotas              ║
║    POST /refresh-token - Force token refresh                 ║
║                                                              ║
║  Usage with Claude Code:                                     ║
║    export ANTHROPIC_BASE_URL=http://localhost:${PORT}          ║
║    export ANTHROPIC_API_KEY=dummy                            ║
║    claude                                                    ║
║                                                              ║
║  Add Google accounts:                                        ║
║    npm run accounts                                          ║
║                                                              ║
║  Prerequisites (if no accounts configured):                  ║
║    - Antigravity must be running                             ║
║    - Have a chat panel open in Antigravity                   ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
  `);
});
