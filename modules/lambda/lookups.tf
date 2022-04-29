data "aws_ssm_parameter" "honeycomb_api_key" {
  name = "honeycomb_api_key"
}

data "aws_s3_bucket" "bucket_for_lambda" {
  bucket = local.bucket_name
}
