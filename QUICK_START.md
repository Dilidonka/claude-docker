# Quick Start Guide

## First Time Setup

```bash
# 1. Make script executable
chmod +x claude-docker.sh

# 2. Build and start
./claude-docker.sh start
```

That's it! Claude Code will start automatically.

## Common Commands

### Daily Usage
```bash
./claude-docker.sh start              # Start Claude Code
./claude-docker.sh stop               # Stop container
./claude-docker.sh enter              # Open bash in container
```

### Fast Updates (No Rebuild)
```bash
./claude-docker.sh update-claude      # Update Claude Code (5 sec)
./claude-docker.sh update-mcp         # Update MCP servers (1 min)
./claude-docker.sh install-pkg mc nano # Add packages (10 sec)
```

### Rarely Needed
```bash
./claude-docker.sh rebuild            # Full rebuild (5 min)
./claude-docker.sh logs               # View logs
```

## Quick Tips

✅ **DO**: Use `update-claude` for Claude Code updates
✅ **DO**: Use `install-pkg` to add new tools
✅ **DO**: Use `update-mcp` for MCP updates

❌ **DON'T**: Rebuild unless you modified the Dockerfile
❌ **DON'T**: Wait 5 minutes when 5 seconds will do

## Editors Available

- `nano` - Simple text editor
- `vim` - Advanced text editor
- `mc` - Midnight Commander (file manager)

## Need Help?

```bash
./claude-docker.sh help
```

Or check the full [README.md](README.md) for detailed documentation.

## Troubleshooting One-Liners

```bash
# Container won't start?
./claude-docker.sh rebuild

# Permission issues?
# Edit .env and set USER_ID/GROUP_ID to match your host user

# Can't update Claude Code?
# Container must be running first: ./claude-docker.sh start
# Then in another terminal: ./claude-docker.sh update-claude
```
