#!/bin/bash

set -e

echo "================================================"
echo "  App Switcher Chrome - Installation Script"
echo "================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_mark="${GREEN}✓${NC}"
cross_mark="${RED}✗${NC}"
arrow="${YELLOW}→${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check OS
OS="$(uname -s)"
echo -e "${arrow} Detected OS: ${OS}"
echo ""

# 1. Check/Install Homebrew (macOS only)
if [[ "$OS" == "Darwin" ]]; then
    echo "Checking Homebrew..."
    if command_exists brew; then
        echo -e "  ${check_mark} Homebrew is already installed"
    else
        echo -e "  ${cross_mark} Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo -e "  ${check_mark} Homebrew installed"
    fi
    echo ""
fi

# 2. Check/Install Flutter
echo "Checking Flutter..."
if command_exists flutter; then
    FLUTTER_VERSION=$(flutter --version 2>/dev/null | head -n 1)
    echo -e "  ${check_mark} Flutter is already installed"
    echo "      ${FLUTTER_VERSION}"
else
    echo -e "  ${cross_mark} Flutter not found. Installing..."
    if [[ "$OS" == "Darwin" ]]; then
        brew install --cask flutter
        # Add Flutter to PATH for this session
        export PATH="$PATH:/opt/homebrew/Caskroom/flutter/*/flutter/bin"
        echo -e "  ${check_mark} Flutter installed via Homebrew"
    elif [[ "$OS" == "Linux" ]]; then
        echo "      Please install Flutter manually: https://docs.flutter.dev/get-started/install/linux"
        exit 1
    else
        echo "      Unsupported OS. Please install Flutter manually: https://docs.flutter.dev/get-started/install"
        exit 1
    fi
fi
echo ""

# 3. Check/Install Chrome (for web development)
echo "Checking Chrome..."
if [[ "$OS" == "Darwin" ]]; then
    if [[ -d "/Applications/Google Chrome.app" ]]; then
        echo -e "  ${check_mark} Google Chrome is already installed"
    else
        echo -e "  ${cross_mark} Chrome not found. Installing..."
        brew install --cask google-chrome
        echo -e "  ${check_mark} Chrome installed"
    fi
elif [[ "$OS" == "Linux" ]]; then
    if command_exists google-chrome || command_exists google-chrome-stable; then
        echo -e "  ${check_mark} Google Chrome is already installed"
    else
        echo -e "  ${YELLOW}!${NC} Chrome not found. Please install Chrome manually for web development."
    fi
fi
echo ""

# 4. Enable Flutter web support
echo "Enabling Flutter web support..."
flutter config --enable-web >/dev/null 2>&1
echo -e "  ${check_mark} Flutter web support enabled"
echo ""

# 5. Get Flutter dependencies
echo "Installing Flutter dependencies..."
flutter pub get
echo -e "  ${check_mark} Dependencies installed"
echo ""

# 6. Run Flutter doctor
echo "Running Flutter doctor..."
echo ""
flutter doctor
echo ""

echo "================================================"
echo -e "  ${GREEN}Installation complete!${NC}"
echo "================================================"
echo ""
echo "To run the app:"
echo "  flutter run -d chrome"
echo ""
