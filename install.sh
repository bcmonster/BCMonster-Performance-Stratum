#!/bin/bash
# BCMonster Stratum Installation Script
# Configures git to use HTTPS instead of SSH, then installs dependencies

echo "=================================================="
echo "BCMonster Performance Stratum - Installation"
echo "=================================================="
echo ""

echo "Step 1: Removing old package-lock.json..."
rm -f package-lock.json
echo "✓ Clean slate for npm"
echo ""

echo "Step 2: Configuring git to use HTTPS (no SSH keys needed)..."

# Force all git operations to use HTTPS - multiple methods for safety
git config --global url."https://github.com/".insteadOf git@github.com:
git config --global url."https://github.com/".insteadOf ssh://git@github.com/
git config --global url."https://".insteadOf git://

# Also set for local repo
git config --local url."https://github.com/".insteadOf git@github.com:
git config --local url."https://github.com/".insteadOf ssh://git@github.com/
git config --local url."https://".insteadOf git://

# Environment variable as backup
export GIT_SSH_COMMAND='ssh -o IdentitiesOnly=yes'

echo "✓ Git configured for HTTPS"
echo ""

echo "Step 3: Cleaning npm cache..."
npm cache clean --force 2>/dev/null || true
echo ""

echo "Step 4: Installing dependencies..."
echo "(This may take a few minutes...)"
echo ""

npm install --prefer-online

if [ $? -eq 0 ]; then
    echo ""
    echo "=================================================="
    echo "✅ Installation Complete!"
    echo "=================================================="
    echo ""
    echo "The stratum-pool is ready to use."
    echo ""
    echo "Verification:"
    echo "  ls -la node_modules/bitgo-utxo-lib"
    echo ""
    exit 0
else
    echo ""
    echo "=================================================="
    echo "❌ Installation Failed"
    echo "=================================================="
    echo ""
    echo "Manual fix:"
    echo "  1. git config --global url.\"https://\".insteadOf git://"
    echo "  2. npm cache clean --force"
    echo "  3. rm -rf node_modules package-lock.json"
    echo "  4. npm install"
    echo ""
    exit 1
fi
