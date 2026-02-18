# BCMonster Performance Stratum

**High-performance Stratum poolserver with BIP310 version rolling for Bitcoin mining.**

This is a BCMonster-maintained fork of node-stratum-pool with built-in support for:
- ✅ **mining.configure** (BIP310 version rolling)
- ✅ **VERSION_MASK 0x1fffe000** (13-bit standard)
- ✅ **BCMonster branding** (purple pool name + welcome message)
- ✅ **No cgminer warnings** ("unexpected mining.configure value" fixed)

## What's Different from Upstream

### BIP310 Version Rolling
Responds to `mining.configure` requests from cgminer, bmminer, Antminer firmware, and Whatsminer with proper version rolling negotiation. Provides 8192× nonce space multiplier for high-hashrate ASICs (>20 TH/s).

### BCMonster Branding
- Purple "BCMonster" in server logs
- Welcome message shown to miners: "Welcome to BCMonster.com! Busting blocks since 2016!"

## Installation

Add to your mining pool's `package.json`:

```json
{
  "dependencies": {
    "stratum-pool": "git+https://github.com/bcmonster/BCMonster-Performance-Stratum.git"
  }
}
```

Then `npm install` and you're ready!

## Credits

- Original stratum-pool: s-nomp developers
- BIP310 patches: Laviathon (BCMonster.com)

## License

GPL-2.0
