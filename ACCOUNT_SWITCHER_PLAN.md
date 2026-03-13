# Antigravity Account Switcher Implementation Plan

## Goal
Add functional account switching to the existing extension (`claude-proxy-ext-src`) that allows:
1. Detecting and displaying the current Antigravity Google account
2. Storing multiple Google account sessions
3. One-click switching between stored accounts
4. Displaying quotas for each account (from proxy)

---

## Phase 1: Investigate Antigravity's Auth Storage

### Commands to Run
```powershell
# Find where Antigravity stores auth data
Get-ChildItem "$env:APPDATA\Antigravity\User" -Recurse -Include "*.db","state.vscdb" 2>$null

# Check globalStorage for auth-related folders
Get-ChildItem "$env:APPDATA\Antigravity\User\globalStorage" -Directory 2>$null

# Look for secretStorage
Get-ChildItem "$env:APPDATA\Antigravity" -Recurse -Filter "*secret*" 2>$null
```

### Expected Findings
Antigravity likely stores auth in one of:
- `%APPDATA%\Antigravity\User\globalStorage\<extension-id>\` (JSON files)
- `%APPDATA%\Antigravity\User\state.vscdb` (SQLite database)
- Windows Credential Manager (secure storage)

---

## Phase 2: File Structure

Modify/add files in `claude-proxy-ext-src/`:

```
claude-proxy-ext-src/
├── extension.js           # UPDATE: Integrate account switcher
├── account-manager.js     # NEW: Store/retrieve accounts from extension storage
├── antigravity-auth.js    # NEW: Read/write Antigravity's internal auth (if possible)
├── package.json           # UPDATE: Maybe add permissions
```

---

## Phase 3: Implementation

### 3.1 Create `account-manager.js`

```javascript
// account-manager.js
// Manages stored accounts in extension's globalState

const vscode = require('vscode');

let context = null;

function initialize(extensionContext) {
    context = extensionContext;
}

function getStoredAccounts() {
    return context.globalState.get('antigravityAccounts', []);
}

async function saveAccount(account) {
    const accounts = getStoredAccounts();
    
    // Check if already exists
    const existingIndex = accounts.findIndex(a => a.email === account.email);
    if (existingIndex >= 0) {
        accounts[existingIndex] = account;
    } else {
        accounts.push(account);
    }
    
    await context.globalState.update('antigravityAccounts', accounts);
    return accounts;
}

async function removeAccount(email) {
    const accounts = getStoredAccounts();
    const filtered = accounts.filter(a => a.email !== email);
    await context.globalState.update('antigravityAccounts', filtered);
    return filtered;
}

function getActiveAccountEmail() {
    return context.globalState.get('activeAntigravityAccount', null);
}

async function setActiveAccount(email) {
    await context.globalState.update('activeAntigravityAccount', email);
}

module.exports = {
    initialize,
    getStoredAccounts,
    saveAccount,
    removeAccount,
    getActiveAccountEmail,
    setActiveAccount
};
```

### 3.2 Create `antigravity-auth.js`

```javascript
// antigravity-auth.js
// Read/write Antigravity's internal auth storage

const fs = require('fs');
const path = require('path');
const os = require('os');
const sqlite3 = require('sqlite3'); // May need to add as dependency

// Path to Antigravity's state database (needs investigation)
const ANTIGRAVITY_DATA_PATH = path.join(
    os.homedir(),
    'AppData', 'Roaming', 'Antigravity'
);

const STATE_DB_PATH = path.join(ANTIGRAVITY_DATA_PATH, 'User', 'state.vscdb');

// Read current auth from Antigravity's storage
async function readCurrentAuth() {
    // Option 1: Try reading from state.vscdb (SQLite)
    try {
        return await readFromStateDb();
    } catch (e) {
        console.log('Could not read from state.vscdb:', e.message);
    }
    
    // Option 2: Try reading from globalStorage JSON files
    try {
        return await readFromGlobalStorage();
    } catch (e) {
        console.log('Could not read from globalStorage:', e.message);
    }
    
    return null;
}

async function readFromStateDb() {
    return new Promise((resolve, reject) => {
        const db = new sqlite3.Database(STATE_DB_PATH, sqlite3.OPEN_READONLY);
        
        // Look for auth-related keys
        db.all("SELECT key, value FROM ItemTable WHERE key LIKE '%google%' OR key LIKE '%auth%' OR key LIKE '%token%'", (err, rows) => {
            db.close();
            if (err) reject(err);
            else resolve(rows);
        });
    });
}

async function readFromGlobalStorage() {
    const globalStoragePath = path.join(ANTIGRAVITY_DATA_PATH, 'User', 'globalStorage');
    const dirs = fs.readdirSync(globalStoragePath);
    
    // Look for auth-related extension storage
    for (const dir of dirs) {
        if (dir.includes('google') || dir.includes('auth')) {
            const files = fs.readdirSync(path.join(globalStoragePath, dir));
            for (const file of files) {
                if (file.endsWith('.json')) {
                    const content = fs.readFileSync(path.join(globalStoragePath, dir, file), 'utf8');
                    return JSON.parse(content);
                }
            }
        }
    }
    
    return null;
}

