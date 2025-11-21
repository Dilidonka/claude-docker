# Claude Code in Docker

Run Claude Code in a Docker container with the latest Node.js version, bypassing GLIBC compatibility issues on older Linux systems (like Ubuntu 18.04). Includes automatic MCP server installation and configuration.

## Features

- Latest Node.js (v22) runtime
- **Fast updates without rebuilding** - Update Claude Code in seconds
- **On-demand package installation** - Add system packages without rebuild
- Automatic directory mounting from host to container
- Pre-configured MCP servers:
  - `@modelcontextprotocol/server-sequential-thinking` - Structured reasoning
  - `mysql_mcp_server` - MySQL database operations
  - `@upstash/context7-mcp` - Context management with Upstash Redis
  - `@modelcontextprotocol/server-filesystem` - File operations
  - `@modelcontextprotocol/server-github` - GitHub integration
- Persistent configuration and npm cache
- Built-in editors: vim, nano, midnight commander (mc)
- Works on Ubuntu 18.04 and other systems with old GLIBC versions
- Optimized Docker layering for efficient caching

## Prerequisites

- Docker (version 20.10 or later)
- Docker Compose (version 1.29 or later)
- Claude Code subscription (no API key needed)

## Quick Start

1. **Make the launcher script executable:**
   ```bash
   chmod +x claude-docker.sh
   ```

2. **Start Claude Code:**
   ```bash
   ./claude-docker.sh
   ```

   This will automatically:
   - Create a `.env` file if it doesn't exist
   - Build the Docker image with all MCP servers
   - Mount your current directory
   - Launch Claude Code

3. **Optional: Configure MCP servers**

   Edit `.env` to enable optional MCP servers (MySQL, Upstash, GitHub):
   ```bash
   nano .env
   ```

## Usage

### Basic Commands

```bash
# Start Claude Code in current directory
./claude-docker.sh start

# Start Claude Code in specific directory
./claude-docker.sh --workspace /path/to/your/project start

# Stop the container
./claude-docker.sh stop

# Enter the container with bash
./claude-docker.sh enter

# View container logs
./claude-docker.sh logs

# Show help
./claude-docker.sh help
```

### Fast Updates (No Rebuild Required)

```bash
# Update Claude Code to latest version (takes seconds)
./claude-docker.sh update-claude
# Then restart: ./claude-docker.sh stop && ./claude-docker.sh start

# Update MCP servers (takes ~1 minute)
./claude-docker.sh update-mcp

# Install additional system packages on-demand
./claude-docker.sh install-pkg htop ncdu tree
./claude-docker.sh install-pkg python3-dev gcc

# Install midnight commander and nano (already included)
./claude-docker.sh install-pkg mc nano
```

### Full Rebuild (Only When Needed)

```bash
# Rebuild everything from scratch (slow - only use when needed)
./claude-docker.sh rebuild

# Or rebuild with latest versions
./claude-docker.sh update
```

**Note:** You rarely need to rebuild! Use the fast update commands instead.

## Update Philosophy

This setup is designed to **avoid unnecessary rebuilds**:

| Update Type | Command | Speed | When to Use |
|-------------|---------|-------|-------------|
| **Claude Code** | `update-claude` | ~5 seconds | New Claude Code version released |
| **MCP Servers** | `update-mcp` | ~1 minute | Update MCP server packages |
| **System Packages** | `install-pkg` | ~10 seconds | Need new tools (htop, etc.) |
| **Full Rebuild** | `rebuild` | ~5 minutes | Dockerfile changes, major updates |

### Why This Matters

- **Traditional approach**: Every update requires 5+ minute rebuild
- **New approach**: Most updates take seconds, rebuild only when needed
- **Result**: Faster iterations, less waiting, better developer experience

### Environment Variables

You can also set the workspace directory using an environment variable:

```bash
WORKSPACE_DIR=/path/to/project ./claude-docker.sh
```

## Configuration

### .env File

The `.env` file contains all configuration options:

```bash
# Optional: MySQL Configuration (for mysql_mcp_server)
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=your_password
MYSQL_DATABASE=your_database

# Optional: Upstash Redis Configuration (for @upstash/context7-mcp)
UPSTASH_REDIS_URL=https://your-redis-url.upstash.io
UPSTASH_REDIS_TOKEN=your_redis_token

# Optional: GitHub Configuration (for GitHub MCP server)
GITHUB_PERSONAL_ACCESS_TOKEN=your_github_token

# Auto-detected: User/Group IDs (for file permissions)
USER_ID=1000
GROUP_ID=1000
```

### MCP Servers Configuration

MCP servers are configured in `claude-config.json`. The following servers are pre-configured:

1. **Sequential Thinking** - Helps with structured reasoning and planning
2. **MySQL** - Database operations (requires MySQL credentials in .env)
3. **Context7** - Context management with Upstash Redis (requires Upstash credentials)
4. **Filesystem** - File system operations in workspace
5. **GitHub** - GitHub repository operations (requires GitHub token)

