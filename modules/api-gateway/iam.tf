resource "aws_iam_role" "iam_execution_roles" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0
  name = format("%s-%s-ApigatewayTo%s", var.service, var.stage, var.iam_execution_roles[count.index])
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

  inline_policy {
    name   = format("ApigatewayTo%s", var.iam_execution_roles[count.index])
    policy = data.template_file.iam-policy-templates[count.index].rendered
  }
}

data "template_file" "iam-policy-templates" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0
  template = file(format("template/%s_policy.tpl", var.template_list[count.index]))
}