// Write auth to Antigravity's storage (for account switching)
async function writeAuth(authData) {
    // This is the critical part - needs investigation
    // Option 1: Write to state.vscdb
    // Option 2: Write to globalStorage
    // Option 3: Use VS Code's secretStorage (if Antigravity uses it)
    
    throw new Error('writeAuth not implemented - needs Antigravity auth format investigation');
}

module.exports = {
    readCurrentAuth,
    writeAuth,
    ANTIGRAVITY_DATA_PATH,
    STATE_DB_PATH
};
```

### 3.3 Update `extension.js`

Add to the existing extension:

```javascript
// At top of extension.js, add:
const accountManager = require('./account-manager');
const http = require('http');

// Add new state variables:
let storedAccounts = [];
let activeAccountEmail = null;
let accountQuotas = {};

// In activate(), add:
accountManager.initialize(context);
storedAccounts = accountManager.getStoredAccounts();
activeAccountEmail = accountManager.getActiveAccountEmail();

// Fetch initial quotas
refreshAccountQuotas();

// Register new commands:
context.subscriptions.push(
    vscode.commands.registerCommand('antigravity.saveCurrentAccount', saveCurrentAccountCommand),
    vscode.commands.registerCommand('antigravity.pickAccount', showAccountPickerCommand),
    vscode.commands.registerCommand('antigravity.removeAccount', removeAccountCommand)
);

// ==================== NEW COMMAND IMPLEMENTATIONS ====================

async function saveCurrentAccountCommand() {
    // For now, prompt user to enter account details
    // Later: auto-detect from Antigravity's auth storage
    
    const email = await vscode.window.showInputBox({
        prompt: 'Enter the Google account email',
        placeHolder: 'your.email@gmail.com'
    });
    
    if (!email) return;
    
    const account = {
        email: email,
        addedAt: Date.now()
        // accessToken and refreshToken would need to be captured from Antigravity
    };
    
    storedAccounts = await accountManager.saveAccount(account);
    updateAccountTooltip();
    
    vscode.window.showInformationMessage(`Account ${email} saved!`);
}

async function showAccountPickerCommand() {
    const items = [];
    
    // Add stored accounts
    for (const acc of storedAccounts) {
        const quota = accountQuotas[acc.email];
        const quotaText = quota ? ` (${quota.claudeRemaining || '?'}% Claude)` : '';
        
        items.push({
            label: `🔵 ${acc.email}${quotaText}`,
            description: acc.email === activeAccountEmail ? '✓ Active' : '',
            email: acc.email
        });
    }
    
    // Separator
    if (items.length > 0) {
        items.push({ label: '', kind: vscode.QuickPickItemKind.Separator });
    }
    
    // Actions
    items.push({
        label: '$(add) Add Current Account',
        description: 'Save the currently signed-in account',
        action: 'add'
    });
    
    items.push({
        label: '$(trash) Remove Account...',
        description: 'Remove a saved account',
        action: 'remove'
    });
    
    items.push({
        label: '$(refresh) Refresh Quotas',
        description: 'Update quota information from proxy',
        action: 'refresh'
    });
    
    const selected = await vscode.window.showQuickPick(items, {
        placeHolder: 'Select account or action',
        title: 'Antigravity Accounts'
    });
    
    if (!selected) return;
    
    if (selected.action === 'add') {
        await saveCurrentAccountCommand();
    } else if (selected.action === 'remove') {
        await removeAccountCommand();
    } else if (selected.action === 'refresh') {
        await refreshAccountQuotas();
        vscode.window.showInformationMessage('Quotas refreshed!');
    } else if (selected.email) {
        await switchToAccount(selected.email);
    }
}

async function removeAccountCommand() {
    const items = storedAccounts.map(acc => ({
        label: `🔵 ${acc.email}`,
        email: acc.email
    }));
    
    const selected = await vscode.window.showQuickPick(items, {
        placeHolder: 'Select account to remove'
    });
    
    if (selected) {
        storedAccounts = await accountManager.removeAccount(selected.email);
        updateAccountTooltip();
        vscode.window.showInformationMessage(`Account ${selected.email} removed`);
    }
}

async function switchToAccount(email) {
    // This is where the magic happens
    // For now: just open the sign-in flow with a hint
    // Later: actually switch the auth token
    
    vscode.window.showInformationMessage(
        `To switch to ${email}: Sign out (profile icon top-right) then sign in with ${email}`,
        'Open Sign Out'
    ).then(action => {
        if (action === 'Open Sign Out') {
            vscode.commands.executeCommand('workbench.action.accounts');
        }
    });
    
    // Mark as intended active (will be confirmed after sign-in)
    await accountManager.setActiveAccount(email);
    activeAccountEmail = email;
    updateAccountTooltip();
}

