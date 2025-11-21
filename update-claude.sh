#!/bin/bash

set -e

echo "Updating Claude Code to latest version..."

# Update Claude Code globally
sudo npm update -g @anthropic-ai/claude-code

echo "✓ Claude Code updated successfully!"

# Show version
echo ""
echo "Current Claude Code version:"
claude --version || echo "Claude Code is installed"
