# BCMonster Performance Stratum

**Original s-nomp stratum-pool + BCMonster BIP310 version rolling**

## What's Added

✅ **mining.configure handler** - BIP310 version rolling support  
✅ **VERSION_MASK 0x1fffe000** - Standard 13-bit mask  
✅ **BCMonster branding** - Purple pool name + welcome message  
✅ **No cgminer warnings** - Properly responds to version rolling requests  

## What's NOT Changed

✅ **All original dependencies** - bitgo-utxo-lib, equihashverify, verushash  
✅ **All transaction code** - Unchanged, fully working  
✅ **All pool logic** - Unchanged, proven stable  
✅ **All coin support** - Bitcoin, altcoins, all algorithms  

## Installation

```json
{
  "dependencies": {
    "stratum-pool": "git+https://github.com/bcmonster/BCMonster-Performance-Stratum.git"
  }
}
```

Then `npm install`

## Changes Made

### 1. lib/stratum.js
- Line 10-12: Added BCMonster branding constants
- Line 74-76: Added `case 'mining.configure':`
- Line 104-152: Added `handleMiningConfigure()` function
- Line 182: Added welcome message to subscribe response

### 2. package.json
- Updated repository URLs
- Added BCMonster to keywords
- Updated version to 1.0.0-bcmonster

**Total changes: ~60 lines added to working code**

## Credits

- **Base**: s-nomp/node-stratum-pool
- **BIP310 patches**: Laviathon (BCMonster.com)

## License

GPL-2.0
