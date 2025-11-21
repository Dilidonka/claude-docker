#!/bin/bash

# Ensure config directory exists
mkdir -p /home/developer/.config/claude-code

# Copy default config if it doesn't exist
if [ ! -f /home/developer/.config/claude-code/config.json ]; then
    if [ -f /home/developer/claude-config-template.json ]; then
        cp /home/developer/claude-config-template.json /home/developer/.config/claude-code/config.json
        echo "Initialized Claude Code configuration"
    fi
fi

# Execute the command passed to the container
exec "$@"
