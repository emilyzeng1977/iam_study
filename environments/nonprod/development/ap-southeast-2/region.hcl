# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure things and pass forward to the child modules as inputs.
locals {
  aws_region = "ap-southeast-2"
  aws_azs    = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  azs        = local.aws_azs
  region     = local.aws_region
}
