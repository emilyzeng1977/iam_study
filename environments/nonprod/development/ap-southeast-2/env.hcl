# We need to copy the content of env/dev.env to here

locals {
  SERVICE = "iam"
  SLS_STAGE = "dev-tf"
  VPC_SECURITY_GROUP_ID = "sg-0c4750fe8e5f46316"
  VPC_SUBNET_ID = "subnet-08b549dfd3edf008b"
}
