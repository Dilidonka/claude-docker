# Quick Start Guide

## Setup (One-time)

```bash
# Make the script executable
chmod +x claude-docker.sh

# Run the script - it will create .env automatically
./claude-docker.sh
```

That's it! The script will:
- Create a `.env` file (no API key needed with subscription)
- Build the Docker image with Node.js 22 and all MCP servers
- Mount your current directory
- Launch Claude Code

## Daily Usage

```bash
# Start Claude Code (from any directory)
./claude-docker.sh

# Or specify a project directory
./claude-docker.sh --workspace /path/to/project
```

## Optional: Configure MCP Servers

Edit `.env` to enable MySQL, Upstash, or GitHub MCP servers:

```bash
# MySQL (optional)
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=yourpassword

# Upstash Redis (optional)
UPSTASH_REDIS_URL=https://...
UPSTASH_REDIS_TOKEN=...

# GitHub (optional)
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_...
```

Then rebuild:
```bash
./claude-docker.sh rebuild
```

## Other Commands

```bash
./claude-docker.sh stop      # Stop container
./claude-docker.sh enter     # Open bash in container
./claude-docker.sh logs      # View logs
./claude-docker.sh rebuild   # Rebuild from scratch
```

## Pre-installed MCP Servers

- **Sequential Thinking** - Always available
- **Filesystem** - Always available
- **MySQL** - Configure in .env
- **Context7 (Upstash)** - Configure in .env
- **GitHub** - Configure in .env

## Troubleshooting

**Build fails?**
```bash
./claude-docker.sh rebuild
```

**Permission errors?**
The container uses your user ID automatically.

**Can't connect to MySQL on host?**
Use `MYSQL_HOST=host.docker.internal` or actual host IP.
