# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "staging"
  aws_account_id = "CHANGEME"
  aws_profile    = "staging"
  domain_name    = "foo.io"
  certificate_arn = "arn:aws:acm:us-west-2:CHANGEME:certificate/CHANGEME"
  owner = "jhud"
}
