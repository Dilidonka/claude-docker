FROM node:22-bookworm

# ============================================
# LAYER 1: Base system packages (rarely change)
# ============================================
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    mc \
    sudo \
    default-mysql-client \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install uv (Python package manager) for MySQL MCP server
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.cargo/bin/* /usr/local/bin/ 2>/dev/null || true

# ============================================
# LAYER 2: User setup (rarely changes)
# ============================================
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN (groupadd -g ${GROUP_ID} developer 2>/dev/null || \
     groupmod -n developer $(getent group ${GROUP_ID} | cut -d: -f1) 2>/dev/null || true) && \
    (useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash developer 2>/dev/null || \
     usermod -l developer -d /home/developer -m $(getent passwd ${USER_ID} | cut -d: -f1) 2>/dev/null || true) && \
    mkdir -p /home/developer && chown -R ${USER_ID}:${GROUP_ID} /home/developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ============================================
# LAYER 3: Claude Code (can be updated at runtime)
# ============================================
RUN npm install -g @anthropic-ai/claude-code

# Switch to non-root user
USER developer
WORKDIR /home/developer

# ============================================
# LAYER 4: Directory structure and scripts
# ============================================
RUN mkdir -p /home/developer/.config/claude-code \
    /home/developer/mcp-servers \
    /home/developer/workspace

# Copy utility scripts
COPY --chown=developer:developer install-mcp-servers.sh /home/developer/
COPY --chown=developer:developer update-claude.sh /home/developer/
COPY --chown=developer:developer install-packages.sh /home/developer/
COPY --chown=developer:developer persist-claude-data.sh /home/developer/
RUN chmod +x /home/developer/install-mcp-servers.sh \
    /home/developer/update-claude.sh \
    /home/developer/install-packages.sh \
    /home/developer/persist-claude-data.sh

# Copy Claude Code configuration template
COPY --chown=developer:developer claude-config.json /home/developer/claude-config-template.json

# ============================================
# LAYER 5: MCP servers (can be updated at runtime)
# ============================================
RUN /home/developer/install-mcp-servers.sh

# ============================================
# LAYER 6: Entrypoint and startup
# ============================================
COPY --chown=developer:developer entrypoint.sh /home/developer/
RUN chmod +x /home/developer/entrypoint.sh

# Set workspace as working directory
WORKDIR /home/developer/workspace

# Use entrypoint to initialize config on first run
ENTRYPOINT ["/home/developer/entrypoint.sh"]

# Keep container running with bash (Claude Code will be launched via docker exec)
CMD ["/bin/bash"]
