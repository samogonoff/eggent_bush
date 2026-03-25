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

if command -v docker-compose &> /dev/null; then
    echo "Starting with docker-compose..."
    docker-compose up -d
elif command -v docker &> /dev/null; then
    echo "Starting with docker compose (V2)..."
    docker compose up -d
else
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

echo "Eggent Bush installed successfully!"
echo "Access at: http://localhost:3000"
