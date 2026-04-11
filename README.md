# Opella DevOps Technical Challenge

Reusable Terraform module for Azure VNet + multi-environment deployment (dev + prod).

## Resources Created (per environment)
- Resource Group
- VNet + 2 subnets + NSG (via reusable module)
- Windows VM (`Standard_B1s`) with random password
- Storage Account (with Blob) + Private Endpoint (attached to VNet)

## Regions Used
- **dev** → `eastus`
- **prod** → `westus` (Microsoft’s official paired region for eastus)

## Why Resource Groups per environment?
Clear isolation, cost tracking, and safe deletion. In real production we would use separate subscriptions + Azure Policy.

## Security & Best Practices
- NSG allows only RDP (3389)
- Storage Account is private (`public_network_access_enabled = false`) + Private Endpoint only
- VM password generated with `random_password` (never committed to Git)
- All resources tagged consistently with Environment + Region
- Private endpoint subnet secured

## Clean Code & Quality Process
To maintain high code quality, consistency, and security, the following tools are used:

- `terraform fmt` — Ensures consistent code formatting
- `tflint` — Linting and Terraform best practices validation
- `trivy` — Security and misconfiguration scanning
- `terraform-docs` — Auto-generated module documentation

## Terraform Plans
- [terraform-plan-dev.txt](./terraform-plan-dev.txt)
- [terraform-plan-prod.txt](./terraform-plan-prod.txt)

## GitHub Pipeline
See `.github/workflows/terraform-ci-cd.yml` (matrix strategy + OIDC + manual approval for prod).