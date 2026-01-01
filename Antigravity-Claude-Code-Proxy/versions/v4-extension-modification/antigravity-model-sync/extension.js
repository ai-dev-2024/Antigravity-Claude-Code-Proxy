const vscode = require('vscode');
const fs = require('fs');
const path = require('path');
const http = require('http');

let statusBarItem;
let fileWatcher;
let currentModel = 'unknown';

// Paths to settings files
const ANTIGRAVITY_SETTINGS = path.join(process.env.APPDATA || '', 'Antigravity', 'User', 'settings.json');

function activate(context) {
    console.log('[Antigravity Model Sync] Extension activated');

    // Create status bar item
    statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, 100);
    statusBarItem.command = 'antigravity.showCurrentModel';
    statusBarItem.tooltip = 'Click to show current Antigravity model';
    context.subscriptions.push(statusBarItem);

    // Register commands
    context.subscriptions.push(
        vscode.commands.registerCommand('antigravity.showCurrentModel', showCurrentModel),
        vscode.commands.registerCommand('antigravity.refreshModel', refreshModelFromProxy)
    );

    // Initial model fetch
    refreshModelFromProxy();

    // Watch settings.json for changes
    setupFileWatcher(context);

    // Poll proxy every 5 seconds as backup
    const pollInterval = setInterval(() => {
        refreshModelFromProxy(true); // silent mode
    }, 5000);

    context.subscriptions.push({
        dispose: () => clearInterval(pollInterval)
    });
}

function setupFileWatcher(context) {
    try {
        if (fs.existsSync(ANTIGRAVITY_SETTINGS)) {
            const watcher = fs.watch(ANTIGRAVITY_SETTINGS, (eventType, filename) => {
                if (eventType === 'change') {
                    console.log('[Antigravity Model Sync] Settings file changed');
                    readModelFromSettings();
                }
            });

            context.subscriptions.push({
                dispose: () => watcher.close()
            });

            console.log('[Antigravity Model Sync] Watching settings.json');
        }
    } catch (err) {
        console.log('[Antigravity Model Sync] Could not watch settings:', err.message);
    }
}

function readModelFromSettings() {
    try {
        if (fs.existsSync(ANTIGRAVITY_SETTINGS)) {
            const content = fs.readFileSync(ANTIGRAVITY_SETTINGS, 'utf-8');
            const match = content.match(/"claudeCode\.selectedModel"\s*:\s*"([^"]*)"/);
            if (match && match[1]) {
                const newModel = match[1];
                if (newModel !== currentModel) {
                    const oldModel = currentModel;
                    currentModel = newModel;
                    updateStatusBar();

                    // Show notification for model change
                    if (oldModel !== 'unknown') {
                        vscode.window.showInformationMessage(
                            `🧠 Antigravity Model: ${oldModel} → ${newModel}`,
                            'OK'
                        );
                    }
                }
            }
        }
    } catch (err) {
        console.log('[Antigravity Model Sync] Error reading settings:', err.message);
    }
}

function refreshModelFromProxy(silent = false) {
    const options = {
        hostname: 'localhost',
        port: 8080,
        path: '/active-model',
        method: 'GET',
        timeout: 2000
    };

    const req = http.request(options, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
            try {
                const json = JSON.parse(data);
                if (json.model && json.model !== currentModel) {
                    const oldModel = currentModel;
                    currentModel = json.model;
                    updateStatusBar();

                    if (!silent && oldModel !== 'unknown') {
                        vscode.window.showInformationMessage(
                            `🧠 Antigravity Model: ${json.model}`,
                            'OK'
                        );
                    }
                }
            } catch (e) { }
        });
    });

    req.on('error', () => {
        // Proxy not running - try settings file
        readModelFromSettings();
    });

    req.on('timeout', () => req.destroy());
    req.end();
}

function updateStatusBar() {
    // Shorten model name for display
    let displayName = currentModel;
    if (currentModel.includes('gemini-3-flash')) displayName = '⚡ Flash';
    else if (currentModel.includes('gemini-3-pro')) displayName = '💎 Pro';
    else if (currentModel.includes('opus')) displayName = '🎭 Opus';
    else if (currentModel.includes('sonnet')) displayName = '🎵 Sonnet';
    else if (currentModel.includes('haiku')) displayName = '📝 Haiku';
    else if (currentModel.includes('grok')) displayName = '🌐 Grok';
    else if (currentModel.includes('pplx')) displayName = '🔍 Perplexity';

    statusBarItem.text = `$(sparkle) ${displayName}`;
    statusBarItem.show();
}

function showCurrentModel() {
    vscode.window.showInformationMessage(
        `🧠 Current Antigravity Model: ${currentModel}`,
        'Refresh'
    ).then(selection => {
        if (selection === 'Refresh') {
            refreshModelFromProxy();
        }
    });
}

function deactivate() {
    if (statusBarItem) statusBarItem.dispose();
}

module.exports = { activate, deactivate };
