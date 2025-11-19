#!/bin/bash

# Ensure CocoaPods is available for Flutter builds
# This script ensures that CocoaPods is in the PATH

# Check if pod command exists
if ! command -v pod &> /dev/null; then
    # Try common installation paths
    if [ -f "/opt/homebrew/bin/pod" ]; then
        export PATH="/opt/homebrew/bin:$PATH"
    elif [ -f "/usr/local/bin/pod" ]; then
        export PATH="/usr/local/bin:$PATH"
    else
        echo "Error: CocoaPods not found. Please install it with:"
        echo "  sudo gem install cocoapods"
        exit 1
    fi
fi

# Verify pod is accessible
pod --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: CocoaPods is not working properly"
    exit 1
fi

echo "CocoaPods is available: $(pod --version)"
exit 0

