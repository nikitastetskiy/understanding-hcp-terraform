# Generate a random suffix only if needed
resource "random_pet" "suffix" {
  count = var.org_name == "" ? 1 : 0
}

# Use data block when org_name is set
data "tfe_organization" "defautl_org" {
  count = var.org_name != "" ? 1 : 0
  name  = var.org_name
}

# Create resource when org_name is empty
resource "tfe_organization" "new_org" {
  count = var.org_name == "" ? 1 : 0
  name  = "test-${random_pet.suffix[0].id}"
  email = var.org_email
}