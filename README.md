# Opella DevOps Technical Challenge

Reusable Terraform module for Azure Virtual Network + multi-environment deployment.

## Architecture

- **Reusable Module**: `modules/vnet/` (VNet + subnets + optional NSG)
- **Environments**:
  - **Dev** → `eastus`
  - **Prod** → `westus` (Microsoft paired region)
- **Resources per environment**:
  - Resource Group (with consistent tags)
  - Virtual Network + Subnets + NSG (via reusable module)
  - Windows Virtual Machine (`Standard_DC1s_v3`)
  - Storage Account (Blob) + Private Endpoint
- **Naming**: Microsoft Cloud Adoption Framework (CAF) standards
- **Tagging**: Applied at Resource Group level (`Environment`, `ManagedBy`, `Project`, `Region`)

## Clean Code & Quality Process

- `terraform fmt` — consistent formatting
- `tflint` — linting and best practices
- `trivy` — security and misconfiguration scanning
- `terraform-docs` — auto-generated module documentation

## Deployment

- GitHub Actions CI/CD pipeline with Azure OIDC
- Automatic deployment to Dev
- Manual approval required for Prod (proper release lifecycle)

## Deliverables

- [terraform-plan-dev.txt](./terraform-plan-dev.txt)
- [terraform-plan-prod.txt](./terraform-plan-prod.txt)
- Full pipeline: `.github/workflows/terraform-ci-cd.yml`

## Module Documentation

See `modules/vnet/README.md` (generated with `terraform-docs`).

---