#!/bin/bash
# BCMonster Stratum Installation Script
# Configures git to use HTTPS instead of SSH, then installs dependencies

echo "=================================================="
echo "BCMonster Performance Stratum - Installation"
echo "=================================================="
echo ""

echo "Step 1: Configuring git to use HTTPS (no SSH keys needed)..."

# Force all git operations to use HTTPS
git config --global url."https://github.com/".insteadOf git@github.com:
git config --global url."https://github.com/".insteadOf ssh://git@github.com/
git config --global url."https://".insteadOf git://

echo "✓ Git configured for HTTPS"
echo ""

echo "Step 2: Installing dependencies..."
npm install

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
    echo "Try manual fix:"
    echo "  npm cache clean --force"
    echo "  rm -rf node_modules package-lock.json"
    echo "  bash install.sh"
    echo ""
    exit 1
fi
