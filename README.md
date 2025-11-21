<div align="center">

# 🐳 Claude Code in Docker

**One-Click Isolated AI Coding Assistant | Secure Sandboxing | Zero Host Risk**

[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-v22-339933?logo=node.js&logoColor=white)](https://nodejs.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Security](https://img.shields.io/badge/Security-Isolated-success)](docs/SECURITY.md)

[Quick Start](#-quick-start) • [Features](#-features) • [Security](#-security-why-docker) • [Documentation](#-usage)

</div>

---

## 🎯 What is This?

A **production-ready, security-focused Docker setup** for running [Claude Code](https://claude.com/claude-code) - Anthropic's AI coding assistant - in complete isolation from your host system. One command to start, fully persistent, with automatic updates and zero configuration.

### Perfect For:

- 🛡️ **Security-conscious developers** who want AI assistance without host system risk
- 🔄 **Experimentation** - Run Claude Code in YOLO mode safely in isolated workspaces
- 🐧 **Older systems** - Bypass GLIBC compatibility issues (Ubuntu 18.04+)
- ⚡ **Fast iterations** - Update Claude Code in seconds, not minutes
- 🏢 **Teams** - Standardized development environment across machines

---

## ✨ Features

### 🚀 One-Click Setup
```bash
chmod +x claude-docker.sh && ./claude-docker.sh
```
That's it. Claude Code starts automatically with persistent authentication.

### 🔒 Security-First Design

| Feature | This Setup | Native Claude | Anthropic Sandbox |
|---------|------------|---------------|-------------------|
| **Filesystem Isolation** | ✅ Container only | ❌ Full access | ✅ Bubblewrap |
| **Network Isolation** | ✅ Configurable | ❌ Full access | ✅ Proxy + Whitelist |
| **Persistent Auth** | ✅ Volumes | ✅ Native | ✅ Native |
| **One-Click Setup** | ✅ Yes | ✅ Yes | ⚠️ Manual config |
| **Custom MCP Servers** | ✅ Pre-configured | ✅ Yes | ⚠️ Limited |
| **Update Speed** | ✅ 5 seconds | ✅ Instant | ⚠️ Rebuild |

### ⚡ Fast Update System

- **Update Claude Code**: `./claude-docker.sh update-claude` (5 seconds)
- **Update MCP Servers**: `./claude-docker.sh update-mcp` (1 minute)
- **Install Packages**: `./claude-docker.sh install-pkg htop nano` (10 seconds)
- **Full Rebuild**: Only when needed (~5 minutes)

### 🔧 Pre-Configured MCP Servers

- `@modelcontextprotocol/server-sequential-thinking` - Enhanced reasoning
- `mysql_mcp_server` - Database operations
- `@upstash/context7-mcp` - Context management
- `@modelcontextprotocol/server-filesystem` - File operations
- `@modelcontextprotocol/server-github` - GitHub integration

### 💾 Persistent Everything

- ✅ Authentication & session data
- ✅ Claude Code configuration
- ✅ Project history & settings
- ✅ MCP server data
- ✅ Bash history

---

## 🛡️ Security: Why Docker?

### The Problem with Native Claude Code

Running Claude Code directly on your host gives it:
- ❌ Full filesystem access (can modify/delete system files)
- ❌ Unrestricted network access (all localhost services)
- ❌ System-wide permissions
- ❌ Access to SSH keys, AWS credentials, secrets

### Docker Isolation Benefits

**What Claude Code CAN'T access:**
- ✅ Your home directory (`/home/user/`)
- ✅ System files (`/etc/`, `/var/`, etc.)
- ✅ SSH keys (`~/.ssh/`)
- ✅ Other projects (only mounted workspace visible)
- ✅ Host services (MySQL, Redis) - configurable
- ✅ Host processes

**What Claude Code CAN access:**
- 📁 Mounted workspace directory only
- 🌐 Internet (for API calls, package downloads)
- 🐳 Container filesystem (isolated, easily reset)

### Risk Assessment

| Scenario | Native Claude | Docker (This Setup) |
|----------|---------------|---------------------|
| Delete important files | 🔴 Can delete `/home/user/` | 🟢 Only workspace files |
| Access SSH keys | 🔴 Full access | 🟢 Not mounted, safe |
| Modify system config | 🔴 Can edit `/etc/` | 🟢 Container only |
| Mine cryptocurrency | 🔴 Uses host CPU | 🟡 Uses CPU, kill container |
| Exfiltrate source code | 🔴 Can send any file | 🟡 Only workspace files |
| Break other projects | 🔴 Can access all | 🟢 Not mounted |
| **Host OS compromise** | 🔴 Possible | 🟢 Requires container escape (rare) |

### Comparison: This Setup vs Anthropic's Sandboxing

**Anthropic's Approach** (OS-level sandboxing):
- Uses `bubblewrap` (Linux) / `seatbelt` (macOS)
- Network proxy with domain whitelisting
- 84% fewer permission prompts
- Requires manual configuration

**This Docker Setup**:
- Full OS isolation via containers
- Network configurable (host mode or isolated)
- One-click deployment
- Easier to reset/rebuild
- Works on any OS with Docker

**Which to Choose?**

- **Native + Anthropic Sandbox**: Best for daily development on your main machine
- **This Docker Setup**: Best for experimentation, older systems, team environments, or maximum isolation

### YOLO Mode Safety

With isolated workspace + Docker, **YOLO mode becomes safe**:

```bash
# Create isolated workspace
mkdir ~/claude-experiments
cd ~/claude-experiments

# Start Claude Code in Docker
./claude-docker.sh start

# Enable YOLO mode - worst case: delete workspace and start fresh
```

**Risk**: Only the isolated workspace can be affected. Your host system remains protected.

---

## 🚀 Quick Start

### 1. Clone & Setup
```bash
git clone https://github.com/Dilidonka/claude-docker.git
cd claude-docker
chmod +x claude-docker.sh
```

### 2. Start Claude Code
```bash
./claude-docker.sh start
```

That's it! Claude Code will:
- ✅ Build the Docker image (first time only)
- ✅ Start the container
- ✅ Launch Claude Code automatically
- ✅ Save your authentication

### 3. Daily Usage
```bash
# Start
./claude-docker.sh start

# Stop
./claude-docker.sh stop

# Update Claude Code (fast)
./claude-docker.sh update-claude

# Enter container with bash
./claude-docker.sh enter
```

---

## 📖 Usage

### Basic Commands

```bash
# Start Claude Code in current directory
./claude-docker.sh start

# Start in specific directory
./claude-docker.sh --workspace /path/to/project start

# Stop container
./claude-docker.sh stop

# Enter container with bash
./claude-docker.sh enter

# View logs
./claude-docker.sh logs

# Help
./claude-docker.sh help
```

### Fast Updates (No Rebuild)

```bash
# Update Claude Code (5 seconds)
./claude-docker.sh update-claude
# Then restart: ./claude-docker.sh stop && ./claude-docker.sh start

# Update MCP servers (1 minute)
./claude-docker.sh update-mcp

# Install system packages on-demand
./claude-docker.sh install-pkg htop ncdu tree
./claude-docker.sh install-pkg python3-dev gcc

# Install midnight commander and nano (already included)
./claude-docker.sh install-pkg mc nano
```

### Full Rebuild (Rarely Needed)

```bash
# Rebuild everything from scratch (slow)
./claude-docker.sh rebuild

# Or rebuild with latest versions
./claude-docker.sh update
```

**💡 Tip:** You rarely need to rebuild! Use fast update commands instead.

---

## 🔄 Update Philosophy

This setup avoids unnecessary rebuilds:

| Update Type | Command | Speed | When to Use |
|-------------|---------|-------|-------------|
| **Claude Code** | `update-claude` | ~5 seconds | New version released |
| **MCP Servers** | `update-mcp` | ~1 minute | Update packages |
| **System Packages** | `install-pkg` | ~10 seconds | Need new tools |
| **Full Rebuild** | `rebuild` | ~5 minutes | Dockerfile changes |

### Why This Matters

- **Traditional**: Every update = 5+ minute rebuild
- **This setup**: Most updates = seconds
- **Result**: Faster iterations, less waiting

---

## ⚙️ Configuration

### Environment Variables

Edit `.env` file (auto-created on first run):

```bash
# MySQL Configuration (Optional)
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=your_password
MYSQL_DATABASE=your_database

# Upstash Redis (Optional)
UPSTASH_REDIS_URL=https://your-redis.upstash.io
UPSTASH_REDIS_TOKEN=your_token

# GitHub (Optional)
GITHUB_PERSONAL_ACCESS_TOKEN=your_github_token
```

**Note:** `USER_ID`, `GROUP_ID`, and `WORKSPACE_DIR` are automatically set by the script.

### MCP Servers

Pre-configured servers in `claude-config.json`:

1. **Sequential Thinking** - Structured reasoning
2. **MySQL** - Database operations (requires credentials)
3. **Context7** - Upstash Redis context management
4. **Filesystem** - File operations in workspace
5. **GitHub** - Repository operations (requires token)

To enable/disable, edit `claude-config.json` before first run.

---

## 🏗️ Architecture

### Layered Dockerfile Design

```
Layer 1: Base system packages (rarely change)
Layer 2: User setup (rarely changes)
Layer 3: Claude Code (updateable at runtime)
Layer 4: Utility scripts
Layer 5: MCP servers (updateable at runtime)
Layer 6: Entrypoint configuration
```

Benefits:
- ✅ Maximizes Docker cache efficiency
- ✅ Fast rebuilds when only Claude Code changes
- ✅ Runtime updates without full rebuild

### Persistent Volumes

```
claude-auth        → /home/developer/.claude/
claude-data        → /home/developer/.claude-data/
claude-config      → /home/developer/.config/
claude-cache       → /home/developer/.cache/
claude-local       → /home/developer/.local/
npm-global         → /home/developer/.npm-global/
bash-history       → Bash history
```

All authentication, settings, and project data persist across container restarts.

---

## 🔒 Advanced Security

### Network Isolation

**Default**: `network_mode: host` (container can access localhost services)

**For maximum isolation**, disable host networking:

```yaml
# docker-compose.yml
# network_mode: host  # Comment out this line
```

Then rebuild:
```bash
./claude-docker.sh rebuild
```

**Trade-offs:**
- ✅ **More secure**: Cannot access host services (MySQL, Redis, etc.)
- ❌ **Less convenient**: Need explicit port mappings for services

### Read-Only Workspace

For maximum safety, mount workspace as read-only:

```yaml
# docker-compose.yml
volumes:
  - ${WORKSPACE_DIR}:/home/developer/workspace:ro  # Add :ro
```

Claude Code can analyze but not modify files.

### Hardened Mode

Create `docker-compose.hardened.yml`:

```yaml
services:
  claude-code:
    extends:
      file: docker-compose.yml
      service: claude-code
    # Remove network_mode: host
    # Remove sudo from user
    # Add security options
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - DAC_OVERRIDE
```

---

## 🛠️ Troubleshooting

### Container Won't Start

**Issue**: `invalid spec: :/home/developer/workspace`

**Solution**: WORKSPACE_DIR is not set
```bash
export WORKSPACE_DIR=/path/to/your/project
./claude-docker.sh start
```

### Permission Errors

**Issue**: `EACCES: permission denied`

**Solution**: Volume ownership issue, rebuild to fix permissions
```bash
./claude-docker.sh rebuild
```

### Authentication Lost After Restart

**Solution**: Ensure volumes are properly configured
```bash
docker volume ls | grep claude
# Should see: claude-auth, claude-data, claude-config, etc.
```

If missing, rebuild:
```bash
./claude-docker.sh rebuild
```

### Claude Code Version Issues

**Update to latest:**
```bash
./claude-docker.sh update-claude
./claude-docker.sh stop && ./claude-docker.sh start
```

### MySQL Connection Issues

**From container to host MySQL:**
- Linux: `network_mode: host` + `MYSQL_HOST=localhost`
- Docker Desktop: `MYSQL_HOST=host.docker.internal`

---

## 📂 Directory Structure

```
claude-docker/
├── Dockerfile                    # Layered container definition
├── docker-compose.yml            # Docker Compose configuration
├── claude-docker.sh              # Main launcher script
├── entrypoint.sh                 # Container startup script
├── install-mcp-servers.sh        # MCP installation/update
├── update-claude.sh              # Claude Code updater (runtime)
├── install-packages.sh           # System package installer (runtime)
├── persist-claude-data.sh        # Authentication persistence
├── claude-config.json            # Claude Code config template
├── .env                          # Environment variables
├── README.md                     # This file
└── QUICK_START.md                # Quick reference guide
```

---

## 🎓 Use Cases

### 1. Safe Experimentation
```bash
mkdir ~/ai-experiments
cd ~/ai-experiments
git clone https://github.com/some/project
./claude-docker.sh start
# Enable YOLO mode - worst case: rm -rf ~/ai-experiments
```

### 2. Legacy System Support
```bash
# Works on Ubuntu 18.04, CentOS 7, etc.
# Bypasses GLIBC version issues
./claude-docker.sh start
```

### 3. Team Development
```bash
# Everyone uses same environment
git clone <your-project>
cd <your-project>
/path/to/claude-docker/claude-docker.sh --workspace $(pwd) start
```

### 4. Multiple Projects
```bash
# Project A
./claude-docker.sh --workspace ~/project-a start

# Project B (separate container)
./claude-docker.sh --workspace ~/project-b start
```

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

## 📝 License

This project is provided as-is for use with Claude Code. Refer to [Anthropic's terms of service](https://www.anthropic.com/legal/consumer-terms) for Claude Code usage.

---

## 🙏 Acknowledgments

- [Anthropic](https://www.anthropic.com/) for Claude Code
- [Docker](https://www.docker.com/) for containerization
- Community contributors and testers

---

## 📚 Additional Resources

- [Claude Code Official Docs](https://code.claude.com/docs)
- [Claude Code Sandboxing](https://www.anthropic.com/engineering/claude-code-sandboxing)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [MCP Protocol](https://modelcontextprotocol.io/)

---

## 📊 Changelog

### Version 2.0.0 (Latest)
- ✨ Fast update system (no rebuilds needed)
- ✨ On-demand package installation
- ✨ Optimized Docker layering
- ✨ Persistent authentication (`.claude/`, `.claude.json`)
- ✨ Built-in editors (nano, midnight commander)
- ✨ Runtime update scripts
- 📚 Enhanced documentation
- 🔒 Improved security guidance

### Version 1.0.0
- 🎉 Initial release
- ✅ Node.js 22 support
- ✅ Pre-configured MCP servers
- ✅ Automatic environment setup
- ✅ Ubuntu 18.04+ compatibility

---

## 🌟 Star History

If this project helped you, please ⭐ star it on GitHub!

---

<div align="center">

**Made with ❤️ for secure AI-assisted development**

[Report Bug](https://github.com/Dilidonka/claude-docker/issues) • [Request Feature](https://github.com/Dilidonka/claude-docker/issues)

</div>
