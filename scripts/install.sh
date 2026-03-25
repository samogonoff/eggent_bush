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

echo "DOCKER_DIR: $DOCKER_DIR"
echo "Looking for .env.example in $DOCKER_DIR..."
ls -la "$DOCKER_DIR/" | head -10

if [ -f "$DOCKER_DIR/.env.example" ] && [ ! -f "$DOCKER_DIR/.env" ]; then
    echo "Creating .env from .env.example..."
    cp "$DOCKER_DIR/.env.example" "$DOCKER_DIR/.env"
fi

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
echo "Version: 1.0.1"
