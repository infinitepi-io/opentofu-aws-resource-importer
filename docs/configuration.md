# Configuration Guide

## OpenCode Configuration

The `.opencode/` folder contains all configurations for OpenCode agents and skills.

### Agents

The project includes specialized agents:

- **opentofu-coding** - Writes and refactors OpenTofu configurations
- **opentofu-security** - Reviews configurations for security issues
- **opentofu-dispatcher** - Routes requests to appropriate agents
- **aws-command-generator** - Generates AWS CLI commands for resource inspection

### Commands

- `/security-scan` - Run security scanning with Checkov and Trivy

Usage:
```bash
> /security-scan        # Advisory mode - show issues only
> /security-scan --strict  # Fail on any issues found
```

### Skills

The `opentofu-skills` directory contains the main skill file with OpenTofu best practices including:

- Naming conventions
- Resource block ordering
- Testing strategies
- Security guidelines
- Version management

## Customization

Edit files in `.opencode/` to customize agent behavior and skill rules.
