---
name: opentofu-skills
description: Use when working with OpenTofu — writing configurations, creating reusable modules, implementing tests (native framework or mocks), setting up CI/CD pipelines, reviewing or refactoring existing code, debugging state issues, or making infrastructure-as-code architecture decisions
metadata:
  author: Satish Tripathi
  version: 1.0.0
  opentofu_version: ">= 1.9.0"
  credits: Inspired by [Anton Babenko's terraform-skill](https://github.com/antonbabenko/terraform-skill)
---
# OpenTofu Skill

## When to Use

**Activate for:**

- Creating OpenTofu configurations or modules
- Setting up testing infrastructure for IaC
- Choosing testing approaches (validate, plan, native test framework)
- Structuring multi-environment deployments or CI/CD
- Reviewing or refactoring existing projects

## Core Principles

### Directory Structure

```
environments/     # Environment-specific (prod/, staging/, dev/)
modules/          # Reusable components (networking/, compute/, data/)
examples/         # Module usage examples (also serve as tests)
```

**Key rules:**

- Separate environments from modules
- Use `examples/` as documentation + integration tests
- Keep modules small and focused (single responsibility)

### Module Hierarchy

| Type                            | Scope                                     | Example                                      |
| ------------------------------- | ----------------------------------------- | -------------------------------------------- |
| **Resource**              | Single resource with minimal dependencies | `aws_s3_bucket` with encryption            |
| **Resource Module**       | Group of related resources                | VPC with subnets, NAT gateways, route tables |
| **Infrastructure Module** | Multiple resource modules for a service   | EKS cluster + node groups + addons           |
| **Composition**           | Full environment across accounts/regions  | Production multi-region setup                |

**When to use each:**

- **Resource** — Most configurations; small, focused components
- **Resource Module** — Reusable patterns (network VPC, security groups)
- **Infrastructure Module** — Service-level stacks (complete EKS, RDS)
- **Composition** — Environment-level (entire prod account)

### Naming Conventions

**Resources:**

```hcl
# Good: Descriptive, contextual
resource "aws_instance" "web_server" { }
resource "aws_s3_bucket" "application_logs" { }

# Good: "this" for singleton resources (only one of that type)
resource "aws_vpc" "this" { }

# Avoid: Generic names for non-singletons
resource "aws_instance" "main" { }
resource "aws_s3_bucket" "bucket" { }
```

**Variables:** Prefix with context when needed (`var.vpc_cidr_block`, not `var.cidr`)

**Files:** `main.tf` (resources), `variables.tf`, `outputs.tf`, `versions.tf`, `data.tf`

### Testing Decision Matrix

| Situation               | Approach              | Tools                                            |
| ----------------------- | --------------------- | ------------------------------------------------ |
| Quick syntax check      | Static analysis       | `tofu validate`, `fmt`                       |
| Pre-commit validation   | Static + lint         | `validate`, `tflint`, `trivy`, `checkov` |
| Standard validation     | Native test framework | Built-in `tofu test`                           |
| Security/compliance     | Policy as code        | OPA, Sentinel                                    |
| Cost-sensitive workflow | Mock providers        | Native tests + mocking                           |

**Testing Pyramid:** Static analysis (cheap) → Integration tests (moderate) → End-to-end (expensive)

### Resource Block Ordering

1. `count` or `for_each` FIRST (blank line after)
2. Other arguments
3. `tags` as last real argument
4. `depends_on` after tags (if needed)
5. `lifecycle` at the very end (if needed)

```hcl
resource "aws_nat_gateway" "this" {
  count = var.create_nat_gateway ? 1 : 0

  allocation_id = aws_eip.this[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = { Name = "${var.name}-nat" }

  depends_on = [aws_internet_gateway.this]

  lifecycle { create_before_destroy = true }
}
```

### Variable Block Ordering

1. `description` (ALWAYS required)
2. `type`
3. `default`
4. `validation`
5. `nullable` (when setting to false)

```hcl
variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }

  nullable = false
}
```

### Count vs For_Each

| Scenario                            | Use                           | Why                                 |
| ----------------------------------- | ----------------------------- | ----------------------------------- |
| Boolean condition (create or don't) | `count = condition ? 1 : 0` | Simple on/off toggle                |
| Simple numeric replication          | `count = 3`                 | Fixed number of identical resources |
| Items may be reordered/removed      | `for_each = toset(list)`    | Stable resource addresses           |
| Reference by key                    | `for_each = map`            | Named access to resources           |

```hcl
# ✅ GOOD - Stable addressing
resource "aws_subnet" "private" {
  for_each = toset(var.availability_zones)
  availability_zone = each.key
}

# ❌ BAD - Removing middle AZ recreates all subsequent
resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  availability_zone = var.availability_zones[count.index]
}
```

### Locals for Dependency Management

Use `try()` in locals to hint deletion order and prevent errors when destroying infrastructure:

```hcl
locals {
  vpc_id = try(
    aws_vpc_ipv4_cidr_block_association.this[0].vpc_id,
    aws_vpc.this.id,
    ""
  )
}

resource "aws_subnet" "public" {
  vpc_id = local.vpc_id  # Use local, not direct reference
}
```

### Module Structure

```
my-module/
├── main.tf          # Primary resources
├── variables.tf     # Input variables with descriptions
├── outputs.tf       # Output values
├── versions.tf      # Provider version constraints
├── examples/
│   ├── minimal/
│   └── complete/
└── tests/           # Test files (.tftest.hcl or .go)
```

**Variables:** Always `description`, explicit `type`, `default` where appropriate, `validation` for complex constraints, `sensitive = true` for secrets.

**Outputs:** Always `description`, `sensitive = true` for secrets, consider returning objects.

### Version Strategy

| Component      | Strategy    | Example                         |
| -------------- | ----------- | ------------------------------- |
| OpenTofu       | Pin minor   | `required_version = "~> 1.9"` |
| Providers      | Pin major   | `version = "~> 5.0"`          |
| Modules (prod) | Pin exact   | `version = "5.1.2"`           |
| Modules (dev)  | Allow patch | `version = "~> 5.1"`          |

### CI/CD Workflow

1. **Validate** - Format check + syntax validation + linting
2. **Test** - Run automated tests (native or mocks)
3. **Plan** - Generate and review execution plan
4. **Apply** - Execute changes (with approvals for production)

**Cost optimization:** Use mocking for PR validation, run integration tests only on main branch, implement auto-cleanup, tag all test resources.

### Security Essentials

**Run security scans:** 
```bash
./scripts/security-scan.sh [--strict]
```
Or use the OpenCode command: `/security-scan [--strict]`

❌ **Don't:**

- Store secrets in variables
- Use default VPC
- Skip encryption
- Open security groups to 0.0.0.0/0
- Use inline `ingress`/`egress` blocks in `aws_security_group`

✅ **Do:**

- Use AWS Secrets Manager / Parameter Store
- Create dedicated VPCs
- Enable encryption at rest
- Use least-privilege security groups
- Use separate `aws_vpc_security_group_ingress_rule` / `aws_vpc_security_group_egress_rule` resources (or `aws_security_group_rule`)

### Key Features (1.9+)

```hcl
# try() - Safe fallbacks
output "sg_id" {
  value = try(aws_security_group.this[0].id, "")
}

# optional() - Optional attributes with defaults
variable "config" {
  type = object({
    name    = string
    timeout = optional(number, 300)
  })
}

# Cross-variable validation
variable "backup_days" {
  type = number
  validation {
    condition     = var.environment == "prod" ? var.backup_days >= 7 : true
    error_message = "Production requires backup_days >= 7"
  }
}

# Write-only arguments (secrets never stored in state)
resource "aws_secretsmanager_secret" "this" {
  name = "my-secret"
  recovery_window_in_days = 0
}
```
