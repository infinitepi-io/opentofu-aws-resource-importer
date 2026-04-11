# Import Examples

## How Resource Import Works

1. You provide the AWS resource ID (e.g., `vpc-0123456789abcdef0`)
2. The agent uses AWS CLI to describe the resource
3. OpenTofu configuration is generated based on the resource attributes
4. Review the generated configuration
5. Run `tofu plan` to verify

## Common Import Patterns

### VPC Import

```
Resource ID: vpc-0123456789abcdef0
Import Command: tofu import aws_vpc.this vpc-0123456789abcdef0
```

### Security Group Import

```
Resource ID: sg-0123456789abcdef0
Import Command: tofu import aws_security_group.this sg-0123456789abcdef0
```

### RDS Instance Import

```
Resource ID: db-0123456789abcdef0
Import Command: tofu import aws_db_instance.this db-0123456789abcdef0
```

## Best Practices

1. Always review generated configuration before applying
2. Use descriptive resource names (e.g., `aws_vpc.production` not `aws_vpc.this`)
3. Add appropriate tags to imported resources
4. Consider using `moved` blocks for refactoring existing resources

## Notes

The import agent assists with generating configuration but actual import commands should be run manually to avoid unintended changes.
