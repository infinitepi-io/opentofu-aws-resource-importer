# Security Scanning

## Overview

Security scanning is performed using:

- **Trivy** - Scans for infrastructure misconfigurations
- **Checkov** - Policy-as-code scanner for AWS, Azure, GCP, Kubernetes

## Running Scans

### Using the Command

```bash
opencode
> /security-scan
```

### Strict Mode

In strict mode, the scan will exit with code 1 if any security issues are found:

```bash
> /security-scan --strict
```

This is recommended for CI/CD pipelines.

### Manual Execution

You can also run the script directly:

```bash
chmod +x .opencode/skills/opentofu-skills/scripts/security-scan.sh
./.opencode/skills/opentofu-skills/scripts/security-scan.sh
```

## What Gets Scanned

- Security groups with open ports (0.0.0.0/0)
- S3 buckets without encryption
- Missing IAM password policies
- RDS instances without encryption
- And many more...

## Using Docker

The script runs security tools in Docker containers. Ensure Docker is running before executing scans.
