const fs = require('fs');
const path = require('path');
const os = require('os');

const configPath = path.join(os.homedir(), '.config/antigravity-proxy/accounts.json');

try {
    const data = fs.readFileSync(configPath, 'utf8');
    const config = JSON.parse(data);

    if (config.accounts) {
        config.accounts.forEach(acc => {
            acc.isInvalid = false;
            acc.invalidReason = null;
            acc.isRateLimited = false;
            acc.rateLimitResetTime = null;
            // Clear projectId to force re-discovery
            acc.projectId = undefined;
        });
    }

    // Reset usage count if present (server logic adds it)

    fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
    console.log('Successfully reset accounts.json');
} catch (error) {
    console.error('Failed to reset accounts.json:', error);
}
