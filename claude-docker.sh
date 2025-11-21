#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
# Set WORKSPACE_DIR to current directory if not set or empty
if [ -z "$WORKSPACE_DIR" ]; then
    WORKSPACE_DIR="$(pwd)"
fi
export WORKSPACE_DIR

IMAGE_NAME="claude-code:latest"
CONTAINER_NAME="claude-code-dev"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
}

# Function to check if .env file exists
check_env_file() {
    if [ ! -f "$SCRIPT_DIR/.env" ]; then
        print_info ".env file not found. Creating template..."
        cat > "$SCRIPT_DIR/.env" << 'EOF'
# MySQL Configuration (Optional - for mysql_mcp_server)
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=
MYSQL_DATABASE=

# Upstash Redis Configuration (Optional - for @upstash/context7-mcp)
UPSTASH_REDIS_URL=
UPSTASH_REDIS_TOKEN=

# GitHub Configuration (Optional - for GitHub MCP server)
GITHUB_PERSONAL_ACCESS_TOKEN=

# Note: USER_ID, GROUP_ID, and WORKSPACE_DIR are automatically set by the script
EOF
        print_success ".env file created successfully"
    fi
}

# Function to build the Docker image
build_image() {
    print_info "Building Docker image..."
    cd "$SCRIPT_DIR"

    # Export user/group IDs
    # If running as root (ID 0), use 1000 as default instead
    if [ "$(id -u)" -eq 0 ]; then
        export USER_ID=${USER_ID:-1000}
        export GROUP_ID=${GROUP_ID:-1000}
        print_warning "Running as root. Using USER_ID=${USER_ID} GROUP_ID=${GROUP_ID}"
        print_info "To use different IDs, set USER_ID and GROUP_ID environment variables"
    else
        export USER_ID=$(id -u)
        export GROUP_ID=$(id -g)
    fi

    # Set WORKSPACE_DIR if not already set (use current directory)
    if [ -z "$WORKSPACE_DIR" ]; then
        export WORKSPACE_DIR="$(pwd)"
    fi

    # Ensure variables are exported for docker-compose
    export USER_ID GROUP_ID WORKSPACE_DIR

    docker-compose build
    print_success "Docker image built successfully"
}

# Function to start the container
start_container() {
    print_info "Starting Claude Code container..."
    cd "$SCRIPT_DIR"

    # Export environment variables
    # If running as root (ID 0), use 1000 as default instead
    if [ "$(id -u)" -eq 0 ]; then
        export USER_ID=${USER_ID:-1000}
        export GROUP_ID=${GROUP_ID:-1000}
    else
        export USER_ID=$(id -u)
        export GROUP_ID=$(id -g)
    fi

    # Set WORKSPACE_DIR if not already set
    if [ -z "$WORKSPACE_DIR" ]; then
        export WORKSPACE_DIR="$(pwd)"
    fi

    # Check if container is already running
    if docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        print_warning "Container is already running. Launching Claude Code..."
        docker exec -it "$CONTAINER_NAME" bash -c "cd /home/developer/workspace && claude"
    else
        # Remove old container if exists
        if docker ps -a -q -f name="$CONTAINER_NAME" | grep -q .; then
            print_info "Removing old container..."
            docker rm "$CONTAINER_NAME" > /dev/null 2>&1
        fi

        # Start container in background
        print_info "Starting container..."
        # Ensure environment variables are exported for docker-compose
        export USER_ID GROUP_ID WORKSPACE_DIR
        docker-compose up -d

        # Wait for container to be ready
        sleep 2

        # Launch Claude Code interactively
        print_info "Launching Claude Code..."
        docker exec -it "$CONTAINER_NAME" bash -c "cd /home/developer/workspace && claude"
    fi
}

# Function to stop the container
stop_container() {
    print_info "Stopping Claude Code container..."
    cd "$SCRIPT_DIR"

    # Export environment variables
    # If running as root (ID 0), use 1000 as default instead
    if [ "$(id -u)" -eq 0 ]; then
        export USER_ID=${USER_ID:-1000}
        export GROUP_ID=${GROUP_ID:-1000}
    else
        export USER_ID=$(id -u)
        export GROUP_ID=$(id -g)
    fi

    # Set WORKSPACE_DIR if not already set (use current directory)
    if [ -z "$WORKSPACE_DIR" ]; then
        export WORKSPACE_DIR="$(pwd)"
    fi

    # Ensure variables are exported for docker-compose
    export USER_ID GROUP_ID WORKSPACE_DIR

    docker-compose down
    print_success "Container stopped"
}

# Function to enter the container
enter_container() {
    if ! docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        print_error "Container is not running. Start it first with: $0 start"
        exit 1
    fi

    print_info "Entering container..."
    docker exec -it "$CONTAINER_NAME" bash
}

# Function to rebuild everything
rebuild() {
    print_info "Rebuilding everything..."
    stop_container
    print_info "Removing old image..."
    docker rmi "$IMAGE_NAME" > /dev/null 2>&1 || true
    build_image
    print_success "Rebuild complete"
}

