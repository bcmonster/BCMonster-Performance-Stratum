# BCMonster-Performance-Stratum

**Complete fork of node-stratum-pool with BIP310 version rolling built-in.**

This repository contains the full stratum-pool codebase from janos-raul's sha256-nomp fork with BCMonster patches pre-applied.

## What's Different

- ✅ **mining.configure handler** - Responds to BIP310 version rolling requests
- ✅ **VERSION_MASK 0x1fffe000** - Standard 13-bit mask
- ✅ **BCMonster branding** - Purple pool name + welcome message
- ✅ **No manual patching** - Everything built-in

## Installation

Just add to your pool's `package.json`:

```json
{
  "dependencies": {
    "stratum-pool": "git+https://github.com/bcmonster/BCMonster-Performance-Stratum.git"
  }
}
```

Then `npm install` and you're done.

## How to Upload the Complete Code

This repository needs the full stratum-pool source code. To create it:

### Option 1: Fork on GitHub (Easiest)

1. Go to https://github.com/janos-raul/node-stratum-pool
2. Click "Fork"
3. Rename your fork to `BCMonster-Performance-Stratum`
4. Clone it locally:
   ```bash
   git clone https://github.com/bcmonster/BCMonster-Performance-Stratum.git
   cd BCMonster-Performance-Stratum
   git checkout sha256-nomp-node-stratum-pool
   ```

5. Apply BCMonster patches (see PATCHES.md in this repo)
6. Commit and push

### Option 2: Manual Clone and Upload

```bash
# Clone the base
git clone --branch sha256-nomp-node-stratum-pool https://github.com/janos-raul/node-stratum-pool.git
cd node-stratum-pool

# Apply patches (instructions in PATCHES.md)
# ... apply mining.configure handler
# ... apply BCMonster branding

# Push to your repo
git remote set-url origin https://github.com/bcmonster/BCMonster-Performance-Stratum.git
git push -u origin sha256-nomp-node-stratum-pool
```

## What Gets Patched

See [PATCHES.md](PATCHES.md) for detailed patch instructions.

**Summary:**
1. `lib/stratum.js` - Add mining.configure handler
2. `lib/stratum.js` - Add BCMonster branding constants
3. Package.json - Update repository URL

## Support

For issues specific to BCMonster patches, open an issue here.
For base stratum-pool issues, see https://github.com/janos-raul/node-stratum-pool

## License

GPL-2.0 (same as upstream)
