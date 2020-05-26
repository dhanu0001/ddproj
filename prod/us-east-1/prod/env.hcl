# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "prod"
  # TODO: change to appropriate instance_type
  instance_type = "t2.micro"
}
