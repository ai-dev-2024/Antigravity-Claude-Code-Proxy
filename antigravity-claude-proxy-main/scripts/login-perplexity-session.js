/**
 * Perplexity Session Login Script
 * Add Perplexity Pro accounts using session tokens from browser cookies
 * 
 * Usage: npm run login:perplexity:session
 */

import readline from 'readline';
import { PerplexitySessionAccountManager } from '../src/perplexity-session-account-manager.js';

const manager = new PerplexitySessionAccountManager();

console.log('═'.repeat(60));
console.log('   Perplexity Pro Session Account Setup');
console.log('═'.repeat(60));
console.log('\nThis uses your Perplexity Pro SUBSCRIPTION (not API credits).\n');

console.log('📋 How to get your session token:\n');
console.log('1. Login at https://www.perplexity.ai');
console.log('2. Open DevTools (F12) → Application → Cookies');
console.log('3. Find cookie named: __Secure-next-auth.session-token');
console.log('4. Copy the entire value (it\'s a long string)\n');

console.log('Enter your Perplexity accounts below.');
console.log('Type "done" when finished, or "list" to see accounts.\n');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

async function prompt(question) {
    return new Promise((resolve) => {
        rl.question(question, (answer) => {
            resolve(answer.trim());
        });
    });
}

async function main() {
    await manager.initialize();

    const existing = manager.getAccounts();
    if (existing.length > 0) {
        console.log(`📊 Existing accounts: ${existing.length}`);
        existing.forEach(acc => {
            console.log(`   - ${acc.email} (${acc.usageCount || 0} requests)`);
        });
        console.log('');
    }

    while (true) {
        const email = await prompt('Email (or "done"/"list"): ');

        if (email.toLowerCase() === 'done') {
            break;
        }

        if (email.toLowerCase() === 'list') {
            const accounts = manager.getAccounts();
            console.log(`\n📊 ${accounts.length} account(s):`);
            accounts.forEach(acc => {
                const status = acc.isRateLimited ? '⚠️ Limited' : '✓ Active';
                console.log(`   ${status} ${acc.email} (${acc.usageCount || 0} requests)`);
            });
            console.log('');
            continue;
        }

        if (!email.includes('@')) {
            console.log('⚠️  Please enter a valid email address.\n');
            continue;
        }

        const token = await prompt('Session Token: ');

        if (!token || token.length < 50) {
            console.log('⚠️  Invalid token. Session tokens are typically 200+ characters.\n');
            continue;
        }

        try {
            await manager.addAccount(email, token);
            console.log(`✅ Added/updated: ${email}\n`);
        } catch (error) {
            console.error(`❌ Error: ${error.message}\n`);
        }
    }

    const final = manager.getAccounts();
    console.log(`\n✅ Setup complete! ${final.length} Perplexity session account(s) configured.`);

    if (final.length > 0) {
        console.log('\n🔌 To use in Claude Code:');
        console.log('   /model perplexity-auto');
        console.log('   /model perplexity-research');
        console.log('   /model perplexity-sonar');
    }

    rl.close();
}

main().catch(err => {
    console.error('Error:', err);
    rl.close();
    process.exit(1);
});
