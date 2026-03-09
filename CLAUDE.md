# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

IBM i Dotfiles — a personal dotfiles tool that copies shell configuration files into a user's home directory on IBM i (AS/400). It configures bash, vim, git, and related CLI tools for the IBM i PASE (QOpenSys) environment. Requires bash (enforced at install time and shell startup).

Users clone/copy this repo to their home directory (e.g., `~/.ibmi-dotfiles`) and run `install.sh`.

## Architecture

**Symlink convention:** Files ending in `.symlink` become dotfiles in `$HOME`. The bootstrap script strips the `.symlink` extension and prepends a dot (e.g., `system/aliases.symlink` → `~/.aliases`). Nested directories use the same convention (`dotfiles.symlink/` → `~/.dotfiles/`).

**Key components:**
- `install.sh` — Convenience wrapper that calls `script/bootstrap`.
- `script/bootstrap` — Main installer. Auto-detects its own location for DOTFILES_ROOT. Downloads git-completion and git-prompt from GitHub into `dotfiles.symlink/`, then copies all `*.symlink*` files to the install path (default `$HOME`). Special-cases `.gitconfig` to prompt for author name/email via `sed` substitution. Prefers `/QOpenSys/pkgs/bin/find` with fallback to `find`.
- `system/bashrc.symlink` — Central orchestrator. Sources dotfiles in order: vars/path → before_dotfiles → history → prompt → aliases/functions → after_dotfiles. Only sources interactive-shell files inside `case $- in *i*`.
- `system/bash_profile.symlink` — Login shell entry point with bash guard, sources `.bashrc`.
- `system/after_dotfiles.symlink` — Sources git-completion and git-prompt from `$HOME/.dotfiles/`.
- `ibmi-dotfiles.spec` — Legacy RPM spec file (kept for reference, no longer the primary distribution method).

**Shell sourcing order** (interactive login):
1. `.bash_profile` (bash guard) → `.bashrc`
2. `.vars`, `.path` (always)
3. `.before_dotfiles` → `.history` → `.prompt` → `.aliases`, `.functions` → `.after_dotfiles` (interactive only)

## Development Notes

- Target platform is IBM i PASE (`/QOpenSys`). Paths like `/QOpenSys/pkgs/bin/` are IBM i system paths.
- No build/test/lint commands — this is a collection of shell scripts and config files.
- `git/gitconfig.symlink` contains placeholder tokens `AUTHORNAME` and `AUTHOREMAIL` that get replaced by `sed` during installation.
- Version is tracked in `dotfiles.symlink/VERSION`.
- `git-completion.bash` and `git-prompt.sh` are downloaded at install time (not checked into the repo).
