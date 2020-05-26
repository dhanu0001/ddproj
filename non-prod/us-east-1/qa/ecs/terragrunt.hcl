locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env           = local.environment_vars.locals.environment
  owner         = local.account_vars.locals.owner
  instance_type = local.environment_vars.locals.instance_type
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:itmustbejj/terragrunt-ecs-modules.git//ecs?ref=master"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc-012341a0dd8b01234"
    vpc_subnets = [
      "subnet-003601fe683fd1111",
      "subnet-0f0787cffc6ae1112",
      "subnet-00e05034aa90b1112"
    ],
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  elb_port      = 80
  instance_type = "${local.instance_type}"
  asg_min_size  = 2
  asg_max_size  = 2
  name          = "app-${local.env}"
  server_port   = 8080
  tags = {
    Environment = "${local.env}"
    Owner       = "${local.owner}"
  }
  version     = "~> 1.0.9"
  vpc_id      = dependency.vpc.outputs.vpc_id
  vpc_subnets = dependency.vpc.outputs.private_subnets
}
