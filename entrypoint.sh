#!/bin/bash

# Set proper terminal environment for colors
export TERM="${TERM:-xterm-256color}"
export COLORTERM="truecolor"
export FORCE_COLOR="1"

# Ensure config directory exists
mkdir -p /home/developer/.config/claude-code

# Copy default config if it doesn't exist
if [ ! -f /home/developer/.config/claude-code/config.json ]; then
    if [ -f /home/developer/claude-config-template.json ]; then
        cp /home/developer/claude-config-template.json /home/developer/.config/claude-code/config.json
        echo "Initialized Claude Code configuration"
    fi
fi

# Fix permissions for Claude directories (volumes may be owned by root)
mkdir -p /home/developer/.claude \
         /home/developer/.claude-data \
         /home/developer/.config \
         /home/developer/.cache \
         /home/developer/.local

# Set correct ownership for all persistent directories (using sudo since we're developer user)
sudo chown -R developer:developer /home/developer/.claude \
                                  /home/developer/.claude-data \
                                  /home/developer/.config \
                                  /home/developer/.cache \
                                  /home/developer/.local 2>/dev/null || true

# Start Claude data persistence script in background
/home/developer/persist-claude-data.sh &

# Execute the command passed to the container
exec "$@"
