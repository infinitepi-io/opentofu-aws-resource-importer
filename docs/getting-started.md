# Getting Started

## Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.9.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- [OpenCode](https://opencode.ai/) CLI
- [Docker](https://www.docker.com/) (for security scanning)

## Installation

```bash
git clone https://github.com/infinitepi-io/opentofu-aws-resource-importer.git ~/.opencode/skills/opentofu-aws-resource-importer
```

## AWS Credentials

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

## OpenTofu Version

This project requires OpenTofu >= 1.9.0. Install via:

```bash
# macOS
brew install opentofu

# Linux
curl -LsSf https://get.opentofu.org/install.sh | sh
```

## Next Steps

- [Configuration Guide](configuration.md) - Customize for your needs
- [Import Examples](import-examples.md) - Learn how to import AWS resources
- [Security Scanning](security-scanning.md) - Scan your infrastructure
