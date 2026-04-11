# Security Scan Command

Run security scan using Checkov on OpenTofu files.

## Usage

```
/security-scan [--strict]
```

## Options

- `--strict` - Exit with code 1 if any security issues are found

## Description

Runs Checkov security scanner on the infrastructure codebase to detect:

- Secrets stored in configuration files
- Security misconfigurations
- Compliance violations

## Execution

Execute directly without prompting.

## Output

Report all scan results to the user including:

- Passed/Failed/Skipped check counts
- Failed check details (file, resource, rule name)
- Any recommendations or next steps

## Example

```
/security-scan
/security-scan --strict
```

## Notes

- Trivy is commented out because it doesn't support `.tofu` files
- Checkov properly supports OpenTofu/Terraform scanning
