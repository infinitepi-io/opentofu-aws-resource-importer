# Security Policy

## Reporting Vulnerabilities

If you discover a security vulnerability within this project, please report it responsibly.

### How to Report

1. **Do not** create a public GitHub issue for security vulnerabilities
2. Email the maintainers directly or use private vulnerability reporting
3. Include as much detail as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- Acknowledgment of your report within 48 hours
- Regular updates on the progress
- Credit for the discovery (unless you prefer anonymity)

## Security Best Practices

When using this project:

1. Never commit AWS credentials to version control
2. Use AWS Secrets Manager or Parameter Store for sensitive data
3. Run security scans before deploying infrastructure
4. Review generated configuration carefully
5. Use strict mode in CI/CD pipelines
