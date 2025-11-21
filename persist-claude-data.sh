#!/bin/bash

# Directory to store persistent Claude data
PERSIST_DIR="/home/developer/.claude-data"
mkdir -p "$PERSIST_DIR"

# Files to persist
FILES=(
    ".claude.json"
    ".claude.json.backup"
)

# Function to save data
save_data() {
    for file in "${FILES[@]}"; do
        if [ -f "/home/developer/$file" ]; then
            cp -f "/home/developer/$file" "$PERSIST_DIR/" 2>/dev/null
        fi
    done
}

# Function to restore data
restore_data() {
    for file in "${FILES[@]}"; do
        if [ -f "$PERSIST_DIR/$file" ]; then
            cp -f "$PERSIST_DIR/$file" "/home/developer/" 2>/dev/null
        fi
    done
}

# Restore on startup
restore_data

# Save periodically in background
while true; do
    sleep 60
    save_data
done &
