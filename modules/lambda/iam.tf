resource "aws_iam_role" "iam_lambda_access_role" {
  name = local.lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = var.managed_policy_arns

  inline_policy {
    name   = local.inline_policy_name
    policy = data.template_file.iam-policy-template.rendered
  }

  depends_on = [data.template_file.iam-policy-template]
}

data "template_file" "iam-policy-template" {
  template = file(local.inline_policy_tpl_filename)

  vars = {
    aws_region    = var.aws_region
    account_id    = var.account_id
    stage         = var.stage
    function_name = local.function_name
  }
}
