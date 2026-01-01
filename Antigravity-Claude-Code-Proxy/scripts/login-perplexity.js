import { createInterface } from 'readline';
import { PerplexityAccountManager } from '../src/perplexity-account-manager.js';

const rl = createInterface({
    input: process.stdin,
    output: process.stdout
});

const manager = new PerplexityAccountManager();

console.log('\n==========================================');
console.log('   Perplexity Pro Account Setup');
console.log('==========================================');
console.log('Enter your Perplexity API Keys (starting with pplx-).');
console.log('You can add multiple keys for load balancing.');
console.log('Press ENTER (empty) to finish.\n');

async function ask() {
    // Ensure initialized
    await manager.initialize();

    rl.question('Paste API Key > ', async (key) => {
        key = key.trim();
        if (!key) {
            console.log('\nSetup complete.');
            console.log(`Total active accounts: ${manager.getAccounts().length}`);
            rl.close();
            process.exit(0);
        }

        try {
            await manager.addAccount(key);
            // Current count
            const count = manager.getAccounts().length;
            console.log(`✅ Account added! (Total: ${count})`);
        } catch (e) {
            console.error(`❌ Error: ${e.message}`);
        }

        console.log(''); // Newline
        ask();
    });
}

// Handle errors
process.on('uncaughtException', (err) => {
    console.error('Unexpected error:', err);
    process.exit(1);
});

ask();
