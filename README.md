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
  - Windows Virtual Machine
  - Storage Account (Blob) + Private Endpoint
- **Naming**: Microsoft Cloud Adoption Framework (CAF) standards
- **Tagging**: Applied only at Resource Group level (`Environment`, `ManagedBy`, `Project`, `Region`)

## Clean Code & Quality Process

The following tools are automatically enforced in the CI pipeline:
- `terraform fmt` — validate code formatting
- `tflint` — linting and best practices
- `trivy` — security and misconfiguration scanning
- `terraform-docs` — auto-generated module documentation

## CI/CD Pipelines

- **Separate CI and CD pipelines** (industry best practice)
  - **`terraform-ci.yml`** → Runs on every push:
    - Quality checks (`fmt`, `tflint`, `trivy`, `terraform-docs`)
    - Terraform Plan for Dev and Prod
    - Auto-generates and commits `terraform-plan-dev.txt` and `terraform-plan-prod.txt`
  - **`terraform-cd.yml`** → Manual deployment:
    - Apply to Dev
    - Apply to Prod (with manual approval gate)

- Both pipelines use **Azure OIDC** for secure authentication (no secrets stored in GitHub).

## Deliverables

- [terraform-plan-dev.txt](./terraform-plan-dev.txt) *(auto-updated by CI)*
- [terraform-plan-prod.txt](./terraform-plan-prod.txt) *(auto-updated by CI)*
- CI Pipeline: `.github/workflows/terraform-ci.yml`
- CD Pipeline: `.github/workflows/terraform-cd.yml`

## Module Documentation

See `modules/vnet/README.md` (auto-generated with `terraform-docs`).

---