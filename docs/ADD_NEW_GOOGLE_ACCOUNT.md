# How to Add Multiple Google Accounts

## 🚀 Current Status

✅ **1 Account Active**: `muhib.al.karim@gmail.com`  
✅ **Proxy Server**: Must be stopped to add accounts  
✅ **Ready to Add**: More accounts  

---

## 📋 Step-by-Step Instructions

### Step 1: Stop the Proxy Server
The proxy must be stopped before adding new accounts:

```cmd
taskkill /f /im node.exe
```

### Step 2: Add a New Account
Run the account addition command:

```cmd
cd "C:\Users\Muhib\Desktop\Projects\Antigravity-Claude-Code-Proxy\Antigravity-Claude-Code-Proxy"
npm run accounts:add
```

### Step 3: OAuth Browser Flow
1. **Browser Opens**: A browser window will automatically open
2. **Sign In**: Choose a DIFFERENT Google account (not `muhib.al.karim@gmail.com`)
3. **Grant Permissions**: Click "Allow" or "Continue" 
4. **Wait**: The browser may redirect to a blank page - this is normal
5. **Close Browser**: Close the browser window

### Step 4: Terminal Response
After closing the browser, you'll see:
```
✓ Successfully authenticated: [your-new-email@gmail.com]
✓ Saved 1 account(s) to C:\Users\Muhib\.config\antigravity-proxy\accounts.json
```

### Step 5: Add More Accounts (Optional)
Repeat Steps 2-4 for each additional account you want to add.

### Step 6: Start Proxy Again
```cmd
npm start
```

### Step 7: Verify Multiple Accounts
```cmd
node src/accounts-cli.js list
```

---

## 🎯 Key Points

### ✅ DO:
- Use DIFFERENT Google accounts (not just email aliases)
- Add 2-5 accounts for optimal quota usage
- Close browser after authentication
- Start proxy after adding accounts

### ❌ DON'T:
- Use the same Google account multiple times
- Add accounts while proxy is running
- Keep browser open after authentication

---

## 📊 Expected Output

### Before Adding Accounts:
```
1 account(s) saved:
  1. muhib.al.karim@gmail.com
```

### After Adding 3 Accounts:
```
3 account(s) saved:
  1. muhib.al.karim@gmail.com
  2. another.account@gmail.com
  3. third.account@gmail.com
```

---

## 🔧 Troubleshooting

### Error: "Server is currently running"
- **Solution**: Stop proxy first with `taskkill /f /im node.exe`

### Error: "Could not open browser"
- **Solution**: Copy the URL from terminal and open manually in browser

### Authentication Failed
- **Solution**: Try with a different Google account

### No accounts saved
- **Solution**: Make sure to close browser after authentication

---

## 📈 Benefits of Multiple Accounts

1. **15x More Quota**: Each account has separate daily limits
2. **Load Balancing**: Automatic switching between accounts
3. **No Rate Limits**: When one hits limits, others continue
4. **Higher Throughput**: More parallel requests possible

## 🎉 Ready to Add More Accounts?

**Current**: 1 account  
**Recommended**: 3-5 accounts  
**Maximum**: 10 accounts  

Start by adding your second account now!