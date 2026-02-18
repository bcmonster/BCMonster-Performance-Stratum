# BCMonster Patches for node-stratum-pool

Apply these patches to janos-raul/node-stratum-pool (sha256-nomp-node-stratum-pool branch).

## Prerequisites

```bash
git clone --branch sha256-nomp-node-stratum-pool https://github.com/janos-raul/node-stratum-pool.git
cd node-stratum-pool
```

---

## Patch 1: Add BCMonster Branding

**File:** `lib/stratum.js`

**Location:** At the top of the file, after the requires, add:

```javascript
// ========================================================================
// BCMonster Branding
// ========================================================================
var POOL_NAME = '\x1b[35mBCMonster\x1b[0m'; // Purple ANSI color  
var WELCOME_MESSAGE = 'Welcome to BCMonster.com! Busting blocks since 2016!';
```

---

## Patch 2: Add mining.configure Handler

**File:** `lib/stratum.js`

**Location:** Find the `StratumClient` constructor or the function that handles incoming messages.

Look for where `mining.subscribe` is handled. It will look something like:

```javascript
case 'mining.subscribe':
    // ... handler code
    break;
```

**Add THIS handler BEFORE the mining.subscribe case:**

```javascript
case 'mining.configure':
    handleMiningConfigure(message, function(error, result){
        sendJson({
            id: message.id,
            result: result,
            error: error
        });
    });
    break;
```

---

## Patch 3: Add handleMiningConfigure Function

**File:** `lib/stratum.js`

**Location:** Add this function near the top of the file, after the branding constants:

```javascript
// ========================================================================
// BCMonster: mining.configure handler for BIP310 version rolling
// ========================================================================
function handleMiningConfigure(message, callback) {
    var params = message.params || [{}];
    var extensions = params[0] || {};
    var result = {};
    var error = null;

    // Version Rolling Extension (BIP310)
    if (extensions['version-rolling'] !== undefined) {
        var VERSION_MASK = 0x1fffe000; // BIP310 standard: 13 bits (bits 13-25)
        var requestParams = extensions['version-rolling'];
        
        // Parse requested mask and min-bit-count
        var requestedMask = parseInt(requestParams['mask'] || '0x1fffe000', 16);
        var minBitCount = requestParams['min-bit-count'] || 0;
        
        // Negotiate: use intersection of requested mask and our mask
        var negotiatedMask = (requestedMask & VERSION_MASK) >>> 0;
        
        // Count bits in negotiated mask
        var bitCount = negotiatedMask.toString(2).replace(/0/g, '').length;
        
        // If negotiated mask has fewer bits than minimum, use full mask
        if (bitCount < minBitCount) {
            negotiatedMask = VERSION_MASK;
            bitCount = 13;
        }
        
        // Respond with version-rolling parameters
        result['version-rolling'] = true;
        result['version-rolling.mask'] = '0x' + ('00000000' + negotiatedMask.toString(16)).slice(-8);
        result['version-rolling.min-bit-count'] = Math.max(minBitCount, 2);
    }

    // Minimum Difficulty Extension (optional)
    if (extensions['minimum-difficulty'] !== undefined) {
        result['minimum-difficulty'] = true;
    }

    // Subscribe Extranonce Extension (optional)
    if (extensions['subscribe-extranonce'] !== undefined) {
        result['subscribe-extranonce'] = true;
    }

    callback(error, result);
}
```

---

## Patch 4: Add Welcome Message to mining.subscribe Response

**File:** `lib/stratum.js`

**Location:** In the `mining.subscribe` handler, find where it sends the response.

It will look something like:

```javascript
sendJson({
    id: message.id,
    result: [
        [
            ["mining.set_difficulty", subscriptionId],
            ["mining.notify", subscriptionId]
        ],
        extraNonce1,
        extraNonce2Size
    ],
    error: null
});
```

**Change it to:**

```javascript
sendJson({
    id: message.id,
    result: [
        [
            ["mining.set_difficulty", subscriptionId],
            ["mining.notify", subscriptionId]
        ],
        extraNonce1,
        extraNonce2Size,
        WELCOME_MESSAGE  // <-- Add this line
    ],
    error: null
});
```

The 4th parameter in the result array is the optional "info" field that miners display on connect.

---

## Patch 5: Update package.json

**File:** `package.json`

Change:

```json
{
  "name": "stratum-pool",
  "repository": {
    "type": "git",
    "url": "https://github.com/janos-raul/node-stratum-pool.git"
  }
}
```

To:

```json
{
  "name": "stratum-pool",
  "version": "1.0.0-bcmonster",
  "description": "High performance Stratum poolserver in Node.js - BCMonster fork with BIP310 version rolling",
  "repository": {
    "type": "git",
    "url": "https://github.com/bcmonster/BCMonster-Performance-Stratum.git"
  }
}
```

---

## Commit and Push

```bash
git add -A
git commit -m "BCMonster patches: Add BIP310 version rolling + branding

- Add mining.configure handler for version rolling (BIP310)
- Negotiate VERSION_MASK 0x1fffe000 (13 bits)
- Add BCMonster welcome message for miners
- Add purple pool name for server logs
- Fixes cgminer 'unexpected mining.configure value' warning"

git remote set-url origin https://github.com/bcmonster/BCMonster-Performance-Stratum.git
git push -u origin sha256-nomp-node-stratum-pool
```

---

## Verification

After patching, test that:

1. `npm install` works without errors
2. Pool starts successfully
3. Miners connect and see welcome message
4. cgminer doesn't show "unexpected mining.configure value" warning
5. Server logs show purple "BCMonster" text

---

## Troubleshooting

**"Cannot find module 'stratum-pool'"**
- Make sure package.json is valid
- Run `npm install` in the parent pool directory

**Welcome message not showing**
- Check that you added it as the 4th parameter in the subscribe response
- Verify miners support the info field (most do)

**Still seeing cgminer warning**
- Check that mining.configure case is BEFORE mining.subscribe
- Verify handleMiningConfigure function exists
- Check server logs for JavaScript errors

**Purple text not showing**
- ANSI colors only work in terminals that support them
- Windows cmd.exe may need ANSI escape code support enabled
- Try a different terminal (bash, PowerShell, etc.)
