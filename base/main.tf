# Generate a random suffix only if needed
resource "random_pet" "suffix" {
  count = var.org_name == "" ? 1 : 0
}

# Use data block when org_name is set
data "tfe_organization" "default_org" {
  count = var.org_name != "" ? 1 : 0
  name  = var.org_name
}

# Create resource when org_name is empty
resource "tfe_organization" "new_org" {
  count = var.org_name == "" ? 1 : 0
  name  = "test-${random_pet.suffix[0].id}"
  email = var.org_email
}

locals {
  org_name = var.org_name == "" ? tfe_organization.new_org[0].name : data.tfe_organization.default_org[0].name
}

resource "tfe_workspace" "test" {
  name         = "test-workspace"
  organization = local.org_name
  tags         = {
    auto_destroy = "1d"
  }
  auto_destroy_activity_duration = "1d"
}