// ==================== QUOTA FETCHING ====================

async function refreshAccountQuotas() {
    try {
        const response = await fetchFromProxy('/limits');
        if (response && response.accounts) {
            for (const acc of response.accounts) {
                accountQuotas[acc.email] = calculateQuotaSummary(acc.limits);
            }
        }
        updateAccountTooltip();
    } catch (e) {
        console.log('Could not fetch quotas:', e.message);
    }
}

function calculateQuotaSummary(limits) {
    if (!limits) return null;
    
    let claudeTotal = 0;
    let claudeCount = 0;
    
    for (const [model, info] of Object.entries(limits)) {
        if (model.includes('claude')) {
            const remaining = info.remainingFraction !== undefined ? 
                Math.round(info.remainingFraction * 100) : 50;
            claudeTotal += remaining;
            claudeCount++;
        }
    }
    
    return {
        claudeRemaining: claudeCount > 0 ? Math.round(claudeTotal / claudeCount) : null
    };
}

function fetchFromProxy(endpoint) {
    return new Promise((resolve, reject) => {
        const req = http.request({
            hostname: 'localhost',
            port: 8080,
            path: endpoint,
            method: 'GET',
            timeout: 5000
        }, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
                try {
                    resolve(JSON.parse(data));
                } catch (e) {
                    reject(e);
                }
            });
        });
        req.on('error', reject);
        req.end();
    });
}

// ==================== TOOLTIP UPDATE ====================

function updateAccountTooltip() {
    if (!accountStatusBarItem) return;
    accountStatusBarItem.tooltip = createAccountTooltip();
}

// UPDATE the createAccountTooltip function:
function createAccountTooltip() {
    const md = new vscode.MarkdownString();
    md.isTrusted = true;
    md.supportThemeIcons = true;

    md.appendMarkdown(`### $(account) Antigravity Accounts\n\n`);

    if (storedAccounts.length === 0) {
        md.appendMarkdown(`*No accounts saved*\n\n`);
        md.appendMarkdown(`[$(add) Save Current Account](command:antigravity.saveCurrentAccount)\n\n`);
    } else {
        for (const acc of storedAccounts) {
            const isActive = acc.email === activeAccountEmail;
            const icon = isActive ? '$(check)' : '$(circle-outline)';
            const quota = accountQuotas[acc.email];
            const quotaText = quota?.claudeRemaining !== null ? 
                ` • Claude: ${quota.claudeRemaining}%` : '';
            
            md.appendMarkdown(`${icon} **${acc.email}**${quotaText}\n\n`);
        }
        md.appendMarkdown(`\n`);
    }

    md.appendMarkdown(`---\n\n`);
    md.appendMarkdown(`[$(list-selection) Switch](command:antigravity.pickAccount) · `);
    md.appendMarkdown(`[$(add) Add](command:antigravity.saveCurrentAccount) · `);
    md.appendMarkdown(`[$(server) Dashboard](command:antigravity.openDashboard)`);
    
    return md;
}
```

### 3.4 Update `package.json`

Add new commands:

```json
{
    "contributes": {
        "commands": [
            {
                "command": "antigravity.openDashboard",
                "title": "Antigravity: Open Dashboard"
            },
            {
                "command": "antigravity.switchModel",
                "title": "Antigravity: Switch Model"
            },
            {
                "command": "antigravity.switchIDEAccount",
                "title": "Antigravity: Switch IDE Account"
            },
            {
                "command": "antigravity.saveCurrentAccount",
                "title": "Antigravity: Save Current Account"
            },
            {
                "command": "antigravity.pickAccount",
                "title": "Antigravity: Switch Account"
            },
            {
                "command": "antigravity.removeAccount",
                "title": "Antigravity: Remove Saved Account"
            }
        ]
    }
}
```

---

## Phase 4: Future Enhancement - True Account Switching

Once the basic storage/display works, investigate proper token switching:

1. **Find Antigravity's auth storage format** (state.vscdb or globalStorage)
2. **Capture OAuth tokens** when user signs in
3. **Write tokens** to Antigravity's storage when switching
4. **Trigger reload** to pick up new auth

This may require:
- Adding `sqlite3` as a dependency
- Reverse-engineering Antigravity's token format
- Possibly using VS Code's `SecretStorage` API

---

## Testing

After implementation:

1. Package extension: `npx @vscode/vsce package --out ../claude-proxy-extension.vsix`
2. Install: `antigravity --install-extension ../claude-proxy-extension.vsix --force`
3. Reload Antigravity window
4. Test tooltip hover and click actions

---

## Key Files Reference

- Extension source: `c:\Users\Muhib\Desktop\Projects\Antigravity-Claude-Code-Proxy\claude-proxy-ext-src\`
- Current extension.js: Contains model switcher and basic account tooltip
- Proxy limits endpoint: `http://localhost:8080/limits`
