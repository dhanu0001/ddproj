locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env            = local.environment_vars.locals.environment
  owner          = local.account_vars.locals.owner
  region         = local.region_vars.locals.region
  container_name = "nginx"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:itmustbejj/terragrunt-ecs-modules.git//modules/service?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  version = "~> 1.0.9"

  name           = "app-${local.env}"
  region         = "${local.region}"
  container_name = "${local.container_name}"
  container_port = "80"
  log_groups     = ["app-${local.env}-${local.container_name}"]
  tags = {
    Environment = "${local.env}"
    Owner       = "${local.owner}"
  }
}
