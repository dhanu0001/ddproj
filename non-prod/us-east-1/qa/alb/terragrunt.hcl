locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
  domain_name     = local.account_vars.locals.domain_name
  certificate_arn = local.account_vars.locals.certificate_arn
  owner           = local.account_vars.locals.owner
  instance_type   = local.environment_vars.locals.instance_type
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:itmustbejj/terragrunt-infrastructure-modules-example.git//modules/alb?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  version = "~> 1.0.9"

  name               = "app-${local.env}"
  host_name          = "app-${local.env}"
  domain_name        = "${local.domain_name}"
  certificate_arn    = "${local.certificate_arn}"

  tags               = {
    Environment = "${local.env}"
    Owner = "${local.owner}"
  }

  instance_type = "${local.instance_type}"

  min_size = 2
  max_size = 2

  server_port = 8080
  elb_port    = 80
}
