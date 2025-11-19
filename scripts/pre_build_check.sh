#!/bin/bash

# Pre-build check script to ensure CocoaPods is available
# This script ensures CocoaPods is in PATH before Flutter builds

# Add Homebrew to PATH if not already present
if [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Check if pod command exists
if ! command -v pod &> /dev/null; then
    echo "Error: CocoaPods not found in PATH"
    echo "Please ensure CocoaPods is installed:"
    echo "  brew install cocoapods"
    echo "Or add it to PATH:"
    echo "  export PATH=\"/opt/homebrew/bin:\$PATH\""
    exit 1
fi

# Verify pod works
pod --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: CocoaPods is not working properly"
    exit 1
fi

echo "✓ CocoaPods is available: $(pod --version)"
exit 0

