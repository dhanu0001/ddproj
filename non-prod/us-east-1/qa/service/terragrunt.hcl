locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
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

  name = "app-${local.env}"
  container_name       = "nginx"
  container_port       = "80"
  log_groups           = ["app-dev-nginx"]
  tags                 = {
    Environment = "dev"
    Owner = "me"
  }
}
