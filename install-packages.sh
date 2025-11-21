#!/bin/bash

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <package1> [package2] [package3] ..."
    echo "Example: $0 mc nano htop"
    exit 1
fi

echo "Installing system packages: $@"
echo ""

# Update package list
sudo apt-get update

# Install requested packages
sudo apt-get install -y "$@"

# Clean up
sudo rm -rf /var/lib/apt/lists/*

echo ""
echo "✓ Packages installed successfully: $@"
