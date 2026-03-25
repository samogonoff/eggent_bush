#!/bin/bash
set -e

REPO="https://github.com/samogonoff/eggent_bush.git"
BRANCH="${EGGENT_BRANCH:-main}"
INSTALL_DIR="${EGGENT_DIR:-$HOME/eggent_bush}"
GITHUB_TOKEN="${EGENT_TOKEN:-}"

echo "Installing Eggent Bush..."

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR" && git pull origin "$BRANCH"
else
    echo "Cloning repository to $INSTALL_DIR..."
    if [ -n "$GITHUB_TOKEN" ]; then
        REPO_URL="https://${GITHUB_TOKEN}@github.com/samogonoff/eggent_bush.git"
        git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
    else
        git clone -b "$BRANCH" "$REPO" "$INSTALL_DIR"
    fi
fi

cd "$INSTALL_DIR"

DOCKER_DIR="$INSTALL_DIR"
if [ -d "$INSTALL_DIR/eggent" ]; then
    DOCKER_DIR="$INSTALL_DIR/eggent"
fi

if ! command -v ollama &> /dev/null; then
    echo "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

if [ -f "$DOCKER_DIR/.env.example" ]; then
    if [ ! -f "$DOCKER_DIR/.env" ]; then
        echo "Copying .env.example to .env ..."
        cp "$DOCKER_DIR/.env.example" "$DOCKER_DIR/.env"
    else
        echo ".env already exists"
    fi
else
    echo "WARNING: .env.example not found"
fi

if [ -d "$DOCKER_DIR/data" ]; then
    chmod -R 777 "$DOCKER_DIR/data"
else
    mkdir -p "$DOCKER_DIR/data"
    chmod -R 777 "$DOCKER_DIR/data"
fi

ls -la "$DOCKER_DIR"/.env* 2>/dev/null

if [ -f "$DOCKER_DIR/docker-compose.yml" ]; then
    if command -v docker-compose &> /dev/null; then
        echo "Starting with docker-compose..."
        cd "$DOCKER_DIR" && docker-compose up -d
    elif command -v docker &> /dev/null; then
        echo "Starting with docker compose (V2)..."
        cd "$DOCKER_DIR" && docker compose up -d
    else
        echo "Docker is not installed. Please install Docker first."
        exit 1
    fi
else
    echo "docker-compose.yml not found in $DOCKER_DIR"
fi

echo "Eggent Bush installed successfully!"
echo "Access at: http://localhost:3000"