To enable/disable specific MCP servers, edit `claude-config.json` before building.

## How It Works

1. **Dockerfile**: Creates a layered container with:
   - Layer 1: Base system packages (rarely change)
   - Layer 2: User setup (rarely changes)
   - Layer 3: Claude Code (updateable at runtime)
   - Layer 4: Utility scripts
   - Layer 5: MCP servers (updateable at runtime)
   - Layer 6: Entrypoint configuration

2. **docker-compose.yml**: Manages container configuration, volume mounts, and environment variables

3. **claude-docker.sh**: Main launcher script that handles:
   - Environment validation
   - Docker image building
   - Container lifecycle management
   - Workspace directory mounting
   - Fast updates without rebuild

4. **Utility Scripts**:
   - `install-mcp-servers.sh`: Installs/updates MCP servers
   - `update-claude.sh`: Updates Claude Code to latest version
   - `install-packages.sh`: Installs system packages on-demand

5. **claude-config.json**: Claude Code configuration with MCP server definitions

## Volume Persistence

The following data is persisted across container restarts:

- Claude Code configuration (`claude-config` volume)
- NPM global packages (`npm-global` volume)
- Bash history (`bash-history` volume)
- Your workspace directory (mounted from host)

## Troubleshooting

### GLIBC Version Issues

If you see errors like "version 'GLIBC_2.XX' not found", this Docker setup solves that by running everything in a container with the latest system libraries.

### Permission Issues

The container runs as a non-root user with the same UID/GID as your host user to avoid permission issues with mounted files.

### MCP Server Errors

If an MCP server fails to start:

1. Check that required environment variables are set in `.env`
2. View logs: `./claude-docker.sh logs`
3. Enter container and check manually: `./claude-docker.sh enter`

### MySQL Connection Issues

If you're connecting to MySQL on the host machine:

- Use `MYSQL_HOST=host.docker.internal` (Docker Desktop)
- Or use `network_mode: host` in docker-compose.yml (Linux)

### Updating Components

**Fast updates (recommended):**
```bash
# Update Claude Code only
./claude-docker.sh update-claude

# Update MCP servers only
./claude-docker.sh update-mcp

# Install new packages
./claude-docker.sh install-pkg package-name
```

**Full rebuild (rarely needed):**
```bash
# Only use when you modify Dockerfile or need clean slate
./claude-docker.sh rebuild
```

## Directory Structure

```
claude-docker/
├── Dockerfile                 # Container definition with optimized layers
├── docker-compose.yml         # Docker Compose configuration
├── claude-docker.sh           # Main launcher script with update commands
├── entrypoint.sh              # Container startup script
├── install-mcp-servers.sh     # MCP servers installation/update script
├── update-claude.sh           # Claude Code update script (runtime)
├── install-packages.sh        # System packages installer (runtime)
├── claude-config.json         # Claude Code configuration template
├── .env                       # Environment variables (created on first run)
└── README.md                  # This file
```

## Advanced Usage

### Running from Any Directory

Create a symlink or add to your PATH:

```bash
# Symlink
sudo ln -s /path/to/claude-docker/claude-docker.sh /usr/local/bin/claude-docker

# Then use from anywhere:
cd ~/my-project
claude-docker start
```

### Custom MCP Servers

To add your own MCP servers:

1. Edit `install-mcp-servers.sh` to install your server
2. Edit `claude-config.json` to configure it
3. Update MCP servers: `./claude-docker.sh update-mcp` (fast)

   Or rebuild for major changes: `./claude-docker.sh rebuild`

### Using with Different Node Versions

Edit `Dockerfile` and change the first line:

```dockerfile
FROM node:20-bookworm  # for Node.js 20
FROM node:18-bookworm  # for Node.js 18
```

Then rebuild: `./claude-docker.sh rebuild`

## Security Notes

- Store your `.env` file securely and don't commit it to version control
- `.env` is already in `.gitignore`
- Credentials are only passed to the container via environment variables
- The container runs as a non-root user for security
- Authentication uses your Claude Code subscription, no API key needed

## License

This setup is provided as-is for use with Claude Code. Refer to Anthropic's terms of service for Claude Code usage.

## Support

For issues with:
- **This Docker setup**: Open an issue in your repository
- **Claude Code**: Visit https://github.com/anthropics/claude-code
- **MCP Servers**: Check individual MCP server documentation

## Changelog

### Version 2.0.0
- **Fast update system**: Update Claude Code without rebuilding (seconds vs minutes)
- **On-demand package installation**: Add system packages without rebuild
- **Optimized Docker layering**: Better caching and faster builds
- **New commands**: `update-claude`, `update-mcp`, `install-pkg`
- **Built-in editors**: Added nano and midnight commander (mc)
- **Runtime update scripts**: `update-claude.sh` and `install-packages.sh`
- **Improved documentation**: Clear guidance on when to rebuild vs update

### Version 1.0.0
- Initial release
- Support for Node.js 22
- Pre-configured MCP servers
- Automatic environment setup
- Ubuntu 18.04+ compatibility
