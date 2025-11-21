#!/bin/bash

set -e

echo "Installing MCP servers..."

# Create MCP servers directory
mkdir -p /home/developer/mcp-servers

# Install sequential thinking MCP server
echo "Installing @modelcontextprotocol/server-sequential-thinking..."
cd /home/developer/mcp-servers
mkdir -p sequential-thinking
cd sequential-thinking
npm init -y > /dev/null 2>&1
npm install @modelcontextprotocol/server-sequential-thinking > /dev/null 2>&1
echo "✓ @modelcontextprotocol/server-sequential-thinking installed"

# Install uv (Python package manager for mysql_mcp_server)
echo "Installing uv (Python package manager)..."
if ! command -v uvx &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="/home/developer/.cargo/bin:$PATH"
    echo 'export PATH="/home/developer/.cargo/bin:$PATH"' >> /home/developer/.bashrc
fi
echo "✓ uv installed for mysql_mcp_server"

# Install Upstash Context7 MCP server
echo "Installing @upstash/context7-mcp..."
cd /home/developer/mcp-servers
mkdir -p context7-mcp
cd context7-mcp
npm init -y > /dev/null 2>&1
npm install @upstash/context7-mcp > /dev/null 2>&1
echo "✓ @upstash/context7-mcp installed"

# Install additional useful MCP servers
echo "Installing @modelcontextprotocol/server-filesystem..."
cd /home/developer/mcp-servers
mkdir -p filesystem
cd filesystem
npm init -y > /dev/null 2>&1
npm install @modelcontextprotocol/server-filesystem > /dev/null 2>&1
echo "✓ @modelcontextprotocol/server-filesystem installed"

echo "Installing @modelcontextprotocol/server-github..."
cd /home/developer/mcp-servers
mkdir -p github
cd github
npm init -y > /dev/null 2>&1
npm install @modelcontextprotocol/server-github > /dev/null 2>&1
echo "✓ @modelcontextprotocol/server-github installed"

echo ""
echo "All MCP servers installed successfully!"
echo ""
