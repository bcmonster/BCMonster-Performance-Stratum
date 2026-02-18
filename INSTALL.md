# BCMonster Performance Stratum - Installation Guide

## Quick Install (Recommended)

```bash
# Clone the repo
git clone https://github.com/bcmonster/BCMonster-Performance-Stratum.git
cd BCMonster-Performance-Stratum

# Run the install script
bash install.sh
```

## Manual Install (If Script Fails)

### The blake2b-wasm SSH Problem

One of the deep dependencies (`blake2b-wasm`) uses SSH URLs which require GitHub SSH keys. Here's the guaranteed fix:

```bash
# Step 1: Delete package-lock.json if it exists
rm -f package-lock.json

# Step 2: Configure git to ALWAYS use HTTPS
git config --global url."https://github.com/".insteadOf git@github.com:
git config --global url."https://github.com/".insteadOf ssh://git@github.com/
git config --global url."https://".insteadOf git://
git config --global url."https://".insteadOf ssh://

# Step 3: Set npm to prefer online (don't use cache)
echo "prefer-online=true" >> ~/.npmrc

# Step 4: Clean everything
npm cache clean --force
rm -rf node_modules

# Step 5: Install
npm install
```

## Alternative: Use NPM Published Versions

If the git dependencies keep failing, we can switch to npm-published versions:

```bash
# Edit package.json and change these lines:

# FROM:
"bitgo-utxo-lib": "git+https://github.com/miketout/bitgo-utxo-lib.git",
"equihashverify": "git+https://github.com/s-nomp/equihashverify.git",
"verushash": "git+https://github.com/VerusCoin/verushash-node#...",

# TO:
"bitgo-utxo-lib": "^9.30.0",

# Then just:
npm install
```

**Note:** For Bitcoin SHA256 mining, only `bitgo-utxo-lib` is required. The others (equihashverify, verushash) are for altcoins.

## Verify Installation

```bash
# Check stratum-pool installed
ls -la node_modules/bitgo-utxo-lib
ls -la node_modules/bignum

# Both should exist
```

## Troubleshooting

### Still Getting SSH Errors?

Your system might have an old package-lock.json cached. Try:

```bash
# Nuclear option
rm -rf ~/.npm
rm -rf node_modules package-lock.json
npm cache clean --force

# Reinstall
git config --global url."https://".insteadOf ssh://
npm install --prefer-online
```

### Git Config Not Working?

Check if it was applied:

```bash
git config --global --get-regexp url

# Should show:
# url.https://github.com/.insteadof git@github.com:
# url.https://github.com/.insteadof ssh://git@github.com/
# url.https://.insteadof git://
```

If not shown, the config didn't save. Try:

```bash
# Edit directly
nano ~/.gitconfig

# Add this section:
[url "https://github.com/"]
    insteadOf = git@github.com:
    insteadOf = ssh://git@github.com/
[url "https://"]
    insteadOf = git://
    insteadOf = ssh://
```

## Why This Happens

The dependency tree is:
```
BCMonster-Performance-Stratum
  └─ bitgo-utxo-lib (git+https - OK)
       └─ blake2b (git+https - OK)
            └─ blake2b-wasm (SSH URL - PROBLEM!)
```

The `blake2b-wasm` package.json uses `git+ssh://` instead of `git+https://`.

**Solution:** Git config rewrites SSH→HTTPS before npm sees it.

## Success Criteria

Installation succeeded when:
- ✅ No SSH errors during `npm install`
- ✅ `node_modules/bitgo-utxo-lib` exists
- ✅ `npm install` completes without errors
- ✅ Can `require('bitgo-utxo-lib')` in Node.js

## Next Steps

After successful installation:
1. Upload to GitHub
2. Main pool uses: `"stratum-pool": "git+https://github.com/bcmonster/BCMonster-Performance-Stratum.git"`
3. Users run `npm install` in main pool
4. Stratum installs automatically
