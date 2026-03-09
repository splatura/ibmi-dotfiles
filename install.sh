#!/usr/bin/env bash
#
# Convenience wrapper for script/bootstrap.
# Run this from anywhere to install ibmi-dotfiles.

if [ -z "$BASH_VERSION" ]; then
    echo "Error: ibmi-dotfiles requires bash. Please run this script with bash." >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/script/bootstrap" "$@"