# Function to update Claude Code (without rebuild)
update_claude() {
    if ! docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        print_error "Container is not running. Start it first with: $0 start"
        exit 1
    fi

    print_info "Updating Claude Code to latest version..."
    docker exec -it "$CONTAINER_NAME" /home/developer/update-claude.sh
    print_success "Claude Code updated successfully"
    print_info "Restart the container to use the new version: $0 stop && $0 start"
}

# Function to update MCP servers (without rebuild)
update_mcp() {
    if ! docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        print_error "Container is not running. Start it first with: $0 start"
        exit 1
    fi

    print_info "Updating MCP servers..."
    docker exec -it "$CONTAINER_NAME" /home/developer/install-mcp-servers.sh
    print_success "MCP servers updated successfully"
}

# Function to install system packages (without rebuild)
install_packages() {
    if ! docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        print_error "Container is not running. Start it first with: $0 start"
        exit 1
    fi

    if [ $# -eq 0 ]; then
        print_error "Please specify packages to install"
        print_info "Usage: $0 install-pkg <package1> [package2] ..."
        exit 1
    fi

    print_info "Installing packages: $@"
    docker exec -it "$CONTAINER_NAME" /home/developer/install-packages.sh "$@"
    print_success "Packages installed successfully"
}

# Function to rebuild image (old method - for major updates)
update() {
    print_info "Rebuilding image with latest versions..."
    print_warning "This will rebuild the entire image. Use 'update-claude' for faster Claude Code updates."
    stop_container
    print_info "Removing old image to force fresh build..."
    docker rmi "$IMAGE_NAME" > /dev/null 2>&1 || true
    print_info "Building new image..."
    build_image
    print_success "Image rebuilt successfully"
    print_info "Start the container with: $0 start"
}

# Function to show logs
show_logs() {
    cd "$SCRIPT_DIR"

    # Export environment variables
    # If running as root (ID 0), use 1000 as default instead
    if [ "$(id -u)" -eq 0 ]; then
        export USER_ID=${USER_ID:-1000}
        export GROUP_ID=${GROUP_ID:-1000}
    else
        export USER_ID=$(id -u)
        export GROUP_ID=$(id -g)
    fi

    # Set WORKSPACE_DIR if not already set (use current directory)
    if [ -z "$WORKSPACE_DIR" ]; then
        export WORKSPACE_DIR="$(pwd)"
    fi

    # Ensure variables are exported for docker-compose
    export USER_ID GROUP_ID WORKSPACE_DIR

    docker-compose logs -f
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
    start           Start Claude Code in Docker container (default)
    stop            Stop the Docker container
    build           Build the Docker image
    rebuild         Rebuild everything from scratch
    update          Rebuild image with latest versions (slow)
    update-claude   Update Claude Code without rebuild (fast)
    update-mcp      Update MCP servers without rebuild
    install-pkg     Install system packages without rebuild
    enter           Enter the running container with bash
    logs            Show container logs
    help            Show this help message

Options:
    --workspace DIR    Set workspace directory (default: current directory)

Environment Variables:
    WORKSPACE_DIR      Directory to mount as workspace

Examples:
    # Basic usage
    $0                          # Start Claude Code in current directory
    $0 start                    # Same as above
    $0 --workspace /path/to/project start

    # Container management
    $0 stop                     # Stop the container
    $0 enter                    # Enter the container with bash

    # Updates (fast - no rebuild)
    $0 update-claude            # Update Claude Code only
    $0 update-mcp               # Update MCP servers only
    $0 install-pkg htop ncdu    # Install additional packages

    # Full rebuild (slow - use only when needed)
    $0 rebuild                  # Rebuild everything from scratch
    $0 update                   # Rebuild with latest versions

Configuration:
    Edit .env file in $SCRIPT_DIR to configure:
    - ANTHROPIC_API_KEY (required)
    - MySQL settings (optional)
    - Upstash Redis settings (optional)
EOF
}

# Parse command line arguments
COMMAND="start"
INSTALL_PACKAGES=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --workspace)
            WORKSPACE_DIR="$2"
            shift 2
            ;;
        start|stop|build|rebuild|update|update-claude|update-mcp|enter|logs|help)
            COMMAND="$1"
            shift
            ;;
        install-pkg)
            COMMAND="install-pkg"
            shift
            # Collect all remaining arguments as packages
            while [[ $# -gt 0 ]]; do
                INSTALL_PACKAGES+=("$1")
                shift
            done
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
case $COMMAND in
    start)
        check_docker
        check_env_file

        # Check if image exists
        if ! docker images -q "$IMAGE_NAME" | grep -q .; then
            print_info "Image not found. Building..."
            build_image
        fi

        start_container
        ;;
    stop)
        check_docker
        stop_container
        ;;
    build)
        check_docker
        check_env_file
        build_image
        ;;
    rebuild)
        check_docker
        check_env_file
        rebuild
        ;;
    update)
        check_docker
        check_env_file
        update
        ;;
    update-claude)
        check_docker
        update_claude
        ;;
    update-mcp)
        check_docker
        update_mcp
        ;;
    install-pkg)
        check_docker
        install_packages "${INSTALL_PACKAGES[@]}"
        ;;
    enter)
        check_docker
        enter_container
        ;;
    logs)
        check_docker
        show_logs
        ;;
    help)
        show_usage
        ;;
    *)
        print_error "Unknown command: $COMMAND"
        show_usage
        exit 1
        ;;
esac
