# Workspace: macOS DevOps & Efficiency

This workspace is dedicated to managing macOS system configurations, shell scripts, and overall development efficiency.

## Environment
- **Shell:** [Nushell](https://www.nushell.sh/) (`nu`)
- **Terminal:** [Ghosty](https://ghosty.org/)

## Core Mandates
- **macOS Native:** Prioritize built-in macOS tools (brew, defaults, osascript) and Nushell-native commands over external dependencies.
- **Safety First:** Before running commands that modify system settings or delete files, explain the impact and verify the target path.
- **Scripting Standards:** 
  - All shell scripts should prioritize Nushell (`.nu` files).
  - Use `#!/usr/bin/env nu` for script shebangs.
  - Prefer modular scripts over monolithic ones.
  - Include basic error handling and "dry-run" options where appropriate.
- **Organization:** Keep scripts in a `scripts/` directory and documentation in `docs/`.

## Workflow
- **Research:** Check existing system configurations using `defaults read` or checking specific config files.
- **Automation:** Look for opportunities to automate repetitive terminal tasks or system maintenance.
- **Validation:** Test scripts in a safe, isolated manner before applying them system-wide.
