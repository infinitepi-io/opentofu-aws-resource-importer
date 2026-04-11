# OpenTofu AWS Resource Importer

A powerful OpenCode skill and agent configuration for importing existing AWS resources into OpenTofu state with generated configuration.

## Features

- **Intelligent Import** — Uses AWS CLI to describe existing resources and generates proper OpenTofu configuration
- **Security Scanning** — Built-in Checkov and Trivy integration for scanning infrastructure
- **Best Practices** — Follows OpenTofu best practices for naming, block ordering, and module structure
- **Agent System** — Specialized agents for coding, security, and AWS command generation

## Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.9.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- [OpenCode](https://opencode.ai/) CLI
- [Docker](https://www.docker.com/) (for security scanning)

## Installation

Run this command from your project directory:

```bash
git clone https://github.com/infinitepi-io/opentofu-aws-resource-importer.git .opencode
```

This clones the repository and places the `.opencode` folder directly in your current project directory.

## Quick Start

1. **Start OpenCode:**
   ```bash
   opencode
   ```

2. **Run security scan:**
   ```bash
   > /security-scan
   ```

3. **Import AWS resources** — Ask OpenCode to help import your existing AWS resources

## Project Structure

```
.
├── .opencode/                 # OpenCode configuration
│   ├── agents/                # AI agent configurations
│   ├── commands/              # Custom commands
│   ├── skills/                # OpenTofu skill with best practices
│   │   └── opentofu-skills/
│   │       ├── SKILL.md       # Main skill file
│   │       └── scripts/       # Helper scripts
│   └── package.json           # OpenCode manifest
├── docs/                      # Documentation
└── LICENSE                    # Apache 2.0 License
```

## Configuration

### AWS Credentials

Ensure your AWS credentials are configured:

```bash
aws configure
```

Or set environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### OpenTofu Version

This project requires OpenTofu >= 1.9.0. Install via:

```bash
# macOS
brew install opentofu

# Linux
curl -LsSf https://get.opentofu.org/install.sh | sh
```

## Usage

### Using the Security Scan Command

```bash
opencode
> /security-scan
```

For strict mode (fails on issues):

```bash
opencode
> /security-scan --strict
```

### Importing AWS Resources

The import agent helps you bring existing AWS resources under OpenTofu management:

1. Start OpenCode in your project directory
2. Ask to import an AWS resource
3. Provide the resource ID or ARN
4. Review generated configuration
5. Run `tofu plan` to verify

## Documentation

- [Getting Started](docs/getting-started.md)
- [Configuration Guide](docs/configuration.md)
- [Import Examples](docs/import-examples.md)
- [Security Scanning](docs/security-scanning.md)

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting.

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.

## Credits

Inspired by [Anton Babenko&#39;s terraform-skill](https://github.com/antonbabenko/terraform-skill).
