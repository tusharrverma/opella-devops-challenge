# Opella DevOps Technical Challenge

Reusable Terraform module for Azure Virtual Network + multi-environment deployment.

## Architecture

- **Reusable Module**: `modules/vnet/` — provisions VNet, subnets, and optional NSG
- **Environments**:
  - **Dev** → `eastus`
  - **Prod** → `westus` (Microsoft paired region)
- **Resources per environment**:
  - Resource Group
  - Virtual Network + Subnets + NSG (via reusable module)
  - Windows Virtual Machine (`Standard_DC1s_v3`)
  - Storage Account (with Blob) + Private Endpoint (attached to VNet)
- **Naming**: Microsoft Cloud Adoption Framework (CAF) standards
- **Tagging**: Consistent tags applied at Resource Group level (`Environment`, `ManagedBy`, `Project`, `Region`)

## Clean Code & Quality Process

- `terraform fmt` — code formatting
- `tflint` — linting and best practices
- `trivy` — security & misconfiguration scanning
- `terraform-docs` — auto-generated module documentation

## Deployment

- GitHub Actions CI/CD pipeline with Azure OIDC authentication
- Automatic deployment to Dev
- Manual approval required for Prod
- Plan artifacts are uploaded for easy review

## Deliverables

- [terraform-plan-dev.txt](./terraform-plan-dev.txt)
- [terraform-plan-prod.txt](./terraform-plan-prod.txt)
- Full GitHub Actions workflow: `.github/workflows/terraform-ci-cd.yml`

## How to use the VNet Module

See `modules/vnet/README.md` (auto-generated).

## Notes

- All resources are free-tier friendly.
- VM computer name is kept under 15 characters as per Azure limits.
- In a real production environment, I would replace public IP with Azure Bastion, enable infrastructure encryption on Storage, and restrict NSG rules further.

---